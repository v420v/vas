module lexer

pub struct Lexer {
	mut:
		text []u8   // program line
		c 	 u8     // current character
		col  int
}

pub enum TokenKind {
	ident
	number
	comma
	colon
	eol // enf of line 
}

pub struct Token {
	pub:
		kind TokenKind
		lit string
}

pub fn new() &Lexer {
	return &Lexer {}
}

pub fn (mut l Lexer) init(text []u8) {
	l.text = text 
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
			start := l.col
			for {
				if l.c >= `0` && l.c <= `9` {
					l.advance()
				} else {
					break
				}
			}
			return Token{lit: l.text[start..l.col].bytestr(), kind: TokenKind.number}
		} else if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`) || l.c == `_` {
			start := l.col
			for {
				if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`) || l.c == `_` {
					l.advance()
				} else {
					break
				}
			}
			return Token{lit: l.text[start..l.col].bytestr(), kind: TokenKind.ident}
		} else {
			match l.c {
				`:` {
					l.advance()
					return Token{lit: ':', kind: TokenKind.colon}
				}
				`,` {
					l.advance()
					return Token{lit: ',', kind: TokenKind.comma}
				} else {
					c := [l.c].bytestr()
					eprintln('unexpected token `$c`')
					exit(1)
				}
			}
		}
	}

	return Token{lit: '\0', kind: TokenKind.eol} // end of line
}
