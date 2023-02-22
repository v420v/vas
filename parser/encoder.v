module parser

import error
import encoding.binary
import strconv
import token

pub enum InstrKind {
	text
	data
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
	retq
	syscall
	nopq
	hlt
	leave
	label
}

pub struct Instr {
pub mut:
	binding       u8
	kind          InstrKind
	code          []u8
	symbol_name   string
	section       InstrKind
	symbol_number int
	addr          i64
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
	mod_indirection_with_displacement8 = u8(0b01)
	mod_indirection_with_displacement32 = u8(0b10)
	rex_w = u8(0x48)

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

pub fn reg_bits(reg string) int {
	match reg {
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
			panic('unreachable')
		}
	}
}

pub fn align_to(n int, align int) int {
	return (n + align - 1) / align * align
}

fn calc_rm(dest string, src string) u8 {
	mut d_n := -1
	mut s_n := -1

	d_n = reg_bits(dest)
	s_n = reg_bits(src)

	return u8(0xc0 + (8 * s_n) + d_n)
}

pub fn compose_mod_rm(mod u8, reg_op u8, rm u8) u8 {
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
					panic('PANIC')
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

pub fn (mut p Parser) instr_movq(left_expr Expr, right_expr Expr, pos token.Position) {
	mut instr := Instr{kind: .movq}
    if left_expr is Register && right_expr is Register {

		// movq %rax, %rax
        instr.code = [parser.rex_w, 0x89, u8(calc_rm(right_expr.lit, left_expr.lit))]

    } else if left_expr is Register && right_expr is Indirection {
		
		if right_expr.regi.lit == "RIP" {
			mod := mod_indirection_with_no_displacement
			reg := u8(reg_bits(left_expr.lit))
			mod_rm := compose_mod_rm(mod, reg, 0b101)
			instr.code << [parser.rex_w, 0x89, mod_rm]

			// movq %rax, foo + 1(%rip) ... ok
			// movq %rax, foo + 1 + bar(%rip) ... error
			mut used_symbols := []string{}
			p.get_disp_symbol(right_expr.expr, mut &used_symbols)
			if used_symbols.len != 1 {
				error.print(pos, 'invalid operand for instruction')
				exit(1)
			}

			rela_text_user := parser.RelaTextUser{
				instr:  &instr,
				offset: instr.code.len,
				uses:   used_symbols[0],
				adjust: eval_expr(right_expr.expr)
			}

			p.rela_text_users << rela_text_user
			instr.code << [u8(0), 0, 0, 0]
		} else {
			reg := u8(reg_bits(left_expr.lit))
	    	num := eval_expr(right_expr.expr)
			rm := u8(reg_bits(right_expr.regi.lit))
        	mod := mod_indirection_with_displacement8

			// movq %rax, 0-4(%rsp)
			if right_expr.regi.lit == "RSP" {
				mod_rm := compose_mod_rm(mod, reg, rm)
				sib := compose_sib(0b00, 0b100, 0b100)
				instr.code = [parser.rex_w, 0x89, mod_rm, sib, u8(num)]
			} else {
				// movq %rax, 0-4(%rbp)
				mod_rm := compose_mod_rm(mod, reg, rm)
        		instr.code = [parser.rex_w, 0x89, mod_rm, u8(num)]
			}
		}

    } else if left_expr is Immediate && right_expr is Register {

        num := eval_expr(left_expr.expr)
        mut hex := [u8(0), 0, 0, 0]
        binary.little_endian_put_u32(mut &hex, u32(num))
        mod_rm := u8(0xc0 + reg_bits(right_expr.lit))
        instr.code = [parser.rex_w, u8(0xc7), mod_rm, hex[0], hex[1], hex[2], hex[3]]

    } else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

pub fn (mut p Parser) instr_popq(expr Expr) {
	mut instr := Instr{kind: .popq}
	if expr is Register {
		// popq %rbp
		instr.code = [u8(0x58 + reg_bits(expr.lit))]
	} else {
		error.print(expr.pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

pub fn (mut p Parser) instr_pushq(expr Expr) {
	mut instr := Instr{kind: .pushq}
	if expr is Register {
		// pushq %rax
		instr.code = [u8(0x50 + reg_bits(expr.lit))]
	} else if expr is Immediate {

		// pushq $10
		num := eval_expr(expr.expr)
		if num < 1 << 7 {
			instr.code = [u8(0x6a), u8(num)]
		} else if num < 1 << 31 {
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

pub fn (mut p Parser) instr_addq(left_expr Expr, right_expr Expr, pos token.Position) {
	mut instr := Instr{kind: .addq}
	if left_expr is Register && right_expr is Register {
		instr.code = [parser.rex_w, u8(0x01), u8(calc_rm(right_expr.lit, left_expr.lit))]
	} else if left_expr is Immediate && right_expr is Register {
		num := eval_expr(left_expr.expr)
		mod_rm := u8(0xc0 + reg_bits(right_expr.lit))

		if -128 <= num && num <= 127 {
			instr.code = [parser.rex_w, 0x83, mod_rm, u8(num)]
		} else if num < 1 << 31 {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			if right_expr.lit == 'RAX' {
				instr.code = [parser.rex_w, 0x05, hex[0], hex[1], hex[2], hex[3]]
			} else {
				instr.code = [parser.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
			}
		} else {
			panic('internal error')
		}
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

pub fn (mut p Parser) instr_callq(left_expr Expr, pos token.Position) {
	instr := Instr{
		kind: .callq
		code: [u8(0xe8), 0, 0, 0, 0]
	}
	
	target_sym_name := match left_expr {
		Ident, Number {
			left_expr.lit
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

pub fn (mut p Parser) instr_leaq(left_expr Expr, right_expr Expr, pos token.Position) {
	mut instr := parser.Instr{kind: .leaq}
	if left_expr is Indirection && right_expr is Register {

		// leaq msg(%rip), %rax
		regi := left_expr.regi
		target_regi := right_expr
		if regi.lit != "RIP" {
			error.print(regi.pos, 'unexpected expression (not implemented yet...)')
			exit(1)
		}

		mod_rm := compose_mod_rm(0b00, u8(reg_bits(target_regi.lit)), u8(0b101))
		instr.code = [parser.rex_w, 0x8d, mod_rm]

		mut used_symbols := []string{}
		p.get_disp_symbol(left_expr.expr, mut &used_symbols)
		if used_symbols.len != 1 {
			error.print(pos, 'invalid operand for instruction')
			exit(1)
		}
		
		rela_text_user := parser.RelaTextUser{
			instr:  &instr,
			uses:   used_symbols[0],
			offset: instr.code.len
			rtype:  parser.r_x86_64_pc32
			adjust: eval_expr(left_expr.expr)
		}
		instr.code << [u8(0), 0, 0, 0]
		p.rela_text_users << rela_text_user
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

pub fn (mut p Parser) instr_subq(left_expr Expr, right_expr Expr, pos token.Position) {
	mut instr := Instr{kind: .subq}
	if left_expr is Register && right_expr is Register {
		instr.code = [parser.rex_w, 0x29, u8(calc_rm(right_expr.lit, left_expr.lit))]
	} else if left_expr is Immediate && right_expr is Register {
		num := eval_expr(left_expr.expr)
		mod_rm := u8(0xe8 + reg_bits(right_expr.lit))

		if -128 <= num && num <= 127 {
			instr.code = [parser.rex_w, 0x83, mod_rm, u8(num)]
		} else if num < 1 << 31 {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			instr.code = [parser.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
		}
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

pub fn (mut p Parser) instr_xorq(left_expr Expr, right_expr Expr, pos token.Position) {
	mut instr := Instr{kind: .xorq}
	if left_expr is Register && right_expr is Register {
		instr.code = [parser.rex_w, 0x31, calc_rm(left_expr.lit, right_expr.lit)]
	} else if left_expr is Immediate && right_expr is Register {
		num := eval_expr(left_expr.expr)
		instr.code = [parser.rex_w, 0x83, u8(0xf0 + reg_bits(right_expr.lit)), u8(num)]
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	p.instrs << &instr
}

