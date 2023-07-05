module encoder

import error
import encoding.binary

fn (mut e Encoder) add_imm_rela(symbol string, imm_val int, size DataSize) {
	mut rela := Rela{ uses: symbol, instr: e.current_instr, adjust: imm_val, offset: e.current_instr.code.len }
	match size {
		.suffix_byte {
			rela.rtype = encoder.r_x86_64_8
			e.current_instr.code << u8(0)
		}
		.suffix_word {
			rela.rtype = encoder.r_x86_64_16
			e.current_instr.code << [u8(0), 0]
		}
		.suffix_long {
			rela.rtype = encoder.r_x86_64_32
			e.current_instr.code << [u8(0), 0, 0, 0]
		}
		.suffix_quad {
			rela.rtype = encoder.r_x86_64_32s
			e.current_instr.code << [u8(0), 0, 0, 0]
		} else {}
	}
	e.rela_text_users << rela
}

fn (mut e Encoder) add_imm_value(imm_val int, size DataSize) {
	if is_in_i8_range(imm_val) || size == DataSize.suffix_byte {
		e.current_instr.code << u8(imm_val)
	} else if size == DataSize.suffix_word {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(imm_val))
		e.current_instr.code << hex
	} else if is_in_i32_range(imm_val) {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(imm_val))
		e.current_instr.code << hex
	} else {
		panic('unreachable')
	}
}

fn (mut e Encoder) add_imm_value2(imm_val int, size DataSize) {
	if size == DataSize.suffix_byte {
		e.current_instr.code << [u8(imm_val)]
	} else if size == DataSize.suffix_word {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(imm_val))
		e.current_instr.code << [hex[0], hex[1]]
	} else {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(imm_val))
		e.current_instr.code << [hex[0], hex[1], hex[2], hex[3]]
	}
}

fn (mut e Encoder) cmov(kind InstrKind, op_code []u8, size DataSize) {
	e.set_current_instr(kind)

	source, desti := e.parse_two_operand()

	if source is Register && desti is Register {
		e.add_prefix(desti, Empty{}, source, [size])
		e.current_instr.code << op_code
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, desti.base_offset%8, source.base_offset%8)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) mov(size DataSize) {
	e.set_current_instr(.mov)

	source, desti := e.parse_two_operand()

	if source is Xmm && desti is Register {
		desti.check_regi_size(DataSize.suffix_quad)
		e.add_prefix(source, Empty{}, desti, [DataSize.suffix_word, DataSize.suffix_quad])
		e.current_instr.code << [u8(0x0F), 0x7E]
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, source.base_offset%8, desti.base_offset%8)
		return
	}
	if source is Register && desti is Xmm {
		source.check_regi_size(DataSize.suffix_quad)
		e.add_prefix(desti, Empty{}, source, [DataSize.suffix_word, DataSize.suffix_quad])
		e.current_instr.code << [u8(0x0F), 0x6E]
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, desti.base_offset%8, source.base_offset%8)
		return
	}
	if source is Indirection && desti is Xmm {
		e.add_segment_override_prefix(source)
		e.add_prefix(desti, source.index, source.base, [DataSize.suffix_single])
		e.current_instr.code << [u8(0x0F), 0x7E]
		e.add_modrm_sib_disp(source, desti.base_offset%8)
		return
	}
	if source is Xmm && desti is Indirection {
		e.add_segment_override_prefix(desti)
		e.add_prefix(source, desti.index, desti.base, [DataSize.suffix_word])
		e.current_instr.code << [u8(0x0F), 0xD6]
		e.add_modrm_sib_disp(desti, source.base_offset%8)
		return
	}

	if source is Register {
		op_code := if size == .suffix_byte {
			[u8(0x88)]
		} else {
			[u8(0x89)]
		}
		source.check_regi_size(size)

		if desti is Register {
			desti.check_regi_size(size)
			e.add_prefix(source, Empty{}, desti, [size])
			e.current_instr.code << op_code
			e.current_instr.code << compose_mod_rm(encoder.mod_regi, source.base_offset%8, desti.base_offset%8)
			return
		}
		if desti is Indirection {
			e.add_segment_override_prefix(desti)
			e.add_prefix(source, desti.index, desti.base, [size])
			e.current_instr.code << op_code
			e.add_modrm_sib_disp(desti, source.base_offset%8)
			return
		}
	}

	if source is Indirection && desti is Register {
		op_code := if size == .suffix_byte {
			[u8(0x8a)]
		} else {
			[u8(0x8b)]
		}
		desti.check_regi_size(size)
		e.add_segment_override_prefix(source)
		e.add_prefix(desti, source.index, source.base, [size])
		e.current_instr.code << op_code
		e.add_modrm_sib_disp(source, desti.base_offset%8)
		return
	}

	if source is Immediate {
		match desti {
			Register {
				desti.check_regi_size(size)
				e.add_prefix(Empty{}, Empty{}, desti, [size])
				e.current_instr.code << if size == .suffix_quad {
					e.current_instr.code << 0xc7
					0xc0 + desti.base_offset%8
				} else if size == .suffix_byte {
					0xB0 + desti.base_offset%8
				} else {
					0xB8 + desti.base_offset%8
				}
			}
			Indirection {
				e.add_segment_override_prefix(desti)
				e.add_prefix(Empty{}, desti.index, desti.base, [size])
				e.current_instr.code <<  if size == .suffix_byte {
					u8(0xc6)
				} else {
					u8(0xc7)
				}
				e.add_modrm_sib_disp(desti, encoder.slash_0)
			} else {
				error.print(desti.pos, 'invalid operand for instruction')
				exit(1)
			}
		}

		mut imm_used_symbols := []string{}
		imm_val := int(eval_expr_get_symbol_64(source.expr, mut imm_used_symbols))
		if imm_used_symbols.len >= 2 {
			error.print(source.pos, 'invalid immediate operand')
			exit(1)
		}
		imm_need_rela := imm_used_symbols.len == 1

		if imm_need_rela {
			e.add_imm_rela(imm_used_symbols[0], int(imm_val), size)
		} else {
			e.add_imm_value2(imm_val, size)
		}
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) rep() {
	e.set_current_instr(.rep)

	source := e.parse_operand()

	if source is Ident {
		match source.lit {
			'movsq' {
				e.current_instr.code << [u8(0xF3), 0x48, 0xA5]
				return
			}
			'stosq' {
				e.current_instr.code << [u8(0xF3), 0x48, 0xAB]
				return
			} else {}
		}
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) movabsq() {
	e.set_current_instr(.movabsq)

	source, desti := e.parse_two_operand()

	if source is Immediate && desti is Register {		
		desti.check_regi_size(DataSize.suffix_quad)
		e.add_prefix(Empty{}, Empty{}, desti, [DataSize.suffix_quad])
		e.current_instr.code << u8(0xB8) + desti.base_offset%8

		mut imm_used_symbols := []string{}
		imm_val := eval_expr_get_symbol_64(source.expr, mut imm_used_symbols)
		if imm_used_symbols.len >= 2 {
			error.print(source.pos, 'invalid immediate operand')
			exit(1)
		}
		imm_need_rela := imm_used_symbols.len == 1

		if imm_need_rela {
			mut rela := Rela{
				uses: imm_used_symbols[0],
				instr: e.current_instr,
				adjust: int(imm_val),
				offset: e.current_instr.code.len,
			}
			rela.rtype = encoder.r_x86_64_64
			e.current_instr.code << [u8(0), 0, 0, 0, 0, 0, 0, 0]
			e.rela_text_users << rela
		} else {
			mut hex := [u8(0), 0, 0, 0, 0, 0, 0, 0]
			binary.little_endian_put_u64(mut &hex, u64(imm_val))
			e.current_instr.code << hex
		}

		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) mul(size DataSize) {
	e.set_current_instr(.mul)

	source := e.parse_operand()

	if e.tok.kind != .comma {
		op_code := if size == DataSize.suffix_byte {
			[u8(0xf6)]
		} else {
			[u8(0xf7)]
		}
		if source is Register {
			source.check_regi_size(size)
			e.add_prefix(Empty{}, Empty{}, source, [size])
			e.current_instr.code << op_code
			e.current_instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_4, source.base_offset%8)
			return
		}
		if source is Indirection {
			e.add_segment_override_prefix(source)
			e.add_prefix(Empty{}, source.index, source.base, [size])
			e.current_instr.code << op_code
			e.add_modrm_sib_disp(source, encoder.slash_4)
			return
		}
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) mov_zero_or_sign_extend(op_code []u8, source_size DataSize, desti_size DataSize) {
	e.set_current_instr(.movzx)

	source, desti := e.parse_two_operand()

	if source is Register && desti is Register {
		// TODO: The following check should be done at add_prefix()
		if desti_size == .suffix_quad && source.lit in ['AH','CH','DH','BH'] {
			error.print(source.pos, 'can\'t encode `%$source.lit` in an instruction requiring REX prefix')
			exit(1)
		}

		source.check_regi_size(source_size)
		desti.check_regi_size(desti_size)
		e.add_prefix(desti, Empty{}, source, [desti_size])
		e.current_instr.code << op_code
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, desti.base_offset%8, source.base_offset%8)
		return
	}
	if source is Indirection && desti is Register {
		desti.check_regi_size(desti_size)
		e.add_segment_override_prefix(source)
		e.add_prefix(desti, source.index, source.base, [desti_size])
		e.current_instr.code << op_code
		e.add_modrm_sib_disp(source, desti.base_offset%8)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) test(size DataSize) {
	e.set_current_instr(.test)

	source, desti := e.parse_two_operand()

	if source is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x84)]
		} else {
			[u8(0x84) + 1]
		}
		source.check_regi_size(size)
		if desti is Register {
			desti.check_regi_size(size)
			e.add_prefix(source, Empty{}, desti, [size])
			e.current_instr.code << op_code
			e.current_instr.code << compose_mod_rm(encoder.mod_regi, source.base_offset%8, desti.base_offset%8)
			return
		}
		if desti is Indirection {
			e.add_segment_override_prefix(desti)
			e.add_prefix(source, desti.index, desti.base, [size])
			e.current_instr.code << op_code
			e.add_modrm_sib_disp(desti, source.base_offset%8)
			return
		}
	}
	if source is Indirection && desti is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x84)]
		} else {
			[u8(0x84) + 1]
		}
		desti.check_regi_size(size)
		e.add_segment_override_prefix(source)
		e.add_prefix(desti, source.index, source.base, [size])
		e.current_instr.code << op_code
		e.add_modrm_sib_disp(source, desti.base_offset%8)
		return
	}
	if source is Immediate {
		mut imm_used_symbols := []string{}
		imm_val := int(eval_expr_get_symbol_64(source.expr, mut imm_used_symbols))
		if imm_used_symbols.len >= 2 {
			error.print(source.pos, 'invalid immediate operand')
			exit(1)
		}
		imm_need_rela := imm_used_symbols.len == 1

		op_code := if size == DataSize.suffix_byte {
			u8(0xF6)
		} else {
			u8(0xF7)
		}

		if desti is Register {
			desti.check_regi_size(size)
			e.add_prefix(Empty{}, Empty{}, desti, [size])
			e.current_instr.code << op_code
			e.current_instr.code << compose_mod_rm(mod_regi, encoder.slash_0, desti.base_offset%8)
		} else if desti is Indirection {
			e.add_segment_override_prefix(desti)
			e.add_prefix(Empty{}, desti.index, desti.base, [size])
			e.current_instr.code << op_code
			e.add_modrm_sib_disp(desti, encoder.slash_0)
		} else {
			error.print(source.pos, 'invalid operand for instruction')
			exit(1)
		}

		if imm_need_rela {
			e.add_imm_rela(imm_used_symbols[0], int(imm_val), size)
		} else {
			e.add_imm_value2(imm_val, size)
		}

		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) arith_instr(kind InstrKind, op_code_base u8, slash u8, size DataSize) {
	e.set_current_instr(kind)

	source, desti := e.parse_two_operand()

	if source is Register {
		op_code := if size == DataSize.suffix_byte {
			op_code_base
		} else {
			op_code_base + 1
		}
		source.check_regi_size(size)
		if desti is Register {
			desti.check_regi_size(size)
			e.add_prefix(source, Empty{}, desti, [size])
			e.current_instr.code << op_code
			e.current_instr.code << compose_mod_rm(encoder.mod_regi, source.base_offset%8, desti.base_offset%8)
			return
		}
		if desti is Indirection {
			e.add_segment_override_prefix(desti)
			e.add_prefix(source, desti.index, desti.base, [size])
			e.current_instr.code << op_code
			e.add_modrm_sib_disp(desti, source.base_offset%8)
			return
		}
	}
	if source is Indirection && desti is Register {
		op_code := if size == DataSize.suffix_byte {
			op_code_base + 2
		} else {
			op_code_base + 3
		}
		desti.check_regi_size(size)
		e.add_segment_override_prefix(source)
		e.add_prefix(desti, source.index, source.base, [size])
		e.current_instr.code << op_code
		e.add_modrm_sib_disp(source, desti.base_offset%8)
		return
	}
	if source is Immediate {
		mut imm_used_symbols := []string{}
		imm_val := int(eval_expr_get_symbol_64(source.expr, mut imm_used_symbols))
		if imm_used_symbols.len >= 2 {
			error.print(source.pos, 'invalid immediate operand')
			exit(1)
		}
		imm_need_rela := imm_used_symbols.len == 1

		op_code := if size == DataSize.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(int(imm_val)) && !imm_need_rela {
			u8(0x83)
		} else {
			u8(0x81)
		}

		if desti is Register {
			desti.check_regi_size(size)
			e.add_prefix(Empty{}, Empty{}, desti, [size])
			e.current_instr.code << op_code
			e.current_instr.code << compose_mod_rm(mod_regi, slash, desti.base_offset%8)
		} else if desti is Indirection {
			e.add_segment_override_prefix(desti)
			e.add_prefix(Empty{}, desti.index, desti.base, [size])
			e.current_instr.code << op_code
			e.add_modrm_sib_disp(desti, slash)
		} else {
			error.print(source.pos, 'invalid operand for instruction')
			exit(1)
		}

		if imm_need_rela {
			e.add_imm_rela(imm_used_symbols[0], imm_val, size)
		} else {
			e.add_imm_value(imm_val, size)
		}

		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) imul(size DataSize) {
	e.set_current_instr(.imul)

	source := e.parse_operand()

	if e.tok.kind != .comma {
		op_code := if size == DataSize.suffix_byte {
			[u8(0xf6)]
		} else {
			[u8(0xf7)]
		}
		if source is Register {
			source.check_regi_size(size)
			e.add_prefix(Empty{}, Empty{}, source, [size])
			e.current_instr.code << op_code
			e.current_instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_5, source.base_offset%8)
			return
		}
		if source is Indirection {
			e.add_segment_override_prefix(source)
			e.add_prefix(Empty{}, source.index, source.base, [size])
			e.current_instr.code << op_code
			e.add_modrm_sib_disp(source, encoder.slash_5)
			return
		}
	}

	e.expect(.comma)
	desti_operand_1 := e.parse_operand()

	if source is Indirection && desti_operand_1 is Register {
		desti_operand_1.check_regi_size(size)
		e.add_segment_override_prefix(source)
		e.add_prefix(desti_operand_1, source.index, source.base, [size])
		e.current_instr.code << [u8(0x0f), 0xaf]
		e.add_modrm_sib_disp(source, desti_operand_1.base_offset%8)
		return
	}

	if source is Register && desti_operand_1 is Register {
		source.check_regi_size(size)
		desti_operand_1.check_regi_size(size)
		e.add_prefix(desti_operand_1, Empty{}, source, [size])
		e.current_instr.code << [u8(0x0f), 0xaf]
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, desti_operand_1.base_offset%8, source.base_offset%8)
		return
	}

	desti_operand_2 := if e.tok.kind != .comma {
		desti_operand_1
	} else {
		e.expect(.comma)
		e.parse_operand()
	}

	if source is Immediate && desti_operand_1 is Register && desti_operand_2 is Register {
		mut imm_used_symbols := []string{}
		imm_val := int(eval_expr_get_symbol_64(source.expr, mut imm_used_symbols))
		if imm_used_symbols.len >= 2 {
			error.print(source.pos, 'invalid immediate operand')
			exit(1)
		}
		imm_need_rela := imm_used_symbols.len == 1

		op_code := if is_in_i8_range(imm_val) && !imm_need_rela {
			u8(0x6b)
		} else {
			u8(0x69)
		}

		desti_operand_1.check_regi_size(size)
		desti_operand_2.check_regi_size(size)
		e.add_prefix(desti_operand_2, Empty{}, desti_operand_1, [size])
		e.current_instr.code << op_code
		e.current_instr.code << compose_mod_rm(mod_regi, desti_operand_2.base_offset%8, desti_operand_1.base_offset%8)

		if imm_need_rela {
			e.add_imm_rela(imm_used_symbols[0], imm_val, size)
		} else {
			e.add_imm_value(imm_val, size)
		}

		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) one_operand_arith(kind InstrKind, slash u8, size DataSize) {
	e.set_current_instr(kind)

	source := e.parse_operand()

	op_code := if size == DataSize.suffix_byte {
		[u8(0xF6)]
	} else {
		[u8(0xF7)]
	}

	if source is Register {
		source.check_regi_size(size)
		e.add_prefix(Empty{}, Empty{}, source, [size])
		e.current_instr.code << op_code
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, slash, source.base_offset%8)
		return
	}
	if source is Indirection {
		e.add_segment_override_prefix(source)
		e.add_prefix(Empty{}, source.index, source.base, [size])
		e.current_instr.code << op_code
		e.add_modrm_sib_disp(source, slash)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) lea(instr_name_upper string) {
	e.set_current_instr(.lea)

	size := get_size_by_suffix(instr_name_upper)

	source, desti := e.parse_two_operand()

	if source is Indirection && desti is Register {
		desti.check_regi_size(size)
		e.add_segment_override_prefix(source)
		e.add_prefix(desti, source.index, source.base, [size])
		e.current_instr.code << u8(0x8D)
		e.add_modrm_sib_disp(source, desti.base_offset%8)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) set(kind InstrKind, op_code []u8) {
	e.set_current_instr(kind)

	regi := e.parse_operand()

	if regi is Register {
		regi.check_regi_size(DataSize.suffix_byte)
		e.add_prefix(Empty{}, Empty{}, regi, [DataSize.suffix_byte])
		e.current_instr.code << op_code
		e.current_instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_0, regi.base_offset%8)
		return
	}

	error.print(regi.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) shift(kind InstrKind, slash u8, size DataSize) {
	e.set_current_instr(kind)

	source := e.parse_operand()

	// single operand
	if e.tok.kind != .comma {
		op_code := if size == DataSize.suffix_byte {
			u8(0xD0)
		} else {
			u8(0xD1)
		}

		if source is Register {
			source.check_regi_size(size)
			e.add_prefix(Empty{}, Empty{}, source, [size])
			e.current_instr.code << op_code
			e.current_instr.code << compose_mod_rm(encoder.mod_regi, slash, source.base_offset%8)
			return
		} else if source is Indirection {
			e.add_segment_override_prefix(source)
			e.add_prefix(Empty{}, source.index, source.base, [size])
			e.current_instr.code << op_code
			e.add_modrm_sib_disp(source, slash)
			return
		}
	}

	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		if source.lit != 'CL' {
			error.print(source.pos, 'invalid operand for instruction')
			exit(1)
		}
		op_code := if size == DataSize.suffix_byte {
			u8(0xD2)
		} else {
			u8(0xD3)
		}
		if desti is Register {
			desti.check_regi_size(size)
			e.add_prefix(source, Empty{}, desti, [size])
			e.current_instr.code << op_code
			e.current_instr.code << compose_mod_rm(encoder.mod_regi, slash, desti.base_offset%8)
			return
		} else if desti is Indirection {
			e.add_segment_override_prefix(desti)
			e.add_prefix(source, desti.index, desti.base, [size])
			e.current_instr.code << op_code
			e.add_modrm_sib_disp(desti, slash)
			return
		}
	}

	if source is Immediate {
		mut used_symbols := []string{}
		imm_val := int(eval_expr_get_symbol_64(source.expr, mut used_symbols))

		if used_symbols.len >= 2 {
			error.print(source.expr.pos, 'invalid immediate operand')
			exit(1)
		}

		imm_need_rela := used_symbols.len == 1
		op_code := if imm_val == 1 && !imm_need_rela {
			if size == DataSize.suffix_byte {
				u8(0xD0)
			} else  {
				u8(0xD1)	
			}
		} else {
			if size == DataSize.suffix_byte {
				u8(0xC0)
			} else {
				u8(0xC1)
			}
		}

		match desti {
			Register {
				desti.check_regi_size(size)
				e.add_prefix(Empty{}, Empty{}, desti, [size])
				e.current_instr.code << op_code
				e.current_instr.code << compose_mod_rm(encoder.mod_regi, slash, desti.base_offset%8)
			}
			Indirection {
				e.add_segment_override_prefix(desti)
				e.add_prefix(Empty{}, desti.index, desti.base, [size])
				e.current_instr.code << op_code
				e.add_modrm_sib_disp(desti, slash)
			} else {
				error.print(desti.pos, 'invalid operand for instruction')
				exit(1)
			}
		}

		if imm_need_rela {
			e.add_imm_rela(used_symbols[0], 0, DataSize.suffix_byte)
		} else if imm_val != 1 {
			e.add_imm_value(u8(imm_val), DataSize.suffix_byte)
		}
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

