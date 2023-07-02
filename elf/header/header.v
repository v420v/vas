// elf.h

module header

pub struct Elf64_Ehdr {
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

pub struct Elf64_Sym {
	st_name  u32
	st_info  u8
	st_other u8
	st_shndx u16
	st_value voidptr
	st_size  u64
}

pub struct Elf64_Shdr {
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

pub const (
    stb_local            = 0
    stb_global           = 1
	//-------------------------------
    stt_notype           = 0
    stt_object           = 1
    stt_func             = 2
    stt_section          = 3
    stt_file             = 4
    stt_common           = 5
    stt_tls              = 6
    stt_relc             = 8
    stt_srelc            = 9
    stt_loos             = 10
    stt_hios             = 12
    stt_loproc           = 13
    stt_hiproc           = 14
	//-------------------------------
    sht_null             = 0
    sht_progbits         = 1
    sht_symtab           = 2
    sht_strtab           = 3
    sht_rela             = 4
	//-------------------------------
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
	//-------------------------------
	r_x86_64_none	  	 = u64(0)
	r_x86_64_64		  	 = u64(1)
	r_x86_64_pc32	  	 = u64(2)
	r_x86_64_got32	  	 = u64(3)
	r_x86_64_plt32	  	 = u64(4)
	r_x86_64_copy	  	 = u64(5)
	r_x86_64_glob_dat 	 = u64(6)
	r_x86_64_jump_slot	 = u64(7)
	r_x86_64_relative 	 = u64(8)
	r_x86_64_gotpcrel 	 = u64(9)
	r_x86_64_32		  	 = u64(10)
	r_x86_64_32s	  	 = u64(11)
	r_x86_64_16		  	 = u64(12)
	r_x86_64_pc16	  	 = u64(13)
	r_x86_64_8		  	 = u64(14)
	r_x86_64_pc8	  	 = u64(15)
	r_x86_64_pc64	  	 = u64(24)
	//-------------------------------
	stv_default			 = 0
	stv_internal		 = 1
	stv_hidden			 = 2
	stv_protected		 = 3
)

