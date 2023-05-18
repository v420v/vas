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
		error.print(imm.pos, 'invalid immediate operand indirect')
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
		error.print(imm.pos, 'invalid immediate operand indirect')
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
	if indir.base_or_index_is_long() {
		instr.code << 0x67
	}

	instr.add_prefix_byte(size)
	instr.code << op_code
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

	if indir.base_or_index_is_long() {
		instr.code << 0x67
	}
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

// addq, addl, addw, addb
fn (mut e Encoder) add(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x00)]
		} else {
			[u8(0x01)]
		}
		source.check_regi_size(size)
		if desti is Register {
			desti.check_regi_size(size)
			e.encode_regi(.add, regi_bits(source), desti, op_code, size)
			return
		}
		if desti is Indirection {
			e.encode_indir(.add, regi_bits(source), desti, op_code, size)
			return
		}
	}
	if source is Immediate && desti is Register {
		rax_magic := if size == DataSize.suffix_byte {
			u8(0x04)
		} else {
			u8(0x05)
		}
		desti.check_regi_size(size)
		e.encode_imm_regi_with_ax(.add, source, desti, rax_magic, encoder.slash_0, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x02)]
		} else {
			[u8(0x03)]
		}
		e.encode_indir(.add, regi_bits(desti), source, op_code, size)
		return
	}
	if source is Immediate && desti is Indirection {
		e.encode_imm_indir(.add, source, desti, encoder.slash_0, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// subq, subl, subw, subb
fn (mut e Encoder) sub(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x28)]
		} else {
			[u8(0x29)]
		}
		source.check_regi_size(size)
		if desti is Register {
			desti.check_regi_size(size)
			e.encode_regi(.sub, regi_bits(source), desti, op_code, size)
			return
		}
		if desti is Indirection {
			e.encode_indir(.sub, regi_bits(source), desti, op_code, size)
			return
		}
	}
	if source is Immediate && desti is Register {
		rax_magic := if size == DataSize.suffix_byte {
			u8(0x2C)
		} else {
			u8(0x2D)
		}
		desti.check_regi_size(size)
		e.encode_imm_regi_with_ax(.sub, source, desti, rax_magic, encoder.slash_5, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x2A)]
		} else {
			[u8(0x2B)]
		}
		e.encode_indir(.sub, regi_bits(desti), source, op_code, size)
		return
	}
	if source is Immediate && desti is Indirection {
		e.encode_imm_indir(.sub, source, desti, encoder.slash_5, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// imulq, imull
fn (mut e Encoder) imul(instr_name_upper string) {
	mut instr := Instr{kind: .imul, section: e.current_section, pos: e.tok.pos}

	size := get_size_by_suffix(instr_name_upper)
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
		op_code := [u8(0x0f), 0xaf]
		e.encode_indir(.imul, regi_bits(desti_operand_1), source, op_code, size)
		return
	}

	if source is Register && desti_operand_1 is Register {
		source.check_regi_size(size)
		desti_operand_1.check_regi_size(size)
		op_code := [u8(0x0f), 0xaf]
		e.encode_regi(.imul, regi_bits(desti_operand_1), source, op_code, size)
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
			error.print(source.pos, 'invalid immediate operand indirect')
			exit(1)
		}
		need_rela := imm_used_symbols.len == 1

		op_code := if is_in_i8_range(imm_val) && !need_rela {
			u8(0x6b)
		} else {
			u8(0x69)
		}

		desti_operand_1.check_regi_size(size)
		desti_operand_2.check_regi_size(size)
		instr.add_prefix_byte(size)
		instr.code << op_code
		instr.code << compose_mod_rm(mod_regi, regi_bits(desti_operand_2), regi_bits(desti_operand_1))

		if need_rela {
			rela_text_users := instr.add_imm_rela(imm_used_symbols[0], imm_val, size)
			e.rela_text_users << &rela_text_users
		} else {
			instr.code << encode_imm_value(imm_val, size)
		}

		e.instrs[e.current_section] << &instr
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// idivq, idivl
fn (mut e Encoder) idiv(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()

	op_code := if size == DataSize.suffix_byte {
		[u8(0xF6)]
	} else {
		[u8(0xF7)]
	}

	if source is Register {
		source.check_regi_size(size)
		e.encode_regi(.idiv, encoder.slash_7, source, op_code, size)
		return
	}
	if source is Indirection {
		e.encode_indir(.idiv, encoder.slash_7, source, op_code, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// divq, divl
fn (mut e Encoder) div(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	op_code := if size == DataSize.suffix_byte {
		[u8(0xF6)]
	} else {
		[u8(0xF7)]
	}
	if source is Register {
		source.check_regi_size(size)
		e.encode_regi(.div, encoder.slash_6, source, op_code, size)
		return
	}
	if source is Indirection {
		e.encode_indir(.div, encoder.slash_6, source, op_code, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// negq, negl, negw, negb
fn (mut e Encoder) neg(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	op_code := if size == DataSize.suffix_byte {
		[u8(0xF6)]
	} else {
		[u8(0xF7)]
	}

	desti := e.parse_operand()

	if desti is Register {
		desti.check_regi_size(size)
		e.encode_regi(.neg, encoder.slash_3, desti, op_code, size)
		return
	}
	if desti is Indirection {
		e.encode_indir(.neg, encoder.slash_3, desti, op_code, size)
		return
	}
	error.print(desti.pos, 'invalid operand for instruction')
	exit(1)
}

// notq, notl, notw, notb
fn (mut e Encoder) not(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	op_code := if size == DataSize.suffix_byte {
		[u8(0xF6)]
	} else {
		[u8(0xF7)]
	}

	desti := e.parse_operand()

	if desti is Register {
		desti.check_regi_size(size)
		e.encode_regi(.not, encoder.slash_3, desti, op_code, size)
		return
	}
	if desti is Indirection {
		e.encode_indir(.not, encoder.slash_2, desti, op_code, size)
		return
	}
	error.print(desti.pos, 'invalid operand for instruction')
	exit(1)
}

// xorq, xorl, xorw, xorb
fn (mut e Encoder) xor(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x30)]
		} else {
			[u8(0x31)]
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
	if source is Immediate && desti is Register {
		rax_magic := if size == DataSize.suffix_byte {
			u8(0x34)
		} else {
			u8(0x35)
		}
		desti.check_regi_size(size)
		e.encode_imm_regi_with_ax(.xor, source, desti, rax_magic, encoder.slash_6, size)
		return
	}
	if source is Immediate && desti is Indirection {
		e.encode_imm_indir(.xor, source, desti, encoder.slash_6, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x32)]
		} else {
			[u8(0x33)]
		}
		desti.check_regi_size(size)
		e.encode_indir(.xor, regi_bits(desti), source, op_code, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// andq, andl, andw, andb
fn (mut e Encoder) and(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Immediate && desti is Register {
		rax_magic := if size == DataSize.suffix_byte {
			u8(0x24)
		} else {
			u8(0x25)
		}
		desti.check_regi_size(size)
		e.encode_imm_regi_with_ax(.and, source, desti, rax_magic, encoder.slash_4, size)
		return
	}
	if source is Immediate && desti is Indirection {
		e.encode_imm_indir(.and, source, desti, encoder.slash_4, size)
		return
	}
	if source is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x20)]
		} else {
			[u8(0x21)]
		}
		source.check_regi_size(size)
		if desti is Register {
			desti.check_regi_size(size)
			e.encode_regi(.and, regi_bits(source), desti, op_code, size)
			return
		}
		if desti is Indirection {
			e.encode_indir(.and, regi_bits(source), desti, op_code, size)
			return
		}
	}
	if source is Indirection && desti is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x22)]
		} else {
			[u8(0x23)]
		}
		desti.check_regi_size(size)
		e.encode_indir(.and, regi_bits(desti), source, op_code, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// cmpq, cmpl, cmpw, cmpb
fn (mut e Encoder) cmp(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x38)]
		} else {
			[u8(0x39)]
		}
		source.check_regi_size(size)
		if desti is Register {
			desti.check_regi_size(size)
			e.encode_regi(.cmp, regi_bits(source), desti, op_code, size)
			return
		}
		if desti is Indirection {
			e.encode_indir(.cmp, regi_bits(source), desti, op_code, size)
			return
		}
	}
	if source is Immediate && desti is Register {
		rax_magic := if size == DataSize.suffix_byte {
			u8(0x3C)
		} else {
			u8(0x3D)
		}
		desti.check_regi_size(size)
		e.encode_imm_regi_with_ax(.cmp, source, desti, rax_magic, encoder.slash_7, size)
		return
	}
	if source is Immediate && desti is Indirection {
		e.encode_imm_indir(.cmp, source, desti, encoder.slash_7, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == DataSize.suffix_byte {
			[u8(0x3A)]
		} else {
			[u8(0x3B)]
		}
		desti.check_regi_size(size)
		e.encode_indir(.cmp, regi_bits(desti), source, op_code, size)
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
fn (mut e Encoder) sh(kind InstrKind, instr_name_upper string, slash u8) {
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
			error.print(source.expr.pos, 'invalid immediate')
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
				if desti.base_or_index_is_long() {
					instr.code << 0x67
				}
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
			if desti.base_or_index_is_long() {
				instr.code << 0x67
			}
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

