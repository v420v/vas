// I know the code is messy, but it gets the job done for now.
// Leaving this comment here to remind myself to refactor it from scratch
// when I have more time. 

module encoder

import error
import token
import encoding.binary
import strconv
import lexer

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
	kind           		string [required]
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

pub const (
	// suffix
	suffix_byte						= 8
	suffix_word						= 16
	suffix_long						= 32
	suffix_quad						= 64

	mod_indirection_with_no_disp	= u8(0b00)
	mod_indirection_with_disp8  	= u8(0b01)
	mod_indirection_with_disp32 	= u8(0b10)
	mod_regi						= u8(0b11)
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

pub struct UserDefinedSection {
pub mut:
	code  []u8
	addr  int
	flags int
}

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
fn (mut e Encoder) encode_regi_regi(kind string, op_code []u8, regi1 Register, regi2 Register, regi1_size int, regi2_size int) {
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
fn (mut e Encoder) encode_imm_regi(kind string, slash u8, rax_magic u8, imm Immediate, regi Register, size int) {
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

fn (mut e Encoder) encode_var_instr(kind string, rel8_code []u8, rel8_offset i64, rel32_code []u8, rel32_offset i64) {
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

fn (mut e Encoder) encode_regi(kind string, op_code []u8, slash u8, regi Register, size int) {
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
		instr := Instr{kind: 'LABEL', pos: pos, section: e.current_section, symbol_name: instr_name}
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
			section_name := e.tok.lit
			e.current_section = section_name

			e.next()
			e.expect(.comma)
			section_flags := e.tok.lit
			e.expect(.string)

			instr := Instr{kind: instr_name_upper, pos: pos, section: section_name, symbol_type: encoder.stt_section, flags: section_flags}

			if s := e.defined_symbols[section_name] {
				if s.kind == 'LABEL' {
					error.print(pos, 'symbol `$section_name` is already defined')
					exit(1)
				}
			} else {
				e.defined_symbols[section_name] = &instr
			}

			e.instrs[e.current_section] << &instr
			return
		}
		'.GLOBAL' {
			instr := Instr{kind: instr_name_upper, pos: pos, section: e.current_section, symbol_name: e.tok.lit}
			e.next()
			e.instrs[e.current_section] << &instr
			return
		}
		'.LOCAL' {
			instr := Instr{kind: instr_name_upper, pos: pos, section: e.current_section, symbol_name: e.tok.lit}
			e.next()
			e.instrs[e.current_section] << &instr
			return
		}
		'.STRING' {
			mut instr := Instr{kind: instr_name_upper, pos: pos, section: e.current_section}

			value := e.tok.lit
			e.expect(.string)

			instr.code = value.bytes()
			instr.code << 0x00
			e.instrs[e.current_section] << &instr
			return
		}
		'.BYTE' {
			mut instr := Instr{kind: instr_name_upper, pos: pos, section: e.current_section}

			desti := e.parse_operand()
			adjust := eval_expr(desti)
			mut used_symbols := []string{}
			e.get_symbol_from_binop(desti, mut &used_symbols)
			if used_symbols.len >= 2 {
				error.print(desti.pos, 'invalid operand for instruction')
				exit(1)
			}
			if used_symbols.len == 1 {
				rela_text_users := &RelaTextUser{
					uses: used_symbols[0],
					instr: &instr,
					adjust: adjust,
					rtype: encoder.r_x86_64_8
				}
				instr.code = [u8(0)]
				e.rela_text_users << rela_text_users
			} else {
				instr.code << u8(adjust)
			}
			e.instrs[e.current_section] << &instr
			return
		}
		'.WORD' {
			mut instr := Instr{kind: instr_name_upper, pos: pos, section: e.current_section}

			desti := e.parse_operand()
			adjust := eval_expr(desti)
			mut used_symbols := []string{}
			e.get_symbol_from_binop(desti, mut &used_symbols)
			if used_symbols.len >= 2 {
				error.print(desti.pos, 'invalid operand for instruction')
				exit(1)
			}
			if used_symbols.len == 1 {
				rela_text_users := &RelaTextUser{
					uses: used_symbols[0],
					instr: &instr,
					adjust: adjust,
					rtype: encoder.r_x86_64_16
				}
				instr.code = [u8(0), 0]
				e.rela_text_users << rela_text_users
			} else {
				mut hex := [u8(0), 0]
				binary.little_endian_put_u16(mut &hex, u16(adjust))
				instr.code = hex
			}
			e.instrs[e.current_section] << &instr
			return
		}
		'.LONG' {
			mut instr := Instr{kind: instr_name_upper, pos: pos, section: e.current_section}

			desti := e.parse_operand()
			adjust := eval_expr(desti)
			mut used_symbols := []string{}
			e.get_symbol_from_binop(desti, mut &used_symbols)
			if used_symbols.len >= 2 {
				error.print(desti.pos, 'invalid operand for instruction')
				exit(1)
			}
			if used_symbols.len == 1 {
				rela_text_users := &RelaTextUser{
					uses: used_symbols[0],
					instr: &instr,
					adjust: adjust,
					rtype: encoder.r_x86_64_32
				}
				instr.code = [u8(0), 0, 0, 0]
				e.rela_text_users << rela_text_users
			} else {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(adjust))
				instr.code = hex
			}
			e.instrs[e.current_section] << &instr
			return
		}
		'.QUAD' {
			mut instr := Instr{kind: instr_name_upper, pos: pos, section: e.current_section}

			desti := e.parse_operand()
			adjust := eval_expr(desti)
			mut used_symbols := []string{}
			e.get_symbol_from_binop(desti, mut &used_symbols)
			if used_symbols.len >= 2 {
				error.print(desti.pos, 'invalid operand for instruction')
				exit(1)
			}
			if used_symbols.len == 1 {
				rela_text_users := &RelaTextUser{
					uses: used_symbols[0],
					instr: &instr,
					adjust: adjust,
					rtype: encoder.r_x86_64_64
				}
				instr.code = [u8(0), 0, 0, 0, 0, 0, 0, 0]
				e.rela_text_users << rela_text_users
			} else {
				mut hex := [u8(0), 0, 0, 0, 0, 0, 0, 0]
				binary.little_endian_put_u64(mut &hex, u64(adjust))
				instr.code = hex
			}
			e.instrs[e.current_section] << &instr
			return
		}
		'RETQ', 'RET' {
			e.instrs[e.current_section] << &Instr{kind: instr_name_upper, pos: pos, section: e.current_section, code: [u8(0xc3)]}
			return
		}
		'SYSCALL' {
			e.instrs[e.current_section] << &Instr{kind: instr_name_upper, pos: pos, section: e.current_section, code: [u8(0x0f), 0x05]}
			return
		}
		'NOPQ', 'NOP' {
			e.instrs[e.current_section] << &Instr{kind: instr_name_upper, pos: pos, section: e.current_section, code: [u8(0x90)]}
			return
		}
		'HLT' {
			e.instrs[e.current_section] << &Instr{kind: instr_name_upper, pos: pos, section: e.current_section, code: [u8(0xf4)]}
			return
		}
		'LEAVE' {
			e.instrs[e.current_section] << &Instr{kind: instr_name_upper, pos: pos, section: e.current_section, code: [u8(0xc9)]}
			return
		}
		'CQTO' {
			e.instrs[e.current_section] << &Instr{kind: instr_name_upper, pos: pos, section: e.current_section, code: [u8(0x48), 0x99]}
			return
		}
		'POP', 'POPQ' {
			source := e.parse_operand()

			if source is Register {
				mut instr := Instr{kind: 'POP', pos: pos, section: e.current_section}
				check_regi_size(source, encoder.suffix_quad)
				instr.code = [0x58 + regi_bits(source)]
				e.instrs[e.current_section] << &instr
				return
			}
			if source is Indirection {
				e.encode_indir('POP', [u8(0x8f)], slash_0, source, encoder.suffix_quad)
				return
			}
		}
		'PUSHQ', 'PUSH' {
			source := e.parse_operand()

			if source is Register {
				mut instr := Instr{kind: 'PUSH', pos: pos, section: e.current_section}
				check_regi_size(source, encoder.suffix_quad)
				instr.code = [0x50 + regi_bits(source)]
				e.instrs[e.current_section] << &instr
				return
			}
			if source is Immediate {
				mut instr := Instr{kind: 'PUSH', pos: pos, section: e.current_section}
				num := eval_expr(source.expr)
				if is_in_i8_range(num) {
					instr.code = [u8(0x6a), u8(num)]
				} else if is_in_i32_range(num) {
					mut hex := [u8(0), 0, 0, 0]
					binary.little_endian_put_u32(mut &hex, u32(num))
					instr.code = [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
				}
				e.instrs[e.current_section] << &instr
				return
			}
			if source is Indirection {
				e.encode_indir('PUSH', [u8(0xff)], slash_6, source, encoder.suffix_quad)
				return
			}
		}
		'MOVQ', 'MOVL', 'MOVW', 'MOVB' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x88)
				} else {
					u8(0x89)
				}
				if desti is Register {
					e.encode_regi_regi(instr_name_upper, [op_code], source, desti, size, size)
					return
				}
				if desti is Indirection {
					e.encode_indir_regi(instr_name_upper, [op_code], desti, source, size, size)
					return
				}
			}
			if source is Indirection && desti is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x8a)
				} else {
					u8(0x8b)
				}
				e.encode_indir_regi(instr_name_upper, [op_code], source, desti, size, size)
				return
			}
			if source is Immediate && desti is Indirection {
				op_code := if size == encoder.suffix_byte {
					u8(0xc6)
				} else {
					u8(0xc7)
				}
				e.encode_imm_indir(instr_name_upper, [op_code], slash_0, source, desti, size)
				return
			}
			if source is Immediate && desti is Register {
				mut instr := Instr{kind: instr_name_upper, pos: pos, section: e.current_section}
				check_regi_size(desti, size)
				mut mod_rm := u8(0)
				if size == encoder.suffix_quad {
					instr.code << [encoder.rex_w, 0xc7]
					mod_rm = 0xc0 + regi_bits(desti)
				} else if size == encoder.suffix_byte {
					mod_rm = 0xB0 + regi_bits(desti)
				} else {
					if size == encoder.suffix_word {
						instr.code << operand_size_prefix16
					}
					mod_rm = 0xB8 + regi_bits(desti)
				}
				num := eval_expr(source.expr)
				if size == encoder.suffix_quad || size == encoder.suffix_long {
					mut hex := [u8(0), 0, 0, 0]
					binary.little_endian_put_u32(mut &hex, u32(num))
					instr.code << [mod_rm, hex[0], hex[1], hex[2], hex[3]]
				} else if size == encoder.suffix_word {
					mut hex := [u8(0), 0]
					binary.little_endian_put_u16(mut &hex, u16(num))
					instr.code << [mod_rm, hex[0], hex[1]]
				} else if size == encoder.suffix_byte {
					instr.code << [mod_rm, u8(num)]
				}
				e.instrs[e.current_section] << &instr
				return
			}
		}
		'MOVZBW', 'MOVZBL', 'MOVZBQ', 'MOVZWQ', 'MOVZWL' {
			suffix := instr_name_upper[4..].to_upper()
			size1 := get_size_by_suffix(suffix[..1])
			size2 := get_size_by_suffix(suffix[1..])

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			op_code := if size1 == encoder.suffix_byte {
				[u8(0x0F), 0xB6]
			} else if size1 == encoder.suffix_word {
				[u8(0x0F), 0xB7]
			} else {
				panic('PANIC')
			}

			if source is Register && desti is Register {
				if size2 == encoder.suffix_quad && source.lit in ['AH','CH','DH','BH'] {
					error.print(source.pos, 'can\'t encode `%$source.lit` in an instruction requiring REX prefix')
					exit(1)
				}
				e.encode_regi_regi(instr_name_upper, op_code, desti, source, size2, size1)
				return
			}
			if source is Indirection && desti is Register {
				e.encode_indir_regi(instr_name_upper, op_code, source, desti, size1, size2)
				return
			}
		}
		'MOVSBL', 'MOVSBW', 'MOVSBQ', 'MOVSWL', 'MOVSWQ' {
			suffix := instr_name_upper[4..].to_upper()
			size1 := get_size_by_suffix(suffix[..1])
			size2 := get_size_by_suffix(suffix[1..])

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			op_code := if size1 == encoder.suffix_byte {
				[u8(0x0F), 0xBE]
			} else if size1 == encoder.suffix_word {
				[u8(0x0F), 0xBF]
			} else {
				panic('PANIC')
			}

			if source is Register && desti is Register {
				if size2 == encoder.suffix_quad && source.lit in ['AH','CH','DH','BH'] {
					error.print(source.pos, 'can\'t encode `%$source.lit` in an instruction requiring REX prefix')
					exit(1)
				}
				e.encode_regi_regi(instr_name_upper, op_code, desti, source, size2, size1)
				return
			}
			if source is Indirection && desti is Register {
				e.encode_indir_regi(instr_name_upper, op_code, source, desti, size1, size2)
				return
			}
		}
		'LEAQ', 'LEAL', 'LEAW' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Indirection && desti is Register {
				e.encode_indir_regi(instr_name_upper, [u8(0x8d)], source, desti, size, size)
				return
			}
		}
		'ADDQ', 'ADDL', 'ADDW', 'ADDB' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x00)
				} else {
					u8(0x01)
				}
				if desti is Register {
					e.encode_regi_regi(instr_name_upper, [op_code], source, desti, size, size)
					return
				}
				if desti is Indirection {
					e.encode_indir_regi(instr_name_upper, [op_code], desti, source, size, size)
					return	
				}
			}
			if source is Immediate && desti is Register {
				rax_magic := if size == encoder.suffix_byte {
					u8(0x04)
				} else {
					u8(0x05)
				}
				e.encode_imm_regi(instr_name_upper, 0, rax_magic, source, desti, size)
				return
			}
			if source is Indirection && desti is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x02)
				} else {
					u8(0x03)
				}
				e.encode_indir_regi(instr_name_upper, [op_code], source, desti, size, size)
				return
			}
			if source is Immediate && desti is Indirection {
				imm_val := eval_expr(source.expr)
				op_code := if size == encoder.suffix_byte {
					u8(0x80)
				} else if is_in_i8_range(imm_val) {
					u8(0x83)
				} else {
					u8(0x81)
				}
				e.encode_imm_indir(instr_name_upper, [op_code], slash_0, source, desti, size)
				return
			}
		}
		'SUBQ', 'SUBL', 'SUBW', 'SUBB' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x28)
				} else {
					u8(0x29)
				}
				if desti is Register {
					e.encode_regi_regi(instr_name_upper, [op_code], source, desti, size, size)
					return
				}
				if desti is Indirection {
					e.encode_indir_regi(instr_name_upper, [op_code], desti, source, size, size)
					return
				}
			}
			if source is Immediate && desti is Register {
				rax_magic := if size == encoder.suffix_byte {
					u8(0x2C)
				} else {
					u8(0x2D)
				}
				e.encode_imm_regi(instr_name_upper, 5, rax_magic, source, desti, size)
				return
			}
			if source is Indirection && desti is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x2A)
				} else {
					u8(0x2B)
				}
				e.encode_indir_regi(instr_name_upper, [op_code], source, desti, size, size)
				return
			}
			if source is Immediate && desti is Indirection {
				imm_val := eval_expr(source.expr)
				op_code := if size == encoder.suffix_byte {
					u8(0x80)
				} else if is_in_i8_range(imm_val) {
					u8(0x83)
				} else {
					u8(0x81)
				}
				e.encode_imm_indir(instr_name_upper, [op_code], 5, source, desti, size)
				return
			}
		}
		'IDIVQ', 'IDIVL', 'IDIVW', 'IDIVB' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()
			op_code := if size == encoder.suffix_byte {
				u8(0xF6)
			} else {
				u8(0xF7)
			}
			if source is Register {
				e.encode_regi(instr_name_upper, [op_code], encoder.slash_7, source, size)
				return
			}
			if source is Indirection {
				e.encode_indir(instr_name_upper, [op_code], encoder.slash_7, source, size)
				return
			}
		}
		'DIVQ', 'DIVL', 'DIVW', 'DIVB' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()
			op_code := if size == encoder.suffix_byte {
				u8(0xF6)
			} else {
				u8(0xF7)
			}
			if source is Register {
				e.encode_regi(instr_name_upper, [op_code], encoder.slash_6, source, size)
				return
			}
			if source is Indirection {
				e.encode_indir(instr_name_upper, [op_code], slash_6, source, size)
				return
			}
		}
		'IMULQ', 'IMULL', 'IMULW' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()

			if e.tok.kind != .comma {
				op_code := if size == encoder.suffix_byte {
					u8(0xf6)
				} else {
					u8(0xf7)
				}
				if source is Register {
					e.encode_regi(instr_name_upper, [op_code], encoder.slash_5, source, size)
					return
				}
				if source is Indirection {
					e.encode_indir(instr_name_upper, [op_code], slash_5, source, size)
					return
				}
			}

			e.expect(.comma)
			desti_operand_1 := e.parse_operand()

			if source is Indirection && desti_operand_1 is Register {
				e.encode_indir_regi(instr_name_upper, [u8(0x0f), 0xaf], source, desti_operand_1, size, size)
				return
			}
			
			if source is Register && desti_operand_1 is Register {
				e.encode_regi_regi(instr_name_upper, [u8(0x0f), 0xaf], desti_operand_1, source, size, size)
				return
			}

			// Both are encoded to the same code.
			// imulq $0x10, %rax
			// imulq $0x10, %rax, %rax
			desti_operand_2 := if e.tok.kind != .comma {
				desti_operand_1
			} else {
				e.expect(.comma)
				e.parse_operand()
			}

			if source is Immediate && desti_operand_1 is Register && desti_operand_2 is Register {
				mut instr := Instr{kind: instr_name_upper, pos: pos, section: e.current_section}
				check_regi_size(desti_operand_1, size)
				check_regi_size(desti_operand_2, size)
				mod_rm := compose_mod_rm(mod_regi, regi_bits(desti_operand_2), regi_bits(desti_operand_1))
				if size == encoder.suffix_quad {
					instr.code << encoder.rex_w
				} else if size == encoder.suffix_word {
					instr.code << operand_size_prefix16
				}
				num := eval_expr(source.expr)
				if is_in_i8_range(num) {
					instr.code << 0x6b
					instr.code << mod_rm
					instr.code << u8(num)
				} else if size == encoder.suffix_word {
					instr.code << 0x69
					instr.code << mod_rm
					mut hex := [u8(0), 0]
					binary.little_endian_put_u16(mut &hex, u16(num))
					instr.code << hex
				} else {
					instr.code << 0x69
					instr.code << mod_rm
					mut hex := [u8(0), 0, 0, 0]
					binary.little_endian_put_u32(mut &hex, u32(num))
					instr.code << hex
				}
				e.instrs[e.current_section] << &instr
				return
			}
		}
		'NEGQ', 'NEGL', 'NEGW', 'NEGB' {
			size := get_size_by_suffix(instr_name_upper)
			op_code := if size == encoder.suffix_byte {
				u8(0xF6)
			} else {
				u8(0xF7)
			}

			desti := e.parse_operand()

			if desti is Register {
				e.encode_regi(instr_name_upper, [op_code], encoder.slash_3, desti, size)
				return
			}

			if desti is Indirection {
				e.encode_indir(instr_name_upper, [op_code], slash_3, desti, size)
				return
			}
		}
		'XORQ', 'XORL', 'XORW', 'XORB' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x30)
				} else {
					u8(0x31)
				}
				if desti is Register {
					e.encode_regi_regi(instr_name_upper, [op_code], source, desti, size, size)
					return
				}
				if desti is Indirection {
					e.encode_indir_regi(instr_name_upper, [op_code], desti, source, size, size)
					return
				}
			}
			if source is Immediate && desti is Register {
				rax_magic := if size == encoder.suffix_byte {
					u8(0x34)
				} else {
					u8(0x35)
				}
				e.encode_imm_regi(instr_name_upper, slash_6, rax_magic, source, desti, size)
				return
			}
			if source is Immediate && desti is Indirection {
				imm_val := eval_expr(source.expr)
				op_code := if size == encoder.suffix_byte {
					u8(0x80)
				} else if is_in_i8_range(imm_val) {
					u8(0x83)
				} else {
					u8(0x81)
				}
				e.encode_imm_indir(instr_name_upper, [op_code], slash_6, source, desti, size)
				return
			}
			if source is Indirection && desti is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x32)
				} else {
					u8(0x33)
				}
				e.encode_indir_regi(instr_name_upper, [op_code], source, desti, size, size)
				return
			}
		}
		'ANDQ', 'ANDL', 'ANDW', 'ANDB' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Immediate && desti is Register {
				rax_magic := if size == encoder.suffix_byte {
					u8(0x24)
				} else {
					u8(0x25)
				}
				e.encode_imm_regi(instr_name_upper, slash_4, rax_magic, source, desti, size)
				return
			}
			if source is Immediate && desti is Indirection {
				imm_val := eval_expr(source.expr)
				op_code := if size == encoder.suffix_byte {
					u8(0x80)
				} else if is_in_i8_range(imm_val) {
					u8(0x83)
				} else {
					u8(0x81)
				}
				e.encode_imm_indir(instr_name_upper, [op_code], slash_4, source, desti, size)
				return
			}
			if source is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x20)
				} else {
					u8(0x21)
				}
				if desti is Register {
					e.encode_regi_regi(instr_name_upper, [op_code], source, desti, size, size)
					return
				}
				if desti is Indirection {
					e.encode_indir_regi(instr_name_upper, [op_code], desti, source, size, size)
					return
				}
			}
			if source is Indirection && desti is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x22)
				} else {
					u8(0x23)
				}
				e.encode_indir_regi(instr_name_upper, [op_code], source, desti, size, size)
				return
			}
		}
		'NOTQ', 'NOTL', 'NOTW', 'NOTB' {
			size := get_size_by_suffix(instr_name_upper)
			op_code := if size == encoder.suffix_byte {
				u8(0xF6)
			} else {
				u8(0xF7)
			}

			desti := e.parse_operand()

			if desti is Register {
				e.encode_regi(instr_name_upper, [op_code], encoder.slash_2, desti, size)
				return
			}
			if desti is Indirection {
				e.encode_indir(instr_name_upper, [op_code], slash_2, desti, size)
				return
			}
		}
		'CMPQ', 'CMPL', 'CMPW', 'CMPB' {
			size := get_size_by_suffix(instr_name_upper)

			source := e.parse_operand()
			e.expect(.comma)
			desti := e.parse_operand()

			if source is Register {
				op_code := if size == encoder.suffix_byte {
					u8(0x38)
				} else {
					u8(0x39)
				}
				if desti is Register {
					e.encode_regi_regi(instr_name_upper, [op_code], source, desti, size, size)
					return
				}
				if desti is Indirection {
					e.encode_indir_regi(instr_name_upper, [op_code], desti, source, size, size)
					return
				}
			}
			if source is Immediate && desti is Register {
				rax_magic := if size == encoder.suffix_byte {
					u8(0x3C)
				} else {
					u8(0x3D)
				}
				e.encode_imm_regi(instr_name_upper, slash_7, rax_magic, source, desti, size)
				return
			}
			if source is Immediate && desti is Indirection {
				imm_val := eval_expr(source.expr)
				op_code := if size == encoder.suffix_byte {
					u8(0x80)
				} else if is_in_i8_range(imm_val) {
					u8(0x83)
				} else {
					u8(0x81)
				}
				e.encode_imm_indir(instr_name_upper, [op_code], slash_7, source, desti, size)
				return
			}
			if source is Indirection && desti is Register {
				op_code := if size == encoder.suffix_byte {u8(0x3A)} else {u8(0x3B)}
				e.encode_indir_regi(instr_name_upper, [op_code], source, desti, size, size)
				return
			}
		}
		'SETL' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(instr_name_upper, [u8(0x0F), 0x9C], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETG' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(instr_name_upper, [u8(0x0F), 0x9F], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETLE' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(instr_name_upper, [u8(0x0F), 0x9E], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETGE' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(instr_name_upper, [u8(0x0F), 0x9D], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETE' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(instr_name_upper, [u8(0x0F), 0x94], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'SETNE' {
			regi := e.parse_operand()
			if regi is Register {
				e.encode_regi(instr_name_upper, [u8(0x0F), 0x95], encoder.slash_0, regi, encoder.suffix_byte)
				return
			}
		}
		'CALLQ', 'CALL' {
			mut instr := Instr{kind: 'CALL', pos: pos, section: e.current_section, code: [u8(0xe8), 0, 0, 0, 0]}

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
			e.instrs[e.current_section] << &instr
			return
		}
		'JMP', 'JMPQ' {
			e.encode_var_instr(instr_name_upper, [u8(0xEB), 0], 1, [u8(0xE9), 0, 0, 0, 0], 1)
			return
		}
		'JNE' {
			e.encode_var_instr(instr_name_upper, [u8(0x75), 0], 1, [u8(0x0F), 0x85, 0, 0, 0, 0], 2)
			return
		}
		'JE' {
			e.encode_var_instr(instr_name_upper, [u8(0x74), 0], 1, [u8(0x0F), 0x84, 0, 0, 0, 0], 2)
			return
		}
		'JL' {
			e.encode_var_instr(instr_name_upper, [u8(0x7C), 0], 1, [u8(0x0f), 0x8C, 0, 0, 0, 0], 2)
			return
		}
		'JG' {
			e.encode_var_instr(instr_name_upper, [u8(0x7F), 0], 1, [u8(0x0F), 0x8F, 0, 0, 0, 0], 2)
			return
		}
		'JLE' {
			e.encode_var_instr(instr_name_upper, [u8(0x7E), 0], 1, [u8(0x0F), 0x8E, 0, 0, 0, 0], 2)
			return
		}
		'JGE' {
			e.encode_var_instr(instr_name_upper, [u8(0x7D), 0], 1, [u8(0x0F), 0x8D, 0, 0, 0, 0], 2)
			return
		}
		else {
			error.print(pos, 'unkwoun instruction `$instr_name_upper`')
			exit(1)
		}
	}
	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

pub fn (mut e Encoder) encode() {
	for e.tok.kind != .eof {
		e.encode_instr()
	}
}

