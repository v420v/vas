module error

import token

pub fn print(pos token.Position, msg string) {
	err := '\u001b[1m$pos.file_name:$pos.line: \x1b[91merror\x1b[0m\u001b[1m: $msg \033[0m'
	eprintln(err)
}

