module encoder

import error
import encoding.binary

fn (mut e Encoder) pop() {
	mut instr := Instr{kind: .pop, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()

	if source is Register {
		source.check_regi_size(.suffix_quad)
		if source.lit in r8_r15 {
			instr.code << rex(0, 0, 0, 1)
		}
		instr.code << [0x58 + source.regi_bits()]
		return
	}
	if source is Indirection {
		instr.add_segment_override_prefix(source)
		mut x, mut b := u8(0), u8(0)
		if source.index.lit in r8_r15 {
			x = 1
		}
		if source.base.lit in r8_r15 {
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
		if source.lit in r8_r15 {
			instr.code << rex(0, 0, 0, 1)
		}
		source.check_regi_size(.suffix_quad)
		instr.code = [0x50 + source.regi_bits()]
		return
	}
	if source is Indirection {
		instr.add_segment_override_prefix(source)
		mut x, mut b := u8(0), u8(0)
		if source.index.lit in r8_r15 {
			x = 1
		}
		if source.base.lit in r8_r15 {
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

fn (mut e Encoder) jmp_instr(kind InstrKind, rel8_code []u8, rel8_offset i64, rel32_code []u8, rel32_offset i64) {
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

