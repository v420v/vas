module token

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
	comma
	colon
	eol // enf of line
	eof // end of file
}

pub struct Token {
	pub:
		kind TokenKind
		pos  Position
		lit string
}
/*
pub const tokens_str = {
	TokenKind.number: '<number>'
	TokenKind.ident: '<ident>'
	TokenKind.comma: ','
	TokenKind.colon: ':'
	TokenKind.eol: '<EOL>'
	TokenKind.eof: '<EOF>'
}
*/