module parser

import error
import token
import gen

struct Parser {
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

fn (mut p Parser) expect(exp token.TokenKind) {
	if p.tok.kind != exp {
		exp_tok_str := token.token_kind_str(exp)
		error.print(error.new_error(p.tok.pos, 'expected `$exp_tok_str` but got `$p.tok.lit`'))
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
			return gen.IntExpr {
				lit: num
				pos: pos
			}
		}
		.percent { // register
			p.next()
			reg_name := p.tok.lit.to_upper()
			if !(reg_name in token.registers) {
				error.print(error.new_error(p.tok.pos, 'invalid register name'))
				exit(1)
			}
			p.next()
			return gen.RegExpr {
				lit: reg_name
				pos: pos
			}
		}
		.ident, .number { // identifier ? label name
			lit := p.tok.lit
			p.next()
			return gen.IdentExpr {
				lit: lit
				pos: pos
			}
		} else {
			error.print(error.new_error(p.tok.pos, 'expected expression but got `$p.tok.lit`'))
			exit(1)
		}
	}
	panic('unreachable')
}

fn (mut p Parser) parse_instr() gen.Instr {
	mut instr := gen.Instr{
		pos: p.tok.pos
	}

	if (p.tok.kind == .ident || p.tok.kind == .number) && p.peak_token().kind == .colon {
		instr.kind = .label
		instr.left_hs = p.parse_expr()
		instr.binding = 0
		p.expect(.colon)
		return instr
	}

	name := p.tok.lit

	match name.to_upper() {
		'.GLOBAL' {
			instr.kind = .global
			p.next()
			instr.left_hs = p.parse_expr()
		}
		'.LOCAL' {
			instr.kind = .local
			p.next()
			instr.left_hs = p.parse_expr()
		}
		'MOVQ' {
			instr.kind = .movq
			p.next()
			instr.left_hs = p.parse_expr()
			p.expect(.comma)
			instr.right_hs = p.parse_expr()
		}
		'POPQ' {
			instr.kind = .popq
			p.next()
			instr.left_hs = p.parse_expr()
		}
		'PUSHQ' {
			instr.kind = .pushq
			p.next()
			instr.left_hs = p.parse_expr()
		}
		'ADDQ' {
			instr.kind = .addq
			p.next()
			instr.left_hs = p.parse_expr()
			p.expect(.comma)
			instr.right_hs = p.parse_expr()
		}
		'SUBQ' {
			instr.kind = .subq
			p.next()
			instr.left_hs = p.parse_expr()
			p.expect(.comma)
			instr.right_hs = p.parse_expr()
		}
		'CALLQ' {
			instr.kind = .callq
			p.next()
			instr.left_hs = p.parse_expr()
		}
		'RETQ' {
			instr.kind = .retq
			p.next()
		}
		'SYSCALL' {
			instr.kind = .syscall
			p.next()
		}
		'XORQ' {
			instr.kind = .xorq
			p.next()
			instr.left_hs = p.parse_expr()
			p.expect(.comma)
			instr.right_hs = p.parse_expr()
		}
		'NOP' {
			instr.kind = .nop
			p.next()
		}
		'HLT' {
			instr.kind = .hlt
			p.next()
		} else {
			error.print(error.new_error(instr.pos, 'unkwoun instruction `$name`'))
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
