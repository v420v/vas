module lexer

import token
import error

pub struct Lexer {
	mut:
		c	      u8       // current character
		text      string   // program line
		idx       int
		line      int
		col       int
		file_name string
	pub mut:
		errors    []error.Vas_Error
}

pub fn new(file_name string, text string) &Lexer {
	mut c := `\0`
	if text.len != 0 {
		c = text[0]
	}
	return &Lexer {
		text: text,
		c: c,
		line: 1,
		col: 0,
		file_name: file_name,
	}
}

fn (mut l Lexer) advance() {
	l.col++
	l.idx++

	if l.c == `\n` {
		l.col = 0
		l.line++
	}

	if l.text.len == l.idx {
		l.c = `\0`
	} else {
		l.c = l.text[l.idx]
	}
}

fn (mut l Lexer) current_pos() token.Position {
	return token.Position{
		line: l.line,
		col: l.col,
		file_name: l.file_name,
	}
}

pub fn (mut l Lexer) lex() []token.Token {
	mut tokens := []token.Token{}

	for l.c != `\0` {
		mut pos := l.current_pos()
		if l.c == ` ` {
			l.advance()
		} else if l.c >= `0` && l.c <= `9` {
			start := l.idx
			for {
				if l.c >= `0` && l.c <= `9` {
					l.advance()
				} else {
					break
				}
			}
			lit := l.text[start..l.idx]
			pos.len = lit.len
			tokens << token.Token{lit: lit, kind: token.TokenKind.number, pos: pos}
		} else if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`) || l.c == `_` {
			start := l.idx
			for {
				if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`) || l.c == `_` {
					l.advance()
				} else {
					break
				}
			}
			lit := l.text[start..l.idx]
			pos.len = lit.len
			tokens << token.Token{lit: lit, kind: token.TokenKind.ident, pos: pos}
		} else {
			pos.len = 1
			match l.c {
				`\n` {
					l.advance()
					tokens << token.Token{lit: '<eol>', kind: token.TokenKind.eol, pos: pos}
				}
				`:` {
					l.advance()
					tokens << token.Token{lit: ':', kind: token.TokenKind.colon, pos: pos}
				}
				`,` {
					l.advance()
					tokens << token.Token{lit: ',', kind: token.TokenKind.comma, pos: pos}
				} else {
					c := [l.c].bytestr()
					l.errors << error.new_error(pos, 'unexpected token `$c`')
					for !(l.c in [`\n`, `\0`]) {
						l.advance()
					}
				}
			}
		}
	}

	tokens << token.Token{lit: '\0', kind: token.TokenKind.eof, pos: l.current_pos()} // end of line

	return tokens
}

