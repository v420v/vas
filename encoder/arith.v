module encoder

import error

fn (mut instr Instr) add_imm_rela(symbol string, imm_val int, size DataSize) RelaTextUser {
	mut rela := RelaTextUser{
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
	return rela
}

// instr_name imm, regi
fn (mut e Encoder) encode_imm_regi_with_ax(kind InstrKind, imm Immediate, regi Register, rax_magic u8, slash u8, size DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	mut imm_used_symbols := []string{}
	imm_val := eval_expr_get_symbol(imm.expr, mut imm_used_symbols)
	if imm_used_symbols.len >= 2 {
		error.print(imm.pos, 'invalid immediate operand')
		exit(1)
	}
	imm_need_rela := imm_used_symbols.len == 1

	regi.check_regi_size(size)
	instr.add_prefix_byte(size)

	if regi.lit == 'AL' || (regi.lit in ['EAX', 'RAX'] && !is_in_i8_range(imm_val)) {
		instr.code << rax_magic
	} else {
		instr.code << if size == .suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) && !imm_need_rela {
			u8(0x83)
		} else {
			u8(0x81)
		}
		instr.code << compose_mod_rm(mod_regi, slash, regi_bits(regi))
	}

	if imm_need_rela {
		rela_text_users := instr.add_imm_rela(imm_used_symbols[0], imm_val, size)
		e.rela_text_users << &rela_text_users
	} else {
		instr.code << encode_imm_value(imm_val, size)
	}
}

// instr_name imm, indir
fn (mut e Encoder) encode_imm_indir(kind InstrKind, imm Immediate, indir Indirection, slash u8, size DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	mut imm_used_symbols := []string{}
	imm_val := eval_expr_get_symbol(imm.expr, mut imm_used_symbols)
	if imm_used_symbols.len >= 2 {
		error.print(imm.pos, 'invalid immediate operand')
		exit(1)
	}
	imm_need_rela := imm_used_symbols.len == 1

	instr.add_segment_override_prefix(indir)
	instr.add_prefix_byte(size)

	instr.code << if size == DataSize.suffix_byte {
		u8(0x80)
	} else if is_in_i8_range(imm_val) && !imm_need_rela {
		u8(0x83)
	} else {
		u8(0x81)
	}

	rela_text_user := instr.add_modrm_sib_disp(indir, slash)
	if rela_text_user != unsafe {nil} {
		e.rela_text_users << rela_text_user
	}

	if imm_need_rela {
		rela_text_users := instr.add_imm_rela(imm_used_symbols[0], imm_val, size)
		e.rela_text_users << &rela_text_users
	} else {
		instr.code << encode_imm_value(imm_val, size)
	}
}

// instr_name indir
fn (mut e Encoder) encode_indir(kind InstrKind, index u8, indir Indirection, op_code []u8, size DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr
	instr.add_segment_override_prefix(indir)
	instr.add_prefix_byte(size)
	instr.code << op_code
	rela_text_user := instr.add_modrm_sib_disp(indir, index)
	if rela_text_user != unsafe {nil} {
		e.rela_text_users << rela_text_user
	}
}

// instr_name regi
fn (mut e Encoder) encode_regi(kind InstrKind, index u8, desti_regi Register, op_code []u8, size DataSize) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr
	instr.add_prefix_byte(size)
	instr.code << op_code
	instr.code << compose_mod_rm(encoder.mod_regi, index, regi_bits(desti_regi))
}

fn (mut e Encoder) arith_instr(kind InstrKind, op_code_base u8, slash u8, size DataSize) {
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
			e.encode_regi(.xor, regi_bits(source), desti, op_code, size)
			return
		}
		if desti is Indirection {
			e.encode_indir(.xor, regi_bits(source), desti, op_code, size)
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
		e.encode_indir(.xor, regi_bits(desti), source, op_code, size)
		return
	}
	if source is Immediate && desti is Register {
		rax_magic := if size == DataSize.suffix_byte {
			op_code_base + 4
		} else {
			op_code_base + 5
		}
		desti.check_regi_size(size)
		e.encode_imm_regi_with_ax(.xor, source, desti, rax_magic, slash, size)
		return
	}
	if source is Immediate && desti is Indirection {
		e.encode_imm_indir(.xor, source, desti, slash, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// imulq, imull, imulw
fn (mut e Encoder) imul(size DataSize) {
	source := e.parse_operand()

	if e.tok.kind != .comma {
		op_code := if size == DataSize.suffix_byte {
			[u8(0xf6)]
		} else {
			[u8(0xf7)]
		}
		if source is Register {
			source.check_regi_size(size)
			e.encode_regi(.imul, encoder.slash_5, source, op_code, size)
			return
		}
		if source is Indirection {
			e.encode_indir(.imul, encoder.slash_5, source, op_code, size)
			return
		}
	}

	e.expect(.comma)
	desti_operand_1 := e.parse_operand()

	if source is Indirection && desti_operand_1 is Register {
		desti_operand_1.check_regi_size(size)
		e.encode_indir(.imul, regi_bits(desti_operand_1), source, [u8(0x0f), 0xaf], size)
		return
	}

	if source is Register && desti_operand_1 is Register {
		source.check_regi_size(size)
		desti_operand_1.check_regi_size(size)
		e.encode_regi(.imul, regi_bits(desti_operand_1), source, [u8(0x0f), 0xaf], size)
		return
	}

	desti_operand_2 := if e.tok.kind != .comma {
		desti_operand_1
	} else {
		e.expect(.comma)
		e.parse_operand()
	}

	if source is Immediate && desti_operand_1 is Register && desti_operand_2 is Register {
		mut instr := Instr{kind: .imul, section: e.current_section, pos: e.tok.pos}
		e.instrs[e.current_section] << &instr

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
		instr.add_prefix_byte(size)
		instr.code << op_code
		instr.code << compose_mod_rm(mod_regi, regi_bits(desti_operand_2), regi_bits(desti_operand_1))

		if imm_need_rela {
			rela_text_users := instr.add_imm_rela(imm_used_symbols[0], imm_val, size)
			e.rela_text_users << &rela_text_users
		} else {
			instr.code << encode_imm_value(imm_val, size)
		}

		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) one_operand_arith(kind InstrKind, slash u8, size DataSize) {
	source := e.parse_operand()

	op_code := if size == DataSize.suffix_byte {
		[u8(0xF6)]
	} else {
		[u8(0xF7)]
	}

	if source is Register {
		source.check_regi_size(size)
		e.encode_regi(kind, slash, source, op_code, size)
		return
	}
	if source is Indirection {
		e.encode_indir(kind, slash, source, op_code, size)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// leaq, leal
fn (mut e Encoder) lea(instr_name_upper string) {
	mut instr := Instr{kind: .lea, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Indirection && desti is Register {
		op_code := [u8(0x8d)]
		desti.check_regi_size(size)
		e.encode_indir(.lea, regi_bits(desti), source, op_code, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// setg, setle, setge, sete, setne
fn (mut e Encoder) set(kind InstrKind, op_code []u8) {
	regi := e.parse_operand()

	if regi is Register {
		regi.check_regi_size(DataSize.suffix_byte)
		e.encode_regi(kind, encoder.slash_0, regi, op_code, DataSize.suffix_byte)
		return
	}
	error.print(regi.pos, 'invalid operand for instruction')
	exit(1)
}

// shl, shr
fn (mut e Encoder) shift(kind InstrKind, instr_name_upper string, slash u8) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	size := get_size_by_suffix(instr_name_upper)
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
				instr.add_prefix_byte(size)
				instr.code << op_code
				instr.code << compose_mod_rm(encoder.mod_regi, slash, regi_bits(desti))
			}
			Indirection {
				instr.add_segment_override_prefix(desti)
				instr.add_prefix_byte(size)
				instr.code << op_code
				rela_text_user := instr.add_modrm_sib_disp(desti, slash)
				if rela_text_user != unsafe {nil} {
					e.rela_text_users << rela_text_user
				}
			} else {
				error.print(desti.pos, 'invalid operand for instruction')
				exit(1)
			}
		}

		if imm_need_rela {
			rela_text_users := &RelaTextUser{
				uses: used_symbols[0],
				instr: &instr,
				adjust: imm_val,
				offset: instr.code.len,
				rtype: encoder.r_x86_64_8,
			}
			e.rela_text_users << rela_text_users
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
			instr.add_prefix_byte(size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, slash, regi_bits(desti))
			return
		} else if desti is Indirection {
			instr.add_segment_override_prefix(desti)
			instr.add_prefix_byte(size)
			instr.code << op_code
			rela_text_user := instr.add_modrm_sib_disp(desti, slash)
			if rela_text_user != unsafe {nil} {
				e.rela_text_users << rela_text_user
			}
			return
		}
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

