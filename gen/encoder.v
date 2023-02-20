module gen

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
}

pub type Expr = IdentExpr | Immediate | Register | Indirection | Number

pub struct Number {
pub:
	lit string
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

pub struct IdentExpr {
pub:
	lit string
	pos token.Position
}

pub const (
	rex_w = u8(0x48)
)

fn reg_is_64(reg string) bool {
	return reg[0] == `R`
}

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

fn eval_expr(expr Expr) int {
	return match expr {
		Number {
			strconv.atoi(expr.lit) or {
                error.print(expr.pos, 'atoi() failed')
                exit(1)
            }
		}
		else {
			0
		}
	}
}

pub fn encode_movq(left_expr Expr, right_expr Expr, pos token.Position) []u8 {
    if left_expr is Register && right_expr is Register {
        return [gen.rex_w, 0x89, u8(calc_rm(right_expr.lit, left_expr.lit))]
    }
    
	if left_expr is Register && right_expr is Indirection {
        reg := u8(reg_bits(left_expr.lit))
        rm := u8(reg_bits(right_expr.regi.lit))
        mut num := 0

	    num = eval_expr(right_expr.expr)

        mod := mod_indirection_with_displacement8
        mod_rm := compose_mod_rm(mod, reg, rm)
        return [gen.rex_w, 0x89, mod_rm, u8(num)]
    }

    if left_expr is Immediate && right_expr is Register {
        num := eval_expr(left_expr.expr)

        mut hex := [u8(0), 0, 0, 0]
        binary.little_endian_put_u32(mut &hex, u32(num))

        mod_rm := u8(0xc0 + reg_bits(right_expr.lit))
        return [gen.rex_w, u8(0xc7), mod_rm, hex[0], hex[1], hex[2], hex[3]]
    }

	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

pub fn encode_popq(expr Expr) []u8 {
	if expr is Register {
		return [u8(0x58 + reg_bits(expr.lit))]
	}
	error.print(expr.pos, 'invalid operand for instruction')
	exit(1)
}

pub fn encode_pushq(expr Expr) []u8 {
	if expr is Register {
		return [u8(0x50 + reg_bits(expr.lit))]
	}

	if expr is Immediate {
		num := eval_expr(expr.expr)

		if num < 1 << 7 {
			return [u8(0x6a), u8(num)]
		} else if num < 1 << 31 {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			return [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
		}
	}

	error.print(expr.pos, 'invalid operand for instruction')
	exit(1)
}

pub fn encode_addq(left_expr Expr, right_expr Expr, pos token.Position) []u8 {
	if left_expr is Register && right_expr is Register {
		return [gen.rex_w, u8(0x01), u8(calc_rm(right_expr.lit, left_expr.lit))]
	}
	
	if left_expr is Immediate && right_expr is Register {
		num := eval_expr(left_expr.expr)
		mod_rm := u8(0xc0 + reg_bits(right_expr.lit))

		if -128 <= num && num <= 127 {
			return [gen.rex_w, 0x83, mod_rm, u8(num)]
		} else if num < 1 << 31 {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			if right_expr.lit == 'RAX' {
				return [gen.rex_w, 0x05, hex[0], hex[1], hex[2], hex[3]]
			} else {
				return [gen.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
			}
		} else {
			panic('PANIC')
		}
	}
	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

pub fn encode_callq(left_expr Expr, pos token.Position) (&Instr, CallTarget) {
	instr := Instr{
		kind: .callq
		code: [u8(0xe8), 0, 0, 0, 0]
	}
	mut target_sym_name := ''

	if left_expr is IdentExpr {
		target_sym_name = left_expr.lit
	} else if left_expr is Number {
		target_sym_name = left_expr.lit
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}

	call_target := CallTarget{
		target_symbol: target_sym_name
		caller: &instr
	}
	return &instr, call_target
}

pub fn encode_leaq(left_expr Expr, right_expr Expr, pos token.Position) (&Instr, RelaTextUser) {
	mut instr := gen.Instr{}
	instr.kind = .leaq
	if left_expr is Indirection && right_expr is Register {
		regi := left_expr.regi

		target_regi := right_expr
		if regi.lit != "RIP" {
			error.print(regi.pos, 'unexpected expression (not implemented yet...)')
			exit(1)
		}

		mod_rm := compose_mod_rm(0b00, u8(reg_bits(target_regi.lit)), u8(0b101))
		instr.code = [gen.rex_w, 0x8d, mod_rm, 0, 0, 0, 0]

		if left_expr.expr is IdentExpr {
			symbol := left_expr.expr.lit
			ru := gen.RelaTextUser{
				instr:  &instr,
				uses:   symbol,
			}
			return &instr, ru
		}
	}
	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

pub fn encode_subq(left_expr Expr, right_expr Expr, pos token.Position) []u8 {
	if left_expr is Register && right_expr is Register {
		return [gen.rex_w, 0x29, u8(calc_rm(right_expr.lit, left_expr.lit))]
	}
	
	if left_expr is Immediate && right_expr is Register {
		num := eval_expr(left_expr.expr)
		mod_rm := u8(0xe8 + reg_bits(right_expr.lit))

		if -128 <= num && num <= 127 {
			return [gen.rex_w, 0x83, mod_rm, u8(num)]
		} else if num < 1 << 31 {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			return [gen.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
		}
	}

	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

pub fn encode_xorq(left_expr Expr, right_expr Expr, pos token.Position) []u8 {
	if left_expr is Register && right_expr is Register {
		return [gen.rex_w, 0x31, calc_rm(left_expr.lit, right_expr.lit)]
	}

	if left_expr is Immediate && right_expr is Register {
		num := eval_expr(left_expr.expr)

		return [gen.rex_w, 0x83, u8(0xf0 + reg_bits(right_expr.lit)), u8(num)]
	}

	error.print(pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut g Gen) assign_symbol_binding(symbol_name string, binding u8) {
	for mut symbol in g.symbols {
		if symbol.symbol_name == symbol_name {
			symbol.binding = binding
			break
		}
	}
}

pub fn (mut g Gen) assign_instruction_addresses(mut instrs  []&Instr) {
    mut section := InstrKind.text
    for mut instr in instrs {
        section = if instr.kind == .data { .data } else { .text }

		match instr.kind {
            .global  {
                g.globals_count++
                g.assign_symbol_binding(instr.symbol_name, gen.stb_global)
            }
            .local  {
                g.assign_symbol_binding(instr.symbol_name, gen.stb_local)
            }
            else {
				if section == .text {
					instr.addr = g.text_addr
					g.text_addr += instr.code.len
					g.code << instr.code
				} else {
					instr.addr = g.data_addr
					g.data_addr += instr.code.len
					g.data << instr.code
				}
            }
        }
        instr.section = section
    }
}

pub fn (mut g Gen) resolve_call_targets(call_targets []CallTarget) {
	for call_target in call_targets {
		for mut symbol in g.symbols {
			if symbol.symbol_name == call_target.target_symbol {
				mut buf := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &buf, u32(symbol.addr - (call_target.caller.addr + 5)))
				g.code[call_target.caller.addr+1] = buf[0]
				g.code[call_target.caller.addr+2] = buf[1]
				g.code[call_target.caller.addr+3] = buf[2]
				g.code[call_target.caller.addr+4] = buf[3]
			}
		}
	}
}

fn (mut g Gen) symbol_is_defined(name string) bool {
	for symbol in g.symbols {
		if symbol.symbol_name == name {
			return true
		}
	}
	return false
}

fn (mut g Gen) rela_symbol_pos(symbol_name string) int {
	mut pos := 0
	for s in g.rela_symbols {
		if s == symbol_name {
			break
		}
		pos++
	}
	return pos
}

pub fn (mut g Gen) handle_undefined_symbols(call_targets []CallTarget, rela_text_users []RelaTextUser) {
	local_symbols_len := g.symbols.len - g.globals_count + 3
	mut pos := local_symbols_len
	mut r_info := u64(0)

	// callq printf

	for call_target in call_targets {
		if g.symbol_is_defined(call_target.target_symbol) {
			continue
		}
		if call_target.target_symbol in g.rela_symbols {
            r_info = (((u64(local_symbols_len + g.rela_symbol_pos(call_target.target_symbol))) << 32) + gen.r_x86_64_plt32)
        } else {
            g.rela_symbols << call_target.target_symbol
            r_info = (((u64(pos)) << 32) + gen.r_x86_64_plt32)
            pos++
        }
        g.relatext << gen.Elf64_Rela{
            r_offset: u64(call_target.caller.addr) + 1,
            r_info: r_info,
            r_addend: -4,
        }
	}

	// leaq msg(%rip), %rdi
	//      ^^^^^^^^^

	for r in rela_text_users {
    	r_offset := u64(r.instr.addr + 3)
    	mut r_addend := i64(0)
    	if !g.symbol_is_defined(r.uses) {
    	    if r.uses in g.rela_symbols {
    	        r_info = ((u64(g.rela_symbol_pos(r.uses) + local_symbols_len) << 32) + gen.r_x86_64_pc32)
    	    } else {
    	        g.rela_symbols << r.uses
    	        r_info = (u64(pos) << 32) + gen.r_x86_64_pc32
    	        pos++
    	    }
			r_addend = -4
    	} else {
    	    for s in g.symbols {
    	        if s.symbol_name == r.uses {
    	            r_addend = s.addr - 4
					section := if s.section == .data {2} else {1}
					r_info = (u64(section) << 32) + gen.r_x86_64_pc32
					break
    	        }
    	    }
    	}
		g.relatext << gen.Elf64_Rela{
    	    r_offset: r_offset,
    	    r_info: r_info,
    	    r_addend: r_addend,
    	}
	}
}
