module elf

import os
import parser
import encoding.binary

pub struct Elf {
	out_file string
pub mut:
	text_addr     i64
	data_addr     i64
	globals_count int
	code          []u8 // text section
	data          []u8 // data section
	symbols       []&parser.Instr
	rela_symbols  []string
	relatext      []Elf64_Rela
	symtab        []Elf64_Sym
	sym_index     map[string]int
	strtab        []u8
}

pub fn new(out_file string) &Elf {
	mut e := &Elf{
		out_file:      out_file
		code:          []u8{} // text section
		data:          []u8{} // data section
		text_addr:     0
		data_addr:     0
		symbols:       []&parser.Instr{}
		rela_symbols:  []string{}
		globals_count: 0
		relatext:      []Elf64_Rela{}
		symtab: [
			Elf64_Sym{
				st_name: u32(0) // null_nameofs
				st_info: ((elf.stb_local << 4) + (elf.stt_notype & 0xf))
			},
			// .text
			Elf64_Sym{
				st_name: u32(0) // null_nameofs
				st_info: ((elf.stb_local << 4) + (elf.stt_section & 0xf))
				st_shndx: 1
			},
			// .rodata
			Elf64_Sym{
				st_name: u32(0) // null_nameofs
				st_info: ((elf.stb_local << 4) + (elf.stt_section & 0xf))
				st_shndx: 2
			},
		]
		sym_index: {
			"null":    0
			".text":   1
			".rodata": 2
		}
		strtab:        []u8{}
	}
	return e
}

//
// ELF Struct
//

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
	stb_local          = 0
	stb_global         = 1

	stt_notype         = 0
	stt_section        = 3

	sht_null           = 0
	sht_progbits       = 1
	sht_symtab         = 2
	sht_strtab         = 3
	sht_rela           = 4

	shf_alloc          = 0x2
	shf_execinstr      = 0x4
	shf_info_link      = 0x40
)

fn (mut e Elf) assign_symbol_binding(symbol_name string, binding u8) {
	for mut symbol in e.symbols {
		if symbol.symbol_name == symbol_name {
			symbol.binding = binding
			break
		}
	}
}

pub fn (mut e Elf) assign_instruction_addresses(mut instrs  []&parser.Instr) {
    mut section := '.text'
    for mut instr in instrs {
        if instr.kind == .data {
			section = '.rodata'
		} else if instr.kind == .text {
			section = '.text'
		}
		instr.section = section

		match instr.kind {
            .global  {
                e.globals_count++
                e.assign_symbol_binding(instr.symbol_name, elf.stb_global)
            }
            .local  {
                e.assign_symbol_binding(instr.symbol_name, elf.stb_local)
            }
            else {
				if section == '.text' {
					instr.addr = e.text_addr
					e.text_addr += instr.code.len
					e.code << instr.code
				} else if section == '.rodata' {
					instr.addr = e.data_addr
					e.data_addr += instr.code.len
					e.data << instr.code
				} else {
					panic('[internal error] somthing whent wrong...')
				}
            }
        }
    }
}

pub fn (mut e Elf) resolve_call_targets(call_targets []parser.CallTarget) {
	for call_target in call_targets {
		for mut symbol in e.symbols {
			if symbol.symbol_name == call_target.target_symbol {
				mut buf := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &buf, u32(symbol.addr - (call_target.caller.addr + 5)))
				e.code[call_target.caller.addr+1] = buf[0]
				e.code[call_target.caller.addr+2] = buf[1]
				e.code[call_target.caller.addr+3] = buf[2]
				e.code[call_target.caller.addr+4] = buf[3]
			}
		}
	}
}

fn (mut e Elf) symbol_is_defined(name string) bool {
	for symbol in e.symbols {
		if symbol.symbol_name == name {
			return true
		}
	}
	return false
}

fn (mut e Elf) get_defined_symbol(name string) parser.Instr {
	for s in e.symbols {
        if s.symbol_name == name {
            return *s
        }
    }
	panic('internal error')
}

pub fn (mut e Elf) handle_undefined_symbols(rela_text_users []parser.RelaTextUser) {
	local_symbols_count := e.symbols.len - e.globals_count + 3
	//                                                       ^ null, text, rodata
	mut pos := local_symbols_count

	for r in rela_text_users {
		mut r_addend := i64(0 - 4)
		mut index := 0

    	if r.rtype == parser.r_x86_64_plt32 && e.symbol_is_defined(r.uses) {
			continue
		} else if e.symbol_is_defined(r.uses) {
			s := e.get_defined_symbol(r.uses)
    	    r_addend += s.addr
			index = e.sym_index[s.section]
		} else {
			if r.uses in e.rela_symbols {
				index = e.sym_index[r.uses]
    	    } else {
    	        e.rela_symbols << r.uses
				e.sym_index[r.uses] = pos
				index = pos
    	        pos++
    	    }
    	}

		e.relatext << elf.Elf64_Rela{
    	    r_offset: u64(r.instr.addr + r.offset),
    	    r_info: (u64(index) << 32) + r.rtype,
    	    r_addend: r_addend + r.adjust,
    	}
	}
}

fn (mut e Elf) elf_symbol(symbol_binding int, mut off &int, mut str &string) {
	for symbol in e.symbols {
		if symbol.binding != symbol_binding {
			continue
		}

		mut symbol_name := symbol.symbol_name
		if !(symbol_name.to_upper().starts_with('.L') && symbol_binding == stb_local) {
			unsafe { *off += str.len + 1 }

			st_shndx := u16(e.sym_index[symbol.section])

			e.symtab << Elf64_Sym{
				st_name: u32(*off)
				st_info: u8((symbol.binding << 4) + (elf.stt_notype & 0xf))
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
	for symbol in e.rela_symbols {
		unsafe {
			*off += str.len + 1
		}
		e.symtab << Elf64_Sym{
			st_name: u32(*off)
			st_info: u8((elf.stb_global << 4) + (elf.stt_notype & 0xf))
			st_shndx: 0
		}
		e.strtab << symbol.bytes()
		e.strtab << 0x00
		str = symbol
	}
}

pub fn (mut e Elf) elf_symtab_strtab() {
	e.strtab << [u8(0x00)]
	mut off := 0
	mut str := ''

	e.elf_symbol(elf.stb_local, mut &off, mut &str) // local
	e.elf_rela_symbol(mut &off, mut &str) // rela local
	e.elf_symbol(elf.stb_global, mut &off, mut &str) // global

	padding := (parser.align_to(e.strtab.len, 32) - e.strtab.len)
	for _ in 0 .. padding {
		e.strtab << 0
	}
}

pub fn (mut e Elf) add_padding_to_data_and_code() {
	mut padding := (parser.align_to(e.data.len, 16) - e.data.len)
	for _ in 0 .. padding {
		e.data << 0
	}

	padding = (parser.align_to(e.code.len, 32) - e.code.len)
	for _ in 0 .. padding {
		e.code << 0
	}
}

pub fn (mut e Elf) gen_elf() {
	mut shstrtab := [
		u8(0x00),
		// .text\0
		0x2e, 0x74, 0x65, 0x78, 0x74, 0x00,
		// .rodata\0
		0x2e, 0x72, 0x6f, 0x64, 0x61, 0x74, 0x61, 0x00,
		// .rela.text\0
		0x2e, 0x72, 0x65, 0x6c, 0x61, 0x2e, 0x74, 0x65, 0x78, 0x74, 0x00,
		// .strtab\0
		0x2e, 0x73, 0x74, 0x72, 0x74, 0x61, 0x62, 0x00,
		// .symtab\0
		0x2e, 0x73, 0x79, 0x6d, 0x74, 0x61, 0x62, 0x00,
		// .shstrtab\0
		0x2e, 0x73, 0x68, 0x73, 0x74, 0x72, 0x74, 0x61, 0x62, 0x00,
	]

	padding := (parser.align_to(shstrtab.len, 32) - shstrtab.len)
	for _ in 0 .. padding {
		shstrtab << 0
	}

	null_nameofs := 0
	text_nameofs := null_nameofs + ''.len + 1
	rodata_nameofs := text_nameofs + '.text'.len + 1
	relatext_nameofs := rodata_nameofs + '.rodata'.len + 1
	strtab_nameofs :=   relatext_nameofs + '.rela.text'.len + 1
	symtab_nameofs := strtab_nameofs + '.strtab'.len + 1
	shstrtab_nameofs := symtab_nameofs + '.symtab'.len + 1

	code_ofs := sizeof(Elf64_Ehdr)
	code_size := u32(e.code.len)

	rodata_ofs := code_ofs + code_size
	rodata_size := u32(e.data.len)

	strtab_ofs := rodata_ofs + rodata_size
	strtab_size := u32(e.strtab.len)

	symtab_ofs := strtab_ofs + strtab_size
	symtab_size := sizeof(Elf64_Sym) * u32(e.symtab.len)

	relatext_ofs := symtab_ofs + symtab_size
  	relatext_size := sizeof(Elf64_Rela) * u32(e.relatext.len)

	shstrtab_ofs := relatext_ofs + relatext_size
	shstrtab_size := u32(shstrtab.len)

	sectionheader_ofs := shstrtab_ofs + shstrtab_size

	section_headers := [
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
			sh_offset: code_ofs
			sh_size: code_size
			sh_link: 0
			sh_info: 0
			sh_addralign: 1
			sh_entsize: 0
		},
		// .rodata
		Elf64_Shdr{
			sh_name: u32(rodata_nameofs)
			sh_type: elf.sht_progbits
			sh_flags: elf.shf_alloc
			sh_addr: 0
			sh_offset: rodata_ofs
			sh_size: rodata_size
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
			sh_info: u32(e.symbols.len - e.globals_count + 3) // Number of local symbols
			//                                             ^ null + rodata + text
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
	]!

	ehdr := Elf64_Ehdr{
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
		e_shnum: u16(section_headers.len)
		e_shstrndx: u16(section_headers.len - 1)
	}

	mut fp := os.open_file(e.out_file, 'w') or { panic('error opening file `${e.out_file}`') }

	os.truncate(e.out_file, 0) or { panic('error truncate file `${e.out_file}`') }

	fp.write_struct(ehdr) or { panic('error writing `Elf64_Ehdr`') }

	fp.write(e.code) or { panic('error writing `code`') }

	fp.write(e.data) or { panic('error writing `.rodata`') }

	fp.write(e.strtab) or { panic('error writing `.strtab`') }

	for s in e.symtab {
		fp.write_struct(s) or { panic('error writing `.symtab`') }
	}

	for r in e.relatext {
		fp.write_struct(r) or { panic('error writing `.rela.text`') }
	}

	fp.write(shstrtab) or { panic('error writing `.shstrtab`') }

	for sh in section_headers {
		fp.write_struct(sh) or { panic('error writing `Elf64_Shdr`') }
	}
}


