module macho

import encoder
import os
import encoding.binary

const mh_magic_64            = u32(0xFEEDFACF)
const cpu_type_x86_64        = i32(0x01000007)
const cpu_subtype_x86_64_all = i32(0x00000003)
const mh_object              = u32(0x00000001)
const lc_segment_64          = u32(0x00000019)
const lc_symtab              = u32(0x00000002)
const vm_prot_all            = i32(7)

// Section type (low 8 bits of Section64.flags)
const s_regular               = u32(0x00000000)
const s_zerofill              = u32(0x00000001)
const s_cstring_literals      = u32(0x00000002)

// Section attributes (high 24 bits of Section64.flags)
const s_attr_pure_instructions = u32(0x80000000)
const s_attr_some_instructions = u32(0x00000400)

// nlist_64 n_type flags
const n_ext  = u8(0x01)
const n_undf = u8(0x00)
const n_sect = u8(0x0e)

const no_sect = u8(0)

// nlist_64 n_desc flags for weak symbols
const n_weak_ref = u16(0x0040) // undefined weak reference
const n_weak_def = u16(0x0080) // defined weak symbol

// x86-64 Mach-O relocation types
const x86_64_reloc_unsigned = u8(0)
const x86_64_reloc_signed   = u8(1)
const x86_64_reloc_branch   = u8(2)
const x86_64_reloc_got_load = u8(3)
const x86_64_reloc_got      = u8(4)

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

struct MachHeader64 {
	magic      u32
	cputype    i32
	cpusubtype i32
	filetype   u32
	ncmds      u32
	sizeofcmds u32
	flags      u32
	reserved   u32
}

struct SegmentCommand64 {
	cmd      u32
	cmdsize  u32
	segname  [16]u8
	vmaddr   u64
	vmsize   u64
	fileoff  u64
	filesize u64
	maxprot  i32
	initprot i32
	nsects   u32
	flags    u32
}

struct Section64 {
	sectname  [16]u8
	segname   [16]u8
	addr      u64
	size      u64
	offset    u32
	align     u32
	reloff    u32
	nreloc    u32
	flags     u32
	reserved1 u32
	reserved2 u32
	reserved3 u32
}

struct SymtabCommand {
	cmd     u32
	cmdsize u32
	symoff  u32
	nsyms   u32
	stroff  u32
	strsize u32
}

struct Nlist64 {
	n_strx  u32
	n_type  u8
	n_sect  u8
	n_desc  u16
	n_value u64
}

struct MachoReloc {
	r_address   i32
	r_symbolnum u32
	r_pcrel     u8
	r_length    u8
	r_extern    u8
	r_type      u8
}

struct MachoSection {
	elf_name    string
	sectname    string
	segname     string
	flags       u32
	align_pow   u32 // section alignment = 2^align_pow
	is_zerofill bool
	sect_size   u64 // logical section size (data.len for regular, zero-count for zerofill)
mut:
	data   []u8
	relocs []MachoReloc
}

pub struct Macho {
	out_file              string
	rela_text_users       []encoder.Rela
	user_defined_symbols  map[string]&encoder.Instr
	user_defined_sections map[string]&encoder.UserDefinedSection
mut:
	keep_locals    bool
	sections       []MachoSection
	section_names  []string      // ordered list of ELF section names
	section_idx    map[string]int // ELF name → 1-based Mach-O section index
	symtab         []Nlist64
	symtab_indices map[string]int
	strtab         []u8
	rela_symbols   []string // undefined symbols referenced by relocations
}

pub fn new(out_file string, keep_locals bool, rela_text_users []encoder.Rela, user_defined_sections map[string]&encoder.UserDefinedSection, user_defined_symbols map[string]&encoder.Instr) &Macho {
	mut m := &Macho{
		out_file:              out_file
		keep_locals:           keep_locals
		rela_text_users:       rela_text_users
		user_defined_symbols:  user_defined_symbols
		user_defined_sections: user_defined_sections
	}

	mut idx := 1
	for name, section in user_defined_sections {
		sectname, segname := elf_section_to_macho(name, section.flags)
		is_zerofill := name == '.bss'
		m.sections << MachoSection{
			elf_name:    name
			sectname:    sectname
			segname:     segname
			flags:       section_type_flags(name, section.flags)
			align_pow:   section_align_pow(name, section.flags)
			is_zerofill: is_zerofill
			sect_size:   u64(section.code.len)
			data:        if is_zerofill { []u8{} } else { section.code.clone() }
		}
		m.section_names << name
		m.section_idx[name] = idx
		idx++
	}

	return m
}

// Maps ELF section name + flags to (Mach-O sectname, segname).
fn elf_section_to_macho(name string, elf_flags int) (string, string) {
	match true {
		name == '.text' || name.starts_with('.text.') {
			return '__text', '__TEXT'
		}
		name == '.data' || name.starts_with('.data.') {
			return '__data', '__DATA'
		}
		name == '.bss' || name.starts_with('.bss.') {
			return '__bss', '__DATA'
		}
		name == '.rodata' || name.starts_with('.rodata.') {
			return '__const', '__TEXT'
		}
		name == '.cstring' {
			return '__cstring', '__TEXT'
		}
		else {
			seg := if elf_flags & 0x4 != 0 {
				'__TEXT'
			} else if elf_flags & 0x1 != 0 {
				'__DATA'
			} else {
				'__TEXT'
			}
			mut sn := if name.starts_with('.') { '__' + name[1..] } else { '__' + name }
			if sn.len > 16 {
				sn = sn[..16]
			}
			return sn, seg
		}
	}
}

fn section_type_flags(name string, elf_flags int) u32 {
	if name == '.bss' || name.starts_with('.bss.') {
		return s_zerofill
	}
	if name == '.cstring' {
		return s_cstring_literals
	}
	if name == '.text' || name.starts_with('.text.') || elf_flags & 0x4 != 0 {
		return s_attr_pure_instructions | s_attr_some_instructions | s_regular
	}
	return s_regular
}

fn section_align_pow(name string, _ int) u32 {
	if name == '.text' || name.starts_with('.text.') { return 2 } // 4-byte
	if name == '.data' || name == '.bss' { return 3 } // 8-byte
	return 0
}

// Copies a string into a fixed-size 16-byte zero-padded array.
fn str16(s string) [16]u8 {
	mut arr := [16]u8{}
	for i := 0; i < s.len && i < 16; i++ {
		arr[i] = s[i]
	}
	return arr
}

// Packs the bitfield half of a relocation_info record (little-endian u32).
fn pack_reloc_info(symbolnum u32, pcrel u8, length u8, is_extern u8, rtype u8) u32 {
	return (symbolnum & 0x00FFFFFF) | (u32(pcrel) << 24) | (u32(length) << 25) |
		(u32(is_extern) << 27) | (u32(rtype) << 28)
}

// Returns (macho_type, pcrel, r_length).
// r_length: 0=1B 1=2B 2=4B 3=8B
fn elf_rtype_to_macho(rtype u64) (u8, u8, u8) {
	match rtype {
		r_x86_64_64      { return x86_64_reloc_unsigned, 0, 3 }
		r_x86_64_32,
		r_x86_64_32s     { return x86_64_reloc_unsigned, 0, 2 }
		r_x86_64_16      { return x86_64_reloc_unsigned, 0, 1 }
		r_x86_64_8       { return x86_64_reloc_unsigned, 0, 0 }
		r_x86_64_pc32    { return x86_64_reloc_signed,   1, 2 }
		r_x86_64_plt32   { return x86_64_reloc_branch,   1, 2 }
		r_x86_64_gotpcrel { return x86_64_reloc_got_load, 1, 2 }
		r_x86_64_pc64    { return x86_64_reloc_signed,   1, 3 }
		else             { return x86_64_reloc_unsigned, 0, 2 }
	}
}

// For local (r_extern=0) Mach-O relocations the implicit addend lives inside
// the section data at the relocation site.  Write `value` in little-endian
// at byte `offset` using `length` bytes (Mach-O r_length encoding).
fn embed_addend(mut data []u8, offset i32, value i64, length u8) {
	off := int(offset)
	if off < 0 { return }
	match length {
		0 {
			if off >= data.len { return }
			data[off] = u8(value)
		}
		1 {
			if off + 2 > data.len { return }
			mut b := [u8(0), 0]
			binary.little_endian_put_u16(mut b, u16(value))
			data[off] = b[0]; data[off + 1] = b[1]
		}
		2 {
			if off + 4 > data.len { return }
			mut b := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut b, u32(i32(value)))
			data[off] = b[0]; data[off + 1] = b[1]
			data[off + 2] = b[2]; data[off + 3] = b[3]
		}
		3 {
			if off + 8 > data.len { return }
			mut b := [u8(0), 0, 0, 0, 0, 0, 0, 0]
			binary.little_endian_put_u64(mut b, u64(value))
			for i in 0 .. 8 { data[off + i] = b[i] }
		}
		else {}
	}
}

// Collect symbols that need external relocations (undefined in this TU).
pub fn (mut m Macho) collect_rela_symbols() {
	for r in m.rela_text_users {
		if r.uses !in m.rela_symbols {
			if r.uses in m.user_defined_symbols {
				continue
			}
			m.rela_symbols << r.uses
		}
	}
}

// Build the Mach-O symbol table and string table.
// Ordering: locals → defined globals → undefined externals (LC_DYSYMTAB-friendly).
pub fn (mut m Macho) build_symtab_strtab() {
	m.strtab << u8(0x00) // string table always starts with a null byte

	// 1. Local symbols (skip section markers and .L labels unless keep_locals)
	for name, sym in m.user_defined_symbols {
		if sym.binding != 0 { continue } // not local
		if sym.symbol_type == 3 { continue } // stt_section — no Mach-O equivalent
		if !m.keep_locals && name.to_upper().starts_with('.L') { continue }

		strx := u32(m.strtab.len)
		m.strtab << name.bytes()
		m.strtab << u8(0x00)
		m.symtab_indices[name] = m.symtab.len
		m.symtab << Nlist64{
			n_strx:  strx
			n_type:  n_sect
			n_sect:  u8(m.section_idx[sym.section_name])
			n_value: u64(sym.addr)
		}
	}

	// 2. Defined global symbols
	for name, sym in m.user_defined_symbols {
		if sym.binding != 1 { continue } // not global
		if sym.symbol_type == 3 { continue } // stt_section

		strx := u32(m.strtab.len)
		m.strtab << name.bytes()
		m.strtab << u8(0x00)
		m.symtab_indices[name] = m.symtab.len
		m.symtab << Nlist64{
			n_strx:  strx
			n_type:  n_sect | n_ext
			n_sect:  u8(m.section_idx[sym.section_name])
			n_value: u64(sym.addr)
		}
	}

	// 3. Weak symbols (defined weak → N_WEAK_DEF, undefined weak → N_WEAK_REF)
	for name, sym in m.user_defined_symbols {
		if sym.binding != 2 { continue } // not weak (stb_weak)
		if sym.symbol_type == 3 { continue } // stt_section
		strx := u32(m.strtab.len)
		m.strtab << name.bytes()
		m.strtab << u8(0x00)
		m.symtab_indices[name] = m.symtab.len
		if sym.section_name == '' {
			// undefined weak reference
			m.symtab << Nlist64{
				n_strx: strx
				n_type: n_undf | n_ext
				n_sect: no_sect
				n_desc: n_weak_ref
			}
		} else {
			// defined weak symbol
			m.symtab << Nlist64{
				n_strx:  strx
				n_type:  n_sect | n_ext
				n_sect:  u8(m.section_idx[sym.section_name])
				n_desc:  n_weak_def
				n_value: u64(sym.addr)
			}
		}
	}

	// 4. Undefined external symbols
	for sym_name in m.rela_symbols {
		strx := u32(m.strtab.len)
		m.strtab << sym_name.bytes()
		m.strtab << u8(0x00)
		m.symtab_indices[sym_name] = m.symtab.len
		m.symtab << Nlist64{
			n_strx:  strx
			n_type:  n_undf | n_ext
			n_sect:  no_sect
			n_value: 0
		}
	}
}

// Convert ELF relocation entries to Mach-O relocation_info records.
// For local (non-external) symbol references the addend is embedded directly
// into the section data, as Mach-O uses implicit (REL) rather than explicit
// (RELA) addends.
pub fn (mut m Macho) build_relocations() {
	for r in m.rela_text_users {
		if r.is_already_resolved {
			continue
		}

		// Locate the section that contains this instruction.
		mut sect_i := -1
		for i, s in m.sections {
			if s.elf_name == r.instr.section_name {
				sect_i = i
				break
			}
		}
		if sect_i < 0 { continue }

		r_address := i32(r.instr.addr + r.offset)
		r_type, r_pcrel, r_length := elf_rtype_to_macho(r.rtype)

		mut r_extern   := u8(0)
		mut r_symbolnum := u32(0)

		if sym := m.user_defined_symbols[r.uses] {
			if sym.binding == 1 { // stb_global — reference via symbol table
				r_extern    = 1
				r_symbolnum = u32(m.symtab_indices[r.uses])
				// Field stays 0 (encoder already wrote 0 for unresolved refs).
			} else { // stb_local — section-relative relocation
				r_extern    = 0
				r_symbolnum = u32(m.section_idx[sym.section_name])
				// For r_extern=0 Mach-O relocations the linker applies:
				//   new_disp = target_section_final - source_section_final + initial_value
				// so for pcrel we must pre-subtract (r_address + 4) from the addend.
				addend := if r_pcrel == 1 {
					sym.addr + i64(r.adjust) - i64(r_address) - 4
				} else {
					sym.addr + i64(r.adjust)
				}
				embed_addend(mut m.sections[sect_i].data, r_address, addend, r_length)
			}
		} else { // undefined external
			r_extern    = 1
			r_symbolnum = u32(m.symtab_indices[r.uses])
		}

		m.sections[sect_i].relocs << MachoReloc{
			r_address:   r_address
			r_symbolnum: r_symbolnum
			r_pcrel:     r_pcrel
			r_length:    r_length
			r_extern:    r_extern
			r_type:      r_type
		}
	}
}

fn align_up(n u32, pow u32) u32 {
	if pow == 0 { return n }
	a := u32(1) << pow
	return (n + a - 1) / a * a
}

// Serialize any struct directly into the file as raw bytes.
fn write_struct[T](mut fp os.File, s T) {
	unsafe {
		fp.write((&u8(voidptr(&s))).vbytes(int(sizeof(T)))) or {
			panic('macho: write error')
		}
	}
}

// Write the complete Mach-O object file.
pub fn (mut m Macho) write_macho() {
	nsects := u32(m.sections.len)

	hdr_sz    := u32(sizeof(MachHeader64))
	seg_sz    := u32(sizeof(SegmentCommand64)) + nsects * u32(sizeof(Section64))
	stab_sz   := u32(sizeof(SymtabCommand))
	cmds_sz   := seg_sz + stab_sz

	mut cur         := hdr_sz + cmds_sz
	mut sect_off    := []u32{len: int(nsects), init: 0}
	mut reloc_off   := []u32{len: int(nsects), init: 0}
	mut seg_vmsize  := u64(0)
	mut seg_filesize := u64(0)

	for i, s in m.sections {
		seg_vmsize += s.sect_size
		if s.is_zerofill {
			sect_off[i] = 0 // zerofill sections carry no file bytes
			continue
		}
		cur = align_up(cur, s.align_pow)
		sect_off[i]   = cur
		cur           += u32(s.data.len)
		seg_filesize  += u64(s.data.len)
	}

	// Relocation tables follow section data.
	for i, s in m.sections {
		if s.relocs.len == 0 { continue }
		reloc_off[i] = cur
		cur += u32(s.relocs.len) * 8 // 8 bytes per relocation_info
	}

	// Symbol table then string table.
	symtab_off := cur
	cur        += u32(m.symtab.len) * u32(sizeof(Nlist64))
	strtab_off := cur
	strtab_sz  := u32(m.strtab.len)

	mut sec64s := []Section64{}
	for i, s in m.sections {
		sec64s << Section64{
			sectname:  str16(s.sectname)
			segname:   str16(s.segname)
			addr:      0
			size:      s.sect_size
			offset:    sect_off[i]
			align:     s.align_pow
			reloff:    reloc_off[i]
			nreloc:    u32(s.relocs.len)
			flags:     s.flags
		}
	}

	seg_cmd := SegmentCommand64{
		cmd:      lc_segment_64
		cmdsize:  seg_sz
		segname:  [16]u8{} // empty — standard for MH_OBJECT
		vmaddr:   0
		vmsize:   seg_vmsize
		fileoff:  u64(hdr_sz + cmds_sz)
		filesize: seg_filesize
		maxprot:  vm_prot_all
		initprot: vm_prot_all
		nsects:   nsects
		flags:    0
	}

	symtab_cmd := SymtabCommand{
		cmd:     lc_symtab
		cmdsize: u32(sizeof(SymtabCommand))
		symoff:  symtab_off
		nsyms:   u32(m.symtab.len)
		stroff:  strtab_off
		strsize: strtab_sz
	}

	hdr := MachHeader64{
		magic:      mh_magic_64
		cputype:    cpu_type_x86_64
		cpusubtype: cpu_subtype_x86_64_all
		filetype:   mh_object
		ncmds:      2
		sizeofcmds: cmds_sz
		flags:      0
		reserved:   0
	}

	mut fp := os.open_file(m.out_file, 'w') or {
		panic('macho: cannot open `${m.out_file}`')
	}
	defer { fp.close() }

	write_struct(mut fp, hdr)
	write_struct(mut fp, seg_cmd)
	for s64 in sec64s {
		write_struct(mut fp, s64)
	}
	write_struct(mut fp, symtab_cmd)

	// Section data (with alignment padding between sections).
	mut written := hdr_sz + cmds_sz
	for _, s in m.sections {
		if s.is_zerofill || s.data.len == 0 { continue }
		aligned := align_up(written, s.align_pow)
		pad := int(aligned - written)
		for _ in 0 .. pad { fp.write_u8(0) or {} }
		fp.write(s.data) or { panic('macho: error writing `${s.elf_name}`') }
		written = aligned + u32(s.data.len)
	}

	// Relocation tables.
	for s in m.sections {
		for r in s.relocs {
			mut addr_b := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut addr_b, u32(r.r_address))
			fp.write(addr_b) or {}

			mut info_b := [u8(0), 0, 0, 0]
			info := pack_reloc_info(r.r_symbolnum, r.r_pcrel, r.r_length, r.r_extern, r.r_type)
			binary.little_endian_put_u32(mut info_b, info)
			fp.write(info_b) or {}
		}
	}

	// Symbol table.
	for sym in m.symtab {
		write_struct(mut fp, sym)
	}

	// String table.
	fp.write(m.strtab) or { panic('macho: error writing string table') }
}
