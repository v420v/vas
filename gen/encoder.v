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
	leave
	label
}

pub struct Instr {
pub mut:
	binding       u8
	kind          InstrKind
	code          []u8
	symbol_name   string
	symbol_number int
	addr          i64
}

pub struct CallTarget {
pub mut:
	target_symbol string
	caller      &Instr
}

pub type Expr = IdentExpr | Immediate | Register

pub struct Register {
pub:
	lit string
	pos token.Position
}

pub struct Immediate {
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
		Register {
			match right_expr {
				Register {
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
		Immediate {
			num := strconv.atoi(left_expr.lit) or {
				error.print(left_expr.pos, 'atoi() failed')
				exit(1)
			}

			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))

			match right_expr {
				Register {
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
		Register {
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
		Register {
			if !reg_is_64(expr.lit) {
				error.print(expr.pos, 'invalid operand for instruction')
				exit(1)
			} else {
				code << u8(0x50 + reg_bits(expr.lit))
			}
		}
		Immediate {
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
		Register {
			match right_expr {
				Register {
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
		Immediate {
			num := strconv.atoi(left_expr.lit) or {
				error.print(left_expr.pos, 'atoi() failed')
				exit(1)
			}

			match right_expr {
				Register {
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
		Register {
			match right_expr {
				Register {
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
		Immediate {
			num := strconv.atoi(left_expr.lit) or {
				error.print(left_expr.pos, 'atoi() failed')
				exit(1)
			}

			match right_expr {
				Register {
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
		Register {
			match right_expr {
				Register {
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
		Immediate {
			num := strconv.atoi(left_expr.lit) or {
				error.print(left_expr.pos, 'atoi() failed')
				exit(1)
			}

			match right_expr {
				Register {
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

// TODO: Rewrite this function later for improved readability and efficiency.
pub fn (mut g Gen) assign_instruction_addresses(mut instrs  []&Instr) {
	for mut instr in instrs {
		instr.addr = g.addr
		g.addr += instr.code.len

		if instr.kind == .global {
			g.globals_count++

			symbol_name := instr.symbol_name
			for mut symbol in g.symbols {
				if symbol.symbol_name == symbol_name {
					symbol.binding = gen.stb_global
				}
			}
		} else if instr.kind == .local {
			symbol_name := instr.symbol_name
			for mut symbol in g.symbols {
				if symbol.symbol_name == symbol_name {
					symbol.binding = gen.stb_local
				}
			}
		} else {
			g.code << instr.code
		}
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

fn (mut g Gen) symbol_exist(name string) bool {
	for symbol in g.symbols {
		if symbol.symbol_name == name {
			return true
		}
	}
	return false
}

fn (mut g Gen) add_rela_text(addr i64, symbol_number int) {
	g.relatext << gen.Elf64_Rela{
      r_offset: u64(addr) + 1,
      r_info: (((u64((symbol_number))) << 32) + (4)),
      r_addend: -4,
    }
}

fn (mut g Gen) find_rela_symbol_pos(symbol_name string) int {
	mut pos := 0
	for s in g.rela_symbols {
		if s == symbol_name {
			break
		}
		pos++
	}
	return pos
}

// TODO: Rewrite this function later for improved readability and efficiency.
pub fn (mut g Gen) handle_undefined_symbols(call_targets []CallTarget) {
	local_symbols_count := g.symbols.len - g.globals_count + 2
	mut pos := local_symbols_count

	for call_target in call_targets {
		if !g.symbol_exist(call_target.target_symbol) {
			if call_target.target_symbol in g.rela_symbols {
				g.add_rela_text(
					call_target.caller.addr,
					local_symbols_count + g.find_rela_symbol_pos(call_target.target_symbol)
				)
			} else {
				g.rela_symbols << call_target.target_symbol
				g.add_rela_text(call_target.caller.addr, pos)
				pos++
			}
		}
	}
}
