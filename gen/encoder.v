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
	nop
	hlt
	label
}

pub struct Instr {
pub mut:
	kind     InstrKind
	left_hs  Expr
	right_hs Expr
	code     []u8
	addr     int
	binding  u8
	pos      token.Position
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

const rex_w = u8(0x48)

const reg32 = ['EAX', 'ECX', 'EDX', 'EBX', 'ESP', 'EBP', 'ESI', 'EDI']

const reg64 = ['RAX', 'RCX', 'RDX', 'RBX', 'RSP', 'RBP', 'RSI', 'RDI']

fn reg_size(reg string) int {
	if reg in gen.reg32 {
		return 32
	}
	if reg in gen.reg64 {
		return 64
	}
	panic('unreachable')
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

fn align_to(n int, align int) int {
	return (n + align - 1) / align * align
}

fn calc_rm(dest string, src string) u8 {
	mut d_n := -1
	mut s_n := -1

	d_n = reg_bits(dest)
	s_n = reg_bits(src)

	return u8(0xc0 + (8 * s_n) + d_n)
}

fn (mut g Gen) has_label(name string) bool {
	for l in g.labels {
		if l.left_hs.lit == name {
			return true
		}
	}
	return false
}

fn (mut g Gen) get_label(name string) &Instr {
	for i, l in g.labels {
		if l.left_hs.lit == name {
			return &g.labels[i]
		}
	}
	panic('unknown label name `${name}`')
}

fn (mut g Gen) encode_movq(instr Instr) []u8 {
	mut src_size := 0
	mut trg_size := 0
	mut code := []u8{}
	match instr.left_hs {
		RegExpr {
			src_size = reg_size(instr.left_hs.lit)
			match instr.right_hs {
				RegExpr {
					trg_size = reg_size(instr.right_hs.lit)

					if src_size != 64 || src_size != trg_size {
						error.print(error.new_error(instr.pos, 'miss match size of operand'))
						exit(1)
					}

					code << [gen.rex_w, u8(0x89), u8(calc_rm(instr.right_hs.lit, instr.left_hs.lit))]
				}
				else {
					error.print(error.new_error(instr.right_hs.pos, 'unexpected expression'))
					exit(1)
				}
			}
		}
		IntExpr {
			num := strconv.atoi(instr.left_hs.lit) or {
				error.print(error.new_error(instr.left_hs.pos, 'atoi() failed'))
				exit(1)
			}

			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))

			match instr.right_hs {
				RegExpr {
					trg_size = reg_size(instr.right_hs.lit)
					if trg_size != 64 {
						error.print(error.new_error(instr.right_hs.pos, 'miss match size of operand'))
						exit(1)
					}
					mod_rm := u8(0xc0 + reg_bits(instr.right_hs.lit))
					code << [gen.rex_w, u8(0xc7), mod_rm, hex[0], hex[1], hex[2], hex[3]]
				}
				else {
					error.print(error.new_error(instr.right_hs.pos, 'unexpected expression'))
					exit(1)
				}
			}
		}
		else {
			error.print(error.new_error(instr.left_hs.pos, 'unexpected expression'))
			exit(1)
		}
	}
	g.addr += code.len
	return code
}

fn (mut g Gen) encode_popq(instr Instr) []u8 {
	mut code := []u8{}
	match instr.left_hs {
		RegExpr {
			if instr.left_hs.lit !in gen.reg64 {
				error.print(error.new_error(instr.left_hs.pos, 'invalid operand for instruction'))
				exit(1)
			} else {
				code << u8(0x58 + reg_bits(instr.left_hs.lit))
			}
		}
		else {
			error.print(error.new_error(instr.left_hs.pos, 'invalid operand for instruction'))
			exit(1)
		}
	}
	g.addr += code.len
	return code
}

fn (mut g Gen) encode_pushq(instr Instr) []u8 {
	mut code := []u8{}
	match instr.left_hs {
		RegExpr {
			if instr.left_hs.lit !in gen.reg64 {
				error.print(error.new_error(instr.left_hs.pos, 'invalid operand for instruction'))
				exit(1)
			} else {
				code << u8(0x50 + reg_bits(instr.left_hs.lit))
			}
		}
		IntExpr {
			num := strconv.atoi(instr.left_hs.lit) or {
				error.print(error.new_error(instr.left_hs.pos, 'atoi() failed'))
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
			error.print(error.new_error(instr.left_hs.pos, 'unexpected expression'))
			exit(1)
		}
	}
	g.addr += code.len
	return code
}

fn (mut g Gen) encode_addq(instr Instr) []u8 {
	mut src_size := 0
	mut trg_size := 0
	mut code := []u8{}
	match instr.left_hs {
		RegExpr {
			src_size = reg_size(instr.left_hs.lit)
			match instr.right_hs {
				RegExpr {
					trg_size = reg_size(instr.right_hs.lit)

					if src_size != 64 || src_size != trg_size {
						error.print(error.new_error(instr.pos, 'miss match size of operand'))
						exit(1)
					}

					code << [gen.rex_w, u8(0x01), u8(calc_rm(instr.right_hs.lit, instr.left_hs.lit))]
				}
				else {
					error.print(error.new_error(instr.right_hs.pos, 'unexpected expression'))
					exit(1)
				}
			}
		}
		IntExpr {
			num := strconv.atoi(instr.left_hs.lit) or {
				error.print(error.new_error(instr.left_hs.pos, 'atoi() failed'))
				exit(1)
			}

			match instr.right_hs {
				RegExpr {
					trg_size = reg_size(instr.right_hs.lit)

					if trg_size != 64 {
						error.print(error.new_error(instr.pos, 'miss match size of operand'))
						exit(1)
					}

					mod_rm := u8(0xc0 + reg_bits(instr.right_hs.lit))

					if -128 <= num && num <= 127 {
						code << [gen.rex_w, 0x83, mod_rm, u8(num)]
					} else if num < 1 << 31 {
						mut hex := [u8(0), 0, 0, 0]
						binary.little_endian_put_u32(mut &hex, u32(num))
						if instr.right_hs.lit == 'RAX' {
							code << [gen.rex_w, 0x05, hex[0], hex[1], hex[2], hex[3]]
						} else {
							code << [gen.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
						}
					}
				}
				else {
					error.print(error.new_error(instr.right_hs.pos, 'unexpected expression'))
					exit(1)
				}
			}
		}
		else {
			error.print(error.new_error(instr.left_hs.pos, 'unexpected expression'))
			exit(1)
		}
	}
	g.addr += code.len
	return code
}

fn (mut g Gen) encode_subq(instr Instr) []u8 {
	mut src_size := 0
	mut trg_size := 0
	mut code := []u8{}
	match instr.left_hs {
		RegExpr {
			src_size = reg_size(instr.left_hs.lit)
			match instr.right_hs {
				RegExpr {
					trg_size = reg_size(instr.right_hs.lit)

					if src_size != 64 || src_size != trg_size {
						error.print(error.new_error(instr.pos, 'miss match size of operand'))
						exit(1)
					}

					code << [gen.rex_w, 0x29, u8(calc_rm(instr.right_hs.lit, instr.left_hs.lit))]
				}
				else {
					error.print(error.new_error(instr.right_hs.pos, 'unexpected expression'))
					exit(1)
				}
			}
		}
		IntExpr {
			num := strconv.atoi(instr.left_hs.lit) or {
				error.print(error.new_error(instr.left_hs.pos, 'atoi() failed'))
				exit(1)
			}

			match instr.right_hs {
				RegExpr {
					trg_size = reg_size(instr.right_hs.lit)

					if trg_size != 64 {
						error.print(error.new_error(instr.pos, 'miss match size of operand'))
						exit(1)
					}

					mod_rm := u8(0xe8 + reg_bits(instr.right_hs.lit))

					if -128 <= num && num <= 127 {
						code << [gen.rex_w, 0x83, mod_rm, u8(num)]
					} else if num < 1 << 31 {
						mut hex := [u8(0), 0, 0, 0]
						binary.little_endian_put_u32(mut &hex, u32(num))
						code << [gen.rex_w, 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3]]
					}
				}
				else {
					error.print(error.new_error(instr.right_hs.pos, 'unexpected expression'))
					exit(1)
				}
			}
		}
		else {
			error.print(error.new_error(instr.left_hs.pos, 'unexpected expression'))
			exit(1)
		}
	}
	g.addr += code.len
	return code
}

pub fn (mut g Gen) encode_label(instr Instr) int {
	mut addr := 0
	match instr.left_hs {
		IdentExpr {
			if g.has_label(instr.left_hs.lit) {
				error.print(error.new_error(instr.pos, 'symbol `${instr.left_hs.lit}` is already defined'))
				exit(1)
			} else {
				addr = g.addr
			}
		}
		else {
			error.print(error.new_error(instr.pos, 'must be an identifier'))
			exit(1)
		}
	}
	return addr
}

fn (mut g Gen) encode_xor(instr Instr) []u8 {
	mut src_size := 0
	mut trg_size := 0
	mut code := []u8{}
	match instr.left_hs {
		RegExpr {
			src_size = reg_size(instr.left_hs.lit)
			match instr.right_hs {
				RegExpr {
					trg_size = reg_size(instr.right_hs.lit)
					if src_size != 64 || src_size != trg_size {
						error.print(error.new_error(instr.pos, 'miss match size of operand'))
						exit(1)
					}
					code << [gen.rex_w, 0x31, calc_rm(instr.left_hs.lit, instr.right_hs.lit)]
				}
				else {
					error.print(error.new_error(instr.right_hs.pos, 'unexpected expression'))
					exit(1)
				}
			}
		}
		IntExpr {
			num := strconv.atoi(instr.left_hs.lit) or {
				error.print(error.new_error(instr.left_hs.pos, 'atoi() failed'))
				exit(1)
			}

			match instr.right_hs {
				RegExpr {
					trg_size = reg_size(instr.right_hs.lit)
					if trg_size != 64 {
						error.print(error.new_error(instr.pos, 'miss match size of operand'))
						exit(1)
					}
					code = [gen.rex_w, 0x83, u8(0xf0 + reg_bits(instr.right_hs.lit)), u8(num)]
				}
				else {
					error.print(error.new_error(instr.right_hs.pos, 'unexpected expression'))
					exit(1)
				}
			}
		}
		else {
			error.print(error.new_error(instr.left_hs.pos, 'unexpected expression'))
			exit(1)
		}
	}
	g.addr += code.len
	return code
}

fn (mut g Gen) encode_callq(instr Instr) ([]u8, int) {
	mut code := []u8{}
	match instr.left_hs {
		IdentExpr {
			g.addr += 5
		}
		RegExpr {
			if reg_size(instr.left_hs.lit) != 64 {
				error.print(error.new_error(instr.pos, 'not supported in 64bit mode'))
				exit(1)
			}
			code << [u8(0xff), u8(0xd0 + reg_bits(instr.left_hs.lit))]
			g.addr += code.len
		}
		else {
			error.print(error.new_error(instr.pos, 'invalid operand for instruction'))
			exit(1)
		}
	}
	return code, g.addr
}

pub fn (mut g Gen) encode(mut instrs []Instr) {
	for mut instr in instrs {
		match mut instr.kind {
			.movq {
				instr.code = g.encode_movq(instr)
			}
			.popq {
				instr.code = g.encode_popq(instr)
			}
			.pushq {
				instr.code = g.encode_pushq(instr)
			}
			.addq {
				instr.code = g.encode_addq(instr)
			}
			.subq {
				instr.code = g.encode_subq(instr)
			}
			.syscall {
				instr.code << [u8(0x0f), 0x05]
				g.addr += instr.code.len
			}
			.label {
				instr.addr = g.encode_label(instr)
				g.labels << instr
			}
			.xorq {
				instr.code = g.encode_xor(instr)
			}
			.callq {
				instr.code, instr.addr = g.encode_callq(instr)
			}
			.global, .local {
				// pass
			}
			.retq {
				instr.code << 0xc3
				g.addr++
			}
			.nop {
				instr.code << 0x90
				g.addr++
			}
			.hlt {
				instr.code << 0xf4
				g.addr++
			}
		}
	}
}

pub fn (mut g Gen) write_code(instrs []Instr) {
	for instr in instrs {
		match instr.kind {
			.movq, .syscall, .retq, .nop, .popq, .pushq, .addq, .subq, .xorq, .hlt {
				g.code << instr.code
			}
			.callq {
				match instr.left_hs {
					IdentExpr {
						mut buf := [u8(0), 0, 0, 0]
						label := g.get_label(instr.left_hs.lit)
						binary.little_endian_put_u32(mut &buf, u32(label.addr - instr.addr))
						g.code << [u8(0xe8), buf[0], buf[1], buf[2], buf[3]]
					}
					RegExpr {
						g.code << instr.code
					}
					else {}
				}
			}
			.global {
				match instr.left_hs {
					IdentExpr {
						if g.has_label(instr.left_hs.lit) {
							mut l := g.get_label(instr.left_hs.lit)
							l.binding = stb_global
							g.globals_count++
						}
					}
					else {
						error.print(error.new_error(instr.left_hs.pos, 'must be an identifier'))
						exit(1)
					}
				}
			}
			.local {
				match instr.left_hs {
					IdentExpr {
						if g.has_label(instr.left_hs.lit) {
							mut l := g.get_label(instr.left_hs.lit)
							if l.binding == stb_global {
								g.globals_count--
							}
							l.binding = stb_local
						}
					}
					else {
						error.print(error.new_error(instr.left_hs.pos, 'must be an identifier'))
						exit(1)
					}
				}
			}
			.label {
				// pass
			}
		}
	}

	padding := (align_to(g.code.len, 32) - g.code.len)
	for _ in 0 .. padding {
		g.code << 0
	}
}


