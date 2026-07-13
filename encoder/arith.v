module encoder

import encoding.binary

// add_imm_rela emits a placeholder of `size` bytes for an immediate that
// references a symbol, plus the relocation entry the linker needs.
//
// `sign_extended` selects R_X86_64_32S over R_X86_64_32 for a 4-byte
// immediate that the CPU sign-extends to 64 bits (e.g. `movq $sym, %reg64`,
// C7 /0 id, and other REX.W instructions with an imm32). It has no effect on
// the other widths, which have no signed relocation variant.
fn (mut e Encoder) add_imm_rela(symbol string, imm_val int, size DataSize, sign_extended bool) {
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
			rela.rtype = if sign_extended { encoder.r_x86_64_32s } else { encoder.r_x86_64_32 }
			e.current_instr.code << [u8(0), 0, 0, 0]
		}
		.suffix_quad {
			rela.rtype = encoder.r_x86_64_64
			e.current_instr.code << [u8(0), 0, 0, 0, 0, 0, 0, 0]
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
