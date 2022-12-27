module parser

import error
import token
import ast
import os

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
		p.error(p.tok.pos, 'expected `$exp_tok_str` but got `$p.tok.lit`')
	}
	p.next()
}

fn (mut p Parser) error(pos token.Position, msg string) {
	program := os.read_file(pos.file_name) or {
		eprintln('error: reading file `$pos.file_name`')
		exit(1)
	}

	program_in_lines := program.split('\n')
	error.print_error(error.new_error(pos, msg), program_in_lines[pos.line-1])

	exit(1)
}

fn (mut p Parser) parse_expr() ast.Expr {
	pos := p.tok.pos
	match p.tok.kind {
		.dolor { // immediates
			p.next()
			num := p.tok.lit
			p.next()
			return ast.IntExpr {
				lit: num
				pos: pos
			}
		}
		.percent { // register
			p.next()
			reg_name := p.tok.lit.to_upper()
			if !(reg_name in token.registers) {
				p.error(p.tok.pos, 'invalid register name')
			}
			p.next()
			return ast.RegExpr {
				lit: reg_name
				pos: pos
			}
		}
		.ident { // identifier ? label name
			lit := p.tok.lit
			p.next()
			return ast.IdentExpr {
				lit: lit
				pos: pos
			}
		} else {
			p.error(p.tok.pos, 'expected expression but got `$p.tok.lit`')
		}
	}
	panic('unreachable')
}

fn (mut p Parser) parse_instr() ast.Instruction {
	mut instr := ast.Instruction{
		pos: p.tok.pos
	}

	if p.tok.kind == .ident && p.peak_token().kind == .colon {
		// parse label
		instr.instr_name = 'LABEL'
		instr.left_hs = p.parse_expr()
		instr.binding = 0
		p.expect(.colon)
		return instr
	}

	name := p.tok.lit.to_upper()

	match name {
		'.GLOBAL' {
			p.next()
			instr.left_hs = p.parse_expr()
		}
		'.LOCAL' {
			p.next()
			instr.left_hs = p.parse_expr()
		}
		'MOVQ', 'MOVL' {
			// parse mov instruction
			// Example
			// movq $10, %rax
			p.next()
			instr.left_hs = p.parse_expr()
			p.expect(.comma)
			instr.right_hs = p.parse_expr()
		}
		'CALLQ' {
			p.next()
			// parse call instruction
			instr.left_hs = p.parse_expr()
		}
		'RETQ' {
			p.next()
			// parse return instruction
			// pass
		}
		'SYSCALL' {
			p.next()
			// parse syscall instruction
			// pass
		}
		'NOP' {
			p.next()
		} else {
			p.error(instr.pos, 'unkwoun instruction `$name`')
		}
	}

	instr.instr_name = name
	return instr
}

pub fn (mut p Parser) parse() []ast.Instruction {
	mut instrs := []ast.Instruction{}
	for p.tok.kind != .eof {
		if p.tok.kind == .eol {
			p.next()
		} else {
			instrs << p.parse_instr()
		}
	}
	return instrs
}
