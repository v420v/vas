module encoder 

import encoding.binary
import error

fn section_flags(flags string) int {
	mut val := 0
	for c in flags {
		match c {
			`a` {
				val |= encoder.shf_alloc
			}
			`x` {
				val |= encoder.shf_execinstr
			}
			`w` {
				val |= encoder.shf_write
			} else {
				panic('unkown attribute $c')
			}
		}
	}
	return val
}

fn (mut e Encoder) change_symbol_binding(instr Instr, binding u8) {
	mut s := e.user_defined_symbols[instr.symbol_name] or {
		error.print(instr.pos, 'undefined symbol `$instr.symbol_name`')
		exit(1)
	}

	if binding == encoder.stb_global && s.kind == .section {
		error.print(instr.pos, 'sections cannot be global')
		exit(1)
	}

	s.binding = binding
}

fn (mut e Encoder) change_symbol_visibility(instr Instr, visibility u8) {
	mut s := e.user_defined_symbols[instr.symbol_name] or {
		error.print(instr.pos, 'undefined symbol `$instr.symbol_name`')
		exit(1)
	}

	s.visibility = visibility
}

fn (mut e Encoder) fix_same_section_relocations() {
	for mut rela in e.rela_text_users {
		if symbol := e.user_defined_symbols[rela.uses] {
			if symbol.section != rela.instr.section {
				continue
			}
			if symbol.binding == encoder.stb_global {
				continue
			}

			if !rela.instr.is_jmp_or_call && rela.rtype != encoder.r_x86_64_pc32 {
				continue
			}

			num := ((symbol.addr - rela.instr.addr) - rela.instr.code.len) + rela.adjust

			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			e.user_defined_sections[rela.instr.section].code[rela.instr.addr + rela.offset] = hex[0]
			e.user_defined_sections[rela.instr.section].code[rela.instr.addr + rela.offset+1] = hex[1]
			e.user_defined_sections[rela.instr.section].code[rela.instr.addr + rela.offset+2] = hex[2]
			e.user_defined_sections[rela.instr.section].code[rela.instr.addr + rela.offset+3] = hex[3]

			rela.is_already_resolved = true
		}
	}
}

pub fn (mut e Encoder) assign_addresses() {
	for mut instr in e.instrs {
		if instr.section !in e.user_defined_sections {
			e.user_defined_sections[instr.section] = &UserDefinedSection{}
		}
		mut section := e.user_defined_sections[instr.section] or {
			panic('this should not happen')
		}
		match instr.kind {
			.section {
				section.flags = section_flags(instr.flags)
			}
			.global {
				e.change_symbol_binding(*instr, encoder.stb_global)
			}
			.local {
				e.change_symbol_binding(*instr, encoder.stb_local)
			}
			.hidden {
				e.change_symbol_visibility(*instr, encoder.stv_hidden)
			}
			.internal {
				e.change_symbol_visibility(*instr, encoder.stv_internal)
			}
			.protected {
				e.change_symbol_visibility(*instr, encoder.stv_protected)
			} else {}
		}

		instr.addr = section.addr
		section.addr += instr.code.len
		section.code << instr.code
	}

	e.fix_same_section_relocations()
}

