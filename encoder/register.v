module encoder

const general_registers = {
	'RAX': Register{lit: 'RAX', base_offset: 0, size: .suffix_quad}
	'RCX': Register{lit: 'RCX', base_offset: 1, size: .suffix_quad}
	'RDX': Register{lit: 'RDX', base_offset: 2, size: .suffix_quad}
	'RBX': Register{lit: 'RBX', base_offset: 3, size: .suffix_quad}
	'RSP': Register{lit: 'RSP', base_offset: 4, size: .suffix_quad}
	'RBP': Register{lit: 'RBP', base_offset: 5, size: .suffix_quad}
	'RSI': Register{lit: 'RSI', base_offset: 6, size: .suffix_quad}
	'RDI': Register{lit: 'RDI', base_offset: 7, size: .suffix_quad}
	'R8': Register{lit: 'R8', base_offset: 8, size: .suffix_quad}
	'R9': Register{lit: 'R9', base_offset: 9, size: .suffix_quad}
	'R10': Register{lit: 'R10', base_offset: 10, size: .suffix_quad}
	'R11': Register{lit: 'R11', base_offset: 11, size: .suffix_quad}
	'R12': Register{lit: 'R12', base_offset: 12, size: .suffix_quad}
	'R13': Register{lit: 'R13', base_offset: 13, size: .suffix_quad}
	'R14': Register{lit: 'R14', base_offset: 14, size: .suffix_quad}
	'R15': Register{lit: 'R15', base_offset: 15, size: .suffix_quad}

	'EAX': Register{lit: 'EAX', base_offset: 0, size: .suffix_long}
	'ECX': Register{lit: 'ECX', base_offset: 1, size: .suffix_long}
	'EDX': Register{lit: 'EDX', base_offset: 2, size: .suffix_long}
	'EBX': Register{lit: 'EBX', base_offset: 3, size: .suffix_long}
	'ESP': Register{lit: 'ESP', base_offset: 4, size: .suffix_long}
	'EBP': Register{lit: 'EBP', base_offset: 5, size: .suffix_long}
	'ESI': Register{lit: 'ESI', base_offset: 6, size: .suffix_long}
	'EDI': Register{lit: 'EDI', base_offset: 7, size: .suffix_long}
	'R8D': Register{lit: 'R8D', base_offset: 8, size: .suffix_long}
	'R9D': Register{lit: 'R9D', base_offset: 9, size: .suffix_long}
	'R10D': Register{lit: 'R10D', base_offset: 10, size: .suffix_long}
	'R11D': Register{lit: 'R11D', base_offset: 11, size: .suffix_long}
	'R12D': Register{lit: 'R12D', base_offset: 12, size: .suffix_long}
	'R13D': Register{lit: 'R13D', base_offset: 13, size: .suffix_long}
	'R14D': Register{lit: 'R14D', base_offset: 14, size: .suffix_long}
	'R15D': Register{lit: 'R15D', base_offset: 15, size: .suffix_long}

	'AX': Register{lit: 'AX', base_offset: 0, size: .suffix_word}
	'CX': Register{lit: 'CX', base_offset: 1, size: .suffix_word}
	'DX': Register{lit: 'DX', base_offset: 2, size: .suffix_word}
	'BX': Register{lit: 'BX', base_offset: 3, size: .suffix_word}
	'SP': Register{lit: 'SP', base_offset: 4, size: .suffix_word}
	'SI': Register{lit: 'SI', base_offset: 6, size: .suffix_word}
	'DI': Register{lit: 'DI', base_offset: 7, size: .suffix_word}
	'R8W': Register{lit: 'R8W', base_offset: 8, size: .suffix_word}
	'R9W': Register{lit: 'R9W', base_offset: 9, size: .suffix_word}
	'R10W': Register{lit: 'R10W', base_offset: 10, size: .suffix_word}
	'R11W': Register{lit: 'R11W', base_offset: 11, size: .suffix_word}
	'R12W': Register{lit: 'R12W', base_offset: 12, size: .suffix_word}
	'R13W': Register{lit: 'R13W', base_offset: 13, size: .suffix_word}
	'R14W': Register{lit: 'R14W', base_offset: 14, size: .suffix_word}
	'R15W': Register{lit: 'R15W', base_offset: 15, size: .suffix_word}

	'AL': Register{lit: 'AL', base_offset: 0, size: .suffix_byte}
	'CL': Register{lit: 'CL', base_offset: 1, size: .suffix_byte}
	'DL': Register{lit: 'DL', base_offset: 2, size: .suffix_byte}
	'BL': Register{lit: 'BL', base_offset: 3, size: .suffix_byte}
	'AH': Register{lit: 'AH', base_offset: 4, size: .suffix_byte}
	'BP': Register{lit: 'BP', base_offset: 5, size: .suffix_byte}
	'CH': Register{lit: 'CH', base_offset: 5, size: .suffix_byte}
	'DH': Register{lit: 'DH', base_offset: 6, size: .suffix_byte}
	'BH': Register{lit: 'BH', base_offset: 7, size: .suffix_byte}
	'SPL': Register{lit: 'SPL', base_offset: 4, size: .suffix_byte, rex_required: true}
	'SIL': Register{lit: 'SIL', base_offset: 6, size: .suffix_byte, rex_required: true}
	'BPL': Register{lit: 'BPL', base_offset: 5, size: .suffix_byte, rex_required: true}
	'DIL': Register{lit: 'DIL', base_offset: 7, size: .suffix_byte, rex_required: true}
	'R8B': Register{lit: 'R8B', base_offset: 8, size: .suffix_byte}
	'R9B': Register{lit: 'R9B', base_offset: 9, size: .suffix_byte}
	'R10B': Register{lit: 'R10B', base_offset: 10, size: .suffix_byte}
	'R11B': Register{lit: 'R11B', base_offset: 11, size: .suffix_byte}
	'R12B': Register{lit: 'R12B', base_offset: 12, size: .suffix_byte}
	'R13B': Register{lit: 'R13B', base_offset: 13, size: .suffix_byte}
	'R14B': Register{lit: 'R14B', base_offset: 14, size: .suffix_byte}
	'R15B': Register{lit: 'R15B', base_offset: 15, size: .suffix_byte}

	'RIP': Register{lit: 'RIP', base_offset: 0, size: .suffix_quad}
	'EIP': Register{lit: 'EIP', base_offset: 0, size: .suffix_long}
	'IP': Register{lit: 'IP', base_offset: 0, size: .suffix_word}

	// Segment registers. In 64-bit mode CS/DS/ES/SS are typically null and
	// rarely used as overrides, but FS/GS carry TLS bases so clang/gcc
	// emit `%fs:disp(...)` for thread-local storage. parse_operand pivots
	// to memory parsing when it sees one of these followed by `:`.
	'CS': Register{lit: 'CS', base_offset: 0, size: .suffix_seg}
	'DS': Register{lit: 'DS', base_offset: 0, size: .suffix_seg}
	'ES': Register{lit: 'ES', base_offset: 0, size: .suffix_seg}
	'SS': Register{lit: 'SS', base_offset: 0, size: .suffix_seg}
	'FS': Register{lit: 'FS', base_offset: 0, size: .suffix_seg}
	'GS': Register{lit: 'GS', base_offset: 0, size: .suffix_seg}
}

// XMM and YMM registers are stored in the same map. Their `size` field
// distinguishes them so the classifier can return xmmreg vs ymmreg.
const xmm_registers = {
	'XMM0':  Xmm{lit: 'XMM0',  base_offset: 0,  size: .suffix_xmm128}
	'XMM1':  Xmm{lit: 'XMM1',  base_offset: 1,  size: .suffix_xmm128}
	'XMM2':  Xmm{lit: 'XMM2',  base_offset: 2,  size: .suffix_xmm128}
	'XMM3':  Xmm{lit: 'XMM3',  base_offset: 3,  size: .suffix_xmm128}
	'XMM4':  Xmm{lit: 'XMM4',  base_offset: 4,  size: .suffix_xmm128}
	'XMM5':  Xmm{lit: 'XMM5',  base_offset: 5,  size: .suffix_xmm128}
	'XMM6':  Xmm{lit: 'XMM6',  base_offset: 6,  size: .suffix_xmm128}
	'XMM7':  Xmm{lit: 'XMM7',  base_offset: 7,  size: .suffix_xmm128}
	'XMM8':  Xmm{lit: 'XMM8',  base_offset: 8,  size: .suffix_xmm128}
	'XMM9':  Xmm{lit: 'XMM9',  base_offset: 9,  size: .suffix_xmm128}
	'XMM10': Xmm{lit: 'XMM10', base_offset: 10, size: .suffix_xmm128}
	'XMM11': Xmm{lit: 'XMM11', base_offset: 11, size: .suffix_xmm128}
	'XMM12': Xmm{lit: 'XMM12', base_offset: 12, size: .suffix_xmm128}
	'XMM13': Xmm{lit: 'XMM13', base_offset: 13, size: .suffix_xmm128}
	'XMM14': Xmm{lit: 'XMM14', base_offset: 14, size: .suffix_xmm128}
	'XMM15': Xmm{lit: 'XMM15', base_offset: 15, size: .suffix_xmm128}

	'YMM0':  Xmm{lit: 'YMM0',  base_offset: 0,  size: .suffix_ymm256}
	'YMM1':  Xmm{lit: 'YMM1',  base_offset: 1,  size: .suffix_ymm256}
	'YMM2':  Xmm{lit: 'YMM2',  base_offset: 2,  size: .suffix_ymm256}
	'YMM3':  Xmm{lit: 'YMM3',  base_offset: 3,  size: .suffix_ymm256}
	'YMM4':  Xmm{lit: 'YMM4',  base_offset: 4,  size: .suffix_ymm256}
	'YMM5':  Xmm{lit: 'YMM5',  base_offset: 5,  size: .suffix_ymm256}
	'YMM6':  Xmm{lit: 'YMM6',  base_offset: 6,  size: .suffix_ymm256}
	'YMM7':  Xmm{lit: 'YMM7',  base_offset: 7,  size: .suffix_ymm256}
	'YMM8':  Xmm{lit: 'YMM8',  base_offset: 8,  size: .suffix_ymm256}
	'YMM9':  Xmm{lit: 'YMM9',  base_offset: 9,  size: .suffix_ymm256}
	'YMM10': Xmm{lit: 'YMM10', base_offset: 10, size: .suffix_ymm256}
	'YMM11': Xmm{lit: 'YMM11', base_offset: 11, size: .suffix_ymm256}
	'YMM12': Xmm{lit: 'YMM12', base_offset: 12, size: .suffix_ymm256}
	'YMM13': Xmm{lit: 'YMM13', base_offset: 13, size: .suffix_ymm256}
	'YMM14': Xmm{lit: 'YMM14', base_offset: 14, size: .suffix_ymm256}
	'YMM15': Xmm{lit: 'YMM15', base_offset: 15, size: .suffix_ymm256}

	// AVX-512 extended XMM/YMM (16-31). EVEX needed; no VEX form.
	'XMM16': Xmm{lit: 'XMM16', base_offset: 16, size: .suffix_xmm128}
	'XMM17': Xmm{lit: 'XMM17', base_offset: 17, size: .suffix_xmm128}
	'XMM18': Xmm{lit: 'XMM18', base_offset: 18, size: .suffix_xmm128}
	'XMM19': Xmm{lit: 'XMM19', base_offset: 19, size: .suffix_xmm128}
	'XMM20': Xmm{lit: 'XMM20', base_offset: 20, size: .suffix_xmm128}
	'XMM21': Xmm{lit: 'XMM21', base_offset: 21, size: .suffix_xmm128}
	'XMM22': Xmm{lit: 'XMM22', base_offset: 22, size: .suffix_xmm128}
	'XMM23': Xmm{lit: 'XMM23', base_offset: 23, size: .suffix_xmm128}
	'XMM24': Xmm{lit: 'XMM24', base_offset: 24, size: .suffix_xmm128}
	'XMM25': Xmm{lit: 'XMM25', base_offset: 25, size: .suffix_xmm128}
	'XMM26': Xmm{lit: 'XMM26', base_offset: 26, size: .suffix_xmm128}
	'XMM27': Xmm{lit: 'XMM27', base_offset: 27, size: .suffix_xmm128}
	'XMM28': Xmm{lit: 'XMM28', base_offset: 28, size: .suffix_xmm128}
	'XMM29': Xmm{lit: 'XMM29', base_offset: 29, size: .suffix_xmm128}
	'XMM30': Xmm{lit: 'XMM30', base_offset: 30, size: .suffix_xmm128}
	'XMM31': Xmm{lit: 'XMM31', base_offset: 31, size: .suffix_xmm128}

	'YMM16': Xmm{lit: 'YMM16', base_offset: 16, size: .suffix_ymm256}
	'YMM17': Xmm{lit: 'YMM17', base_offset: 17, size: .suffix_ymm256}
	'YMM18': Xmm{lit: 'YMM18', base_offset: 18, size: .suffix_ymm256}
	'YMM19': Xmm{lit: 'YMM19', base_offset: 19, size: .suffix_ymm256}
	'YMM20': Xmm{lit: 'YMM20', base_offset: 20, size: .suffix_ymm256}
	'YMM21': Xmm{lit: 'YMM21', base_offset: 21, size: .suffix_ymm256}
	'YMM22': Xmm{lit: 'YMM22', base_offset: 22, size: .suffix_ymm256}
	'YMM23': Xmm{lit: 'YMM23', base_offset: 23, size: .suffix_ymm256}
	'YMM24': Xmm{lit: 'YMM24', base_offset: 24, size: .suffix_ymm256}
	'YMM25': Xmm{lit: 'YMM25', base_offset: 25, size: .suffix_ymm256}
	'YMM26': Xmm{lit: 'YMM26', base_offset: 26, size: .suffix_ymm256}
	'YMM27': Xmm{lit: 'YMM27', base_offset: 27, size: .suffix_ymm256}
	'YMM28': Xmm{lit: 'YMM28', base_offset: 28, size: .suffix_ymm256}
	'YMM29': Xmm{lit: 'YMM29', base_offset: 29, size: .suffix_ymm256}
	'YMM30': Xmm{lit: 'YMM30', base_offset: 30, size: .suffix_ymm256}
	'YMM31': Xmm{lit: 'YMM31', base_offset: 31, size: .suffix_ymm256}

	// AVX-512 ZMM (32 registers).
	'ZMM0':  Xmm{lit: 'ZMM0',  base_offset: 0,  size: .suffix_zmm512}
	'ZMM1':  Xmm{lit: 'ZMM1',  base_offset: 1,  size: .suffix_zmm512}
	'ZMM2':  Xmm{lit: 'ZMM2',  base_offset: 2,  size: .suffix_zmm512}
	'ZMM3':  Xmm{lit: 'ZMM3',  base_offset: 3,  size: .suffix_zmm512}
	'ZMM4':  Xmm{lit: 'ZMM4',  base_offset: 4,  size: .suffix_zmm512}
	'ZMM5':  Xmm{lit: 'ZMM5',  base_offset: 5,  size: .suffix_zmm512}
	'ZMM6':  Xmm{lit: 'ZMM6',  base_offset: 6,  size: .suffix_zmm512}
	'ZMM7':  Xmm{lit: 'ZMM7',  base_offset: 7,  size: .suffix_zmm512}
	'ZMM8':  Xmm{lit: 'ZMM8',  base_offset: 8,  size: .suffix_zmm512}
	'ZMM9':  Xmm{lit: 'ZMM9',  base_offset: 9,  size: .suffix_zmm512}
	'ZMM10': Xmm{lit: 'ZMM10', base_offset: 10, size: .suffix_zmm512}
	'ZMM11': Xmm{lit: 'ZMM11', base_offset: 11, size: .suffix_zmm512}
	'ZMM12': Xmm{lit: 'ZMM12', base_offset: 12, size: .suffix_zmm512}
	'ZMM13': Xmm{lit: 'ZMM13', base_offset: 13, size: .suffix_zmm512}
	'ZMM14': Xmm{lit: 'ZMM14', base_offset: 14, size: .suffix_zmm512}
	'ZMM15': Xmm{lit: 'ZMM15', base_offset: 15, size: .suffix_zmm512}
	'ZMM16': Xmm{lit: 'ZMM16', base_offset: 16, size: .suffix_zmm512}
	'ZMM17': Xmm{lit: 'ZMM17', base_offset: 17, size: .suffix_zmm512}
	'ZMM18': Xmm{lit: 'ZMM18', base_offset: 18, size: .suffix_zmm512}
	'ZMM19': Xmm{lit: 'ZMM19', base_offset: 19, size: .suffix_zmm512}
	'ZMM20': Xmm{lit: 'ZMM20', base_offset: 20, size: .suffix_zmm512}
	'ZMM21': Xmm{lit: 'ZMM21', base_offset: 21, size: .suffix_zmm512}
	'ZMM22': Xmm{lit: 'ZMM22', base_offset: 22, size: .suffix_zmm512}
	'ZMM23': Xmm{lit: 'ZMM23', base_offset: 23, size: .suffix_zmm512}
	'ZMM24': Xmm{lit: 'ZMM24', base_offset: 24, size: .suffix_zmm512}
	'ZMM25': Xmm{lit: 'ZMM25', base_offset: 25, size: .suffix_zmm512}
	'ZMM26': Xmm{lit: 'ZMM26', base_offset: 26, size: .suffix_zmm512}
	'ZMM27': Xmm{lit: 'ZMM27', base_offset: 27, size: .suffix_zmm512}
	'ZMM28': Xmm{lit: 'ZMM28', base_offset: 28, size: .suffix_zmm512}
	'ZMM29': Xmm{lit: 'ZMM29', base_offset: 29, size: .suffix_zmm512}
	'ZMM30': Xmm{lit: 'ZMM30', base_offset: 30, size: .suffix_zmm512}
	'ZMM31': Xmm{lit: 'ZMM31', base_offset: 31, size: .suffix_zmm512}

	// AVX-512 mask registers (K0..K7). Same Xmm carrier with a distinct size
	// so the classifier can pick out the kreg OpClass.
	'K0': Xmm{lit: 'K0', base_offset: 0, size: .suffix_kreg}
	'K1': Xmm{lit: 'K1', base_offset: 1, size: .suffix_kreg}
	'K2': Xmm{lit: 'K2', base_offset: 2, size: .suffix_kreg}
	'K3': Xmm{lit: 'K3', base_offset: 3, size: .suffix_kreg}
	'K4': Xmm{lit: 'K4', base_offset: 4, size: .suffix_kreg}
	'K5': Xmm{lit: 'K5', base_offset: 5, size: .suffix_kreg}
	'K6': Xmm{lit: 'K6', base_offset: 6, size: .suffix_kreg}
	'K7': Xmm{lit: 'K7', base_offset: 7, size: .suffix_kreg}

	// x87 FPU stack registers ST(0)..ST(7). Encoded with `+r` in the c0+r /
	// d0+r etc. opcodes; no REX extension (only 8 registers).
	'ST': Xmm{lit: 'ST', base_offset: 0, size: .suffix_fpureg}
	'ST0': Xmm{lit: 'ST0', base_offset: 0, size: .suffix_fpureg}
	'ST1': Xmm{lit: 'ST1', base_offset: 1, size: .suffix_fpureg}
	'ST2': Xmm{lit: 'ST2', base_offset: 2, size: .suffix_fpureg}
	'ST3': Xmm{lit: 'ST3', base_offset: 3, size: .suffix_fpureg}
	'ST4': Xmm{lit: 'ST4', base_offset: 4, size: .suffix_fpureg}
	'ST5': Xmm{lit: 'ST5', base_offset: 5, size: .suffix_fpureg}
	'ST6': Xmm{lit: 'ST6', base_offset: 6, size: .suffix_fpureg}
	'ST7': Xmm{lit: 'ST7', base_offset: 7, size: .suffix_fpureg}
}
