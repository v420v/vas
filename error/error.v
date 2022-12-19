module error

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

pub fn print_error(e Vas_Error, code string) {
	eprintln('\u001b[1m$e.pos.file_name:$e.pos.line:$e.pos.col: \x1b[91merror\x1b[0m\u001b[1m: $e.msg \033[0m')

	eprintln(' $e.pos.line | $code')

	for _ in 0 .. e.pos.col + 4 + e.pos.line.str().len {
		eprint(' ')
	}

	for _ in 0 .. e.pos.len {
		eprint('\u001b[1m\x1b[91m~\033[0m')
	}

	eprintln('')
}

pub fn print_all(errors []Vas_Error, program string) {
	if errors.len != 0 {
		program_in_lines := program.split('\n')

		for e in errors {
			code := program_in_lines[e.pos.line-1]
			print_error(e, code)
		}

		exit(1)
	}
}

