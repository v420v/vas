module main

import os
import lexer
import parser
import gen

fn file_name_without_ext(file_name string) string {
	ext_len := os.file_ext(file_name).len
	bytes := file_name.bytes()
	return bytes[..bytes.len - ext_len].bytestr()
}

const help = 'Usage:
	vas <filename>.s'

fn main() {
	if os.args.len < 2 {
		eprintln(help)
		exit(1)
	}

	file_name := os.args[1]

	out_file := file_name_without_ext(file_name) + '.o'

	program := os.read_file(file_name) or {
		eprintln('error: reading file `${file_name}`')
		exit(1)
	}

	mut l := lexer.new(file_name, program)
	tokens := l.lex()

	mut p := parser.new(tokens)
	mut instrs := p.parse()

	mut g := gen.new(out_file)
	g.encode(mut instrs)

	g.write_code(instrs)
	g.gen_elf()
}

