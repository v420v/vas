module encoder

// I know the code is messy, but it gets the job done for now.
// Leaving this comment here to remind myself to refactor it from scratch
// when I have more time.

import error
import encoding.binary

/*
	Functions for encoding instructions that contain `indirection`.
*/

fn (mut e Encoder) modrm_and_sib_and_disp_symbol(indir Indirection, index u8, base_is_ip bool, base_is_bp bool) (u8, u8, []u8, bool) {
	disp := eval_expr(indir.disp)

	mut used_symbols := []string{}
	e.get_symbol_from_binop(indir.disp, mut &used_symbols)
	if used_symbols.len >= 2 {
		error.print(indir.disp.pos, 'invalid `disp` for operand indirect')
		exit(1)
	}
	need_rela := used_symbols.len == 1

	mod_rm := if indir.has_index_scale {
		if base_is_ip {
			error.print(indir.index.pos, '%$indir.base.lit.to_lower() as base register can not have an index register')
			exit(1)
		}

		if indir.base.size != indir.index.size {
			error.print(indir.base.pos, 'base register is $indir.base.size-bit, but index register is not')
			exit(1)
		}

		if need_rela {
			compose_mod_rm(mod_indirection_with_disp32, index, 0b100)
		} else if disp == 0 && !base_is_bp {
			compose_mod_rm(mod_indirection_with_no_disp, index, 0b100)
		} else if is_in_i8_range(disp) {
			compose_mod_rm(mod_indirection_with_disp8, index, 0b100)
		} else if is_in_i32_range(disp) {
			compose_mod_rm(mod_indirection_with_disp32, index, 0b100)
		} else {
			panic('disp out range!')
		}
	} else {
		if base_is_ip {
			compose_mod_rm(mod_indirection_with_no_disp, index, 0b101) // rip relative
		} else if need_rela {
			compose_mod_rm(mod_indirection_with_disp32, index, regi_bits(indir.base))
		} else if disp == 0 && !base_is_bp {
			compose_mod_rm(mod_indirection_with_no_disp, index, regi_bits(indir.base))
		} else if is_in_i8_range(disp) {
			compose_mod_rm(mod_indirection_with_disp8, index, regi_bits(indir.base))
		} else if is_in_i32_range(disp) {
			compose_mod_rm(mod_indirection_with_disp32, index, regi_bits(indir.base))
		} else {
			panic('disp out range!')
		}
	}

	mut sib := u8(0)
	if indir.has_index_scale {
		scale_num := u8(eval_expr(indir.scale))
		if scale_num !in [1, 2, 4, 8] {
			error.print(indir.scale.pos, 'scale factor in address must be 1, 2, 4 or 8')
			exit(0)
		}
		sib = regi_bits(indir.base) + (regi_bits(indir.index) << 3) + (scale(scale_num) << 6)
	}

	symbol := if need_rela {
		used_symbols[0]
	} else {
		''
	}

	mut disp_code := []u8{}

	if need_rela {
		rtype := if base_is_ip {
			encoder.r_x86_64_pc32
		} else if indir.base.size == suffix_quad {
			encoder.r_x86_64_32s
		} else {
			encoder.r_x86_64_32	
		}
		rela_text_user := encoder.RelaTextUser{
			instr:  unsafe {nil} // assign latter
			uses:   symbol
			offset: 0 // assign latter
			rtype:  u64(rtype)
			adjust: eval_expr(indir.disp)
		}
		disp_code = [u8(0), 0, 0, 0]
		e.rela_text_users << rela_text_user
	} else {
		if disp != 0 || base_is_ip || base_is_bp {
			if base_is_ip {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(disp))
				disp_code << hex
			} else if is_in_i8_range(disp) {
				disp_code << u8(disp)
			} else if is_in_i32_range(disp) {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(disp))
				disp_code << hex
			} else {
				panic('disp out range!')
			}
		}
	}

	return mod_rm, sib, disp_code, need_rela
}

fn (indir Indirection) check_base_register() (bool, bool, bool) {
	is_ip := indir.base.lit in ['RIP', 'EIP']
	is_sp := indir.base.lit in ['RSP', 'ESP']
	is_bp := indir.base.lit in ['RBP', 'EBP']
	return is_ip, is_sp, is_bp
}

// instr indir, regi
fn (mut e Encoder) encode_indir_regi(kind InstrKind, op_code []u8, indir Indirection, regi Register, indir_size int, regi_size int) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: indir.pos}

	check_regi_size(regi, regi_size)

	base_is_ip, base_is_sp, base_is_bp := indir.check_base_register()
	mod_rm, sib, disp, need_rela := e.modrm_and_sib_and_disp_symbol(indir, regi_bits(regi), base_is_ip, base_is_bp)

	if indir.base.size == suffix_long {
		instr.code << 0x67
	}

	if regi_size == suffix_quad {
		instr.code << encoder.rex_w
	} else if regi_size == suffix_word {
		instr.code << encoder.operand_size_prefix16
	}

	instr.code << op_code
	instr.code << mod_rm
	if indir.has_index_scale {
		instr.code << sib
	}

	if base_is_sp && !indir.has_index_scale {
		instr.code << 0x24
	}

	instr_code_len := instr.code.len

	if need_rela {
		e.rela_text_users[e.rela_text_users.len-1].offset = instr_code_len
		e.rela_text_users[e.rela_text_users.len-1].instr = &instr
	}

	instr.code << disp
	e.instrs[e.current_section] << &instr
}

// instr indir
fn (mut e Encoder) encode_indir(kind InstrKind, op_code []u8, slash u8, indir Indirection, size int) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: indir.pos}

	base_is_ip, base_is_sp, base_is_bp := indir.check_base_register()
	mod_rm, sib, disp, need_rela := e.modrm_and_sib_and_disp_symbol(indir, slash, base_is_ip, base_is_bp)

	if indir.base.size == suffix_long {
		instr.code << 0x67
	}

	if op_code == [u8(0xF7)] && (size == suffix_quad || size == suffix_byte) {
		instr.code << encoder.rex_w
	}

	instr.code << op_code
	instr.code << mod_rm
	if indir.has_index_scale {
		instr.code << sib
	}

	if base_is_sp && !indir.has_index_scale {
		instr.code << 0x24
	}

	instr_code_len := instr.code.len

	if need_rela {
		e.rela_text_users[e.rela_text_users.len-1].offset = instr_code_len
		e.rela_text_users[e.rela_text_users.len-1].instr = &instr
	}

	instr.code << disp

	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) encode_imm_indir(kind InstrKind, op_code []u8, slash u8, imm Immediate, indir Indirection,  size int) {
	mut instr := Instr{kind: kind, section: e.current_section, pos: indir.pos}

	base_is_ip, base_is_sp, base_is_bp := indir.check_base_register()
	mod_rm, sib, disp, need_rela := e.modrm_and_sib_and_disp_symbol(indir, slash, base_is_ip, base_is_bp)

	if indir.base.size == suffix_long {
		instr.code << 0x67
	}

	if size == suffix_quad {
		instr.code << encoder.rex_w
	} else if size == suffix_word {
		instr.code << encoder.operand_size_prefix16
	}

	imm_val := eval_expr(imm.expr)

	instr.code << op_code
	instr.code << mod_rm
	if indir.has_index_scale {
		instr.code << sib
	}

	if base_is_sp && !indir.has_index_scale {
		instr.code << 0x24
	}

	instr_code_len := instr.code.len

	if need_rela {
		e.rela_text_users[e.rela_text_users.len-1].offset = instr_code_len
		e.rela_text_users[e.rela_text_users.len-1].instr = &instr
	}

	instr.code << disp

	if kind == .mov {
		if size == suffix_word {
			mut hex := [u8(0), 0]
			binary.little_endian_put_u16(mut &hex, u16(imm_val))
			instr.code << hex
		} else if size == suffix_byte {
			instr.code << u8(imm_val)
		} else {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(imm_val))
			instr.code << hex
		}
	} else {
		if is_in_i8_range(imm_val) || size == suffix_byte {
			instr.code << u8(imm_val)
		} else if size == suffix_word {
			mut hex := [u8(0), 0]
			binary.little_endian_put_u16(mut &hex, u16(imm_val))
			instr.code << hex
		} else if is_in_i32_range(imm_val) {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(imm_val))
			instr.code << hex
		} else {
			panic('PANIC')
		}
	}

	e.instrs[e.current_section] << &instr
}
