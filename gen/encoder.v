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
	callq
	retq
	syscall
	nop
	label
}

pub struct Instr {
	pub mut:
		kind       InstrKind
		left_hs    Expr
		right_hs   Expr
		code       []u8
		addr       int
		binding    u8
		pos        token.Position
}

pub type Expr = IntExpr | RegExpr | IdentExpr

pub struct RegExpr {
	pub:
	    bit int
	    lit  string
	    pos  token.Position
}

pub struct IntExpr {
	pub:
	    lit  string
	    pos  token.Position
}

pub struct IdentExpr {
	pub:
		lit string
		pos  token.Position
}

const reg32 = ['EAX', 'ECX', 'EDX', 'EBX', 'ESP', 'EBP', 'ESI', 'EDI']
const reg64 = ['RAX', 'RCX', 'RDX', 'RBX', 'RSP', 'RBP', 'RSI', 'RDI']

fn reg_size(reg string) int {
	if reg in reg32 {
		return 32
	}
	if reg in reg64 {
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
			return  0b0101
		}
		'ESI', 'RSI' {
			return 0b0110
		}
		'EDI', 'RDI' {
			return 0b0111
		} else {
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

	out := 0xc0 + (8 * s_n) + d_n

	return u8(out)
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
	panic('unknown label name `$name`')
}

pub fn (mut g Gen) encode(mut instrs []Instr) {
	for mut instr in instrs {
		mut src_size := 0
		mut trg_size := 0
		mut code := []u8{}

		match mut instr.kind {
			.movq {
				match mut instr.left_hs {
					// movq %reg, ...
					RegExpr {
						src_size = reg_size(instr.left_hs.lit)
						match mut instr.right_hs {
							// movq %reg, %reg
							RegExpr {
								trg_size = reg_size(instr.right_hs.lit)

								if src_size != 64 || src_size != trg_size {
									error.print(error.new_error(instr.pos, 'miss match size of operand'))
									exit(1)
								}
								// movq %reg, ...
								code << [ u8(0x48), u8(0x89), u8(calc_rm(instr.right_hs.lit, instr.left_hs.lit)) ]
							} else {
								panic('unreachable')
							}
						}
					}

					// movq $num, ...
					IntExpr {
						num := strconv.atoi(instr.left_hs.lit) or {
							panic('atoi() failed')
						}

						mut buf := [ u8(0), 0, 0, 0 ]
						binary.little_endian_put_u32(mut &buf, u32(num))

						match mut instr.right_hs {
							// movq $num, %reg
							RegExpr {
								trg_size = reg_size(instr.right_hs.lit)
								if trg_size != 64 {
									error.print(error.new_error(instr.right_hs.pos, 'miss match size of operand'))
									exit(1)
								}
								code << [ u8(0x48), u8(0xc7), u8(0xc0 + reg_bits(instr.right_hs.lit)) ]
								code << buf
							} else {
								panic('unreachable')
							}
						}
					} else {
						panic('unreachable')
					}
				}
				g.addr += code.len
			}
			
			.popq {
				match mut instr.left_hs {
					RegExpr {
						if !(instr.left_hs.lit in reg64) {
							error.print(error.new_error(instr.left_hs.pos, 'invalid operand for instruction'))
							exit(1)
						} else {
							code << u8(0x58 + reg_bits(instr.left_hs.lit))
						}
					} else {
						error.print(error.new_error(instr.left_hs.pos, 'invalid operand for instruction'))
						exit(1)
					}
				}
				g.addr += code.len
			}
			
			.pushq {
				match mut instr.left_hs {
					RegExpr {
						if !(instr.left_hs.lit in reg64) {
							error.print(error.new_error(instr.left_hs.pos, 'invalid operand for instruction'))
							exit(1)
						} else {
							code << u8(0x50 + reg_bits(instr.left_hs.lit))
						}
					}
					IntExpr {
						num := strconv.atoi(instr.left_hs.lit) or {
							panic('atoi() failed')
						}
						if num < 1 << 7 {
							code << [ u8(0x6a), u8(num) ]
						} else if num < 1 << 31 {
							mut hex := [ u8(0), 0, 0, 0 ]
							binary.little_endian_put_u32(mut &hex, u32(num))
							code << [ u8(0x68), hex[0], hex[1], hex[2], hex[3] ]
						} else {
							panic('unreachable')
						}
					} else  {
						panic('unreachable')
					}
				}
				g.addr += code.len
			}
			
			.addq {
				match mut instr.left_hs {
					// addq %reg, ...
					RegExpr {
						src_size = reg_size(instr.left_hs.lit)
						match mut instr.right_hs {
							// addq %reg, %reg
							RegExpr {
								trg_size = reg_size(instr.right_hs.lit)

								if src_size != 64 || src_size != trg_size {
									error.print(error.new_error(instr.pos, 'miss match size of operand'))
									exit(1)
								}
								code << [ u8(0x48), u8(0x01), u8(calc_rm(instr.right_hs.lit, instr.left_hs.lit)) ]
							} else {
								panic('unreachable')
							}
						}
					}
					IntExpr {
						match mut instr.right_hs {
							// addq $num, %reg
							RegExpr {
								trg_size = reg_size(instr.right_hs.lit)

								if trg_size != 64 {
									error.print(error.new_error(instr.pos, 'miss match size of operand'))
									exit(1)
								}

								num := strconv.atoi(instr.left_hs.lit) or {
									panic('atoi() failed')
								}

								mod_rm :=  u8(0xc0 + reg_bits(instr.right_hs.lit))

								if -128 <= num && num <= 127 {
									code << [ u8(0x48), 0x83, mod_rm, u8(num) ]
								} else if num < 1 << 31 {
									mut hex := [ u8(0), 0, 0, 0 ]
									binary.little_endian_put_u32(mut &hex, u32(num))
									if instr.right_hs.lit == 'RAX' {
										code << [ u8(0x48), 0x05, hex[0], hex[1], hex[2], hex[3] ]
									} else {
										code << [ u8(0x48), 0x81, mod_rm, hex[0], hex[1], hex[2], hex[3] ]
									}
								} else {
									panic('unreachable')
								}
							} else {
								panic('unreachable')
							}
						}
					} else {
						panic('unreachable')
					}
				}
				g.addr += code.len
			}

			.syscall {
				code << [ u8(0x0f), 0x05 ]
				g.addr += code.len
			}

			.label {
				match mut instr.left_hs {
					IdentExpr {
						if g.has_label(instr.left_hs.lit) {
							error.print(error.new_error(instr.pos, 'symbol `$instr.left_hs.lit` is already defined'))
							exit(1)
						} else {
							instr.addr = g.addr
							g.labels << instr
						}
					} else {
						error.print(error.new_error(instr.pos, 'must be an identifier'))
						exit(1)
					}
				}
			}

			.global, .local {
				// pass
			}
			
			.retq {
				code << 0xc3
				g.addr++
			}

			.nop {
				code << 0x90
				g.addr++
			}

			.callq {
				match mut instr.left_hs {
					IdentExpr {
						g.addr += 5
					}
					RegExpr {
						if reg_size(instr.left_hs.lit) != 64 {
							error.print(error.new_error(instr.pos, 'not supported in 64bit mode'))
							exit(1)
						}
						code << [ u8(0xff), u8(0xd0 + reg_bits(instr.left_hs.lit)) ]
						g.addr += code.len
					} else {
						error.print(error.new_error(instr.pos, 'invalid operand for instruction'))
						exit(1)
					}
				}
				instr.addr = g.addr
			}
		}
		instr.code = code
	}
}

pub fn (mut g Gen) write_code(instrs []Instr) {
	for instr in instrs {
		match instr.kind {
			.movq, .syscall, .retq, .nop, .popq, .pushq, .addq {
				g.code << instr.code
			}

			.callq {
				match instr.left_hs {
					IdentExpr {
						mut buf := [ u8(0), 0, 0, 0 ]
						label := g.get_label(instr.left_hs.lit)
						binary.little_endian_put_u32(mut &buf, u32(label.addr - instr.addr))
						g.code << 0xe8
						g.code << buf
					}
					RegExpr {
						g.code << instr.code
					} else {}
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
					} else {
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
					} else {
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


