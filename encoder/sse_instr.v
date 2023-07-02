module encoder

import error

fn (mut e Encoder) cvttss2sil() {
	mut instr := Instr{kind: .cvttss2sil, section: e.current_section, pos: e.tok.pos}
	e.instrs << &instr

	source, desti := e.parse_two_operand()

	if source is Xmm && desti is Register {
		desti.check_regi_size(DataSize.suffix_long)
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single])
		instr.code << [u8(0x0F), 0x2C]
		instr.code << compose_mod_rm(encoder.mod_regi, desti.regi_bits()%8, source.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) cvtsi2ssq() {
	mut instr := Instr{kind: .cvtsi2ssq, section: e.current_section, pos: e.tok.pos}
	e.instrs << &instr

	source, desti := e.parse_two_operand()

	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_quad)
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single, DataSize.suffix_quad])
		instr.code << [u8(0x0F), 0x2A]
		instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.regi_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) cvtsi2sdq() {
	mut instr := Instr{kind: .cvtsi2sdq, section: e.current_section, pos: e.tok.pos}
	e.instrs << &instr

	source, desti := e.parse_two_operand()

	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_quad)
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_double, DataSize.suffix_quad])
		instr.code << [u8(0x0F), 0x2A]
		instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.regi_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) xorp(kind InstrKind, sizes []DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs << &instr

	source, desti := e.parse_two_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, sizes)
		instr.code << [u8(0x0F), 0x57]
		instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) sse_arith_instr(kind InstrKind, op_code []u8, sizes []DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs << &instr

	source, desti := e.parse_two_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, sizes)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.xmm_bits()%8)
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, sizes)
		instr.code << op_code
		instr.add_modrm_sib_disp(source, desti.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) sse_data_transfer_instr(kind InstrKind, op_code_base u8, sizes []DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs << &instr

	source, desti := e.parse_two_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, sizes)
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.xmm_bits()%8)
		instr.code << 0x0F
		instr.code << op_code_base
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, sizes)
		instr.code << 0x0F
		instr.code << op_code_base
		instr.add_modrm_sib_disp(source, desti.xmm_bits()%8)
		return
	}

	if source is Xmm && desti is Indirection {
		instr.add_segment_override_prefix(desti)
		instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, sizes)
		instr.code << 0x0F
		instr.code << op_code_base + 1
		instr.add_modrm_sib_disp(desti, source.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) movd() {
	mut instr := Instr{kind: .movd, section: e.current_section, pos: e.tok.pos}
	e.instrs << &instr

	source, desti := e.parse_two_operand()

	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_long)
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.regi_bits()%8)
		instr.code << [u8(0x0F), 0x6e]
		instr.code << mod_rm
		return
	}

	if source is Xmm && desti is Register {
		desti.check_regi_size(DataSize.suffix_long)
		instr.add_rex_prefix(source.lit, '', desti.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, source.xmm_bits()%8, desti.regi_bits()%8)
		instr.code << [u8(0x0F), 0x7e]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_word])
		instr.code << [u8(0x0F), 0x6e]
		instr.add_modrm_sib_disp(source, desti.xmm_bits()%8)
		return
	}

	if source is Xmm && desti is Indirection {
		instr.add_segment_override_prefix(desti)
		instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, [DataSize.suffix_word])
		instr.code << [u8(0x0F), 0x7e]
		instr.add_modrm_sib_disp(desti, source.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

