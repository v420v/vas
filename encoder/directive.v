module encoder

import token
import error
import encoding.binary

fn (mut e Encoder) add_section(section_name string, flag string, pos token.Position) {
	e.current_section_name = section_name

	instr := Instr{kind: .section, pos: pos, section_name: section_name, symbol_type: encoder.stt_section, flags: flag}
	e.instrs << &instr

	if s := e.user_defined_symbols[section_name] {
		if s.kind == .label {
			error.print(pos, 'symbol `$section_name` is already defined')
			exit(1)
		}
	} else {
		e.user_defined_symbols[section_name] = &instr
	}
}

fn (mut e Encoder) section() {
	pos := e.tok.pos

	section_name := e.tok.lit

	e.next()
	e.expect(.comma)
	section_flags := e.tok.lit
	e.expect(.string)

	e.add_section(section_name, section_flags, pos)
}

fn (mut e Encoder) zero() {
	e.set_current_instr(.zero)

	operand := e.parse_operand()

	n := eval_expr(operand)

	for _ in 0..n {
		e.current_instr.code << 0
	}
}

fn (mut e Encoder) string() {
	e.set_current_instr(.string)

	value := e.tok.lit
	e.expect(.string)

	e.current_instr.code = value.bytes()
	e.current_instr.code << 0x00
}

fn (mut e Encoder) byte() {
	e.set_current_instr(.byte)

	desti := e.parse_operand()

	mut used_symbols := []string{}
	adjust := int(eval_expr_get_symbol_64(desti, mut used_symbols))
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		e.rela_text_users << &Rela{
			uses: used_symbols[0],
			instr: e.current_instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_8
		}
		e.current_instr.code = [u8(0)]
	} else {
		e.current_instr.code << u8(adjust)
	}
}

fn (mut e Encoder) word() {
	e.set_current_instr(.word)

	desti := e.parse_operand()

	mut used_symbols := []string{}
	adjust := int(eval_expr_get_symbol_64(desti, mut used_symbols))
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		e.rela_text_users << &Rela{
			uses: used_symbols[0],
			instr: e.current_instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_16
		}
		e.current_instr.code = [u8(0), 0]
	} else {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(adjust))
		e.current_instr.code = hex
	}
}

fn (mut e Encoder) long() {
	e.set_current_instr(.long)

	desti := e.parse_operand()

	mut used_symbols := []string{}
	adjust := int(eval_expr_get_symbol_64(desti, mut used_symbols))
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		e.rela_text_users << &Rela{
			uses: used_symbols[0],
			instr: e.current_instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_32
		}
		e.current_instr.code = [u8(0), 0, 0, 0]
	} else {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(adjust))
		e.current_instr.code = hex
	}
}

fn (mut e Encoder) quad() {
	e.set_current_instr(.quad)

	desti := e.parse_operand()

	mut used_symbols := []string{}
	adjust := int(eval_expr_get_symbol_64(desti, mut used_symbols))
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		rela := &Rela{
			uses: used_symbols[0],
			instr: e.current_instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_64
		}
		e.current_instr.code = [u8(0), 0, 0, 0, 0, 0, 0, 0]
		e.rela_text_users << rela
	} else {
		mut hex := [u8(0), 0, 0, 0, 0, 0, 0, 0]
		binary.little_endian_put_u64(mut &hex, u64(adjust))
		e.current_instr.code = hex
	}
}


