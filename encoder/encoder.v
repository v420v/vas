// I know the code is messy, but it gets the job done for now.
// Leaving this comment here to remind myself to refactor it from scratch
// when I have more time. 

module encoder

import error
import token
import lexer
import encoding.binary
import strconv

pub struct Encoder {
mut:
	tok             token.Token // current token
	lex             lexer.Lexer
pub mut:
	current_section string = '.text'
	instrs          map[string][]&Instr
	rela_text_users []RelaTextUser
	variable_instrs []&Instr // variable length instructions jmp, je, jn ...
	defined_symbols map[string]&Instr
	sections        map[string]&UserDefinedSection
	globals_count   int
}

pub enum InstrKind {
	section
	global
	local
	string
	add
	sub
	imul
	idiv
	lea
	mov
	xor
	cqto
	cmp
	pop
	push
	call
	setl
	setg
	setle
	setge
	sete
	setne
	jmp
	jne
	je
	ret
	syscall
	nop
	hlt
	leave
	label
}

pub struct Instr {
pub mut:
	kind           		InstrKind
	code           		[]u8
	symbol_name    		string
	flags          		string
	addr           		i64
	binding        		u8
	symbol_type    		u8
	section        		string [required]
	index          		int
	varcode        		&VariableCode = unsafe{nil}
	is_len_decided 		bool = true
	is_already_resolved bool
	pos token.Position
}

pub struct RelaTextUser {
pub mut:
	uses   string
	instr  &Instr
	offset i64
	rtype  u64
	adjust int
}

pub struct VariableCode {
pub mut:
	trgt_symbol  string
	rel8_code    []u8
	rel8_offset  i64
	rel32_code   []u8
	rel32_offset i64
}

pub type Expr = Ident | Immediate | Register | Indirection | Number | Binop

pub struct Number {
pub:
	lit string
	pos token.Position
}

pub struct Binop {
pub:
	left_hs Expr
	right_hs Expr
	op token.TokenKind
	pos token.Position
}

pub struct Register {
pub:
	lit string
	size int
	pos token.Position
}

pub struct Immediate {
pub:
	expr 	Expr
	pos		token.Position
}

pub struct Indirection {
pub mut:
	disp 			Expr
	base 			Register
	index 			Register
	scale 			Expr
	pos 			token.Position
	has_index_scale bool
}

pub struct Ident {
pub:
	lit string
	pos token.Position
}

pub const (
	mod_indirection_with_no_disp	= u8(0b00)
	mod_indirection_with_disp8  	= u8(0b01)
	mod_indirection_with_disp32 	= u8(0b10)
	mod_regi						= u8(0b11)
	rex_w   						= u8(0x48)
	operand_size_prefix16           = u8(0x66)
	slash_0							= 0 // /0
	slash_1							= 1 // /1
	slash_2							= 2 // /2
	slash_3							= 3 // /3
	slash_4							= 4 // /4
	slash_5							= 5 // /5
	slash_6							= 6 // /6
	slash_7							= 7 // /7

	// section
	elf_shf_write            		= 0x1
	elf_shf_alloc            		= 0x2
	elf_shf_execinstr        		= 0x4
	elf_shf_merge            		= 0x10
	elf_shf_strings          		= 0x20
	elf_shf_info_link        		= 0x40
	elf_shf_link_order       		= 0x80
	elf_shf_os_nonconforming 		= 0x100
	elf_shf_group            		= 0x200
	elf_shf_tls              		= 0x400

	//  rela rtype
	r_x86_64_none	   				= 0
	r_x86_64_64		   				= 1
	r_x86_64_pc32	   				= 2
	r_x86_64_got32	   				= 3
	r_x86_64_plt32	   				= 4
	r_x86_64_copy	   				= 5
	r_x86_64_glob_dat  				= 6
	r_x86_64_jump_slot 				= 7
	r_x86_64_relative  				= 8
	r_x86_64_gotpcrel  				= 9
	r_x86_64_32		   				= 10
	r_x86_64_32s	   				= 11
	r_x86_64_16		   				= 12
	r_x86_64_pc16	   				= 13
	r_x86_64_8		   				= 14
	r_x86_64_pc8	   				= 15
	r_x86_64_pc64	   				= 24

	// symbol
	stb_local            	        = 0
	stb_global           	        = 1

	stt_notype 			 			= 0
	stt_object 			 			= 1
	stt_func 			 			= 2
	stt_section 		 			= 3
	stt_file 			 			= 4
	stt_common 			 			= 5
	stt_tls 			 			= 6
	stt_relc 			 			= 8
	stt_srelc 			 			= 9
	stt_loos 			 			= 10
	stt_hios 			 			= 12
	stt_loproc 			 			= 13
	stt_hiproc 			 			= 14
)

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

	size := regi_size(reg_name)

	e.next()
	return Register{
		lit: reg_name
		size: size
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
			mut indirection := Indirection{
                disp: expr,
                base: regi,
                pos: pos,
            }
			// has index and scale
			if e.tok.kind == .comma {
				indirection.has_index_scale = true
				e.next()
				indirection.index = e.parse_register()
				e.expect(.comma)
				indirection.scale = e.parse_expr()
			}
            e.expect(.rpar)
			return indirection
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
		}
		`W` {
			16
		}
		`B` {
			8
		} else {
			panic('panic')
		}
	}
}

fn check_regi_size(reg Register, size int) {
	if reg.size != size {
		error.print(reg.pos, 'invalid operand for instruction')
		exit(0)
	}
}

fn regi_size(name string) int {
	if name in ['AL', 'CL', 'DL', 'BL', 'AH', 'cH', 'DH', 'BH'] {
		return 8
	} else if name in ['AX', 'CX', 'DX', 'BX', 'SP', 'BP', 'SI', 'DI'] {
		return 16
	} else {
		if name[0] == `R` {
			return 64
		} else if name[0] == `E` {
			return 32
		}
	}
	panic('REGISTER SIZE NOT SUPPORTED YET!')
}

fn reg_bits(reg Register) u8 {
	match reg.lit {
		'EAX', 'RAX', 'AX', 'AL' {
			return 0
		}
		'ECX', 'RCX', 'CX', 'CL' {
			return 1
		}
		'EDX', 'RDX', 'DX', 'DL' {
			return 2
		}
		'EBX', 'RBX', 'BX', 'BL' {
			return 3
		}
		'ESP', 'RSP', 'SP', 'AH' {
			return 4
		}
		'EBP', 'RBP', 'BP', 'CH' {
			return 5
		}
		'ESI', 'RSI', 'SI', 'DH' {
			return 6
		}
		'EDI', 'RDI', 'DI', 'BH' {
			return 7
		}
		else {
			error.print(reg.pos, 'invalid operand for instruction')
			exit(1)
		}
	}
}

pub fn align_to(n int, align int) int {
	return (n + align - 1) / align * align
}

fn is_in_i8_range(n int) bool {
	return -128 <= n && n <= 127
}

fn is_in_i32_range(n int) bool {
	return n < (1 << 31)
}

fn compose_mod_rm(mod u8, reg_op u8, rm u8) u8 {
	return (mod << 6) + (reg_op << 3) + rm
}

fn compose_sib(scale u8, index u8, base u8) u8 {
	return (scale<<6) + (index<<3) + base
}

fn eval_expr(expr Expr) int {
	return match expr {
		Number {
			strconv.atoi(expr.lit) or {
                error.print(expr.pos, 'atoi() failed')
                exit(1)
            }
		}
		Binop{
			match expr.op {
				.plus {
					eval_expr(expr.left_hs) + eval_expr(expr.right_hs)
				}
				.minus {
					eval_expr(expr.left_hs) - eval_expr(expr.right_hs)
				} else {
					panic('[internal error] somthing whent wrong...')
				}
			}
		}
		else {
			0
		}
	}
}

fn (mut e Encoder) get_symbol_from_binop(expr Expr, mut arr []string) {
	match expr {
		Binop {
			e.get_symbol_from_binop(expr.left_hs, mut arr)
			e.get_symbol_from_binop(expr.right_hs, mut arr)
		}
		Ident {
			arr << expr.lit
		}
		else {
		}
	}
}

fn scale(n u8) u8 {
	match n {
		1 {
			return 0
		}
		2 {
			return 1
		}
		4 {
			return 2
		}
		8 {
			return 3
		} else {
			panic('unreachable')
		}
	}
}

// instr regi, regi
fn (mut e Encoder) encode_regi_regi(op_code []u8, regi Register, regi2 Register, mut instr &Instr, size int) {
	check_regi_size(regi, size)
	check_regi_size(regi2, size)
	mod_rm := compose_mod_rm(mod_regi, reg_bits(regi), reg_bits(regi2))

	if size == 64 {
		instr.code << encoder.rex_w
	} else if size == 16 {
		instr.code << operand_size_prefix16
	}

	instr.code << op_code
	instr.code << mod_rm
}

// instr imm, regi
fn (mut e Encoder) encode_imm_regi(slash u8, rax_magic u8, imm Immediate, regi Register, mut instr &Instr, size int) {
	num := eval_expr(imm.expr)
	check_regi_size(regi, size)

	mod_rm := compose_mod_rm(mod_regi, slash, reg_bits(regi))

	if size == 64 {
		instr.code << encoder.rex_w
	} else if size == 16 {
		instr.code << operand_size_prefix16
	}

	if size == 8 {
		if regi.lit == 'AL' {
			instr.code << [rax_magic, u8(num)]
		} else {
			instr.code << [u8(0x80), mod_rm, u8(num)]
		}
	} else if is_in_i8_range(num) {
		instr.code << [u8(0x83), mod_rm, u8(num)]
	} else if size == 16 {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(num))
		if regi.lit in ['RAX', 'EAX'] {
			instr.code << [rax_magic, hex[0], hex[1]]
		} else {
			instr.code << [u8(0x81), mod_rm, hex[0], hex[1]]
		}
	} else if is_in_i32_range(num) {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(num))
		if regi.lit in ['RAX', 'EAX'] {
			instr.code << [rax_magic, hex[0], hex[1], hex[2], hex[3]]
		} else {
			instr.code << [u8(0x81), mod_rm, hex[0], hex[1], hex[2], hex[3]]
		}
	} else {
		panic('immediate out of range!')
	}
}

fn (mut e Encoder) encode_instr() {
	pos := e.tok.pos
	mut instr := Instr{pos: pos, section: e.current_section}

	instr_name := e.tok.lit
	e.next()

	defer {
		e.instrs[e.current_section] << &instr
		if instr.varcode != unsafe { nil } {
			instr.is_len_decided = false
		}
	}

	if e.tok.kind == .colon {
		instr.kind = .label
		instr.symbol_name = instr_name
		e.expect(.colon)

		if instr_name in e.defined_symbols || instr_name == '.text' {
			error.print(pos, 'symbol `$instr_name` is already defined')
			exit(1)
		}
		e.defined_symbols[instr_name] = &instr
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
			return
		}
		'RETQ', 'RET' {
			instr.kind = .ret
			instr.code = [u8(0xc3)]
			return
		}
		'SYSCALL' {
			instr.kind = .syscall
			instr.code = [u8(0x0f), 0x05]
			return
		}
		'NOPQ', 'NOP' {
			instr.kind = .nop
			instr.code = [u8(0x90)]
			return
		}
		'HLT' {
			instr.kind = .hlt
			instr.code = [u8(0xf4)]
			return
		}
		'LEAVE' {
			instr.kind = .leave
			instr.code = [u8(0xc9)]
			return
		}
		'CQTO' {
			instr.kind = .cqto
			instr.code = [u8(0x48), 0x99]
			return
		}
		'.GLOBAL' {
			instr.kind = .global
			instr.symbol_name = e.tok.lit
			e.next()
			return
		}
		'.LOCAL' {
			instr.kind = .local
			instr.symbol_name = e.tok.lit
			e.next()
			return
		}
		'.STRING' {
			value := e.tok.lit
			e.expect(.string)

			instr.kind = .string

			instr.code = value.bytes()
			instr.code << 0x00
			return
		}
		'POP', 'POPQ' {
			instr.kind = .pop

			source := e.parse_operand()

			if source is Register {
				check_regi_size(source, 64)
				instr.code = [0x58 + reg_bits(source)]
				return
			}
			if source is Indirection {
				e.encode_indir([u8(0x8f)], slash_0, source, mut &instr, 64)
				return
			}
		}
		'PUSHQ', 'PUSH' {
			instr.kind = .push

			source := e.parse_operand()

			if source is Register {
				check_regi_size(source, 64)
				instr.code = [0x50 + reg_bits(source)]
				return
			}
			if source is Immediate {
				num := eval_expr(source.expr)
				if is_in_i8_range(num) {
					instr.code = [u8(0x6a), u8(num)]
				} else if is_in_i32_range(num) {
					mut hex := [u8(0), 0, 0, 0]
					binary.little_endian_put_u32(mut &hex, u32(num))
					instr.code = [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
				} else {
					panic('internal error')
				}
				return
			}
			if source is Indirection {
				e.encode_indir([u8(0xff)], slash_6, source, mut &instr, 64)
				return
			}
		}
		'MOVQ', 'MOVL', 'MOVW', 'MOVB' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .mov

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register && desti is Register {
				op_code := if size == 8 {
					u8(0x88)
				} else {
					u8(0x89)
				}
				e.encode_regi_regi([op_code], source, desti, mut &instr, size)
				return
			}
			if source is Indirection && desti is Register {
				op_code := if size == 8 {
					u8(0x8a)
				} else {
					u8(0x8b)
				}
				e.encode_indir_regi([op_code], source, desti, mut &instr, size)
				return
			}
			if source is Register && desti is Indirection {
				op_code := if size == 8 {
					u8(0x88)
				} else {
					u8(0x89)
				}
				e.encode_indir_regi([op_code], desti, source, mut &instr, size)
				return
			}
			if source is Immediate && desti is Register {
				check_regi_size(desti, size)
				mut mod_rm := u8(0)
				if size == 64 {
					instr.code << [encoder.rex_w, 0xc7]
					mod_rm = 0xc0 + reg_bits(desti)
				} else {
					if size == 16 {
						instr.code << operand_size_prefix16
					}
					if size == 8 {
						mod_rm = 0xB0 + reg_bits(desti)
					} else {
						mod_rm = 0xB8 + reg_bits(desti)
					}
				}
				num := eval_expr(source.expr)
				if size == 64 || size == 32 {
					mut hex := [u8(0), 0, 0, 0]
					binary.little_endian_put_u32(mut &hex, u32(num))
					instr.code << [mod_rm, hex[0], hex[1], hex[2], hex[3]]
				} else if size == 16 {
					mut hex := [u8(0), 0]
					binary.little_endian_put_u16(mut &hex, u16(num))
					instr.code << [mod_rm, hex[0], hex[1]]
				} else if size == 8 {
					instr.code << [mod_rm, u8(num)]
				} else {
					panic('UNKOWN SIZE MOV instr')
				}
				return
			}
			if source is Immediate && desti is Indirection {
				op_code := if size == 8 {
					u8(0xc6)
				} else {
					u8(0xc7)
				}
				e.encode_imm_indir([op_code], slash_0, source, desti, mut &instr, size)
				return
			}
		}
		'LEAQ', 'LEAL', 'LEAW' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .lea

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Indirection && desti is Register {
				e.encode_indir_regi([u8(0x8d)], source, desti, mut &instr, size)
				return
			}
		}
		'ADDQ', 'ADDL', 'ADDW', 'ADDB' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .add

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register && desti is Register {
				op_code := if size == 8 {
					u8(0x00)
				} else {
					u8(0x01)
				}
				e.encode_regi_regi([op_code], source, desti, mut &instr, size)
				return
			}
			if source is Immediate && desti is Register {
				rax_magic := if size == 8 {
					u8(0x04)
				} else {
					u8(0x05)
				}
				e.encode_imm_regi(0, rax_magic, source, desti, mut instr, size)
				return
			}
			if source is Indirection && desti is Register {
				op_code := if size == 8 {
					u8(0x02)
				} else {
					u8(0x03)
				}
				e.encode_indir_regi([op_code], source, desti, mut &instr, size)
				return
			}
			if source is Register && desti is Indirection {
				op_code := if size == 8 {
					u8(0x00)
				} else {
					u8(0x01)
				}
				e.encode_indir_regi([op_code], desti, source, mut &instr, size)
				return
			}
			if source is Immediate && desti is Indirection {
				imm_val := eval_expr(source.expr)
				op_code := if size == 8 {
					u8(0x80)
				} else if is_in_i8_range(imm_val) {
					u8(0x83)
				} else {
					u8(0x81)
				}
				e.encode_imm_indir([op_code], slash_0, source, desti, mut &instr, size)
				return
			}
		}
		'SUBQ', 'SUBL', 'SUBW', 'SUBB' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .sub

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register && desti is Register {
				op_code := if size == 8 {
					u8(0x28)
				} else {
					u8(0x29)
				}
				e.encode_regi_regi([op_code], source, desti, mut &instr, size)
				return
			}
			if source is Immediate && desti is Register {
				rax_magic := if size == 8 {
					u8(0x2C)
				} else {
					u8(0x2D)
				}
				e.encode_imm_regi(5, rax_magic, source, desti, mut instr, size)
				return
			}
			if source is Indirection && desti is Register {
				op_code := if size == 8 {
					u8(0x2A)
				} else {
					u8(0x2B)
				}
				e.encode_indir_regi([op_code], source, desti, mut &instr, size)
				return
			}
			if source is Register && desti is Indirection {
				op_code := if size == 8 {
					u8(0x28)
				} else {
					u8(0x29)
				}
				e.encode_indir_regi([op_code], desti, source, mut &instr, size)
				return
			}
			if source is Immediate && desti is Indirection {
				imm_val := eval_expr(source.expr)
				op_code := if size == 8 {
					u8(0x80)
				} else if is_in_i8_range(imm_val) {
					u8(0x83)
				} else {
					u8(0x81)
				}
				e.encode_imm_indir([op_code], 5, source, desti, mut &instr, size)
				return
			}
		}
		'IDIVQ', 'IDIVL', 'IDIVW', 'IDIVB' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .idiv
			source := e.parse_operand()
			op_code := if size == 8 {
				u8(0xf6)
			} else {
				u8(0xf7)
			}
			if source is Register {
				if size == 64 {
					instr.code = [encoder.rex_w]
				} else if size == 16 {
					instr.code = [encoder.operand_size_prefix16]
				}
				check_regi_size(source, size)
				instr.code << [op_code, 0xf8 + reg_bits(source)]
				return
			}
			if source is Indirection {
				e.encode_indir([op_code], slash_7, source, mut instr, size)
				return
			}
		}
		'IMULQ', 'IMULL', 'IMULW' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .imul

			source := e.parse_operand()

			if e.tok.kind != .comma {
				op_code := if size == 8 {
					u8(0xf6)
				} else {
					u8(0xf7)
				}
				if source is Register {
					if size == 64 {
						instr.code = [encoder.rex_w]
					} else if size == 16 {
						instr.code = [encoder.operand_size_prefix16]
					}
					check_regi_size(source, size)
					instr.code << [op_code, 0xe8 + reg_bits(source)]
					return
				}
				if source is Indirection {
					e.encode_indir([op_code], slash_5, source, mut instr, size)
					return
				}
			}

			e.expect(.comma)
			desti_operand_1 := e.parse_operand()

			if source is Indirection && desti_operand_1 is Register {
				e.encode_indir_regi([u8(0x0f), 0xaf], source, desti_operand_1, mut &instr, size)
				return
			}
			
			if source is Register && desti_operand_1 is Register {
				e.encode_regi_regi([u8(0x0f), 0xaf], desti_operand_1, source, mut &instr, size)
				return
			}

			e.expect(.comma)
			desti_operand_2 := e.parse_operand()

			if source is Immediate && desti_operand_1 is Register && desti_operand_2 is Register {
				check_regi_size(desti_operand_1, size)
				check_regi_size(desti_operand_2, size)
				mod_rm := compose_mod_rm(mod_regi, reg_bits(desti_operand_2), reg_bits(desti_operand_1))
				if size == 64 {
					instr.code << encoder.rex_w
				} else if size == 16 {
					instr.code << operand_size_prefix16
				}
				num := eval_expr(source.expr)
				if is_in_i8_range(num) {
					instr.code << 0x6b
					instr.code << mod_rm
					instr.code << u8(num)
				} else if size == 16 {
					instr.code << 0x69
					instr.code << mod_rm
					mut hex := [u8(0), 0]
					binary.little_endian_put_u16(mut &hex, u16(num))
					instr.code << hex
				} else {
					instr.code << 0x69
					instr.code << mod_rm
					mut hex := [u8(0), 0, 0, 0]
					binary.little_endian_put_u32(mut &hex, u32(num))
					instr.code << hex
				}
				return
			}
		}
		'XORQ', 'XORL', 'XORW', 'XORB' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .xor

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register && desti is Register {
				op_code := if size == 8 {
					u8(0x30)
				} else {
					u8(0x31)
				}
				e.encode_regi_regi([op_code], source, desti, mut &instr, size)
				return
			}
			if source is Immediate && desti is Register {
				rax_magic := if size == 8 {
					u8(0x34)
				} else {
					u8(0x35)
				}
				e.encode_imm_regi(slash_6, rax_magic, source, desti, mut instr, size)
				return
			}
			if source is Register && desti is Indirection {
				op_code := if size == 8 {
					u8(0x30)
				} else {
					u8(0x31)
				}
				e.encode_indir_regi([op_code], desti, source, mut &instr, size)
				return
			}
			if source is Immediate && desti is Indirection {
				imm_val := eval_expr(source.expr)
				op_code := if size == 8 {
					u8(0x80)
				} else if is_in_i8_range(imm_val) {
					u8(0x83)
				} else {
					u8(0x81)
				}
				e.encode_imm_indir([op_code], slash_6, source, desti, mut &instr, size)
				return
			}
		}
		'CMPQ', 'CMPL', 'CMPW', 'CMPB' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .cmp

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register && desti is Register {
				op_code := if size == 8 {
					u8(0x38)
				} else {
					u8(0x39)
				}
				e.encode_regi_regi([op_code], source, desti, mut &instr, size)
				return
			}
			if source is Immediate && desti is Register {
				rax_magic := if size == 8 {
					u8(0x3C)
				} else {
					u8(0x3D)
				}
				e.encode_imm_regi(slash_7, rax_magic, source, desti, mut instr, size)
				return
			}
			if source is Register && desti is Indirection {
				op_code := if size == 8 {
					u8(0x38)
				} else {
					u8(0x39)
				}
				e.encode_indir_regi([op_code], desti, source, mut &instr, size)
				return
			}
			if source is Immediate && desti is Indirection {
				imm_val := eval_expr(source.expr)
				op_code := if size == 8 {
					u8(0x80)
				} else if is_in_i8_range(imm_val) {
					u8(0x83)
				} else {
					u8(0x81)
				}
				e.encode_imm_indir([op_code], slash_7, source, desti, mut &instr, size)
				return
			}
		}
		'SETL' {
			instr.kind = .setl

			regi := e.parse_operand()

			if regi is Register {
				check_regi_size(regi, 8)
				mod_rm := compose_mod_rm(encoder.mod_regi, 0, reg_bits(regi))
				instr.code = [u8(0x0F), 0x9C, mod_rm]
				return
			}
		}
		'SETG' {
			instr.kind = .setg

			regi := e.parse_operand()

			if regi is Register {
				check_regi_size(regi, 8)
				mod_rm := compose_mod_rm(encoder.mod_regi, 0, reg_bits(regi))
				instr.code = [u8(0x0F), 0x9F, mod_rm]
				return
			}
		}
		'SETLE' {
			instr.kind = .setle

			regi := e.parse_operand()

			if regi is Register {
				check_regi_size(regi, 8)
				mod_rm := compose_mod_rm(encoder.mod_regi, 0, reg_bits(regi))
				instr.code = [u8(0x0F), 0x9E, mod_rm]
				return
			}
		}
		'SETGE' {
			instr.kind = .setge

			regi := e.parse_operand()

			if regi is Register {
				check_regi_size(regi, 8)
				mod_rm := compose_mod_rm(encoder.mod_regi, 0, reg_bits(regi))
				instr.code = [u8(0x0F), 0x9D, mod_rm]
				return
			}
		}
		'SETE' {
			instr.kind = .sete

			regi := e.parse_operand()

			if regi is Register {
				check_regi_size(regi, 8)
				mod_rm := compose_mod_rm(encoder.mod_regi, 0, reg_bits(regi))
				instr.code = [u8(0x0F), 0x94, mod_rm]
				return
			}
		}
		'SETNE' {
			instr.kind = .setne

			regi := e.parse_operand()

			if regi is Register {
				check_regi_size(regi, 8)
				mod_rm := compose_mod_rm(encoder.mod_regi, 0, reg_bits(regi))
				instr.code = [u8(0x0F), 0x95, mod_rm]
				return
			}
		}
		'CALLQ', 'CALL' {
			instr.kind = .call
			instr.code = [u8(0xe8), 0, 0, 0, 0]

			source := e.parse_operand()
			adjust := eval_expr(source)

			mut used_symbols := []string{}
			e.get_symbol_from_binop(source, mut &used_symbols)
			if used_symbols.len >= 2 || used_symbols.len == 0 {
				error.print(source.pos, 'invalid operand for instruction')
				exit(1)
			}

			e.rela_text_users << encoder.RelaTextUser{
				instr:  &instr,
				offset: 1,
				uses:   used_symbols[0],
				adjust: adjust,
				rtype:   encoder.r_x86_64_plt32
			}
			return
		}
		'JMP', 'JMPQ' {
			instr.kind = .jmp

			desti := e.parse_operand()

			target_sym_name := match desti {
				Ident {
					desti.lit
				} else {
					error.print(pos, 'invalid operand for instruction')
					exit(1)
				}
			}

			instr.varcode = &VariableCode{
				trgt_symbol: target_sym_name,
				rel8_code:   [u8(0xeb), 0],
				rel8_offset: 1,
				rel32_code:   [u8(0xe9), 0, 0, 0, 0],
				rel32_offset: 1,
			}

			e.variable_instrs << &instr
			return
		}
		'JNE' {
			instr.kind = .jne
			desti := e.parse_operand()

			target_sym_name := match desti {
				Ident {
					desti.lit
				} else {
					error.print(pos, 'invalid operand for instruction')
					exit(1)
				}
			}

			instr.varcode = &VariableCode{
				trgt_symbol: target_sym_name,
				rel8_code:   [u8(0x75), 0],
				rel8_offset: 1,
				rel32_code:   [u8(0x0f), 0x85, 0, 0, 0, 0],
				rel32_offset: 2,
			}

			e.variable_instrs << &instr
			return
		}
		'JE' {
			instr.kind = .je
			desti := e.parse_operand()

			target_sym_name := match desti {
				Ident {
					desti.lit
				} else {
					error.print(pos, 'invalid operand for instruction')
					exit(1)
				}
			}

			instr.varcode =  &VariableCode{
				trgt_symbol: target_sym_name,
				rel8_code:   [u8(0x74), 0],
				rel8_offset: 1,
				rel32_code:   [u8(0x0f), 0x84, 0, 0, 0, 0],
				rel32_offset: 2,
			}

			e.variable_instrs << &instr
			return
		}
		else {
			error.print(pos, 'unkwoun instruction `$instr_name`')
			exit(1)
		}
	}
	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

pub fn (mut e Encoder) encode() {
	for e.tok.kind != .eof {
		if e.tok.kind == .eol {
			e.next()
		} else {
			e.encode_instr()
		}
	}
}

