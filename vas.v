module main

import os
import flag
import parser
import gen

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

	mut p := parser.new(program, file_name)
	mut g := gen.new(out_file)

	mut instrs, defined_symbols, call_targets := p.parse()

	g.symbols = defined_symbols

	g.assign_instruction_addresses(mut instrs)

	g.resolve_call_targets(call_targets)

	g.handle_undefined_symbols(call_targets)

	padding := (gen.align_to(g.code.len, 32) - g.code.len)
	for _ in 0 .. padding {
		g.code << 0
	}

	g.gen_elf()
}

