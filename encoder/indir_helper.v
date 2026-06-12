module encoder

import error
import encoding.binary

fn (mut e Encoder) add_segment_override_prefix(indir Indirection) {
	// Segment override (CS/DS/ES/SS/FS/GS) — emitted as a prefix byte
	// before the rest of the instruction. In 64-bit mode CS/DS/ES/SS
	// are usually null, but FS/GS are still meaningful (TLS).
	match indir.segment {
		'CS' { e.current_instr.code << 0x2E }
		'SS' { e.current_instr.code << 0x36 }
		'DS' { e.current_instr.code << 0x3E }
		'ES' { e.current_instr.code << 0x26 }
		'FS' { e.current_instr.code << 0x64 }
		'GS' { e.current_instr.code << 0x65 }
		else {}
	}
	// Address-size override (0x67) for 32-bit base/index in 64-bit mode.
	if indir.base.size == .suffix_long || indir.index.size == .suffix_long {
		e.current_instr.code << 0x67
	}
}

// disp_modifier finds the `@MODIFIER` carried by a symbol inside a displacement
// expression (e.g. the `tpoff` in `%fs:x@tpoff` or `gotpcrel` in
// `sym@gotpcrel(%rip)`).
fn disp_modifier(expr Expr) string {
	return match expr {
		Ident { expr.modifier }
		Binop {
			m := disp_modifier(expr.left_hs)
			if m != '' { m } else { disp_modifier(expr.right_hs) }
		}
		Neg { disp_modifier(expr.expr) }
		Immediate { disp_modifier(expr.expr) }
		else { '' }
	}
}

// modifier_to_reloc maps a `@MODIFIER` to its x86-64 relocation type. The bool
// is false when the modifier isn't a recognized GOT/PLT/TLS flavor.
fn modifier_to_reloc(modifier string) (u64, bool) {
	rt := match modifier {
		'plt' { encoder.r_x86_64_plt32 }
		'gotpcrel', 'gotpcrelx' { encoder.r_x86_64_gotpcrel }
		'gottpoff' { encoder.r_x86_64_gottpoff }
		'tlsgd' { encoder.r_x86_64_tlsgd }
		'tlsld' { encoder.r_x86_64_tlsld }
		'tpoff' { encoder.r_x86_64_tpoff32 }
		'dtpoff' { encoder.r_x86_64_dtpoff32 }
		'got' { encoder.r_x86_64_got32 }
		'gotoff' { encoder.r_x86_64_gotoff64 }
		else { encoder.r_x86_64_none }
	}
	return rt, rt != encoder.r_x86_64_none
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

	// RIP/EIP: instruction-pointer-relative addressing (handled specially).
	if indir.base.lit in ['RIP', 'EIP'] {
		return true, false, false
	}

	// The ModR/M r/m and SIB base fields only encode the low 3 bits of the
	// register number, so RSP/RBP's addressing quirks are shared by their
	// REX-extended cousins R12/R13:
	//   low3 == 4 (RSP, R12): r/m or SIB base = 100 means "SIB byte follows",
	//                         so a SIB byte is always required.
	//   low3 == 5 (RBP, R13): r/m or SIB base = 101 with mod=00 means
	//                         "disp32 / no base", so a displacement (mod >= 01)
	//                         must be emitted even when it is zero.
	low3 := indir.base.base_offset % 8
	return false, low3 == 4, low3 == 5
}

fn (mut e Encoder) add_modrm_sib_disp(indir Indirection, index u8) {
	if !indir.has_base && !indir.has_index_scale {
		// Bare-displacement form like `%fs:0` or `disp` (absolute addressing).
		// In 64-bit mode this requires ModR/M mod=00 r/m=100 (SIB follows)
		// + SIB index=100 (none) base=101 (no base) + 32-bit disp.
		mut used_symbols := []string{}
		disp := int(eval_expr_get_symbol_64(indir.disp, mut used_symbols))
		if used_symbols.len >= 2 {
			error.print(indir.disp.pos, 'invalid operand')
			exit(1)
		}
		e.current_instr.code << compose_mod_rm(mod_indirection_with_no_disp, index, 0b100)
		e.current_instr.code << 0x25
		if used_symbols.len == 1 {
			// `%seg:sym@tpoff` etc. select a TLS/GOT relocation; otherwise this
			// is a plain absolute 32-bit reference.
			mrt, mok := modifier_to_reloc(disp_modifier(indir.disp))
			e.rela_text_users << encoder.Rela{
				instr:  e.current_instr
				uses:   used_symbols[0]
				offset: e.current_instr.code.len
				rtype:  if mok { mrt } else { encoder.r_x86_64_32 }
				adjust: disp
			}
			e.current_instr.code << [u8(0), 0, 0, 0]
		} else {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(disp))
			e.current_instr.code << hex
		}
		return
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

	if disp_need_rela {
		mrt, mok := modifier_to_reloc(disp_modifier(indir.disp))
		rtype := if mok {
			// `sym@gotpcrel(%rip)`, `sym@gottpoff(%rip)`, `sym@tlsgd(%rip)`, ...
			mrt
		} else if base_is_ip {
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
