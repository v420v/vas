module gen

import instruction
import error

import encoding.binary
import strconv

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

fn (mut g Gen) get_label(name string) &instruction.Instruction {
	for i, l in g.labels {
		if l.left_hs.lit == name {
			return &g.labels[i]
		}
	}
	panic('unknown label name `$name`')
}

pub fn (mut g Gen) gen(mut instrs []instruction.Instruction) {
	for mut instr in instrs {
		mut src_size := 0
		mut trg_size := 0
		mut code := []u8{}

		match mut instr.instr_name {
			'MOVQ' {
				match mut instr.left_hs {
					// movq %reg, ...
					instruction.RegExpr {
						src_size = reg_size(instr.left_hs.lit)
						match mut instr.right_hs {
							// movq %reg, %reg
							instruction.RegExpr {
								trg_size = reg_size(instr.right_hs.lit)

								if src_size != 64 || src_size != trg_size {
									g.errors << error.new_error(instr.pos, 'miss match size of operand')
								}
								// movq %reg, ...
								code << [ u8(0x48), u8(0x89), u8(calc_rm(instr.right_hs.lit, instr.left_hs.lit)) ]
							} else {
								panic('unreachable')
							}
						}
					}

					// movq $num, ...
					instruction.IntExpr {
						num := strconv.atoi(instr.left_hs.lit) or {
							panic('atoi() failed')
						}

						mut buf := [ u8(0), 0, 0, 0 ]
						binary.little_endian_put_u32(mut &buf, u32(num))

						match mut instr.right_hs {
							// movq $num, %reg
							instruction.RegExpr {
								trg_size = reg_size(instr.right_hs.lit)
								if trg_size != 64 {
									g.errors << error.new_error(instr.right_hs.pos, 'miss match size of operand')
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
				g.offset += code.len
			}
			'POPQ' {
				match mut instr.left_hs {
					instruction.RegExpr {
						if !(instr.left_hs.lit in reg64) {
							g.errors << error.new_error(instr.left_hs.pos, 'invalid operand for instruction')
						} else {
							code << u8(0x58 + reg_bits(instr.left_hs.lit))
						}
					} else {
						g.errors << error.new_error(instr.left_hs.pos, 'invalid operand for instruction')
					}
				}
				g.offset += code.len
			}
			'PUSHQ' {
				match mut instr.left_hs {
					instruction.RegExpr {
						if !(instr.left_hs.lit in reg64) {
							g.errors << error.new_error(instr.left_hs.pos, 'invalid operand for instruction')
						} else {
							code << u8(0x50 + reg_bits(instr.left_hs.lit))
						}
					}
					instruction.IntExpr {
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
				g.offset += code.len
			}
			'MOVL' {
				g.errors << error.new_error(instr.pos, 'instruction not implemented yet')
			}
			'SYSCALL' {
				code << [ u8(0x0f), 0x05 ]
				g.offset += code.len
			}
			'LABEL' {
				match mut instr.left_hs {
					instruction.IdentExpr {
						if g.has_label(instr.left_hs.lit) {
							g.errors << error.new_error(instr.pos, 'symbol `$instr.left_hs.lit` is already defined')
						} else {
							instr.offset = g.offset
							g.labels << instr
						}
					} else {
						g.errors << error.new_error(instr.pos, 'must be an identifier')
					}
				}
			}
			'.GLOBAL' {
				// pass
			}
			'RETQ' {
				code << 0xc3
				g.offset++
			}
			'NOP' {
				code << 0x90
				g.offset++
			}
			'CALLQ' {
				match mut instr.left_hs {
					instruction.IdentExpr {
						g.offset += 5
					}
					instruction.RegExpr {
						if reg_size(instr.left_hs.lit) != 64 {
							g.errors << error.new_error(instr.pos, 'not supported in 64bit mode')
						}
						code << [ u8(0xff), u8(0xd0 + reg_bits(instr.left_hs.lit)) ]
						g.offset += code.len
					} else {
						g.errors << error.new_error(instr.pos, 'invalid operand for instruction')
					}
				}
				instr.offset = g.offset
			} else {
				panic('unreachable')
			}
		}
		instr.code = code
	}
}

pub fn (mut g Gen) write_code(instrs []instruction.Instruction) {
	for instr in instrs {
		match instr.instr_name {
			'MOVQ', 'SYSCALL', 'RETQ', 'NOP', 'POPQ', 'PUSHQ' {
				g.code << instr.code
			}
			'CALLQ' {
				match instr.left_hs {
					instruction.IdentExpr {
						mut buf := [ u8(0), 0, 0, 0 ]
						label := g.get_label(instr.left_hs.lit)
						binary.little_endian_put_u32(mut &buf, u32(label.offset - instr.offset))
						g.code << 0xe8
						g.code << buf
					}
					instruction.RegExpr {
						g.code << instr.code
					} else {}
				}
			}
			'.GLOBAL' {
				match instr.left_hs {
					instruction.IdentExpr {
						if g.has_label(instr.left_hs.lit) {
							mut l := g.get_label(instr.left_hs.lit)
							l.binding = stb_global
							g.globals_count++
						}
					} else {
						g.errors << error.new_error(instr.left_hs.pos, 'must be an identifier')
					}
				}
			}
			'.LOCAL' {
				match instr.left_hs {
					instruction.IdentExpr {
						if g.has_label(instr.left_hs.lit) {
							mut l := g.get_label(instr.left_hs.lit)
							if l.binding == stb_global {
								g.globals_count--
							}
							l.binding = stb_local
						}
					} else {
						g.errors << error.new_error(instr.left_hs.pos, 'must be an identifier')
					}
				}
			}
			'LABEL' {} // pass
			else {}
		}
	}

	padding := (align_to(g.code.len, 32) - g.code.len)
	for _ in 0 .. padding {
		g.code << 0
	}
}


