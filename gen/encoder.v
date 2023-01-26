module gen

import error
import encoding.binary
import strconv
import token

pub enum InstrKind {
	global
	local
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
	label
}

pub struct Instr {
pub mut:
	binding     u8
	kind        InstrKind
	code        []u8
	symbol_name string
	addr        i64
}

pub struct CallTarget {
pub mut:
	target_symbol string
	caller      &Instr
}

pub type Expr = IdentExpr | IntExpr | RegExpr

pub struct RegExpr {
pub:
	bit int
	lit string
	pos token.Position
}

pub struct IntExpr {
pub:
	lit string
	pos token.Position
}

pub struct IdentExpr {
pub:
	lit string
	pos token.Position
}

const (
	rex_w = u8(0x48)
)

fn reg_is_64(reg string) bool {
	return reg[0] == `R`
}

fn reg_bits(reg string) int {
	match reg {
		'EAX', 'RAX' {
			return 0b0000
		}
		'ECX', 'RCX' {
			return 0b0001
		}
		'EDX', 'RDX' {
			return 0b0010
		}
		'EBX', 'RBX' {
			return 0b0011
		}
		'ESP', 'RSP' {
			return 0b0100
		}
		'EBP', 'RBP' {
			return 0b0101
		}
		'ESI', 'RSI' {
			return 0b0110
		}
		'EDI', 'RDI' {
			return 0b0111
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

pub fn encode_movq(left_expr Expr, right_expr Expr, pos token.Position) []u8 {
	mut code := []u8{}
	match left_expr {
		RegExpr {
			match right_expr {
				RegExpr {
					if !reg_is_64(left_expr.lit) || !reg_is_64(right_expr.lit) {
						error.print(pos, 'miss match size of operand')
						exit(1)
					}

					code << [gen.rex_w, u8(0x89), u8(calc_rm(right_expr.lit, left_expr.lit))]
				}
				else {
					error.print(right_expr.pos, 'unexpected expression')
					exit(1)
				}
			}
		}
		IntExpr {
			num := strconv.atoi(left_expr.lit) or {
				error.print(left_expr.pos, 'atoi() failed')
				exit(1)
			}

			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))

			match right_expr {
				RegExpr {
					if !reg_is_64(right_expr.lit) {
						error.print(right_expr.pos, 'miss match size of operand')
						exit(1)
					}
					mod_rm := u8(0xc0 + reg_bits(right_expr.lit))
					code << [gen.rex_w, u8(0xc7), mod_rm, hex[0], hex[1], hex[2], hex[3]]
				}
				else {
					error.print(right_expr.pos, 'unexpected expression')
					exit(1)
				}
			}
		}
		else {
			error.print(left_expr.pos, 'unexpected expression')
			exit(1)
		}
	}

	return code
}

pub fn encode_popq(expr Expr) []u8 {
	mut code := []u8{}
	match expr {
		RegExpr {
			if !reg_is_64(expr.lit) {
				error.print(expr.pos, 'invalid operand for instruction')
				exit(1)
			} else {
				code << u8(0x58 + reg_bits(expr.lit))
			}
		}
		else {
			error.print(expr.pos, 'invalid operand for instruction')
			exit(1)
		}
	}
	return code
}

pub fn encode_pushq(expr Expr) []u8 {
	mut code := []u8{}
	match expr {
		RegExpr {
			if !reg_is_64(expr.lit) {
				error.print(expr.pos, 'invalid operand for instruction')
				exit(1)
			} else {
				code << u8(0x50 + reg_bits(expr.lit))
			}
		}
		IntExpr {
			num := strconv.atoi(expr.lit) or {
				error.print(expr.pos, 'atoi() failed')
				exit(1)
			}
			if num < 1 << 7 {
				code << [u8(0x6a), u8(num)]
			} else if num < 1 << 31 {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(num))
				code << [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
			}
		}
		else {
			error.print(expr.pos, 'unexpected expression')
			exit(1)
		}
	}
	return code
}

pub fn encode_addq(left_expr Expr, right_expr Expr, pos token.Position) []u8 {
	mut code := []u8{}
	match left_expr {
		RegExpr {
			match right_expr {
				RegExpr {
					if !reg_is_64(left_expr.lit) || !reg_is_64(right_expr.lit) {
						error.print(pos, 'miss match size of operand')
						exit(1)
					}

					code << [gen.rex_w, u8(0x01), u8(calc_rm(right_expr.lit, left_expr.lit))]
				}
				else {
					error.print(right_expr.pos, 'unexpected expression')
					exit(1)
				}
			}
		}
		IntExpr {
			num := strconv.atoi(left_expr.lit) or {
				error.print(left_expr.pos, 'atoi() failed')
				exit(1)
			}

			match right_expr {
				RegExpr {
					if !reg_is_64(right_expr.lit) {
						error.print(pos, 'miss match size of operand')
						exit(1)
					}

					mod_rm := u8(0xc0 + reg_bits(right_expr.lit))

					if -128 <= num && num <= 127 {
						code << [gen.rex_w, 0x83, mod_rm, u8(num)]
					} else if num < 1 << 31 {
						mut hex := [u8(0), 0, 0, 0]
						binary.little_endian_put_u32(mut &hex, u32(num))
						if right_expr.lit == 'RAX' {
							code << [gen.rex_w, 0x05, hex[0], hex[1], hex[2], hex[3]]
						} else {
							code << [gen.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
						}
					}
				}
				else {
					error.print(right_expr.pos, 'unexpected expression')
					exit(1)
				}
			}
		}
		else {
			error.print(left_expr.pos, 'unexpected expression')
			exit(1)
		}
	}
	return code
}

pub fn encode_callq(left_expr Expr, pos token.Position) (&Instr, CallTarget) {
	instr := Instr{
		kind: .callq
		code: [u8(0xe8), 0, 0, 0, 0]
	}

	mut target_sym_name := ''
	match left_expr {
		IdentExpr{
			target_sym_name = left_expr.lit
		}
		else {
			error.print(left_expr.pos, 'unexpected expression (not supported yet)')
			exit(1)
		}
	}

	call_target := CallTarget{
		target_symbol: target_sym_name
		caller: &instr
	}
	return &instr, call_target
}

pub fn encode_subq(left_expr Expr, right_expr Expr, pos token.Position) []u8 {
	mut code := []u8{}
	match left_expr {
		RegExpr {
			match right_expr {
				RegExpr {
					if !reg_is_64(left_expr.lit) || !reg_is_64(right_expr.lit) {
						error.print(pos, 'miss match size of operand')
						exit(1)
					}

					code << [gen.rex_w, 0x29, u8(calc_rm(right_expr.lit, left_expr.lit))]
				}
				else {
					error.print(right_expr.pos, 'unexpected expression')
					exit(1)
				}
			}
		}
		IntExpr {
			num := strconv.atoi(left_expr.lit) or {
				error.print(left_expr.pos, 'atoi() failed')
				exit(1)
			}

			match right_expr {
				RegExpr {
					if !reg_is_64(right_expr.lit) {
						error.print(pos, 'miss match size of operand')
						exit(1)
					}

					mod_rm := u8(0xe8 + reg_bits(right_expr.lit))

					if -128 <= num && num <= 127 {
						code << [gen.rex_w, 0x83, mod_rm, u8(num)]
					} else if num < 1 << 31 {
						mut hex := [u8(0), 0, 0, 0]
						binary.little_endian_put_u32(mut &hex, u32(num))
						code << [gen.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
					}
				}
				else {
					error.print(right_expr.pos, 'unexpected expression')
					exit(1)
				}
			}
		}
		else {
			error.print(left_expr.pos, 'unexpected expression')
			exit(1)
		}
	}
	return code
}

pub fn encode_xorq(left_expr Expr, right_expr Expr, pos token.Position) []u8 {
	mut code := []u8{}
	match left_expr {
		RegExpr {
			match right_expr {
				RegExpr {
					if !reg_is_64(left_expr.lit) || !reg_is_64(right_expr.lit) {
						error.print(pos, 'miss match size of operand')
						exit(1)
					}
					code << [gen.rex_w, 0x31, calc_rm(left_expr.lit, right_expr.lit)]
				}
				else {
					error.print(right_expr.pos, 'unexpected expression')
					exit(1)
				}
			}
		}
		IntExpr {
			num := strconv.atoi(left_expr.lit) or {
				error.print(left_expr.pos, 'atoi() failed')
				exit(1)
			}

			match right_expr {
				RegExpr {
					if !reg_is_64(right_expr.lit) {
						error.print(pos, 'miss match size of operand')
						exit(1)
					}
					code = [gen.rex_w, 0x83, u8(0xf0 + reg_bits(right_expr.lit)), u8(num)]
				}
				else {
					error.print(right_expr.pos, 'unexpected expression')
					exit(1)
				}
			}
		}
		else {
			error.print(left_expr.pos, 'unexpected expression')
			exit(1)
		}
	}
	return code
}

