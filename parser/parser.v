module parser

import os
import error
import token
import lexer
import gen

struct Parser {
mut:
	tok  token.Token // current token
	lex  lexer.Lexer
}

pub fn new(file_name string) &Parser {
	program := os.read_file(file_name) or {
		eprintln('error: reading file `${file_name}`')
		exit(1)
	}

	mut l := lexer.new(file_name, program)
	tok := l.lex()

	return &Parser{
		tok: tok
		lex: l
	}
}

fn (mut p Parser) next() {
	p.tok = p.lex.lex()
}

fn (mut p Parser) expect(exp token.TokenKind) {
	if p.tok.kind != exp {
		exp_tok_str := token.token_kind_str(exp)
		error.print(p.tok.pos, 'expected `${exp_tok_str}` but got `${p.tok.lit}`')
		exit(1)
	}
	p.next()
}

fn (mut p Parser) parse_expr() gen.Expr {
	pos := p.tok.pos
	match p.tok.kind {
		.dolor { // immediates
			p.next()
			num := p.tok.lit
			p.next()
			return gen.IntExpr{
				lit: num
				pos: pos
			}
		}
		.percent { // register
			p.next()
			reg_name := p.tok.lit.to_upper()
			if reg_name !in token.registers {
				error.print(p.tok.pos, 'invalid register name')
				exit(1)
			}
			p.next()
			return gen.RegExpr{
				lit: reg_name
				pos: pos
			}
		}
		.ident, .number {
			lit := p.tok.lit
			p.next()
			return gen.IdentExpr{
				lit: lit
				pos: pos
			}
		}
		else {
			error.print(p.tok.pos, 'expected expression but got `${p.tok.lit}`')
			exit(1)
		}
	}
	panic('unreachable')
}

fn (mut p Parser) parse_instr() gen.Instr {
	mut instr := gen.Instr{
		pos: p.tok.pos
	}

	name := p.tok.lit
	p.next()

	if p.tok.kind == .colon {
		instr.kind = .label
		instr.left_hs = gen.Expr(
			gen.IdentExpr{
				lit: name
				pos: instr.pos
			}
		)
		instr.binding = 0
		p.expect(.colon)
		return instr
	}

	match name.to_upper() {
		'.GLOBAL' {
			instr.kind = .global
			instr.left_hs = p.parse_expr()
		}
		'.LOCAL' {
			instr.kind = .local
			instr.left_hs = p.parse_expr()
		}
		'MOVQ' {
			instr.kind = .movq
			instr.left_hs = p.parse_expr()
			p.expect(.comma)
			instr.right_hs = p.parse_expr()
		}
		'POPQ' {
			instr.kind = .popq
			instr.left_hs = p.parse_expr()
		}
		'PUSHQ' {
			instr.kind = .pushq
			instr.left_hs = p.parse_expr()
		}
		'ADDQ' {
			instr.kind = .addq
			instr.left_hs = p.parse_expr()
			p.expect(.comma)
			instr.right_hs = p.parse_expr()
		}
		'SUBQ' {
			instr.kind = .subq
			instr.left_hs = p.parse_expr()
			p.expect(.comma)
			instr.right_hs = p.parse_expr()
		}
		'CALLQ' {
			instr.kind = .callq
			instr.left_hs = p.parse_expr()
		}
		'RETQ' {
			instr.kind = .retq
		}
		'SYSCALL' {
			instr.kind = .syscall
		}
		'XORQ' {
			instr.kind = .xorq
			instr.left_hs = p.parse_expr()
			p.expect(.comma)
			instr.right_hs = p.parse_expr()
		}
		'NOP' {
			instr.kind = .nop
		}
		'HLT' {
			instr.kind = .hlt
		}
		else {
			error.print(instr.pos, 'unkwoun instruction `${name}`')
			exit(1)
		}
	}

	return instr
}

pub fn (mut p Parser) parse() []gen.Instr {
	mut instrs := []gen.Instr{}
	for p.tok.kind != .eof {
		if p.tok.kind == .eol {
			p.next()
		} else {
			instrs << p.parse_instr()
		}
	}
	return instrs
}

