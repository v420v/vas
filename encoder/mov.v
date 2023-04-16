module encoder

import error
import encoding.binary

// movq, movl, movw, movb
fn (mut e Encoder) mov(instr_name_upper string) {
	mut instr := Instr{kind: .mov, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x88)
		} else {
			u8(0x89)
		}
		check_regi_size(source, size)
		check_regi_size(desti, size)
		instr.code << add_prefix_byte(size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, regi_bits(source), regi_bits(desti))
		return
	}
	if source is Immediate && desti is Register {
		check_regi_size(desti, size)
		instr.code << add_prefix_byte(size)
		mod_rm := if size == encoder.suffix_quad {
			instr.code << 0xc7
			0xc0 + regi_bits(desti)
		} else if size == encoder.suffix_byte {
			0xB0 + regi_bits(desti)
		} else {
			0xB8 + regi_bits(desti)
		}
		imm_val := eval_expr(source.expr)
		if size == encoder.suffix_byte {
			instr.code << [mod_rm, u8(imm_val)]
		} else if size == encoder.suffix_word {
			mut hex := [u8(0), 0]
			binary.little_endian_put_u16(mut &hex, u16(imm_val))
			instr.code << [mod_rm, hex[0], hex[1]]
		} else {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(imm_val))
			instr.code << [mod_rm, hex[0], hex[1], hex[2], hex[3]]
		}
		return
	}
	if source is Register && desti is Indirection {
		op_code := if size == encoder.suffix_byte {
			u8(0x88)
		} else {
			u8(0x89)
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
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x8a)
		} else {
			u8(0x8b)
		}
		check_regi_size(desti, size)
		if source.base_or_index_is_long() {
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
		op_code := if size == encoder.suffix_byte {
			u8(0xc6)
		} else {
			u8(0xc7)
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
		imm_val := eval_expr(source.expr)
		if size == suffix_byte {
			instr.code << u8(imm_val)
		} else if size == suffix_word {
			mut hex := [u8(0), 0]
			binary.little_endian_put_u16(mut &hex, u16(imm_val))
			instr.code << hex
		} else {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(imm_val))
			instr.code << hex
		}
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// movz...
fn (mut e Encoder) mov_zero_extend(instr_name_upper string) {
	mut instr := Instr{kind: .movzx, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	suffix := instr_name_upper[4..].to_upper()
	exp_source_size := get_size_by_suffix(suffix[..1])
	exp_desti_size := get_size_by_suffix(suffix[1..])

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	op_code := if exp_source_size == encoder.suffix_byte {
		[u8(0x0F), 0xB6]
	} else if exp_source_size == encoder.suffix_word {
		[u8(0x0F), 0xB7]
	} else {
		panic('unreachable')
	}

	if source is Register && desti is Register {
		if exp_desti_size == encoder.suffix_quad && source.lit in ['AH','CH','DH','BH'] {
			error.print(source.pos, 'can\'t encode `%$source.lit` in an instruction requiring REX prefix')
			exit(1)
		}
		check_regi_size(source, exp_source_size)
		check_regi_size(desti, exp_desti_size)
		instr.code << add_prefix_byte(exp_desti_size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, regi_bits(desti), regi_bits(source))
		return
	}
	if source is Indirection && desti is Register {
		check_regi_size(desti, exp_desti_size)
		if source.base_or_index_is_long() {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(exp_desti_size)
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

// movs...
fn (mut e Encoder) mov_sign_extend(instr_name_upper string) {
	mut instr := Instr{kind: .movsx, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	suffix := instr_name_upper[4..].to_upper()
	exp_source_size := get_size_by_suffix(suffix[..1])
	exp_desti_size := get_size_by_suffix(suffix[1..])

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	op_code := if exp_source_size == encoder.suffix_long && exp_desti_size == encoder.suffix_quad {
		[u8(0x63)]
	} else if exp_source_size == encoder.suffix_byte {
		[u8(0x0F), 0xBE]
	} else if exp_source_size == encoder.suffix_word {
		[u8(0x0F), 0xBF]
	} else {
		panic('unreachable')
	}

	if source is Register && desti is Register {
		if exp_desti_size == encoder.suffix_quad && source.lit in ['AH','CH','DH','BH'] {
			error.print(source.pos, 'can\'t encode `%$source.lit` in an instruction requiring REX prefix')
			exit(1)
		}
		check_regi_size(source, exp_source_size)
		check_regi_size(desti, exp_desti_size)
		instr.code << add_prefix_byte(exp_desti_size)
		instr.code << op_code
		instr.code << compose_mod_rm(encoder.mod_regi, regi_bits(desti), regi_bits(source))
		return
	}
	if source is Indirection && desti is Register {
		check_regi_size(desti, exp_desti_size)
		if source.base_or_index_is_long() {
			instr.code << 0x67
		}
		instr.code << add_prefix_byte(exp_desti_size)
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
