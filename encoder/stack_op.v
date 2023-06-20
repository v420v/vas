module encoder

import error
import encoding.binary

fn (mut e Encoder) pop() {
	mut instr := Instr{kind: .pop, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()

	if source is Register {
		source.check_regi_size(.suffix_quad)
		instr.add_rex_prefix('', '', source.lit, [])
		instr.code << [0x58 + source.regi_bits()]
		return
	}
	if source is Indirection {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix('', source.index.lit, source.base.lit, [])
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
		instr.code << [0x50 + source.regi_bits()]
		return
	}
	if source is Indirection {
		instr.add_segment_override_prefix(source)
		instr.add_rex_prefix('', source.index.lit, source.base.lit, [])
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

fn (mut e Encoder) jmp_instr(kind InstrKind, rel32_code []u8, rel32_offset i64) {
	mut instr := Instr{kind: kind, section: e.current_section, is_jmp_or_call: true, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	desti := e.parse_operand()

	if desti is Ident {
		instr.code << rel32_code
		rela_text_users << &Rela{
			uses: desti.lit,
			instr: &instr,
			offset: rel32_offset,
			rtype: encoder.r_x86_64_32s,
			adjust: 0,
		}
		return
	}
	if desti is Star {
		desti.regi.check_regi_size(DataSize.suffix_quad)
		if desti.regi.lit in r8_r15 {
			instr.code << 0x41
		}
		instr.code << [u8(0xFF), 0xE0 + desti.regi.regi_bits()]
		return
	}

	error.print(desti.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) call() {
	mut instr := Instr{kind: .call, pos: e.tok.pos, section: e.current_section, is_jmp_or_call: true}
	e.instrs[e.current_section] << &instr

	desti := e.parse_operand()

	if desti is Star {
		desti.regi.check_regi_size(DataSize.suffix_quad)
		if desti.regi.lit in r8_r15 {
			instr.code << 0x41
		}
		instr.code << [u8(0xFF), 0xD0 + desti.regi.regi_bits()]
	} else {
		instr.code << [u8(0xe8), 0, 0, 0, 0]
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
	}
}

