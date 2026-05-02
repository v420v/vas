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

	operand := e.parse_operand()

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
		desti := e.parse_operand()
		mut used_symbols := []string{}
		adjust := int(eval_expr_get_symbol_64(desti, mut used_symbols))
		if used_symbols.len >= 2 {
			error.print(desti.pos, 'invalid operand')
			exit(1)
		}
		mut hex := [u8(0), 0]
		if used_symbols.len == 1 {
			e.rela_text_users << &Rela{
				uses: used_symbols[0],
				instr: e.current_instr,
				adjust: adjust,
				rtype: encoder.r_x86_64_16
			}
		} else {
			binary.little_endian_put_u16(mut &hex, u16(adjust))
		}
		e.current_instr.code << hex
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
}

// IEEE 754 double-precision (`.double`).
fn (mut e Encoder) double_data() {
	e.set_current_instr(.quad)
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
	mut used := []string{}
	val := eval_expr_get_symbol_64(e.parse_expr(), mut used)
	if used.len > 0 {
		error.print(pos, '.set/.equ with symbol references not supported (only constants)')
		exit(1)
	}
	if strict && name in e.set_aliases {
		error.print(pos, '.equiv: `${name}` already defined')
		exit(1)
	}
	e.set_aliases[name] = val
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
	if e.tok.kind == .comma {
		e.next()
		_ = eval_expr(e.parse_expr())
	}

	if sym_name in e.user_defined_symbols {
		error.print(pos, 'symbol `${sym_name}` is already defined')
		exit(1)
	}

	saved_section := e.current_section_name
	e.current_section_name = '.bss'
	defer { e.current_section_name = saved_section }

	label_instr := &Instr{
		kind: .label
		pos: pos
		section_name: '.bss'
		symbol_name: sym_name
	}
	e.user_defined_symbols[sym_name] = label_instr
	e.instrs << label_instr

	mut zero_instr := &Instr{
		kind: .zero
		pos: pos
		section_name: '.bss'
	}
	for _ in 0..size {
		zero_instr.code << 0
	}
	e.instrs << zero_instr

	if make_global {
		e.instrs << &Instr{
			kind: .global
			pos: pos
			section_name: '.bss'
			symbol_name: sym_name
		}
	}
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

fn (mut e Encoder) byte() {
	e.set_current_instr(.byte)
	for {
		desti := e.parse_operand()
		mut used_symbols := []string{}
		adjust := int(eval_expr_get_symbol_64(desti, mut used_symbols))
		if used_symbols.len >= 2 {
			error.print(desti.pos, 'invalid operand')
			exit(1)
		}
		if used_symbols.len == 1 {
			e.rela_text_users << &Rela{
				uses: used_symbols[0],
				instr: e.current_instr,
				adjust: adjust,
				rtype: encoder.r_x86_64_8
			}
			e.current_instr.code << u8(0)
		} else {
			e.current_instr.code << u8(adjust)
		}
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
		desti := e.parse_operand()
		mut used_symbols := []string{}
		adjust := int(eval_expr_get_symbol_64(desti, mut used_symbols))
		if used_symbols.len >= 2 {
			error.print(desti.pos, 'invalid operand')
			exit(1)
		}
		mut hex := [u8(0), 0, 0, 0]
		if used_symbols.len == 1 {
			e.rela_text_users << &Rela{
				uses: used_symbols[0],
				instr: e.current_instr,
				adjust: adjust,
				rtype: encoder.r_x86_64_32
			}
		} else {
			binary.little_endian_put_u32(mut &hex, u32(adjust))
		}
		e.current_instr.code << hex
		if e.tok.kind != .comma {
			break
		}
		e.next()
	}
}

fn (mut e Encoder) quad() {
	e.set_current_instr(.quad)
	for {
		desti := e.parse_operand()
		mut used_symbols := []string{}
		adjust := eval_expr_get_symbol_64(desti, mut used_symbols)
		if used_symbols.len >= 2 {
			error.print(desti.pos, 'invalid operand')
			exit(1)
		}
		mut hex := [u8(0), 0, 0, 0, 0, 0, 0, 0]
		if used_symbols.len == 1 {
			e.rela_text_users << &Rela{
				uses: used_symbols[0],
				instr: e.current_instr,
				adjust: int(adjust),
				rtype: encoder.r_x86_64_64
			}
		} else {
			binary.little_endian_put_u64(mut &hex, u64(adjust))
		}
		e.current_instr.code << hex
		if e.tok.kind != .comma {
			break
		}
		e.next()
	}
}
