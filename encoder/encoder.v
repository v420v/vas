module encoder

import error
import token
import lexer
import strconv
import encoding.binary

pub enum InstrKind {
	section
	global
	local
	string
	byte
	word
	long
	quad
	add
	sub
	imul
	idiv
	div
	neg
	lea
	mov
	movzx
	movsx
	xor
	and
	not
	cqto
	cmp
	shl
	shr
	pop
	push
	call
	setl
	setg
	setle
	setge
	sete
	setne
	jmp
	jne
	je
	jl
	jg
	jle
	jge
	ret
	syscall
	nop
	hlt
	leave
	label
}

pub struct Encoder {
mut:
	tok					token.Token			// current token
	l  					lexer.Lexer			// lexer
pub mut:
	current_section		string
	instrs         		map[string][]&Instr // map with section name as keys and instruction list as value
	rela_text_users		[]RelaTextUser
	variable_instrs		[]&Instr			// variable length instructions jmp, je, jn ...
	defined_symbols		map[string]&Instr   // labels, sections...
	sections       		map[string]&UserDefinedSection
	globals_count  		int					// global symbols
	local_labels_count	int					// symbols that start with `.L`
}

pub struct Instr {
pub mut:
	kind           		InstrKind [required]
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
	pos token.Position [required]
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

pub type Expr = Ident | Immediate | Register | Indirection | Number | Binop | Neg

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

pub struct Neg {
pub:
	expr Expr
	pos token.Position
}

pub struct Register {
pub:
	lit string
	size int
	pos token.Position
}

pub struct Immediate {
pub:
	expr 	Expr
	pos		token.Position
}

pub struct Indirection {
pub mut:
	disp 			Expr
	base 			Register
	index 			Register
	scale 			Expr
	pos 			token.Position
	has_base        bool
	has_index_scale bool
}

pub struct Ident {
pub:
	lit string
	pos token.Position
}

pub struct UserDefinedSection {
pub mut:
	code  []u8
	addr  int
	flags int
}

pub const (
	// suffix
	suffix_byte						= 8
	suffix_word						= 16
	suffix_long						= 32
	suffix_quad						= 64

	mod_indirection_with_no_disp	= u8(0)
	mod_indirection_with_disp8  	= u8(1)
	mod_indirection_with_disp32 	= u8(2)
	mod_regi						= u8(3)
	rex_w   						= u8(0x48)
	operand_size_prefix16           = u8(0x66)
	slash_0							= 0 // /0
	slash_1							= 1 // /1
	slash_2							= 2 // /2
	slash_3							= 3 // /3
	slash_4							= 4 // /4
	slash_5							= 5 // /5
	slash_6							= 6 // /6
	slash_7							= 7 // /7

	// section
	elf_shf_write            		= 0x1
	elf_shf_alloc            		= 0x2
	elf_shf_execinstr        		= 0x4
	elf_shf_merge            		= 0x10
	elf_shf_strings          		= 0x20
	elf_shf_info_link        		= 0x40
	elf_shf_link_order       		= 0x80
	elf_shf_os_nonconforming 		= 0x100
	elf_shf_group            		= 0x200
	elf_shf_tls              		= 0x400

	//  rela rtype
	r_x86_64_none	   				= u64(0)
	r_x86_64_64		   				= u64(1)
	r_x86_64_pc32	   				= u64(2)
	r_x86_64_got32	   				= u64(3)
	r_x86_64_plt32	   				= u64(4)
	r_x86_64_copy	   				= u64(5)
	r_x86_64_glob_dat  				= u64(6)
	r_x86_64_jump_slot 				= u64(7)
	r_x86_64_relative  				= u64(8)
	r_x86_64_gotpcrel  				= u64(9)
	r_x86_64_32		   				= u64(10)
	r_x86_64_32s	   				= u64(11)
	r_x86_64_16		   				= u64(12)
	r_x86_64_pc16	   				= u64(13)
	r_x86_64_8		   				= u64(14)
	r_x86_64_pc8	   				= u64(15)
	r_x86_64_pc64	   				= u64(24)

	// symbol
	stb_local            	        = 0
	stb_global           	        = 1

	stt_notype 			 			= 0
	stt_object 			 			= 1
	stt_func 			 			= 2
	stt_section 		 			= 3
	stt_file 			 			= 4
	stt_common 			 			= 5
	stt_tls 			 			= 6
	stt_relc 			 			= 8
	stt_srelc 			 			= 9
	stt_loos 			 			= 10
	stt_hios 			 			= 12
	stt_loproc 			 			= 13
	stt_hiproc 			 			= 14
)

pub fn new(mut l lexer.Lexer, file_name string) &Encoder {
	tok := l.lex()
	default_text_section := Instr{kind: .section, pos: tok.pos, section: '.text', symbol_type: encoder.stt_section, flags: 'ax'}
	e := &Encoder {
		tok: tok
		l: l
		current_section: '.text'
		defined_symbols: {'.text': &default_text_section}
		instrs: {'.text': [&default_text_section]}
	}
	return e
}

fn (mut e Encoder) next() {
	e.tok = e.l.lex()
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
		error.print(e.tok.pos, 'invalid register name `$reg_name`')
		exit(1)
	}

	size := regi_size(reg_name)

	e.next()
	return Register{
		lit: reg_name
		size: size
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
		.minus {
			e.next()
			expr := e.parse_factor()
			return Neg{pos: e.tok.pos, expr: expr}
		}
		else {
			error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
    		exit(1)
		}
	}
}

fn (mut e Encoder) parse_expr() Expr {
	expr := e.parse_factor()
	if e.tok.kind in [.plus, .minus, .mul, .div] {
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
			// parse indirect
			expr := if e.tok.kind == .lpar {
				Expr(Number{lit: '0', pos: pos})
			} else {
				e.parse_expr()
			}
			if e.tok.kind != .lpar {
        	    return expr
        	}
			e.next()
			mut indirection := Indirection{
                disp: expr,
                pos: pos,
            }
			if e.tok.kind == .comma {
				indirection.has_base = false
			} else {
				indirection.has_base = true
				indirection.base = e.parse_register()
			}
			// has index and scale
			if e.tok.kind == .comma {
				indirection.has_index_scale = true
				e.next()
				indirection.index = e.parse_register()
				indirection.scale = if e.tok.kind == .comma {
					e.expect(.comma)
					e.parse_expr()
				} else {
					Expr(Number{lit: '1', pos: pos})
				}
			}
            e.expect(.rpar)
			return indirection
        }
    }
	error.print(e.tok.pos, 'unexpected token `${e.tok.lit}`')
	exit(1)
}

fn regi_size(name string) int {
	if name in ['AL', 'CL', 'DL', 'BL', 'AH', 'cH', 'DH', 'BH'] {
		return 8
	} else if name in ['AX', 'CX', 'DX', 'BX', 'SP', 'BP', 'SI', 'DI'] {
		return 16
	} else {
		if name[0] == `R` {
			return 64
		} else if name[0] == `E` {
			return 32
		}
	}
	panic('unreachable')
}

fn regi_bits(regi Register) u8 {
	match regi.lit[regi.lit.len-2..] {
		'AX', 'AL' {
			return 0
		}
		'CX', 'CL' {
			return 1
		}
		'DX', 'DL' {
			return 2
		}
		'BX', 'BL' {
			return 3
		}
		'SP', 'AH' {
			return 4
		}
		'BP', 'CH' {
			return 5
		}
		'SI', 'DH' {
			return 6
		}
		'DI', 'BH' {
			return 7
		}
		else {
			error.print(regi.pos, 'invalid operand for instruction')
			exit(1)
		}
	}
}

fn eval_expr(expr Expr) int {
	return match expr {
		Number {
			int(strconv.parse_int(expr.lit, 0, 64) or {
                error.print(expr.pos, 'invalid number `expr.lit`')
                exit(1)
            })
		}
		Binop{
			match expr.op {
				.plus {
					eval_expr(expr.left_hs) + eval_expr(expr.right_hs)
				}
				.minus {
					eval_expr(expr.left_hs) - eval_expr(expr.right_hs)
				}
				.mul {
					eval_expr(expr.left_hs) * eval_expr(expr.right_hs)
				}
				.div {
					eval_expr(expr.left_hs) / eval_expr(expr.right_hs)
				} else {
					panic('[internal error] somthing whent wrong...')
				}
			}
		}
		Neg {
			eval_expr(expr.expr) * -1
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
		Neg {
			e.get_symbol_from_binop(expr.expr, mut arr)
		}
		Ident {
			arr << expr.lit
		}
		else {
		}
	}
}

fn get_size_by_suffix(name string) int {
	return match name.to_upper()[name.len-1] {
		`Q` {
			encoder.suffix_quad
		}
		`L` {
			encoder.suffix_long
		}
		`W` {
			encoder.suffix_word
		}
		`B` {
			encoder.suffix_byte
		} else {
			panic('unkown size')
		}
	}
}

fn (regi Register) check_regi_size(size int) {
	if regi.size != size {
		error.print(regi.pos, 'invalid size of register for instruction.')
		exit(0)
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
			panic('scale unreachable')
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

fn add_prefix_byte(size int) []u8 {
	if size == encoder.suffix_quad {
		return [encoder.rex_w]
	} else if size == encoder.suffix_word {
		return [operand_size_prefix16]
	}
	return []
}

fn encode_imm_value(imm_val int, size int) []u8 {
	if is_in_i8_range(imm_val) || size == suffix_byte {
		return [u8(imm_val)]
	} else if size == suffix_word {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(imm_val))
		return hex
	} else if is_in_i32_range(imm_val) {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(imm_val))
		return hex
	} else {
		panic('unreachable')
	}
}

fn (mut e Encoder) var_instr(kind InstrKind, rel8_code []u8, rel8_offset i64, rel32_code []u8, rel32_offset i64) {
	desti := e.parse_operand()

	target_sym_name := match desti {
		Ident {
			desti.lit
		} else {
			error.print(desti.pos, 'invalid operand for instruction')
			exit(1)
		}
	}

	instr := Instr{
		kind: kind,
		varcode: &VariableCode{
			trgt_symbol: target_sym_name,
			rel8_code:   rel8_code,
			rel8_offset: rel8_offset,
			rel32_code:   rel32_code,
			rel32_offset: rel32_offset,
		},
		is_len_decided: false,
		pos: desti.pos,
		section: e.current_section,
	}

	e.variable_instrs << &instr
	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) encode_instr() {
	pos := e.tok.pos

	instr_name := e.tok.lit
	instr_name_upper := instr_name.to_upper()
	e.next()

	if e.tok.kind == .colon {
		instr := Instr{kind: .label, pos: pos, section: e.current_section, symbol_name: instr_name}
		e.expect(.colon)

		if instr_name in e.defined_symbols || instr_name == '.text' {
			error.print(pos, 'symbol `$instr_name` is already defined')
			exit(1)
		}
		e.defined_symbols[instr_name] = &instr
		e.instrs[e.current_section] << &instr
		return
	}

	match instr_name_upper {
		'.SECTION' {
			e.section()
		}
		'.GLOBAL' {
			instr := Instr{kind: .global, pos: pos, section: e.current_section, symbol_name: e.tok.lit}
			e.next()
			e.instrs[e.current_section] << &instr
		}
		'.LOCAL' {
			instr := Instr{kind: .local, pos: pos, section: e.current_section, symbol_name: e.tok.lit}
			e.next()
			e.instrs[e.current_section] << &instr
		}
		'.STRING' {
			e.string()
		}
		'.BYTE' {
			e.byte()
		}
		'.WORD' {
			e.word()
		}
		'.LONG' {
			e.long()
		}
		'.QUAD' {
			e.quad()
		}
		'RETQ', 'RET' {
			e.instrs[e.current_section] << &Instr{kind: .ret, pos: pos, section: e.current_section, code: [u8(0xc3)]}
		}
		'SYSCALL' {
			e.instrs[e.current_section] << &Instr{kind: .syscall, pos: pos, section: e.current_section, code: [u8(0x0f), 0x05]}
		}
		'NOPQ', 'NOP' {
			e.instrs[e.current_section] << &Instr{kind: .nop, pos: pos, section: e.current_section, code: [u8(0x90)]}
		}
		'HLT' {
			e.instrs[e.current_section] << &Instr{kind: .hlt, pos: pos, section: e.current_section, code: [u8(0xf4)]}
		}
		'LEAVE' {
			e.instrs[e.current_section] << &Instr{kind: .leave, pos: pos, section: e.current_section, code: [u8(0xc9)]}
		}
		'CQTO' {
			e.instrs[e.current_section] << &Instr{kind: .cqto, pos: pos, section: e.current_section, code: [u8(0x48), 0x99]}
		}
		'POP', 'POPQ' {
			e.pop()
		}
		'PUSHQ', 'PUSH' {
			e.push()
		}
		'MOVQ', 'MOVL', 'MOVW', 'MOVB' {
			e.mov(instr_name_upper)
		}
		'MOVZBW', 'MOVZBL', 'MOVZBQ', 'MOVZWQ', 'MOVZWL' {
			e.mov_zero_extend(instr_name_upper)
		}
		'MOVSBL', 'MOVSBW', 'MOVSBQ', 'MOVSWL', 'MOVSWQ', 'MOVSLQ' {
			e.mov_sign_extend(instr_name_upper)
		}
		'LEAQ', 'LEAL', 'LEAW' {
			e.lea(instr_name_upper)
		}
		'ADDQ', 'ADDL', 'ADDW', 'ADDB' {
			e.add(instr_name_upper)
		}
		'SUBQ', 'SUBL', 'SUBW', 'SUBB' {
			e.sub(instr_name_upper)
		}
		'IDIVQ', 'IDIVL', 'IDIVW', 'IDIVB' {
			e.idiv(instr_name_upper)
		}
		'DIVQ', 'DIVL', 'DIVW', 'DIVB' {
			e.div(instr_name_upper)
		}
		'IMULQ', 'IMULL', 'IMULW' {
			e.imul(instr_name_upper)
		}
		'NEGQ', 'NEGL', 'NEGW', 'NEGB' {
			e.neg(instr_name_upper)
		}
		'XORQ', 'XORL', 'XORW', 'XORB' {
			e.xor(instr_name_upper)
		}
		'ANDQ', 'ANDL', 'ANDW', 'ANDB' {
			e.and(instr_name_upper)
		}
		'NOTQ', 'NOTL', 'NOTW', 'NOTB' {
			e.not(instr_name_upper)
		}
		'CMPQ', 'CMPL', 'CMPW', 'CMPB' {
			e.cmp(instr_name_upper)
		}
		'SHLQ', 'SHLL', 'SHLW', 'SHLB' {
			e.sh(.shl, instr_name_upper, encoder.slash_4)
		}
		'SHRQ', 'SHRL', 'SHRW', 'SHRB' {
			e.sh(.shr, instr_name_upper, encoder.slash_5)
		}
		'SETL' {
			e.set(.setl, [u8(0x0F), 0x9C])
		}
		'SETG' {
			e.set(.setg, [u8(0x0F), 0x9F])
		}
		'SETLE' {
			e.set(.setle, [u8(0x0F), 0x9E])
		}
		'SETGE' {
			e.set(.setge, [u8(0x0F), 0x9D])
		}
		'SETE' {
			e.set(.sete, [u8(0x0F), 0x94])
		}
		'SETNE' {
			e.set(.setne, [u8(0x0F), 0x95])
		}
		'CALLQ', 'CALL' {
			e.call()
		}
		'JMP' {
			e.var_instr(.jmp, [u8(0xEB), 0], 1, [u8(0xE9), 0, 0, 0, 0], 1)
		}
		'JNE' {
			e.var_instr(.jne, [u8(0x75), 0], 1, [u8(0x0F), 0x85, 0, 0, 0, 0], 2)
		}
		'JE' {
			e.var_instr(.je, [u8(0x74), 0], 1, [u8(0x0F), 0x84, 0, 0, 0, 0], 2)
		}
		'JL' {
			e.var_instr(.jl, [u8(0x7C), 0], 1, [u8(0x0f), 0x8C, 0, 0, 0, 0], 2)
		}
		'JG' {
			e.var_instr(.jg, [u8(0x7F), 0], 1, [u8(0x0F), 0x8F, 0, 0, 0, 0], 2)
		}
		'JLE' {
			e.var_instr(.jle, [u8(0x7E), 0], 1, [u8(0x0F), 0x8E, 0, 0, 0, 0], 2)
		}
		'JGE' {
			e.var_instr(.jge, [u8(0x7D), 0], 1, [u8(0x0F), 0x8D, 0, 0, 0, 0], 2)
		}
		else {
			error.print(pos, 'unkwoun instruction `$instr_name`')
			exit(1)
		}
	}
}

pub fn (mut e Encoder) encode() {
	for {
		if e.tok.kind == .eof {
			break
		}
		e.encode_instr()
	}
}

