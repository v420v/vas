module encoder

import error
import encoding.binary

fn (mut e Encoder) add_segment_override_prefix(indir Indirection) {
	if indir.base.size == .suffix_long || indir.index.size == .suffix_long {
		e.current_instr.code << 0x67
	}
}

fn scale(n u8) u8 {
	match n {
		1 {
			return 0
		}
		2 {
			return 1
		}
		4 {
			return 2
		}
		8 {
			return 3
		} else {
			panic('scale unreachable')
		}
	}
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

fn (mut e Encoder) add_modrm_sib_disp(indir Indirection, index u8) {
	if !indir.has_base && !indir.has_index_scale {
		error.print(indir.pos, 'syntax not supported yet. `disp(,,)`')
		exit(1)
	}

	base_is_ip, base_is_sp, base_is_bp := indir.check_base_register()

	mut used_symbols := []string{}
	disp := int(eval_expr_get_symbol_64(indir.disp, mut used_symbols))
	if used_symbols.len >= 2 {
		error.print(indir.disp.pos, 'invalid operand')
		exit(1)
	}
	disp_need_rela := used_symbols.len == 1

	if indir.has_index_scale {
		if base_is_ip {
			error.print(indir.index.pos, '%$indir.base.lit.to_lower() as base register can not have an index register')
			exit(1)
		}

		if indir.base.size != indir.index.size && indir.has_base {
			error.print(indir.base.pos, 'base register is $indir.base.size-bit, but index register is not')
			exit(1)
		}

		if !indir.has_base {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_no_disp, index, 0b100)
		} else if disp_need_rela {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_disp32, index, 0b100)
		} else if disp == 0 && !base_is_bp {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_no_disp, index, 0b100)
		} else if is_in_i8_range(disp) {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_disp8, index, 0b100)
		} else if is_in_i32_range(disp) {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_disp32, index, 0b100)
		} else {
			panic('disp out range!')
		}
	} else {
		if base_is_ip {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_no_disp, index, 0b101) // rip relative
		} else if disp_need_rela {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_disp32, index, indir.base.base_offset%8)
		} else if disp == 0 && !base_is_bp {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_no_disp, index, indir.base.base_offset%8)
		} else if is_in_i8_range(disp) {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_disp8, index, indir.base.base_offset%8)
		} else if is_in_i32_range(disp) {
			e.current_instr.code << compose_mod_rm(mod_indirection_with_disp32, index, indir.base.base_offset%8)
		} else {
			panic('disp out range!')
		}
	}

	// add sib byte
	if indir.has_index_scale {
		scale_num := u8(eval_expr(indir.scale))
		if scale_num !in [1, 2, 4, 8] {
			error.print(indir.scale.pos, 'scale factor in address must be 1, 2, 4 or 8')
			exit(0)
		}
		if indir.has_base {
			e.current_instr.code << indir.base.base_offset%8 + (indir.index.base_offset%8 << 3) + (scale(scale_num) << 6)
		} else {
			e.current_instr.code << 0x5 + (indir.index.base_offset%8 << 3) + (scale(scale_num) << 6)
		}
	} else if base_is_sp || indir.base.base_offset == 12 {
		e.current_instr.code << 0x24
	}

	// disp
	if disp_need_rela {
		rtype := if base_is_ip {
			encoder.r_x86_64_pc32
		} else if indir.base.size == .suffix_quad {
			encoder.r_x86_64_32s
		} else {
			encoder.r_x86_64_32	
		}
		rela := encoder.Rela{
			instr: e.current_instr
			uses:   used_symbols[0]
			offset: e.current_instr.code.len
			rtype:  u64(rtype)
			adjust: eval_expr(indir.disp)
		}
		e.rela_text_users << rela
		e.current_instr.code << [u8(0), 0, 0, 0]
	} else {
		if !indir.has_base {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(disp))
			e.current_instr.code << hex
		} else if disp != 0 || base_is_ip || base_is_bp {
			if base_is_ip {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(disp))
				e.current_instr.code << hex
			} else if is_in_i8_range(disp) {
				e.current_instr.code << u8(disp)
			} else if is_in_i32_range(disp) {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(disp))
				e.current_instr.code << hex
			}
		}
	}
}
