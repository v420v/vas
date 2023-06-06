module encoder

import error
import token
import lexer
import strconv

pub enum InstrKind {
	@none
	section
	global
	local
	string
	byte
	word
	long
	quad
	add
	sub
	instr_or
	adc
	sbb
	xor
	and
	imul
	idiv
	div
	neg
	mul
	lea
	mov
	movzx
	movsx
	not
	cqto
	cltq
	cltd
	cmp
	shl
	shr
	sar
	sal
	pop
	push
	call
	seto
	setno
	setb
	setnb
	setae
	setbe
	seta
	setpo
	setl
	setg
	setle
	setge
	sete
	setne
	jmp
	jne
	je
	jl
	jg
	jle
	jge
	jbe
	jnb
	jnbe
	jp
	ja
	js
	jb
	jns
	ret
	syscall
	nop
	hlt
	leave
	label
}

pub struct Encoder {
mut:
	tok					token.Token						// current token
	l  					lexer.Lexer						// lexer
pub mut:
	current_section		string
	instrs         		map[string][]&Instr 			// map with section name as keys and instruction list as value
	variable_instrs		[]&Instr						// variable length instructions jmp, je, jn ...
}

pub struct Instr {
pub mut:
	kind           		InstrKind [required]
	code           		[]u8 = []u8{cap: 16}
	symbol_name    		string
	flags          		string
	addr           		i64
	binding        		u8
	symbol_type    		u8
	section        		string [required]
	index          		int
	varcode        		&VariableCode = unsafe{nil}
	is_len_decided 		bool = true
	pos token.Position [required]
}

pub struct Rela {
pub mut:
	uses  				string
	instr 				&Instr
	offset				i64
	rtype 				u64
	adjust				int
	is_already_resolved	bool
}

pub struct VariableCode {
pub mut:
	trgt_symbol  string
	rel8_code    []u8
	rel8_offset  i64
	rel32_code   []u8
	rel32_offset i64
}

pub type Expr = Ident | Immediate | Register | Indirection | Number | Binop | Neg

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

pub struct Neg {
pub:
	expr Expr
	pos token.Position
}

pub struct Register {
pub:
	lit string
	size DataSize
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
	has_base        bool
	has_index_scale bool
}

pub struct Ident {
pub:
	lit string
	pos token.Position
}

pub struct UserDefinedSection {
pub mut:
	code  []u8
	addr  int
	flags int
}

enum DataSize {
	suffix_byte						= 8
	suffix_word						= 16
	suffix_long						= 32
	suffix_quad						= 64
}

pub const (
	mod_indirection_with_no_disp	= u8(0)
	mod_indirection_with_disp8  	= u8(1)
	mod_indirection_with_disp32 	= u8(2)
	mod_regi						= u8(3)
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
	r_x86_64_none	   				= u64(0)
	r_x86_64_64		   				= u64(1)
	r_x86_64_pc32	   				= u64(2)
	r_x86_64_got32	   				= u64(3)
	r_x86_64_plt32	   				= u64(4)
	r_x86_64_copy	   				= u64(5)
	r_x86_64_glob_dat  				= u64(6)
	r_x86_64_jump_slot 				= u64(7)
	r_x86_64_relative  				= u64(8)
	r_x86_64_gotpcrel  				= u64(9)
	r_x86_64_32		   				= u64(10)
	r_x86_64_32s	   				= u64(11)
	r_x86_64_16		   				= u64(12)
	r_x86_64_pc16	   				= u64(13)
	r_x86_64_8		   				= u64(14)
	r_x86_64_pc8	   				= u64(15)
	r_x86_64_pc64	   				= u64(24)

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

	r8_r15 = [
		'R8', 'R8D', 'R8W', 'R8B',
		'R9', 'R9D', 'R9W', 'R9B',
		'R10', 'R10D', 'R10W', 'R10B',
		'R11', 'R11D', 'R11W', 'R11B',
		'R12', 'R12D', 'R12W', 'R12B',
		'R13', 'R13D', 'R13W', 'R13B',
		'R14', 'R14D', 'R14W', 'R14B',
		'R15', 'R15D', 'R15W', 'R15B',
	]
)

pub fn new(mut l lexer.Lexer, file_name string) &Encoder {
	tok := l.lex()
	default_text_section := Instr{kind: .section, pos: tok.pos, section: '.text', symbol_type: encoder.stt_section, flags: 'ax'}
	user_defined_symbols = {'.text': &default_text_section}
	e := &Encoder {
		tok: tok
		l: l
		current_section: '.text'
		instrs: {'.text': [&default_text_section]}
	}
	return e
}

fn (mut e Encoder) next() {
	e.tok = e.l.lex()
}

fn (mut e Encoder) expect(exp token.TokenKind) {
	if e.tok.kind != exp {
		error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
		exit(1)
	}
	e.next()
}

fn regi_size(name string) ?DataSize {
	if name in ['RAX', 'RCX', 'RDX', 'RBX', 'RSP', 'RBP', 'RSI', 'RDI', 'RIP', 'R8', 'R9', 'R10', 'R11', 'R12', 'R13', 'R14', 'R15'] {
		return .suffix_quad
	}
	if name in ['EAX', 'ECX', 'EDX', 'EBX', 'ESP', 'EBP', 'ESI', 'EDI', 'EIP', 'R8D', 'R9D', 'R10D', 'R11D', 'R12D', 'R13D', 'R14D', 'R15D'] {
		return .suffix_long
	}
	if name in ['AX', 'CX', 'DX', 'BX', 'SP', 'BP', 'SI', 'DI', 'IP', 'R8W', 'R9W', 'R10W', 'R11W', 'R12W', 'R13W', 'R14W', 'R15W'] {
		return .suffix_word
	}
	if name in ['AL', 'CL', 'DL', 'BL', 'AH', 'CH', 'DH', 'BH', 'R8B', 'R9B', 'R10B', 'R11B', 'R12B', 'R13B', 'R14B', 'R15B'] {
		return .suffix_byte
	}

	return none
}

fn (mut e Encoder) parse_register() Register {
	e.expect(.percent)
	pos := e.tok.pos
	regi_name := e.tok.lit.to_upper()

	size := regi_size(regi_name) or {
		error.print(e.tok.pos, 'invalid register name `$regi_name`')
		exit(1)
	}

	e.next()
	return Register{
		lit: regi_name
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
		.minus {
			e.next()
			expr := e.parse_factor()
			return Neg{pos: e.tok.pos, expr: expr}
		}
		else {
			error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
    		exit(1)
		}
	}
}

fn (mut e Encoder) parse_expr() Expr {
	expr := e.parse_factor()
	if e.tok.kind in [.plus, .minus, .mul, .div] {
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
			// parse indirect
			expr := if e.tok.kind == .lpar {
				Expr(Number{lit: '0', pos: pos})
			} else {
				e.parse_expr()
			}
			if e.tok.kind != .lpar {
        	    return expr
        	}
			e.next()
			mut indirection := Indirection{
                disp: expr,
                pos: pos,
            }
			if e.tok.kind == .comma {
				indirection.has_base = false
			} else {
				indirection.has_base = true
				indirection.base = e.parse_register()
			}
			// has index and scale
			if e.tok.kind == .comma {
				indirection.has_index_scale = true
				e.next()
				indirection.index = e.parse_register()
				indirection.scale = if e.tok.kind == .comma {
					e.expect(.comma)
					e.parse_expr()
				} else {
					Expr(Number{lit: '1', pos: pos})
				}
			}
            e.expect(.rpar)
			return indirection
        }
    }
	error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
	exit(1)
}

fn eval_expr_get_symbol(expr Expr, mut arr[]string) int {
	return match expr {
		Number {
			int(strconv.parse_int(expr.lit, 0, 64) or {
                error.print(expr.pos, 'invalid number `expr.lit`')
                exit(1)
            })
		}
		Binop{
			match expr.op {
				.plus {
					eval_expr_get_symbol(expr.left_hs, mut arr) + eval_expr_get_symbol(expr.right_hs, mut arr)
				}
				.minus {
					eval_expr_get_symbol(expr.left_hs, mut arr) - eval_expr_get_symbol(expr.right_hs, mut arr)
				}
				.mul {
					eval_expr_get_symbol(expr.left_hs, mut arr) * eval_expr_get_symbol(expr.right_hs, mut arr)
				}
				.div {
					eval_expr_get_symbol(expr.left_hs, mut arr) / eval_expr_get_symbol(expr.right_hs, mut arr)
				} else {
					panic('[internal error] somthing whent wrong...')
				}
			}
		}
		Ident {
			arr << expr.lit
			0
		}
		Neg {
			eval_expr_get_symbol(expr.expr, mut arr) * -1
		}
		Immediate {
			eval_expr_get_symbol(expr.expr, mut arr)
		}
		else {
			0
		}
	}
}

fn eval_expr(expr Expr) int {
	return match expr {
		Number {
			int(strconv.parse_int(expr.lit, 0, 64) or {
                error.print(expr.pos, 'invalid number `expr.lit`')
                exit(1)
            })
		}
		Binop {
			match expr.op {
				.plus {
					eval_expr(expr.left_hs) + eval_expr(expr.right_hs)
				}
				.minus {
					eval_expr(expr.left_hs) - eval_expr(expr.right_hs)
				}
				.mul {
					eval_expr(expr.left_hs) * eval_expr(expr.right_hs)
				}
				.div {
					eval_expr(expr.left_hs) / eval_expr(expr.right_hs)
				} else {
					panic('[internal error] somthing whent wrong...')
				}
			}
		}
		Neg {
			eval_expr(expr.expr) * -1
		}
		Immediate {
			eval_expr(expr.expr)
		}
		else {
			0
		}
	}
}

fn get_size_by_suffix(name string) DataSize {
	return match name.to_upper()[name.len-1] {
		`Q` {
			DataSize.suffix_quad
		}
		`L` {
			DataSize.suffix_long
		}
		`W` {
			DataSize.suffix_word
		}
		`B` {
			DataSize.suffix_byte
		} else {
			panic('unkown DataSize')
		}
	}
}

fn (regi Register) regi_bits() u8 {
	match regi.lit {
		'RAX', 'EAX', 'AX', 'AL', 'R8', 'R8D', 'R8W', 'R8B' {
			return 0
		}
		'RCX', 'ECX', 'CX', 'CL', 'R9', 'R9D', 'R9W', 'R9B' {
			return 1
		}
		'RDX', 'EDX', 'DX', 'DL', 'R10', 'R10D', 'R10W', 'R10B' {
			return 2
		}
		'RBX', 'EBX', 'BX', 'BL', 'R11', 'R11D', 'R11W', 'R11B' {
			return 3
		}
		'RSP', 'ESP', 'SP', 'AH', 'R12', 'R12D', 'R12W', 'R12B' {
			return 4
		}
		'RBP', 'EBP', 'BP', 'CH', 'R13', 'R13D', 'R13W', 'R13B' {
			return 5
		}
		'RSI', 'ESI', 'SI', 'DH', 'R14', 'R14D', 'R14W', 'R14B' {
			return 6
		}
		'RDI', 'EDI', 'DI', 'BH', 'R15', 'R15D', 'R15W', 'R15B' {
			return 7
		} else {
			panic('unreachable')
		}
	}
}

fn (regi Register) check_regi_size(size DataSize) {
	if regi.size != size {
		error.print(regi.pos, 'invalid size of register for instruction.')
		exit(0)
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

fn (mut e Encoder) encode_instr() {
	pos := e.tok.pos

	instr_name := e.tok.lit
	instr_name_upper := instr_name.to_upper()
	e.next()

	if e.tok.kind == .colon {
		instr := Instr{kind: .label, pos: pos, section: e.current_section, symbol_name: instr_name}
		e.expect(.colon)

		if instr_name in user_defined_symbols || instr_name == '.text' {
			error.print(pos, 'symbol `$instr_name` is already defined')
			exit(1)
		}

		user_defined_symbols[instr_name] = &instr
		e.instrs[e.current_section] << &instr
		return
	}

	match instr_name_upper {
		'.SECTION' {
			e.section()
		}
		'.TEXT' {
			e.add_section('.text', 'ax', pos)
		}
		'.DATA' {
			e.add_section('.data', 'wa', pos)
		}
		'.BSS' {
			e.add_section('.bss', 'wa', pos)
		}
		'.GLOBAL', '.GLOBL' {
			instr := Instr{kind: .global, pos: pos, section: e.current_section, symbol_name: e.tok.lit}
			e.next()
			e.instrs[e.current_section] << &instr
		}
		'.LOCAL' {
			instr := Instr{kind: .local, pos: pos, section: e.current_section, symbol_name: e.tok.lit}
			e.next()
			e.instrs[e.current_section] << &instr
		}
		'.STRING' {
			e.string()
		}
		'.BYTE' {
			e.byte()
		}
		'.WORD' {
			e.word()
		}
		'.LONG' {
			e.long()
		}
		'.QUAD' {
			e.quad()
		}
		'.ZERO' {
			e.zero()
		}
		'POP', 'POPQ' {
			e.pop()
		}
		'PUSHQ', 'PUSH' {
			e.push()
		}
		'CALLQ', 'CALL' {
			e.call()
		}
		'LEAQ', 'LEAL', 'LEAW' {
			e.lea(instr_name_upper)
		}
		'NOTQ', 'NOTL', 'NOTW', 'NOTB' {
			e.one_operand_arith(.not, encoder.slash_2, get_size_by_suffix(instr_name_upper))
		}
		'NEGQ', 'NEGL', 'NEGW', 'NEGB' {
			e.one_operand_arith(.neg, encoder.slash_3, get_size_by_suffix(instr_name_upper))
		}
		'DIVQ', 'DIVL', 'DIVW', 'DIVB' {
			e.one_operand_arith(.div, encoder.slash_6, get_size_by_suffix(instr_name_upper))
		}
		'IDIVQ', 'IDIVL', 'IDIVW', 'IDIVB' {
			e.one_operand_arith(.idiv, encoder.slash_7, get_size_by_suffix(instr_name_upper))
		}
		'IMULQ', 'IMULL', 'IMULW' {
			e.imul(get_size_by_suffix(instr_name_upper))
		}
		'MULQ', 'MULL', 'MULW', 'MULB' {
			e.mul(get_size_by_suffix(instr_name_upper))
		}
		'MOVQ', 'MOVL', 'MOVW', 'MOVB' {
			e.mov(get_size_by_suffix(instr_name_upper))
		}
		'MOVZBW' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xB6], DataSize.suffix_byte, DataSize.suffix_word)
		}
		'MOVZBL' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xB6], DataSize.suffix_byte, DataSize.suffix_long)
		}
		'MOVZBQ' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xB6], DataSize.suffix_byte, DataSize.suffix_quad)
		}
		'MOVZWQ' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xB7], DataSize.suffix_word, DataSize.suffix_quad)
		}
		'MOVZWL' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xB7], DataSize.suffix_word, DataSize.suffix_long)
		}
		'MOVSBL' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xBE], DataSize.suffix_byte, DataSize.suffix_long)
		}
		'MOVSBW' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xBE], DataSize.suffix_byte, DataSize.suffix_word)
		}
		'MOVSBQ' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xBE], DataSize.suffix_byte, DataSize.suffix_quad)
		}
		'MOVSWL' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xBF], DataSize.suffix_word, DataSize.suffix_long)
		}
		'MOVSWQ' {
			e.mov_zero_or_sign_extend([u8(0x0F), 0xBF], DataSize.suffix_word, DataSize.suffix_quad)
		}
		'MOVSLQ' {
			e.mov_zero_or_sign_extend([u8(0x63)], DataSize.suffix_long, DataSize.suffix_quad)
		}
		'ADDQ', 'ADDL', 'ADDW', 'ADDB' {
			e.arith_instr(.add, 0, encoder.slash_0, get_size_by_suffix(instr_name_upper))
		}
		'ORQ', 'ORL', 'ORW', 'ORB' {
			e.arith_instr(.instr_or, 0x8, encoder.slash_1, get_size_by_suffix(instr_name_upper))
		}
		'ADCQ', 'ADCL', 'ADCW', 'ADCB' {
			e.arith_instr(.adc, 0x10, encoder.slash_2, get_size_by_suffix(instr_name_upper))
		}
		'SBBQ', 'SBBL', 'SBBW', 'SBBB' {
			e.arith_instr(.sbb, 0x18, encoder.slash_3, get_size_by_suffix(instr_name_upper))
		}
		'ANDQ', 'ANDL', 'ANDW', 'ANDB' {
			e.arith_instr(.and, 0x20, encoder.slash_4, get_size_by_suffix(instr_name_upper))
		}
		'SUBQ', 'SUBL', 'SUBW', 'SUBB' {
			e.arith_instr(.sub, 0x28, encoder.slash_5, get_size_by_suffix(instr_name_upper))
		}
		'XORQ', 'XORL', 'XORW', 'XORB' {
			e.arith_instr(.xor, 0x30, encoder.slash_6, get_size_by_suffix(instr_name_upper))
		}
		'CMPQ', 'CMPL', 'CMPW', 'CMPB' {
			e.arith_instr(.cmp, 0x38, encoder.slash_7, get_size_by_suffix(instr_name_upper))
		}
		'SHLQ', 'SHLL', 'SHLW', 'SHLB' {
			e.shift(.shl, encoder.slash_4, get_size_by_suffix(instr_name_upper))
		}
		'SHRQ', 'SHRL', 'SHRW', 'SHRB' {
			e.shift(.shr, encoder.slash_5, get_size_by_suffix(instr_name_upper))
		}
		'SARQ', 'SARL', 'SARW', 'SARB' {
			e.shift(.sar, encoder.slash_7, get_size_by_suffix(instr_name_upper))
		}
		'SALQ', 'SALL', 'SALW', 'SALB' {
			e.shift(.sal, encoder.slash_4, get_size_by_suffix(instr_name_upper))
		}
		'SETO' {
			e.set(.seto, [u8(0x0F), 0x90])
		}
		'SETNO' {
			e.set(.setno, [u8(0x0F), 0x91])
		}
		'SETB' {
			e.set(.setb, [u8(0x0F), 0x92])
		}
		'SETAE' {
			e.set(.setae, [u8(0x0F), 0x93])
		}
		'SETE' {
			e.set(.sete, [u8(0x0F), 0x94])
		}
		'SETNE' {
			e.set(.setne, [u8(0x0F), 0x95])
		}
		'SETNB' {
			e.set(.setnb, [u8(0x0F), 0x93])
		}
		'SETBE' {
			e.set(.setbe, [u8(0x0F), 0x96])
		}
		'SETA' {
			e.set(.seta, [u8(0x0F), 0x97])
		}
		'SETPO' {
			e.set(.setpo, [u8(0x0F), 0x9B])
		}
		'SETL' {
			e.set(.setl, [u8(0x0F), 0x9C])
		}
		'SETG' {
			e.set(.setg, [u8(0x0F), 0x9F])
		}
		'SETLE' {
			e.set(.setle, [u8(0x0F), 0x9E])
		}
		'SETGE' {
			e.set(.setge, [u8(0x0F), 0x9D])
		}
		'JMP' {
			e.jmp_instr(.jmp, [u8(0xEB), 0], 1, [u8(0xE9), 0, 0, 0, 0], 1)
		}
		'JNE' {
			e.jmp_instr(.jne, [u8(0x75), 0], 1, [u8(0x0F), 0x85, 0, 0, 0, 0], 2)
		}
		'JE' {
			e.jmp_instr(.je, [u8(0x74), 0], 1, [u8(0x0F), 0x84, 0, 0, 0, 0], 2)
		}
		'JL' {
			e.jmp_instr(.jl, [u8(0x7C), 0], 1, [u8(0x0f), 0x8C, 0, 0, 0, 0], 2)
		}
		'JG' {
			e.jmp_instr(.jg, [u8(0x7F), 0], 1, [u8(0x0F), 0x8F, 0, 0, 0, 0], 2)
		}
		'JLE' {
			e.jmp_instr(.jle, [u8(0x7E), 0], 1, [u8(0x0F), 0x8E, 0, 0, 0, 0], 2)
		}
		'JGE' {
			e.jmp_instr(.jge, [u8(0x7D), 0], 1, [u8(0x0F), 0x8D, 0, 0, 0, 0], 2)
		}
		'JNB' {
			e.jmp_instr(.jnb, [u8(0x73), 0], 1, [u8(0x0F), 0x83, 0, 0, 0, 0], 2)
		}
		'JBE' {
			e.jmp_instr(.jbe, [u8(0x76), 0], 1, [u8(0x0F), 0x86, 0, 0, 0, 0], 2)
		}
		'JNBE' {
			e.jmp_instr(.jnbe, [u8(0x77), 0], 1, [u8(0x0F), 0x87, 0, 0, 0, 0], 2)
		}
		'JP' {
			e.jmp_instr(.jp, [u8(0x7A), 0], 1, [u8(0x0F), 0x8A, 0, 0, 0, 0], 2)
		}
		'JA' {
			e.jmp_instr(.ja, [u8(0x77), 0], 1, [u8(0x0F), 0x87, 0, 0, 0, 0], 2)
		}
		'JB' {
			e.jmp_instr(.jb, [u8(0x72), 0], 1, [u8(0x0F), 0x82, 0, 0, 0, 0], 2)
		}
		'JS' {
			e.jmp_instr(.js, [u8(0x78), 0], 1, [u8(0x0F), 0x88, 0, 0, 0, 0], 2)
		}
		'JNS' {
			e.jmp_instr(.jns, [u8(0x79), 0], 1, [u8(0x0F), 0x89, 0, 0, 0, 0], 2)
		}
		'RETQ', 'RET' {
			e.instrs[e.current_section] << &Instr{kind: .ret, pos: pos, section: e.current_section, code: [u8(0xc3)]}
		}
		'SYSCALL' {
			e.instrs[e.current_section] << &Instr{kind: .syscall, pos: pos, section: e.current_section, code: [u8(0x0f), 0x05]}
		}
		'NOPQ', 'NOP' {
			e.instrs[e.current_section] << &Instr{kind: .nop, pos: pos, section: e.current_section, code: [u8(0x90)]}
		}
		'HLT' {
			e.instrs[e.current_section] << &Instr{kind: .hlt, pos: pos, section: e.current_section, code: [u8(0xf4)]}
		}
		'LEAVE' {
			e.instrs[e.current_section] << &Instr{kind: .leave, pos: pos, section: e.current_section, code: [u8(0xc9)]}
		}
		'CLTQ' {
			e.instrs[e.current_section] << &Instr{kind: .cltq, pos: pos, section: e.current_section, code: [u8(0x48), 0x98]}
		}
		'CLTD' {
			e.instrs[e.current_section] << &Instr{kind: .cltd, pos: pos, section: e.current_section, code: [u8(0x99)]}
		}
		'CQTO' {
			e.instrs[e.current_section] << &Instr{kind: .cqto, pos: pos, section: e.current_section, code: [u8(0x48), 0x99]}
		}
		else {
			error.print(pos, 'unkwoun instruction `$instr_name`')
			exit(1)
		}
	}
}

pub fn (mut e Encoder) encode() {
	for {
		if e.tok.kind == .eof {
			break
		}
		e.encode_instr()
	}
}

