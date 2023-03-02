module token

pub const registers = [
	'RAX',
	'RCX',
	'RDX',
	'RBX',
	'RSP',
	'RBP',
	'RSI',
	'RDI',
	'RIP',

	'EAX',
	'ECX',
	'EDX',
	'EBX',
	'ESP',
	'EBP',
	'ESI',
	'EDI',
]

pub struct Position {
pub mut:
	file_name string
	line      int
	col       int
	len       int
}

pub enum TokenKind {
	ident
	number
	string
	comma
	colon
	lpar
	rpar
	plus
	minus
	percent
	dolor
	eol // enf of line
	eof // end of file
}

pub struct Token {
pub:
	kind TokenKind
	pos  Position
	lit  string
}

