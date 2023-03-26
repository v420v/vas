// I know the code is messy, but it gets the job done for now.
// Leaving this comment here to remind myself to refactor it from scratch
// when I have more time. 

module encoder

import error
import token
import lexer
import encoding.binary
import strconv

pub struct Encoder {
mut:
	tok             token.Token // current token
	lex             lexer.Lexer
pub mut:
	current_section string = '.text'
	instrs          map[string][]&Instr
	rela_text_users []RelaTextUser
	variable_instrs []&Instr // variable length instructions jmp, je, jn ...
	defined_symbols map[string]&Instr
	sections        map[string]&UserDefinedSection
	globals_count   int
}

pub enum InstrKind {
	section
	global
	local
	string
	add
	sub
	imul
	idiv
	lea
	mov
	xor
	cqto
	cmp
	pop
	push
	call
	jmp
	jne
	je
	ret
	syscall
	nop
	hlt
	leave
	label
}

pub struct Instr {
pub mut:
	kind           		InstrKind
	code           		[]u8
	symbol_name    		string
	flags          		string
	addr           		i64
	binding        		u8
	symbol_type    		u8
	section        		string [required]
	index          		int
	varcode        		&VariableCode = unsafe{nil}
	is_len_decided 		bool = true
	is_already_resolved bool
	pos token.Position
}

pub struct RelaTextUser {
pub mut:
	uses   string
	instr  &Instr
	offset i64
	rtype  u64
	adjust int
}

pub struct VariableCode {
pub mut:
	trgt_symbol  string
	rel8_code    []u8
	rel8_offset  i64
	rel32_code   []u8
	rel32_offset i64
}

pub type Expr = Ident | Immediate | Register | Indirection | Number | Binop

pub struct Number {
pub:
	lit string
	pos token.Position
}

pub struct Binop {
pub:
	left_hs Expr
	right_hs Expr
	op token.TokenKind
	pos token.Position
}

pub struct Register {
pub:
	lit string
	pos token.Position
}

pub struct Immediate {
pub:
	expr Expr
	pos token.Position
}

pub struct Indirection {
pub mut:
	disp 			Expr
	base 			Register
	index 			Register
	scale 			Expr
	pos 			token.Position
	has_index_scale bool
}

pub struct Ident {
pub:
	lit string
	pos token.Position
}

pub const (
	elf_shf_write            			 = 0x1
	elf_shf_alloc            			 = 0x2
	elf_shf_execinstr        			 = 0x4
	elf_shf_merge            			 = 0x10
	elf_shf_strings          			 = 0x20
	elf_shf_info_link        			 = 0x40
	elf_shf_link_order       			 = 0x80
	elf_shf_os_nonconforming 			 = 0x100
	elf_shf_group            			 = 0x200
	elf_shf_tls              			 = 0x400

	stb_local            	             = 0
	stb_global           	             = 1

	mod_indirection_with_no_disp = u8(0b00)
	mod_indirection_with_disp8   = u8(0b01)
	mod_indirection_with_disp32  = u8(0b10)
	mod_regi							 = u8(0b11)
	rex_w   							 = u8(0x48)

	r_x86_64_none	   					 = 0
	r_x86_64_64		   					 = 1
	r_x86_64_pc32	   					 = 2
	r_x86_64_got32	   					 = 3
	r_x86_64_plt32	   					 = 4
	r_x86_64_copy	   					 = 5
	r_x86_64_glob_dat  					 = 6
	r_x86_64_jump_slot 					 = 7
	r_x86_64_relative  					 = 8
	r_x86_64_gotpcrel  					 = 9
	r_x86_64_32		   					 = 10
	r_x86_64_32s	   					 = 11
	r_x86_64_16		   					 = 12
	r_x86_64_pc16	   					 = 13
	r_x86_64_8		   					 = 14
	r_x86_64_pc8	   					 = 15
	r_x86_64_pc64	   					 = 24

	stt_notype 			 				 = 0
	stt_object 			 				 = 1
	stt_func 			 				 = 2
	stt_section 		 				 = 3
	stt_file 			 				 = 4
	stt_common 			 				 = 5
	stt_tls 			 				 = 6
	stt_relc 			 				 = 8
	stt_srelc 			 				 = 9
	stt_loos 			 				 = 10
	stt_hios 			 				 = 12
	stt_loproc 			 				 = 13
	stt_hiproc 			 				 = 14
)

pub struct UserDefinedSection {
pub mut:
	code  []u8
	addr  int
	flags int
}

pub fn new(program string, file_name string) &Encoder {
	mut l := lexer.new(file_name, program)

	return &Encoder {
		tok: l.lex()
		lex: l
	}
}

fn (mut e Encoder) next() {
	e.tok = e.lex.lex()
}

fn (mut e Encoder) expect(exp token.TokenKind) {
	if e.tok.kind != exp {
		error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
		exit(1)
	}
	e.next()
}

fn (mut e Encoder) parse_register() Register {
	e.expect(.percent)
	pos := e.tok.pos
	reg_name := e.tok.lit.to_upper()
	if reg_name !in token.registers {
		error.print(e.tok.pos, 'invalid register name')
		exit(1)
	}
	e.next()
	return Register{
		lit: reg_name
		pos: pos
	}
}

fn (mut e Encoder) parse_factor() Expr {
	match e.tok.kind {
		.number {
			lit := e.tok.lit
			e.next()
			return Number{pos: e.tok.pos, lit: lit}
		}
		.ident {
			lit := e.tok.lit
			e.next()
			return Ident{pos: e.tok.pos, lit: lit}
		}
		else {
			error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
    		exit(1)
		}
	}
}

fn (mut e Encoder) parse_expr() Expr {
	expr := e.parse_factor()
	if e.tok.kind in [.plus, .minus] {
		op := e.tok.kind
		pos := e.tok.pos
		e.next()
		right_hs := e.parse_expr()
		return Binop{
			left_hs: expr,
			right_hs: right_hs,
			op: op,
			pos: pos
		}
	}
	return expr
}

fn (mut e Encoder) parse_operand() Expr {
    pos := e.tok.pos
    
    match e.tok.kind {
        .dolor {
            e.next()
            return Immediate{
                expr: e.parse_expr(),
                pos: pos,
            }
        }
        .percent {
            return e.parse_register()
        }
		else {
			expr := e.parse_expr()
			if e.tok.kind != .lpar {
        	    return expr
        	}
			e.next()
			regi := e.parse_register()
			mut indirection := Indirection{
                disp: expr,
                base: regi,
                pos: pos,
            }
			// has index and scale
			if e.tok.kind == .comma {
				indirection.has_index_scale = true
				e.next()
				indirection.index = e.parse_register()
				e.expect(.comma)
				indirection.scale = e.parse_expr()
			}
            e.expect(.rpar)
			return indirection
        }
    }
	error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
	exit(1)
}

fn get_size_by_suffix(name string) int {
	return match name.to_upper()[name.len-1] {
		`Q` {
			64
		}
		`L` {
			32
		} else {
			panic('PANIC')
		}
	}
}

fn regi_size(regi Register) int {
	return if regi.lit[0] == `R` {
		64
	} else if  regi.lit[0] == `E` {
		32
	} else {
		panic('[internal error] somthing whent wrong...')
	}
}

fn check_regi_size(reg Register, size int) {
	reg_size := if reg.lit[0] == `R` {
		64
	} else {
		32
	}
	if reg_size != size {
		error.print(reg.pos, 'invalid operand for instruction')
		exit(0)
	}
}

fn reg_bits(reg Register) u8 {
	match reg.lit {
		'EAX', 'RAX' {
			return 0
		}
		'ECX', 'RCX' {
			return 1
		}
		'EDX', 'RDX' {
			return 2
		}
		'EBX', 'RBX' {
			return 3
		}
		'ESP', 'RSP' {
			return 4
		}
		'EBP', 'RBP' {
			return 5
		}
		'ESI', 'RSI' {
			return 6
		}
		'EDI', 'RDI' {
			return 7
		}
		else {
			error.print(reg.pos, 'invalid operand for instruction')
			exit(1)
		}
	}
}

pub fn align_to(n int, align int) int {
	return (n + align - 1) / align * align
}

fn is_in_i8_range(n int) bool {
	return -128 <= n && n <= 127
}

fn is_in_i32_range(n int) bool {
	return n < (1 << 31)
}

fn compose_mod_rm(mod u8, reg_op u8, rm u8) u8 {
	return (mod << 6) + (reg_op << 3) + rm
}

fn compose_sib(scale u8, index u8, base u8) u8 {
	return (scale<<6) + (index<<3) + base
}

fn eval_expr(expr Expr) int {
	return match expr {
		Number {
			strconv.atoi(expr.lit) or {
                error.print(expr.pos, 'atoi() failed')
                exit(1)
            }
		}
		Binop{
			match expr.op {
				.plus {
					eval_expr(expr.left_hs) + eval_expr(expr.right_hs)
				}
				.minus {
					eval_expr(expr.left_hs) - eval_expr(expr.right_hs)
				} else {
					panic('[internal error] somthing whent wrong...')
				}
			}
		}
		else {
			0
		}
	}
}

fn (mut e Encoder) get_symbol_from_binop(expr Expr, mut arr []string) {
	match expr {
		Binop {
			e.get_symbol_from_binop(expr.left_hs, mut arr)
			e.get_symbol_from_binop(expr.right_hs, mut arr)
		}
		Ident {
			arr << expr.lit
		}
		else {
		}
	}
}

fn scale(n u8) u8 {
	match n {
		1 {
			return 0
		}
		2 {
			return 1
		}
		4 {
			return 2
		}
		8 {
			return 3
		} else {
			panic('unreachable')
		}
	}
}

fn (mut e Encoder) encode_indir_regi(op_code []u8, indir Indirection, regi Register, mut instr &Instr, size int) {
	check_regi_size(regi, size)

	disp := eval_expr(indir.disp)
	base_is_ip := indir.base.lit in ['RIP', 'EIP']
	base_is_sp := indir.base.lit in ['RSP', 'ESP']
	base_is_bp := indir.base.lit in ['RBP', 'EBP']

	mut used_symbols := []string{}
	e.get_symbol_from_binop(indir.disp, mut &used_symbols)
	if used_symbols.len >= 2 {
		error.print(indir.disp.pos, 'invalid operand for instruction')
		exit(1)
	}

	need_rela := used_symbols.len == 1
	mut mod_rm := u8(0)

	if indir.has_index_scale {
		if base_is_ip {
			error.print(indir.index.pos, '%$indir.base.lit.to_lower() as base register can not have an index register')
			exit(1)
		}

		if regi_size(indir.base) != regi_size(indir.index) {
			base_regi_size := regi_size(indir.base)
			error.print(indir.base.pos, 'base register is $base_regi_size-bit, but index register is not')
			exit(1)
		}

		if need_rela {
			mod_rm = compose_mod_rm(mod_indirection_with_disp32, reg_bits(regi), 0b100)
		} else if disp == 0 && !base_is_bp {
			mod_rm = compose_mod_rm(mod_indirection_with_no_disp, reg_bits(regi), 0b100)
		} else if is_in_i8_range(disp) {
			mod_rm = compose_mod_rm(mod_indirection_with_disp8, reg_bits(regi), 0b100)
		} else if is_in_i32_range(disp) {
			mod_rm = compose_mod_rm(mod_indirection_with_disp32, reg_bits(regi), 0b100)
		} else {
			panic('disp out range!')
		}
	} else {
		if base_is_ip {
			mod_rm = compose_mod_rm(mod_indirection_with_no_disp, reg_bits(regi), 0b101) // rip relative
		} else if need_rela {
			mod_rm = compose_sib(mod_indirection_with_disp32, reg_bits(regi), reg_bits(indir.base))
		} else if disp == 0 && !base_is_bp {
			mod_rm = compose_mod_rm(mod_indirection_with_no_disp, reg_bits(regi), reg_bits(indir.base))
		} else if is_in_i8_range(disp) {
			mod_rm = compose_sib(mod_indirection_with_disp8, reg_bits(regi), reg_bits(indir.base))
		} else if is_in_i32_range(disp) {
			mod_rm = compose_sib(mod_indirection_with_disp32, reg_bits(regi), reg_bits(indir.base))
		} else {
			panic('disp out range!')
		}
	}

	if regi_size(indir.base) == 32 {
		instr.code << 0x67
	}

	if size == 64 {
		instr.code << encoder.rex_w
	}

	instr.code << op_code
	instr.code << mod_rm

	if indir.has_index_scale {
		scale_num := u8(eval_expr(indir.scale))
		if scale_num !in [1, 2, 4, 8] {
			error.print(indir.scale.pos, 'scale factor in address must be 1, 2, 4 or 8')
			exit(0)
		}
		sib := reg_bits(indir.base) + (reg_bits(indir.index) << 3) + (scale(scale_num) << 6)
		instr.code << sib
	}

	if base_is_sp && !indir.has_index_scale {
		instr.code << 0x24
	}

	instr_code_len := instr.code.len

	if need_rela {
		rtype := if base_is_ip {
			encoder.r_x86_64_pc32
		} else {
			encoder.r_x86_64_32s
		}
		rela_text_user := encoder.RelaTextUser{
			instr:  unsafe {instr},
			uses:   used_symbols[0],
			offset: instr_code_len
			rtype:  u64(rtype)
			adjust: eval_expr(indir.disp)
		}
		instr.code << [u8(0), 0, 0, 0]
		e.rela_text_users << rela_text_user
	} else {
		if disp != 0 || base_is_ip || base_is_bp {
			if base_is_ip {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(disp))
				instr.code << hex
			} else if is_in_i8_range(disp) {
				instr.code << u8(disp)
			} else if is_in_i32_range(disp) {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(disp))
				instr.code << hex
			} else {
				panic('disp out range!')
			}
		}
	}
}

fn (mut e Encoder) encode_imm_regi(slash u8, rax_magic u8, imm Immediate, regi Register, mut instr &Instr, size int) {
	num := eval_expr(imm.expr)
	check_regi_size(regi, size)

	mod_rm := compose_mod_rm(mod_regi, slash, reg_bits(regi))

	if size == 64 {
		instr.code << encoder.rex_w
	}

	if is_in_i8_range(num) {
		instr.code << [u8(0x83), mod_rm, u8(num)]
	} else if is_in_i32_range(num) {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(num))
		if regi.lit in ['RAX', 'EAX'] {
			instr.code << [rax_magic, hex[0], hex[1], hex[2], hex[3]]
		} else {
			instr.code << [u8(0x81), mod_rm, hex[0], hex[1], hex[2], hex[3]]
		}
	}
}

fn (mut e Encoder) encode_regi_regi(op_code []u8, regi Register, regi2 Register, mut instr &Instr, size int) {
	check_regi_size(regi, size)
	check_regi_size(regi2, size)
	mod_rm := compose_mod_rm(mod_regi, reg_bits(regi), reg_bits(regi2))
	if size == 64 {
   		instr.code << encoder.rex_w
	}
	instr.code << op_code
	instr.code << mod_rm
}

fn (mut e Encoder) encode_instr() {
	pos := e.tok.pos
	mut instr := Instr{pos: pos, section: e.current_section}

	instr_name := e.tok.lit
	e.next()

	defer {
		e.instrs[e.current_section] << &instr
		if instr.varcode != unsafe { nil } {
			instr.is_len_decided = false
		}
	}

	if e.tok.kind == .colon {
		instr.kind = .label
		instr.symbol_name = instr_name
		e.expect(.colon)

		if instr_name in e.defined_symbols || instr_name == '.text' {
			error.print(pos, 'symbol `$instr_name` is already defined')
			exit(1)
		}
		e.defined_symbols[instr_name] = &instr
		return
	}

	match instr_name.to_upper() {
		'.SECTION' {
			instr.kind = .section
			name := e.tok.lit

			e.current_section = name
			instr.section = e.current_section

			e.next()
			e.expect(.comma)
			instr.section = name
			instr.flags = e.tok.lit
			e.expect(.string)
			instr.symbol_type = encoder.stt_section

			if s := e.defined_symbols[name] {
				if s.kind == .label {
					error.print(pos, 'symbol `$name` is already defined')
					exit(1)
				}
			} else {
				e.defined_symbols[name] = &instr
			}
			return
		}
		'RETQ', 'RET' {
			instr.kind = .ret
			instr.code = [u8(0xc3)]
			return
		}
		'SYSCALL' {
			instr.kind = .syscall
			instr.code = [u8(0x0f), 0x05]
			return
		}
		'NOPQ', 'NOP' {
			instr.kind = .nop
			instr.code = [u8(0x90)]
			return
		}
		'HLT' {
			instr.kind = .hlt
			instr.code = [u8(0xf4)]
			return
		}
		'LEAVE' {
			instr.kind = .leave
			instr.code = [u8(0xc9)]
			return
		}
		'CQTO' {
			instr.kind = .cqto
			instr.code = [u8(0x48), 0x99]
			return
		}
		'.GLOBAL' {
			instr.kind = .global
			instr.symbol_name = e.tok.lit
			e.next()
			return
		}
		'.LOCAL' {
			instr.kind = .local
			instr.symbol_name = e.tok.lit
			e.next()
			return
		}
		'.STRING' {
			value := e.tok.lit
			e.expect(.string)

			instr.kind = .string

			instr.code = value.bytes()
			instr.code << 0x00
			return
		}
		'POP', 'POPQ' {
			instr.kind = .pop

			source := e.parse_operand()

			if source is Register {
				check_regi_size(source, 64)
				instr.code = [0x58 + reg_bits(source)]
				return
			}
		}
		'PUSHQ', 'PUSH' {
			instr.kind = .push

			source := e.parse_operand()

			if source is Register {
				check_regi_size(source, 64)
				instr.code = [0x50 + reg_bits(source)]
				return
			}
			if source is Immediate {
				num := eval_expr(source.expr)
				if is_in_i8_range(num) {
					instr.code = [u8(0x6a), u8(num)]
				} else if is_in_i32_range(num) {
					mut hex := [u8(0), 0, 0, 0]
					binary.little_endian_put_u32(mut &hex, u32(num))
					instr.code = [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
				} else {
					panic('internal error')
				}
				return
			}
		}
		'MOVQ', 'MOVL' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .mov

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register && desti is Register {
				e.encode_regi_regi([u8(0x89)], source, desti, mut &instr, size)
				return
			}
			if source is Indirection && desti is Register {
				e.encode_indir_regi([u8(0x8b)], source, desti, mut &instr, size)
				return
			}
			if source is Register && desti is Indirection {
				e.encode_indir_regi([u8(0x89)], desti, source, mut &instr, size)
				return
			}
			if source is Immediate && desti is Register {
				check_regi_size(desti, size)
				mut mod_rm := u8(0)
				if size == 64 {
					instr.code << [encoder.rex_w, 0xc7]
					mod_rm = 0xc0 + reg_bits(desti)
				} else if size == 32 {
					mod_rm = 0xB8 + reg_bits(desti)
				}
				num := eval_expr(source.expr)
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(num))
				instr.code << [mod_rm, hex[0], hex[1], hex[2], hex[3]]
				return
			}
		}
		'LEAQ', 'LEAL' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .lea

			source := e.parse_operand()
			e.expect(.comma)
			destination := e.parse_operand()

			if source is Indirection && destination is Register {
				e.encode_indir_regi([u8(0x8d)], source, destination, mut &instr, size)
				return
			}
		}
		'ADDQ', 'ADDL' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .add

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register && desti is Register {
				e.encode_regi_regi([u8(0x01)], source, desti, mut &instr, size)
				return
			}
			if source is Immediate && desti is Register {
				e.encode_imm_regi(0, 0x05, source, desti, mut instr, size)
				return
			}
			if source is Indirection && desti is Register {
				e.encode_indir_regi([u8(0x3)], source, desti, mut &instr, size)
				return
			}
			if source is Register && desti is Indirection {
				e.encode_indir_regi([u8(0x1)], desti, source, mut &instr, size)
				return
			}	
		}
		'SUBQ', 'SUBL' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .sub

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register && desti is Register {
				e.encode_regi_regi([u8(0x29)], source, desti, mut &instr, size)
				return
			}
			if source is Immediate && desti is Register {
				e.encode_imm_regi(5, 0x2D, source, desti, mut instr, size)
				return
			}
			if source is Indirection && desti is Register {
				e.encode_indir_regi([u8(0x2b)], source, desti, mut &instr, size)
				return
			}
			if source is Register && desti is Indirection {
				e.encode_indir_regi([u8(0x29)], desti, source, mut &instr, size)
				return
			}
		}
		'IDIVQ', 'IDIVL' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .idiv
			source := e.parse_operand()
			if source is Register {
				if size == 64 {
					instr.code = [encoder.rex_w]
				}
				check_regi_size(source, size)
				instr.code << [u8(0xf7), 0xf8 + reg_bits(source)]
				return
			}
		}
		'IMULQ', 'IMULL' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .imul

			source := e.parse_operand()

			if e.tok.kind != .comma && source is Register {
				if size == 64 {
					instr.code = [encoder.rex_w]
				}
				check_regi_size(source, size)
				instr.code << [u8(0xf7), 0xe8 + reg_bits(source)]
				return
			}
			
			e.expect(.comma)
			desti_operand_1 := e.parse_operand()

			if source is Indirection && desti_operand_1 is Register {
				e.encode_indir_regi([u8(0x0f), 0xaf], source, desti_operand_1, mut &instr, size)
				return
			}
			
			if source is Register && desti_operand_1 is Register {
				e.encode_regi_regi([u8(0x0f), 0xaf], source, desti_operand_1, mut &instr, size)
				return
			}

			e.expect(.comma)
			desti_operand_2 := e.parse_operand()

			if source is Immediate && desti_operand_1 is Register && desti_operand_2 is Register {
				check_regi_size(desti_operand_1, size)
				check_regi_size(desti_operand_2, size)
				mod_rm := compose_mod_rm(mod_regi, reg_bits(desti_operand_2), reg_bits(desti_operand_1))
				if size == 64 {
					instr.code << encoder.rex_w
				}
				num := eval_expr(source.expr)
				if is_in_i8_range(num) {
					instr.code << 0x6b
					instr.code << mod_rm
					instr.code << u8(num)
				} else {
					instr.code << 0x69
					instr.code << mod_rm
					mut hex := [u8(0), 0, 0, 0]
					binary.little_endian_put_u32(mut &hex, u32(num))
					instr.code << hex
				}
				return
			}
		}
		'XORQ', 'XORL' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .xor

			source := e.parse_operand()
			e.expect(.comma)
			destination := e.parse_operand()

			if source is Register && destination is Register {
				e.encode_regi_regi([u8(0x31)], source, destination, mut &instr, size)
				return
			}
			
			if source is Immediate && destination is Register {
				e.encode_imm_regi(6, 0x35, source, destination, mut instr, size)
				return
			}
		}
		'CMPQ', 'CMPL' {
			size := get_size_by_suffix(instr_name)
			instr.kind = .cmp

			source := e.parse_operand()
			e.expect(.comma)
			destination := e.parse_operand()

			if source is Register && destination is Register {
				e.encode_regi_regi([u8(0x39)], source, destination, mut &instr, size)
				return
			}
			
			if source is Immediate && destination is Register {
				e.encode_imm_regi(7, 0x3D, source, destination, mut instr, size)
				return
			}
		}
		'CALLQ', 'CALL' {
			instr.kind = .call
			instr.code = [u8(0xe8), 0, 0, 0, 0]

			source := e.parse_operand()
			adjust := eval_expr(source)

			mut used_symbols := []string{}
			e.get_symbol_from_binop(source, mut &used_symbols)
			if used_symbols.len >= 2 || used_symbols.len == 0 {
				error.print(source.pos, 'invalid operand for instruction')
				exit(1)
			}

			e.rela_text_users << encoder.RelaTextUser{
				instr:  &instr,
				offset: 1,
				uses:   used_symbols[0],
				adjust: adjust,
				rtype:   encoder.r_x86_64_plt32
			}
			return
		}
		'JMP', 'JMPQ' {
			instr.kind = .jmp

			destination := e.parse_operand()

			target_sym_name := match destination {
				Ident {
					destination.lit
				} else {
					error.print(pos, 'invalid operand for instruction')
					exit(1)
				}
			}

			instr.varcode = &VariableCode{
				trgt_symbol: target_sym_name,
				rel8_code:   [u8(0xeb), 0],
				rel8_offset: 1,
				rel32_code:   [u8(0xe9), 0, 0, 0, 0],
				rel32_offset: 1,
			}

			e.variable_instrs << &instr
			return
		}
		'JNE' {
			instr.kind = .jne
			destination := e.parse_operand()

			target_sym_name := match destination {
				Ident {
					destination.lit
				} else {
					error.print(pos, 'invalid operand for instruction')
					exit(1)
				}
			}

			instr.varcode = &VariableCode{
				trgt_symbol: target_sym_name,
				rel8_code:   [u8(0x75), 0],
				rel8_offset: 1,
				rel32_code:   [u8(0x0f), 0x85, 0, 0, 0, 0],
				rel32_offset: 2,
			}

			e.variable_instrs << &instr
			return
		}
		'JE' {
			instr.kind = .je
			destination := e.parse_operand()

			target_sym_name := match destination {
				Ident {
					destination.lit
				} else {
					error.print(pos, 'invalid operand for instruction')
					exit(1)
				}
			}

			instr.varcode =  &VariableCode{
				trgt_symbol: target_sym_name,
				rel8_code:   [u8(0x74), 0],
				rel8_offset: 1,
				rel32_code:   [u8(0x0f), 0x84, 0, 0, 0, 0],
				rel32_offset: 2,
			}

			e.variable_instrs << &instr
			return
		}
		else {
			error.print(pos, 'unkwoun instruction `$instr_name`')
			exit(1)
		}
	}
	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

pub fn (mut e Encoder) encode() {
	for e.tok.kind != .eof {
		if e.tok.kind == .eol {
			e.next()
		} else {
			e.encode_instr()
		}
	}
}

