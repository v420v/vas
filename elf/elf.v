module elf

import os
import assemble
import encoding.binary

pub struct Elf {
mut:
	out_file        string
	globals_count   int
	defined_symbols []&assemble.Instr
	rela_symbols    []string
	sym_index       map[string]int

	// ----------------------------
	ehdr            Elf64_Ehdr
	text            []u8
	data            []u8
	strtab          []u8
	symtab          []Elf64_Sym
	relatext        []Elf64_Rela
	shstrtab        []u8
	section_headers []Elf64_Shdr
}

/*

Elf format
 - https://en.wikipedia.org/wiki/Executable_and_Linkable_Format
 - https://www.cs.cmu.edu/afs/cs/academic/class/15213-f00/docs/elf.pdf

---------------------
     Elf header
---------------------
       .text
---------------------
       .data
---------------------
       strtab
---------------------
       symtab
---------------------
      rela.text
---------------------
	   shstrtab
---------------------
       section
	   headers
---------------------

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

pub fn (mut e Elf) assign_addresses_and_set_bindings(mut instrs  []&assemble.Instr, mut defined_symbols []&assemble.Instr) {
	mut curr_section := '.text'
	mut text_addr, mut data_addr := 0, 0

	for mut i in instrs {
		if i.kind == .section {
			curr_section = i.section
		}

		if i.kind == .global {
			e.set_symbol_binding(i.symbol_name, mut defined_symbols, stb_global)
		}

		if i.kind == .local {
			e.set_symbol_binding(i.symbol_name, mut defined_symbols, stb_local)
		}

		i.section = curr_section

		match curr_section {
			'.text' {
				i.addr = text_addr
				e.text << i.code
				text_addr += i.code.len
			}
			'.data' {
				i.addr = data_addr
				e.data << i.code
				data_addr += i.code.len
			} else {
				panic('unreachable')
			}
		}
	}

	add_padding(mut e.data)
	add_padding(mut e.text)

	e.defined_symbols << [
		&assemble.Instr {kind: .label, binding: stb_local}, // null
		&assemble.Instr {kind: .label, binding: stb_local, section: '.text', symbol_type: stt_section}, // .text
		&assemble.Instr {kind: .label, binding: stb_local, section: '.data', symbol_type: stt_section}, // .data
	]
	e.sym_index['null'] = 0
	e.sym_index['.text'] = 1
	e.sym_index['.data'] = 2

	e.defined_symbols << defined_symbols
}

pub fn (mut e Elf) resolve_call_targets(call_targets []assemble.CallTarget) {
	for call_target in call_targets {
		for mut symbol in e.defined_symbols {
			if symbol.symbol_name == call_target.target_symbol {

				// canot call symbol from a different section. need to relocate.
				if call_target.caller.section != symbol.section {
					panic('TODO: this instruction needs to be in rela.text\ncanot call symbol from a different section. need to relocate.')
				}

				mut buf := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &buf, u32(symbol.addr - (call_target.caller.addr + 5)))
				e.text[call_target.caller.addr+1] = buf[0]
				e.text[call_target.caller.addr+2] = buf[1]
				e.text[call_target.caller.addr+3] = buf[2]
				e.text[call_target.caller.addr+4] = buf[3]
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

		e.relatext << elf.Elf64_Rela{
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

pub fn (mut e Elf) elf_rest() {
	e.shstrtab << [
		u8(0x00),
		// .text\0
		0x2e, 0x74, 0x65, 0x78, 0x74, 0x00,
		// .data\0
		0x2e, 0x64, 0x61, 0x74, 0x61, 0x00,
		// .rela.text\0
		0x2e, 0x72, 0x65, 0x6c, 0x61, 0x2e, 0x74, 0x65, 0x78, 0x74, 0x00,
		// .strtab\0
		0x2e, 0x73, 0x74, 0x72, 0x74, 0x61, 0x62, 0x00,
		// .symtab\0
		0x2e, 0x73, 0x79, 0x6d, 0x74, 0x61, 0x62, 0x00,
		// .shstrtab\0
		0x2e, 0x73, 0x68, 0x73, 0x74, 0x72, 0x74, 0x61, 0x62, 0x00,
	]

	add_padding(mut e.shstrtab)

	null_nameofs := 0
	text_nameofs := null_nameofs + ''.len + 1
	data_nameofs := text_nameofs + '.text'.len + 1
	relatext_nameofs := data_nameofs + '.data'.len + 1
	strtab_nameofs :=   relatext_nameofs + '.rela.text'.len + 1
	symtab_nameofs := strtab_nameofs + '.strtab'.len + 1
	shstrtab_nameofs := symtab_nameofs + '.symtab'.len + 1

	text_ofs := sizeof(Elf64_Ehdr)
	text_size := u32(e.text.len)
	data_ofs := text_ofs + text_size
	data_size := u32(e.data.len)
	strtab_ofs := data_ofs + data_size
	strtab_size := u32(e.strtab.len)
	symtab_ofs := strtab_ofs + strtab_size
	symtab_size := sizeof(Elf64_Sym) * u32(e.symtab.len)
	relatext_ofs := symtab_ofs + symtab_size
  	relatext_size := sizeof(Elf64_Rela) * u32(e.relatext.len)
	shstrtab_ofs := relatext_ofs + relatext_size
	shstrtab_size := u32(e.shstrtab.len)
	sectionheader_ofs := shstrtab_ofs + shstrtab_size

	e.section_headers << [
		// NULL
		Elf64_Shdr{
			sh_name: u32(null_nameofs)
			sh_type: elf.sht_null
		},
		// .text
		Elf64_Shdr{
			sh_name: u32(text_nameofs)
			sh_type: elf.sht_progbits
			sh_flags: elf.shf_alloc | elf.shf_execinstr
			sh_addr: 0
			sh_offset: text_ofs
			sh_size: text_size
			sh_link: 0
			sh_info: 0
			sh_addralign: 1
			sh_entsize: 0
		},
		// .data
		Elf64_Shdr{
			sh_name: u32(data_nameofs)
			sh_type: elf.sht_progbits
			sh_flags: elf.shf_alloc | shf_write
			sh_addr: 0
			sh_offset: data_ofs
			sh_size: data_size
			sh_link: 0
			sh_info: 0
			sh_addralign: 1
			sh_entsize: 0
		},
		// .strtab
		Elf64_Shdr{
			sh_name: u32(strtab_nameofs)
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
			sh_name: u32(symtab_nameofs)
			sh_type: elf.sht_symtab
			sh_flags: 0
			sh_addr: 0
			sh_offset: symtab_ofs
			sh_size: symtab_size
			sh_link: 3 // section number of .strtab
			sh_info: u32(e.defined_symbols.len - e.globals_count) // Number of local symbols
			sh_addralign: 8
			sh_entsize: sizeof(Elf64_Sym)
		},
		// .rela.text
		Elf64_Shdr{
			sh_name: u32(relatext_nameofs)
			sh_type: elf.sht_rela,
			sh_flags: elf.shf_info_link
			sh_addr: 0
			sh_offset: relatext_ofs
			sh_size: relatext_size
			sh_link: 4
			sh_info: 1
			sh_addralign: 8
			sh_entsize: sizeof(Elf64_Rela)
		}
		// .shstrtab
		Elf64_Shdr{
			sh_name: u32(shstrtab_nameofs)
			sh_type: elf.sht_strtab
			sh_flags: 0
			sh_addr: 0
			sh_offset: shstrtab_ofs
			sh_size: shstrtab_size
			sh_link: 0
			sh_info: 0
			sh_addralign: 1
			sh_entsize: 0
		},
	]

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
	os.truncate(e.out_file, 0) or { panic('error truncate file `${e.out_file}`') }

	fp.write_struct(e.ehdr) or { panic('error writing `elf header`') }
	fp.write(e.text) or { panic('error writing `.text`') }
	fp.write(e.data) or { panic('error writing `.data`') }
	fp.write(e.strtab) or { panic('error writing `.strtab`') }
	for s in e.symtab {
		fp.write_struct(s) or { panic('error writing `.symtab`') }
	}
	for r in e.relatext {
		fp.write_struct(r) or { panic('error writing `.rela.text`') }
	}
	fp.write(e.shstrtab) or { panic('error writing `.shstrtab`') }
	for sh in e.section_headers {
		fp.write_struct(sh) or { panic('error writing `section_headers`') }
	}
}

