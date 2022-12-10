module lexer

pub struct Lexer {
	mut:
		text      []u8   // program line
		line      int
		file_name string
		c 	      u8     // current character
		col       int
}

pub enum TokenKind {
	ident
	number
	comma
	colon
	eol // enf of line 
}

pub struct Position {
	pub:
		file_name string
		line      int
		col       int
}

pub struct Token {
	pub:
		file_name string
		kind TokenKind
		pos  Position
		lit string
}

pub fn new(file_name string) &Lexer {
	return &Lexer {
		file_name: file_name,
	}
}

pub fn (mut l Lexer) init(text []u8, line int) {
	l.text = text 
	l.line = line
	l.c = text[0]
	l.col = 0
}

fn (mut l Lexer) advance() {
	l.col++
	l.c = l.text[l.col]
}

pub fn (mut l Lexer) lex() Token {
	for l.c != `\0` {
		if l.c == ` ` {
			l.advance()
		} else if l.c >= `0` && l.c <= `9` {
			pos := Position{line: l.line, col: l.col, file_name: l.file_name}
			start := l.col
			for {
				if l.c >= `0` && l.c <= `9` {
					l.advance()
				} else {
					break
				}
			}
			return Token{lit: l.text[start..l.col].bytestr(), kind: TokenKind.number, pos: pos}
		} else if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`) || l.c == `_` {
			pos := Position{line: l.line, col: l.col, file_name: l.file_name}
			start := l.col
			for {
				if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`) || l.c == `_` {
					l.advance()
				} else {
					break
				}
			}
			return Token{lit: l.text[start..l.col].bytestr(), kind: TokenKind.ident, pos: pos}
		} else {
			pos := Position{line: l.line, col: l.col, file_name: l.file_name}
			match l.c {
				`:` {
					l.advance()
					return Token{lit: ':', kind: TokenKind.colon, pos: pos}
				}
				`,` {
					l.advance()
					return Token{lit: ',', kind: TokenKind.comma, pos: pos}
				} else {
					c := [l.c].bytestr()
					eprintln('$l.file_name:$l.line:$l.col: error: unexpected token `$c`')
					exit(1)
				}
			}
		}
	}

	return Token{lit: '\0', kind: TokenKind.eol, pos: Position{line: l.line, col: l.col, file_name: l.file_name}} // end of line
}
