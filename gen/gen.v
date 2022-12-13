module gen

import ast
import os
import encoding.binary
import strconv

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

const stb_local = 0
const stb_global = 1

const stt_notype = 0
const stt_section = 3

const sht_null = 0
const sht_progbits = 1
const sht_symtab = 2
const sht_strtab = 3

const shf_alloc = 0x2
const shf_execinstr = 0x4

pub fn (mut g Gen) gen_elf() {
	rodata := [16]u8{}

	// strtab size 16bytes
	strtab := [
		u8(0x00),

		// _start\0
		0x5f, 0x73, 0x74, 0x61, 0x72, 0x74, 0x00,

		// foo\0
		//0x66, 0x6f, 0x6f, 0x00,

		// padding
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	]!

	null_nameofs := 0
	start_nameofs := null_nameofs + ''.len + 1
	//foo_nameofs := start_nameofs + '_start'.len + 1

	symtab := [
		Elf64_Sym{
			st_name: u32(null_nameofs)
			st_info: ((stb_local << 4) + (stt_notype & 0xf))
		},
		// Section .rodata
		Elf64_Sym{
			st_name: u32(null_nameofs)
			st_info: ((stb_local << 4) + (stt_section & 0xf))
			st_shndx: 2
		},
		// _start
		Elf64_Sym{
			st_name: u32(start_nameofs)
			st_info: ((stb_global << 4) + (stt_notype & 0xf))
			st_shndx: 1
			st_value: 0
		},
		// foo
		//Elf64_Sym{
		//	st_name: u32(foo_nameofs)
		//	st_info: ((stb_global << 4) + (stt_notype & 0xf))
		//	st_shndx: 1
		//	st_value: 0x14
		//},
	]!

	// size 64 bytes
	shstrtab := [
		u8(0x00),

		// .text\0
		0x2e, 0x74, 0x65, 0x78, 0x74, 0x00,

		// .rodata\0
		0x2e, 0x72, 0x6f, 0x64, 0x61, 0x74, 0x61, 0x00,

		// .strtab\0
		0x2e, 0x73, 0x74, 0x72, 0x74, 0x61, 0x62, 0x00,

		// .symtab\0
		0x2e, 0x73, 0x79, 0x6d, 0x74, 0x61, 0x62, 0x00,

		// .shstrtab\0
		0x2e, 0x73, 0x68, 0x73, 0x74, 0x72, 0x74, 0x61, 0x62, 0x00,

		// padding
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	]!

	text_nameofs := null_nameofs + ''.len + 1
	rodata_nameofs := text_nameofs + '.text'.len + 1
	strtab_nameofs := rodata_nameofs + '.rodata'.len + 1
	symtab_nameofs := strtab_nameofs + '.strtab'.len + 1
	shstrtab_nameofs := symtab_nameofs + '.symtab'.len + 1

	code_ofs := sizeof(Elf64_Ehdr)
	code_size := u32(g.code.len)

	rodata_ofs := code_ofs + code_size
	rodata_size := sizeof(rodata)

	strtab_ofs := rodata_ofs + rodata_size
	strtab_size := sizeof(strtab)

	symtab_ofs := strtab_ofs + strtab_size
	symtab_size := sizeof(symtab)

	shstrtab_ofs := symtab_ofs + symtab_size
	shstrtab_size := sizeof(shstrtab)

	sectionheader_ofs := shstrtab_ofs + shstrtab_size

	section_headers := [
		// NULL
		Elf64_Shdr{
			sh_name: u32(null_nameofs)
			sh_type: sht_null
		},
		// .text
		Elf64_Shdr{
			sh_name: u32(text_nameofs)
			sh_type: sht_progbits
			sh_flags: shf_alloc | shf_execinstr
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
			sh_type: sht_progbits
			sh_flags: shf_alloc
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
			sh_type: sht_strtab
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
			sh_type: sht_symtab
			sh_flags: 0
			sh_addr: 0
			sh_offset: symtab_ofs
			sh_size: symtab_size
			sh_link: 3 // section number of .strtab
			sh_info: 2 // Number of local symbols
			sh_addralign: 8
			sh_entsize: sizeof(Elf64_Sym)
		},
		// .shstrtab
		Elf64_Shdr{
			sh_name: u32(shstrtab_nameofs)
			sh_type: sht_strtab
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

	mut fp := os.open_file(g.out_file, 'w') or {
		panic('error opening file `$g.out_file`')
	}

	os.truncate(g.out_file, 0) or {
		panic('error truncate file `$g.out_file`')
	}

	fp.write_struct(ehdr) or {
		panic('error writing `Elf64_Ehdr`')
	}

	fp.write(g.code) or {
		panic('error writing `code`')
	}

	fp.write_raw(rodata) or {
		panic('error writing `.rodata`')
	}

	fp.write_raw(strtab) or {
		panic('error writing `.strtab`')
	}

	for _, s in symtab {
		fp.write_struct(s) or {
			panic('error writing `.symtab`')
		}
	}

	fp.write_raw(shstrtab) or {
		panic('error writing `.shstrtab`')
	}

	for _, sh in section_headers {
		fp.write_struct(sh) or {
			panic('error writing `Elf64_Shdr`')
		}
	}
}

struct Gen {
	out_file string
	mut:
		code []u8 // program
}

pub fn new(out_file string) &Gen {
	return &Gen {
		out_file: out_file,
		code: []u8{}
	}
}

const reg_32 = {
	'eax' : 0
	'ecx' : 1
	'edx' : 2
	'ebx' : 3
	'esp' : 4
	'ebp' : 5
	'esi' : 6
	'edi' : 7
}

const reg_64 = {
	'rax' : 0
	'rcx' : 1
	'rdx' : 2
	'rbx' : 3
	'rsp' : 4
	'rbp' : 5
	'rsi' : 6
	'rdi' : 7
}

fn align_to(n int, align int) int {
	return (n + align - 1) / align * align
}

fn calc_rm(dest string, src string) u8 {
	mut d_n := -1
	mut s_n := -1

	if dest in reg_64 {
		d_n = reg_64[dest]
		s_n = reg_64[src]
	}
	
	if dest in reg_32 {
		d_n = reg_32[dest]
		s_n = reg_32[src]
	}

	if d_n < 0 || s_n < 0 {
		panic('failed to lookup registers: $dest, $src')
	}

	out := 0xc0 + (8 * s_n) + d_n

	if out > 255 {
		panic("calc_rm received out of bounds value")
	}

	return u8(out)
}

fn (mut g Gen) gen_mov(op ast.Op) {
	if op.left is ast.RegExpr && op.right is ast.RegExpr {
		left := op.left as ast.RegExpr
		right := op.right as ast.RegExpr
		if left.bit != right.bit {
			eprintln('$right.pos.file_name:$right.pos.line:$right.pos.col: error: invalid combination of operands')
			exit(1)
		}

		if left.bit == 32 {
			g.code << [u8(0x89), u8(calc_rm(left.lit, right.lit))]
		} else {
			g.code << [u8(0x48), u8(0x89), u8(calc_rm(left.lit, right.lit))]
		}
	} else {
		match op.left {
			ast.RegExpr {
				if op.left.bit == 32 {
					g.code << u8(0xb8 + reg_32[op.left.lit])
				} else {
					g.code << [u8(0x48), u8(0xc7), u8(0xc0 + reg_64[op.left.lit])]
				}
			} else {
				eprintln('$op.left.pos.file_name:$op.left.pos.line:$op.left.pos.col: error: expected register')
				exit(1)
			}
		}

		match op.right {
			ast.IntExpr {
				num := strconv.atoi(op.right.lit) or {
					eprintln('$op.right.pos.file_name:$op.right.pos.line:$op.right.pos.col: error: invalid integer')
					exit(1)
				}

				mut buf := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &buf, u32(num))

				g.code << buf
			}  else {
				eprintln('$op.right.pos.file_name:$op.right.pos.line:$op.right.pos.col: error: unexpected value')
				exit(1)
			}
		}
	}
}

pub fn (mut g Gen) gen(ops []ast.Op) {
	for _, op in ops {
		match op.kind {
			.mov {
				g.gen_mov(op)
			}
			.nop {
				g.code << 0x90
			}
			.syscall {
				g.code << [ u8(0x0f), 0x05 ]
			}
		}
	}

	padding := (align_to(g.code.len, 32) - g.code.len)
	for _ in 0 .. padding {
		g.code << 0
	}
}

