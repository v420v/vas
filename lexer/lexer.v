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
	c := if text.len == 0 {
		`\0`
	} else {
		text[0]
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

fn (mut l Lexer) peak(n int) u8 {
	if l.text.len == l.idx+n {
		return `\0`
	} else {
		return l.text[l.idx+n]
	}
}

fn (mut l Lexer) current_pos() token.Position {
	return token.Position{
		line: l.line
		file_name: l.file_name
	}
}

fn (mut l Lexer) skip_comment() {
	for l.c !in [`\n`, `\0`] {
		l.advance()
	}
}

fn (mut l Lexer) read_number() token.Token {
	pos := l.current_pos()
	start := l.idx

	if l.text[start] == `0` {
		l.advance()

		if l.c in [`x`, `X`] {
			l.advance()
			for (l.c >= `0` && l.c <= `9`) || (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`) {
				l.advance()
			}
		}

		if l.c in [`o`, `O`] {
			l.advance()
			for l.c >= `0` && l.c <= `7` {
				l.advance()
			}
		}

		if l.c in [`b`, `B`] {
			l.advance()
			for l.c in [`0`, `1`] {
				l.advance()
			}
		}
	} else {
		for l.c >= `0` && l.c <= `9` {
			l.advance()
		}
	}

	lit := l.text[start..l.idx]

	return token.Token{
		lit: lit
		kind: .number
		pos: pos
	}
}

fn is_alpha(c u8) bool {
	return (c >= `a` && c <= `z`) || (c >= `A` && c <= `Z`)
}

fn is_digit(c u8) bool {
	return (c >= `0` && c <= `9`)
}

fn (mut l Lexer) read_ident() token.Token {
	pos := l.current_pos()
	start := l.idx
	for {
		if is_alpha(l.c) || is_digit(l.c) || l.c in [`_`, `.`, `-`, `$`] {
			l.advance()
		} else {
			break
		}
	}
	lit := l.text[start..l.idx]
	return token.Token{
		lit: lit
		kind: .ident
		pos: pos
	}
}

fn is_hex_digit(c u8) bool {
	return (`0` <= c && c <= `9`) || (`A` <= c && c <= `F`) || (`a` <= c && c <= `f`)
}

fn from_hex(c u8) u8 {
	if `0` <= c && c <= `9` {
		return c - `0`
	}
	if `a` <= c && c <= `f` {
		return c - `a` + 10
	}
	return c - `A` + 10
}

fn (mut l Lexer) read_escaped_char() u8 {
	mut c := u8(0)
	l.advance() // skip '\\'
	if `0` <= l.c && l.c <= `7` {
		c = l.c - `0`
		if `0` <= l.peak(1) && l.peak(1) <= `7` {
			l.advance()
			c = (c << 3) + (l.c - `0`)
			if `0` <= l.peak(1) && l.peak(1) <= `7` {
				l.advance()
        		c = (c << 3) + (l.c - `0`)
			}
		}
		return c
	}

	if l.c == `x` {
		l.advance()
		if !is_hex_digit(l.c) {
			eprintln('error: invalid hex escape sequence');
			exit(1)
		}

		for is_hex_digit(l.c) {
			c = (c << 4) + from_hex(l.c)
			l.advance()
		}
	}

	if l.c == `a` {
		return `\a`
	}
	if l.c == `b` {
		return `\b`
	}
	if l.c == `t` {
		return `\t`
	}
	if l.c == `n` {
		return `\n`
	}
	if l.c == `v` {
		return `\v`
	}
	if l.c == `f` {
		return `\f`
	}
	if l.c == `r` {
		return `\r`
	}

	return l.c
}

fn (mut l Lexer) read_string() token.Token {
	pos := l.current_pos()
	l.advance()
	mut lit := []u8{}
	for l.c != `"` {
		if l.c == `\\` {
			lit << l.read_escaped_char()
			l.advance()
		} else {
			lit << l.c
			l.advance()
		}
	}
	l.advance()
	return token.Token{
		lit: lit.bytestr()
		kind: .string
		pos: pos
	}
}

fn (mut l Lexer) single_letter_token(c string, kind token.TokenKind) token.Token {
	pos := l.current_pos()
	l.advance()
	return token.Token{
		lit: c
		kind: kind
		pos: pos
	}
}

pub fn (mut l Lexer) lex() token.Token {
	for l.c != `\0` {
		mut pos := l.current_pos()
		if l.c in [` `, `\t`, `\n`] {
			l.advance()
		} else if is_digit(l.c) {
			return l.read_number()
		} else if is_alpha(l.c) || l.c == `_` || l.c == `.` {
			return l.read_ident()
		} else if l.c == `"` {
			return l.read_string()
		} else {
			match l.c {
				`#` { // skip comment
					l.skip_comment()
				}
				`:` {
					return l.single_letter_token(':', .colon)
				}
				`(` {
					return l.single_letter_token('(', .lpar)
				}
				`)` {
					return l.single_letter_token(')', .rpar)
				}
				`+` {
					return l.single_letter_token('+', .plus)
				}
				`-` {
					return l.single_letter_token('-', .minus)
				}
				`*` {
					return l.single_letter_token('*', .mul)
				}
				`/` {
					return l.single_letter_token('/', .div)
				}
				`$` {
					return l.single_letter_token('$', .dolor)
				}
				`%` {
					return l.single_letter_token('%', .percent)
				}
				`,` {
					return l.single_letter_token(',', .comma)
				}
				else {
					c := [l.c].bytestr()
					error.print(pos, 'unexpected token `${c}`')
					exit(1)
				}
			}
		}
	}

	return token.Token{
		lit: '\0'
		kind: token.TokenKind.eof
		pos: l.current_pos()
	} // end of file
}

