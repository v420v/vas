module error

import os
import token

pub struct Vas_Error {
	pub mut:
		pos token.Position
		msg string
}

pub fn new_error(pos token.Position, msg string) Vas_Error {
	return Vas_Error {
		pos: pos,
		msg: msg,
	}
}

fn print_space(n int) {
	for _ in 0 .. n {
		eprint(' ')
	}
}

pub fn print(e Vas_Error) {
	program := os.read_file(e.pos.file_name) or {
		eprintln('error: reading file `$e.pos.file_name`')
		exit(1)
	}

	program_in_lines := program.split('\n')

	code := program_in_lines[e.pos.line-1]

	eprintln('\u001b[1m$e.pos.file_name:$e.pos.line:$e.pos.col: \x1b[91merror\x1b[0m\u001b[1m: $e.msg \033[0m')

	print_space(e.pos.line.str().len + 2)
	eprintln('|')

	eprintln(' $e.pos.line | $code')

	print_space(e.pos.line.str().len + 2)
	eprint('|')

	print_space(e.pos.col + 1)

	for _ in 0 .. e.pos.len {
		eprint('\u001b[1m\x1b[91m~\033[0m')
	}
	eprintln('')
}

