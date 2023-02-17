module token

pub const registers = [
	'EAX',
	'RAX',
	'ECX',
	'RCX',
	'EDX',
	'RDX',
	'EBX',
	'RBX',
	'ESP',
	'RSP',
	'EBP',
	'RBP',
	'ESI',
	'RSI',
	'EDI',
	'RDI',
	'RIP',
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

pub fn token_kind_str(kind TokenKind) string {
	match kind {
		.ident {
			return '<ident>'
		}
		.number {
			return '<number>'
		}
		.string {
			return '<string>'
		}
		.comma {
			return ','
		}
		.colon {
			return ':'
		}
		.lpar {
			return '('
		}
		.rpar {
			return ')'
		}
		.percent {
			return '%'
		}
		.dolor {
			return '$'
		}
		.eol {
			return '<EOL>'
		}
		.eof {
			return '<EOF>'
		}
	}
}


