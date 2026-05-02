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
	// Constant aliases declared via `.set` / `.equ`. When parse_factor sees
	// an Ident whose name is in this map, it returns a Number with the
	// stored value rather than emitting a symbol reference. Only constants
	// (no symbol-relative aliases) are supported.
	set_aliases map[string]i64
	// Section name stack for `.pushsection` / `.popsection` / `.previous`.
	// `previous_section_name` is the section we were in before the most
	// recent switch, used by `.previous` to toggle.
	section_stack         []string
	previous_section_name string
	// Per-instruction AVX-512 operand decorators (parsed once per instruction
	// in try_table_driven, consumed by emit_table during EVEX P2 emission).
	//   mask_reg     : 0..7 = K register, 8 = no mask (default)
	//   zeroing      : `{z}`           — zeroing-masking
	//   broadcast    : `{1toN}`        — set EVEX.b
	//   sae          : `{sae}`         — set EVEX.b (no rounding override)
	//   has_rounding : `{rn-sae}` etc. — set EVEX.b and override L'L with rounding mode
	//   rounding     : 0=RN, 1=RD, 2=RU, 3=RZ
	mask_reg     u8 = 8
	zeroing      bool
	broadcast    bool
	sae          bool
	has_rounding bool
	rounding     u8
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

pub type Expr = Number | Binop | Ident | Immediate | Indirection | Neg | Register | Star | Xmm

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
	// Segment override: empty string for the default segment, or one of
	// `CS`/`DS`/`ES`/`SS`/`FS`/`GS`. Only FS/GS commonly appear in 64-bit
	// code (TLS base). Set by parse_operand when it sees `%seg:expr...`
	// and read by emit_table to emit the corresponding prefix byte.
	segment string
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
	suffix_xmm128 // packed 128-bit (MOVAPS / XORPS / PXOR / etc.)
	suffix_ymm256 // packed 256-bit (AVX VMOVAPS / VPXOR / etc.)
	suffix_zmm512 // packed 512-bit (AVX-512 VADDPD / VPADDD / etc.)
	suffix_kreg   // AVX-512 mask register (K0..K7) — width depends on instruction
	suffix_fpureg // x87 stack register ST(0)..ST(7)
	suffix_seg    // segment register (CS/DS/ES/SS/FS/GS) — emits a prefix byte
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

	// AT&T x87 syntax: `%st` is ST(0), `%st(N)` is ST(N). We consume the
	// `st` ident first, then check whether `(N)` follows.
	if register_name == 'ST' {
		pos := e.tok.pos
		e.next() // consume `st`
		if e.tok.kind == .lpar {
			e.expect(.lpar)
			idx := e.tok.lit
			e.expect(.number)
			e.expect(.rpar)
			key := 'ST' + idx
			if mut st_reg := xmm_registers[key] {
				st_reg.pos = pos
				return st_reg
			}
			error.print(pos, 'unknown FPU register `%st(${idx})`')
			exit(1)
		}
		if mut st_reg := xmm_registers['ST'] {
			st_reg.pos = pos
			return st_reg
		}
	}

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
			ident_pos := e.tok.pos
			mut lit := e.tok.lit
			if at := lit.index('@') {
				lit = lit[..at]
			}
			e.next()
			// `.set` / `.equ` constants are inlined here so the rest of
			// the pipeline sees a plain integer literal.
			if val := e.set_aliases[lit] {
				return Number{
					pos: ident_pos
					lit: val.str()
				}
			}
			return Ident{
				pos: ident_pos
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
			reg := e.parse_register()
			// `%seg:disp(base, index, scale)` — segment-prefixed memory
			// operand (TLS access etc.). After consuming the segment
			// register and `:`, parse the rest as a normal memory
			// expression and stamp the segment name on the Indirection.
			if reg is Register {
				if reg.size == .suffix_seg && e.tok.kind == .colon {
					e.next()
					seg_name := reg.lit
					inner := e.parse_operand()
					if inner is Indirection {
						mut ind := inner
						ind.segment = seg_name
						return ind
					}
					return Indirection{
						disp: inner
						pos: pos
						segment: seg_name
					}
				}
			}
			return reg
		}
		.mul {
			// AT&T syntax: `*<operand>` marks an indirect call/jmp target.
			// The `*` is purely syntactic — the encoder picks rm-form or
			// rel-form based on the operand class — so consume it and
			// forward the inner operand. Handles `*%rax`, `*(%rax)`,
			// `*tab(%rip,%rax,8)` etc.
			e.next()
			return e.parse_operand()
		}
		else {
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
	return n >= -2147483648 && n <= 2147483647
}

fn compose_mod_rm(mod u8, reg_op u8, rm u8) u8 {
	return (mod << 6) + (reg_op << 3) + rm
}

fn is_noop_directive(name_upper string) bool {
	if name_upper.starts_with('.CFI_') {
		return true
	}
	return name_upper in [
		'.FILE',
		'.IDENT',
		'.TYPE',
		'.SIZE',
		'.P2ALIGN',
		'.BALIGN',
		'.ALIGN',
		'.ADDRSIG',
		'.ADDRSIG_SYM',
		'.WEAK',
		'.LOC',
		'.LINE',
		'.CV_LOC',
		'.CV_FILE',
		'.CV_FUNC_ID',
		'.CV_INLINE_SITE_ID',
		'.CV_INLINE_LINETABLE',
		'.INTEL_SYNTAX',
		'.ATT_SYNTAX',
		'.CODE64',
		'.CODE32',
		'.CODE16',
		'.SYMVER',
		'.GNU_ATTRIBUTE',
		'.SUBSECTION',
	]
}

fn (mut e Encoder) encode_instr() {
	pos := e.tok.pos

	instr_name := e.tok.lit
	instr_name_upper := instr_name.to_upper()

	if is_noop_directive(instr_name_upper) {
		e.l.skip_to_eol()
		e.next()
		return
	}

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

	if e.try_table_driven(instr_name_upper, pos) {
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
		'.STRING', '.ASCIZ' {
			e.string()
		}
		'.ASCII' {
			e.ascii()
		}
		'.BYTE' {
			e.byte()
		}
		'.WORD', '.SHORT', '.VALUE' {
			e.short()
		}
		'.LONG', '.INT' {
			e.long()
		}
		'.QUAD' {
			e.quad()
		}
		'.OCTA' {
			e.octa()
		}
		'.FLOAT', '.SINGLE' {
			e.float_data()
		}
		'.DOUBLE' {
			e.double_data()
		}
		'.ZERO' {
			e.zero()
		}
		'.SKIP', '.SPACE' {
			e.skip()
		}
		'.FILL' {
			e.fill()
		}
		'.ULEB128' {
			e.uleb128()
		}
		'.SLEB128' {
			e.sleb128()
		}
		'.SET', '.EQU' {
			e.set_directive(false)
		}
		'.EQUIV' {
			e.set_directive(true)
		}
		'.COMM' {
			e.common(true)
		}
		'.LCOMM' {
			e.common(false)
		}
		'.PUSHSECTION' {
			e.pushsection()
		}
		'.POPSECTION' {
			e.popsection()
		}
		'.PREVIOUS' {
			e.previous_section()
		}
		// All integer / branch / shift / SSE / MOVZX / MOVSX / MOVSXD / MOVABSQ
		// / CVT* mnemonics go through try_table_driven. The only legacy entry
		// that remains here is REP, which consumes a following mnemonic ident
		// rather than ordinary operands.
		'REP' {
			e.rep()
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
