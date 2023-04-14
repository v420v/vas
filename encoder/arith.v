module encoder

// I know the code is messy, but it gets the job done for now.
// Leaving this comment here to remind myself to refactor it from scratch
// when I have more time. 

import error

// addq, addl, addw, addb
fn (mut e Encoder) add(instr_name_upper string) {
	mut instr := Instr{kind: .add, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x00)
		} else {
			u8(0x01)
		}
		check_regi_size(source, size)
		check_regi_size(desti, size)
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, regi_bits(source), regi_bits(desti))
		return
	}
	if source is Register && desti is Indirection {
		op_code := if size == encoder.suffix_byte {
			u8(0x00)
		} else {
			u8(0x01)
		}
		check_regi_size(source, size)
		if desti.base.size == suffix_long || desti.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, regi_bits(source))
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return	
	}
	if source is Immediate && desti is Register {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}
		rax_magic := if size == encoder.suffix_byte {
			u8(0x04)
		} else {
			u8(0x05)
		}
		check_regi_size(desti, size)
		instr.code << add_prefix_byte(size)
		mod_rm := compose_mod_rm(mod_regi, encoder.slash_0, regi_bits(desti))
		if desti.lit in ['AL', 'EAX', 'RAX'] && !is_in_i8_range(imm_val) {
			instr.code << rax_magic
		} else {
			instr.code << op_code
			instr.code << mod_rm
		}
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x02)
		} else {
			u8(0x03)
		}
		if source.base.size == suffix_long || source.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, regi_bits(desti))
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	if source is Immediate && desti is Indirection {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}

		if desti.base.size == suffix_long || desti.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, encoder.slash_0)
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// subq, subl, subw, subb
fn (mut e Encoder) sub(instr_name_upper string) {
	mut instr := Instr{kind: .sub, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x28)
		} else {
			u8(0x29)
		}
		if desti is Register {
			check_regi_size(source, size)
			check_regi_size(desti, size)
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, regi_bits(source), regi_bits(desti))
			return
		}
		if desti is Indirection {
			check_regi_size(source, size)
			if desti.base.size == suffix_long || desti.index.size == suffix_long {
				instr.code << 0x67
			}
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, regi_bits(source))
			instr.code << mod_rm_sib
			if need_rela {
				e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
				e.rela_text_users[e.rela_text_users.len-1].instr = &instr
			}
			instr.code << disp
			return
		}
	}
	if source is Immediate && desti is Register {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}
		rax_magic := if size == encoder.suffix_byte {
			u8(0x2C)
		} else {
			u8(0x2D)
		}
		check_regi_size(desti, size)
		instr.code << add_prefix_byte(size)
		mod_rm := compose_mod_rm(mod_regi, encoder.slash_5, regi_bits(desti))
		if desti.lit in ['AL', 'EAX', 'RAX'] && !is_in_i8_range(imm_val) {
			instr.code << rax_magic
		} else {
			instr.code << op_code
			instr.code << mod_rm
		}
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x2A)
		} else {
			u8(0x2B)
		}
		if source.base.size == suffix_long || source.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, regi_bits(desti))
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	if source is Immediate && desti is Indirection {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}
		if desti.base.size == suffix_long || desti.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, encoder.slash_5)
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// imulq, imull
fn (mut e Encoder) imul(instr_name_upper string) {
	mut instr := Instr{kind: .imul, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()

	if e.tok.kind != .comma {
		op_code := if size == encoder.suffix_byte {
			u8(0xf6)
		} else {
			u8(0xf7)
		}
		if source is Register {
			instr.code << add_prefix_byte(size)
			check_regi_size(source, size)
			mod_rm := compose_mod_rm(encoder.mod_regi, encoder.slash_5, regi_bits(source))
			instr.code << op_code
			instr.code << mod_rm
			return
		}
		if source is Indirection {
			if source.base.size == suffix_long || source.index.size == suffix_long {
				instr.code << 0x67
			}
			if op_code == u8(0xF7) && size == suffix_quad {
				instr.code << encoder.rex_w
			}
			instr.code << op_code
			mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, encoder.slash_5)
			instr.code << mod_rm_sib
			if need_rela {
				e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
				e.rela_text_users[e.rela_text_users.len-1].instr = &instr
			}
			instr.code << disp
			return
		}
	}

	e.expect(.comma)
	desti_operand_1 := e.parse_operand()

	if source is Indirection && desti_operand_1 is Register {
		op_code := [u8(0x0f), 0xaf]
		if source.base.size == suffix_long || source.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, regi_bits(desti_operand_1))
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
			
	if source is Register && desti_operand_1 is Register {
		op_code := [u8(0x0f), 0xaf]
		check_regi_size(source, size)
		check_regi_size(desti_operand_1, size)
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, regi_bits(desti_operand_1), regi_bits(source))
		return
	}

	desti_operand_2 := if e.tok.kind != .comma {
		desti_operand_1
	} else {
		e.expect(.comma)
		e.parse_operand()
	}

	if source is Immediate && desti_operand_1 is Register && desti_operand_2 is Register {
		imm_val := eval_expr(source.expr)
		op_code := if is_in_i8_range(imm_val) {
			u8(0x6b)
		} else {
			u8(0x69)
		}
		check_regi_size(desti_operand_1, size)
		check_regi_size(desti_operand_2, size)
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm := compose_mod_rm(mod_regi, regi_bits(desti_operand_2), regi_bits(desti_operand_1))
		instr.code << mod_rm
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// idivq, idivl
fn (mut e Encoder) idiv(instr_name_upper string) {
	mut instr := Instr{kind: .idiv, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()

	op_code := if size == encoder.suffix_byte {
		u8(0xF6)
	} else {
		u8(0xF7)
	}

	if source is Register {
		instr.code << add_prefix_byte(size)
		check_regi_size(source, size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_7, regi_bits(source))
		return
	}
	if source is Indirection {
		if source.base.size == suffix_long || source.index.size == suffix_long {
			instr.code << 0x67
		}
		if op_code == u8(0xF7) && size == suffix_quad {
			instr.code << encoder.rex_w
		}
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, encoder.slash_7)
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// divq, divl
fn (mut e Encoder) div(instr_name_upper string) {
	mut instr := Instr{kind: .div, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	op_code := if size == encoder.suffix_byte {
		u8(0xF6)
	} else {
		u8(0xF7)
	}
	if source is Register {
		if size == encoder.suffix_quad {
			instr.code << encoder.rex_w
		} else if size == encoder.suffix_word {
			instr.code << encoder.operand_size_prefix16
		}
		check_regi_size(source, size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_6, regi_bits(source))
		return
	}
	if source is Indirection {
		if source.base.size == suffix_long || source.index.size == suffix_long {
			instr.code << 0x67
		}
		if op_code == u8(0xF7) && size == suffix_quad {
			instr.code << encoder.rex_w
		}
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, encoder.slash_6)
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// negq, negl, negw, negb
fn (mut e Encoder) neg(instr_name_upper string) {
	mut instr := Instr{kind: .neg, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	op_code := if size == encoder.suffix_byte {
		u8(0xF6)
	} else {
		u8(0xF7)
	}

	desti := e.parse_operand()

	if desti is Register {
		if size == encoder.suffix_quad {
			instr.code << encoder.rex_w
		} else if size == encoder.suffix_word {
			instr.code << encoder.operand_size_prefix16
		}
		check_regi_size(desti, size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_3, regi_bits(desti))
		return
	}
	if desti is Indirection {
		if desti.base.size == suffix_long || desti.index.size == suffix_long {
			instr.code << 0x67
		}
		if op_code == u8(0xF7) && (size == suffix_quad || size == suffix_byte) {
			instr.code << encoder.rex_w
		}
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, encoder.slash_3)
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	error.print(desti.pos, 'invalid operand for instruction')
	exit(1)
}

// notq, notl, notw, notb
fn (mut e Encoder) not(instr_name_upper string) {
	mut instr := Instr{kind: .not, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	op_code := if size == encoder.suffix_byte {
		u8(0xF6)
	} else {
		u8(0xF7)
	}

	desti := e.parse_operand()

	if desti is Register {
		if size == encoder.suffix_quad {
			instr.code << encoder.rex_w
		} else if size == encoder.suffix_word {
			instr.code << encoder.operand_size_prefix16
		}
		check_regi_size(desti, size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, encoder.slash_2, regi_bits(desti))
		return
	}
	if desti is Indirection {
		if desti.base.size == suffix_long || desti.index.size == suffix_long {
			instr.code << 0x67
		}
		if op_code == u8(0xF7) && (size == suffix_quad || size == suffix_byte) {
			instr.code << encoder.rex_w
		}
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, encoder.slash_2)
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	error.print(desti.pos, 'invalid operand for instruction')
	exit(1)
}

// xorq, xorl, xorw, xorb
fn (mut e Encoder) xor(instr_name_upper string) {
	mut instr := Instr{kind: .xor, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x30)
		} else {
			u8(0x31)
		}
		if desti is Register {
			check_regi_size(source, size)
			check_regi_size(desti, size)
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, regi_bits(source), regi_bits(desti))
			return
		}
		if desti is Indirection {
			check_regi_size(source, size)

			if desti.base.size == suffix_long || desti.index.size == suffix_long {
				instr.code << 0x67
			}
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, regi_bits(source))
			instr.code << mod_rm_sib
			if need_rela {
				e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
				e.rela_text_users[e.rela_text_users.len-1].instr = &instr
			}
			instr.code << disp
			return
		}
	}
	if source is Immediate && desti is Register {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}
		rax_magic := if size == encoder.suffix_byte {
			u8(0x34)
		} else {
			u8(0x35)
		}
		check_regi_size(desti, size)
		instr.code << add_prefix_byte(size)
		mod_rm := compose_mod_rm(mod_regi, encoder.slash_6, regi_bits(desti))
		if desti.lit in ['AL', 'EAX', 'RAX'] && !is_in_i8_range(imm_val) {
			instr.code << rax_magic
		} else {
			instr.code << op_code
			instr.code << mod_rm
		}
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	if source is Immediate && desti is Indirection {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}
		
		if desti.base.size == suffix_long || desti.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, encoder.slash_6)
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x32)
		} else {
			u8(0x33)
		}
		if source.base.size == suffix_long || source.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, regi_bits(desti))
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// andq, andl, andw, andb
fn (mut e Encoder) and(instr_name_upper string) {
	mut instr := Instr{kind: .and, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Immediate && desti is Register {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}
		rax_magic := if size == encoder.suffix_byte {
			u8(0x24)
		} else {
			u8(0x25)
		}
		check_regi_size(desti, size)
		instr.code << add_prefix_byte(size)
		mod_rm := compose_mod_rm(mod_regi, encoder.slash_4, regi_bits(desti))
		if desti.lit in ['AL', 'EAX', 'RAX'] && !is_in_i8_range(imm_val) {
			instr.code << rax_magic
		} else {
			instr.code << op_code
			instr.code << mod_rm
		}
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	if source is Immediate && desti is Indirection {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}
		if desti.base.size == suffix_long || desti.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, encoder.slash_4)
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	if source is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x20)
		} else {
			u8(0x21)
		}
		if desti is Register {
			check_regi_size(source, size)
			check_regi_size(desti, size)
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, regi_bits(source), regi_bits(desti))
			return
		}
		if desti is Indirection {
			check_regi_size(source, size)
			if desti.base.size == suffix_long || desti.index.size == suffix_long {
				instr.code << 0x67
			}
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, regi_bits(source))
			instr.code << mod_rm_sib
			if need_rela {
				e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
				e.rela_text_users[e.rela_text_users.len-1].instr = &instr
			}
			instr.code << disp
			return
		}
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x22)
		} else {
			u8(0x23)
		}
		if source.base.size == suffix_long || source.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, regi_bits(desti))
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// cmpq, cmpl, cmpw, cmpb
fn (mut e Encoder) cmp(instr_name_upper string) {
	mut instr := Instr{kind: .cmp, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x38)
		} else {
			u8(0x39)
		}
		if desti is Register {
			check_regi_size(source, size)
			check_regi_size(desti, size)
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, regi_bits(source), regi_bits(desti))
			return
		}
		if desti is Indirection {
			check_regi_size(source, size)
			if desti.base.size == suffix_long || desti.index.size == suffix_long {
				instr.code << 0x67
			}
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, regi_bits(source))
			instr.code << mod_rm_sib
			if need_rela {
				e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
				e.rela_text_users[e.rela_text_users.len-1].instr = &instr
			}
			instr.code << disp
			return
		}
	}
	if source is Immediate && desti is Register {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}
		rax_magic := if size == encoder.suffix_byte {
			u8(0x3C)
		} else {
			u8(0x3D)
		}
		check_regi_size(desti, size)
		instr.code << add_prefix_byte(size)
		mod_rm := compose_mod_rm(mod_regi, slash_7, regi_bits(desti))
		if desti.lit in ['AL', 'EAX', 'RAX'] && !is_in_i8_range(imm_val) {
			instr.code << rax_magic
		} else {
			instr.code << op_code
			instr.code << mod_rm
		}
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	if source is Immediate && desti is Indirection {
		imm_val := eval_expr(source.expr)
		op_code := if size == encoder.suffix_byte {
			u8(0x80)
		} else if is_in_i8_range(imm_val) {
			u8(0x83)
		} else {
			u8(0x81)
		}
		if desti.base.size == suffix_long || desti.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, encoder.slash_7)
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		instr.code << encode_imm_value(imm_val, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x3A)
		} else {
			u8(0x3B)
		}
		if source.base.size == suffix_long || source.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, regi_bits(desti))
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// leaq, leal
fn (mut e Encoder) lea(instr_name_upper string) {
	mut instr := Instr{kind: .lea, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Indirection && desti is Register {
		op_code := u8(0x8d)
		if source.base.size == suffix_long || source.index.size == suffix_long {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(source, regi_bits(desti))
		instr.code << mod_rm_sib
		if need_rela {
			e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
			e.rela_text_users[e.rela_text_users.len-1].instr = &instr
		}
		instr.code << disp
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// setg, setle, setge, sete, setne
fn (mut e Encoder) set(kind InstrKind, op_code []u8) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	regi := e.parse_operand()

	if regi is Register {
		check_regi_size(regi, encoder.suffix_byte)
		mod_rm := compose_mod_rm(encoder.mod_regi, encoder.slash_0, regi_bits(regi))
		instr.code << op_code
		instr.code << mod_rm
		return
	}
	error.print(regi.pos, 'invalid operand for instruction')
	exit(1)
}

// shl, shlr
fn (mut e Encoder) sh(kind InstrKind, instr_name_upper string, slash u8) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: e.tok.pos}

	defer {
		e.instrs[e.current_section] << &instr
	}

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Immediate {
		imm_val := eval_expr(source.expr)
		op_code := if imm_val == 1 {
			if size == encoder.suffix_byte {
				u8(0xD0)
			} else  {
				u8(0xD1)	
			}
		} else {
			if size == encoder.suffix_byte {
				u8(0xC0)
			} else {
				u8(0xC1)
			}
		}
		if desti is Register {
			check_regi_size(desti, size)
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, slash, regi_bits(desti))
			if imm_val != 1 {
				instr.code << u8(imm_val)
			}
		} else if desti is Indirection {
			if desti.base.size == suffix_long || desti.index.size == suffix_long {
				instr.code << 0x67
			}
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, slash)
			instr.code << mod_rm_sib
			if need_rela {
				e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
				e.rela_text_users[e.rela_text_users.len-1].instr = &instr
			}
			instr.code << disp
			if imm_val != 1 {
				instr.code << u8(imm_val)
			}
		}
		return
	}
	if source is Register {
		if source.lit != 'CL' {
			error.print(source.pos, 'invalid operand for instruction')
			exit(1)
		}
		op_code := if size == encoder.suffix_byte {
			u8(0xD2)
		} else {
			u8(0xD3)
		}
		if desti is Register {
			check_regi_size(desti, size)
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			instr.code << compose_mod_rm(encoder.mod_regi, slash, regi_bits(desti))
			return
		} else if desti is Indirection {
			if desti.base.size == suffix_long || desti.index.size == suffix_long {
				instr.code << 0x67
			}
			instr.code << add_prefix_byte(size)
			instr.code << op_code
			mod_rm_sib, disp, need_rela := e.calculate_modrm_sib_disp(desti, slash)
			instr.code << mod_rm_sib
			if need_rela {
				e.rela_text_users[e.rela_text_users.len-1].offset = instr.code.len
				e.rela_text_users[e.rela_text_users.len-1].instr = &instr
			}
			instr.code << disp
			return
		}
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

