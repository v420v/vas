module encoder 

import encoding.binary
import error
import elf

fn section_flags(flags string) int {
	mut val := 0
	for c in flags {
		match c {
			`a` {
				val |= elf.shf_alloc
			}
			`x` {
				val |= elf.shf_execinstr
			}
			`w` {
				val |= elf.shf_write
			} else {
				panic('unkown attribute $c')
			}
		}
	}
	return val
}

fn change_symbol_binding(instr Instr, binding u8) {
	mut s := user_defined_symbols[instr.symbol_name] or {
		error.print(instr.pos, 'undefined symbol `$instr.symbol_name`')
		exit(1)
	}

	if binding == elf.stb_global && s.kind == .section {
		error.print(instr.pos, 'sections cannot be global')
		exit(1)
	}

	s.binding = binding
}

fn change_symbol_visibility(instr Instr, visibility u8) {
	mut s := user_defined_symbols[instr.symbol_name] or {
		error.print(instr.pos, 'undefined symbol `$instr.symbol_name`')
		exit(1)
	}

	s.visibility = visibility
}

fn fix_same_section_relocations() {
	for mut rela in rela_text_users {
		if symbol := user_defined_symbols[rela.uses] {
			if symbol.section != rela.instr.section {
				continue
			}
			if symbol.binding == elf.stb_global {
				continue
			}

			if !rela.instr.is_jmp_or_call && rela.rtype != elf.r_x86_64_pc32 {
				continue
			}

			num := ((symbol.addr - rela.instr.addr) - rela.instr.code.len) + rela.adjust

			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			user_defined_sections[rela.instr.section].code[rela.instr.addr + rela.offset] = hex[0]
			user_defined_sections[rela.instr.section].code[rela.instr.addr + rela.offset+1] = hex[1]
			user_defined_sections[rela.instr.section].code[rela.instr.addr + rela.offset+2] = hex[2]
			user_defined_sections[rela.instr.section].code[rela.instr.addr + rela.offset+3] = hex[3]

			rela.is_already_resolved = true
		}
	}
}

pub fn (mut e Encoder) assign_addresses() {
	for mut instr in e.instrs {
		if instr.section !in user_defined_sections {
			user_defined_sections[instr.section] = &UserDefinedSection{}
		}
		mut section := user_defined_sections[instr.section] or {
			panic('this should not happen')
		}
		match instr.kind {
			.section {
				section.flags = section_flags(instr.flags)
			}
			.global {
				change_symbol_binding(*instr, elf.stb_global)
			}
			.local {
				change_symbol_binding(*instr, elf.stb_local)
			}
			.hidden {
				change_symbol_visibility(*instr, elf.stv_hidden)
			}
			.internal {
				change_symbol_visibility(*instr, elf.stv_internal)
			}
			.protected {
				change_symbol_visibility(*instr, elf.stv_protected)
			} else {}
		}

		instr.addr = section.addr
		section.addr += instr.code.len
		section.code << instr.code
	}

	fix_same_section_relocations()
}

