module main

import os
import flag
import lexer
import encoder
import elf

fn file_name_without_ext(file_name string) string {
	ext_len := os.file_ext(file_name).len
	bytes := file_name.bytes()
	return if file_name == '-' {
		'main'
	} else {
		bytes[..bytes.len - ext_len].bytestr()
	}
}

fn main() {
	mut fp := flag.new_flag_parser(os.args)
    fp.application('vas')
    fp.version('v0.0.0')
    fp.skip_executable()
    mut out_file := fp.string('o', `o`, 'out_file_none', 'set output file name')

    additional_args := fp.finalize() or {
        println(fp.usage())
        return
    }

	if additional_args.len < 1 {
		println(fp.usage())
        return
	}

	file_name := additional_args[0]

	if out_file == 'out_file_none' {
		out_file = file_name_without_ext(file_name) + '.o'
	}

	program := if file_name == '-' {
		os.get_raw_lines_joined()
	} else {
		os.read_file(file_name) or {
			eprintln('error: reading file `${file_name}`')
			exit(1)
		}
	}

	mut l := lexer.new(file_name, program)

	mut en := encoder.new(mut l, file_name)
	en.encode()
	if en.variable_instrs.len != 0 {
		en.add_index_to_instrs()
		en.resolve_variable_length_instrs(mut en.variable_instrs)
	}
	en.assign_addresses()
	en.fix_same_section_relocations()
	en.count_local_labels()

	mut e := elf.new(out_file, en.sections, en.defined_symbols, en.globals_count, en.local_labels_count)
	e.elf_symtab_strtab(en.rela_text_users)
	e.build_shstrtab()
	e.build_headers()
	e.write_elf()
}

