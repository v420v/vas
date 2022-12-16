module main

import os

import error
import lexer
import parser
import gen

fn file_name_without_ext(file_name string) string {
	ext_len := os.file_ext(file_name).len
	str_u8_arr := file_name.bytes()
	return str_u8_arr[.. str_u8_arr.len - ext_len].bytestr()
}

fn main() {
	if os.args.len < 2 {
		eprintln('Usage:\n\tvas <filename>.s')
		exit(1)
	}

	file_name := os.args[1]

	out_file := file_name_without_ext(file_name) + '.o'

	program := os.read_file(file_name) or {
		eprintln('error: reading file `$file_name`')
		exit(1)
	}

	mut l := lexer.new(file_name, program)

	tokens := l.lex()

	error.print_all(l.errors, program)

	mut p := parser.new(tokens)

	ops := p.parse()

	error.print_all(p.errors, program)

	mut g := gen.new(out_file)

	g.gen(ops)?

	error.print_all(g.errors, program)

	g.gen_elf()
}

