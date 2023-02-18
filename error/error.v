module error

import os
import token

fn space(n int) string {
	mut space := ''
	for _ in 0 .. n {
		space += ' '
	}
	return space
}

pub fn print(pos token.Position, msg string) {
	program := os.read_file(pos.file_name) or {
		panic('error: something whent wrong while reading file `$pos.file_name`')
	}

	program_in_lines := program.split('\n')

	code := program_in_lines[pos.line-1]

	mut err := '\u001b[1m$pos.file_name:$pos.line:$pos.col: \x1b[91merror\x1b[0m\u001b[1m: $msg \033[0m\n' +
			space(pos.line.str().len + 2) + '|\n' +
			' $pos.line | $code\n' +
			space(pos.line.str().len + 2) + '|' +
			space(pos.col + 1)

	for _ in 0 .. pos.len {
		err += '\u001b[1m\x1b[91m~\033[0m'
	}

	eprintln(err)
}

