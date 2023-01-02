module lexer

import token
import error

pub struct Lexer {
mut:
	c         u8     // current character
	text      string // program line
	idx       int
	line      int
	col       int
	file_name string
}

pub fn new(file_name string, text string) &Lexer {
	mut c := `\0`
	if text.len != 0 {
		c = text[0]
	}
	return &Lexer{
		text: text
		c: c
		line: 1
		col: 0
		file_name: file_name
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
		line: l.line
		col: l.col
		file_name: l.file_name
	}
}

fn (mut l Lexer) skip_comment() {
	for l.c !in [`\n`, `\0`] {
		l.advance()
	}
}

fn (mut l Lexer) read_number() token.Token {
	mut pos := l.current_pos()
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
	return token.Token{
		lit: lit
		kind: .number
		pos: pos
	}
}

fn (mut l Lexer) read_ident() token.Token {
	mut pos := l.current_pos()
	start := l.idx
	for {
		if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`)
			|| (l.c >= `0` && l.c <= `9`) || l.c == `_` || l.c == `.` {
			l.advance()
		} else {
			break
		}
	}
	lit := l.text[start..l.idx]
	pos.len = lit.len
	return token.Token{
		lit: lit
		kind: .ident
		pos: pos
	}
}

pub fn (mut l Lexer) lex() []token.Token {
	mut tokens := []token.Token{}

	for l.c != `\0` {
		mut pos := l.current_pos()
		if l.c == ` ` {
			l.advance()
		} else if l.c >= `0` && l.c <= `9` {
			tokens << l.read_number()
		} else if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`)
			|| l.c == `_` || l.c == `.` {
			tokens << l.read_ident()
		} else {
			pos.len = 1
			match l.c {
				`#` { // skip comment
					l.skip_comment()
				}
				`\n` {
					l.advance()
					tokens << token.Token{
						lit: '<eol>'
						kind: .eol
						pos: pos
					}
				}
				`:` {
					l.advance()
					tokens << token.Token{
						lit: ':'
						kind: .colon
						pos: pos
					}
				}
				`$` {
					l.advance()
					tokens << token.Token{
						lit: '$'
						kind: .dolor
						pos: pos
					}
				}
				`%` {
					l.advance()
					tokens << token.Token{
						lit: '%'
						kind: .percent
						pos: pos
					}
				}
				`,` {
					l.advance()
					tokens << token.Token{
						lit: ','
						kind: .comma
						pos: pos
					}
				}
				else {
					c := [l.c].bytestr()
					err := error.new_error(pos, 'unexpected token `${c}`')
					error.print(err)
					exit(1)
				}
			}
		}
	}

	tokens << token.Token{
		lit: '\0'
		kind: token.TokenKind.eof
		pos: l.current_pos()
	} // end of file

	return tokens
}

