module encoder

import token
import error
import encoding.binary
import strconv
import math.bits as mbits

fn (mut e Encoder) add_section(section_name string, flag string, pos token.Position) {
	e.current_section_name = section_name

	instr := Instr{kind: .section, pos: pos, section_name: section_name, symbol_type: encoder.stt_section, flags: flag}
	e.instrs << &instr

	if s := e.user_defined_symbols[section_name] {
		if s.kind == .label {
			error.print(pos, 'symbol `$section_name` is already defined')
			exit(1)
		}
	} else {
		e.user_defined_symbols[section_name] = &instr
	}
}

fn (mut e Encoder) section() {
	name, flags, pos := e.parse_section_args()
	e.add_section(name, flags, pos)
}

fn (mut e Encoder) zero() {
	e.set_current_instr(.zero)

	// `.zero N` takes a count expression, not an instruction operand — use the
	// expression parser so a bare `N` stays a Number rather than being read as
	// an absolute-memory reference.
	operand := e.parse_expr()

	n := eval_expr(operand)

	for _ in 0..n {
		e.current_instr.code << 0
	}
}

// `.skip count[, fill]` and `.space count[, fill]` reserve `count` bytes,
// optionally filling with `fill` (default 0). `.zero` is the same with the
// fill argument fixed to 0.
fn (mut e Encoder) skip() {
	e.set_current_instr(.zero)

	n := eval_expr(e.parse_expr())
	mut fill := u8(0)
	if e.tok.kind == .comma {
		e.next()
		fill = u8(eval_expr(e.parse_expr()))
	}
	for _ in 0..n {
		e.current_instr.code << fill
	}
}

// `.fill repeat[, size[, value]]`. Emits `repeat` chunks of `size` bytes
// each, with the lowest `size` bytes of `value` little-endian; truncated
// to 8 bytes since `value` is parsed as i64 in our pipeline.
fn (mut e Encoder) fill() {
	e.set_current_instr(.zero)

	repeat := eval_expr(e.parse_expr())
	mut size := 1
	mut value := i64(0)
	if e.tok.kind == .comma {
		e.next()
		size = eval_expr(e.parse_expr())
		if e.tok.kind == .comma {
			e.next()
			mut used := []string{}
			value = eval_expr_get_symbol_64(e.parse_expr(), mut used)
		}
	}
	if size <= 0 || repeat <= 0 {
		return
	}
	mut bytes := []u8{len: 8}
	binary.little_endian_put_u64(mut bytes, u64(value))
	for _ in 0..repeat {
		for j in 0..size {
			b := if j < 8 { bytes[j] } else { u8(0) }
			e.current_instr.code << b
		}
	}
}

// align_directive parses `.p2align`/`.balign`/`.align [N[, fill[, max]]]` and
// records a deferred alignment instruction. `is_p2` distinguishes the
// power-of-two form (`.p2align 4` → align 16) from the byte-count forms
// (`.balign 16`, and `.align` which on x86-64 ELF is also a byte count). The
// actual padding bytes are generated in assign_addresses, once the section
// offset is known.
fn (mut e Encoder) align_directive(is_p2 bool) {
	pos := e.tok.pos
	first := eval_expr(e.parse_expr())
	align_bytes := if is_p2 { 1 << u32(first) } else { first }

	mut fill := -1
	mut max := -1
	if e.tok.kind == .comma {
		e.next()
		// The fill argument may be empty (`.p2align 4,,15`).
		if e.tok.kind != .comma {
			fill = eval_expr(e.parse_expr())
		}
		if e.tok.kind == .comma {
			e.next()
			max = eval_expr(e.parse_expr())
		}
	}

	// Alignment of 0 or 1 never inserts padding.
	if align_bytes <= 1 {
		return
	}

	e.instrs << &Instr{
		kind:         .align
		pos:          pos
		section_name: e.current_section_name
		align_bytes:  align_bytes
		align_fill:   fill
		align_max:    max
	}
}

// nop_pattern returns the GNU as canonical multi-byte NOP encoding of length
// `n` (1..11) used to pad executable sections.
fn nop_pattern(n int) []u8 {
	return match n {
		1 { [u8(0x90)] }
		2 { [u8(0x66), 0x90] }
		3 { [u8(0x0f), 0x1f, 0x00] }
		4 { [u8(0x0f), 0x1f, 0x40, 0x00] }
		5 { [u8(0x0f), 0x1f, 0x44, 0x00, 0x00] }
		6 { [u8(0x66), 0x0f, 0x1f, 0x44, 0x00, 0x00] }
		7 { [u8(0x0f), 0x1f, 0x80, 0x00, 0x00, 0x00, 0x00] }
		8 { [u8(0x0f), 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00] }
		9 { [u8(0x66), 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00] }
		10 { [u8(0x66), 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00] }
		else { [u8(0x66), 0x66, 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00] }
	}
}

// gen_align_fill produces `pad` bytes of alignment filler. Executable sections
// with no explicit fill (or the conventional 0x90) get GNU as's optimized
// multi-byte NOPs, chunked into runs of at most 11 bytes; everything else
// repeats the fill byte (default 0).
fn gen_align_fill(pad int, is_exec bool, fill int) []u8 {
	if pad <= 0 {
		return []u8{}
	}
	use_nops := is_exec && (fill < 0 || fill == 0x90)
	if !use_nops {
		b := u8(if fill < 0 { 0 } else { fill })
		return []u8{len: pad, init: b}
	}
	mut out := []u8{cap: pad}
	mut rem := pad
	for rem > 0 {
		take := if rem > 11 { 11 } else { rem }
		out << nop_pattern(take)
		rem -= take
	}
	return out
}

// `.ascii "..."` is `.string` without a NUL terminator. Multiple
// comma-separated string literals are concatenated.
fn (mut e Encoder) ascii() {
	e.set_current_instr(.string)
	for {
		value := e.tok.lit
		e.expect(.string)
		e.current_instr.code << value.bytes()
		if e.tok.kind != .comma {
			break
		}
		e.next()
	}
}

// `.short` and `.value` are 16-bit little-endian data; same semantics as
// `.word` but accept comma-separated lists too.
fn (mut e Encoder) short() {
	e.set_current_instr(.word)
	for {
		e.emit_data_value(2, encoder.r_x86_64_16)
		if e.tok.kind != .comma {
			break
		}
		e.next()
	}
}

// `.int` is a 32-bit alias of `.long`.
fn (mut e Encoder) int_data() {
	e.long()
}

// `.octa N` emits 16 bytes — low 8 from the i64 value, high 8 zero.
// True 128-bit literals would require widening eval_expr; rarely used.
fn (mut e Encoder) octa() {
	e.set_current_instr(.quad)
	mut used := []string{}
	val := eval_expr_get_symbol_64(e.parse_expr(), mut used)
	if used.len > 0 {
		error.print(e.tok.pos, '.octa with symbol references not supported')
		exit(1)
	}
	mut lo := []u8{len: 8}
	binary.little_endian_put_u64(mut lo, u64(val))
	e.current_instr.code << lo
	for _ in 0..8 {
		e.current_instr.code << 0
	}
}

// IEEE 754 single-precision (`.float` / `.single`).
fn (mut e Encoder) float_data() {
	e.set_current_instr(.long)
	for {
		if e.tok.kind != .number {
			error.print(e.tok.pos, 'expected float literal')
			exit(1)
		}
		val64 := strconv.atof64(e.tok.lit) or {
			error.print(e.tok.pos, 'invalid float literal')
			exit(1)
		}
		e.next()
		bits32 := mbits.f32_bits(f32(val64))
		mut hex := []u8{len: 4}
		binary.little_endian_put_u32(mut hex, bits32)
		e.current_instr.code << hex
		if e.tok.kind != .comma {
			break
		}
		e.next()
	}
}

// IEEE 754 double-precision (`.double`).
fn (mut e Encoder) double_data() {
	e.set_current_instr(.quad)
	for {
		if e.tok.kind != .number {
			error.print(e.tok.pos, 'expected float literal')
			exit(1)
		}
		val := strconv.atof64(e.tok.lit) or {
			error.print(e.tok.pos, 'invalid float literal')
			exit(1)
		}
		e.next()
		bits64 := mbits.f64_bits(val)
		mut hex := []u8{len: 8}
		binary.little_endian_put_u64(mut hex, bits64)
		e.current_instr.code << hex
		if e.tok.kind != .comma {
			break
		}
		e.next()
	}
}

// `.uleb128 N`: variable-length unsigned integer (DWARF).
fn (mut e Encoder) uleb128() {
	e.set_current_instr(.byte)
	mut v := u64(eval_expr(e.parse_expr()))
	for {
		mut b := u8(v & 0x7f)
		v >>= 7
		if v != 0 {
			b |= 0x80
		}
		e.current_instr.code << b
		if v == 0 {
			break
		}
	}
}

// `.sleb128 N`: variable-length signed integer (DWARF).
fn (mut e Encoder) sleb128() {
	e.set_current_instr(.byte)
	mut v := i64(eval_expr(e.parse_expr()))
	for {
		b := u8(v & 0x7f)
		// Arithmetic shift right to preserve sign.
		v >>= 7
		sign_bit := b & 0x40
		more := !((v == 0 && sign_bit == 0) || (v == -1 && sign_bit != 0))
		if more {
			e.current_instr.code << (b | 0x80)
		} else {
			e.current_instr.code << b
			break
		}
	}
}

// `.set name, expr` / `.equ name, expr` / `.equiv name, expr`. Stores a
// constant alias resolved at parse time. `.equiv` errors on redefine.
fn (mut e Encoder) set_directive(strict bool) {
	pos := e.tok.pos
	name := e.tok.lit
	e.expect(.ident)
	e.expect(.comma)
	mut refs := []SymRef{}
	val := eval_reloc_expr(e.parse_expr(), 1, mut refs)

	// Pure constant → a parse-time alias inlined wherever the name appears.
	if refs.len == 0 {
		if strict && name in e.set_aliases {
			error.print(pos, '.equiv: `${name}` already defined')
			exit(1)
		}
		e.set_aliases[name] = val
		return
	}

	// `.set name, sym (+ const)` → a symbol alias: `name` resolves to the same
	// section as `sym`, at `sym`'s address plus the constant. The plain form
	// (const 0) is common for C++ constructor/destructor folding; the +const
	// form is gcc's overlapping-string-literal optimization (`.set .LC1,.LC52+8`
	// points .LC1 8 bytes into .LC52). Resolved after layout (the target may be
	// defined later).
	if refs.len == 1 && refs[0].coeff == 1 {
		if name in e.user_defined_symbols {
			error.print(pos, 'symbol `${name}` is already defined')
			exit(1)
		}
		e.user_defined_symbols[name] = &Instr{
			kind:         .label
			pos:          pos
			section_name: e.current_section_name
			symbol_name:  name
			alias_target: refs[0].name
			alias_addend: val
		}
		return
	}

	error.print(pos, '.set/.equ: unsupported expression (allowed: constant, or a single symbol)')
	exit(1)
}

// `.type name, @function|@object|@tls_object|...` sets the symbol's ELF type.
fn (mut e Encoder) type_directive(pos token.Position) {
	name := e.tok.lit
	e.next()
	e.expect(.comma)
	mut tname := e.tok.lit
	if tname.len > 0 && tname[0] in [`@`, `%`] {
		tname = tname[1..]
	}
	e.next()
	st := match tname {
		'function', 'gnu_indirect_function' { encoder.stt_func }
		'object', 'gnu_unique_object' { encoder.stt_object }
		'tls_object' { encoder.stt_tls }
		'common' { encoder.stt_common }
		else { encoder.stt_notype }
	}
	e.instrs << &Instr{
		kind:         .set_type
		pos:          pos
		section_name: e.current_section_name
		symbol_name:  name
		symbol_type:  u8(st)
	}
}

// `.comm sym, size[, align]` — common (global, uninitialized).
// `.lcomm sym, size[, align]` — local (static) uninitialized.
// Both emitted as zero-filled space in `.bss`. Alignment is parsed and
// discarded (the linker will align based on the symbol size in practice).
fn (mut e Encoder) common(make_global bool) {
	pos := e.tok.pos
	sym_name := e.tok.lit
	e.expect(.ident)
	e.expect(.comma)
	size := eval_expr(e.parse_expr())
	mut align := 1
	if e.tok.kind == .comma {
		e.next()
		align = eval_expr(e.parse_expr())
	}

	if sym_name in e.user_defined_symbols {
		error.print(pos, 'symbol `${sym_name}` is already defined')
		exit(1)
	}

	// `.comm`/`.lcomm` lay the symbol out in .bss. The requested alignment is
	// honored via an align directive (otherwise a `lock`-prefixed access to a
	// misaligned atomic would split-lock fault), which also raises .bss's
	// sh_addralign. Binding defaults to global for `.comm`; a preceding
	// `.local` (applied later in assign_addresses) can downgrade it.
	if align > 1 {
		e.instrs << &Instr{
			kind:         .align
			pos:          pos
			section_name: '.bss'
			align_bytes:  align
		}
	}

	label_instr := &Instr{
		kind:         .label
		pos:          pos
		section_name: '.bss'
		symbol_name:  sym_name
		binding:      if make_global { u8(encoder.stb_global) } else { u8(encoder.stb_local) }
		symbol_type:  u8(encoder.stt_object)
	}
	e.user_defined_symbols[sym_name] = label_instr
	e.instrs << label_instr

	mut zero_instr := &Instr{
		kind:         .zero
		pos:          pos
		section_name: '.bss'
	}
	for _ in 0 .. size {
		zero_instr.code << 0
	}
	e.instrs << zero_instr
}

// Shared parser for `.section` and `.pushsection`. Returns (name, flags, pos).
// Tolerates a missing flags string (just `name`) and trailing args like
// `,@progbits[,N]` which are skipped at the lexer level.
fn (mut e Encoder) parse_section_args() (string, string, token.Position) {
	pos := e.tok.pos
	if e.tok.kind !in [.ident, .string] {
		error.print(pos, 'expected section name')
		exit(1)
	}
	section_name := e.tok.lit
	e.next()
	mut flags := ''
	if e.tok.kind == .comma {
		e.next()
		if e.tok.kind == .string {
			flags = e.tok.lit
			e.next()
		}
		if e.tok.kind == .comma {
			e.l.skip_to_eol()
			e.next()
		}
	}
	return section_name, flags, pos
}

// `.pushsection name[, "flags"[, ...]]` — switch to `name`, remember the
// current section on a stack so `.popsection` can restore it.
fn (mut e Encoder) pushsection() {
	e.section_stack << e.current_section_name
	e.previous_section_name = e.current_section_name
	name, flags, pos := e.parse_section_args()
	if flags != '' && name !in e.user_defined_sections {
		e.add_section(name, flags, pos)
	} else {
		e.current_section_name = name
	}
}

fn (mut e Encoder) popsection() {
	if e.section_stack.len == 0 {
		error.print(e.tok.pos, '.popsection without matching .pushsection')
		exit(1)
	}
	saved := e.section_stack.last()
	e.section_stack.delete_last()
	e.previous_section_name = e.current_section_name
	e.current_section_name = saved
}

// `.previous` toggles between the current section and whichever section
// we were last in. With no previous section recorded, it's a no-op.
fn (mut e Encoder) previous_section() {
	if e.previous_section_name == '' {
		return
	}
	tmp := e.current_section_name
	e.current_section_name = e.previous_section_name
	e.previous_section_name = tmp
}

fn (mut e Encoder) string() {
	e.set_current_instr(.string)

	value := e.tok.lit
	e.expect(.string)

	e.current_instr.code = value.bytes()
	e.current_instr.code << 0x00
}

// emit_data_value parses one data operand and appends `width` little-endian
// bytes. A bare constant is written inline; a single `sym (± const)` records a
// relocation; a same-section difference `A - B (± const)` is recorded as a
// deferred label-difference fixup (resolved to a constant after layout, no ELF
// relocation emitted).
fn (mut e Encoder) emit_data_value(width int, rtype u64) {
	// Data directives (.byte/.word/.long/.quad/...) take a value expression, not
	// an instruction operand: a bare `5` is the constant 5, not the bytes at
	// address 5. parse_expr handles numbers, `sym@modifier`, and `A-B` label
	// differences — everything data needs — without the absolute-memory wrap.
	expr := e.parse_expr()
	mut refs := []SymRef{}
	cst := eval_reloc_expr(expr, 1, mut refs)
	offset := i64(e.current_instr.code.len)

	if refs.len == 0 {
		mut v := u64(cst)
		for _ in 0 .. width {
			e.current_instr.code << u8(v & 0xff)
			v >>= 8
		}
		return
	}

	if refs.len == 1 && refs[0].coeff == 1 {
		e.rela_text_users << Rela{
			uses:   refs[0].name
			instr:  e.current_instr
			offset: offset
			adjust: int(cst)
			rtype:  rtype
		}
		for _ in 0 .. width {
			e.current_instr.code << u8(0)
		}
		return
	}

	// Label difference: exactly one +1 term and one -1 term.
	mut plus := ''
	mut minus := ''
	mut ok := refs.len == 2
	if ok {
		for ref in refs {
			if ref.coeff == 1 && plus == '' {
				plus = ref.name
			} else if ref.coeff == -1 && minus == '' {
				minus = ref.name
			} else {
				ok = false
			}
		}
	}
	if !ok || plus == '' || minus == '' {
		error.print(e_pos(expr), 'unsupported relocatable expression (allowed: `sym`, `sym±const`, same-section `A-B`)')
		exit(1)
	}
	e.rela_text_users << Rela{
		uses:   plus
		uses2:  minus
		instr:  e.current_instr
		offset: offset
		adjust: int(cst)
		rtype:  rtype
	}
	for _ in 0 .. width {
		e.current_instr.code << u8(0)
	}
}

fn (mut e Encoder) byte() {
	e.set_current_instr(.byte)
	for {
		e.emit_data_value(1, encoder.r_x86_64_8)
		if e.tok.kind != .comma {
			break
		}
		e.next()
	}
}

fn (mut e Encoder) word() {
	e.short()
}

fn (mut e Encoder) long() {
	e.set_current_instr(.long)
	for {
		e.emit_data_value(4, encoder.r_x86_64_32)
		if e.tok.kind != .comma {
			break
		}
		e.next()
	}
}

fn (mut e Encoder) quad() {
	e.set_current_instr(.quad)
	for {
		e.emit_data_value(8, encoder.r_x86_64_64)
		if e.tok.kind != .comma {
			break
		}
		e.next()
	}
}
