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
	'R15D': Register{lit: 'R15D', base_offset: 15, size: .suffix_byte}
	'R15B': Register{lit: 'R15B', base_offset: 15, size: .suffix_byte}
	'RIP': Register{lit: 'RIP', base_offset: 0, size: .suffix_quad}
	'EIP': Register{lit: 'EIP', base_offset: 0, size: .suffix_long}
	'IP': Register{lit: 'IP', base_offset: 0, size: .suffix_word}
}

const xmm_registers = {
	'XMM0': Xmm{lit: 'XMM0', base_offset: 0, size: .suffix_unkown}
	'XMM1': Xmm{lit: 'XMM1', base_offset: 1, size: .suffix_unkown}
	'XMM2': Xmm{lit: 'XMM2', base_offset: 2, size: .suffix_unkown}
	'XMM3': Xmm{lit: 'XMM3', base_offset: 3, size: .suffix_unkown}
	'XMM4': Xmm{lit: 'XMM4', base_offset: 4, size: .suffix_unkown}
	'XMM5': Xmm{lit: 'XMM5', base_offset: 5, size: .suffix_unkown}
	'XMM6': Xmm{lit: 'XMM6', base_offset: 6, size: .suffix_unkown}
	'XMM7': Xmm{lit: 'XMM7', base_offset: 7, size: .suffix_unkown}
	'XMM8': Xmm{lit: 'XMM8', base_offset: 8, size: .suffix_unkown}
	'XMM9': Xmm{lit: 'XMM9', base_offset: 9, size: .suffix_unkown}
	'XMM10': Xmm{lit: 'XMM10', base_offset: 10, size: .suffix_unkown}
	'XMM11': Xmm{lit: 'XMM11', base_offset: 11, size: .suffix_unkown}
	'XMM12': Xmm{lit: 'XMM12', base_offset: 12, size: .suffix_unkown}
	'XMM13': Xmm{lit: 'XMM13', base_offset: 13, size: .suffix_unkown}
	'XMM14': Xmm{lit: 'XMM14', base_offset: 14, size: .suffix_unkown}
	'XMM15': Xmm{lit: 'XMM15', base_offset: 15, size: .suffix_unkown}
}
