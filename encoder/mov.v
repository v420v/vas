module encoder

import error
import encoding.binary

fn (mut e Encoder) mov(instr_name_upper string) {
	size := get_size_by_suffix(instr_name_upper)

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x88)
		} else {
			u8(0x89)
		}
		if desti is Register {
			e.encode_regi_regi(.mov, [op_code], source, desti, size, size)
			return
		}
		if desti is Indirection {
			e.encode_indir_regi(.mov, [op_code], desti, source, size, size)
			return
		}
	}
	if source is Indirection && desti is Register {
		op_code := if size == encoder.suffix_byte {
			u8(0x8a)
		} else {
			u8(0x8b)
		}
		e.encode_indir_regi(.mov, [op_code], source, desti, size, size)
		return
	}
	if source is Immediate && desti is Indirection {
		op_code := if size == encoder.suffix_byte {
			u8(0xc6)
		} else {
			u8(0xc7)
		}
		e.encode_imm_indir(.mov, [op_code], slash_0, source, desti, size)
		return
	}
	if source is Immediate && desti is Register {
		mut instr := Instr{kind: .mov, pos: source.pos, section: e.current_section}
		check_regi_size(desti, size)
		mut mod_rm := u8(0)
		if size == encoder.suffix_quad {
			instr.code << [encoder.rex_w, 0xc7]
			mod_rm = 0xc0 + regi_bits(desti)
		} else if size == encoder.suffix_byte {
			mod_rm = 0xB0 + regi_bits(desti)
		} else {
			if size == encoder.suffix_word {
				instr.code << operand_size_prefix16
			}
			mod_rm = 0xB8 + regi_bits(desti)
		}
		num := eval_expr(source.expr)
		if size == encoder.suffix_quad || size == encoder.suffix_long {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			instr.code << [mod_rm, hex[0], hex[1], hex[2], hex[3]]
		} else if size == encoder.suffix_word {
			mut hex := [u8(0), 0]
			binary.little_endian_put_u16(mut &hex, u16(num))
			instr.code << [mod_rm, hex[0], hex[1]]
		} else if size == encoder.suffix_byte {
			instr.code << [mod_rm, u8(num)]
		}
		e.instrs[e.current_section] << &instr
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) mov_zero_extend(instr_name_upper string) {
	suffix := instr_name_upper[4..].to_upper()
	size1 := get_size_by_suffix(suffix[..1])
	size2 := get_size_by_suffix(suffix[1..])

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	op_code := if size1 == encoder.suffix_byte {
		[u8(0x0F), 0xB6]
	} else if size1 == encoder.suffix_word {
		[u8(0x0F), 0xB7]
	} else {
		panic('PANIC')
	}

	if source is Register && desti is Register {
		if size2 == encoder.suffix_quad && source.lit in ['AH','CH','DH','BH'] {
			error.print(source.pos, 'can\'t encode `%$source.lit` in an instruction requiring REX prefix')
			exit(1)
		}
		e.encode_regi_regi(.movzx, op_code, desti, source, size2, size1)
		return
	}
	if source is Indirection && desti is Register {
		e.encode_indir_regi(.movzx, op_code, source, desti, size1, size2)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) mov_sign_extend(instr_name_upper string) {
	suffix := instr_name_upper[4..].to_upper()
	size1 := get_size_by_suffix(suffix[..1])
	size2 := get_size_by_suffix(suffix[1..])

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	op_code := if size1 == encoder.suffix_long && size2 == encoder.suffix_quad {
		[u8(0x63)]
	} else if size1 == encoder.suffix_byte {
		[u8(0x0F), 0xBE]
	} else if size1 == encoder.suffix_word {
		[u8(0x0F), 0xBF]
	} else {
		panic('PANIC')
	}

	if source is Register && desti is Register {
		if size2 == encoder.suffix_quad && source.lit in ['AH','CH','DH','BH'] {
			error.print(source.pos, 'can\'t encode `%$source.lit` in an instruction requiring REX prefix')
			exit(1)
		}
		e.encode_regi_regi(.movsx, op_code, desti, source, size2, size1)
		return
	}
	if source is Indirection && desti is Register {
		e.encode_indir_regi(.movsx, op_code, source, desti, size1, size2)
		return
	}
	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}
