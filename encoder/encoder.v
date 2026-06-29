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
	instr
	// Section & symbol-attribute directives (consumed in addr.v).
	section
	global
	local
	hidden
	internal
	protected
	weak
	set_type
	// Layout & label directives.
	label
	align
	// Data-emitting directives: the bytes live in Instr.code; the tag is intent.
	string
	byte
	word
	long
	quad
	zero
}

const stb_local            = 0
const stb_global           = 1
const stb_weak             = 2
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
const r_x86_64_dtpmod64    = u64(16)
const r_x86_64_dtpoff64    = u64(17)
const r_x86_64_tpoff64     = u64(18)
const r_x86_64_tlsgd       = u64(19)
const r_x86_64_tlsld       = u64(20)
const r_x86_64_dtpoff32    = u64(21)
const r_x86_64_gottpoff    = u64(22)
const r_x86_64_tpoff32     = u64(23)
const r_x86_64_pc64        = u64(24)
const r_x86_64_gotoff64    = u64(25)
const r_x86_64_gotpc32     = u64(26)
const r_x86_64_gotpcrelx   = u64(41)
const r_x86_64_rex_gotpcrelx = u64(42)
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
	// For kind == .align: the alignment (in bytes), the explicit fill byte
	// (-1 = default: NOPs in code, 0 in data), and the max bytes to skip
	// (-1 = unlimited). The padding bytes are materialised into `code` during
	// assign_addresses once the section offset is known.
	align_bytes int
	align_fill  int = -1
	align_max   int = -1
	// For a `.set name, sym` alias: the target symbol whose address/section
	// this symbol inherits, resolved after layout. alias_addend is the constant
	// added to the target's address for the `.set name, sym + const` form (gcc's
	// overlapping-string-literal optimization: `.set .LC1, .LC52+8`).
	alias_target string
	alias_addend i64
}

pub struct Rela {
pub mut:
	uses                string
	instr               &Instr
	offset              i64
	rtype               u64
	adjust              int
	is_already_resolved bool
	// For label-difference data (`.long A-B`): `uses` is the addend symbol
	// (+1), `uses2` the subtrahend (-1). After layout, resolve_label_diffs
	// either folds it to a constant (both endpoints in one section) or, when
	// the subtrahend anchors this data's own section, rewrites it into a
	// PC-relative relocation against `uses` using the explicit `addend` below.
	uses2 string
	// When set, the backend emits this relocation with `addend` verbatim,
	// bypassing its rtype-specific addend computation. Used for the
	// cross-section label-difference PC-relative form.
	set_addend bool
	addend     i64
}

// SymRef is one symbol term of a relocatable expression, with its integer
// coefficient (+1 for `sym`, -1 for `-sym`).
pub struct SymRef {
pub:
	name  string
	coeff int
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
	// Relocation modifier from a `sym@MODIFIER` suffix, lowercased and without
	// the `@` (e.g. `plt`, `gotpcrel`, `tpoff`, `gottpoff`, `tlsgd`). Empty for
	// a plain symbol.
	modifier string
}

pub struct UserDefinedSection {
pub mut:
	code  []u8
	addr  int
	flags int
	// Largest alignment requested in this section (via .p2align/.balign/.align),
	// written to the section header's sh_addralign. 0 is treated as 1.
	align int
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
	suffix_tbyte  // 80-bit memory (x87 long double / BCD: FLDT/FSTPT/FBLD/FBSTP)
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
			lit := e.tok.lit
			e.next()
			// A `sym@MODIFIER` suffix (e.g. `printf@PLT`, `x@tpoff`) selects a
			// relocation flavor. Capture it and keep the bare name. A modifier
			// never co-occurs with the `A-B` subtraction form, so this is
			// handled before the minus split.
			if at := lit.index('@') {
				return Ident{
					pos:      ident_pos
					lit:      lit[..at]
					modifier: lit[at + 1..].to_lower()
				}
			}
			// The lexer keeps `-` inside identifiers (for names like
			// `.note.GNU-stack`), but in an expression `A-B` is a subtraction
			// (jump-table entries `.long .L2-.L4`, `.size f, .Lend-f`). Split
			// the token back into a left-associative subtraction chain here.
			// `.set`/`.equ` constant inlining is applied per segment.
			return e.split_minus_ident(lit, ident_pos)
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

// split_minus_ident turns an identifier token that the lexer glued around `-`
// into a left-associative subtraction of its segments (e.g. `.L2-.L4-1` →
// `(.L2 - .L4) - 1`). A token with no `-` returns a single segment unchanged.
fn (mut e Encoder) split_minus_ident(lit string, pos token.Position) Expr {
	parts := lit.split('-')
	mut expr := e.seg_to_expr(parts[0], pos)
	for i := 1; i < parts.len; i++ {
		expr = Binop{
			left_hs:  expr
			right_hs: e.seg_to_expr(parts[i], pos)
			op:       .minus
			pos:      pos
		}
	}
	return expr
}

// seg_to_expr classifies one `-`-delimited segment: a `.set`/`.equ` constant is
// inlined as a Number, a digit-led segment is a numeric literal, anything else
// is a symbol reference.
fn (mut e Encoder) seg_to_expr(seg string, pos token.Position) Expr {
	if val := e.set_aliases[seg] {
		return Number{
			pos: pos
			lit: val.str()
		}
	}
	if seg.len > 0 && seg[0] >= `0` && seg[0] <= `9` {
		return Number{
			pos: pos
			lit: seg
		}
	}
	return Ident{
		pos: pos
		lit: seg
	}
}

// parse_term handles `*` and `/` (higher precedence), left-associatively.
fn (mut e Encoder) parse_term() Expr {
	mut expr := e.parse_factor()
	for e.tok.kind in [.mul, .div] {
		op := e.tok.kind
		pos := e.tok.pos
		e.next()
		right_hs := e.parse_factor()
		expr = Binop{
			left_hs: expr
			right_hs: right_hs
			op: op
			pos: pos
		}
	}
	return expr
}

// parse_expr handles `+` and `-` (lower precedence), left-associatively.
fn (mut e Encoder) parse_expr() Expr {
	mut expr := e.parse_term()
	for e.tok.kind in [.plus, .minus] {
		op := e.tok.kind
		pos := e.tok.pos
		e.next()
		right_hs := e.parse_term()
		expr = Binop{
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
				// A bare numeric literal in operand position is an absolute
				// memory reference in AT&T syntax (`movq 16, %rax` loads from
				// address 16) — not an immediate, which would need `$`. Wrap it
				// so it encodes as the disp32 absolute form. Bare symbols/labels
				// stay as-is: they're branch targets (`jmp .L5`) handled downstream.
				if expr is Number {
					return Indirection{
						disp: expr
						pos: pos
					}
				}
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

// parse_num_lit parses a non-negative numeric literal (a leading `-` is a
// separate Neg node) into its i64 bit pattern. It parses as u64 so that values
// in (i64_max, u64_max] — the 0x8000000000000000 FP sign mask, full-width
// `movabs` immediates — keep their exact bits instead of saturating at i64 max
// (which turned -9223372036854775808 into 0x8000000000000001).
fn parse_num_lit(lit string, pos token.Position) i64 {
	return i64(strconv.parse_uint(lit, 0, 64) or {
		error.print(pos, 'invalid number `${lit}`')
		exit(1)
	})
}

fn eval_expr_get_symbol_64(expr Expr, mut arr []string) i64 {
	return match expr {
		Number {
			parse_num_lit(expr.lit, expr.pos)
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
					r := eval_expr_get_symbol_64(expr.right_hs, mut arr)
					if r == 0 {
						error.print(expr.pos, 'division by zero')
						exit(1)
					}
					eval_expr_get_symbol_64(expr.left_hs, mut arr) / r
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

// eval_reloc_expr evaluates a data expression into a constant plus a list of
// symbol terms with signed coefficients (+1 for `sym`, -1 for `-sym`). `sign`
// is inherited from any enclosing subtraction/negation; start the walk with
// +1. Symbols may only be added/subtracted: a symbol inside `*` or `/` is
// rejected (those operands must reduce to constants).
fn eval_reloc_expr(expr Expr, sign int, mut refs []SymRef) i64 {
	match expr {
		Number {
			v := parse_num_lit(expr.lit, expr.pos)
			return i64(sign) * v
		}
		Ident {
			refs << SymRef{
				name:  expr.lit
				coeff: sign
			}
			return 0
		}
		Neg {
			return eval_reloc_expr(expr.expr, -sign, mut refs)
		}
		Immediate {
			return eval_reloc_expr(expr.expr, sign, mut refs)
		}
		Binop {
			match expr.op {
				.plus {
					return eval_reloc_expr(expr.left_hs, sign, mut refs) +
						eval_reloc_expr(expr.right_hs, sign, mut refs)
				}
				.minus {
					return eval_reloc_expr(expr.left_hs, sign, mut refs) +
						eval_reloc_expr(expr.right_hs, -sign, mut refs)
				}
				.mul, .div {
					mut lr := []SymRef{}
					mut rr := []SymRef{}
					l := eval_reloc_expr(expr.left_hs, 1, mut lr)
					r := eval_reloc_expr(expr.right_hs, 1, mut rr)
					if lr.len != 0 || rr.len != 0 {
						error.print(expr.pos, 'cannot multiply or divide a symbol in an expression')
						exit(1)
					}
					res := if expr.op == .mul {
						l * r
					} else {
						if r == 0 {
							error.print(expr.pos, 'division by zero')
							exit(1)
						}
						l / r
					}
					return i64(sign) * res
				}
				else {
					error.print(expr.pos, 'unsupported operator in expression')
					exit(1)
				}
			}
		}
		else {
			error.print(e_pos(expr), 'unexpected operand in data expression')
			exit(1)
		}
	}
}

// e_pos extracts the source position from any Expr variant for diagnostics.
fn e_pos(expr Expr) token.Position {
	return match expr {
		Number { expr.pos }
		Binop { expr.pos }
		Ident { expr.pos }
		Immediate { expr.pos }
		Indirection { expr.pos }
		Neg { expr.pos }
		Register { expr.pos }
		Star { expr.pos }
		Xmm { expr.pos }
	}
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
		'.SIZE',
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

// prefix_byte maps a leading prefix mnemonic to its prefix byte, or -1 if the
// mnemonic is not a prefix. LOCK/REP families prepend to the next instruction.
fn prefix_byte(name_upper string) int {
	return match name_upper {
		'LOCK' { 0xF0 }
		'REP', 'REPE', 'REPZ' { 0xF3 }
		'REPNE', 'REPNZ' { 0xF2 }
		else { -1 }
	}
}

// define_label records a `name:` definition in the current section.
fn (mut e Encoder) define_label(name string, pos token.Position) {
	if name in e.user_defined_symbols {
		error.print(pos, 'symbol `${name}` is already defined')
		exit(1)
	}
	instr := &Instr{
		kind:         .label
		pos:          pos
		section_name: e.current_section_name
		symbol_name:  name
	}
	e.user_defined_symbols[name] = instr
	e.instrs << instr
}

// prepend_prefixes inserts prefix bytes (LOCK/REP) ahead of the just-encoded
// instruction's bytes, where group-1 prefixes belong in the legacy encoding.
// Relocations recorded during this instruction's encoding (indices
// >= rela_start) now sit `prefixes.len` bytes later, so their in-instruction
// offsets are shifted to keep the patch site — and the PC-relative addend the
// backend derives from it — correct.
fn (mut e Encoder) prepend_prefixes(prefixes []u8, rela_start int) {
	mut nc := []u8{cap: prefixes.len + e.current_instr.code.len}
	nc << prefixes
	nc << e.current_instr.code
	e.current_instr.code = nc
	for i := rela_start; i < e.rela_text_users.len; i++ {
		e.rela_text_users[i].offset += prefixes.len
	}
}

fn (mut e Encoder) encode_instr() {
	pos := e.tok.pos

	// Leading prefix mnemonics (lock / rep / repe / repz / repne / repnz)
	// prepend a byte to the instruction that follows on the same line.
	mut prefixes := []u8{}
	for {
		pb := prefix_byte(e.tok.lit.to_upper())
		if pb < 0 {
			break
		}
		pname := e.tok.lit
		ppos := e.tok.pos
		e.next()
		if e.tok.kind == .colon {
			// A label that happens to be spelled like a prefix (`rep:`).
			e.expect(.colon)
			e.define_label(pname, ppos)
			return
		}
		prefixes << u8(pb)
	}

	instr_name := e.tok.lit
	instr_name_upper := instr_name.to_upper()

	if is_noop_directive(instr_name_upper) {
		e.l.skip_to_eol()
		e.next()
		return
	}

	e.next()

	if e.tok.kind == .colon {
		e.expect(.colon)
		e.define_label(instr_name, pos)
		return
	}

	rela_start := e.rela_text_users.len
	if e.try_table_driven(instr_name_upper, pos) {
		if prefixes.len > 0 {
			e.prepend_prefixes(prefixes, rela_start)
		}
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
		'.WEAK', '.WEAKREF' {
			e.instrs << &Instr{
				kind: .weak
				pos: pos
				section_name: e.current_section_name
				symbol_name: e.tok.lit
			}
			e.next()
		}
		'.TYPE' {
			e.type_directive(pos)
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
		'.P2ALIGN', '.P2ALIGNL', '.P2ALIGNW' {
			e.align_directive(true)
		}
		'.BALIGN', '.BALIGNL', '.BALIGNW', '.ALIGN' {
			e.align_directive(false)
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
		// All integer / branch / shift / SSE / string / MOVZX / MOVSX / MOVSXD /
		// MOVABSQ / CVT* mnemonics go through try_table_driven; LOCK/REP prefixes
		// are handled above. Only directives remain in this dispatch.
		else {
			error.print(pos, 'unknown instruction `${instr_name}`')
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
