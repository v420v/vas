
// I know this code is messy, but it gets the job done for now.
// Leaving this comment here to remind myself to refactor it from scratch
// when I have more time. 

module elf

import os
import assemble
import encoding.binary

pub struct Elf {
mut:
	out_file             string
	globals_count        int
	defined_symbols      []&assemble.Instr
	rela_symbols         []string
	sym_index            map[string]int

	// ----------------------------
	ehdr                 Elf64_Ehdr

	custom_sections      map[string]&CustomSection
	custom_section_names []string
	section_name_offs    map[string]int

	strtab               []u8
	symtab               []Elf64_Sym
	rela                 map[string][]Elf64_Rela
	shstrtab             []u8
	section_headers      []Elf64_Shdr
}

/*

Elf format
 - https://en.wikipedia.org/wiki/Executable_and_Linkable_Format
 - https://www.cs.cmu.edu/afs/cs/academic/class/15213-f00/docs/elf.pdf

*/

struct Elf64_Ehdr {
	e_ident     [16]u8
	e_type      u16
	e_machine   u16
	e_version   u32
	e_entry     voidptr
	e_phoff     voidptr
	e_shoff     voidptr
	e_flags     u32
	e_ehsize    u16
	e_phentsize u16
	e_phnum     u16
	e_shentsize u16
	e_shnum     u16
	e_shstrndx  u16
}

struct Elf64_Sym {
	st_name  u32
	st_info  u8
	st_other u8
	st_shndx u16
	st_value voidptr
	st_size  u64
}

struct Elf64_Shdr {
	sh_name      u32
	sh_type      u32
	sh_flags     voidptr
	sh_addr      voidptr
	sh_offset    voidptr
	sh_size      voidptr
	sh_link      u32
	sh_info      u32
	sh_addralign voidptr
	sh_entsize   voidptr
}

pub struct Elf64_Rela {
	r_offset u64
	r_info   u64
	r_addend i64
}

struct Elf64_Phdr {
	ph_type   u32
	ph_flags  u32
	ph_off    u64
	ph_vaddr  u64
	ph_paddr  u64
	ph_filesz u64
	ph_memsz  u64
	ph_align  u64
}

pub const (
	stb_local            = 0
	stb_global           = 1

	stt_notype 			 = 0
	stt_object 			 = 1
	stt_func 			 = 2
	stt_section 		 = 3
	stt_file 			 = 4
	stt_common 			 = 5
	stt_tls 			 = 6
	stt_relc 			 = 8
	stt_srelc 			 = 9
	stt_loos 			 = 10
	stt_hios 			 = 12
	stt_loproc 			 = 13
	stt_hiproc 			 = 14

	sht_null             = 0
	sht_progbits         = 1
	sht_symtab           = 2
	sht_strtab           = 3
	sht_rela             = 4

	shf_write            = 0x1
	shf_alloc            = 0x2
	shf_execinstr        = 0x4
	shf_merge            = 0x10
	shf_strings          = 0x20
	shf_info_link        = 0x40
	shf_link_order       = 0x80
	shf_os_nonconforming = 0x100
	shf_group            = 0x200
	shf_tls              = 0x400
)

pub fn new(out_file string) &Elf {
	return &Elf{
		out_file: out_file
	}
}

fn (mut e Elf) set_symbol_binding(name string, mut defined_symbols []&assemble.Instr, set_binding u8) {
	for mut symbol in defined_symbols {
		if symbol.symbol_name == name {
			if symbol.binding == stb_local && set_binding == stb_global {
				e.globals_count++
			}
			if symbol.binding == stb_global && set_binding == stb_local {
				e.globals_count--
			}
			symbol.binding = set_binding
			break
		}
	}
}

fn add_padding(mut code []u8) {
	mut padding := (assemble.align_to(code.len, 16) - code.len)
	for _ in 0 .. padding {
		code << 0
	}
}

struct CustomSection {
mut:
	code  []u8
	addr  int
	flags voidptr
}

fn section_flags(flags string) int {
	mut val := 0
	for c in flags {
		match c {
			`a` {
				val |= shf_alloc
			}
			`x` {
				val |= shf_execinstr
			}
			`w` {
				val |= shf_write
			} else {
				panic('unkown attribute $c')
			}
		}
	}
	return val
}

pub fn (mut e Elf) assign_addresses_and_set_bindings(mut instrs  []&assemble.Instr, mut defined_symbols []&assemble.Instr) {
	mut curr_section := ''

	for mut i in instrs {
		match i.kind {
			.section {
				curr_section = i.section
			}
			.global {
				e.set_symbol_binding(i.symbol_name, mut defined_symbols, stb_global)
				continue
			}
			.local {
				e.set_symbol_binding(i.symbol_name, mut defined_symbols, stb_local)
				continue
			}
			else {}
		}

		if curr_section == '' {
			curr_section = '.text'
		}

		if curr_section !in e.custom_sections {
			e.custom_sections[curr_section] = &CustomSection{
				flags: section_flags(i.flags)
			}
			e.custom_section_names << curr_section
		}

		i.section = curr_section

		mut s := e.custom_sections[curr_section] or {
			panic('PANIC')
		}

		i.addr = s.addr
		s.code << i.code
		s.addr += i.code.len
	}

	for _, mut s in e.custom_sections {
		add_padding(mut s.code)
	}

	e.defined_symbols << &assemble.Instr {kind: .label, binding: stb_local} // null
	e.sym_index['null'] = 0
	mut index_count := 1

	for name, _ in e.custom_sections {
		e.defined_symbols << &assemble.Instr {kind: .label, binding: stb_local, section: name, symbol_type: stt_section}
		e.sym_index[name] = index_count
		index_count++
	}

	e.defined_symbols << defined_symbols
}

pub fn (mut e Elf) resolve_call_targets(call_targets []assemble.CallTarget) {
	for call_target in call_targets {
		for mut symbol in e.defined_symbols {
			if symbol.symbol_name == call_target.target_symbol {
				caller_section := call_target.caller.section
				// canot call symbol from a different section. need to relocate.
				if caller_section != symbol.section {
					panic('TODO: this instruction needs to be in rela.text\ncanot call symbol from a different section. need to relocate.')
				}

				mut buf := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &buf, u32(symbol.addr - (call_target.caller.addr + 5)))
				e.custom_sections[caller_section].code[call_target.caller.addr+1] = buf[0]
				e.custom_sections[caller_section].code[call_target.caller.addr+2] = buf[1]
				e.custom_sections[caller_section].code[call_target.caller.addr+3] = buf[2]
				e.custom_sections[caller_section].code[call_target.caller.addr+4] = buf[3]
				break
			}
		}
	}
}

fn (mut e Elf) symbol_is_defined(name string) bool {
	for symbol in e.defined_symbols {
		if symbol.symbol_name == name {
			return true
		}
	}
	return false
}

fn (mut e Elf) get_defined_symbol(name string) assemble.Instr {
	for s in e.defined_symbols {
        if s.symbol_name == name {
            return *s
        }
    }
	panic('unreachable')
}

pub fn (mut e Elf) rela_text_users(rela_text_users []assemble.RelaTextUser) {
	mut pos := e.defined_symbols.len - e.globals_count

	for r in rela_text_users {
		mut index := 0
		mut r_addend := i64(0 - 4)
		if r.rtype == assemble.r_x86_64_32s {
			r_addend = 0
		}

    	if r.rtype == assemble.r_x86_64_plt32 && e.symbol_is_defined(r.uses) {
			// already resolved call instruction
			continue
		} else if e.symbol_is_defined(r.uses) {
			s := e.get_defined_symbol(r.uses)
    	    r_addend += s.addr
			index = e.sym_index[s.section]
		} else if r.uses in e.rela_symbols {
			index = e.sym_index[r.uses]
    	} else {
    	    e.rela_symbols << r.uses
			e.sym_index[r.uses] = pos
			index = pos
    	    pos++
    	}

		e.rela['.rela' + r.instr.section] << elf.Elf64_Rela{
    	    r_offset: u64(r.instr.addr + r.offset),
    	    r_info: (u64(index) << 32) + r.rtype,
    	    r_addend: r_addend + r.adjust,
    	}
	}
}

fn (mut e Elf) elf_symbol(symbol_binding int, mut off &int, mut str &string) {
	for symbol in e.defined_symbols {
		if symbol.binding != symbol_binding {
			continue
		}

		mut symbol_name := symbol.symbol_name
		mut st_name := u32(0)

		if !(symbol_name.to_upper().starts_with('.L') && symbol_binding == stb_local) {
			unsafe { *off += str.len + 1 }
			st_shndx := u16(e.sym_index[symbol.section])

			if symbol.symbol_type == stt_section {
				st_name = 0
			} else {
				st_name = u32(*off)
			}

			e.symtab << Elf64_Sym{
				st_name: st_name
				st_info: u8((symbol.binding << 4) + (symbol.symbol_type & 0xf))
				st_shndx: st_shndx
				st_value: symbol.addr
			}

			e.strtab << symbol_name.bytes()
			e.strtab << 0x00
			str = symbol_name
		}
	}
}

fn (mut e Elf) elf_rela_symbol(mut off &int, mut str &string) {
	for symbol_name in e.rela_symbols {
		unsafe {*off += str.len + 1}
		e.symtab << Elf64_Sym{
			st_name: u32(*off)
			st_info: u8((elf.stb_global << 4) + (elf.stt_notype & 0xf))
			st_shndx: 0
		}
		e.strtab << symbol_name.bytes()
		e.strtab << 0x00
		str = symbol_name
	}
}

pub fn (mut e Elf) elf_symtab_strtab() {
	e.strtab << [u8(0x00)]
	mut off := 0
	mut str := ''

	e.elf_symbol(elf.stb_local, mut &off, mut &str)  // local
	e.elf_rela_symbol(mut &off, mut &str)            // rela local
	e.elf_symbol(elf.stb_global, mut &off, mut &str) // global

	add_padding(mut e.strtab)
}

pub fn (mut e Elf) make_shstrtab() {
	// null
	e.shstrtab << [u8(0x00)]
	e.section_name_offs[''] = 0

	// custom sections
	mut name_offs := ''.len + 1
	for name in e.custom_section_names {
		e.section_name_offs[name] = name_offs
		name_offs += name.len + 1

		e.shstrtab << name.bytes()
		e.shstrtab << 0x00
	}

	for name in ['.strtab', '.symtab', '.shstrtab'] {
		e.section_name_offs[name] = name_offs
		name_offs += name.len + 1

		e.shstrtab << name.bytes()
		e.shstrtab << 0x00
	}

	for name, _ in e.rela {
		e.section_name_offs[name] = name_offs
		name_offs += name.len + 1

		e.shstrtab << name.bytes()
		e.shstrtab << 0x00
	}

	add_padding(mut e.shstrtab)
}

pub fn (mut e Elf) elf_rest() {
	// make sections

	/*
	-----------------
		Elf header
	-----------------
	 custom sections
	-----------------
	     strtab
	-----------------
	     symtab
	-----------------
	  rela sections
	-----------------
	    shstrtab
	-----------------
	*/

	mut idx := 0
	mut section_offs := sizeof(Elf64_Ehdr)
	mut section_idx := {'': idx}
	idx++

	// null section
	e.section_headers << Elf64_Shdr{
		sh_name: u32(e.section_name_offs[''])
		sh_type: elf.sht_null
	}

	// custom sections
	for name in e.custom_section_names {
		section := e.custom_sections[name] or { panic('[internal error] unkown section `$name`') }
		e.section_headers << Elf64_Shdr{
			sh_name: u32(e.section_name_offs[name])
			sh_type: elf.sht_progbits
			sh_flags: section.flags
			sh_addr: 0
			sh_offset: section_offs
			sh_size: section.code.len
			sh_link: 0
			sh_info: 0
			sh_addralign: 1
			sh_entsize: 0
		}
		section_offs += u32(section.code.len)
		section_idx[name] = idx
		idx++
	}

	strtab_ofs := section_offs
	strtab_size := u32(e.strtab.len)
	section_idx['.strtab'] = idx
	idx++

	symtab_ofs := strtab_ofs + strtab_size
	symtab_size := sizeof(Elf64_Sym) * u32(e.symtab.len)
	section_idx['.symtab'] = idx
	idx++

	e.section_headers << [
		// .strtab
		Elf64_Shdr{
			sh_name: u32(e.section_name_offs['.strtab'])
			sh_type: elf.sht_strtab
			sh_flags: 0
			sh_addr: 0
			sh_offset: strtab_ofs
			sh_size: strtab_size
			sh_link: 0
			sh_info: 0
			sh_addralign: 1
			sh_entsize: 0
		},
		// .symtab
		Elf64_Shdr{
			sh_name: u32(e.section_name_offs['.symtab'])
			sh_type: elf.sht_symtab
			sh_flags: 0
			sh_addr: 0
			sh_offset: symtab_ofs
			sh_size: symtab_size
			sh_link: u32(section_idx['.strtab']) // section number of .strtab
			sh_info: u32(e.defined_symbols.len - e.globals_count) // Number of local symbols
			sh_addralign: 8
			sh_entsize: sizeof(Elf64_Sym)
		}
	]

	section_offs = symtab_ofs + symtab_size

	// add rela ... to section headers
	for name, rela in e.rela {
		size := u32(rela.len) * sizeof(Elf64_Rela)
		e.section_headers << Elf64_Shdr{
			sh_name: u32(e.section_name_offs[name])
			sh_type: elf.sht_rela,
			sh_flags: elf.shf_info_link
			sh_addr: 0
			sh_offset: section_offs
			sh_size: size
			sh_link: u32(section_idx['.symtab'])
			sh_info: u32(section_idx[name[5..]]) // target section number. if `.rela.text` the target will be `.text`
			sh_addralign: 8
			sh_entsize: sizeof(Elf64_Rela)
		}
		section_offs += size
	}

	// .shstrtab
	e.section_headers << Elf64_Shdr{
		sh_name: u32(e.section_name_offs['.shstrtab'])
		sh_type: elf.sht_strtab
		sh_flags: 0
		sh_addr: 0
		sh_offset: section_offs
		sh_size: u32(e.shstrtab.len)
		sh_link: 0
		sh_info: 0
		sh_addralign: 1
		sh_entsize: 0
	}

	sectionheader_ofs := section_offs + u32(e.shstrtab.len)

	e.ehdr = Elf64_Ehdr{
		e_ident: [
			u8(0x7f), 0x45, 0x4c, 0x46, // Magic number ' ELF' in ascii format
			0x02, // 2 = 64-bit
			0x01, // 1 = little endian
			0x01,
			0x00,
			0x00,
			0x00,
			0x00,
			0x00,
			0x00,
			0x00,
			0x00,
			0x00,
		]!
		e_type: 1 // 1 = realocatable
		e_machine: 0x3e
		e_version: 1
		e_entry: 0
		e_phoff: 0
		e_shoff: sectionheader_ofs
		e_flags: 0x0
		e_ehsize: u16(sizeof(Elf64_Ehdr))
		e_phentsize: u16(sizeof(Elf64_Phdr))
		e_phnum: 0
		e_shentsize: u16(sizeof(Elf64_Shdr))
		e_shnum: u16(e.section_headers.len)
		e_shstrndx: u16(e.section_headers.len - 1)
	}
}

pub fn (mut e Elf) write_elf() {
	mut fp := os.open_file(e.out_file, 'w') or { panic('error opening file `${e.out_file}`') }
	os.truncate(e.out_file, 0) or {
		panic('error truncate file `${e.out_file}`')
	}

	fp.write_struct(e.ehdr) or {
		panic('somthing whent wrong while writing `elf header`')
	}

	for name in e.custom_section_names {
		section := e.custom_sections[name] or {
			panic('unkown section $name')
		}
		fp.write(section.code) or {
			panic('somthing whent wrong while writing `$name`')
		}
	}

	fp.write(e.strtab) or {
		panic('somthing whent wrong while writing `.strtab`')
	}

	for s in e.symtab {
		fp.write_struct(s) or {
			panic('somthing whent wrong while writing `.symtab`')
		}
	}

	for _, rela in e.rela {
		for r in rela {
			fp.write_struct(r) or {
				panic('somthing whent wrong while writing `.rela.text`')
			}
		}
	}

	fp.write(e.shstrtab) or {
		panic('somthing whent wrong while writing `.shstrtab`')
	}

	for sh in e.section_headers {
		fp.write_struct(sh) or {
			panic('somthing whent wrong while writing `section_headers`')
		}
	}
}

