module parser

import error
import token
import lexer

pub struct Parser {
pub mut:
	tok             token.Token // current token
	lex             lexer.Lexer
	instrs          []&Instr
	call_targets    []CallTarget
	rela_text_users []RelaTextUser
	variable_instrs []&Instr
	defined_symbols []&Instr
}

pub fn new(program string, file_name string) &Parser {
	mut l := lexer.new(file_name, program)

	return &Parser{
		tok:             l.lex()
		lex:             l
		call_targets:    []CallTarget{}
		defined_symbols: []&Instr{}
	}
}

fn (mut p Parser) next() {
	p.tok = p.lex.lex()
}

fn (mut p Parser) expect(exp token.TokenKind) {
	if p.tok.kind != exp {
		error.print(p.tok.pos, 'unexpected token `${p.tok.lit}`')
		exit(1)
	}
	p.next()
}

fn (mut p Parser) parse_register() Register {
	pos := p.tok.pos
	p.expect(.percent)
	reg_name := p.tok.lit.to_upper()
	if reg_name !in token.registers {
		error.print(p.tok.pos, 'invalid register name')
		exit(1)
	}
	p.next()
	return Register{
		lit: reg_name
		pos: pos
	}
}

fn (mut p Parser) parse_factor() Expr {
	match p.tok.kind {
		.number {
			lit := p.tok.lit
			p.next()
			return Number{pos: p.tok.pos, lit: lit}
		}
		.ident {
			lit := p.tok.lit
			p.next()
			return Ident{pos: p.tok.pos, lit: lit}
		}
		else {
			error.print(p.tok.pos, 'unexpected token `${p.tok.lit}`')
    		exit(1)
		}
	}
}

fn (mut p Parser) parse_expr() Expr {
	expr := p.parse_factor()
	if p.tok.kind in [.plus, .minus] {
		op := p.tok.kind
		pos := p.tok.pos
		p.next()
		right_hs := p.parse_expr()
		return Binop{
			left_hs: expr,
			right_hs: right_hs,
			op: op,
			pos: pos
		}
	}
	return expr
}

fn (mut p Parser) parse_operand() Expr {
    pos := p.tok.pos
    
    match p.tok.kind {
        .dolor {
            p.next()
            return Immediate{
                expr: p.parse_expr(),
                pos: pos,
            }
        }
        .percent {
            return p.parse_register()
        }
		else {
			expr := p.parse_expr()
			if p.tok.kind != .lpar {
        	    return expr
        	}
			p.next()
			regi := p.parse_register()
            p.expect(.rpar)
            return Indirection{
                expr: expr,
                regi: regi,
                pos: pos,
            }
        }
    }
	error.print(p.tok.pos, 'unexpected token `${p.tok.lit}`')
	exit(1)
}

fn (mut p Parser) parse_instr() {
	pos := p.tok.pos
	mut instr := Instr{}

	name := p.tok.lit
	p.next()

	if p.tok.kind == .colon {
		instr.kind = .label
		instr.symbol_name = name
		p.expect(.colon)

		p.defined_symbols << &instr
		p.instrs << &instr
		return
	}

	match name.to_upper() {
		'.TEXT', '.DATA' {
			instr.kind = .section
			instr.section = name
			p.instrs << &instr
		}
		'RETQ' {
			instr.kind = .retq
			instr.code = [u8(0xc3)]
			p.instrs << &instr
		}
		'SYSCALL' {
			instr.kind = .syscall
			instr.code = [u8(0x0f), 0x05]
			p.instrs << &instr
		}
		'NOPQ' {
			instr.kind = .nopq
			instr.code = [u8(0x90)]
			p.instrs << &instr
		}
		'HLT' {
			instr.kind = .hlt
			instr.code = [u8(0xf4)]
			p.instrs << &instr
		}
		'LEAVE' {
			instr.kind = .leave
			instr.code = [u8(0xc9)]
			p.instrs << &instr
		}
		'.GLOBAL' {
			instr.kind = .global
			instr.symbol_name = p.tok.lit
			p.next()
			p.instrs << &instr
		}
		'.LOCAL' {
			instr.kind = .local
			instr.symbol_name = p.tok.lit
			p.next()
			p.instrs << &instr
		}
		'.STRING' {
			value := p.tok.lit
			p.expect(.string)
			p.instr_string(value)
		}
		'POPQ' {
			source := p.parse_operand()
			p.instr_popq(source)
		}
		'PUSHQ' {
			source := p.parse_operand()
			p.instr_pushq(source)
		}
		'MOVQ' {
			source := p.parse_operand()
			p.expect(.comma)
			destination := p.parse_operand()
			p.instr_movq(source, destination, pos)
		}
		'ADDQ' {
			source := p.parse_operand()
			p.expect(.comma)
			destination := p.parse_operand()
			p.instr_addq(source, destination, pos)
		}
		'SUBQ' {
			source := p.parse_operand()
			p.expect(.comma)
			destination := p.parse_operand()
			p.instr_subq(source, destination, pos)
		}
		'XORQ' {
			source := p.parse_operand()
			p.expect(.comma)
			destination := p.parse_operand()
			p.instr_xorq(source, destination, pos)
		}
		'JMP' {
			destination := p.parse_operand()
			p.instr_jmp(destination, pos)
		}
		'CALLQ' {
			source := p.parse_operand()
			p.instr_callq(source, pos)
		}
		'LEAQ' {
			source := p.parse_operand()
			p.expect(.comma)
			destination := p.parse_operand()
			p.instr_leaq(source, destination, pos)
		}
		else {
			error.print(pos, 'unkwoun instruction `$name`')
			exit(1)
		}
	}
}

pub fn (mut p Parser) parse() {
	for p.tok.kind != .eof {
		if p.tok.kind == .eol {
			p.next()
		} else {
			p.parse_instr()
		}
	}
}

