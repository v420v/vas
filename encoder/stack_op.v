module encoder

import error
import encoding.binary

fn (mut e Encoder) pop() {
	mut instr := Instr{kind: .pop, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()

	if source is Register {
		source.check_regi_size(.suffix_quad)
		regi_index_over_8 := [Regi.r8, .r9, .r10, .r11, .r12, .r13, .r14, .r15]
		if source.kind in regi_index_over_8 {
			instr.code << rex(0, 0, 0, 1)
		}
		instr.code << [0x58 + source.regi_bits()]
		return
	}
	if source is Indirection {
		instr.add_segment_override_prefix(source)
		mut x, mut b := u8(0), u8(0)
		regi_index_over_8 := [Regi.r8, .r9, .r10, .r11, .r12, .r13, .r14, .r15]
		if source.index.kind in regi_index_over_8 {
			x = 1
		}
		if source.base.kind in regi_index_over_8 {
			b = 1
		}
		if x != 0 || b != 0 {
			instr.code << rex(0, 0, x, b)
		}
		instr.code << 0x8f // op_code
		instr.add_modrm_sib_disp(source, encoder.slash_0)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) push() {
	mut instr := Instr{kind: .push, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()

	if source is Register {
		source.check_regi_size(.suffix_quad)
		regi_index_over_8 := [Regi.r8, .r9, .r10, .r11, .r12, .r13, .r14, .r15]
		if source.kind in regi_index_over_8 {
			instr.code << rex(0, 0, 0, 1)
		}
		source.check_regi_size(.suffix_quad)
		instr.code = [0x50 + source.regi_bits()]
		return
	}
	if source is Indirection {
		instr.add_segment_override_prefix(source)
		mut x, mut b := u8(0), u8(0)
		regi_index_over_8 := [Regi.r8, .r9, .r10, .r11, .r12, .r13, .r14, .r15]
		if source.index.kind in regi_index_over_8 {
			x = 1
		}
		if source.base.kind in regi_index_over_8 {
			b = 1
		}
		if x != 0 || b != 0 {
			instr.code << rex(0, 0, x, b)
		}
		instr.code << 0xff // op_code
		instr.add_modrm_sib_disp(source, encoder.slash_6)
		return
	}
	if source is Immediate {
		mut used_symbols := []string{}
		imm_val := eval_expr_get_symbol(source, mut used_symbols)
		if used_symbols.len >= 2 {
			error.print(source.pos, 'invalid immediate operand')
			exit(1)
		}
		imm_need_rela := used_symbols.len == 1
		if imm_need_rela {
			instr.code << [u8(0x68), 0, 0, 0, 0]
			rela_text_users << &Rela{
				uses: used_symbols[0],
				instr: &instr,
				offset: 0x1,
				rtype: encoder.r_x86_64_32s,
				adjust: imm_val,
			}
		} else {
			if is_in_i8_range(imm_val) {
				instr.code = [u8(0x6a), u8(imm_val)]
			} else if is_in_i32_range(imm_val) {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(imm_val))
				instr.code = [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
			}
		}
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) call() {
	instr := Instr{kind: .call, pos: e.tok.pos, section: e.current_section, code: [u8(0xe8), 0, 0, 0, 0]}

	desti := e.parse_operand()

	mut used_symbols := []string{}
	adjust := eval_expr_get_symbol(desti, mut used_symbols)
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand for instruction')
		exit(1)
	}

	rela_text_users << encoder.Rela{
		instr:  &instr,
		offset: 1,
		uses:   used_symbols[0],
		adjust: adjust,
		rtype:   encoder.r_x86_64_plt32
	}
	e.instrs[e.current_section] << &instr
}

