module token

pub const registers = [
	// 64bit
	'RAX',
	'RCX',
	'RDX',
	'RBX',
	'RSP',
	'RBP',
	'RSI',
	'RDI',
	'RIP',

	// 32bit
	'EAX',
	'ECX',
	'EDX',
	'EBX',
	'ESP',
	'EBP',
	'ESI',
	'EDI',
	'EIP',

	// 16bit
	'AX',
	'CX',
	'DX',
	'BX',
	'SP',
	'BP',
	'SI',
	'DI',
	'IP',

	// 8bit
	'AL',
	'CL',
	'DL',
	'BL',
	'AH',
	'CH',
	'DH',
	'BH',
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
	mul
	div
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

