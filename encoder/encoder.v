// I know the code is messy, but it gets the job done for now.
// Leaving this comment here to remind myself to refactor it from scratch
// when I have more time. 

module encoder

import error
import token
import encoding.binary
import strconv
import lexer

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
	tok             token.Token // current token
	l               lexer.Lexer // lexer
pub mut:
	current_section string = '.text'
	instrs          map[string][]&Instr
	rela_text_users []RelaTextUser
	variable_instrs []&Instr // variable length instructions jmp, je, jn ...
	defined_symbols map[string]&Instr
	sections        map[string]&UserDefinedSection
	globals_count   int
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
	r_x86_64_none	   				= 0
	r_x86_64_64		   				= 1
	r_x86_64_pc32	   				= 2
	r_x86_64_got32	   				= 3
	r_x86_64_plt32	   				= 4
	r_x86_64_copy	   				= 5
	r_x86_64_glob_dat  				= 6
	r_x86_64_jump_slot 				= 7
	r_x86_64_relative  				= 8
	r_x86_64_gotpcrel  				= 9
	r_x86_64_32		   				= 10
	r_x86_64_32s	   				= 11
	r_x86_64_16		   				= 12
	r_x86_64_pc16	   				= 13
	r_x86_64_8		   				= 14
	r_x86_64_pc8	   				= 15
	r_x86_64_pc64	   				= 24

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
	return &Encoder {
		tok: tok
		l: l
	}
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
			expr := if e.tok.kind == .lpar {
				Expr(Number{lit: '0', pos: pos})
			} else {
				e.parse_expr()
			}
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

fn get_size_by_suffix(name string) int {
	return match name.to_upper()[name.len-1] {
		`Q` {
			suffix_quad
		}
		`L` {
			suffix_long
		}
		`W` {
			suffix_word
		}
		`B` {
			suffix_byte
		} else {
			panic('unkown size')
		}
	}
}

fn check_regi_size(reg Register, size int) {
	if reg.size != size {
		error.print(reg.pos, 'invalid size of register for instruction.')
		exit(0)
	}
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

// instr regi, regi
fn (mut e Encoder) encode_regi_regi(kind InstrKind, op_code []u8, regi1 Register, regi2 Register, regi1_size int, regi2_size int) {
	mut code := []u8{}
	check_regi_size(regi1, regi1_size)
	check_regi_size(regi2, regi2_size)

	if regi1_size == encoder.suffix_quad {
		code << encoder.rex_w
	} else if regi1_size == encoder.suffix_word {
		code << operand_size_prefix16
	}

	code << op_code
	code << compose_mod_rm(encoder.mod_regi, regi_bits(regi1), regi_bits(regi2))

	e.instrs[e.current_section] << &Instr{kind: kind, code: code, section: e.current_section, pos: regi1.pos}
}

// instr imm, regi
fn (mut e Encoder) encode_imm_regi(kind InstrKind, slash u8, rax_magic u8, imm Immediate, regi Register, size int) {
	mut code := []u8{}

	num := eval_expr(imm.expr)
	check_regi_size(regi, size)

	mod_rm := compose_mod_rm(mod_regi, slash, regi_bits(regi))

	if size == encoder.suffix_quad {
		code << encoder.rex_w
	} else if size == encoder.suffix_word {
		code << operand_size_prefix16
	}

	if size == encoder.suffix_byte {
		if regi.lit == 'AL' {
			code << [rax_magic, u8(num)]
		} else {
			code << [u8(0x80), mod_rm, u8(num)]
		}
	} else if is_in_i8_range(num) {
		code << [u8(0x83), mod_rm, u8(num)]
	} else if size == encoder.suffix_word {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(num))
		if regi.lit in ['RAX', 'EAX'] {
			code << [rax_magic, hex[0], hex[1]]
		} else {
			code << [u8(0x81), mod_rm, hex[0], hex[1]]
		}
	} else if is_in_i32_range(num) {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(num))
		if regi.lit in ['RAX', 'EAX'] {
			code << [rax_magic, hex[0], hex[1], hex[2], hex[3]]
		} else {
			code << [u8(0x81), mod_rm, hex[0], hex[1], hex[2], hex[3]]
		}
	}

	e.instrs[e.current_section] << &Instr{kind: kind, code: code, section: e.current_section, pos: imm.pos}
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

fn (mut e Encoder) encode_regi(kind InstrKind, op_code []u8, slash u8, regi Register, size int) {
	mut code := []u8{}
	if size == encoder.suffix_quad {
		code << encoder.rex_w
	} else if size == encoder.suffix_word {
		code << encoder.operand_size_prefix16
	}
	check_regi_size(regi, size)
	mod_rm := compose_mod_rm(encoder.mod_regi, slash, regi_bits(regi))
	code << op_code
	code << mod_rm
	e.instrs[e.current_section] << &Instr{kind: kind, code: code, section: e.current_section, pos: regi.pos}
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
			return
		}
		'.GLOBAL' {
			instr := Instr{kind: .global, pos: pos, section: e.current_section, symbol_name: e.tok.lit}
			e.next()
			e.instrs[e.current_section] << &instr
			return
		}
		'.LOCAL' {
			instr := Instr{kind: .local, pos: pos, section: e.current_section, symbol_name: e.tok.lit}
			e.next()
			e.instrs[e.current_section] << &instr
			return
		}
		'.STRING' {
			e.string()
			return
		}
		'.BYTE' {
			e.byte()
			return
		}
		'.WORD' {
			e.word()
			return
		}
		'.LONG' {
			e.long()
			return
		}
		'.QUAD' {
			e.quad()
			return
		}
		'POP', 'POPQ' {
			e.pop()
			return
		}
		'PUSHQ', 'PUSH' {
			e.push()
			return
		}
		'MOVQ', 'MOVL', 'MOVW', 'MOVB' {
			e.mov(instr_name_upper)
			return
		}
		'MOVZBW', 'MOVZBL', 'MOVZBQ', 'MOVZWQ', 'MOVZWL' {
			e.mov_zero_extend(instr_name_upper)
			return
		}
		'MOVSBL', 'MOVSBW', 'MOVSBQ', 'MOVSWL', 'MOVSWQ' {
			e.mov_sign_extend(instr_name_upper)
			return
		}
		'LEAQ', 'LEAL', 'LEAW' {
			e.lea(instr_name_upper)
			return
		}
		'ADDQ', 'ADDL', 'ADDW', 'ADDB' {
			e.add(instr_name_upper)
			return
		}
		'SUBQ', 'SUBL', 'SUBW', 'SUBB' {
			e.sub(instr_name_upper)
			return
		}
		'IDIVQ', 'IDIVL', 'IDIVW', 'IDIVB' {
			e.idiv(instr_name_upper)
			return
		}
		'DIVQ', 'DIVL', 'DIVW', 'DIVB' {
			e.div(instr_name_upper)
			return
		}
		'IMULQ', 'IMULL', 'IMULW' {
			e.imul(instr_name_upper)
			return
		}
		'NEGQ', 'NEGL', 'NEGW', 'NEGB' {
			e.neg(instr_name_upper)
			return
		}
		'XORQ', 'XORL', 'XORW', 'XORB' {
			e.xor(instr_name_upper)
			return
		}
		'ANDQ', 'ANDL', 'ANDW', 'ANDB' {
			e.and(instr_name_upper)
			return
		}
		'NOTQ', 'NOTL', 'NOTW', 'NOTB' {
			e.not(instr_name_upper)
			return
		}
		'CMPQ', 'CMPL', 'CMPW', 'CMPB' {
			e.cmp(instr_name_upper)
			return
		}
		'RETQ', 'RET' {
			e.instrs[e.current_section] << &Instr{kind: .ret, pos: pos, section: e.current_section, code: [u8(0xc3)]}
			return
		}
		'SYSCALL' {
			e.instrs[e.current_section] << &Instr{kind: .syscall, pos: pos, section: e.current_section, code: [u8(0x0f), 0x05]}
			return
		}
		'NOPQ', 'NOP' {
			e.instrs[e.current_section] << &Instr{kind: .nop, pos: pos, section: e.current_section, code: [u8(0x90)]}
			return
		}
		'HLT' {
			e.instrs[e.current_section] << &Instr{kind: .hlt, pos: pos, section: e.current_section, code: [u8(0xf4)]}
			return
		}
		'LEAVE' {
			e.instrs[e.current_section] << &Instr{kind: .leave, pos: pos, section: e.current_section, code: [u8(0xc9)]}
			return
		}
		'CQTO' {
			e.instrs[e.current_section] << &Instr{kind: .cqto, pos: pos, section: e.current_section, code: [u8(0x48), 0x99]}
			return
		}
		'SETL' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(.setl, [u8(0x0F), 0x9C], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETG' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(.setg, [u8(0x0F), 0x9F], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETLE' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(.setle, [u8(0x0F), 0x9E], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETGE' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(.setge, [u8(0x0F), 0x9D], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETE' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(.sete, [u8(0x0F), 0x94], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETNE' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(.setne, [u8(0x0F), 0x95], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'CALLQ', 'CALL' {
			e.call()
			return
		}
		'JMP' {
			e.var_instr(.jmp, [u8(0xEB), 0], 1, [u8(0xE9), 0, 0, 0, 0], 1)
			return
		}
		'JNE' {
			e.var_instr(.jne, [u8(0x75), 0], 1, [u8(0x0F), 0x85, 0, 0, 0, 0], 2)
			return
		}
		'JE' {
			e.var_instr(.je, [u8(0x74), 0], 1, [u8(0x0F), 0x84, 0, 0, 0, 0], 2)
			return
		}
		'JL' {
			e.var_instr(.jl, [u8(0x7C), 0], 1, [u8(0x0f), 0x8C, 0, 0, 0, 0], 2)
			return
		}
		'JG' {
			e.var_instr(.jg, [u8(0x7F), 0], 1, [u8(0x0F), 0x8F, 0, 0, 0, 0], 2)
			return
		}
		'JLE' {
			e.var_instr(.jle, [u8(0x7E), 0], 1, [u8(0x0F), 0x8E, 0, 0, 0, 0], 2)
			return
		}
		'JGE' {
			e.var_instr(.jge, [u8(0x7D), 0], 1, [u8(0x0F), 0x8D, 0, 0, 0, 0], 2)
			return
		}
		else {
			error.print(pos, 'unkwoun instruction `$instr_name_upper`')
			exit(1)
		}
	}
}

pub fn (mut e Encoder) encode() {
	for e.tok.kind != .eof {
		e.encode_instr()
	}
}

