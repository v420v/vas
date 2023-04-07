module encoder

import error
import encoding.binary

fn (mut e Encoder) pop() {
	source := e.parse_operand()

	if source is Register {
		mut instr := Instr{kind: .pop, pos: source.pos, section: e.current_section}
		check_regi_size(source, encoder.suffix_quad)
		instr.code = [0x58 + regi_bits(source)]
		e.instrs[e.current_section] << &instr
		return
	}
	if source is Indirection {
		e.encode_indir(.pop, [u8(0x8f)], slash_0, source, encoder.suffix_quad)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) push() {
	source := e.parse_operand()

	if source is Register {
		mut instr := Instr{kind: .push, pos: source.pos, section: e.current_section}
		check_regi_size(source, encoder.suffix_quad)
		instr.code = [0x50 + regi_bits(source)]
		e.instrs[e.current_section] << &instr
		return
	}
	if source is Immediate {
		mut instr := Instr{kind: .push, pos: source.pos, section: e.current_section}
		num := eval_expr(source.expr)
		if is_in_i8_range(num) {
			instr.code = [u8(0x6a), u8(num)]
		} else if is_in_i32_range(num) {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			instr.code = [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
		}
		e.instrs[e.current_section] << &instr
		return
	}
	if source is Indirection {
		e.encode_indir(.push, [u8(0xff)], slash_6, source, encoder.suffix_quad)
		return
	}

	error.print(source.pos, 'invalid operand for instruction')
	exit(1)
}

fn (mut e Encoder) call() {
	instr := Instr{kind: .call, pos: e.tok.pos, section: e.current_section, code: [u8(0xe8), 0, 0, 0, 0]}

	source := e.parse_operand()
	adjust := eval_expr(source)

	mut used_symbols := []string{}
	e.get_symbol_from_binop(source, mut &used_symbols)
	if used_symbols.len >= 2 || used_symbols.len == 0 {
		error.print(source.pos, 'invalid operand for instruction')
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

