module error

import os
import token

fn print_space(n int) {
	for _ in 0 .. n {
		eprint(' ')
	}
}

pub fn print(pos token.Position, msg string) {
	program := os.read_file(pos.file_name) or {
		eprintln('error: reading file `$pos.file_name`')
		exit(1)
	}

	program_in_lines := program.split('\n')

	code := program_in_lines[pos.line-1]

	eprintln('\u001b[1m$pos.file_name:$pos.line:$pos.col: \x1b[91merror\x1b[0m\u001b[1m: $msg \033[0m')

	print_space(pos.line.str().len + 2)
	eprintln('|')

	eprintln(' $pos.line | $code')

	print_space(pos.line.str().len + 2)
	eprint('|')

	print_space(pos.col + 1)

	for _ in 0 .. pos.len {
		eprint('\u001b[1m\x1b[91m~\033[0m')
	}
	eprintln('')
}

