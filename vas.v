// I know the code is messy, but it gets the job done for now.
// Leaving this comment here to remind myself to refactor it from scratch
// when I have more time. 

module main

import os
import flag
import encoder
import elf

fn file_name_without_ext(file_name string) string {
	ext_len := os.file_ext(file_name).len
	bytes := file_name.bytes()
	return bytes[..bytes.len - ext_len].bytestr()
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

	program := os.read_file(file_name) or {
		eprintln('error: reading file `${file_name}`')
		exit(1)
	}

	mut en := encoder.new(program, file_name)
	en.encode()
	en.add_index_to_instrs()
	en.resolve_variable_length_instrs(mut en.variable_instrs)
	en.assign_addresses()
	en.resolve_call_targets()

	mut e := elf.new(out_file, en.sections, en.defined_symbols, en.globals_count)
	e.rela_text_users(en.rela_text_users)
	e.elf_symtab_strtab()
	e.build_shstrtab()
	e.build_headers()
	e.write_elf()
}

