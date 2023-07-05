module encoder

import error

fn (mut e Encoder) pop() {
	e.set_current_instr(.pop)

	source := e.parse_operand()

	if source is Register {
		source.check_regi_size(.suffix_quad)
		e.add_prefix(Empty{}, Empty{}, source, [])
		e.current_instr.code << [0x58 + source.base_offset%8]
		return
	}
	if source is Indirection {
		e.add_segment_override_prefix(source)
		e.add_prefix(Empty{}, source.index, source.base, [])
		e.current_instr.code << 0x8f // op_code
		e.add_modrm_sib_disp(source, encoder.slash_0)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) push() {
	e.set_current_instr(.push)

	source := e.parse_operand()

	if source is Register {
		source.check_regi_size(.suffix_quad)
		e.add_prefix(Empty{}, Empty{}, source, [])
		source.check_regi_size(.suffix_quad)
		e.current_instr.code << [0x50 + source.base_offset%8]
		return
	}
	if source is Indirection {
		e.add_segment_override_prefix(source)
		e.add_prefix(Empty{}, source.index, source.base, [])
		e.current_instr.code << 0xff // op_code
		e.add_modrm_sib_disp(source, encoder.slash_6)
		return
	}
	if source is Immediate {
		mut used_symbols := []string{}
		imm_val := int(eval_expr_get_symbol_64(source, mut used_symbols))
		if used_symbols.len >= 2 {
			error.print(source.pos, 'invalid immediate operand')
			exit(1)
		}

		e.current_instr.code << if is_in_i8_range(imm_val) {
			u8(0x6A)
		} else {
			u8(0x68)
		}

		imm_need_rela := used_symbols.len == 1

		if imm_need_rela {
			e.add_imm_rela(used_symbols[0], imm_val, DataSize.suffix_quad)
		} else {
			e.add_imm_value(imm_val, DataSize.suffix_quad)
		}
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) jmp_instr(kind InstrKind, rel32_code []u8, rel32_offset i64) {
	e.set_current_instr(kind)
	e.current_instr.is_jmp_or_call = true

	desti := e.parse_operand()

	if desti is Ident {
		e.current_instr.code << rel32_code
		e.rela_text_users << &Rela{
			uses: desti.lit,
			instr: e.current_instr,
			offset: rel32_offset,
			rtype: encoder.r_x86_64_32s,
			adjust: 0,
		}
		return
	}
	if desti is Star {
		desti.regi.check_regi_size(DataSize.suffix_quad)
		e.add_prefix(Empty{}, Empty{}, desti.regi, [])
		e.current_instr.code << [u8(0xFF), 0xE0 + desti.regi.base_offset%8]
		return
	}

	error.print(desti.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) call() {
	e.set_current_instr(.call)
	e.current_instr.is_jmp_or_call = true

	desti := e.parse_operand()

	if desti is Star {
		desti.regi.check_regi_size(DataSize.suffix_quad)
		e.add_prefix(Empty{}, Empty{}, desti.regi, [])
		e.current_instr.code << [u8(0xFF), 0xD0 + desti.regi.base_offset%8]
	} else {
		e.current_instr.code << [u8(0xe8), 0, 0, 0, 0]
		mut used_symbols := []string{}
		adjust := int(eval_expr_get_symbol_64(desti, mut used_symbols))
		if used_symbols.len >= 2 {
			error.print(desti.pos, 'invalid operand for instruction')
			exit(1)
		}

		e.rela_text_users << encoder.Rela{
			instr:  e.current_instr,
			offset: 1,
			uses:   used_symbols[0],
			adjust: adjust,
			rtype:   encoder.r_x86_64_plt32
		}
	}
}

