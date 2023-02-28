module assemble

import error
import token
import lexer

pub struct Assemble {
mut:
	tok             token.Token // current token
	lex             lexer.Lexer
pub mut:
	instrs          []&Instr
	call_targets    []CallTarget
	rela_text_users []RelaTextUser
	variable_instrs []&Instr
	defined_symbols []&Instr
}

pub fn new(program string, file_name string) &Assemble {
	mut l := lexer.new(file_name, program)

	return &Assemble{
		tok:             l.lex()
		lex:             l
	}
}

fn (mut a Assemble) next() {
	a.tok = a.lex.lex()
}

fn (mut a Assemble) expect(exp token.TokenKind) {
	if a.tok.kind != exp {
		error.print(a.tok.pos, 'unexpected token `${a.tok.lit}`')
		exit(1)
	}
	a.next()
}

fn (mut a Assemble) parse_register() Register {
	pos := a.tok.pos
	a.expect(.percent)
	reg_name := a.tok.lit.to_upper()
	if reg_name !in token.registers {
		error.print(a.tok.pos, 'invalid register name')
		exit(1)
	}
	a.next()
	return Register{
		lit: reg_name
		pos: pos
	}
}

fn (mut a Assemble) parse_factor() Expr {
	match a.tok.kind {
		.number {
			lit := a.tok.lit
			a.next()
			return Number{pos: a.tok.pos, lit: lit}
		}
		.ident {
			lit := a.tok.lit
			a.next()
			return Ident{pos: a.tok.pos, lit: lit}
		}
		else {
			error.print(a.tok.pos, 'unexpected token `${a.tok.lit}`')
    		exit(1)
		}
	}
}

fn (mut a Assemble) parse_expr() Expr {
	expr := a.parse_factor()
	if a.tok.kind in [.plus, .minus] {
		op := a.tok.kind
		pos := a.tok.pos
		a.next()
		right_hs := a.parse_expr()
		return Binop{
			left_hs: expr,
			right_hs: right_hs,
			op: op,
			pos: pos
		}
	}
	return expr
}

fn (mut a Assemble) parse_operand() Expr {
    pos := a.tok.pos
    
    match a.tok.kind {
        .dolor {
            a.next()
            return Immediate{
                expr: a.parse_expr(),
                pos: pos,
            }
        }
        .percent {
            return a.parse_register()
        }
		else {
			expr := a.parse_expr()
			if a.tok.kind != .lpar {
        	    return expr
        	}
			a.next()
			regi := a.parse_register()
            a.expect(.rpar)
            return Indirection{
                expr: expr,
                regi: regi,
                pos: pos,
            }
        }
    }
	error.print(a.tok.pos, 'unexpected token `${a.tok.lit}`')
	exit(1)
}

fn (mut a Assemble) parse_instr() {
	pos := a.tok.pos
	mut instr := Instr{}

	name := a.tok.lit
	a.next()

	if a.tok.kind == .colon {
		instr.kind = .label
		instr.symbol_name = name
		a.expect(.colon)

		a.defined_symbols << &instr
		a.instrs << &instr
		return
	}

	match name.to_upper() {
		'.TEXT', '.DATA' {
			instr.kind = .section
			instr.section = name
			a.instrs << &instr
		}
		'RETQ' {
			instr.kind = .retq
			instr.code = [u8(0xc3)]
			a.instrs << &instr
		}
		'SYSCALL' {
			instr.kind = .syscall
			instr.code = [u8(0x0f), 0x05]
			a.instrs << &instr
		}
		'NOPQ' {
			instr.kind = .nopq
			instr.code = [u8(0x90)]
			a.instrs << &instr
		}
		'HLT' {
			instr.kind = .hlt
			instr.code = [u8(0xf4)]
			a.instrs << &instr
		}
		'LEAVE' {
			instr.kind = .leave
			instr.code = [u8(0xc9)]
			a.instrs << &instr
		}
		'.GLOBAL' {
			instr.kind = .global
			instr.symbol_name = a.tok.lit
			a.next()
			a.instrs << &instr
		}
		'.LOCAL' {
			instr.kind = .local
			instr.symbol_name = a.tok.lit
			a.next()
			a.instrs << &instr
		}
		'.STRING' {
			value := a.tok.lit
			a.expect(.string)
			a.instr_string(value)
		}
		'POPQ' {
			source := a.parse_operand()
			a.instr_popq(source)
		}
		'PUSHQ' {
			source := a.parse_operand()
			a.instr_pushq(source)
		}
		'MOVQ' {
			source := a.parse_operand()
			a.expect(.comma)
			destination := a.parse_operand()
			a.instr_movq(source, destination, pos)
		}
		'ADDQ' {
			source := a.parse_operand()
			a.expect(.comma)
			destination := a.parse_operand()
			a.instr_addq(source, destination, pos)
		}
		'SUBQ' {
			source := a.parse_operand()
			a.expect(.comma)
			destination := a.parse_operand()
			a.instr_subq(source, destination, pos)
		}
		'XORQ' {
			source := a.parse_operand()
			a.expect(.comma)
			destination := a.parse_operand()
			a.instr_xorq(source, destination, pos)
		}
		'JMP' {
			destination := a.parse_operand()
			a.instr_jmp(destination, pos)
		}
		'JNE' {
			destination := a.parse_operand()
			a.instr_jne(destination, pos)
		}
		'JE' {
			destination := a.parse_operand()
			a.instr_je(destination, pos)
		}
		'CALLQ' {
			source := a.parse_operand()
			a.instr_callq(source, pos)
		}
		'LEAQ' {
			source := a.parse_operand()
			a.expect(.comma)
			destination := a.parse_operand()
			a.instr_leaq(source, destination, pos)
		}
		else {
			error.print(pos, 'unkwoun instruction `$name`')
			exit(1)
		}
	}
}

pub fn (mut a Assemble) parse() {
	for a.tok.kind != .eof {
		if a.tok.kind == .eol {
			a.next()
		} else {
			a.parse_instr()
		}
	}
}

