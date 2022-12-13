module parser

import lexer
import ast

struct Parser {
	mut:
		l          &lexer.Lexer
		tok        lexer.Token // current token
		file_name  string
		text_lines []string
}

pub fn new(text_lines []string, file_name string) &Parser {
	return &Parser {
		l:          0,
		file_name: file_name,
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
		eprintln('${p.tok.pos.file_name}:${p.tok.pos.line}:${p.tok.pos.col}: error: expected `$expected` but got `$got`')
		exit(1)
	}
	p.next()
}

fn (mut p Parser) parse_expr() ast.Expr {
	match p.tok.kind {
		.number {
			lit := p.tok.lit
			pos := p.tok.pos
			p.expect(lexer.TokenKind.number)
			return ast.IntExpr {
				lit: lit,
				pos: pos,
			}
		}
		.ident {
			lit := p.tok.lit
			pos := p.tok.pos
			p.expect(lexer.TokenKind.ident)
			if lit in ['eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi'] {
				return ast.RegExpr {
					lit: lit,
					bit: 32,
					pos: pos,
				}
			} else if lit in ['rax', 'rcx', 'rdx', 'rbx', 'rsp', 'rbp', 'rsi', 'rdi'] {
				return ast.RegExpr {
					lit: lit,
					bit: 64,
					pos: pos,
				}
			} else {
				eprintln('${p.tok.pos.file_name}:${p.tok.pos.line}:${p.tok.pos.col}: error: unknown identifier `$lit`')
				exit(1)
			}
		} else {
			tok := tokens_str[p.tok.kind]
			eprintln('${p.tok.pos.file_name}:${p.tok.pos.line}:${p.tok.pos.col}: error: expected expression but got `$tok`')
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
				eprintln('${p.tok.pos.file_name}:${p.tok.pos.line}:${p.tok.pos.col}: error: invalid instruction `$p.tok.lit`')
				exit(1)
			}
		}
	}
	return op
}

pub fn (mut p Parser) parse() []ast.Op {
	mut ops := []ast.Op{}

	p.l = lexer.new(p.file_name)
	for i, t in p.text_lines {
		mut bytes := t.bytes()
		bytes << `\0`

		p.l.init(bytes, i + 1)

		p.tok = p.l.lex()

		if p.tok.kind != lexer.TokenKind.eol {
			ops << p.parse_op()
		}
	}

	return ops
}
