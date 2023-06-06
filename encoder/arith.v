module encoder

import error
import encoding.binary

fn (mut instr Instr) add_imm_rela(symbol string, imm_val int, size DataSize) {
	mut rela := Rela{
		uses: symbol,
		instr: unsafe{ instr },
		adjust: imm_val,
		offset: instr.code.len,
	}
	match size {
		.suffix_byte {
			rela.rtype = encoder.r_x86_64_8
			instr.code << u8(0)
		}
		.suffix_word {
			rela.rtype = encoder.r_x86_64_16
			instr.code << [u8(0), 0]
		}
		.suffix_long {
			rela.rtype = encoder.r_x86_64_32
			instr.code << [u8(0), 0, 0, 0]
		}
		.suffix_quad {
			rela.rtype = encoder.r_x86_64_32s
			instr.code << [u8(0), 0, 0, 0]
		}
	}
	rela_text_users << rela
}

fn (mut instr Instr) add_imm_value(imm_val int, size DataSize) {
	if is_in_i8_range(imm_val) || size == DataSize.suffix_byte {
		instr.code << u8(imm_val)
	} else if size == DataSize.suffix_word {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(imm_val))
		instr.code << hex
	} else if is_in_i32_range(imm_val) {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(imm_val))
		instr.code << hex
	} else {
		panic('unreachable')
	}
}

pub fn rex(w u8, r u8, x u8, b u8) u8 {
	return 64 | (w << 3) | (r << 2) | (x << 1) | b
}

fn (mut instr Instr) add_rex_prefix(regi_r ?string, regi_i ?string, regi_b ?string, size DataSize) {
	mut w, mut r, mut x, mut b := u8(0), u8(0), u8(0), u8(0)
	
	if regi_r or {''} in r8_r15 {
		r = 1
	}
	if regi_i or {''} in r8_r15 {
		x = 1
	}
	if regi_b or {''} in r8_r15 {
		b = 1
	}

	match size {
		.suffix_word {
			instr.code << operand_size_prefix16
		}
		.suffix_quad {
			w = 1
		} else {}
	}

	if w != 0 || r != 0 || b != 0 || x != 0 {
		instr.code << rex(w, r, x, b)
	}
}

fn (mut e Encoder) mov(size DataSize) {
	mut instr := Instr{kind: .mov, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == .suffix_byte {
			[u8(0x88)]
		} else {
			[u8(0x89)]
		}
		source.check_regi_size(size)

		if desti is Register {
			desti.check_regi_size(size)
			instr.add_rex_prefix(source.lit, none, desti.lit, size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, source.regi_bits(), desti.regi_bits())
			return
		}
		if desti is Indirection {
			instr.add_segment_override_prefix(desti)
			instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, size)
			instr.code << op_code
			instr.add_modrm_sib_disp(desti, source.regi_bits())
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
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, size)
		instr.code << op_code
		instr.add_modrm_sib_disp(source, desti.regi_bits())
		return
	}

	if source is Immediate {
		match desti {
			Register {
				desti.check_regi_size(size)
				instr.add_rex_prefix(none, none, desti.lit, size)
				instr.code << if size == .suffix_quad {
					instr.code << 0xc7
					0xc0 + desti.regi_bits()
				} else if size == .suffix_byte {
					0xB0 + desti.regi_bits()
				} else {
					0xB8 + desti.regi_bits()
				}
			}
			Indirection {
				instr.add_segment_override_prefix(desti)
				instr.add_rex_prefix(none, desti.index.lit, desti.base.lit, size)
				instr.code <<  if size == .suffix_byte {
					u8(0xc6)
				} else {
					u8(0xc7)
				}
				instr.add_modrm_sib_disp(desti, encoder.slash_0)
			} else {
				error.print(desti.pos, 'invalid operand for instruction')
				exit(1)
			}
		}

		mut imm_used_symbols := []string{}
		imm_val := eval_expr_get_symbol(source.expr, mut imm_used_symbols)
		if imm_used_symbols.len >= 2 {
			error.print(source.pos, 'invalid immediate operand')
			exit(1)
		}
		imm_need_rela := imm_used_symbols.len == 1

		if imm_need_rela {
			instr.add_imm_rela(imm_used_symbols[0], imm_val, size)
		} else {
			if size == .suffix_byte {
				instr.code << [u8(imm_val)]
			} else if size == .suffix_word {
				mut hex := [u8(0), 0]
				binary.little_endian_put_u16(mut &hex, u16(imm_val))
				instr.code << [hex[0], hex[1]]
			} else {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(imm_val))
				instr.code << [hex[0], hex[1], hex[2], hex[3]]
			}
		}
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) mul(size DataSize) {
	mut instr := Instr{kind: .mul, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()

	if e.tok.kind != .comma {
		op_code := if size == DataSize.suffix_byte {
			[u8(0xf6)]
		} else {
			[u8(0xf7)]
		}
		if source is Register {
			source.check_regi_size(size)
			instr.add_rex_prefix(none, none, source.lit, size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_4, source.regi_bits())
			return
		}
		if source is Indirection {
			instr.add_segment_override_prefix(source)
			instr.add_rex_prefix(none, source.index.lit, source.base.lit, size)
			instr.code << op_code
			instr.add_modrm_sib_disp(source, encoder.slash_4)
			return
		}
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) mov_zero_or_sign_extend(op_code []u8, source_size DataSize, desti_size DataSize) {
	mut instr := Instr{kind: .movzx, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register && desti is Register {
		if desti_size == .suffix_quad && source.lit in ['AH','CH','DH','BH'] {
			error.print(source.pos, 'can\'t encode `%$source.lit` in an instruction requiring REX prefix')
			exit(1)
		}
		source.check_regi_size(source_size)
		desti.check_regi_size(desti_size)
		instr.add_rex_prefix(desti.lit, none, source.lit, desti_size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, desti.regi_bits(), source.regi_bits())
		return
	}
	if source is Indirection && desti is Register {
		desti.check_regi_size(desti_size)
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, desti_size)
		instr.code << op_code
		instr.add_modrm_sib_disp(source, desti.regi_bits())
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) test(size DataSize) {
	mut instr := Instr{kind: .test, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x84)]
		} else {
			[u8(0x84) + 1]
		}
		source.check_regi_size(size)
		if desti is Register {
			desti.check_regi_size(size)
			instr.add_rex_prefix(source.lit, none, desti.lit, size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, source.regi_bits(), desti.regi_bits())
			return
		}
		if desti is Indirection {
			instr.add_segment_override_prefix(desti)
			instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, size)
			instr.code << op_code
			instr.add_modrm_sib_disp(desti, source.regi_bits())
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
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, size)
		instr.code << op_code
		instr.add_modrm_sib_disp(source, desti.regi_bits())
		return
	}
	if source is Immediate {
		mut imm_used_symbols := []string{}
		imm_val := eval_expr_get_symbol(source.expr, mut imm_used_symbols)
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
			instr.add_rex_prefix(none, none, desti.lit, size)
			if desti.lit == 'AL' || (desti.lit in ['EAX', 'RAX'] && !is_in_i8_range(imm_val)) {
				instr.code << if size == DataSize.suffix_byte {
					u8(0xA8)
				} else {
					u8(0xA9)
				}
			} else {
				instr.code << op_code
				instr.code << compose_mod_rm(mod_regi, encoder.slash_0, desti.regi_bits())
			}
		} else if desti is Indirection {
			instr.add_segment_override_prefix(desti)
			instr.add_rex_prefix(none, desti.index.lit, desti.base.lit, size)
			instr.code << op_code
			instr.add_modrm_sib_disp(desti, encoder.slash_0)
		} else {
			error.print(source.pos, 'invalid operand for instruction')
			exit(1)
		}

		if imm_need_rela {
			instr.add_imm_rela(imm_used_symbols[0], imm_val, size)
		} else {
			if size == .suffix_byte {
				instr.code << [u8(imm_val)]
			} else if size == .suffix_word {
				mut hex := [u8(0), 0]
				binary.little_endian_put_u16(mut &hex, u16(imm_val))
				instr.code << [hex[0], hex[1]]
			} else {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(imm_val))
				instr.code << [hex[0], hex[1], hex[2], hex[3]]
			}
		}

		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) arith_instr(kind InstrKind, op_code_base u8, slash u8, size DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == DataSize.suffix_byte {
			[op_code_base]
		} else {
			[op_code_base + 1]
		}
		source.check_regi_size(size)
		if desti is Register {
			desti.check_regi_size(size)
			instr.add_rex_prefix(source.lit, none, desti.lit, size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, source.regi_bits(), desti.regi_bits())
			return
		}
		if desti is Indirection {
			instr.add_segment_override_prefix(desti)
			instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, size)
			instr.code << op_code
			instr.add_modrm_sib_disp(desti, source.regi_bits())
			return
		}
	}
	if source is Indirection && desti is Register {
		op_code := if size == DataSize.suffix_byte {
			[op_code_base + 2]
		} else {
			[op_code_base + 3]
		}
		desti.check_regi_size(size)
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, size)
		instr.code << op_code
		instr.add_modrm_sib_disp(source, desti.regi_bits())
		return
	}
	if source is Immediate {
		mut imm_used_symbols := []string{}
		imm_val := eval_expr_get_symbol(source.expr, mut imm_used_symbols)
		if imm_used_symbols.len >= 2 {
			error.print(source.pos, 'invalid immediate operand')
			exit(1)
		}
		imm_need_rela := imm_used_symbols.len == 1

		op_code := if size == DataSize.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) && !imm_need_rela {
			u8(0x83)
		} else {
			u8(0x81)
		}

		if desti is Register {
			desti.check_regi_size(size)
			instr.add_rex_prefix(none, none, desti.lit, size)
			if desti.lit == 'AL' || (desti.lit in ['EAX', 'RAX'] && !is_in_i8_range(imm_val)) {
				instr.code << if size == DataSize.suffix_byte {
					op_code_base + 4
				} else {
					op_code_base + 5
				}
			} else {
				instr.code << op_code
				instr.code << compose_mod_rm(mod_regi, slash, desti.regi_bits())
			}
		} else if desti is Indirection {
			instr.add_segment_override_prefix(desti)
			instr.add_rex_prefix(none, desti.index.lit, desti.base.lit, size)
			instr.code << op_code
			instr.add_modrm_sib_disp(desti, slash)
		} else {
			error.print(source.pos, 'invalid operand for instruction')
			exit(1)
		}

		if imm_need_rela {
			instr.add_imm_rela(imm_used_symbols[0], imm_val, size)
		} else {
			instr.add_imm_value(imm_val, size)
		}

		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) imul(size DataSize) {
	mut instr := Instr{kind: .imul, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()

	if e.tok.kind != .comma {
		op_code := if size == DataSize.suffix_byte {
			[u8(0xf6)]
		} else {
			[u8(0xf7)]
		}
		if source is Register {
			source.check_regi_size(size)
			instr.add_rex_prefix(none, none, source.lit, size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_5, source.regi_bits())
			return
		}
		if source is Indirection {
			instr.add_segment_override_prefix(source)
			instr.add_rex_prefix(none, source.index.lit, source.base.lit, size)
			instr.code << op_code
			instr.add_modrm_sib_disp(source, encoder.slash_5)
			return
		}
	}

	e.expect(.comma)
	desti_operand_1 := e.parse_operand()

	if source is Indirection && desti_operand_1 is Register {
		desti_operand_1.check_regi_size(size)
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti_operand_1.lit, source.index.lit, source.base.lit, size)
		instr.code << [u8(0x0f), 0xaf]
		instr.add_modrm_sib_disp(source, desti_operand_1.regi_bits())
		return
	}

	if source is Register && desti_operand_1 is Register {
		source.check_regi_size(size)
		desti_operand_1.check_regi_size(size)
		instr.add_rex_prefix(desti_operand_1.lit, none, source.lit, size)
		instr.code << [u8(0x0f), 0xaf]
		instr.code << compose_mod_rm(encoder.mod_regi, desti_operand_1.regi_bits(), source.regi_bits())
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
		imm_val := eval_expr_get_symbol(source.expr, mut imm_used_symbols)
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
		instr.add_rex_prefix(desti_operand_2.lit, none, desti_operand_1.lit, size)
		instr.code << op_code
		instr.code << compose_mod_rm(mod_regi, desti_operand_2.regi_bits(), desti_operand_1.regi_bits())

		if imm_need_rela {
			instr.add_imm_rela(imm_used_symbols[0], imm_val, size)
		} else {
			instr.add_imm_value(imm_val, size)
		}

		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) one_operand_arith(kind InstrKind, slash u8, size DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()

	op_code := if size == DataSize.suffix_byte {
		[u8(0xF6)]
	} else {
		[u8(0xF7)]
	}

	if source is Register {
		source.check_regi_size(size)
		instr.add_rex_prefix(none, none, source.lit, size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, slash, source.regi_bits())
		return
	}
	if source is Indirection {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(none, source.index.lit, source.base.lit, size)
		instr.code << op_code
		instr.add_modrm_sib_disp(source, slash)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) lea(instr_name_upper string) {
	mut instr := Instr{kind: .lea, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Indirection && desti is Register {
		desti.check_regi_size(size)
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix(desti.lit, source.index.lit, source.base.lit, size)
		instr.code << [u8(0x8D)]
		instr.add_modrm_sib_disp(source, desti.regi_bits())
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) set(kind InstrKind, op_code []u8) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	regi := e.parse_operand()

	if regi is Register {
		regi.check_regi_size(DataSize.suffix_byte)
		instr.add_rex_prefix(none, none, regi.lit, DataSize.suffix_byte)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_0, regi.regi_bits())
		return
	}

	error.print(regi.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) shift(kind InstrKind, slash u8, size DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Immediate {
		mut used_symbols := []string{}
		imm_val := eval_expr_get_symbol(source.expr, mut used_symbols)

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
				instr.add_rex_prefix(none, none, desti.lit, size)
				instr.code << op_code
				instr.code << compose_mod_rm(encoder.mod_regi, slash, desti.regi_bits())
			}
			Indirection {
				instr.add_segment_override_prefix(desti)
				instr.add_rex_prefix(none, desti.index.lit, desti.base.lit, size)
				instr.code << op_code
				instr.add_modrm_sib_disp(desti, slash)
			} else {
				error.print(desti.pos, 'invalid operand for instruction')
				exit(1)
			}
		}

		if imm_need_rela {
			rela := &Rela{
				uses: used_symbols[0],
				instr: &instr,
				adjust: imm_val,
				offset: instr.code.len,
				rtype: encoder.r_x86_64_8,
			}
			rela_text_users << rela
			instr.code << 0
		} else if imm_val != 1 {
			instr.code << u8(imm_val)
		}
		return
	}
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
			instr.add_rex_prefix(source.lit, none, desti.lit, size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, slash, desti.regi_bits())
			return
		} else if desti is Indirection {
			instr.add_segment_override_prefix(desti)
			instr.add_rex_prefix(source.lit, desti.index.lit, desti.base.lit, size)
			instr.code << op_code
			instr.add_modrm_sib_disp(desti, slash)
			return
		}
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

