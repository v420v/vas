module parser

import token
import error
import ast
import os

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

fn (mut p Parser) peak_token() token.Token {
	return p.tokens[p.idx+1]
}

fn (mut p Parser) parse_expr() ast.Expr {
	pos := p.tok.pos
	match p.tok.kind {
		.number {
			lit := p.tok.lit
			p.next()

			return ast.IntExpr {
				lit: lit,
				pos: pos,
			}
		}
		.ident {
			lit := p.tok.lit
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
				return ast.IdentExpr {
					name: lit
					pos: pos,
				}
			}
		} else {
			p.error(p.tok.pos, 'expected expression but got `$p.tok.lit`')
		}
	}
	panic('unreachable')
}

fn (mut p Parser) parse_op() ast.Instr {
	pos := p.tok.pos

	if p.tok.kind == .ident && p.peak_token().kind == .colon {
		label_name := p.tok.lit
		p.next()
		p.next()
		return ast.Label {
			name: label_name,
			pos: pos,
		}
	}

	match p.tok.lit {
		'mov' {
			p.next()

			left := p.parse_expr()

			if p.tok.kind != .comma {
				p.error(p.tok.pos, 'expected `,` but got `$p.tok.lit`')
			}

			p.next()

			right := p.parse_expr()

			return ast.Mov{
				pos: pos,
				left: left,
				right: right,
			}
		}
		'call' {
			p.next()

			expr := p.parse_expr()

			return ast.Call {
				expr: expr,
				offset: 0,
				pos: pos,
			}
		}
		'ret' {
			p.next()
			return ast.Ret {
				pos: pos,
			}
		}
		'nop' {
			p.next()
			return ast.Nop{
				pos: pos,
			}
		}
		'syscall' {
			p.next()

			return ast.Syscall{
				pos: pos,
			}
		} else {
			p.error(p.tok.pos, 'invalid instruction `$p.tok.lit`')
		}
	}
	panic('unreachable')
}

fn (mut p Parser) error(pos token.Position, msg string) {
	program := os.read_file(pos.file_name) or {
		eprintln('error: reading file `$pos.file_name`')
		exit(1)
	}

	program_in_lines := program.split('\n')

	code := program_in_lines[pos.line-1]

	error.print_error(error.new_error(pos, msg), code)

	exit(1)
}

pub fn (mut p Parser) parse() []ast.Instr {
	mut instrs := []ast.Instr{}

	for p.tok.kind != .eof {
		if p.tok.kind == .eol {
			p.next() // EOL
		} else {
			instrs << p.parse_op()
		}
	}

	return instrs
}

