module assemble

import error
import token
import lexer

pub struct Assemble {
mut:
	tok             token.Token // current token
	lex             lexer.Lexer
pub mut:
	current_section string = '.text'
	instrs          map[string][]&Instr
	call_targets    []CallTarget
	rela_text_users []RelaTextUser
	variable_instrs []&Instr // variable length instructions jmp, je, jn ...
	defined_symbols map[string]&Instr
	sections        map[string]&UserDefinedSection
	globals_count   int
}

pub fn new(program string, file_name string) &Assemble {
	mut l := lexer.new(file_name, program)

	return &Assemble {
		tok: l.lex()
		lex: l
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
	a.expect(.percent)
	pos := a.tok.pos
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

fn get_size_by_suffix(name string) int {
	return match name.to_upper()[name.len-1] {
		`Q` {
			64
		}
		`L` {
			32
		} else {
			panic('PANIC')
		}
	}
}

fn (mut a Assemble) add_instr(instr &Instr) {
	a.instrs[a.current_section] << instr
}

fn (mut a Assemble) parse_instr() {
	pos := a.tok.pos
	mut instr := Instr{pos: pos, section: a.current_section}

	instr_name := a.tok.lit
	a.next()

	if a.tok.kind == .colon {
		instr.kind = .label
		instr.symbol_name = instr_name
		a.expect(.colon)

		if instr_name in a.defined_symbols || instr_name == '.text' {
			error.print(pos, 'symbol `$instr_name` is already defined')
			exit(1)
		}
		a.defined_symbols[instr_name] = &instr
		a.add_instr(&instr)
		return
	}

	match instr_name.to_upper() {
		'.SECTION' {
			instr.kind = .section
			name := a.tok.lit

			a.current_section = name
			instr.section = a.current_section

			a.next()
			a.expect(.comma)
			instr.section = name
			instr.flags = a.tok.lit
			a.expect(.string)
			instr.symbol_type = assemble.stt_section

			if s := a.defined_symbols[name] {
				if s.kind == .label {
					error.print(pos, 'symbol `$name` is already defined')
					exit(1)
				}
			} else {
				a.defined_symbols[name] = &instr
			}

			a.add_instr(&instr)
		}
		'RETQ', 'RET' {
			instr.kind = .ret
			instr.code = [u8(0xc3)]
			a.add_instr(&instr)
		}
		'SYSCALL' {
			instr.kind = .syscall
			instr.code = [u8(0x0f), 0x05]
			a.add_instr(&instr)
		}
		'NOPQ', 'NOP' {
			instr.kind = .nop
			instr.code = [u8(0x90)]
			a.add_instr(&instr)
		}
		'HLT' {
			instr.kind = .hlt
			instr.code = [u8(0xf4)]
			a.add_instr(&instr)
		}
		'LEAVE' {
			instr.kind = .leave
			instr.code = [u8(0xc9)]
			a.add_instr(&instr)
		}
		'.GLOBAL' {
			instr.kind = .global
			instr.symbol_name = a.tok.lit
			a.next()
			a.add_instr(&instr)
		}
		'.LOCAL' {
			instr.kind = .local
			instr.symbol_name = a.tok.lit
			a.next()
			a.add_instr(&instr)
		}
		'.STRING' {
			value := a.tok.lit
			a.expect(.string)
			a.instr_string(value, pos)
		}
		'POP', 'POPQ' {
			a.instr_pop(pos)
		}
		'PUSHQ', 'PUSH' {
			a.instr_push(pos)
		}
		'MOVQ', 'MOVL' {
			size := get_size_by_suffix(instr_name)
			a.instr_mov(size, pos)
		}
		'LEAQ', 'LEAL' {
			size := get_size_by_suffix(instr_name)
			a.instr_leaq(size, pos)
		}
		'ADDQ', 'ADDL' {
			size := get_size_by_suffix(instr_name)
			a.instr_addq(size, pos)
		}
		'SUBQ', 'SUBL' {
			size := get_size_by_suffix(instr_name)
			a.instr_subq(size, pos)
		}
		'XORQ', 'XORL' {
			size := get_size_by_suffix(instr_name)
			a.instr_xorq(size, pos)
		}
		'CMPQ', 'CMPL' {
			size := get_size_by_suffix(instr_name)
			a.instr_cmp(size, pos)
		}
		'CALLQ', 'CALL' {
			a.instr_call(pos)
		}
		'JMP', 'JMPQ' {
			a.instr_jmp(pos)
		}
		'JNE' {
			a.instr_jne(pos)
		}
		'JE' {
			a.instr_je(pos)
		}
		else {
			error.print(pos, 'unkwoun instruction `$instr_name`')
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

