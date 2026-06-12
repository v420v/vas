module encoder

import encoding.binary

// add_imm_rela emits a placeholder of `size` bytes for an immediate that
// references a symbol, plus the relocation entry the linker needs.
fn (mut e Encoder) add_imm_rela(symbol string, imm_val int, size DataSize) {
	mut rela := Rela{
		uses:   symbol
		instr:  e.current_instr
		adjust: imm_val
		offset: e.current_instr.code.len
	}
	match size {
		.suffix_byte {
			rela.rtype = encoder.r_x86_64_8
			e.current_instr.code << u8(0)
		}
		.suffix_word {
			rela.rtype = encoder.r_x86_64_16
			e.current_instr.code << [u8(0), 0]
		}
		.suffix_long {
			rela.rtype = encoder.r_x86_64_32
			e.current_instr.code << [u8(0), 0, 0, 0]
		}
		.suffix_quad {
			rela.rtype = encoder.r_x86_64_32s
			e.current_instr.code << [u8(0), 0, 0, 0]
		}
		else {}
	}
	e.rela_text_users << rela
}

// add_imm_value2 emits a numeric immediate at its full width (no sign-extend
// short form). The table-driven encoder uses this for every immediate slot.
fn (mut e Encoder) add_imm_value2(imm_val int, size DataSize) {
	if size == DataSize.suffix_byte {
		e.current_instr.code << [u8(imm_val)]
	} else if size == DataSize.suffix_word {
		mut hex := [u8(0), 0]
		binary.little_endian_put_u16(mut &hex, u16(imm_val))
		e.current_instr.code << [hex[0], hex[1]]
	} else {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(imm_val))
		e.current_instr.code << [hex[0], hex[1], hex[2], hex[3]]
	}
}
