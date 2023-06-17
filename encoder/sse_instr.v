module encoder

fn (mut e Encoder) cvttss2sil() {
	mut instr := Instr{kind: .cvttss2sil, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Register {
		desti.check_regi_size(DataSize.suffix_long)
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single])
		instr.code << [u8(0x0F), 0x2C]
		instr.code << compose_mod_rm(encoder.mod_regi, desti.regi_bits(), source.xmm_bits())
		return
	}
}

fn (mut e Encoder) cvtsi2ssq() {
	mut instr := Instr{kind: .cvtsi2ssq, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_quad)
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single, DataSize.suffix_quad])
		instr.code << [u8(0x0F), 0x2A]
		instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.regi_bits())
		return
	}
}

fn (mut e Encoder) cvtsi2sdq() {
	mut instr := Instr{kind: .cvtsi2sdq, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_quad)
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_double, DataSize.suffix_quad])
		instr.code << [u8(0x0F), 0x2A]
		instr.code << compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.regi_bits())
		return
	}
}

fn (mut e Encoder) cvtsd2ss() {
	mut instr := Instr{kind: .cvtsd2ss, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_double])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x5A]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_double])
		instr.code << [u8(0x0F), 0x5A]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) cvtss2sd() {
	mut instr := Instr{kind: .cvtss2sd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x5A]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_single])
		instr.code << [u8(0x0F), 0x5A]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) movss() {
	mut instr := Instr{kind: .movss, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x10]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_single])
		instr.code << [u8(0x0F), 0x10]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}

	if source is Xmm && desti is Indirection {
		instr.add_segment_override_prefix(desti)
		instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, [DataSize.suffix_single])
		instr.code << [u8(0x0F), 0x11]
		instr.add_modrm_sib_disp(desti, source.xmm_bits())
		return
	}
}

fn (mut e Encoder) movsd() {
	mut instr := Instr{kind: .movsd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_double])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x10]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_double])
		instr.code << [u8(0x0F), 0x10]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}

	if source is Xmm && desti is Indirection {
		instr.add_segment_override_prefix(desti)
		instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, [DataSize.suffix_double])
		instr.code << [u8(0x0F), 0x11]
		instr.add_modrm_sib_disp(desti, source.xmm_bits())
		return
	}
}

fn (mut e Encoder) movd() {
	mut instr := Instr{kind: .movd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_long)
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.regi_bits())
		instr.code << [u8(0x0F), 0x6e]
		instr.code << mod_rm
		return
	}

	if source is Xmm && desti is Register {
		desti.check_regi_size(DataSize.suffix_long)
		instr.add_rex_prefix(source.lit, '', desti.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, source.xmm_bits(), desti.regi_bits())
		instr.code << [u8(0x0F), 0x7e]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_word])
		instr.code << [u8(0x0F), 0x6e]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}

	if source is Xmm && desti is Indirection {
		instr.add_segment_override_prefix(desti)
		instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, [DataSize.suffix_word])
		instr.code << [u8(0x0F), 0x7e]
		instr.add_modrm_sib_disp(desti, source.xmm_bits())
		return
	}
}

fn (mut e Encoder) ucomiss() {
	mut instr := Instr{kind: .ucomiss, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x2E]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [])
		instr.code << [u8(0x0F), 0x2E]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) ucomisd() {
	mut instr := Instr{kind: .ucomisd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x2E]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_word])
		instr.code << [u8(0x0F), 0x2E]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) comisd() {
	mut instr := Instr{kind: .comisd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x2F]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_word])
		instr.code << [u8(0x0F), 0x2F]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) comiss() {
	mut instr := Instr{kind: .comiss, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x2F]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [])
		instr.code << [u8(0x0F), 0x2F]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}

}

fn (mut e Encoder) subss() {
	mut instr := Instr{kind: .subss, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x5C]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_single])
		instr.code << [u8(0x0F), 0x5C]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
	}
}

fn (mut e Encoder) subsd() {
	mut instr := Instr{kind: .subsd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_double])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x5C]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_double])
		instr.code << [u8(0x0F), 0x5C]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
	}
}

fn (mut e Encoder) addss() {
	mut instr := Instr{kind: .addss, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x58]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_single])
		instr.code << [u8(0x0F), 0x58]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) addsd() {
	mut instr := Instr{kind: .addsd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_double])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x58]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_double])
		instr.code << [u8(0x0F), 0x58]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}

}

fn (mut e Encoder) mulss() {
	mut instr := Instr{kind: .mulss, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x59]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_single])
		instr.code << [u8(0x0F), 0x59]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) mulsd() {
	mut instr := Instr{kind: .mulsd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_double])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x59]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_double])
		instr.code << [u8(0x0F), 0x59]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) divss() {
	mut instr := Instr{kind: .divss, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_single])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x5E]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_single])
		instr.code << [u8(0x0F), 0x5E]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) divsd() {
	mut instr := Instr{kind: .divsd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_double])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x5E]
		instr.code << mod_rm
		return
	}

	if source is Indirection && desti is Xmm {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, [DataSize.suffix_double])
		instr.code << [u8(0x0F), 0x5E]
		instr.add_modrm_sib_disp(source, desti.xmm_bits())
		return
	}
}

fn (mut e Encoder) movaps() {
	mut instr := Instr{kind: .movaps, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x28]
		instr.code << mod_rm
		return
	}

	if source is Xmm && desti is Indirection {
		instr.add_segment_override_prefix(desti)
		instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, [])
		instr.code << [u8(0x0F), 0x29]
		instr.add_modrm_sib_disp(desti, source.xmm_bits())
		return
	}
}

fn (mut e Encoder) movups() {
	mut instr := Instr{kind: .movups, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Indirection {
		instr.add_segment_override_prefix(desti)
		instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, [])
		instr.code << [u8(0x0F), 0x11]
		instr.add_modrm_sib_disp(desti, source.xmm_bits())
		return
	}
}

fn (mut e Encoder) xorpd() {
	mut instr := Instr{kind: .xorpd, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x57]
		instr.code << mod_rm
		return
	}
}

fn (mut e Encoder) xorps() {
	mut instr := Instr{kind: .xorps, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0x57]
		instr.code << mod_rm
		return
	}
}

fn (mut e Encoder) pxor() {
	mut instr := Instr{kind: .pxor, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Xmm && desti is Xmm {
		instr.add_rex_prefix(desti.lit, '', source.lit, [DataSize.suffix_word])
		mod_rm := compose_mod_rm(encoder.mod_regi, desti.xmm_bits(), source.xmm_bits())
		instr.code << [u8(0x0F), 0xEF]
		instr.code << mod_rm
		return
	}
}

