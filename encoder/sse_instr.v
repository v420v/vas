module encoder

import error

fn (mut e Encoder) cvttss2sil() {
	e.set_current_instr(.cvttss2sil)

	source, desti := e.parse_two_operand()

	if source is Xmm && desti is Register {
		desti.check_regi_size(DataSize.suffix_long)
		e.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single])
		e.current_instr.code << [u8(0x0F), 0x2C]
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, desti.regi_bits()%8, source.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) cvtsi2ssq() {
	e.set_current_instr(.cvtsi2ssq)

	source, desti := e.parse_two_operand()

	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_quad)
		e.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single, DataSize.suffix_quad])
		e.current_instr.code << [u8(0x0F), 0x2A]
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.regi_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) cvtsi2sdq() {
	e.set_current_instr(.cvtsi2sdq)

	source, desti := e.parse_two_operand()

	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_quad)
		e.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_double, DataSize.suffix_quad])
		e.current_instr.code << [u8(0x0F), 0x2A]
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.regi_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) xorp(kind InstrKind, sizes []DataSize) {
	e.set_current_instr(kind)

	source, desti := e.parse_two_operand()

	if source is Xmm && desti is Xmm {
		e.add_rex_prefix(desti.lit, '', source.lit, sizes)
		e.current_instr.code << [u8(0x0F), 0x57]
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) sse_arith_instr(kind InstrKind, op_code []u8, sizes []DataSize) {
	e.set_current_instr(kind)

	source, desti := e.parse_two_operand()

	if source is Xmm && desti is Xmm {
		e.add_rex_prefix(desti.lit, '', source.lit, sizes)
		e.current_instr.code << op_code
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.xmm_bits()%8)
		return
	}

	if source is Indirection && desti is Xmm {
		e.add_segment_override_prefix(source)
		e.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, sizes)
		e.current_instr.code << op_code
		e.add_modrm_sib_disp(source, desti.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) sse_data_transfer_instr(kind InstrKind, op_code_base u8, sizes []DataSize) {
	e.set_current_instr(kind)

	source, desti := e.parse_two_operand()

	if source is Xmm && desti is Xmm {
		e.add_rex_prefix(desti.lit, '', source.lit, sizes)
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.xmm_bits()%8)
		e.current_instr.code << 0x0F
		e.current_instr.code << op_code_base
		e.current_instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		e.add_segment_override_prefix(source)
		e.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, sizes)
		e.current_instr.code << 0x0F
		e.current_instr.code << op_code_base
		e.add_modrm_sib_disp(source, desti.xmm_bits()%8)
		return
	}

	if source is Xmm && desti is Indirection {
		e.add_segment_override_prefix(desti)
		e.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, sizes)
		e.current_instr.code << 0x0F
		e.current_instr.code << op_code_base + 1
		e.add_modrm_sib_disp(desti, source.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) movd() {
	e.set_current_instr(.movd)

	source, desti := e.parse_two_operand()

	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_long)
		e.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits()%8, source.regi_bits()%8)
		e.current_instr.code << [u8(0x0F), 0x6e]
		e.current_instr.code << mod_rm
		return
	}

	if source is Xmm && desti is Register {
		desti.check_regi_size(DataSize.suffix_long)
		e.add_rex_prefix(source.lit, '', desti.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, source.xmm_bits()%8, desti.regi_bits()%8)
		e.current_instr.code << [u8(0x0F), 0x7e]
		e.current_instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		e.add_segment_override_prefix(source)
		e.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_word])
		e.current_instr.code << [u8(0x0F), 0x6e]
		e.add_modrm_sib_disp(source, desti.xmm_bits()%8)
		return
	}

	if source is Xmm && desti is Indirection {
		e.add_segment_override_prefix(desti)
		e.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, [DataSize.suffix_word])
		e.current_instr.code << [u8(0x0F), 0x7e]
		e.add_modrm_sib_disp(desti, source.xmm_bits()%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

