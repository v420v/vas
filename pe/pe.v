module pe

import encoder
import os
import encoding.binary

// COFF machine type
const image_file_machine_amd64 = u16(0x8664)

// Section characteristics
const image_scn_cnt_code               = u32(0x00000020)
const image_scn_cnt_initialized_data   = u32(0x00000040)
const image_scn_cnt_uninitialized_data = u32(0x00000080)
const image_scn_mem_execute            = u32(0x20000000)
const image_scn_mem_read               = u32(0x40000000)
const image_scn_mem_write              = u32(0x80000000)
const image_scn_align_4bytes           = u32(0x00300000)
const image_scn_align_8bytes           = u32(0x00400000)
// Set when a section has more than 0xFFFF relocations; real count goes in
// the VirtualAddress field of a synthetic leading relocation entry.
const image_scn_lnk_nreloc_ovfl       = u32(0x01000000)

// Symbol storage classes
const image_sym_class_external = u8(2)
const image_sym_class_static   = u8(3)

// COFF AMD64 relocation types
const image_rel_amd64_addr64 = u16(0x0001) // 64-bit absolute VA
const image_rel_amd64_addr32 = u16(0x0002) // 32-bit absolute VA
const image_rel_amd64_rel32  = u16(0x0004) // 32-bit RIP-relative (next-instr based)

// ELF rtype mirrors (from encoder package)
const r_x86_64_64       = u64(1)
const r_x86_64_pc32     = u64(2)
const r_x86_64_plt32    = u64(4)
const r_x86_64_gotpcrel = u64(9)
const r_x86_64_32       = u64(10)
const r_x86_64_32s      = u64(11)
const r_x86_64_16       = u64(12)
const r_x86_64_8        = u64(14)
const r_x86_64_pc64     = u64(24)

// COFF File Header (IMAGE_FILE_HEADER) — 20 bytes, naturally aligned.
struct CoffFileHeader {
	machine                 u16
	number_of_sections      u16
	time_date_stamp         u32
	pointer_to_symbol_table u32
	number_of_symbols       u32
	size_of_optional_header u16
	characteristics         u16
}

// Section Header (IMAGE_SECTION_HEADER) — 40 bytes, naturally aligned.
struct CoffSectionHeader {
	name                   [8]u8
	virtual_size           u32 // 0 for object files
	virtual_address        u32 // 0 for object files
	size_of_raw_data       u32
	pointer_to_raw_data    u32
	pointer_to_relocations u32
	pointer_to_linenumbers u32 // deprecated, always 0
	number_of_relocations  u16
	number_of_linenumbers  u16 // deprecated, always 0
	characteristics        u32
}

// Internal relocation record (written manually as 10 bytes to avoid padding).
struct CoffReloc {
	virtual_address    u32
	symbol_table_index u32
	typ                u16
}

// Internal symbol record (written manually as 18 bytes to avoid padding).
struct CoffSym {
	name           [8]u8 // if [0..3]==0 then [4..7] is string-table offset
	value          u32
	section_number i16
	typ            u16
	storage_class  u8
	num_aux        u8
}

struct PeSection {
	elf_name string
	name     string
	chars    u32
	is_bss   bool
	size     u32
mut:
	data   []u8
	relocs []CoffReloc
}

pub struct Pe {
	out_file              string
	rela_text_users       []encoder.Rela
	user_defined_symbols  map[string]&encoder.Instr
	user_defined_sections map[string]&encoder.UserDefinedSection
mut:
	keep_locals  bool
	sections     []PeSection
	section_names []string
	section_idx  map[string]int // ELF name → 1-based COFF section index
	syms         []CoffSym
	sym_indices  map[string]int // symbol name → 0-based symbol table index
	strtab       []u8          // string table content (no leading 4-byte size field)
	rela_symbols []string
}

pub fn new(out_file string, keep_locals bool, rela_text_users []encoder.Rela, user_defined_sections map[string]&encoder.UserDefinedSection, user_defined_symbols map[string]&encoder.Instr) &Pe {
	mut p := &Pe{
		out_file:              out_file
		keep_locals:           keep_locals
		rela_text_users:       rela_text_users
		user_defined_symbols:  user_defined_symbols
		user_defined_sections: user_defined_sections
	}

	mut idx := 1
	for name, section in user_defined_sections {
		is_bss := name == '.bss' || name.starts_with('.bss.')
		p.sections << PeSection{
			elf_name: name
			name:     elf_section_to_coff(name)
			chars:    section_characteristics(name, section.flags)
			is_bss:   is_bss
			size:     u32(section.code.len)
			data:     if is_bss { []u8{} } else { section.code.clone() }
		}
		p.section_names << name
		p.section_idx[name] = idx
		idx++
	}
	return p
}

fn elf_section_to_coff(name string) string {
	match true {
		name == '.text' || name.starts_with('.text.')     { return '.text' }
		name == '.data' || name.starts_with('.data.')     { return '.data' }
		name == '.bss' || name.starts_with('.bss.')       { return '.bss' }
		name == '.rodata' || name.starts_with('.rodata.') { return '.rdata' }
		name == '.cstring'                                 { return '.rdata' }
		else {
			return if name.len > 8 { name[..8] } else { name }
		}
	}
}

fn section_characteristics(name string, elf_flags int) u32 {
	if name == '.text' || name.starts_with('.text.') || elf_flags & 0x4 != 0 {
		return image_scn_cnt_code | image_scn_mem_execute | image_scn_mem_read | image_scn_align_4bytes
	}
	if name == '.bss' || name.starts_with('.bss.') {
		return image_scn_cnt_uninitialized_data | image_scn_mem_read | image_scn_mem_write | image_scn_align_8bytes
	}
	if name == '.rodata' || name.starts_with('.rodata.') || name == '.cstring' {
		return image_scn_cnt_initialized_data | image_scn_mem_read | image_scn_align_8bytes
	}
	if elf_flags & 0x1 != 0 {
		return image_scn_cnt_initialized_data | image_scn_mem_read | image_scn_mem_write | image_scn_align_8bytes
	}
	return image_scn_cnt_initialized_data | image_scn_mem_read | image_scn_align_8bytes
}

// Maps ELF relocation types to COFF AMD64 relocation types.
// Aborts with a clear diagnostic for ELF relocation widths that have no COFF
// equivalent rather than silently emitting a wider relocation that would
// overwrite adjacent bytes (e.g. r_x86_64_16 / r_x86_64_8 → ADDR32 was wrong).
fn elf_rtype_to_coff(rtype u64) u16 {
	match rtype {
		r_x86_64_64               { return image_rel_amd64_addr64 }
		r_x86_64_32, r_x86_64_32s { return image_rel_amd64_addr32 }
		r_x86_64_16 {
			eprintln('pe: error: R_X86_64_16 has no COFF/AMD64 equivalent — `.word sym` is unsupported for PE output')
			exit(1)
		}
		r_x86_64_8 {
			eprintln('pe: error: R_X86_64_8 has no COFF/AMD64 equivalent — `.byte sym` is unsupported for PE output')
			exit(1)
		}
		r_x86_64_pc64 {
			eprintln('pe: error: R_X86_64_PC64 has no COFF/AMD64 equivalent — 64-bit PC-relative relocation is unsupported for PE output')
			exit(1)
		}
		else { return image_rel_amd64_rel32 }
	}
}

// Write r.adjust as a little-endian i32 into section data at the relocation site.
fn embed_i32(mut data []u8, offset i32, value i32) {
	off := int(offset)
	if off < 0 || off + 4 > data.len { return }
	mut b := [u8(0), 0, 0, 0]
	binary.little_endian_put_u32(mut b, u32(value))
	for i in 0 .. 4 { data[off + i] = b[i] }
}

// Write r.adjust as a little-endian i64 into section data at the relocation site.
fn embed_i64(mut data []u8, offset i32, value i64) {
	off := int(offset)
	if off < 0 || off + 8 > data.len { return }
	mut b := [u8(0), 0, 0, 0, 0, 0, 0, 0]
	binary.little_endian_put_u64(mut b, u64(value))
	for i in 0 .. 8 { data[off + i] = b[i] }
}

pub fn (mut p Pe) collect_rela_symbols() {
	for r in p.rela_text_users {
		if r.uses !in p.rela_symbols {
			if r.uses in p.user_defined_symbols {
				continue
			}
			p.rela_symbols << r.uses
		}
	}
}

// Build a CoffSym, adding long names to the string table.
fn (mut p Pe) make_sym(name string, section_number i16, value u32, storage_class u8) CoffSym {
	mut n := [8]u8{}
	if name.len <= 8 {
		for i in 0 .. name.len { n[i] = name[i] }
	} else {
		// First 4 bytes zero, next 4 bytes = offset from start of string table.
		str_off := u32(4 + p.strtab.len)
		mut b := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut b, str_off)
		n[4] = b[0]; n[5] = b[1]; n[6] = b[2]; n[7] = b[3]
		p.strtab << name.bytes()
		p.strtab << u8(0)
	}
	return CoffSym{
		name:           n
		value:          value
		section_number: section_number
		typ:            0
		storage_class:  storage_class
		num_aux:        0
	}
}

// Build the symbol table and string table.
// Order: locals → defined globals → undefined externals.
pub fn (mut p Pe) build_symtab_strtab() {
	// 1. Local symbols
	for name, sym in p.user_defined_symbols {
		if sym.binding != 0 { continue } // not local
		if sym.symbol_type == 3 { continue } // stt_section — no COFF equivalent
		if !p.keep_locals && name.to_upper().starts_with('.L') { continue }

		p.sym_indices[name] = p.syms.len
		p.syms << p.make_sym(name, i16(p.section_idx[sym.section_name]), u32(sym.addr),
			image_sym_class_static)
	}

	// 2. Defined global symbols
	for name, sym in p.user_defined_symbols {
		if sym.binding != 1 { continue } // not global
		if sym.symbol_type == 3 { continue }

		p.sym_indices[name] = p.syms.len
		p.syms << p.make_sym(name, i16(p.section_idx[sym.section_name]), u32(sym.addr),
			image_sym_class_external)
	}

	// 3. Weak symbols — COFF has no native weak binding; treat as external.
	//    section_name == '' means undefined; otherwise defined.
	for name, sym in p.user_defined_symbols {
		if sym.binding != 2 { continue } // not weak (stb_weak)
		if sym.symbol_type == 3 { continue }
		p.sym_indices[name] = p.syms.len
		if sym.section_name == '' {
			p.syms << p.make_sym(name, i16(0), 0, image_sym_class_external)
		} else {
			p.syms << p.make_sym(name, i16(p.section_idx[sym.section_name]),
				u32(sym.addr), image_sym_class_external)
		}
	}

	// 4. Undefined external symbols
	for sym_name in p.rela_symbols {
		p.sym_indices[sym_name] = p.syms.len
		p.syms << p.make_sym(sym_name, i16(0), 0, image_sym_class_external)
	}
}

// Convert ELF relocations to COFF IMAGE_RELOCATION records.
//
// COFF uses implicit (inline) addends.  The linker computes:
//   REL32:  sym_section_va + sym.value + inline - (source_section_va + r_va + 4)
//   ADDR64: sym_section_va + sym.value + inline
//   ADDR32: sym_section_va + sym.value + inline
//
// Since sym.value == sym.addr (offset within section) is already in the symbol
// table, we only need to embed r.adjust as the inline addend.
pub fn (mut p Pe) build_relocations() {
	for r in p.rela_text_users {
		if r.is_already_resolved { continue }

		mut sect_i := -1
		for i, s in p.sections {
			if s.elf_name == r.instr.section_name {
				sect_i = i
				break
			}
		}
		if sect_i < 0 { continue }

		r_va := u32(r.instr.addr + r.offset)
		coff_type := elf_rtype_to_coff(r.rtype)
		sym_idx := u32(p.sym_indices[r.uses])

		// Embed r.adjust as the inline addend into section data.
		if r.adjust != 0 {
			if coff_type == image_rel_amd64_addr64 {
				embed_i64(mut p.sections[sect_i].data, i32(r_va), i64(r.adjust))
			} else {
				embed_i32(mut p.sections[sect_i].data, i32(r_va), i32(r.adjust))
			}
		}

		p.sections[sect_i].relocs << CoffReloc{
			virtual_address:    r_va
			symbol_table_index: sym_idx
			typ:                coff_type
		}
	}
}

// Serialize any struct whose size is free of padding as raw bytes.
fn write_struct[T](mut fp os.File, s T) {
	unsafe {
		fp.write((&u8(voidptr(&s))).vbytes(int(sizeof(T)))) or { panic('pe: write error') }
	}
}

// Write a CoffReloc as exactly 10 bytes (avoids struct tail-padding to 12).
fn write_coff_reloc(mut fp os.File, r CoffReloc) {
	mut buf := []u8{len: 10, init: 0}
	mut b4 := [u8(0), 0, 0, 0]
	binary.little_endian_put_u32(mut b4, r.virtual_address)
	buf[0] = b4[0]; buf[1] = b4[1]; buf[2] = b4[2]; buf[3] = b4[3]
	binary.little_endian_put_u32(mut b4, r.symbol_table_index)
	buf[4] = b4[0]; buf[5] = b4[1]; buf[6] = b4[2]; buf[7] = b4[3]
	mut b2 := [u8(0), 0]
	binary.little_endian_put_u16(mut b2, r.typ)
	buf[8] = b2[0]; buf[9] = b2[1]
	fp.write(buf) or {}
}

// Write a CoffSym as exactly 18 bytes (avoids struct tail-padding to 20).
fn write_coff_sym(mut fp os.File, s CoffSym) {
	mut buf := []u8{len: 18, init: 0}
	for i in 0 .. 8 { buf[i] = s.name[i] }
	mut b4 := [u8(0), 0, 0, 0]
	binary.little_endian_put_u32(mut b4, s.value)
	buf[8] = b4[0]; buf[9] = b4[1]; buf[10] = b4[2]; buf[11] = b4[3]
	mut b2 := [u8(0), 0]
	binary.little_endian_put_u16(mut b2, u16(s.section_number))
	buf[12] = b2[0]; buf[13] = b2[1]
	binary.little_endian_put_u16(mut b2, s.typ)
	buf[14] = b2[0]; buf[15] = b2[1]
	buf[16] = s.storage_class
	buf[17] = s.num_aux
	fp.write(buf) or {}
}

// Write the complete COFF object file.
//
// File layout:
//   [COFF File Header: 20 bytes]
//   [Section Headers: 40 bytes * nsections]
//   [Section data]
//   [Relocation tables: 10 bytes per entry]
//   [Symbol table: 18 bytes per entry]
//   [String table: 4-byte size + NUL-terminated strings]
pub fn (mut p Pe) write_pe() {
	nsects := u32(p.sections.len)

	hdr_sz      := u32(sizeof(CoffFileHeader))
	sect_hdr_sz := nsects * u32(sizeof(CoffSectionHeader))

	mut cur       := hdr_sz + sect_hdr_sz
	mut sect_off  := []u32{len: int(nsects), init: 0}
	mut reloc_off := []u32{len: int(nsects), init: 0}

	// Section data offsets (BSS carries no file bytes).
	for i, s in p.sections {
		if s.is_bss || s.data.len == 0 {
			sect_off[i] = 0
			continue
		}
		sect_off[i] = cur
		cur += u32(s.data.len)
	}

	// Relocation table offsets (10 bytes per entry).
	// When a section has more than 0xFFFF relocations a synthetic overflow
	// entry is prepended, so allocate one extra slot in that case.
	for i, s in p.sections {
		if s.relocs.len == 0 { continue }
		reloc_off[i] = cur
		n_entries := if s.relocs.len > 0xffff { s.relocs.len + 1 } else { s.relocs.len }
		cur += u32(n_entries) * 10
	}

	symtab_off  := cur
	strtab_size := u32(4 + p.strtab.len) // includes 4-byte size field

	// Build section headers.
	mut sect_hdrs := []CoffSectionHeader{}
	for i, s in p.sections {
		mut n := [8]u8{}
		for j := 0; j < s.name.len && j < 8; j++ { n[j] = s.name[j] }

		raw_size := if s.is_bss { s.size } else { u32(s.data.len) }
		raw_ptr  := if s.is_bss { u32(0) } else { sect_off[i] }

		// COFF overflow encoding: when reloc count exceeds the 16-bit field
		// capacity, set IMAGE_SCN_LNK_NRELOC_OVFL and store 0xFFFF in the
		// header; the real count (+1 for the synthetic entry) lives in the
		// VirtualAddress of the first (synthetic) relocation record.
		nreloc := if s.relocs.len > 0xffff { u16(0xffff) } else { u16(s.relocs.len) }
		chars  := if s.relocs.len > 0xffff { s.chars | image_scn_lnk_nreloc_ovfl } else { s.chars }
		sect_hdrs << CoffSectionHeader{
			name:                   n
			virtual_size:           0
			virtual_address:        0
			size_of_raw_data:       raw_size
			pointer_to_raw_data:    raw_ptr
			pointer_to_relocations: reloc_off[i]
			pointer_to_linenumbers: 0
			number_of_relocations:  nreloc
			number_of_linenumbers:  0
			characteristics:        chars
		}
	}

	hdr := CoffFileHeader{
		machine:                 image_file_machine_amd64
		number_of_sections:      u16(nsects)
		time_date_stamp:         0 // zero for reproducible builds
		pointer_to_symbol_table: symtab_off
		number_of_symbols:       u32(p.syms.len)
		size_of_optional_header: 0
		characteristics:         0
	}

	mut fp := os.open_file(p.out_file, 'w') or { panic('pe: cannot open `${p.out_file}`') }
	defer { fp.close() }

	write_struct(mut fp, hdr)
	for sh in sect_hdrs {
		write_struct(mut fp, sh)
	}

	// Section data.
	for s in p.sections {
		if s.is_bss || s.data.len == 0 { continue }
		fp.write(s.data) or { panic('pe: error writing `${s.elf_name}`') }
	}

	// Relocation tables.
	for s in p.sections {
		if s.relocs.len > 0xffff {
			// Synthetic overflow entry: VirtualAddress carries the true count
			// (real relocs + 1 for this synthetic entry), per COFF spec §5.2.
			write_coff_reloc(mut fp, CoffReloc{
				virtual_address:    u32(s.relocs.len + 1)
				symbol_table_index: 0
				typ:                0
			})
		}
		for r in s.relocs {
			write_coff_reloc(mut fp, r)
		}
	}

	// Symbol table (18 bytes per entry).
	for sym in p.syms {
		write_coff_sym(mut fp, sym)
	}

	// String table: 4-byte total size followed by NUL-terminated strings.
	mut sz_b := [u8(0), 0, 0, 0]
	binary.little_endian_put_u32(mut sz_b, strtab_size)
	fp.write(sz_b) or {}
	if p.strtab.len > 0 {
		fp.write(p.strtab) or { panic('pe: error writing string table') }
	}
}
