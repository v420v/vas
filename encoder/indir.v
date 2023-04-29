module encoder

import error
import encoding.binary

fn (indir Indirection) base_or_index_is_long() bool {
	return indir.base.size == encoder.suffix_long || indir.index.size == encoder.suffix_long
}

fn (indir Indirection) check_base_register() (bool, bool, bool) {
	if !indir.has_base {
		return false, false, false
	}

	match true {
		indir.base.lit in ['RIP', 'EIP'] {
			return true, false, false
		}
		indir.base.lit in ['RSP', 'ESP'] {
			return false, true, false
		}
		indir.base.lit in ['RBP', 'EBP'] {
			return false, false, true
		} else {
			return false, false, false
		}
	}
}

fn (mut e Encoder) calculate_modrm_sib_disp(indir Indirection, index u8) ([]u8, []u8, bool) {
	if !indir.has_base && !indir.has_index_scale {
		error.print(indir.pos, 'syntax not supported yet. `disp(,,)`')
		exit(1)
	}

	base_is_ip, base_is_sp, base_is_bp := indir.check_base_register()

	disp := eval_expr(indir.disp)

	mut used_symbols := []string{}
	e.get_symbol_from_binop(indir.disp, mut &used_symbols)
	if used_symbols.len >= 2 {
		error.print(indir.disp.pos, 'invalid `disp` for operand indirect')
		exit(1)
	}
	need_rela := used_symbols.len == 1

	// modrm
	mod_rm := if indir.has_index_scale {
		if base_is_ip {
			error.print(indir.index.pos, '%$indir.base.lit.to_lower() as base register can not have an index register')
			exit(1)
		}

		if indir.base.size != indir.index.size && indir.has_base {
			error.print(indir.base.pos, 'base register is $indir.base.size-bit, but index register is not')
			exit(1)
		}

		if !indir.has_base {
			compose_mod_rm(mod_indirection_with_no_disp, index, 0b100)
		} else if need_rela {
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

	mut mod_rm_sib := [mod_rm]

	// scale
	if indir.has_index_scale {
		scale_num := u8(eval_expr(indir.scale))
		if scale_num !in [1, 2, 4, 8] {
			error.print(indir.scale.pos, 'scale factor in address must be 1, 2, 4 or 8')
			exit(0)
		}
		if indir.has_base {
			mod_rm_sib << regi_bits(indir.base) + (regi_bits(indir.index) << 3) + (scale(scale_num) << 6)
		} else {
			mod_rm_sib << 0x5 + (regi_bits(indir.index) << 3) + (scale(scale_num) << 6)
		}
	}

	if base_is_sp && !indir.has_index_scale {
		mod_rm_sib << 0x24
	}

	// disp
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
			uses:   used_symbols[0]
			offset: 0 // assign latter
			rtype:  u64(rtype)
			adjust: eval_expr(indir.disp)
		}
		disp_code = [u8(0), 0, 0, 0]
		e.rela_text_users << rela_text_user
	} else {
		if !indir.has_base {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(disp))
			disp_code << hex
		} else if disp != 0 || base_is_ip || base_is_bp {
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

	return mod_rm_sib, disp_code, need_rela
}
