module encoder

import error
import encoding.binary

// pop
fn (mut e Encoder) pop() {
	mut instr := Instr{kind: .pop, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()

	if source is Register {
		source.check_regi_size(.suffix_quad)
		instr.code = [0x58 + regi_bits(source)]
		return
	}
	if source is Indirection {
		if source.base_or_index_is_long() {
			instr.code << 0x67
		}
		instr.code << 0x8f // op_code
		mod_rm_sib, disp, mut rela_text_user := e.calculate_modrm_sib_disp(source, encoder.slash_0)
		instr.code << mod_rm_sib
		if rela_text_user != unsafe {nil} {
			rela_text_user.assign_offset_to_rela(instr.code.len, &instr)
			e.rela_text_users << rela_text_user
		}
		instr.code << disp
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// push
fn (mut e Encoder) push() {
	mut instr := Instr{kind: .push, section: e.current_section, pos: e.tok.pos}
	e.instrs[e.current_section] << &instr

	source := e.parse_operand()

	if source is Register {
		source.check_regi_size(.suffix_quad)
		instr.code = [0x50 + regi_bits(source)]
		return
	}
	if source is Immediate {
		imm_val := eval_expr(source.expr)
		if is_in_i8_range(imm_val) {
			instr.code = [u8(0x6a), u8(imm_val)]
		} else if is_in_i32_range(imm_val) {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(imm_val))
			instr.code = [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
		}
		return
	}
	if source is Indirection {
		if source.base_or_index_is_long() {
			instr.code << 0x67
		}
		instr.code << u8(0xff) // op_code
		mod_rm_sib, disp, mut rela_text_user := e.calculate_modrm_sib_disp(source, encoder.slash_6)
		instr.code << mod_rm_sib
		if rela_text_user != unsafe {nil} {
			rela_text_user.assign_offset_to_rela(instr.code.len, &instr)
			e.rela_text_users << rela_text_user
		}
		instr.code << disp
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

// call
fn (mut e Encoder) call() {
	instr := Instr{kind: .call, pos: e.tok.pos, section: e.current_section, code: [u8(0xe8), 0, 0, 0, 0]}

	desti := e.parse_operand()

	mut used_symbols := []string{}
	adjust := eval_expr_get_symbol(desti, mut used_symbols)
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand for instruction')
		exit(1)
	}

	e.rela_text_users << encoder.RelaTextUser{
		instr:  &instr,
		offset: 1,
		uses:   used_symbols[0],
		adjust: adjust,
		rtype:   encoder.r_x86_64_plt32
	}
	e.instrs[e.current_section] << &instr
}

