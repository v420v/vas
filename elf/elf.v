module elf

import encoder
import os

pub struct Elf {
	out_file             		string
	rela_text_users				[]encoder.Rela
	user_defined_symbols		map[string]&encoder.Instr
	user_defined_sections		map[string]&encoder.UserDefinedSection
mut:
	keep_locals					bool			// flag to keep local labels. labels that start from `.L`
	ehdr                      	Elf64_Ehdr    	// Elf header
	symtab_symbol_indexs		map[string]int  // symtab symbol index
	local_symbols_count			int				// used in .symtab section header
	rela_symbols              	[]string      	// symbols that are not defined
	user_defined_section_names	[]string      	// list of user-defined section names
	user_defined_section_idx  	map[string]int	// user-defined sections index
	section_name_offs			map[string]int
	strtab            			[]u8
	symtab            			[]Elf64_Sym
	rela_section_names			[]string
	rela						map[string][]Elf64_Rela
	shstrtab					[]u8
	section_headers				[]Elf64_Shdr
}

pub struct Elf64_Ehdr {
	e_ident     [16]u8
	e_type      u16
	e_machine   u16
	e_version   u32
	e_entry     u64
	e_phoff     u64
	e_shoff     u64
	e_flags     u32
	e_ehsize    u16
	e_phentsize u16
	e_phnum     u16
	e_shentsize u16
	e_shnum     u16
	e_shstrndx  u16
}

pub struct Elf64_Sym {
	st_name  u32
	st_info  u8
	st_other u8
	st_shndx u16
	st_value u64
	st_size  u64
}

pub struct Elf64_Shdr {
	sh_name      u32
	sh_type      u32
	sh_flags     u64
	sh_addr      u64
	sh_offset    u64
	sh_size      u64
	sh_link      u32
	sh_info      u32
	sh_addralign u64
	sh_entsize   u64
}

pub struct Elf64_Rela {
	r_offset u64
	r_info   u64
	r_addend i64
}

pub struct Elf64_Phdr {
	ph_type   u32
	ph_flags  u32
	ph_off    u64
	ph_vaddr  u64
	ph_paddr  u64
	ph_filesz u64
	ph_memsz  u64
	ph_align  u64
}

const stb_local            = 0
const stb_global           = 1
const stt_notype           = 0
const stt_object           = 1
const stt_func             = 2
const stt_section          = 3
const stt_file             = 4
const stt_common           = 5
const stt_tls              = 6
const stt_relc             = 8
const stt_srelc            = 9
const stt_loos             = 10
const stt_hios             = 12
const stt_loproc           = 13
const stt_hiproc           = 14
const sht_null             = 0
const sht_progbits         = 1
const sht_symtab           = 2
const sht_strtab           = 3
const sht_rela             = 4
const sht_nobits           = 8
const shf_write            = 0x1
const shf_alloc            = 0x2
const shf_execinstr        = 0x4
const shf_merge            = 0x10
const shf_strings          = 0x20
const shf_info_link        = 0x40
const shf_link_order       = 0x80
const shf_os_nonconforming = 0x100
const shf_group            = 0x200
const shf_tls              = 0x400
const r_x86_64_none	  	= u64(0)
const r_x86_64_64		  	= u64(1)
const r_x86_64_pc32	  	= u64(2)
const r_x86_64_got32	  	= u64(3)
const r_x86_64_plt32	  	= u64(4)
const r_x86_64_copy	  	= u64(5)
const r_x86_64_glob_dat 	= u64(6)
const r_x86_64_jump_slot	= u64(7)
const r_x86_64_relative 	= u64(8)
const r_x86_64_gotpcrel 	= u64(9)
const r_x86_64_32		  	= u64(10)
const r_x86_64_32s	  	    = u64(11)
const r_x86_64_16		  	= u64(12)
const r_x86_64_pc16	  	= u64(13)
const r_x86_64_8		  	= u64(14)
const r_x86_64_pc8	  	    = u64(15)
const r_x86_64_tlsgd       = u64(19)
const r_x86_64_tlsld       = u64(20)
const r_x86_64_dtpoff32    = u64(21)
const r_x86_64_gottpoff    = u64(22)
const r_x86_64_tpoff32     = u64(23)
const r_x86_64_pc64	  	= u64(24)
const r_x86_64_gotoff64    = u64(25)
const r_x86_64_gotpcrelx   = u64(41)
const r_x86_64_rex_gotpcrelx = u64(42)
const stv_default			= 0
const stv_internal		    = 1
const stv_hidden			= 2
const stv_protected		= 3

pub fn new(out_file string, keep_locals bool, rela_text_users []encoder.Rela, user_defined_sections map[string]&encoder.UserDefinedSection, user_defined_symbols map[string]&encoder.Instr) &Elf {
	mut e := &Elf{
		out_file: out_file
		keep_locals: keep_locals
		rela_text_users: rela_text_users
		user_defined_symbols: user_defined_symbols
		user_defined_sections: user_defined_sections
	}

	for name, _ in e.user_defined_sections {
		e.user_defined_section_names << name
		e.user_defined_section_idx[name] = e.user_defined_section_idx.len + 1
	}

	return e
}

pub fn align_to(n int, align int) int {
	return (n + align - 1) / align * align
}

// is_symbol_reloc reports whether a relocation type references its symbol
// directly (GOT/PLT/TLS slots are per-symbol), so it must not be rewritten to a
// section-relative form even for local symbols.
// is_nobits reports whether a section holds no file content (SHT_NOBITS) — the
// .bss / .tbss families. Such sections occupy memory but not file space.
fn is_nobits(name string) bool {
	return name == '.bss' || name == '.tbss' || name.starts_with('.bss.')
		|| name.starts_with('.tbss.')
}

fn is_symbol_reloc(rtype u64) bool {
	return rtype in [r_x86_64_plt32, r_x86_64_gotpcrel, r_x86_64_gotpcrelx, r_x86_64_rex_gotpcrelx,
		r_x86_64_gottpoff, r_x86_64_tlsgd, r_x86_64_tlsld, r_x86_64_tpoff32, r_x86_64_dtpoff32,
		r_x86_64_got32, r_x86_64_gotoff64]
}

fn add_padding(mut code []u8) {
	padding := (align_to(code.len, 16) - code.len)
	for _ in 0 .. padding {
		code << 0
	}
}

fn (mut e Elf) elf_symbol(symbol_binding int, mut off &int, mut str &string) {
	for name, symbol in e.user_defined_symbols {
		if symbol.binding != symbol_binding {
			continue
		}

		if symbol.binding == stb_local {
			if !e.keep_locals && symbol.binding == stb_local && name.to_upper().starts_with('.L') {
				continue
			}
			e.local_symbols_count++
		}

		e.symtab_symbol_indexs[name] = e.symtab_symbol_indexs.len

		unsafe { *off += str.len + 1 }
		st_shndx := u16(e.user_defined_section_idx[symbol.section_name])
		mut st_name := u32(0)

		if symbol.symbol_type == stt_section {
			st_name = 0
		} else {
			st_name = u32(*off)
		}

		e.symtab << Elf64_Sym{
			st_name: st_name
			st_info: u8((symbol.binding << 4) + (symbol.symbol_type & 0xf))
			st_other: symbol.visibility
			st_shndx: st_shndx
			st_value: u64(symbol.addr)
		}

		e.strtab << name.bytes()
		e.strtab << 0x00
		str = name
	}
}

// Add rela symbol to symtab and strtab
// This function should be called after processing local symbols.
fn (mut e Elf) elf_rela_symbol(mut off &int, mut str &string) {
	for symbol_name in e.rela_symbols {
		unsafe {*off += str.len + 1}
		e.symtab_symbol_indexs[symbol_name] = e.symtab_symbol_indexs.len

		e.symtab << Elf64_Sym{
			st_name: u32(*off)
			st_info: u8((stb_global << 4) + (stt_notype & 0xf))
			st_shndx: 0
		}
		e.strtab << symbol_name.bytes()
		e.strtab << 0x00
		str = symbol_name
	}
}

pub fn (mut e Elf) rela_text_users() {
	/*
		x86: 再配置型
		https://docs.oracle.com/cd/E19683-01/817-4912/6mkdg542u/index.html#chapter6-26
	*/
	for r in e.rela_text_users {
		mut index := 0

		mut r_addend := if r.rtype in [r_x86_64_32s, r_x86_64_32, r_x86_64_64, r_x86_64_16, r_x86_64_8,
			r_x86_64_tpoff32, r_x86_64_dtpoff32, r_x86_64_got32, r_x86_64_gotoff64] {
			i64(0)
		} else if r.rtype in [r_x86_64_pc32, r_x86_64_plt32, r_x86_64_gotpcrel, r_x86_64_gotpcrelx,
			r_x86_64_rex_gotpcrelx, r_x86_64_gottpoff, r_x86_64_tlsgd, r_x86_64_tlsld] {
			i64(r.offset - r.instr.code.len)
		} else {
			i64(0-4)
		}

    	if r.is_already_resolved {
			continue
		}

		// Cross-section label-difference (and other pre-computed) relocations
		// carry their final addend; emit it verbatim against `uses` (its
		// section symbol when local).
		if r.set_addend {
			mut idx := 0
			if s := e.user_defined_symbols[r.uses] {
				idx = if s.binding == stb_global {
					e.symtab_symbol_indexs[r.uses]
				} else {
					e.symtab_symbol_indexs[s.section_name]
				}
			} else {
				idx = e.symtab_symbol_indexs[r.uses]
			}
			rela_section_name := '.rela' + r.instr.section_name
			e.rela[rela_section_name] << Elf64_Rela{
				r_offset: u64(r.instr.addr + r.offset)
				r_info:   (u64(idx) << 32) + r.rtype
				r_addend: r.addend
			}
			if rela_section_name !in e.rela_section_names {
				e.rela_section_names << rela_section_name
			}
			continue
		}

		if s := e.user_defined_symbols[r.uses] {
			// GOT/PLT/TLS relocations are always resolved per-symbol (there is a
			// GOT/TLS slot for the symbol itself), so they reference the symbol
			// even when it is local — unlike ordinary local references, which
			// are rewritten to be section-relative.
			if is_symbol_reloc(r.rtype) || s.binding == stb_global {
				index = e.symtab_symbol_indexs[r.uses]
			} else {
				r_addend += s.addr
				index = e.symtab_symbol_indexs[s.section_name]
			}
		} else {
			index = e.symtab_symbol_indexs[r.uses]
    	}

		rela_section_name := '.rela' + r.instr.section_name
		e.rela[rela_section_name] << Elf64_Rela{
    	    r_offset: u64(r.instr.addr + r.offset),
    	    r_info: (u64(index) << 32) + r.rtype,
    	    r_addend: r_addend + r.adjust,
    	}

		if rela_section_name !in e.rela_section_names {
			e.rela_section_names << rela_section_name
		}
	}
}

pub fn (mut e Elf) collect_rela_symbols() {
	for rela in e.rela_text_users {
		if rela.uses !in e.rela_symbols {
			if rela.uses in e.user_defined_symbols {
				continue
			}
			e.rela_symbols << rela.uses
		}
	}
}

pub fn (mut e Elf) build_symtab_strtab() {
	e.strtab << [u8(0x00)]
	e.symtab << Elf64_Sym{
		st_name: 0
		st_info: u8((stb_local << 4) + (stt_notype & 0xf))
	}
	e.symtab_symbol_indexs[''] = e.symtab_symbol_indexs.len // null symbol
	e.local_symbols_count++

	mut off := 0
	mut str := ''

	e.elf_symbol(stb_local, mut &off, mut &str)  // local
	e.elf_rela_symbol(mut &off, mut &str)            // rela local
	e.elf_symbol(stb_global, mut &off, mut &str) // global
	e.elf_symbol(2, mut &off, mut &str)          // weak (STB_WEAK)

	add_padding(mut e.strtab)
}

pub fn (mut e Elf) build_shstrtab() {
	e.shstrtab << [u8(0x00)]
	e.section_name_offs[''] = 0

	mut name_offs := ''.len + 1
	for name in e.user_defined_section_names {
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

	for name in e.rela.keys() {
		e.section_name_offs[name] = name_offs
		name_offs += name.len + 1

		e.shstrtab << name.bytes()
		e.shstrtab << 0x00
	}

	add_padding(mut e.shstrtab)
}

// TODO: refactor later...
pub fn (mut e Elf) build_headers() {
	mut section_offs := u64(sizeof(Elf64_Ehdr))
	mut section_idx := {'': 0}

	e.section_headers << Elf64_Shdr{
		sh_name: u32(e.section_name_offs[''])
		sh_type: sht_null
	}

	for name in e.user_defined_section_names {
		section := e.user_defined_sections[name] or {
			panic('[internal error] unkown section `$name`')
		}
		nobits := is_nobits(name)
		e.section_headers << Elf64_Shdr{
			sh_name: u32(e.section_name_offs[name])
			sh_type: u32(if nobits { sht_nobits } else { sht_progbits })
			sh_flags: u64(section.flags)
			sh_addr: 0
			sh_offset: section_offs
			sh_size: u64(section.code.len)
			sh_link: 0
			sh_info: 0
			sh_addralign: u64(if section.align > 0 { section.align } else { 1 })
			sh_entsize: 0
		}
		// A NOBITS section reserves no bytes in the file.
		if !nobits {
			section_offs += u64(section.code.len)
		}
		section_idx[name] = section_idx.len
	}

	strtab_ofs := section_offs
	strtab_size := u64(e.strtab.len)
	section_idx['.strtab'] = section_idx.len

	symtab_ofs := strtab_ofs + strtab_size
	symtab_size := u64(sizeof(Elf64_Sym)) * u64(e.symtab.len)
	section_idx['.symtab'] = section_idx.len

	e.section_headers << [
		Elf64_Shdr{
			sh_name: u32(e.section_name_offs['.strtab'])
			sh_type: sht_strtab
			sh_flags: 0
			sh_addr: 0
			sh_offset: strtab_ofs
			sh_size: strtab_size
			sh_link: 0
			sh_info: 0
			sh_addralign: u64(1)
			sh_entsize: 0
		},
		Elf64_Shdr{
			sh_name: u32(e.section_name_offs['.symtab'])
			sh_type: sht_symtab
			sh_flags: 0
			sh_addr: 0
			sh_offset: symtab_ofs
			sh_size: symtab_size
			sh_link: u32(section_idx['.strtab']) // section number of .strtab
			sh_info: u32(e.local_symbols_count) // Number of local symbols
			sh_addralign: u64(8)
			sh_entsize: u64(sizeof(Elf64_Sym))
		}
	]

	section_offs = symtab_ofs + symtab_size

	for name in e.rela_section_names {
		size := u64(e.rela[name].len) * u64(sizeof(Elf64_Rela))
		e.section_headers << Elf64_Shdr{
			sh_name: u32(e.section_name_offs[name])
			sh_type: sht_rela,
			sh_flags: u64(shf_info_link)
			sh_addr: 0
			sh_offset: section_offs
			sh_size: size
			sh_link: u32(section_idx['.symtab'])
			sh_info: u32(section_idx[name[5..]]) // target section index. if `.rela.text` the target will be `.text`
			sh_addralign: u64(8)
			sh_entsize: u64(sizeof(Elf64_Rela))
		}
		section_offs += size
	}

	e.section_headers << Elf64_Shdr{
		sh_name: u32(e.section_name_offs['.shstrtab'])
		sh_type: sht_strtab
		sh_flags: 0
		sh_addr: 0
		sh_offset: section_offs
		sh_size: u64(e.shstrtab.len)
		sh_link: 0
		sh_info: 0
		sh_addralign: u64(1)
		sh_entsize: 0
	}

	sectionheader_ofs := section_offs + u64(e.shstrtab.len)

	e.ehdr = Elf64_Ehdr{
		e_ident: [
			u8(0x7f), 0x45, 0x4c, 0x46, // Magic number ' ELF' in ascii format
			0x02, // 2 = 64-bit
			0x01, // 1 = little endian
			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		]!
		e_type: 1 // 1 = realocatable
		e_machine: 0x3e
		e_version: 1
		e_entry: 0
		e_phoff: 0
		e_shoff: u64(sectionheader_ofs)
		e_flags: 0x0
		e_ehsize: u16(sizeof(Elf64_Ehdr))
		e_phentsize: u16(sizeof(Elf64_Phdr))
		e_phnum: 0
		e_shentsize: u16(sizeof(Elf64_Shdr))
		e_shnum: u16(e.section_headers.len)
		e_shstrndx: u16(e.section_headers.len - 1)
	}
}

fn write_bytes[T](mut fp os.File, s T, label string) {
	unsafe {
		ptr := &u8(voidptr(&s))
		data := ptr.vbytes(int(sizeof(T)))
		fp.write(data) or { panic('error writing `${label}`') }
	}
}

pub fn (mut e Elf) write_elf() {
	mut fp := os.open_file(e.out_file, 'w') or { panic('error opening file `${e.out_file}`') }

	defer {
		fp.close()
	}

	write_bytes(mut fp, e.ehdr, 'elf header')

	for name in e.user_defined_section_names {
		if is_nobits(name) {
			continue // NOBITS sections carry no file content
		}
		section := e.user_defined_sections[name] or {
			panic('unkown section $name')
		}
		fp.write(section.code) or {
			panic('error writing `$name`')
		}
	}

	fp.write(e.strtab) or {
		panic('error writing `.strtab`')
	}

	for s in e.symtab {
		write_bytes(mut fp, s, '.symtab')
	}

	for name in e.rela_section_names {
		for r in e.rela[name] {
			write_bytes(mut fp, r, '.rela.text')
		}
	}

	fp.write(e.shstrtab) or {
		panic('error writing `.shstrtab`')
	}

	for sh in e.section_headers {
		write_bytes(mut fp, sh, 'section_headers')
	}
}
