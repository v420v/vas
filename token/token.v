module token

pub struct Position {
pub mut:
	file_name string
	line      int
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

