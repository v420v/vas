module encoder

import error
import encoding.binary

fn (mut e Encoder) section() {
	pos := e.tok.pos

	section_name := e.tok.lit
	e.current_section = section_name

	e.next()
	e.expect(.comma)
	section_flags := e.tok.lit
	e.expect(.string)

	instr := Instr{kind: .section, pos: pos, section: section_name, symbol_type: encoder.stt_section, flags: section_flags}

	if s := user_defined_symbols[section_name] {
		if s.kind == .label {
			error.print(pos, 'symbol `$section_name` is already defined')
			exit(1)
		}
	} else {
		user_defined_symbols[section_name] = &instr
	}

	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) zero() {
	operand := e.parse_operand()

	n := eval_expr(operand)

	mut instr := Instr{kind: .string, pos: e.tok.pos, section: e.current_section}
	e.instrs[e.current_section] << &instr

	for _ in 0..n {
		instr.code << 0
	}
}

fn (mut e Encoder) string() {
	pos := e.tok.pos

	mut instr := Instr{kind: .string, pos: pos, section: e.current_section}

	value := e.tok.lit
	e.expect(.string)

	instr.code = value.bytes()
	instr.code << 0x00
	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) byte() {
	desti := e.parse_operand()

	mut instr := Instr{kind: .byte, pos: desti.pos, section: e.current_section}

	mut used_symbols := []string{}
	adjust := eval_expr_get_symbol(desti, mut used_symbols)
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		rela := &Rela{
			uses: used_symbols[0],
			instr: &instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_8
		}
		instr.code = [u8(0)]
		rela_text_users << rela
	} else {
		instr.code << u8(adjust)
	}
	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) word() {
	desti := e.parse_operand()

	mut instr := Instr{kind: .word, pos: desti.pos, section: e.current_section}

	mut used_symbols := []string{}
	adjust := eval_expr_get_symbol(desti, mut used_symbols)
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		rela := &Rela{
			uses: used_symbols[0],
			instr: &instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_16
		}
		instr.code = [u8(0), 0]
		rela_text_users << rela
	} else {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(adjust))
		instr.code = hex
	}
	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) long() {
	desti := e.parse_operand()

	mut instr := Instr{kind: .long, pos: desti.pos, section: e.current_section}

	mut used_symbols := []string{}
	adjust := eval_expr_get_symbol(desti, mut used_symbols)
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		rela := &Rela{
			uses: used_symbols[0],
			instr: &instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_32
		}
		instr.code = [u8(0), 0, 0, 0]
		rela_text_users << rela
	} else {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(adjust))
		instr.code = hex
	}
	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) quad() {
	desti := e.parse_operand()

	mut instr := Instr{kind: .quad, pos: desti.pos, section: e.current_section}

	mut used_symbols := []string{}
	adjust := eval_expr_get_symbol(desti, mut used_symbols)
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		rela := &Rela{
			uses: used_symbols[0],
			instr: &instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_64
		}
		instr.code = [u8(0), 0, 0, 0, 0, 0, 0, 0]
		rela_text_users << rela
	} else {
		mut hex := [u8(0), 0, 0, 0, 0, 0, 0, 0]
		binary.little_endian_put_u64(mut &hex, u64(adjust))
		instr.code = hex
	}
	e.instrs[e.current_section] << &instr
}


