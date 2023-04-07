module encoder

import error
import encoding.binary

/*
- add
- sub
- imul
- idiv
- div
- neg
- not
- and
- cmp
- lea
*/

fn (mut e Encoder) add(instr_name_upper string) {
	pos := e.tok.pos
	size := get_size_by_suffix(instr_name_upper)

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x00)
		} else {
			u8(0x01)
		}
		if desti is Register {
			e.encode_regi_regi(.add, [op_code], source, desti, size, size)
			return
		}
		if desti is Indirection {
			e.encode_indir_regi(.add, [op_code], desti, source, size, size)
			return	
		}
	}
	if source is Immediate && desti is Register {
		rax_magic := if size == encoder.suffix_byte {
			u8(0x04)
		} else {
			u8(0x05)
		}
		e.encode_imm_regi(.add, 0, rax_magic, source, desti, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x02)
		} else {
			u8(0x03)
		}
		e.encode_indir_regi(.add, [op_code], source, desti, size, size)
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
		e.encode_imm_indir(.add, [op_code], slash_0, source, desti, size)
		return
	}
	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) sub(instr_name_upper string) {
	pos := e.tok.pos

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
			e.encode_regi_regi(.sub, [op_code], source, desti, size, size)
			return
		}
		if desti is Indirection {
			e.encode_indir_regi(.sub, [op_code], desti, source, size, size)
			return
		}
	}
	if source is Immediate && desti is Register {
		rax_magic := if size == encoder.suffix_byte {
			u8(0x2C)
		} else {
			u8(0x2D)
		}
		e.encode_imm_regi(.sub, 5, rax_magic, source, desti, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x2A)
		} else {
			u8(0x2B)
		}
		e.encode_indir_regi(.sub, [op_code], source, desti, size, size)
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
		e.encode_imm_indir(.sub, [op_code], 5, source, desti, size)
		return
	}
	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) imul(instr_name_upper string) {
	pos := e.tok.pos

	size := get_size_by_suffix(instr_name_upper)
	source := e.parse_operand()

	if e.tok.kind != .comma {
		op_code := if size == encoder.suffix_byte {
			u8(0xf6)
		} else {
			u8(0xf7)
		}
		if source is Register {
			e.encode_regi(.imul, [op_code], encoder.slash_5, source, size)
			return
		}
		if source is Indirection {
			e.encode_indir(.imul, [op_code], slash_5, source, size)
			return
		}
	}

	e.expect(.comma)
	desti_operand_1 := e.parse_operand()

	if source is Indirection && desti_operand_1 is Register {
		e.encode_indir_regi(.imul, [u8(0x0f), 0xaf], source, desti_operand_1, size, size)
		return
	}
			
	if source is Register && desti_operand_1 is Register {
		e.encode_regi_regi(.imul, [u8(0x0f), 0xaf], desti_operand_1, source, size, size)
		return
	}

	// Both are encoded to the same code.
	// imulq $0x10, %rax
	// imulq $0x10, %rax, %rax
	desti_operand_2 := if e.tok.kind != .comma {
		desti_operand_1
	} else {
		e.expect(.comma)
		e.parse_operand()
	}

	if source is Immediate && desti_operand_1 is Register && desti_operand_2 is Register {
		mut instr := Instr{kind: .imul, pos: pos, section: e.current_section}
		check_regi_size(desti_operand_1, size)
		check_regi_size(desti_operand_2, size)
		mod_rm := compose_mod_rm(mod_regi, regi_bits(desti_operand_2), regi_bits(desti_operand_1))
		if size == encoder.suffix_quad {
			instr.code << encoder.rex_w
		} else if size == encoder.suffix_word {
			instr.code << operand_size_prefix16
		}
		num := eval_expr(source.expr)
		if is_in_i8_range(num) {
			instr.code << 0x6b
			instr.code << mod_rm
			instr.code << u8(num)
		} else if size == encoder.suffix_word {
			instr.code << 0x69
			instr.code << mod_rm
			mut hex := [u8(0), 0]
			binary.little_endian_put_u16(mut &hex, u16(num))
			instr.code << hex
		} else {
			instr.code << 0x69
			instr.code << mod_rm
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			instr.code << hex
		}
		e.instrs[e.current_section] << &instr
		return
	}
	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) idiv(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)

	source := e.parse_operand()
	op_code := if size == encoder.suffix_byte {
		u8(0xF6)
	} else {
		u8(0xF7)
	}
	if source is Register {
		e.encode_regi(.idiv, [op_code], encoder.slash_7, source, size)
		return
	}
	if source is Indirection {
		e.encode_indir(.idiv, [op_code], encoder.slash_7, source, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) div(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)

	source := e.parse_operand()
	op_code := if size == encoder.suffix_byte {
		u8(0xF6)
	} else {
		u8(0xF7)
	}
	if source is Register {
		e.encode_regi(.div, [op_code], encoder.slash_6, source, size)
		return
	}
	if source is Indirection {
		e.encode_indir(.div, [op_code], slash_6, source, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) neg(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	op_code := if size == encoder.suffix_byte {
		u8(0xF6)
	} else {
		u8(0xF7)
	}

	desti := e.parse_operand()

	if desti is Register {
		e.encode_regi(.neg, [op_code], encoder.slash_3, desti, size)
		return
	}
	if desti is Indirection {
		e.encode_indir(.neg, [op_code], slash_3, desti, size)
		return
	}
	error.print(desti.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) not(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)
	op_code := if size == encoder.suffix_byte {
		u8(0xF6)
	} else {
		u8(0xF7)
	}

	desti := e.parse_operand()

	if desti is Register {
		e.encode_regi(.not, [op_code], encoder.slash_2, desti, size)
		return
	}
	if desti is Indirection {
		e.encode_indir(.not, [op_code], slash_2, desti, size)
		return
	}
	error.print(desti.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) xor(instr_name_upper string) {
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
			e.encode_regi_regi(.xor, [op_code], source, desti, size, size)
			return
		}
		if desti is Indirection {
			e.encode_indir_regi(.xor, [op_code], desti, source, size, size)
			return
		}
	}
	if source is Immediate && desti is Register {
		rax_magic := if size == encoder.suffix_byte {
			u8(0x34)
		} else {
			u8(0x35)
		}
		e.encode_imm_regi(.xor, slash_6, rax_magic, source, desti, size)
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
		e.encode_imm_indir(.xor, [op_code], slash_6, source, desti, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x32)
		} else {
			u8(0x33)
		}
		e.encode_indir_regi(.xor, [op_code], source, desti, size, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) and(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Immediate && desti is Register {
		rax_magic := if size == encoder.suffix_byte {
			u8(0x24)
		} else {
			u8(0x25)
		}
		e.encode_imm_regi(.and, slash_4, rax_magic, source, desti, size)
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
		e.encode_imm_indir(.and, [op_code], slash_4, source, desti, size)
		return
	}
	if source is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x20)
		} else {
			u8(0x21)
		}
		if desti is Register {
			e.encode_regi_regi(.and, [op_code], source, desti, size, size)
			return
		}
		if desti is Indirection {
			e.encode_indir_regi(.and, [op_code], desti, source, size, size)
			return
		}
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x22)
		} else {
			u8(0x23)
		}
		e.encode_indir_regi(.and, [op_code], source, desti, size, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) cmp(instr_name_upper string) {
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
			e.encode_regi_regi(.cmp, [op_code], source, desti, size, size)
			return
		}
		if desti is Indirection {
			e.encode_indir_regi(.cmp, [op_code], desti, source, size, size)
			return
		}
	}
	if source is Immediate && desti is Register {
		rax_magic := if size == encoder.suffix_byte {
			u8(0x3C)
		} else {
			u8(0x3D)
		}
		e.encode_imm_regi(.cmp, slash_7, rax_magic, source, desti, size)
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
		e.encode_imm_indir(.cmp, [op_code], slash_7, source, desti, size)
		return
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {u8(0x3A)} else {u8(0x3B)}
		e.encode_indir_regi(.cmp, [op_code], source, desti, size, size)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) lea(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Indirection && desti is Register {
		e.encode_indir_regi(.lea, [u8(0x8d)], source, desti, size, size)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}
