module encoder

import error
import token
import encoding.binary

// try_table_driven attempts to encode the current instruction (whose mnemonic
// has already been consumed by `e.next()`) using the data-driven table.
// Returns true if the instruction was handled; false if the mnemonic is not
// covered by the table and the legacy match dispatcher should run instead.
fn (mut e Encoder) try_table_driven(instr_name_upper string, pos token.Position) bool {
	c := canonicalize_mnemonic(instr_name_upper)
	if !c.ok {
		return false
	}

	e.set_current_instr(canon_to_kind(c.name))
	// Reset per-instruction AVX-512 decorator state (sticky from the previous
	// instruction otherwise).
	e.mask_reg = 8
	e.zeroing = false
	e.broadcast = false
	e.sae = false
	e.has_rounding = false
	e.rounding = 0

	mut ops := []Expr{}
	// Zero-operand mnemonics are settled by the canonical name alone; for the
	// rest, the lexer doesn't emit newlines, so we cannot use the next token
	// to decide whether operands follow.
	if !is_zero_operand(c.name) {
		ops << e.parse_operand()
		e.consume_avx512_decorators(pos)
		for e.tok.kind == .comma {
			e.next()
			ops << e.parse_operand()
			e.consume_avx512_decorators(pos)
		}
	}

	// AT&T → Intel: GAS AT&T reverses the operand order. We always reverse,
	// regardless of arity (works for 1-op no-ops too — it's a no-op).
	if ops.len > 1 {
		mut rev := []Expr{cap: ops.len}
		for i := ops.len - 1; i >= 0; i-- {
			rev << ops[i]
		}
		ops = rev.clone()
	}

	// Memory-operand size for AVX/AVX-512 is determined by the xmm/ymm/zmm
	// sibling: when canonicalize returned `suffix_unkown` (a V-prefixed
	// mnemonic), look at the first Xmm operand to infer the width. zmm wins
	// over ymm wins over xmm so a wider operand always promotes the memory
	// side.
	mut implied := DataSize.suffix_unkown
	for op in ops {
		if op is Xmm {
			if op.size == .suffix_zmm512 {
				implied = .suffix_zmm512
				break
			} else if op.size == .suffix_ymm256 {
				implied = .suffix_ymm256
			} else if op.size == .suffix_xmm128 && implied != .suffix_ymm256 {
				implied = .suffix_xmm128
			}
		}
	}

	// Size hint per operand position. In Intel order: ops[0] = dst, ops[1] = src.
	// For symmetric instructions src_size == dst_size, so this collapses; for
	// V-prefixed mnemonics (size unknown) we fall back to the implied width.
	mut classes := []OpClass{}
	for i, op in ops {
		mut sz := if i == 0 { c.dst_size } else { c.src_size }
		if sz == .suffix_unkown && implied != .suffix_unkown {
			sz = implied
		}
		classes << classify_operand(op, sz)
	}

	// AVX-512-only decorators force the EVEX-encoded row.
	require_evex := e.mask_reg < 8 || e.zeroing || e.broadcast || e.sae || e.has_rounding
	// Extract immediate literal value for sign-extending ib-form filtering in
	// find_best_match.  If no immediate or it uses a symbol, leave as 0.
	mut imm_literal := i64(0)
	for op in ops {
		if op is Immediate {
			mut syms := []string{}
			v := eval_expr_get_symbol_64(op.expr, mut syms)
			if syms.len == 0 {
				imm_literal = v
			}
			break
		}
	}
	mut m, mut found := find_best_match(c.name, classes, require_evex, imm_literal)
	if !found && c.alt_name != '' {
		// Fall back to the alternate spelling (e.g. MOVQ as the SSE2 mnemonic
		// when the integer MOV row didn't match the parsed xmm operands).
		m, found = find_best_match(c.alt_name, classes, require_evex, imm_literal)
	}
	if !found {
		// Build a richer diagnostic that lists the closest near-misses.
		mut msg := 'no encoding for `${instr_name_upper}` ${op_class_list_str(classes)}'
		mut cands := collect_candidates(c.name, classes)
		if c.alt_name != '' {
			cands << collect_candidates(c.alt_name, classes)
		}
		if cands.len == 0 {
			msg += '\n  no rows with this mnemonic + ${classes.len} operand(s)'
		} else {
			// Show up to the 4 closest (cands is sorted by mismatch_at desc).
			// Dedupe by operand spec — multiple identical rows (e.g. ND
			// variants) would otherwise clutter the diagnostic.
			mut seen := map[string]bool{}
			mut shown := 0
			msg += '\n  candidates:'
			for cand in cands {
				if shown >= 4 {
					break
				}
				key := op_class_list_str(cand.enc.operands)
				if key in seen {
					continue
				}
				seen[key] = true
				msg += '\n    ${cand.enc.mnemonic} ${key}'
				if cand.mismatch_at < cand.enc.operands.len {
					req := op_class_str(cand.enc.operands[cand.mismatch_at])
					got := op_class_str(classes[cand.mismatch_at])
					msg += '  -- operand ${cand.mismatch_at}: want ${req}, got ${got}'
				}
				shown++
			}
			extra := cands.len - shown
			if extra > 0 {
				msg += '\n    ... and ${extra} more'
			}
		}
		error.print(pos, msg)
		exit(1)
	}

	e.emit_table(lookup_row(m), ops)
	return true
}


// emit_table is the generic emitter: it walks one InstrEnc row and the
// (already Intel-ordered) operand list, and appends the encoded bytes to
// e.current_instr.code. Reuses existing primitives:
//   - add_segment_override_prefix: 0x67 for 32-bit indirection
//   - rex / add_modrm_sib_disp / compose_mod_rm
//   - add_imm_rela / add_imm_value2: immediate emission with optional relocation
// consume_avx512_decorators parses any trailing `{...}` blocks following an
// operand and folds them into the per-instruction Encoder state. Decorators
// can attach to any operand, not just the last one — broadcast `{1to8}` for
// example sits on the memory source.
fn (mut e Encoder) consume_avx512_decorators(pos token.Position) {
	for e.tok.kind == .lbrace {
		e.next()
		if e.tok.kind == .percent {
			kop := e.parse_register()
			if kop is Xmm && kop.size == .suffix_kreg {
				e.mask_reg = kop.base_offset
			} else {
				error.print(pos, 'mask decorator requires a `%kN` register')
				exit(1)
			}
		} else if e.tok.kind == .ident {
			match e.tok.lit {
				'z' { e.zeroing = true }
				'sae' { e.sae = true }
				'rn-sae' {
					e.has_rounding = true
					e.rounding = 0
				}
				'rd-sae' {
					e.has_rounding = true
					e.rounding = 1
				}
				'ru-sae' {
					e.has_rounding = true
					e.rounding = 2
				}
				'rz-sae' {
					e.has_rounding = true
					e.rounding = 3
				}
				else {} // unrecognised — drained below
			}
			e.next()
		} else if e.tok.kind == .number && e.tok.lit == '1' {
			// `{1toN}` broadcast — N is determined by element size, not
			// encoded literally. We just flag that broadcast is requested.
			e.next()
			if e.tok.kind == .ident && e.tok.lit.starts_with('to') {
				e.broadcast = true
				e.next()
			}
		} else {
			for e.tok.kind !in [.rbrace, .eof] {
				e.next()
			}
		}
		e.expect(.rbrace)
	}
}

// xmm_to_reg shapes an Xmm into a Register so the rest of the emitter can
// treat reg slots uniformly. Only the encoding-relevant fields are copied.
fn xmm_to_reg(x Xmm) Register {
	return Register{
		lit:          x.lit
		size:         x.size
		base_offset:  x.base_offset
		rex_required: x.rex_required
		pos:          x.pos
	}
}

// reg_from_op extracts a register-shaped value from an operand that is a
// general-purpose Register or an Xmm.
fn reg_from_op(op Expr, ctx string) Register {
	match op {
		Register { return op }
		Xmm { return xmm_to_reg(op) }
		else { panic('emit_table: ${ctx} expected reg or xmm') }
	}
}

// rm_from_op decomposes a Register/Xmm/Indirection into the (kind, reg, indir)
// triple the emitter uses for r/m slots. kind: 1 = register-shaped, 2 = memory.
fn rm_from_op(op Expr, ctx string) (int, Register, Indirection) {
	match op {
		Register { return 1, op, Indirection{} }
		Xmm { return 1, xmm_to_reg(op), Indirection{} }
		Indirection { return 2, Register{
			size: .suffix_unkown
		}, op }
		else { panic('emit_table: ${ctx} expected reg/xmm/mem') }
	}
}

fn (mut e Encoder) emit_table(enc &InstrEnc, ops []Expr) {
	mut has_reg := false
	mut reg_slot := Register{
		size: .suffix_unkown
	}
	mut rm_kind := 0 // 0=none, 1=Register-or-Xmm, 2=Indirection
	mut rm_reg := Register{
		size: .suffix_unkown
	}
	mut rm_indir := Indirection{}
	mut imm_idx := -1
	mut label_idx := -1
	mut has_vvvv := false
	mut vvvv_slot := Register{
		size: .suffix_unkown
	}
	mut has_is4 := false
	mut is4_slot := Register{
		size: .suffix_unkown
	}

	match enc.op_order {
		.zo {}
		.r {
			reg_slot = reg_from_op(ops[0], '/r')
			has_reg = true
		}
		.m {
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[0], '/m')
		}
		.i {
			op0 := ops[0]
			match op0 {
				Immediate { imm_idx = 0 }
				Ident { label_idx = 0 }
				else { panic('emit_table: /i expected imm or label') }
			}
		}
		.mr {
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[0], '/mr slot 0')
			reg_slot = reg_from_op(ops[1], '/mr slot 1')
			has_reg = true
		}
		.rm {
			reg_slot = reg_from_op(ops[0], '/rm slot 0')
			has_reg = true
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[1], '/rm slot 1')
		}
		.mi {
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[0], '/mi slot 0')
			imm_idx = 1
		}
		.ri {
			reg_slot = reg_from_op(ops[0], '/ri slot 0')
			has_reg = true
			imm_idx = 1
		}
		.rmi {
			reg_slot = reg_from_op(ops[0], '/rmi slot 0')
			has_reg = true
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[1], '/rmi slot 1')
			imm_idx = 2
		}
		.m1 {
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[0], '/m1 slot 0')
		}
		.mc {
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[0], '/mc slot 0')
		}
		.r_skip {
			// x87 2-op `fadd %st(i), %st` etc. — first operand encoded as +r,
			// second is the implicit ST(0).
			reg_slot = reg_from_op(ops[0], '/r_skip slot 0')
			has_reg = true
		}
		.skip_r {
			// x87 2-op `fadd %st, %st(i)` etc. — first operand is implicit
			// ST(0), second encoded as +r.
			reg_slot = reg_from_op(ops[1], '/skip_r slot 1')
			has_reg = true
		}
		.rvm {
			// VEX 3-op: dst→reg, src1→VEX.vvvv, src2→r/m.
			reg_slot = reg_from_op(ops[0], '/rvm slot 0')
			has_reg = true
			vvvv_slot = reg_from_op(ops[1], '/rvm slot 1')
			has_vvvv = true
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[2], '/rvm slot 2')
		}
		.mvr {
			// VEX 3-op store form: dst→r/m, src1→VEX.vvvv, src2→reg.
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[0], '/mvr slot 0')
			vvvv_slot = reg_from_op(ops[1], '/mvr slot 1')
			has_vvvv = true
			reg_slot = reg_from_op(ops[2], '/mvr slot 2')
			has_reg = true
		}
		.rvmi {
			// VEX 4-op with immediate: dst→reg, src1→vvvv, src2→r/m, src3=imm.
			reg_slot = reg_from_op(ops[0], '/rvmi slot 0')
			has_reg = true
			vvvv_slot = reg_from_op(ops[1], '/rvmi slot 1')
			has_vvvv = true
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[2], '/rvmi slot 2')
			imm_idx = 3
		}
		.mri {
			// 3-op: ModR/M.r/m, ModR/M.reg, imm  (EXTRACTPS / PEXTR* / SHLD imm).
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[0], '/mri slot 0')
			reg_slot = reg_from_op(ops[1], '/mri slot 1')
			has_reg = true
			imm_idx = 2
		}
		.rmv {
			// VEX 3-op: dst→reg, src1→r/m, src2→vvvv  (BEXTR / BZHI / VPROT*).
			reg_slot = reg_from_op(ops[0], '/rmv slot 0')
			has_reg = true
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[1], '/rmv slot 1')
			vvvv_slot = reg_from_op(ops[2], '/rmv slot 2')
			has_vvvv = true
		}
		.vmi {
			// VEX 3-op shift-by-imm: dst→VEX.vvvv (encoded as the destination
			// "vvvv" with reg_field /digit), src→r/m, imm. ops[0] is the
			// destination operand whose register goes into vvvv.
			vvvv_slot = reg_from_op(ops[0], '/vmi slot 0')
			has_vvvv = true
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[1], '/vmi slot 1')
			imm_idx = 2
		}
		.rvms {
			// AMD FMA4 W=0: dst→reg, src1→vvvv, src2→r/m, src3→/is4 (top 4 bits of imm8).
			reg_slot = reg_from_op(ops[0], '/rvms slot 0')
			has_reg = true
			vvvv_slot = reg_from_op(ops[1], '/rvms slot 1')
			has_vvvv = true
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[2], '/rvms slot 2')
			is4_slot = reg_from_op(ops[3], '/rvms slot 3')
			has_is4 = true
		}
		.rvsm {
			// AMD FMA4 W=1: dst→reg, src1→vvvv, src2→/is4, src3→r/m.
			reg_slot = reg_from_op(ops[0], '/rvsm slot 0')
			has_reg = true
			vvvv_slot = reg_from_op(ops[1], '/rvsm slot 1')
			has_vvvv = true
			is4_slot = reg_from_op(ops[2], '/rvsm slot 2')
			has_is4 = true
			rm_kind, rm_reg, rm_indir = rm_from_op(ops[3], '/rvsm slot 3')
		}
	}

	// 1) address-size prefix (0x67) for 32-bit indirection
	if rm_kind == 2 {
		e.add_segment_override_prefix(rm_indir)
	}

	// REX/VEX/EVEX register-extension bits.
	//   r/x/b   = bit 3 of the corresponding reg (REX.R/X/B equivalent)
	//   rh/xh/bh = bit 4 (R'/X'/B' — EVEX-only, used by ymm/zmm16-31)
	mut rr := u8(0)
	mut rx := u8(0)
	mut rb := u8(0)
	mut rrh := u8(0)
	mut bbh := u8(0)
	mut rxh := u8(0)

	if enc.plus_reg && has_reg {
		rb = (reg_slot.base_offset >> 3) & 1
		bbh = (reg_slot.base_offset >> 4) & 1
	} else {
		if has_reg && (enc.reg_field == .slash_r || enc.op_order == .mvr || enc.op_order == .rvm) {
			rr = (reg_slot.base_offset >> 3) & 1
			rrh = (reg_slot.base_offset >> 4) & 1
		}
		if rm_kind == 1 {
			rb = (rm_reg.base_offset >> 3) & 1
			bbh = (rm_reg.base_offset >> 4) & 1
		} else if rm_kind == 2 {
			if rm_indir.has_base {
				rb = (rm_indir.base.base_offset >> 3) & 1
				// EVEX X bit doubles as base[4] for non-VSIB memory; we don't model that yet.
			}
			if rm_indir.has_index_scale {
				rx = (rm_indir.index.base_offset >> 3) & 1
				rxh = (rm_indir.index.base_offset >> 4) & 1
			}
		}
	}

	if enc.evex_present {
		// EVEX (4-byte): 0x62 + P0 + P1 + P2.
		//   P0 = !R | !X | !B | !R' | 0 0 | mm[1:0]
		//   P1 = W  | (!vvvv)[3:0]   | 1   | pp[1:0]
		//   P2 = z  | L'[1] L[0]     | b   | !V'   | aaa[2:0]
		// We don't model masking ({k1}), zeroing ({z}), broadcast or rounding
		// yet, so z=0, b=0, aaa=0, and V'=1 (vvvv high bit = 0).
		//
		// Note: when ModR/M.mod = 11 (reg-reg form), the rm register's bit 4
		// is encoded into the EVEX X position; for memory with an index reg,
		// X holds the index's bit 3 as usual.
		vvvv4 := if has_vvvv { vvvv_slot.base_offset & 0xF } else { u8(0) }
		v_high := if has_vvvv && vvvv_slot.base_offset >= 16 { u8(1) } else { u8(0) }
		w := if enc.evex_w == 2 { u8(0) } else { enc.evex_w }
		inv_vvvv4 := (~vvvv4) & 0xF
		ll := enc.evex_l & 0x3

		x_bit := if rm_kind == 1 { bbh } else { rx }
		_ = rxh // EVEX index-bit-4 (zmm16-31 in VSIB) — out of scope for now.

		// EVEX P2 decorators:
		//   bit 7    = z       — zeroing-masking
		//   bits 5-6 = L'L     — vector length (overridden to rounding mode for {rN-sae})
		//   bit 4    = b       — broadcast / sae / rounding indicator
		//   bit 3    = !V'     — vvvv high bit (inverted)
		//   bits 0-2 = aaa     — mask register
		z_bit := if e.zeroing { u8(1) } else { u8(0) }
		aaa := if e.mask_reg < 8 { e.mask_reg & 0x7 } else { u8(0) }
		b_bit := if e.broadcast || e.sae || e.has_rounding { u8(1) } else { u8(0) }
		final_ll := if e.has_rounding { e.rounding & 0x3 } else { ll }

		e.current_instr.code << u8(0x62)
		e.current_instr.code << ((u8(1) - rr) << 7) | ((u8(1) - x_bit) << 6) | ((u8(1) - rb) << 5) | ((u8(1) - rrh) << 4) | enc.evex_mm
		e.current_instr.code << (w << 7) | (inv_vvvv4 << 3) | u8(0x04) | enc.evex_pp
		e.current_instr.code << (z_bit << 7) | (final_ll << 5) | (b_bit << 4) | ((u8(1) - v_high) << 3) | aaa
	} else if enc.vex_present {
		// VEX path. Legacy prefixes and the 0F escape are folded into pp/mm,
		// and REX bits become inverted RXBW bits inside the VEX byte.
		vvvv := if has_vvvv { vvvv_slot.base_offset & 0xF } else { u8(0) }
		l := if enc.vex_l == 2 { u8(0) } else { enc.vex_l }
		w := if enc.vex_w == 2 { u8(0) } else { enc.vex_w }
		inv_vvvv := (~vvvv) & 0xF

		// 2-byte form requires mm=01 (0F map) and X=B=W=0.
		if enc.vex_mm == 1 && rx == 0 && rb == 0 && w == 0 {
			e.current_instr.code << u8(0xC5)
			e.current_instr.code << ((u8(1) - rr) << 7) | (inv_vvvv << 3) | (l << 2) | enc.vex_pp
		} else {
			e.current_instr.code << u8(0xC4)
			e.current_instr.code << ((u8(1) - rr) << 7) | ((u8(1) - rx) << 6) | ((u8(1) - rb) << 5) | enc.vex_mm
			e.current_instr.code << (w << 7) | (inv_vvvv << 3) | (l << 2) | enc.vex_pp
		}
	} else {
		// Legacy REX path.
		// 2) fixed prefixes (0x66 / 0xF2 / 0xF3)
		for p in enc.prefixes {
			e.current_instr.code << p
		}

		mut rw := if enc.rex_w { u8(1) } else { u8(0) }
		mut rex_required := false
		if has_reg && reg_slot.rex_required {
			rex_required = true
		}
		if rm_kind == 1 && rm_reg.rex_required {
			rex_required = true
		}

		if rw != 0 || rr != 0 || rx != 0 || rb != 0 || rex_required {
			e.current_instr.code << rex(rw, rr, rx, rb)
		}
	}

	// 4) opcode (with optional +r merge into the last byte)
	if enc.plus_reg && has_reg {
		for i := 0; i < enc.opcode.len - 1; i++ {
			e.current_instr.code << enc.opcode[i]
		}
		e.current_instr.code << enc.opcode[enc.opcode.len - 1] + (reg_slot.base_offset % 8)
	} else {
		for b in enc.opcode {
			e.current_instr.code << b
		}
	}

	// 5) ModR/M (+ SIB + disp), driven by reg_field
	if enc.reg_field != .@none {
		digit_or_reg := match enc.reg_field {
			.slash_r {
				if has_reg { reg_slot.base_offset % 8 } else { u8(0) }
			}
			.slash_d0 { u8(0) }
			.slash_d1 { u8(1) }
			.slash_d2 { u8(2) }
			.slash_d3 { u8(3) }
			.slash_d4 { u8(4) }
			.slash_d5 { u8(5) }
			.slash_d6 { u8(6) }
			.slash_d7 { u8(7) }
			.@none { u8(0) }
		}
		if rm_kind == 1 {
			e.current_instr.code << compose_mod_rm(encoder.mod_regi, digit_or_reg, rm_reg.base_offset % 8)
		} else if rm_kind == 2 {
			e.add_modrm_sib_disp(rm_indir, digit_or_reg)
		}
	}

	// 6) Immediate
	if imm_idx >= 0 {
		op := ops[imm_idx] as Immediate
		mut sym := []string{}
		imm_val := eval_expr_get_symbol_64(op.expr, mut sym)
		sym_used := sym.len == 1

		size := match enc.imm {
			.ib { DataSize.suffix_byte }
			.iw { DataSize.suffix_word }
			.id { DataSize.suffix_long }
			.iq { DataSize.suffix_quad }
			.@none { DataSize.suffix_byte }
		}

		if sym_used {
			e.add_imm_rela(sym[0], int(imm_val), size)
		} else if enc.imm == .iq {
			mut hex := [u8(0), 0, 0, 0, 0, 0, 0, 0]
			binary.little_endian_put_u64(mut &hex, u64(imm_val))
			e.current_instr.code << hex
		} else {
			e.add_imm_value2(int(imm_val), size)
		}
	}

	// 6b) AMD FMA4 /is4 byte: imm8 whose upper nibble holds the 3rd source
	// register. Lower nibble is reserved (zero) for our forms.
	if has_is4 {
		e.current_instr.code << (is4_slot.base_offset & 0xF) << 4
	}

	// 7) Relative (label → rel32 / rel8)
	if enc.rel != .@none && label_idx >= 0 {
		op := ops[label_idx] as Ident
		rel_offset := i64(e.current_instr.code.len)
		nbytes := match enc.rel {
			.rel8 { 1 }
			.rel32 { 4 }
			.@none { 0 }
		}
		for _ in 0 .. nbytes {
			e.current_instr.code << u8(0)
		}
		rtype := if enc.mnemonic == 'CALL' {
			encoder.r_x86_64_plt32
		} else {
			encoder.r_x86_64_32s
		}
		e.rela_text_users << &Rela{
			uses:   op.lit
			instr:  e.current_instr
			offset: rel_offset
			rtype:  u64(rtype)
			adjust: 0
		}
		e.current_instr.is_jmp_or_call = true
	}
}
