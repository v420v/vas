module parser

import token
import error
import ast

struct Parser {
	pub mut:
		errors     []error.Vas_Error
	mut:
		idx        int
		tok        token.Token // current token
		tokens     []token.Token
}

pub fn new(tokens []token.Token) &Parser {
	return &Parser {
		idx: 0,
		tok: tokens[0],
		tokens: tokens,
	}
}

fn (mut p Parser) next() {
	p.idx++
	p.tok = p.tokens[p.idx]
}

fn (mut p Parser) parse_expr() ?ast.Expr {
	match p.tok.kind {
		.number {
			lit := p.tok.lit
			pos := p.tok.pos

			p.next()

			return ast.IntExpr {
				lit: lit,
				pos: pos,
			}
		}
		.ident {
			lit := p.tok.lit
			pos := p.tok.pos

			p.next()

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
				p.errors << error.new_error(pos, 'unknown identifier `$lit`')
			}
		} else {
			p.errors << error.new_error(p.tok.pos, 'expected expression but got `$p.tok.lit`')
		}
	}
	return none
}

fn (mut p Parser) parse_op() ?ast.Op {
	mut op := ast.Op{}
	op.pos = p.tok.pos
	match p.tok.lit {
		'mov' {
			op.kind = ast.OpKind.mov
			p.next()

			op.left = p.parse_expr() or {
				return none
			}

			if p.tok.kind != token.TokenKind.comma {
				p.errors << error.new_error(p.tok.pos, 'expected `,` but got `$p.tok.lit`')
				return none
			}

			p.next()

			op.right = p.parse_expr() or {
				return none
			}
		}
		'nop' {
			op.kind = ast.OpKind.nop
			p.next()
		}
		'syscall' {
			op.kind = ast.OpKind.syscall
			p.next()
		} else {
			p.errors << error.new_error(p.tok.pos, 'invalid instruction `$p.tok.lit`')
			return none
		}
	}
	return op
}

pub fn (mut p Parser) parse() []ast.Op {
	mut ops := []ast.Op{}

	for p.tok.kind != token.TokenKind.eof {
		if p.tok.kind == token.TokenKind.eol {
			p.next() // EOL
		} else {
			ops << p.parse_op() or {
				ast.Op{}
			}

			for !(p.tok.kind in [token.TokenKind.eol, token.TokenKind.eof]) {
				p.next()
			}
		}
	}

	return ops
}
