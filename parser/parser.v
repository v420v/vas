module parser

import error
import token
import lexer
import gen

struct Parser {
mut:
	tok             token.Token // current token
	lex             lexer.Lexer
	call_targets    []gen.CallTarget
	defined_symbols []&gen.Instr
}

pub fn new(program string, file_name string) &Parser {
	mut l := lexer.new(file_name, program)

	return &Parser{
		tok:             l.lex()
		lex:             l
		call_targets:    []gen.CallTarget{}
		defined_symbols: []&gen.Instr{}
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
			return gen.Immediate{
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
			return gen.Register{
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
		else {}
	}
	error.print(p.tok.pos, 'expected expression but got `${p.tok.lit}`')
	exit(1)
}

fn (mut p Parser) parse_instr() &gen.Instr {
	pos := p.tok.pos
	mut instr := gen.Instr{}

	name := p.tok.lit
	p.next()

	if p.tok.kind == .colon {
		instr.kind = .label
		instr.symbol_name = name
		p.expect(.colon)

		p.defined_symbols << &instr
	} else {
		match name.to_upper() {
			'.GLOBAL' {
				instr.kind = .global
				instr.symbol_name = p.tok.lit
				p.next()
			}
			'.LOCAL' {
				instr.kind = .local
				instr.symbol_name = p.tok.lit
				p.next()
			}
			'MOVQ' {
				instr.kind = .movq
				left_expr := p.parse_expr()
				p.expect(.comma)
				right_expr := p.parse_expr()
				instr.code = gen.encode_movq(left_expr, right_expr, pos)
			}
			'POPQ' {
				instr.kind = .popq
				expr := p.parse_expr()
				instr.code = gen.encode_popq(expr)
			}
			'PUSHQ' {
				instr.kind = .pushq
				expr := p.parse_expr()
				instr.code = gen.encode_pushq(expr)
			}
			'ADDQ' {
				instr.kind = .addq
				left_expr := p.parse_expr()
				p.expect(.comma)
				right_expr := p.parse_expr()
				instr.code = gen.encode_addq(left_expr, right_expr, pos)
			}
			'SUBQ' {
				instr.kind = .subq
				left_expr := p.parse_expr()
				p.expect(.comma)
				right_expr := p.parse_expr()
				instr.code = gen.encode_subq(left_expr, right_expr, pos)
			}
			'CALLQ' {
				left_expr := p.parse_expr()
				call_instr, call_target := gen.encode_callq(left_expr, pos)
				p.call_targets << call_target
				return call_instr
			}
			'RETQ' {
				instr.kind = .retq
				instr.code = [u8(0xc3)]
			}
			'SYSCALL' {
				instr.kind = .syscall
				instr.code = [u8(0x0f), 0x05]
			}
			'XORQ' {
				instr.kind = .xorq
				left_expr := p.parse_expr()
				p.expect(.comma)
				right_expr := p.parse_expr()
				instr.code = gen.encode_xorq(left_expr, right_expr, pos)
			}
			'NOPQ' {
				instr.kind = .nopq
				instr.code = [u8(0x90)]
			}
			'HLT' {
				instr.kind = .hlt
				instr.code = [u8(0xf4)]
			}
			'LEAVE' {
				instr.kind = .leave
				instr.code = [u8(0xc9)]
			}
			else {
				error.print(pos, 'unkwoun instruction `${name}`')
				exit(1)
			}
		}
	}
	return &instr
}

pub fn (mut p Parser) parse() ([]&gen.Instr, []&gen.Instr, []gen.CallTarget) {
	mut instrs := []&gen.Instr{}

	for p.tok.kind != .eof {
		if p.tok.kind == .eol {
			p.next()
		} else {
			instrs << p.parse_instr()
		}
	}

	return instrs, p.defined_symbols, p.call_targets
}

