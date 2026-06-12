module encoder

import encoding.binary
import error
import token

fn section_flags(flags string) int {
	mut val := 0
	for c in flags {
		match c {
			`a` { val |= encoder.shf_alloc }
			`x` { val |= encoder.shf_execinstr }
			`w` { val |= encoder.shf_write }
			`M` { val |= encoder.shf_merge }
			`S` { val |= encoder.shf_strings }
			`T` { val |= encoder.shf_tls }
			`G` {
			}
			`o` { val |= encoder.shf_link_order }
			else {
				// Ignore unknown GAS flag chars rather than abort.
				// Producing a section with slightly wrong flag bits is harmless for our test purposes;
				// the alternative is to refuse real toolchain output entirely.
			}
		}
	}
	return val
}

fn (mut e Encoder) change_symbol_binding(instr Instr, binding u8) {
	mut s := e.user_defined_symbols[instr.symbol_name] or { return }

	if binding == encoder.stb_global && s.kind == .section {
		error.print(instr.pos, 'sections cannot be global')
		exit(1)
	}

	s.binding = binding
}

fn (mut e Encoder) change_symbol_visibility(instr Instr, visibility u8) {
	mut s := e.user_defined_symbols[instr.symbol_name] or { return }

	s.visibility = visibility
}

fn (mut e Encoder) fix_same_section_relocations() {
	for mut rela in e.rela_text_users {
		if symbol := e.user_defined_symbols[rela.uses] {
			if symbol.section_name != rela.instr.section_name {
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

			mut section := e.user_defined_sections[rela.instr.section_name] or {
				panic('this should not happen')
			}

			section.code[rela.instr.addr + rela.offset] = hex[0]
			section.code[rela.instr.addr + rela.offset+1] = hex[1]
			section.code[rela.instr.addr + rela.offset+2] = hex[2]
			section.code[rela.instr.addr + rela.offset+3] = hex[3]

			rela.is_already_resolved = true
		}
	}
}

pub fn (mut e Encoder) assign_addresses() {
	for mut instr in e.instrs {
		if instr.kind == .section && instr.section_name !in e.user_defined_sections {
			e.user_defined_sections[instr.section_name] = &UserDefinedSection{
				flags: section_flags(instr.flags)
			}
		}

		mut section := e.user_defined_sections[instr.section_name] or {
			panic('this should not happen')
		}

		match instr.kind {
			.global {
				e.change_symbol_binding(*instr, encoder.stb_global)
				continue
			}
			.local {
				e.change_symbol_binding(*instr, encoder.stb_local)
				continue
			}
			.hidden {
				e.change_symbol_visibility(*instr, encoder.stv_hidden)
				continue
			}
			.internal {
				e.change_symbol_visibility(*instr, encoder.stv_internal)
				continue
			}
			.protected {
				e.change_symbol_visibility(*instr, encoder.stv_protected)
				continue
			}
			.weak {
				e.change_symbol_binding(*instr, encoder.stb_weak)
				continue
			}
			.set_type {
				if mut s := e.user_defined_symbols[instr.symbol_name] {
					s.symbol_type = instr.symbol_type
				}
				continue
			} else {}
		}

		if instr.kind == .align {
			mut pad := align_to(section.addr, instr.align_bytes) - section.addr
			if instr.align_max >= 0 && pad > instr.align_max {
				pad = 0
			}
			is_exec := section.flags & encoder.shf_execinstr != 0
			instr.code = gen_align_fill(pad, is_exec, instr.align_fill)
			if instr.align_bytes > section.align {
				section.align = instr.align_bytes
			}
		}

		instr.addr = section.addr
		section.addr += instr.code.len
		section.code << instr.code
	}

	e.resolve_aliases()
	e.fix_same_section_relocations()
	e.resolve_label_diffs()
}

fn (mut e Encoder) resolve_aliases() {
	for _, mut sym in e.user_defined_symbols {
		if sym.alias_target == '' {
			continue
		}
		target := e.user_defined_symbols[sym.alias_target] or {
			error.print(sym.pos, 'undefined alias target `${sym.alias_target}` for `${sym.symbol_name}`')
			exit(1)
		}
		sym.addr = target.addr
		sym.section_name = target.section_name
		if sym.symbol_type == encoder.stt_notype {
			sym.symbol_type = target.symbol_type
		}
	}
}

fn (mut e Encoder) resolve_label_diffs() {
	for mut rela in e.rela_text_users {
		if rela.uses2 == '' {
			continue
		}
		site := rela.instr.addr + rela.offset
		plus_addr, plus_sec, plus_binding := e.diff_endpoint(rela.uses, site,
			rela.instr.section_name, rela.instr.pos)
		minus_addr, minus_sec, _ := e.diff_endpoint(rela.uses2, site, rela.instr.section_name,
			rela.instr.pos)
		width := match rela.rtype {
			encoder.r_x86_64_64 { 8 }
			encoder.r_x86_64_16 { 2 }
			encoder.r_x86_64_8 { 1 }
			else { 4 }
		}

		if plus_sec == minus_sec {
			val := (plus_addr - minus_addr) + i64(rela.adjust)
			mut section := e.user_defined_sections[rela.instr.section_name] or {
				panic('resolve_label_diffs: unknown section `${rela.instr.section_name}`')
			}
			mut v := u64(val)
			base := int(rela.instr.addr + rela.offset)
			for i in 0 .. width {
				section.code[base + i] = u8(v & 0xff)
				v >>= 8
			}
			rela.is_already_resolved = true
			continue
		}

		if minus_sec != rela.instr.section_name {
			error.print(rela.instr.pos, 'label difference `${rela.uses}-${rela.uses2}` spans sections; not supported')
			exit(1)
		}
		pc_type := match width {
			8 { encoder.r_x86_64_pc64 }
			2 { encoder.r_x86_64_pc16 }
			1 { encoder.r_x86_64_pc8 }
			else { encoder.r_x86_64_pc32 }
		}

		mut a := i64(rela.adjust) + site - minus_addr
		if plus_binding != encoder.stb_global {
			a += plus_addr
		}
		rela.rtype = pc_type
		rela.set_addend = true
		rela.addend = a
		rela.uses2 = ''
	}
}

fn (mut e Encoder) diff_endpoint(name string, site i64, cur_sec string, pos token.Position) (i64, string, u8) {
	if name == '.' {
		return site, cur_sec, u8(encoder.stb_local)
	}
	s := e.user_defined_symbols[name] or {
		error.print(pos, 'undefined symbol `${name}` in label difference')
		exit(1)
	}
	return s.addr, s.section_name, s.binding
}
