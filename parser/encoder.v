module parser

import error
import encoding.binary
import strconv
import token

pub enum InstrKind {
	section
	global
	local
	string
	leaq
	movq
	popq
	pushq
	addq
	subq
	callq
	xorq
	jmp
	retq
	syscall
	nopq
	hlt
	leave
	label
}

pub struct Instr {
pub mut:
	kind           InstrKind
	code           []u8
	symbol_name    string
	section        string
	addr           i64
	binding        u8
	symbol_type    u8
	index          int
	varcode        &VariableCode = unsafe{nil}
	is_len_decided bool = true
}

fn new_instr(kind InstrKind, is_len_decided bool) Instr {
	return Instr {
		kind: kind,
		is_len_decided: is_len_decided,
	}
}

pub struct CallTarget {
pub mut:
	target_symbol string
	caller      &Instr
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
pub:
	expr Expr
	regi Register
	pos token.Position
}

pub struct Ident {
pub:
	lit string
	pos token.Position
}

pub const (
	mod_indirection_with_no_displacement = u8(0b00)
	mod_indirection_with_displacement8   = u8(0b01)
	mod_indirection_with_displacement32  = u8(0b10)
	mod_regi = u8(0b11)
	rex_w    = u8(0x48)

	r_x86_64_none	   = 0
	r_x86_64_64		   = 1
	r_x86_64_pc32	   = 2
	r_x86_64_got32	   = 3
	r_x86_64_plt32	   = 4
	r_x86_64_copy	   = 5
	r_x86_64_glob_dat  = 6
	r_x86_64_jump_slot = 7
	r_x86_64_relative  = 8
	r_x86_64_gotpcrel  = 9
	r_x86_64_32		   = 10
	r_x86_64_32s	   = 11
	r_x86_64_16		   = 12
	r_x86_64_pc16	   = 13
	r_x86_64_8		   = 14
	r_x86_64_pc8	   = 15
	r_x86_64_pc64	   = 24
)

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

fn (mut p Parser) get_disp_symbol(expr Expr, mut arr []string) {
	match expr {
		Binop {
			p.get_disp_symbol(expr.left_hs, mut arr)
			p.get_disp_symbol(expr.right_hs, mut arr)
		}
		Ident {
			arr << expr.lit
		}
		else {
		}
	}
}

fn (mut p Parser) encode_indirection_register(op_code []u8, indirection Indirection, register Register, mut instr &Instr, pos token.Position) {
	// disp(base)

	disp := eval_expr(indirection.expr)
	base_is_rip := indirection.regi.lit == 'RIP'
	base_is_rsp := indirection.regi.lit == 'RSP'
	base_is_rbp := indirection.regi.lit == 'RBP'

	mut used_symbols := []string{}
	p.get_disp_symbol(indirection.expr, mut &used_symbols)
	if used_symbols.len >= 2 {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}

	need_rela := used_symbols.len == 1

	mod_rm := if base_is_rip {
		compose_mod_rm(mod_indirection_with_no_displacement, reg_bits(register), 0b101) // rip relative
	} else if need_rela {
		compose_sib(mod_indirection_with_displacement32, reg_bits(register), reg_bits(indirection.regi))
	} else if disp == 0 && !base_is_rbp {
		compose_mod_rm(mod_indirection_with_no_displacement, reg_bits(register), reg_bits(indirection.regi))
	} else if is_in_i8_range(disp) {
		compose_sib(mod_indirection_with_displacement8, reg_bits(register), reg_bits(indirection.regi))
	} else if is_in_i32_range(disp) {
		compose_sib(mod_indirection_with_displacement32, reg_bits(register), reg_bits(indirection.regi))
	} else {
		panic('[internal eror] something whent wrong...')
	}

	instr.code << parser.rex_w
	instr.code << op_code
	instr.code << mod_rm

	if base_is_rsp {
		instr.code << 0x24
	}
	instr_code_len := instr.code.len // use in offset of rela_text_user.

	if need_rela {
		rtype := if base_is_rip {
			parser.r_x86_64_pc32
		} else {
			parser.r_x86_64_32s
		}
		rela_text_user := parser.RelaTextUser{
			instr:  unsafe {instr},
			uses:   used_symbols[0],
			offset: instr_code_len
			rtype:  u64(rtype)
			adjust: eval_expr(indirection.expr)
		}
		instr.code << [u8(0), 0, 0, 0]
		p.rela_text_users << rela_text_user
	} else {
		if disp != 0 || base_is_rip || base_is_rbp {
			if base_is_rip {
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
				panic('PANIC')
			}
		}
	}
}

fn (mut p Parser) encode_regi_regi(op_code []u8, source Register, destination Register, mut instr &Instr, pos token.Position) {
	mod_rm := compose_mod_rm(mod_regi, reg_bits(source), reg_bits(destination))
    instr.code << parser.rex_w
	instr.code << op_code
	instr.code << mod_rm
}

fn (mut p Parser) instr_string(value string) {
	mut instr := Instr{kind: .string}
	arr := value.bytes()
	instr.code = arr
	p.instrs << &instr
}

fn (mut p Parser) instr_movq(source Expr, destination Expr, pos token.Position) {
	mut instr := Instr{kind: .movq}
    if source is Register && destination is Register {

		p.encode_regi_regi([u8(0x89)], source, destination, mut &instr, pos)

	} else if source is Indirection && destination is Register {

		p.encode_indirection_register([u8(0x8b)], source, destination, mut &instr, pos)

    } else if source is Register && destination is Indirection {

		p.encode_indirection_register([u8(0x89)], destination, source, mut &instr, pos)

    } else if source is Immediate && destination is Register {
        num := eval_expr(source.expr)
        mut hex := [u8(0), 0, 0, 0]
        binary.little_endian_put_u32(mut &hex, u32(num))
        mod_rm := u8(0xc0 + reg_bits(destination))
        instr.code = [parser.rex_w, u8(0xc7), mod_rm, hex[0], hex[1], hex[2], hex[3]]
    } else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

fn (mut p Parser) instr_popq(expr Expr) {
	mut instr := Instr{kind: .popq}
	if expr is Register {
		instr.code = [u8(0x58 + reg_bits(expr))]
	} else {
		error.print(expr.pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

fn (mut p Parser) instr_pushq(expr Expr) {
	mut instr := Instr{kind: .pushq}
	if expr is Register {
		instr.code = [u8(0x50 + reg_bits(expr))]
	} else if expr is Immediate {

		num := eval_expr(expr.expr)
		if is_in_i8_range(num) {
			instr.code = [u8(0x6a), u8(num)]
		} else if is_in_i32_range(num) {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			instr.code = [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
		} else {
			panic('internal error')
		}

	} else {
		error.print(expr.pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

fn (mut p Parser) instr_addq(source Expr, destination Expr, pos token.Position) {
	mut instr := Instr{kind: .addq}
	if source is Register && destination is Register {

		p.encode_regi_regi([u8(0x01)], source, destination, mut &instr, pos)

	} else if source is Immediate && destination is Register {

		num := eval_expr(source.expr)
		mod_rm := 0xc0 + reg_bits(destination)
		if is_in_i8_range(num) {
			instr.code = [parser.rex_w, 0x83, mod_rm, u8(num)]
		} else if is_in_i32_range(num) {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			if destination.lit == 'RAX' {
				instr.code = [parser.rex_w, 0x05, hex[0], hex[1], hex[2], hex[3]]
			} else {
				instr.code = [parser.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
			}
		} else {
			panic('[internal error] somthing whent wrong...')
		}

	} else if source is Indirection && destination is Register {

		p.encode_indirection_register([u8(0x3)], source, destination, mut &instr, pos)

	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

fn (mut p Parser) instr_callq(source Expr, pos token.Position) {
	instr := Instr{kind: .callq, code: [u8(0xe8), 0, 0, 0, 0]}
	
	target_sym_name := match source {
		Ident, Number {
			source.lit
		} else {
			error.print(pos, 'invalid operand for instruction')
			exit(1)
		}
	}

	call_target := CallTarget{
		target_symbol: target_sym_name
		caller: &instr
	}

	rela_text_user := parser.RelaTextUser{
		instr:  &instr,
		offset: 1,
		uses:   target_sym_name,
		rtype:   parser.r_x86_64_plt32
	}

	p.rela_text_users << rela_text_user
	p.instrs << &instr
	p.call_targets << call_target
}

fn (mut p Parser) instr_leaq(source Expr, destination Expr, pos token.Position) {
	mut instr := parser.Instr{kind: .leaq}
	if source is Indirection && destination is Register {

		p.encode_indirection_register([u8(0x8d)], source, destination, mut &instr, pos)

	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

fn (mut p Parser) instr_subq(source Expr, destination Expr, pos token.Position) {
	mut instr := Instr{kind: .subq}
	if source is Register && destination is Register {

		p.encode_regi_regi([u8(0x29)], source, destination, mut &instr, pos)

	} else if source is Immediate && destination is Register {

		num := eval_expr(source.expr)
		mod_rm := 0xe8 + reg_bits(destination)

		if is_in_i8_range(num) {
			instr.code = [parser.rex_w, 0x83, mod_rm, u8(num)]
		} else if is_in_i32_range(num) {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			instr.code = [parser.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
		}

	} else if source is Indirection && destination is Register {

		p.encode_indirection_register([u8(0x2b)], source, destination, mut &instr, pos)

	} else if source is Register && destination is Indirection {

		p.encode_indirection_register([u8(0x29)], destination, source, mut &instr, pos)

	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

fn (mut p Parser) instr_jmp(destination Expr, pos token.Position) {
	mut instr := Instr{is_len_decided: false, kind: .jmp}

	target_sym_name := match destination {
		Ident, Number {
			destination.lit
		} else {
			error.print(pos, 'invalid operand for instruction')
			exit(1)
		}
	}

	varcode := &VariableCode{
		trgt_symbol: target_sym_name,
		rel8_code:   [u8(0xeb), 0],
		rel8_offset: 1,
		rel32_code:   [u8(0xe9), 0, 0, 0, 0],
		rel32_offset: 1,
	}

	instr.varcode = varcode

	p.variable_instrs << &instr
	p.instrs << &instr
}

fn (mut p Parser) instr_xorq(source Expr, destination Expr, pos token.Position) {
	mut instr := Instr{kind: .xorq}
	if source is Register && destination is Register {

		p.encode_regi_regi([u8(0x31)], source, destination, mut &instr, pos)

	} else if source is Immediate && destination is Register {

		num := eval_expr(source.expr)
		instr.code = [parser.rex_w, 0x83, 0xf0 + reg_bits(destination), u8(num)]

	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

fn calc_distance(user_instr &Instr, symdef &Instr, instrs []&Instr) (int, int, int, bool) {
    mut from, mut to := &Instr{}, &Instr{}
    forward := user_instr.index <= symdef.index

	unsafe {
    	if forward {
    	    from, to = instrs[user_instr.index+1], symdef
    	} else {
    	    from, to = symdef, instrs[user_instr.index+1]
    	}
	}

    mut has_variable_length := false
    mut diff, mut min, mut max := 0, 0, 0

    for instr := from; instr != to; instr = instrs[instr.index+1] {
        if !instr.is_len_decided {
            has_variable_length = true
            len_short, len_large := instr.varcode.rel8_code.len, instr.varcode.rel32_code.len
            min += len_short
            max += len_large
            diff += len_large
        } else {
            length := instr.code.len
            diff += length
            min += length
            max += length
        }
    }
    if !forward {
        diff, min, max = -diff, -min, -max
    }
    return diff, min, max, !has_variable_length
}

fn (mut p Parser) get_defined_symbol(name string) Instr {
	for s in p.defined_symbols {
        if s.symbol_name == name {
            return *s
        }
    }
	panic('unreachable')
}

pub fn (mut p Parser) resolve_variable_length_instrs(mut instrs []&Instr) []&Instr {
	mut todos := []&Instr{}
	for index := 0; index < instrs.len; index++ {
		name := instrs[index].varcode.trgt_symbol
		s := p.get_defined_symbol(name)
		diff, min, max, is_len_decided := calc_distance(instrs[index], s, p.instrs)
		if is_len_decided {
			if parser.is_in_i8_range(diff) {
				instrs[index].code = instrs[index].varcode.rel8_code
				instrs[index].code[instrs[index].varcode.rel8_offset] = u8(diff)
			} else {
				diff_int32 := i32(diff)
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(diff_int32))

				mut code, offset := instrs[index].varcode.rel32_code.clone(), instrs[index].varcode.rel32_offset
				code[offset] = hex[0]
				code[offset+1] = hex[1]
				code[offset+2] = hex[2]
				code[offset+3] = hex[3]
				instrs[index].code = code
			}
			instrs[index].is_len_decided = true
		} else {
			if parser.is_in_i8_range(max) {
				instrs[index].is_len_decided = true
				instrs[index].varcode.rel32_code = []u8{}
				instrs[index].code = instrs[index].varcode.rel8_code
			} else if !parser.is_in_i8_range(min) {
				instrs[index].is_len_decided = true
				instrs[index].varcode.rel8_code = []u8{}
				instrs[index].code = instrs[index].varcode.rel32_code
			}
			todos << instrs[index]
		}
	}
	return todos
}

