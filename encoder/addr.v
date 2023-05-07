module encoder 

import encoding.binary
import error

pub fn (mut e Encoder) add_index_to_instrs() {
	for name, _ in e.instrs {
		for i := 0; i < e.instrs[name].len; i++ {
			e.instrs[name][i].index = i
		}
	}
}

// function for variable length instructions
fn calc_distance(user_instr &Instr, symdef &Instr, instrs []&Instr) (int, int, int, bool) {
	unsafe {
    	mut from, mut to := symdef, instrs[user_instr.index+1]
    	forward := user_instr.index <= symdef.index

    	if forward {
    	    from, to = instrs[user_instr.index+1], symdef
    	}

    	mut has_variable_length := false
    	mut diff, mut min, mut max := 0, 0, 0

    	for instr := from; instr != to; instr = instrs[instr.index+1] {
    	    if !instr.is_len_decided {
    	        has_variable_length = true
    	        len_short, len_large := instr.varcode.rel8_code.len, instr.varcode.rel32_code.len
    	        min += len_short
    	        max += len_large
    	        diff += len_large
    	    } else {
    	        length := instr.code.len
    	        diff += length
    	        min += length
    	        max += length
    	    }
    	}

    	if !forward {
    	    diff, min, max = -diff, -min, -max
    	}
	
    	return diff, min, max, !has_variable_length
	}
}

// TODO: catch infinite loop
pub fn (mut e Encoder) resolve_variable_length_instrs(mut instrs []&Instr) {
	mut todos := []&Instr{}
	for index := 0; index < instrs.len; index++ {
		name := instrs[index].varcode.trgt_symbol

		// check if the symbol is defined
		s := e.defined_symbols[name] or {
			rela_text_user := encoder.RelaTextUser{
				instr:  instrs[index],
				offset: instrs[index].varcode.rel32_offset,
				uses:   name,
				rtype:  encoder.r_x86_64_plt32
			}
			e.rela_text_users << rela_text_user
			instrs[index].code = instrs[index].varcode.rel32_code
			instrs[index].is_len_decided = true
			continue
		}

		// Check if the symbol and instruction are declared in the same section
		if instrs[index].section != s.section {
			rela_text_user := encoder.RelaTextUser{
				instr:  instrs[index],
				offset: instrs[index].varcode.rel32_offset,
				uses:   name,
				rtype:  encoder.r_x86_64_plt32
			}
			e.rela_text_users << rela_text_user
			instrs[index].code = instrs[index].varcode.rel32_code
			instrs[index].is_len_decided = true
			continue
		}

		diff, min, max, is_len_decided := calc_distance(instrs[index], s, e.instrs[instrs[index].section])
		if is_len_decided {
			if encoder.is_in_i8_range(diff) {
				instrs[index].code = instrs[index].varcode.rel8_code
				instrs[index].code[instrs[index].varcode.rel8_offset] = u8(diff)
			} else {
				diff_int32 := i32(diff)
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(diff_int32))

				mut code, offset := instrs[index].varcode.rel32_code.clone(), instrs[index].varcode.rel32_offset
				code[offset] = hex[0]
				code[offset+1] = hex[1]
				code[offset+2] = hex[2]
				code[offset+3] = hex[3]
				instrs[index].code = code
			}
			instrs[index].is_len_decided = true
		} else {
			if encoder.is_in_i8_range(max) {
				instrs[index].is_len_decided = true
				instrs[index].varcode.rel32_code = []u8{}
				instrs[index].code = instrs[index].varcode.rel8_code
			} else if !encoder.is_in_i8_range(min) {
				instrs[index].is_len_decided = true
				instrs[index].varcode.rel8_code = []u8{}
				instrs[index].code = instrs[index].varcode.rel32_code
			}
			todos << instrs[index]
		}
	}
	e.variable_instrs = todos

	if e.variable_instrs.len > 0 {
		e.resolve_variable_length_instrs(mut e.variable_instrs)
	}
}

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
	mut s := e.defined_symbols[instr.symbol_name] or {
		error.print(instr.pos, 'undefined symbol `$instr.symbol_name`')
		exit(1)
	}
	if binding == stb_global && s.binding == stb_local {
		e.globals_count++
	}

	if binding == stb_local && s.binding == stb_global {
		e.globals_count--
	}

	if binding == stb_global && s.kind == .section {
		error.print(instr.pos, 'sections cannot be global')
		exit(1)
	}

	s.binding = binding
}

pub fn (mut e Encoder) assign_addresses() {
	for name, mut instrs in e.instrs {
		if name !in e.sections {
			e.sections[name] = &UserDefinedSection{}
		}
		mut section := e.sections[name] or {
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
	for mut rela in e.rela_text_users {
		if symbol := e.defined_symbols[rela.uses] {
			if symbol.section != rela.instr.section {
				continue
			}
			if symbol.binding == encoder.stb_global {
				continue
			}
			if rela.instr.kind != .call && rela.rtype != encoder.r_x86_64_pc32 {
				continue
			}

			num := ((symbol.addr - rela.instr.addr) - rela.instr.code.len) + rela.adjust

			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			e.sections[rela.instr.section].code[rela.instr.addr + rela.offset] = hex[0]
			e.sections[rela.instr.section].code[rela.instr.addr + rela.offset+1] = hex[1]
			e.sections[rela.instr.section].code[rela.instr.addr + rela.offset+2] = hex[2]
			e.sections[rela.instr.section].code[rela.instr.addr + rela.offset+3] = hex[3]

			rela.instr.is_already_resolved = true
		}
	}
}

pub fn (mut e Encoder) count_local_labels() {
	for name, sym in e.defined_symbols {
		if name.to_upper().starts_with('.L') && sym.binding == encoder.stb_local {
			e.local_labels_count++
		}
	}
}

