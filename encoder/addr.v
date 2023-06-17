module encoder 

import encoding.binary
import error

/*
	Functions for symbols and addresses
*/
fn section_flags(flags string) int {
	mut val := 0
	for c in flags {
		match c {
			`a` {
				val |= elf_shf_alloc
			}
			`x` {
				val |= elf_shf_execinstr
			}
			`w` {
				val |= elf_shf_write
			} else {
				panic('unkown attribute $c')
			}
		}
	}
	return val
}

fn (mut e Encoder) change_symbol_binding(instr Instr, binding u8) {
	mut s := user_defined_symbols[instr.symbol_name] or {
		error.print(instr.pos, 'undefined symbol `$instr.symbol_name`')
		exit(1)
	}

	if binding == stb_global && s.kind == .section {
		error.print(instr.pos, 'sections cannot be global')
		exit(1)
	}

	s.binding = binding
}

pub fn (mut e Encoder) assign_addresses() {
	for name, mut instrs in e.instrs {
		if name !in user_defined_sections {
			user_defined_sections[name] = &UserDefinedSection{}
		}
		mut section := user_defined_sections[name] or {
			panic('this should not happen')
		}

		for mut i in instrs {
			match i.kind {
				.section {
					section.flags = section_flags(i.flags)
				}
				.global {
					e.change_symbol_binding(*i, stb_global)
				}
				.local {
					e.change_symbol_binding(*i, stb_local)
				} else {}
			}

			i.addr = section.addr
			section.addr += i.code.len
			section.code << i.code
		}
	}
}

pub fn (mut e Encoder) fix_same_section_relocations() {
	/*
	.section .text, "ax"
	foo:
		retq

		callq foo # relocation is not needed
	*/

	/*
	.section .text, "ax"
	msg:
		.string "Hello, world!\n"

		leaq msg(%rip), %rsi # relocation is not needed
	*/

	for mut rela in rela_text_users {
		if symbol := user_defined_symbols[rela.uses] {
			if symbol.section != rela.instr.section {
				continue
			}
			if symbol.binding == encoder.stb_global {
				continue
			}
			if rela.instr.kind !in [.call, .jmp, .jne, .je, .jl, .jg, .jle, .jge, .jbe, .jnb, .jnbe, .jp, .ja, .js, .jb, .jns] && rela.rtype != encoder.r_x86_64_pc32 {
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

