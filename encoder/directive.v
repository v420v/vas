module encoder

import token
import error
import encoding.binary

fn (mut e Encoder) add_section(name string, flag string, pos token.Position) {
	e.current_section = name

	instr := Instr{kind: .section, pos: pos, section: name, symbol_type: encoder.stt_section, flags: flag}
	e.instrs[e.current_section] << &instr

	if s := user_defined_symbols[name] {
		if s.kind == .label {
			error.print(pos, 'symbol `$name` is already defined')
			exit(1)
		}
	} else {
		user_defined_symbols[name] = &instr
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
	mut instr := Instr{kind: .string, pos: e.tok.pos, section: e.current_section}
	e.instrs[e.current_section] << &instr

	operand := e.parse_operand()

	n := eval_expr(operand)

	for _ in 0..n {
		instr.code << 0
	}
}

fn (mut e Encoder) string() {
	mut instr := Instr{kind: .string, pos: e.tok.pos, section: e.current_section}
	e.instrs[e.current_section] << &instr

	value := e.tok.lit
	e.expect(.string)

	instr.code = value.bytes()
	instr.code << 0x00
}

fn (mut e Encoder) byte() {
	mut instr := Instr{kind: .byte, pos: e.tok.pos, section: e.current_section}
	e.instrs[e.current_section] << &instr

	desti := e.parse_operand()

	mut used_symbols := []string{}
	adjust := eval_expr_get_symbol(desti, mut used_symbols)
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		rela_text_users << &Rela{
			uses: used_symbols[0],
			instr: &instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_8
		}
		instr.code = [u8(0)]
	} else {
		instr.code << u8(adjust)
	}
}

fn (mut e Encoder) word() {
	mut instr := Instr{kind: .word, pos: e.tok.pos, section: e.current_section}
	e.instrs[e.current_section] << &instr

	desti := e.parse_operand()

	mut used_symbols := []string{}
	adjust := eval_expr_get_symbol(desti, mut used_symbols)
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		rela_text_users << &Rela{
			uses: used_symbols[0],
			instr: &instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_16
		}
		instr.code = [u8(0), 0]
	} else {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(adjust))
		instr.code = hex
	}
}

fn (mut e Encoder) long() {
	mut instr := Instr{kind: .long, pos: e.tok.pos, section: e.current_section}
	e.instrs[e.current_section] << &instr

	desti := e.parse_operand()

	mut used_symbols := []string{}
	adjust := eval_expr_get_symbol(desti, mut used_symbols)
	if used_symbols.len >= 2 {
		error.print(desti.pos, 'invalid operand')
		exit(1)
	}

	if used_symbols.len == 1 {
		rela_text_users << &Rela{
			uses: used_symbols[0],
			instr: &instr,
			adjust: adjust,
			rtype: encoder.r_x86_64_32
		}
		instr.code = [u8(0), 0, 0, 0]
	} else {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(adjust))
		instr.code = hex
	}
}

fn (mut e Encoder) quad() {
	mut instr := Instr{kind: .quad, pos: e.tok.pos, section: e.current_section}
	e.instrs[e.current_section] << &instr

	desti := e.parse_operand()

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
}


