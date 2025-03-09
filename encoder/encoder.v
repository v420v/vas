module encoder

import error
import token
import lexer
import strconv

pub struct Encoder {
mut:
	tok token.Token // current token
	l   lexer.Lexer // lexer
pub mut:
	current_section_name  string
	current_instr         &Instr
	instrs                []&Instr // All instructions, sections, symbols, directives
	rela_text_users       []Rela
	user_defined_symbols  map[string]&Instr
	user_defined_sections map[string]&UserDefinedSection
}

pub enum InstrKind {
	@none
	section
	global
	local
	hidden
	internal
	protected
	string
	byte
	word
	long
	quad
	zero
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
	movabsq
	rep
	test
	movzx
	movsx
	not
	cqto
	cltq
	cltd
	cwtl
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
	cmovs
	cmovns
	cmovg
	cmovge
	cmovl
	cmovle
	cvttss2sil
	cvtsi2ssq
	cvtsi2sdq
	cvtsd2ss
	cvtss2sd
	movss
	movsd
	movd
	ucomiss
	ucomisd
	comisd
	comiss
	subss
	subsd
	addss
	addsd
	mulss
	mulsd
	divss
	divsd
	movaps
	movups
	xorpd
	xorps
	pxor
	label
}

const stb_local            = 0
const stb_global           = 1
const stt_notype           = 0
const stt_object           = 1
const stt_func             = 2
const stt_section          = 3
const stt_file             = 4
const stt_common           = 5
const stt_tls              = 6
const stt_relc             = 8
const stt_srelc            = 9
const stt_loos             = 10
const stt_hios             = 12
const stt_loproc           = 13
const stt_hiproc           = 14
const sht_null             = 0
const sht_progbits         = 1
const sht_symtab           = 2
const sht_strtab           = 3
const sht_rela             = 4
const shf_write            = 0x1
const shf_alloc            = 0x2
const shf_execinstr        = 0x4
const shf_merge            = 0x10
const shf_strings          = 0x20
const shf_info_link        = 0x40
const shf_link_order       = 0x80
const shf_os_nonconforming = 0x100
const shf_group            = 0x200
const shf_tls              = 0x400
const r_x86_64_none        = u64(0)
const r_x86_64_64          = u64(1)
const r_x86_64_pc32        = u64(2)
const r_x86_64_got32       = u64(3)
const r_x86_64_plt32       = u64(4)
const r_x86_64_copy        = u64(5)
const r_x86_64_glob_dat    = u64(6)
const r_x86_64_jump_slot   = u64(7)
const r_x86_64_relative    = u64(8)
const r_x86_64_gotpcrel    = u64(9)
const r_x86_64_32          = u64(10)
const r_x86_64_32s         = u64(11)
const r_x86_64_16          = u64(12)
const r_x86_64_pc16        = u64(13)
const r_x86_64_8           = u64(14)
const r_x86_64_pc8         = u64(15)
const r_x86_64_pc64        = u64(24)
const stv_default          = 0
const stv_internal         = 1
const stv_hidden           = 2
const stv_protected        = 3

pub struct Instr {
pub mut:
	kind           InstrKind     @[required]
	code           []u8 = []u8{cap: 16}
	symbol_name    string
	flags          string
	addr           i64
	binding        u8
	visibility     u8 // STV_DEFAULT, STV_INTERNAL, STV_HIDDEN, STV_PROTECTED
	symbol_type    u8
	section_name   string         @[required]
	is_jmp_or_call bool
	pos            token.Position @[required]
}

pub struct Rela {
pub mut:
	uses                string
	instr               &Instr
	offset              i64
	rtype               u64
	adjust              int
	is_already_resolved bool
}

pub type Expr = Binop | Ident | Immediate | Indirection | Neg | Number | Register | Star | Xmm

pub struct Number {
pub:
	lit string
	pos token.Position
}

pub struct Star {
pub:
	regi Register
	pos  token.Position
}

pub struct Binop {
pub:
	left_hs  Expr
	right_hs Expr
	op       token.TokenKind
	pos      token.Position
}

pub struct Neg {
pub:
	expr Expr
	pos  token.Position
}

type RegiAll = Register | Xmm | Empty

pub struct Register {
pub mut:
	lit  string
	size DataSize
	base_offset u8
	rex_required bool
	pos  token.Position
}

pub struct Xmm {
pub mut:
	lit string
	size DataSize
	base_offset u8
	rex_required bool
	pos token.Position
}

struct Empty {
pub mut:
	lit string
	size DataSize
	rex_required bool
	base_offset u8
}

pub struct Immediate {
pub:
	expr Expr
	pos  token.Position
}

pub struct Indirection {
pub mut:
	disp            Expr
	base            Register
	index           Register
	scale           Expr
	pos             token.Position
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
	suffix_byte
	suffix_word
	suffix_long
	suffix_quad
	suffix_single
	suffix_double
	suffix_unkown
}

const mod_indirection_with_no_disp = u8(0)
const mod_indirection_with_disp8   = u8(1)
const mod_indirection_with_disp32  = u8(2)
const mod_regi                     = u8(3)
const rex_w                        = u8(0x48)
const operand_size_prefix16        = u8(0x66)
const slash_0                      = 0 // /0
const slash_1                      = 1 // /1
const slash_2                      = 2 // /2
const slash_3                      = 3 // /3
const slash_4                      = 4 // /4
const slash_5                      = 5 // /5
const slash_6                      = 6 // /6
const slash_7                      = 7 // /7

pub fn new(mut l lexer.Lexer, file_name string) &Encoder {
	tok := l.lex()
	mut e := &Encoder{
		tok: tok
		l: l
		current_section_name: '.text'
		instrs: []&Instr{cap: 1500000}
		current_instr: unsafe { nil }
	}
	e.add_section('.bss', 'aw', tok.pos)
	e.add_section('.data', 'aw', tok.pos)
	e.add_section('.text', 'ax', tok.pos)
	return e
}

fn (mut e Encoder) set_current_instr(kind InstrKind) {
	instr := &Instr{
		pos: e.tok.pos
		kind: kind
		section_name: e.current_section_name
	}
	e.current_instr = instr
	e.instrs << instr
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

fn (mut e Encoder) parse_register() Expr {
	e.expect(.percent)

	register_name := e.tok.lit.to_upper()

	if mut xmm_register := xmm_registers[register_name] {
		xmm_register.pos = e.tok.pos
		e.next()
		return xmm_register
	}

	if mut general_register := general_registers[register_name] {
		general_register.pos = e.tok.pos
		e.next()
		return general_register
	}

	error.print(e.tok.pos, 'unkown register `${e.tok.lit}`')
	exit(1)
}

fn (mut e Encoder) parse_factor() Expr {
	match e.tok.kind {
		.number {
			lit := e.tok.lit
			e.next()
			return Number{
				pos: e.tok.pos
				lit: lit
			}
		}
		.ident {
			lit := e.tok.lit
			e.next()
			return Ident{
				pos: e.tok.pos
				lit: lit
			}
		}
		.minus {
			e.next()
			expr := e.parse_factor()
			return Neg{
				pos: e.tok.pos
				expr: expr
			}
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
			left_hs: expr
			right_hs: right_hs
			op: op
			pos: pos
		}
	}
	return expr
}

fn (mut e Encoder) parse_two_operand() (Expr, Expr) {
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()
	return source, desti
}

fn (mut e Encoder) parse_operand() Expr {
	pos := e.tok.pos

	match e.tok.kind {
		.dolor {
			e.next()
			return Immediate{
				expr: e.parse_expr()
				pos: pos
			}
		}
		.percent {
			return e.parse_register()
		}
		.mul {
			e.expect(.mul)
			regi := e.parse_register() as Register
			return Star{
				regi: regi
				pos: pos
			}
		}
		else {
			// parse indirect
			expr := if e.tok.kind == .lpar {
				Expr(Number{
					lit: '0'
					pos: pos
				})
			} else {
				e.parse_expr()
			}
			if e.tok.kind != .lpar {
				return expr
			}
			e.next()
			mut indirection := Indirection{
				disp: expr
				pos: pos
			}
			if e.tok.kind != .comma {
				indirection.has_base = true
				indirection.base = e.parse_register() as Register
			}
			// has index and scale
			if e.tok.kind == .comma {
				indirection.has_index_scale = true
				e.next()
				indirection.index = e.parse_register() as Register
				indirection.scale = if e.tok.kind == .comma {
					e.expect(.comma)
					e.parse_expr()
				} else {
					Expr(Number{
						lit: '1'
						pos: pos
					})
				}
			}
			e.expect(.rpar)
			return indirection
		}
	}
	error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
	exit(1)
}

fn eval_expr_get_symbol_64(expr Expr, mut arr []string) i64 {
	return match expr {
		Number {
			strconv.parse_int(expr.lit, 0, 64) or {
				error.print(expr.pos, 'invalid number `expr.lit`')
				exit(1)
			}
		}
		Binop {
			match expr.op {
				.plus {
					eval_expr_get_symbol_64(expr.left_hs, mut arr) +
						eval_expr_get_symbol_64(expr.right_hs, mut arr)
				}
				.minus {
					eval_expr_get_symbol_64(expr.left_hs, mut arr) - eval_expr_get_symbol_64(expr.right_hs, mut
						arr)
				}
				.mul {
					eval_expr_get_symbol_64(expr.left_hs, mut arr) * eval_expr_get_symbol_64(expr.right_hs, mut
						arr)
				}
				.div {
					eval_expr_get_symbol_64(expr.left_hs, mut arr) / eval_expr_get_symbol_64(expr.right_hs, mut
						arr)
				}
				else {
					panic('not implemented yet')
				}
			}
		}
		Ident {
			arr << expr.lit
			0
		}
		Neg {
			eval_expr_get_symbol_64(expr.expr, mut arr) * -1
		}
		Immediate {
			eval_expr_get_symbol_64(expr.expr, mut arr)
		}
		else {
			panic('not implmented yet')
		}
	}
}

fn eval_expr(expr Expr) int {
	mut empty := []string{}
	return int(eval_expr_get_symbol_64(expr, mut empty))
}

fn get_size_by_suffix(name string) DataSize {
	return match name.to_upper()[name.len - 1] {
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
		}
		else {
			panic('unkown DataSize')
		}
	}
}

fn (regi Register) check_regi_size(size DataSize) {
	if regi.size != size {
		error.print(regi.pos, 'invalid size of register for instruction.')
		exit(0)
	}
}

fn rex(w u8, r u8, x u8, b u8) u8 {
	return 64 | (w << 3) | (r << 2) | (x << 1) | b
}

fn (mut e Encoder) add_prefix(regi_r RegiAll, regi_i RegiAll, regi_b RegiAll, sizes []DataSize) {
	mut w, mut r, mut x, mut b := u8(0), u8(0), u8(0), u8(0)

	if regi_r.base_offset >= 8 {
		r = 1
	}

	if regi_i.base_offset >= 8 {
		x = 1
	}

	if regi_b.base_offset >= 8 {
		b = 1
	}

	if DataSize.suffix_word in sizes {
		e.current_instr.code << encoder.operand_size_prefix16
	}
	if DataSize.suffix_single in sizes {
		e.current_instr.code << 0xF3
	}
	if DataSize.suffix_double in sizes {
		e.current_instr.code << 0xF2
	}
	if DataSize.suffix_quad in sizes {
		w = 1
	}

	if w != 0 || r != 0 || b != 0 || x != 0 || regi_r.rex_required || regi_b.rex_required {
		e.current_instr.code << rex(w, r, x, b)
	}
}

fn align_to(n int, align int) int {
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
		instr := Instr{
			kind: .label
			pos: pos
			section_name: e.current_section_name
			symbol_name: instr_name
		}
		e.expect(.colon)

		if instr_name in e.user_defined_symbols {
			error.print(pos, 'symbol `${instr_name}` is already defined')
			exit(1)
		}

		e.user_defined_symbols[instr_name] = &instr
		e.instrs << &instr
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
			e.instrs << &Instr{
				kind: .global
				pos: pos
				section_name: e.current_section_name
				symbol_name: e.tok.lit
			}
			e.next()
		}
		'.LOCAL' {
			e.instrs << &Instr{
				kind: .local
				pos: pos
				section_name: e.current_section_name
				symbol_name: e.tok.lit
			}
			e.next()
		}
		'.HIDDEN' {
			e.instrs << &Instr{
				kind: .hidden
				pos: pos
				section_name: e.current_section_name
				symbol_name: e.tok.lit
			}
			e.next()
		}
		'.INTERNAL' {
			e.instrs << &Instr{
				kind: .internal
				pos: pos
				section_name: e.current_section_name
				symbol_name: e.tok.lit
			}
			e.next()
		}
		'.PROTECTED' {
			e.instrs << &Instr{
				kind: .protected
				pos: pos
				section_name: e.current_section_name
				symbol_name: e.tok.lit
			}
			e.next()
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
		'MOVABSQ' {
			e.movabsq()
		}
		'TESTQ', 'TESTL', 'TESTW', 'TESTB' {
			e.test(get_size_by_suffix(instr_name_upper))
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
			e.jmp_instr(.jmp, [u8(0xE9), 0, 0, 0, 0], 1)
		}
		'JNE' {
			e.jmp_instr(.jne, [u8(0x0F), 0x85, 0, 0, 0, 0], 2)
		}
		'JE' {
			e.jmp_instr(.je, [u8(0x0F), 0x84, 0, 0, 0, 0], 2)
		}
		'JL' {
			e.jmp_instr(.jl, [u8(0x0f), 0x8C, 0, 0, 0, 0], 2)
		}
		'JG' {
			e.jmp_instr(.jg, [u8(0x0F), 0x8F, 0, 0, 0, 0], 2)
		}
		'JLE' {
			e.jmp_instr(.jle, [u8(0x0F), 0x8E, 0, 0, 0, 0], 2)
		}
		'JGE' {
			e.jmp_instr(.jge, [u8(0x0F), 0x8D, 0, 0, 0, 0], 2)
		}
		'JNB' {
			e.jmp_instr(.jnb, [u8(0x0F), 0x83, 0, 0, 0, 0], 2)
		}
		'JBE' {
			e.jmp_instr(.jbe, [u8(0x0F), 0x86, 0, 0, 0, 0], 2)
		}
		'JNBE' {
			e.jmp_instr(.jnbe, [u8(0x0F), 0x87, 0, 0, 0, 0], 2)
		}
		'JP' {
			e.jmp_instr(.jp, [u8(0x0F), 0x8A, 0, 0, 0, 0], 2)
		}
		'JA' {
			e.jmp_instr(.ja, [u8(0x0F), 0x87, 0, 0, 0, 0], 2)
		}
		'JB' {
			e.jmp_instr(.jb, [u8(0x0F), 0x82, 0, 0, 0, 0], 2)
		}
		'JS' {
			e.jmp_instr(.js, [u8(0x0F), 0x88, 0, 0, 0, 0], 2)
		}
		'JNS' {
			e.jmp_instr(.jns, [u8(0x0F), 0x89, 0, 0, 0, 0], 2)
		}
		'REP' {
			e.rep()
		}
		'CVTTSS2SIL' {
			e.cvttss2sil()
		}
		'CVTSI2SSQ' {
			e.cvtsi2ssq()
		}
		'CVTSI2SDQ' {
			e.cvtsi2sdq()
		}
		'MOVD' {
			e.movd()
		}
		'XORPD' {
			e.xorp(.xorpd, [DataSize.suffix_word])
		}
		'XORPS' {
			e.xorp(.xorps, [])
		}
		'MOVSS' {
			e.sse_data_transfer_instr(.movss, 0x10, [DataSize.suffix_single])
		}
		'MOVSD' {
			e.sse_data_transfer_instr(.movss, 0x10, [DataSize.suffix_double])
		}
		'MOVAPS' {
			e.sse_data_transfer_instr(.movaps, 0x28, [])
		}
		'MOVUPS' {
			e.sse_data_transfer_instr(.movups, 0x10, [])
		}
		'PXOR' {
			e.sse_arith_instr(.pxor, [u8(0x0F), 0xEF], [DataSize.suffix_word])
		}
		'CVTSD2SS' {
			e.sse_arith_instr(.cvtsd2ss, [u8(0x0F), 0x5A], [DataSize.suffix_double])
		}
		'CVTSS2SD' {
			e.sse_arith_instr(.cvtss2sd, [u8(0x0F), 0x5A], [DataSize.suffix_single])
		}
		'UCOMISS' {
			e.sse_arith_instr(.ucomiss, [u8(0x0F), 0x2E], [])
		}
		'UCOMISD' {
			e.sse_arith_instr(.ucomisd, [u8(0x0F), 0x2E], [DataSize.suffix_word])
		}
		'COMISS' {
			e.sse_arith_instr(.comiss, [u8(0x0F), 0x2F], [])
		}
		'COMISD' {
			e.sse_arith_instr(.ucomisd, [u8(0x0F), 0x2F], [DataSize.suffix_word])
		}
		'SUBSS' {
			e.sse_arith_instr(.subss, [u8(0x0F), 0x5C], [DataSize.suffix_single])
		}
		'SUBSD' {
			e.sse_arith_instr(.subss, [u8(0x0F), 0x5C], [DataSize.suffix_double])
		}
		'ADDSS' {
			e.sse_arith_instr(.addss, [u8(0x0F), 0x58], [DataSize.suffix_single])
		}
		'ADDSD' {
			e.sse_arith_instr(.addsd, [u8(0x0F), 0x58], [DataSize.suffix_double])
		}
		'MULSS' {
			e.sse_arith_instr(.mulss, [u8(0x0F), 0x59], [DataSize.suffix_single])
		}
		'MULSD' {
			e.sse_arith_instr(.mulsd, [u8(0x0F), 0x59], [DataSize.suffix_double])
		}
		'DIVSS' {
			e.sse_arith_instr(.divss, [u8(0x0F), 0x5E], [DataSize.suffix_single])
		}
		'DIVSD' {
			e.sse_arith_instr(.divsd, [u8(0x0F), 0x5E], [DataSize.suffix_double])
		}
		'CMOVNEQ', 'CMOVNEL', 'CMOVNEW' {
			e.cmov(.cmovs, [u8(0x0F), 0x45], get_size_by_suffix(instr_name_upper))
		}
		'CMOVSQ', 'CMOVSL', 'CMOVSW' {
			e.cmov(.cmovs, [u8(0x0F), 0x48], get_size_by_suffix(instr_name_upper))
		}
		'CMOVNSQ', 'CMOVNSL', 'CMOVNSW' {
			e.cmov(.cmovns, [u8(0x0F), 0x49], get_size_by_suffix(instr_name_upper))
		}
		'CMOVLQ', 'CMOVLL', 'CMOVLW' {
			e.cmov(.cmovl, [u8(0x0F), 0x4C], get_size_by_suffix(instr_name_upper))
		}
		'CMOVGEQ', 'CMOVGEL', 'CMOVGEW' {
			e.cmov(.cmovge, [u8(0x0F), 0x4D], get_size_by_suffix(instr_name_upper))
		}
		'CMOVLEQ', 'CMOVLEL', 'CMOVLEW' {
			e.cmov(.cmovle, [u8(0x0F), 0x4E], get_size_by_suffix(instr_name_upper))
		}
		'CMOVGQ', 'CMOVGL', 'CMOVGW' {
			e.cmov(.cmovg, [u8(0x0F), 0x4F], get_size_by_suffix(instr_name_upper))
		}
		'RETQ', 'RET' {
			e.instrs << &Instr{
				kind: .ret
				pos: pos
				section_name: e.current_section_name
				code: [u8(0xc3)]
			}
		}
		'SYSCALL' {
			e.instrs << &Instr{
				kind: .syscall
				pos: pos
				section_name: e.current_section_name
				code: [u8(0x0f), 0x05]
			}
		}
		'NOPQ', 'NOP' {
			e.instrs << &Instr{
				kind: .nop
				pos: pos
				section_name: e.current_section_name
				code: [u8(0x90)]
			}
		}
		'HLT' {
			e.instrs << &Instr{
				kind: .hlt
				pos: pos
				section_name: e.current_section_name
				code: [u8(0xf4)]
			}
		}
		'LEAVE' {
			e.instrs << &Instr{
				kind: .leave
				pos: pos
				section_name: e.current_section_name
				code: [u8(0xc9)]
			}
		}
		'CLTQ' {
			e.instrs << &Instr{
				kind: .cltq
				pos: pos
				section_name: e.current_section_name
				code: [u8(0x48), 0x98]
			}
		}
		'CLTD' {
			e.instrs << &Instr{
				kind: .cltd
				pos: pos
				section_name: e.current_section_name
				code: [u8(0x99)]
			}
		}
		'CQTO' {
			e.instrs << &Instr{
				kind: .cqto
				pos: pos
				section_name: e.current_section_name
				code: [u8(0x48), 0x99]
			}
		}
		'CWTL' {
			e.instrs << &Instr{
				kind: .cwtl
				pos: pos
				section_name: e.current_section_name
				code: [u8(0x98)]
			}
		}
		else {
			error.print(pos, 'unkwoun instruction `${instr_name}`')
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
