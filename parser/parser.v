module parser

import lexer
import ast

struct Parser {
	mut:
		l          &lexer.Lexer
		tok        lexer.Token // current token
		text_lines []string
}

pub fn new(text_lines []string) &Parser {
	return &Parser {
		l:          0,
		text_lines: text_lines,
	}
}

fn (mut p Parser) next() {
	p.tok = p.l.lex()
}

const tokens_str = {
	lexer.TokenKind.number: '<number>'
	lexer.TokenKind.ident: '<ident>'
	lexer.TokenKind.comma: ','
	lexer.TokenKind.colon: ':'
	lexer.TokenKind.eol: '<EOL>'
}

fn (mut p Parser) expect(kind lexer.TokenKind) {
	if kind != p.tok.kind {
		expected := tokens_str[kind]
		mut got := p.tok.lit
		if p.tok.kind == lexer.TokenKind.eol {
			got = tokens_str[p.tok.kind]
		}
		eprintln('expected `$expected` but got `$got`')
		exit(1)
	}
	p.next()
}

fn (mut p Parser) parse_expr() ast.Expr {
	match p.tok.kind {
		.number {
			lit := p.tok.lit
			p.expect(lexer.TokenKind.number)
			return ast.IntExpr {
				lit: lit,
			}
		}
		.ident {
			name := p.tok.lit
			if name in ['eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi'] {
				p.expect(lexer.TokenKind.ident)
				return ast.RegExpr {
					name: name,
				}
			} else {
				eprintln('$name not implemented yet')
				exit(1)
			}
		} else {
			tok := tokens_str[p.tok.kind]
			eprintln('expected expr but got $tok')
			exit(1)
		}
	}
}

fn (mut p Parser) parse_op() ast.Op {
	mut op := ast.Op{}

	for p.tok.kind != lexer.TokenKind.eol {
		match p.tok.lit {
			'mov' {
				op.kind = ast.OpKind.mov
				p.expect(lexer.TokenKind.ident)

				op.left = p.parse_expr()
				p.expect(lexer.TokenKind.comma)
				op.right = p.parse_expr()
			}
			'nop' {
				op.kind = ast.OpKind.nop
				p.expect(lexer.TokenKind.ident)
			}
			'syscall' {
				op.kind = ast.OpKind.syscall
				p.expect(lexer.TokenKind.ident)
			} else {
				eprintln('`$p.tok.lit` not supported yet')
				exit(1)
			}
		}
	}
	return op
}

pub fn (mut p Parser) parse() []ast.Op {
	mut ops := []ast.Op{}

	p.l = lexer.new()
	for _, t in p.text_lines {
		mut bytes := t.bytes()
		bytes << `\0`

		p.l.init(bytes)

		p.tok = p.l.lex()

		if p.tok.kind != lexer.TokenKind.eol {
			ops << p.parse_op()
		}
	}

	return ops
}
