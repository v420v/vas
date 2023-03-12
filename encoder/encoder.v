module encoder

import error
import token
import lexer

pub struct Encoder {
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

pub struct UserDefinedSection {
pub mut:
	code  []u8
	addr  int
	flags int
}

pub fn new(program string, file_name string) &Encoder {
	mut l := lexer.new(file_name, program)

	return &Encoder {
		tok: l.lex()
		lex: l
	}
}

fn (mut e Encoder) next() {
	e.tok = e.lex.lex()
}

fn (mut e Encoder) expect(exp token.TokenKind) {
	if e.tok.kind != exp {
		error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
		exit(1)
	}
	e.next()
}

fn (mut e Encoder) parse_register() Register {
	e.expect(.percent)
	pos := e.tok.pos
	reg_name := e.tok.lit.to_upper()
	if reg_name !in token.registers {
		error.print(e.tok.pos, 'invalid register name')
		exit(1)
	}
	e.next()
	return Register{
		lit: reg_name
		pos: pos
	}
}

fn (mut e Encoder) parse_factor() Expr {
	match e.tok.kind {
		.number {
			lit := e.tok.lit
			e.next()
			return Number{pos: e.tok.pos, lit: lit}
		}
		.ident {
			lit := e.tok.lit
			e.next()
			return Ident{pos: e.tok.pos, lit: lit}
		}
		else {
			error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
    		exit(1)
		}
	}
}

fn (mut e Encoder) parse_expr() Expr {
	expr := e.parse_factor()
	if e.tok.kind in [.plus, .minus] {
		op := e.tok.kind
		pos := e.tok.pos
		e.next()
		right_hs := e.parse_expr()
		return Binop{
			left_hs: expr,
			right_hs: right_hs,
			op: op,
			pos: pos
		}
	}
	return expr
}

fn (mut e Encoder) parse_operand() Expr {
    pos := e.tok.pos
    
    match e.tok.kind {
        .dolor {
            e.next()
            return Immediate{
                expr: e.parse_expr(),
                pos: pos,
            }
        }
        .percent {
            return e.parse_register()
        }
		else {
			expr := e.parse_expr()
			if e.tok.kind != .lpar {
        	    return expr
        	}
			e.next()
			regi := e.parse_register()
            e.expect(.rpar)
            return Indirection{
                expr: expr,
                regi: regi,
                pos: pos,
            }
        }
    }
	error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
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

fn (mut e Encoder) add_instr(instr &Instr) {
	e.instrs[e.current_section] << instr
}

const (
	elf_shf_write            = 0x1
	elf_shf_alloc            = 0x2
	elf_shf_execinstr        = 0x4
	elf_shf_merge            = 0x10
	elf_shf_strings          = 0x20
	elf_shf_info_link        = 0x40
	elf_shf_link_order       = 0x80
	elf_shf_os_nonconforming = 0x100
	elf_shf_group            = 0x200
	elf_shf_tls              = 0x400

	stb_local            = 0
	stb_global           = 1
)

fn section_flags(flags string) int {
	mut val := 0
	for c in flags {
		match c {
			`a` {
				val |= elf_shf_alloc
			}
			`x` {
				val |= elf_shf_execinstr
			}
			`w` {
				val |= elf_shf_write
			} else {
				panic('unkown attribute $c')
			}
		}
	}
	return val
}

fn (mut e Encoder) change_symbol_binding(instr Instr, binding u8) {
	mut s := e.defined_symbols[instr.symbol_name] or {
		error.print(instr.pos, 'undefined symbol `$instr.symbol_name`')
		exit(1)
	}
	if binding == stb_global && s.binding == stb_local {
		e.globals_count++
	}

	if binding == stb_local && s.binding == stb_global {
		e.globals_count--
	}

	if binding == stb_global && s.kind == .section {
		error.print(instr.pos, 'sections cannot be global')
		exit(1)
	}

	s.binding = binding
}

pub fn (mut e Encoder) assign_addresses() {
	e.sections['.text'] = &UserDefinedSection{
		flags: section_flags('ax')
	}
	for name, mut instrs in e.instrs {
		if name !in e.sections {
			e.sections[name] = &UserDefinedSection{}
		}
		mut section := e.sections[name] or {
			panic('PANIC')
		}

		for mut i in instrs {
			match i.kind {
				.section {
					section.flags = section_flags(i.flags)
				}
				.global {
					e.change_symbol_binding(*i, stb_global)
				}
				.local {
					e.change_symbol_binding(*i, stb_local)
				} else {}
			}

			i.addr = section.addr
			section.addr += i.code.len
			section.code << i.code
		}

		// padding
		mut padding := (encoder.align_to(section.code.len, 16) - section.code.len)
		for _ in 0 .. padding {
			section.code << 0
		}
	}
}

fn (mut e Encoder) encoder_instr() {
	pos := e.tok.pos
	mut instr := Instr{pos: pos, section: e.current_section}

	instr_name := e.tok.lit
	e.next()

	if e.tok.kind == .colon {
		instr.kind = .label
		instr.symbol_name = instr_name
		e.expect(.colon)

		if instr_name in e.defined_symbols || instr_name == '.text' {
			error.print(pos, 'symbol `$instr_name` is already defined')
			exit(1)
		}
		e.defined_symbols[instr_name] = &instr
		e.add_instr(&instr)
		return
	}

	match instr_name.to_upper() {
		'.SECTION' {
			instr.kind = .section
			name := e.tok.lit

			e.current_section = name
			instr.section = e.current_section

			e.next()
			e.expect(.comma)
			instr.section = name
			instr.flags = e.tok.lit
			e.expect(.string)
			instr.symbol_type = encoder.stt_section

			if s := e.defined_symbols[name] {
				if s.kind == .label {
					error.print(pos, 'symbol `$name` is already defined')
					exit(1)
				}
			} else {
				e.defined_symbols[name] = &instr
			}

			e.add_instr(&instr)
		}
		'RETQ', 'RET' {
			instr.kind = .ret
			instr.code = [u8(0xc3)]
			e.add_instr(&instr)
		}
		'SYSCALL' {
			instr.kind = .syscall
			instr.code = [u8(0x0f), 0x05]
			e.add_instr(&instr)
		}
		'NOPQ', 'NOP' {
			instr.kind = .nop
			instr.code = [u8(0x90)]
			e.add_instr(&instr)
		}
		'HLT' {
			instr.kind = .hlt
			instr.code = [u8(0xf4)]
			e.add_instr(&instr)
		}
		'LEAVE' {
			instr.kind = .leave
			instr.code = [u8(0xc9)]
			e.add_instr(&instr)
		}
		'.GLOBAL' {
			instr.kind = .global
			instr.symbol_name = e.tok.lit
			e.next()
			e.add_instr(&instr)
		}
		'.LOCAL' {
			instr.kind = .local
			instr.symbol_name = e.tok.lit
			e.next()
			e.add_instr(&instr)
		}
		'.STRING' {
			value := e.tok.lit
			e.expect(.string)
			e.instr_string(value, pos)
		}
		'POP', 'POPQ' {
			e.instr_pop(pos)
		}
		'PUSHQ', 'PUSH' {
			e.instr_push(pos)
		}
		'MOVQ', 'MOVL' {
			size := get_size_by_suffix(instr_name)
			e.instr_mov(size, pos)
		}
		'LEAQ', 'LEAL' {
			size := get_size_by_suffix(instr_name)
			e.instr_leaq(size, pos)
		}
		'ADDQ', 'ADDL' {
			size := get_size_by_suffix(instr_name)
			e.instr_addq(size, pos)
		}
		'SUBQ', 'SUBL' {
			size := get_size_by_suffix(instr_name)
			e.instr_subq(size, pos)
		}
		'XORQ', 'XORL' {
			size := get_size_by_suffix(instr_name)
			e.instr_xorq(size, pos)
		}
		'CMPQ', 'CMPL' {
			size := get_size_by_suffix(instr_name)
			e.instr_cmp(size, pos)
		}
		'CALLQ', 'CALL' {
			e.instr_call(pos)
		}
		'JMP', 'JMPQ' {
			e.instr_jmp(pos)
		}
		'JNE' {
			e.instr_jne(pos)
		}
		'JE' {
			e.instr_je(pos)
		}
		else {
			error.print(pos, 'unkwoun instruction `$instr_name`')
			exit(1)
		}
	}
}

pub fn (mut e Encoder) encode() {
	for e.tok.kind != .eof {
		if e.tok.kind == .eol {
			e.next()
		} else {
			e.encoder_instr()
		}
	}
}

