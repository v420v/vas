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

fn (mut l Lexer) is_hex() bool {
	if l.text.len == l.idx+1 {
		return false
	} else {
		return (l.c == `0`) && (l.text[l.idx+1] in [`x`, `X`])
	}
}

fn (mut l Lexer) read_number() token.Token {
	mut pos := l.current_pos()
	start := l.idx

	if l.is_hex() {
		l.advance()
		l.advance()
		for {
			if (l.c >= `0` && l.c <= `9`) || (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`) {
				l.advance()
			} else {
				break
			}
		}
	} else {
		for {
			if l.c >= `0` && l.c <= `9` {
				l.advance()
			} else {
				break
			}
		}
	}

	lit := l.text[start..l.idx]
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
		if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`) || (l.c >= `0` && l.c <= `9`) || l.c in [`_`, `.`, `-`, `$`] {
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

pub fn (mut l Lexer) lex() token.Token {
	for l.c != `\0` {
		mut pos := l.current_pos()
		if l.c == ` ` || l.c == `\t` {
			l.advance()
		} else if l.c >= `0` && l.c <= `9` {
			return l.read_number()
		} else if (l.c >= `a` && l.c <= `z`) || (l.c >= `A` && l.c <= `Z`)
			|| l.c == `_` || l.c == `.` {
			return l.read_ident()
		} else if l.c == `"` {
			l.advance()
			mut lit := []u8{}
			for l.c != `"` {
				if l.c == `\\` {
					l.advance()
					match l.c {
						`n` {
							lit << `\n`
						}
						`t` {
							lit << `\t`
						}
						`a` {
							lit << `\a`
						}
						`b` {
							lit << `\b`
						}
						`f` {
							lit << `\f`
						}
						`v` {
							lit << `\v`
						}
						`0` {
							if l.peak(1) == `3` && l.peak(2) == `3` {
								l.advance()
								l.advance()
								lit << `\033`
							} else {
								lit << `\0`
							}
						} else {
							lit << `\\`
							lit << l.c
						}
					}
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
		} else {
			match l.c {
				`#` { // skip comment
					l.skip_comment()
				}
				`\n` {
					l.advance()
				}
				`:` {
					l.advance()
					return token.Token{
						lit: ':'
						kind: .colon
						pos: pos
					}
				}
				`(` {
					l.advance()
					return token.Token{
						lit: '('
						kind: .lpar
						pos: pos
					}
				}
				`)` {
					l.advance()
					return token.Token{
						lit: ')'
						kind: .rpar
						pos: pos
					}
				}
				`+` {
					l.advance()
					return token.Token{
						lit: '+'
						kind: .plus
						pos: pos
					}
				}
				`-` {
					l.advance()
					return token.Token{
						lit: '-'
						kind: .minus
						pos: pos
					}
				}
				`*` {
					l.advance()
					return token.Token{
						lit: '*'
						kind: .mul
						pos: pos
					}
				}
				`/` {
					l.advance()
					return token.Token{
						lit: '/'
						kind: .mul
						pos: pos
					}
				}
				`$` {
					l.advance()
					return token.Token{
						lit: '$'
						kind: .dolor
						pos: pos
					}
				}
				`%` {
					l.advance()
					return token.Token{
						lit: '%'
						kind: .percent
						pos: pos
					}
				}
				`,` {
					l.advance()
					return token.Token{
						lit: ','
						kind: .comma
						pos: pos
					}
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

