module encoder

pub enum OpClass {
	@none
	reg8
	reg16
	reg32
	reg64
	rm8
	rm16
	rm32
	rm64
	imm8
	imm16
	imm32
	imm64
	imm_one // exactly the literal value 1 (used by shift `rm,1` short form)
	reg_cl  // the CL register (used by shift `rm,%cl` form)
	// SSE / SSE2 — XMM registers and memory of 32 / 64 / 128 bits.
	xmmreg
	xmmrm    // generic xmm-or-mem (size determined by mnemonic)
	xmmrm8   // xmm or 8-bit mem (AVX-512 byte-element ops like VPMOVSXBW)
	xmmrm16  // xmm or 16-bit mem
	xmmrm32
	xmmrm64
	xmmrm128
	// AVX — YMM registers and 256-bit memory.
	ymmreg
	ymmrm
	ymmrm128
	ymmrm256
	// AVX-512 — ZMM registers and 512-bit memory. ymmrm/xmmrm are still
	// reused for the 128/256 EVEX forms.
	zmmreg
	zmmrm
	zmmrm128
	zmmrm256
	zmmrm512
	// AVX-512 mask registers (K0..K7). Width is determined by the mnemonic.
	kreg
	krm  // kreg or memory of suitable width — width is mnemonic-determined
	// Generic memory of unspecified size (CLFLUSH / PREFETCH* / FXSAVE / etc.).
	// Subclass-matches any rmN slot.
	mem_any
	mem8
	mem16
	mem32
	mem64
	mem128
	mem256
	mem80 // 80-bit memory (x87 tbyte / BCD), kept distinct so FLDT/FSTPT don't
	      // collide with the 32/64-bit FLD/FSTP forms
	// x87 FPU stack registers ST(0)..ST(7). `fpu0` is the implicit ST(0)
	// operand some instructions encode as a placeholder (no actual bytes).
	fpureg
	fpu0
	label
	rel8
	rel32
}

pub enum OpOrder {
	zo
	r
	m
	i
	rm
	mr
	mi
	ri
	rmi // 3-operand: dest=reg, src=r/m, imm
	mri // 3-operand: dest=r/m, reg, imm    (EXTRACTPS / PEXTR* / SHLD imm)
	m1  // shift `rm,1`: ModR/M only, no immediate emitted
	mc  // shift `rm,%cl`: ModR/M only, CL is implicit
	r_skip // x87 2-op: ops[0] encoded as +r, ops[1] is implicit fpu0
	skip_r // x87 2-op: ops[0] is implicit fpu0, ops[1] encoded as +r
	// VEX-only 3-operand forms:
	rvm // op0=ModR/M.reg, op1=VEX.vvvv, op2=ModR/M.r/m   (VADDPS / VPXOR / ...)
	mvr // op0=ModR/M.r/m, op1=VEX.vvvv, op2=ModR/M.reg   (store form of VMOVSS / VMOVSD)
	rmv // op0=reg, op1=r/m, op2=VEX.vvvv     (BEXTR / BZHI / VPROT* — non-destructive)
	vmi // op0=VEX.vvvv (dest), op1=r/m, op2=imm   (VPSLL* / VPSRL* shift-by-imm)
	// VEX/EVEX 4-operand forms:
	rvmi // op0=reg, op1=VEX.vvvv, op2=r/m, op3=imm    (VBLENDPS / VCMPPD / ...)
	rvms // op0=reg, op1=VEX.vvvv, op2=r/m, op3=/is4 reg     (AMD FMA4 W=0)
	rvsm // op0=reg, op1=VEX.vvvv, op2=/is4 reg, op3=r/m     (AMD FMA4 W=1)
}

pub enum RegFieldKind {
	@none
	slash_r
	slash_d0
	slash_d1
	slash_d2
	slash_d3
	slash_d4
	slash_d5
	slash_d6
	slash_d7
}

pub enum ImmKind {
	@none
	ib
	iw
	id
	iq
}

pub enum RelKind {
	@none
	rel8
	rel32
}

pub struct InstrEnc {
pub:
	mnemonic  string
	operands  []OpClass
	op_order  OpOrder
	prefixes  []u8
	rex_w     bool
	opcode    []u8
	plus_reg  bool
	reg_field RegFieldKind
	imm       ImmKind
	rel       RelKind
	// VEX prefix info. When `vex_present` is true the legacy prefix/REX path
	// is bypassed and a VEX byte sequence is emitted instead.
	//
	//   vex_l  : 0=128-bit (L=0), 1=256-bit (L=1), 2=lig (length-ignored, encode 0)
	//   vex_w  : 0, 1, 2=wig (W-ignored, encode 0)
	//   vex_pp : 0=none, 1=0x66, 2=0xF3, 3=0xF2
	//   vex_mm : 1=0F, 2=0F38, 3=0F3A
	vex_present bool
	vex_l       u8
	vex_w       u8
	vex_pp      u8
	vex_mm      u8
	// EVEX (AVX-512). Same layout as VEX but with a 2-bit L'L for 512-bit
	// vectors (evex_l: 0=128, 1=256, 2=512). The 4-byte 0x62 prefix is emitted
	// instead of the 2/3-byte VEX prefix.
	evex_present bool
	evex_l       u8
	evex_w       u8
	evex_pp      u8
	evex_mm      u8
}

pub const insns_table = [
	InstrEnc{mnemonic: 'MOVSB', operands: [], op_order: .zo, opcode: [u8(0xa4)]},
	InstrEnc{mnemonic: 'MOVSW', operands: [], op_order: .zo, prefixes: [u8(0x66)], opcode: [u8(0xa5)]},
	InstrEnc{mnemonic: 'MOVSL', operands: [], op_order: .zo, opcode: [u8(0xa5)]},
	InstrEnc{mnemonic: 'MOVSQ', operands: [], op_order: .zo, rex_w: true, opcode: [u8(0xa5)]},
	InstrEnc{mnemonic: 'STOSB', operands: [], op_order: .zo, opcode: [u8(0xaa)]},
	InstrEnc{mnemonic: 'STOSW', operands: [], op_order: .zo, prefixes: [u8(0x66)], opcode: [u8(0xab)]},
	InstrEnc{mnemonic: 'STOSL', operands: [], op_order: .zo, opcode: [u8(0xab)]},
	InstrEnc{mnemonic: 'STOSQ', operands: [], op_order: .zo, rex_w: true, opcode: [u8(0xab)]},
	InstrEnc{mnemonic: 'LODSB', operands: [], op_order: .zo, opcode: [u8(0xac)]},
	InstrEnc{mnemonic: 'LODSW', operands: [], op_order: .zo, prefixes: [u8(0x66)], opcode: [u8(0xad)]},
	InstrEnc{mnemonic: 'LODSL', operands: [], op_order: .zo, opcode: [u8(0xad)]},
	InstrEnc{mnemonic: 'LODSQ', operands: [], op_order: .zo, rex_w: true, opcode: [u8(0xad)]},
	InstrEnc{mnemonic: 'SCASB', operands: [], op_order: .zo, opcode: [u8(0xae)]},
	InstrEnc{mnemonic: 'SCASW', operands: [], op_order: .zo, prefixes: [u8(0x66)], opcode: [u8(0xaf)]},
	InstrEnc{mnemonic: 'SCASL', operands: [], op_order: .zo, opcode: [u8(0xaf)]},
	InstrEnc{mnemonic: 'SCASQ', operands: [], op_order: .zo, rex_w: true, opcode: [u8(0xaf)]},
	InstrEnc{mnemonic: 'CMPSB', operands: [], op_order: .zo, opcode: [u8(0xa6)]},
	InstrEnc{mnemonic: 'CMPSW', operands: [], op_order: .zo, prefixes: [u8(0x66)], opcode: [u8(0xa7)]},
	InstrEnc{mnemonic: 'CMPSL', operands: [], op_order: .zo, opcode: [u8(0xa7)]},
	InstrEnc{mnemonic: 'CMPSQ', operands: [], op_order: .zo, rex_w: true, opcode: [u8(0xa7)]},
	InstrEnc{mnemonic: 'XCHG', operands: [.rm8, .reg8], op_order: .mr, opcode: [u8(0x86)], reg_field: .slash_r},
	InstrEnc{mnemonic: 'XCHG', operands: [.reg8, .rm8], op_order: .rm, opcode: [u8(0x86)], reg_field: .slash_r},
	InstrEnc{mnemonic: 'XCHG', operands: [.rm16, .reg16], op_order: .mr, prefixes: [u8(0x66)], opcode: [u8(0x87)], reg_field: .slash_r},
	InstrEnc{mnemonic: 'XCHG', operands: [.reg16, .rm16], op_order: .rm, prefixes: [u8(0x66)], opcode: [u8(0x87)], reg_field: .slash_r},
	InstrEnc{mnemonic: 'XCHG', operands: [.rm32, .reg32], op_order: .mr, opcode: [u8(0x87)], reg_field: .slash_r},
	InstrEnc{mnemonic: 'XCHG', operands: [.reg32, .rm32], op_order: .rm, opcode: [u8(0x87)], reg_field: .slash_r},
	InstrEnc{mnemonic: 'XCHG', operands: [.rm64, .reg64], op_order: .mr, rex_w: true, opcode: [u8(0x87)], reg_field: .slash_r},
	InstrEnc{mnemonic: 'XCHG', operands: [.reg64, .rm64], op_order: .rm, rex_w: true, opcode: [u8(0x87)], reg_field: .slash_r},
]

// ----- Mnemonic canonicalization -----

// Canonical (Intel) names for the zero-operand integer instructions we
// support. The AT&T-specific spellings CLTQ/CLTD/CQTO/CWTL are normalized to
// these in `canonicalize_mnemonic`.
const zero_op_canons = [
	'RET', 'SYSCALL', 'NOP', 'HLT', 'LEAVE', 'CBW', 'CDQE', 'CDQ', 'CQO', 'CWDE',
	'F2XM1', 'FABS', 'FCHS', 'FCLEX', 'FCOMPP', 'FCOS', 'FDECSTP', 'FEMMS', 'FFREE',
	'FINCSTP', 'FINIT', 'FLD1', 'FLDL2E', 'FLDL2T', 'FLDLG2', 'FLDLN2', 'FLDPI', 'FLDZ',
	'FNCLEX', 'FNINIT', 'FNOP', 'FPATAN', 'FPREM', 'FPREM1', 'FPTAN', 'FRNDINT', 'FSCALE',
	'FSIN', 'FSINCOS', 'FSQRT', 'FTST', 'FUCOMPP', 'FWAIT', 'FXAM', 'FXTRACT', 'FYL2X',
	'FYL2XP1', 'F1ST', 'FRSTPM', 'FNSTSW', 'FSTSW',
	'CPUID', 'RDTSC', 'RDTSCP', 'RDPMC', 'RDMSR', 'WRMSR',
	'CLI', 'STI', 'CLD', 'STD', 'CLC', 'STC', 'CMC', 'SAHF', 'LAHF',
	'INT3', 'INTO', 'IRET', 'IRETQ', 'IRETD', 'SYSENTER', 'SYSEXIT', 'SYSRET', 'SYSRETQ',
	'WBINVD', 'INVD', 'SWAPGS', 'MONITOR', 'MWAIT', 'PAUSE',
	'LFENCE', 'MFENCE', 'SFENCE',
	'CLAC', 'STAC', 'ENDBR32', 'ENDBR64', 'SERIALIZE',
	'XEND', 'XTEST', 'XGETBV', 'XSETBV',
	'UD2', 'UD2A', 'UD2B',
	'AAA', 'AAD', 'AAM', 'AAS', 'DAA', 'DAS',
	'PUSHF', 'PUSHFQ', 'PUSHFD', 'POPF', 'POPFQ', 'POPFD',
	'PUSHA', 'PUSHAD', 'POPA', 'POPAD',
	'EMMS', 'GETSEC', 'RSM', 'TLBSYNC',
	'MOVSB', 'MOVSW', 'MOVSL', 'MOVSQ',
	'STOSB', 'STOSW', 'STOSL', 'STOSQ',
	'LODSB', 'LODSW', 'LODSL', 'LODSQ',
	'SCASB', 'SCASW', 'SCASL', 'SCASQ',
	'CMPSB', 'CMPSW', 'CMPSL', 'CMPSQ',
]

const branch_canons = [
	'JMP', 'CALL',
	'JO', 'JNO', 'JB', 'JNB', 'JE', 'JNE', 'JBE', 'JNBE', 'JS', 'JNS', 'JP', 'JPO', 'JL', 'JGE',
	'JLE', 'JG',
	'JC', 'JNC', 'JZ', 'JNZ', 'JNA', 'JA', 'JAE', 'JNGE', 'JNL', 'JNG', 'JNLE', 'JPE',
]

const setcc_canons = [
	'SETO', 'SETNO', 'SETB', 'SETNB', 'SETE', 'SETNE', 'SETBE', 'SETA', 'SETS', 'SETNS', 'SETP',
	'SETPO', 'SETL', 'SETGE', 'SETLE', 'SETG',
	'SETC', 'SETNC', 'SETZ', 'SETNZ', 'SETPE', 'SETAE', 'SETNA', 'SETNBE', 'SETNGE', 'SETNL',
	'SETNG', 'SETNLE',
]

// SSE mnemonics carry no AT&T size suffix; the memory-operand width is fixed
// by the mnemonic itself.
//   single (32-bit float):   MOVSS / ADDSS / SUBSS / MULSS / DIVSS / UCOMISS / COMISS
//   double (64-bit float):   MOVSD / ADDSD / SUBSD / MULSD / DIVSD / UCOMISD / COMISD
//   xmm128 (packed 128-bit): MOVAPS / MOVUPS / MOVAPD / MOVUPD / XORPS / XORPD / ANDPS /
//                            ANDPD / ORPS / ORPD / ANDNPS / ANDNPD / PXOR / PADDB / etc.
//   long (32-bit GPR):       MOVD (xmm/mmx <-> r/m32)
const sse_mnemonics_single = ['MOVSS', 'ADDSS', 'SUBSS', 'MULSS', 'DIVSS', 'UCOMISS', 'COMISS',
	'CVTSS2SD']

const sse_mnemonics_double = ['MOVSD', 'ADDSD', 'SUBSD', 'MULSD', 'DIVSD', 'UCOMISD', 'COMISD',
	'CVTSD2SS']

const sse_mnemonics_xmm128 = ['MOVAPS', 'MOVUPS', 'MOVAPD', 'MOVUPD', 'XORPS', 'XORPD', 'ANDPS',
	'ANDPD', 'ORPS', 'ORPD', 'ANDNPS', 'ANDNPD', 'PXOR']

// Shift-family mnemonics that GAS allows in their 1-operand form:
// `shll %ecx` is shorthand for `shll $1, %ecx`. Used by emit_table to
// synthesize the implicit immediate.
const one_op_shift_canons = ['SHL', 'SHR', 'SAR', 'SAL', 'ROL', 'ROR', 'RCL', 'RCR']

// Suffixed bases: AT&T `<base><Q|L|W|B>` strips to canonical Intel `<base>` plus a size hint.
const suffixed_bases = [
	'MOV', 'ADD', 'OR', 'ADC', 'SBB', 'AND', 'SUB', 'XOR', 'CMP', 'TEST',
	'NOT', 'NEG', 'MUL', 'DIV', 'IDIV', 'IMUL', 'LEA',
	'SHL', 'SHR', 'SAR', 'SAL', 'ROL', 'ROR', 'RCL', 'RCR', 'SHLD', 'SHRD',
	'INC', 'DEC', 'XCHG', 'XADD', 'CMPXCHG', 'BSF', 'BSR', 'BSWAP', 'POPCNT', 'LZCNT', 'TZCNT',
	'BT', 'BTS', 'BTR', 'BTC', 'MOVBE', 'CRC32',
	'BEXTR', 'BZHI', 'BLSI', 'BLSMSK', 'BLSR', 'MULX', 'PDEP', 'PEXT',
	'RORX', 'SARX', 'SHLX', 'SHRX', 'ADCX', 'ADOX',
	// CMOV<cc>: the cc is part of the base name; the trailing letter is the AT&T size suffix.
	'CMOVO', 'CMOVNO', 'CMOVB', 'CMOVNB', 'CMOVE', 'CMOVNE', 'CMOVBE', 'CMOVNBE',
	'CMOVS', 'CMOVNS', 'CMOVP', 'CMOVPO', 'CMOVL', 'CMOVGE', 'CMOVLE', 'CMOVG',
	'CMOVC', 'CMOVNC', 'CMOVZ', 'CMOVNZ', 'CMOVA', 'CMOVAE', 'CMOVNA', 'CMOVNGE', 'CMOVNL',
	'CMOVNG', 'CMOVNLE', 'CMOVPE',
]

// Mnemonics whose AT&T spelling carries no size suffix — they pass through
// canonicalize unchanged with an unknown size hint.
const passthrough_canons = [
	'EXTRACTPS', 'INSERTPS', 'PEXTRB', 'PEXTRW', 'PEXTRD', 'PEXTRQ',
	'PINSRB', 'PINSRW', 'PINSRD', 'PINSRQ',
	'PADDB', 'PADDW', 'PADDD', 'PADDQ', 'PADDSB', 'PADDSW', 'PADDUSB', 'PADDUSW',
	'PSUBB', 'PSUBW', 'PSUBD', 'PSUBQ', 'PSUBSB', 'PSUBSW', 'PSUBUSB', 'PSUBUSW',
	'PMULLW', 'PMULLD', 'PMULHW', 'PMULHUW', 'PMULHRSW', 'PMULUDQ', 'PMULDQ',
	'PMADDWD', 'PMADDUBSW', 'PSADBW', 'PALIGNR', 'PSHUFB', 'PSHUFD', 'PSHUFLW', 'PSHUFHW',
	'PUNPCKLBW', 'PUNPCKLWD', 'PUNPCKLDQ', 'PUNPCKLQDQ',
	'PUNPCKHBW', 'PUNPCKHWD', 'PUNPCKHDQ', 'PUNPCKHQDQ',
	'PHADDW', 'PHADDD', 'PHADDSW', 'PHSUBW', 'PHSUBD', 'PHSUBSW',
	'PMINUB', 'PMINSW', 'PMINSB', 'PMINUW', 'PMINUD', 'PMINSD',
	'PMAXUB', 'PMAXSW', 'PMAXSB', 'PMAXUW', 'PMAXUD', 'PMAXSD',
	'PCMPEQB', 'PCMPEQW', 'PCMPEQD', 'PCMPEQQ',
	'PCMPGTB', 'PCMPGTW', 'PCMPGTD', 'PCMPGTQ',
	'PABSB', 'PABSW', 'PABSD', 'PSIGNB', 'PSIGNW', 'PSIGND',
	'PAVGB', 'PAVGW',
	'PACKSSWB', 'PACKSSDW', 'PACKUSWB', 'PACKUSDW',
	'POR', 'PAND', 'PANDN',
	'PMOVMSKB', 'MOVMSKPS', 'MOVMSKPD',
	'PSLLW', 'PSLLD', 'PSLLQ', 'PSRLW', 'PSRLD', 'PSRLQ', 'PSRAW', 'PSRAD',
	'PSLLDQ', 'PSRLDQ',
	'MOVDQU', 'MOVDQA', 'MOVNTDQ', 'MOVNTPS', 'MOVNTPD', 'MOVNTI',
	'MOVHPS', 'MOVHPD', 'MOVLPS', 'MOVLPD', 'MOVHLPS', 'MOVLHPS',
	'MOVDDUP', 'MOVSHDUP', 'MOVSLDUP',
	'SHUFPS', 'SHUFPD', 'UNPCKHPS', 'UNPCKHPD', 'UNPCKLPS', 'UNPCKLPD',
	'CMPPS', 'CMPPD',
	// Packed / extra SSE arithmetic + conversions (auto-vectorizer output).
	'ADDPS', 'ADDPD', 'SUBPS', 'SUBPD', 'MULPS', 'MULPD', 'DIVPS', 'DIVPD',
	'MAXPS', 'MAXPD', 'MINPS', 'MINPD', 'MAXSS', 'MAXSD', 'MINSS', 'MINSD',
	'SQRTPS', 'SQRTPD', 'SQRTSS', 'SQRTSD', 'RSQRTPS', 'RSQRTSS', 'RCPPS', 'RCPSS',
	'HADDPD', 'HADDPS', 'HSUBPD', 'HSUBPS', 'ADDSUBPD', 'ADDSUBPS',
	'ROUNDPS', 'ROUNDPD', 'ROUNDSS', 'ROUNDSD',
	'BLENDPS', 'BLENDPD', 'BLENDVPS', 'BLENDVPD', 'DPPS', 'DPPD',
	'CVTDQ2PS', 'CVTPS2DQ', 'CVTTPS2DQ', 'CVTDQ2PD', 'CVTPD2DQ', 'CVTTPD2DQ',
	'CVTPS2PD', 'CVTPD2PS', 'CVTSS2SI', 'CVTSD2SI',
	'POPCNT',
	'CLFLUSH', 'CLFLUSHOPT', 'CLWB', 'PREFETCH', 'PREFETCHT0', 'PREFETCHT1', 'PREFETCHT2',
	'PREFETCHNTA', 'PREFETCHW', 'PREFETCHWT1', 'CLDEMOTE',
	'XADD', 'XCHG', 'CMPXCHG', 'CMPXCHG8B', 'CMPXCHG16B',
	'WRFSBASE', 'WRGSBASE', 'RDFSBASE', 'RDGSBASE',
	'PTWRITE', 'PCONFIG',
	'RDRAND', 'RDSEED', 'RDPID',
	'INT', 'INVLPG', 'CLDEMOTE',
	'XSAVE', 'XSAVES', 'XRSTOR', 'XRSTORS', 'XSAVE64', 'XSAVES64', 'XRSTOR64', 'XRSTORS64',
	'XBEGIN', 'XABORT', 'XSAVEC', 'XSAVEC64', 'XSAVEOPT', 'XSAVEOPT64',
	// MOVQ / MOVD are NOT here: the integer suffix-strip path owns them; lookup
	// falls through to SSE2 rows via Canon.alt_name when the operands are xmm.
	'LIDT', 'LGDT', 'SIDT', 'SGDT', 'LLDT', 'SLDT', 'LTR', 'STR',
	'LMSW', 'SMSW', 'LAR', 'LSL',
	'LDS', 'LES', 'LFS', 'LGS', 'LSS',
	'VMLAUNCH', 'VMRESUME', 'VMXOFF', 'VMXON', 'VMCALL', 'VMFUNC',
	'VMRUN', 'VMSAVE', 'VMLOAD', 'STGI', 'CLGI', 'INVLPGA',
	'VMCLEAR', 'VMPTRLD', 'VMPTRST', 'VMREAD', 'VMWRITE',
	'INVEPT', 'INVVPID', 'INVPCID',
	'INCSSPD', 'INCSSPQ', 'RDSSPD', 'RDSSPQ', 'SAVEPREVSSP', 'RSTORSSP',
	'WRSSD', 'WRSSQ', 'WRUSSD', 'WRUSSQ', 'SETSSBSY', 'CLRSSBSY',
	'TPAUSE', 'UMONITOR', 'UMWAIT', 'MOVDIRI', 'MOVDIR64B',
	'ENQCMD', 'ENQCMDS', 'WAITPKG',
	'CLZERO', 'MONITORX', 'MWAITX', 'WBNOINVD', 'IRETF',
	'AESDEC', 'AESDECLAST', 'AESENC', 'AESENCLAST', 'AESIMC', 'AESKEYGENASSIST',
	'SHA1MSG1', 'SHA1MSG2', 'SHA1NEXTE', 'SHA1RNDS4',
	'SHA256MSG1', 'SHA256MSG2', 'SHA256RNDS2', 'PCLMULQDQ',
	'CMOVNP', 'RETN', 'RETF', 'CMPSD', 'CMPSS',
	'INSB', 'INSW', 'INSD', 'OUTSB', 'OUTSW', 'OUTSD',
	'IN', 'OUT',
	'FXSAVE', 'FXSAVE64', 'FXRSTOR', 'FXRSTOR64',
	'FNSAVE', 'FRSTOR', 'FNSTENV', 'FLDENV', 'FNSTCW', 'FLDCW',
	'FUCOMI', 'FUCOMIP', 'FCOMI', 'FCOMIP', 'FCMOVE', 'FCMOVNE',
	'FCMOVB', 'FCMOVNB', 'FCMOVBE', 'FCMOVNBE', 'FCMOVU', 'FCMOVNU',
]

// x87 base mnemonics whose `s`/`l` suffix in AT&T spells out a memory
// operand size (FADDS = FADD mem32, FADDL = FADD mem64). The strip is
// gated on this list so we don't confuse FMUL/FSUBR's trailing letters
// with a size suffix.
const fpu_mem_bases = ['FADD', 'FSUB', 'FSUBR', 'FMUL', 'FDIV', 'FDIVR',
	'FCOM', 'FCOMP', 'FLD', 'FST', 'FSTP',
	'FIADD', 'FISUB', 'FISUBR', 'FIMUL', 'FIDIV', 'FIDIVR', 'FICOM', 'FICOMP',
	'FILD', 'FIST', 'FISTP', 'FBLD', 'FBSTP']

// x87 mnemonics that take a tbyte (80-bit) memory operand via AT&T's `t`
// suffix: FLDT, FSTPT, FBLD, FBSTP. (FBLD/FBSTP take BCD-80 directly without
// a `t`, but FBLDT / FBSTPT also work.)
const fpu_tbyte_bases = ['FLD', 'FSTP', 'FBLD', 'FBSTP']

// x87 *integer* memory ops. Their AT&T size suffix names an INTEGER width —
// `s`=m16int, `l`=m32int, `q`=m64int — unlike the float bases above where
// `s`=m32 and `l`=m64. (FILD/FIST/FISTP have the m64 `q` form.)
const fpu_int_bases = ['FIADD', 'FIMUL', 'FISUB', 'FISUBR', 'FIDIV', 'FIDIVR',
	'FICOM', 'FICOMP', 'FILD', 'FIST', 'FISTP']

fn try_strip_size_suffix(name string, base string) (DataSize, bool) {
	if name.len != base.len + 1 || !name.starts_with(base) {
		return DataSize.suffix_unkown, false
	}
	s := match name[base.len] {
		`Q` { DataSize.suffix_quad }
		`L` { DataSize.suffix_long }
		`W` { DataSize.suffix_word }
		`B` { DataSize.suffix_byte }
		else { DataSize.suffix_unkown }
	}
	return s, s != .suffix_unkown
}

// parse_movz_movs interprets AT&T's `mov{z,s}<src><dst>` family:
//
//   movzbw / movzbl / movzbq    MOVZX  src=byte, dst={word,long,quad}
//   movzwl / movzwq             MOVZX  src=word, dst={long,quad}
//   movsbw / movsbl / movsbq    MOVSX  src=byte, dst={word,long,quad}
//   movswl / movswq             MOVSX  src=word, dst={long,quad}
//   movslq                      MOVSXD src=long, dst=quad
//
// Returns (canon, dst_size, src_size, ok).
fn parse_movz_movs(name string) (string, DataSize, DataSize, bool) {
	if name.len != 6 {
		return '', DataSize.suffix_unkown, DataSize.suffix_unkown, false
	}
	head := name[..4]
	mut canon := ''
	is_movs := head == 'MOVS'
	if head != 'MOVZ' && !is_movs {
		return '', DataSize.suffix_unkown, DataSize.suffix_unkown, false
	}
	src_letter := name[4]
	dst_letter := name[5]
	if is_movs && src_letter == `L` && dst_letter == `Q` {
		canon = 'MOVSXD'
	} else if is_movs {
		canon = 'MOVSX'
	} else {
		canon = 'MOVZX'
	}

	src_size := match src_letter {
		`B` { DataSize.suffix_byte }
		`W` { DataSize.suffix_word }
		`L` { DataSize.suffix_long }
		else { DataSize.suffix_unkown }
	}
	dst_size := match dst_letter {
		`W` { DataSize.suffix_word }
		`L` { DataSize.suffix_long }
		`Q` { DataSize.suffix_quad }
		else { DataSize.suffix_unkown }
	}
	if src_size == .suffix_unkown || dst_size == .suffix_unkown {
		return '', DataSize.suffix_unkown, DataSize.suffix_unkown, false
	}
	return canon, dst_size, src_size, true
}

// Canon is the result of canonicalizing an AT&T mnemonic. For most
// instructions src_size == dst_size (symmetric); MOVZX / MOVSX / MOVSXD
// have distinct widths. `alt_name` is an optional fallback the lookup
// retries if `name` finds no match — used for collisions like MOVQ
// (integer MOV-with-quad vs SSE2 MOVQ on xmm operands).
pub struct Canon {
pub:
	name     string
	dst_size DataSize
	src_size DataSize
	alt_name string
	// inject_imm >= 0 marks a mnemonic that expands to a base instruction plus a
	// synthesized leading immediate — used by the SSE compare-predicate pseudo-ops
	// (`cmpnlesd` → `cmpsd $6`). -1 means "no injected immediate".
	inject_imm int = -1
	ok         bool
}

// SSE compare-predicate pseudo-ops: GAS spells `cmpsd $imm8, src, dst` as
// `cmp<pred>sd src, dst`, where the predicate name selects the imm8. gcc emits
// these for floating relational operators (e.g. `cmpnlesd` for `a > b`). The
// same 8 predicates apply to the SS / PS / PD sizes. try_cmp_pseudo returns the
// base mnemonic (CMPSS/CMPSD/CMPPS/CMPPD) and the predicate imm8; ok=false when
// `name` is not one of these pseudo spellings.
fn try_cmp_pseudo(name string) (string, u8, bool) {
	// Bases (CMPSD/CMPPS/...) are length 5; a real pseudo is CMP + pred(>=2) +
	// size(2) >= 7. The length guard keeps the string compares (CMPSB/CMPSW/...)
	// and the integer CMP suffixes out.
	if name.len < 7 || !name.starts_with('CMP') {
		return '', 0, false
	}
	size_suffix := name[name.len - 2..]
	if size_suffix !in ['SS', 'SD', 'PS', 'PD'] {
		return '', 0, false
	}
	pred := match name[3..name.len - 2] {
		'EQ' { u8(0) }
		'LT' { u8(1) }
		'LE' { u8(2) }
		'UNORD' { u8(3) }
		'NEQ' { u8(4) }
		'NLT' { u8(5) }
		'NLE' { u8(6) }
		'ORD' { u8(7) }
		else { return '', 0, false }
	}
	return 'CMP' + size_suffix, pred, true
}

fn sym(name string, sz DataSize) Canon {
	return Canon{
		name:     name
		dst_size: sz
		src_size: sz
		ok:       true
	}
}

fn canonicalize_mnemonic(name string) Canon {
	// Aliases: 'RETQ' / 'CALLQ' / 'PUSHQ' / 'POPQ' / 'NOPQ' are equivalent to the unsuffixed forms.
	// The CLTQ family are AT&T-only spellings that NASM/Intel calls CDQE/CDQ/CQO/CWDE.
	match name {
		'RETQ' { return sym('RET', DataSize.suffix_quad) }
		'CALLQ' { return sym('CALL', DataSize.suffix_quad) }
		'JMPQ' { return sym('JMP', DataSize.suffix_quad) }
		'PUSHQ' { return sym('PUSH', DataSize.suffix_quad) }
		'POPQ' { return sym('POP', DataSize.suffix_quad) }
		'NOPQ' { return sym('NOP', DataSize.suffix_quad) }
		'CBTW' { return sym('CBW', DataSize.suffix_word) }
		'CLTQ' { return sym('CDQE', DataSize.suffix_quad) }
		'CLTD' { return sym('CDQ', DataSize.suffix_long) }
		'CQTO' { return sym('CQO', DataSize.suffix_quad) }
		'CWTL' { return sym('CWDE', DataSize.suffix_long) }
		'MOVABSQ' { return sym('MOVABSQ', DataSize.suffix_quad) }
		// AT&T CVT* names attach a size suffix to the integer side. The xmm
		// operand is always implicit; the L/Q suffix selects the rm32 vs rm64
		// (or reg32 vs reg64) row of the underlying Intel mnemonic.
		'CVTSI2SSL' {
			return Canon{
				name:     'CVTSI2SS'
				dst_size: DataSize.suffix_unkown
				src_size: DataSize.suffix_long
				ok:       true
			}
		}
		'CVTSI2SSQ' {
			return Canon{
				name:     'CVTSI2SS'
				dst_size: DataSize.suffix_unkown
				src_size: DataSize.suffix_quad
				ok:       true
			}
		}
		'CVTSI2SDL' {
			return Canon{
				name:     'CVTSI2SD'
				dst_size: DataSize.suffix_unkown
				src_size: DataSize.suffix_long
				ok:       true
			}
		}
		'CVTSI2SDQ' {
			return Canon{
				name:     'CVTSI2SD'
				dst_size: DataSize.suffix_unkown
				src_size: DataSize.suffix_quad
				ok:       true
			}
		}
		'CVTTSS2SIL' {
			return Canon{
				name:     'CVTTSS2SI'
				dst_size: DataSize.suffix_long
				src_size: DataSize.suffix_single
				ok:       true
			}
		}
		'CVTTSS2SIQ' {
			return Canon{
				name:     'CVTTSS2SI'
				dst_size: DataSize.suffix_quad
				src_size: DataSize.suffix_single
				ok:       true
			}
		}
		'CVTTSD2SIL' {
			return Canon{
				name:     'CVTTSD2SI'
				dst_size: DataSize.suffix_long
				src_size: DataSize.suffix_double
				ok:       true
			}
		}
		'CVTTSD2SIQ' {
			return Canon{
				name:     'CVTTSD2SI'
				dst_size: DataSize.suffix_quad
				src_size: DataSize.suffix_double
				ok:       true
			}
		}
		else {}
	}

	// SSE compare-predicate pseudo (cmpnlesd → cmpsd $6): map to the base
	// mnemonic and stash the predicate imm8 for emit_table to inject. Checked
	// before the suffixed-base / passthrough paths so `CMP`'s presence in
	// suffixed_bases can't mis-handle it.
	cmp_base, cmp_pred, is_cmp_pseudo := try_cmp_pseudo(name)
	if is_cmp_pseudo {
		return Canon{
			name:       cmp_base
			dst_size:   DataSize.suffix_unkown
			src_size:   DataSize.suffix_unkown
			inject_imm: int(cmp_pred)
			ok:         true
		}
	}

	if name == 'PUSH' || name == 'POP' {
		return sym(name, DataSize.suffix_quad)
	}
	if name in encoder.zero_op_canons {
		return sym(name, DataSize.suffix_quad)
	}
	if name in encoder.branch_canons {
		return sym(name, DataSize.suffix_quad)
	}
	if name in encoder.setcc_canons {
		return sym(name, DataSize.suffix_byte)
	}
	if name in encoder.sse_mnemonics_single {
		return sym(name, DataSize.suffix_single)
	}
	if name in encoder.sse_mnemonics_double {
		return sym(name, DataSize.suffix_double)
	}
	if name in encoder.sse_mnemonics_xmm128 {
		return sym(name, DataSize.suffix_xmm128)
	}
	if name == 'MOVD' {
		return sym('MOVD', DataSize.suffix_long)
	}

	// Asymmetric `mov{z,s}<src><dst>` family — MOVZX / MOVSX / MOVSXD.
	mzs_canon, mzs_dst, mzs_src, mzs_ok := parse_movz_movs(name)
	if mzs_ok {
		return Canon{
			name:     mzs_canon
			dst_size: mzs_dst
			src_size: mzs_src
			ok:       true
		}
	}

	if name in encoder.passthrough_canons {
		return sym(name, DataSize.suffix_unkown)
	}

	if name in encoder.suffixed_bases {
		return Canon{
			name:     name
			dst_size: DataSize.suffix_unkown
			src_size: DataSize.suffix_unkown
			alt_name: name
			ok:       true
		}
	}

	for base in encoder.suffixed_bases {
		size, ok := try_strip_size_suffix(name, base)
		if ok {
			// MOVQ / MOVD / MOVB etc. collide with SSE/MMX-side mnemonics that
			// share the same spelling (e.g. SSE2 MOVQ on xmm operands). Pass
			// `name` through as an alt so the lookup can fall back to it when
			// the integer-MOV row doesn't match.
			return Canon{
				name:     base
				dst_size: size
				src_size: size
				alt_name: name
				ok:       true
			}
		}
	}

	// AVX / VEX mnemonics: anything starting with `V` (length > 1) passes
	// through with an unknown size hint. The actual operand width is
	// inferred from the xmm/ymm siblings at lookup time.
	if name.len > 1 && name[0] == `V` {
		return sym(name, DataSize.suffix_unkown)
	}
	// AVX-512 mask-register instructions (KMOV, KAND, KOR, KXOR, KNOT, ...)
	// also pass through with an unknown size hint.
	if name.len > 1 && name[0] == `K` {
		return sym(name, DataSize.suffix_unkown)
	}
	// x87 FPU mnemonics: F-prefix passthrough. AT&T attaches `s` (32-bit
	// float), `l` (64-bit float), or `t` (80-bit tbyte) to the mnemonic as
	// a memory-operand size hint; we only strip those when the resulting
	// base is a known FPU mnemonic (so FMUL / FSUBR don't get their trailing
	// `L`/`R` mistaken for size suffixes).
	if name.len > 1 && name[0] == `F` {
		if name.len > 2 {
			last := name[name.len - 1]
			base := name[..name.len - 1]
			// x87 integer ops: suffix names an integer width (s=16, l=32, q=64).
			if base in encoder.fpu_int_bases {
				isz := match last {
					`S` { DataSize.suffix_word }
					`L` { DataSize.suffix_long }
					`Q` { DataSize.suffix_quad }
					else { DataSize.suffix_unkown }
				}
				if isz != .suffix_unkown {
					return sym(base, isz)
				}
			}
			if last == `S` && base in encoder.fpu_mem_bases {
				return sym(base, DataSize.suffix_long)
			}
			if last == `L` && base in encoder.fpu_mem_bases {
				return sym(base, DataSize.suffix_quad)
			}
			// 80-bit tbyte memory: width is wildcard for now (mem_any
			// matches any rmN slot the row demands).
			if last == `T` && base in encoder.fpu_tbyte_bases {
				return sym(base, DataSize.suffix_tbyte)
			}
		}
		return sym(name, DataSize.suffix_unkown)
	}

	return Canon{
		dst_size: DataSize.suffix_unkown
		src_size: DataSize.suffix_unkown
	}
}

fn is_zero_operand(canon string) bool {
	return canon in encoder.zero_op_canons
}

// ----- Operand classification -----

fn classify_register_size(s DataSize) OpClass {
	return match s {
		.suffix_byte { OpClass.reg8 }
		.suffix_word { OpClass.reg16 }
		.suffix_long { OpClass.reg32 }
		.suffix_quad { OpClass.reg64 }
		else { OpClass.@none }
	}
}

fn classify_memory_size(s DataSize) OpClass {
	return match s {
		.suffix_byte { OpClass.rm8 }
		.suffix_word { OpClass.rm16 }
		.suffix_long { OpClass.rm32 }
		.suffix_quad { OpClass.rm64 }
		.suffix_single { OpClass.xmmrm32 }
		.suffix_double { OpClass.xmmrm64 }
		.suffix_tbyte { OpClass.mem80 }
		.suffix_xmm128 { OpClass.xmmrm128 }
		.suffix_ymm256 { OpClass.ymmrm256 }
		.suffix_zmm512 { OpClass.zmmrm512 }
		// No size context (CLFLUSH / PREFETCH* / etc.): use the wildcard
		// `mem_any` class so the lookup accepts whichever rmN slot is on the
		// row.
		.suffix_unkown { OpClass.mem_any }
		else { OpClass.@none }
	}
}

fn classify_immediate_value(im Immediate, size_hint DataSize) OpClass {
	mut sym := []string{}
	v := eval_expr_get_symbol_64(im.expr, mut sym)
	if sym.len > 0 {
		return OpClass.imm32
	}
	if v == 1 {
		return OpClass.imm_one
	}
	// imm8 covers both signed (-128..127) and unsigned (0..255) 8-bit values.
	// For sign-extending ib forms (rm16/32/64 + imm8), values 128..255 are
	// filtered out inside find_best_match to avoid sign-extension corruption.
	if v >= -128 && v <= 255 {
		return OpClass.imm8
	}
	// A 16-bit-range value is an imm16 only for a genuinely 16-bit operand
	// (`pushw`, `movw`, ...). For an explicitly 32/64-bit operand there is no
	// imm16 encoding — GAS sign-extends a 32-bit immediate — so classifying it
	// as imm16 would select the 0x66-prefixed form and change the operation
	// width (`pushq $0x1234` must not become a 2-byte `pushw`, which corrupts
	// the stack).
	if v >= -32768 && v <= 65535 && size_hint != .suffix_quad && size_hint != .suffix_long {
		return OpClass.imm16
	}
	if v >= -(i64(1) << 31) && v <= ((i64(1) << 32) - 1) {
		return OpClass.imm32
	}
	return OpClass.imm64
}

fn classify_operand(op Expr, size_hint DataSize) OpClass {
	match op {
		Register {
			if op.lit == 'CL' {
				return OpClass.reg_cl
			}
			return classify_register_size(op.size)
		}
		Xmm {
			if op.size == .suffix_kreg {
				return OpClass.kreg
			}
			if op.size == .suffix_fpureg {
				// ST(0) is the implicit "fpu0" operand for r-/-r forms;
				// ST(1)..ST(7) are the regular fpureg slot.
				if op.base_offset == 0 {
					return OpClass.fpu0
				}
				return OpClass.fpureg
			}
			if op.size == .suffix_zmm512 {
				return OpClass.zmmreg
			}
			if op.size == .suffix_ymm256 {
				return OpClass.ymmreg
			}
			return OpClass.xmmreg
		}
		Indirection {
			return classify_memory_size(size_hint)
		}
		Immediate {
			return classify_immediate_value(op, size_hint)
		}
		Ident {
			return OpClass.label
		}
		else {
			return OpClass.@none
		}
	}
}

fn op_class_matches(parsed OpClass, required OpClass) bool {
	if parsed == required {
		return true
	}
	return match required {
		// reg* satisfies rm* (same width). reg_cl is also a byte register,
		// so it satisfies reg8 and rm8 — useful for instructions that take
		// a generic byte operand and happen to be passed CL.
		.reg8 { parsed == .reg_cl }
		.rm8 { parsed == .reg8 || parsed == .reg_cl || parsed == .mem_any }
		.rm16 { parsed == .reg16 || parsed == .mem_any }
		.rm32 { parsed == .reg32 || parsed == .mem_any }
		.rm64 { parsed == .reg64 || parsed == .mem_any }
		// imm subclassing. imm_one is the narrowest and satisfies every wider slot.
		.imm8 { parsed == .imm_one }
		.imm16 { parsed == .imm_one || parsed == .imm8 }
		.imm32 { parsed == .imm_one || parsed == .imm8 || parsed == .imm16 }
		.imm64 { parsed == .imm_one || parsed == .imm8 || parsed == .imm16 || parsed == .imm32 }
		// xmm: xmmreg also fills xmmrm{,8,16,32,64,128} slots.
		.xmmrm { parsed == .xmmreg || parsed == .xmmrm8 || parsed == .xmmrm16 || parsed == .xmmrm32 || parsed == .xmmrm64 || parsed == .xmmrm128 }
		.xmmrm8 { parsed == .xmmreg || parsed == .rm8 }
		.xmmrm16 { parsed == .xmmreg || parsed == .rm16 }
		// A memory operand's true width is fixed by the mnemonic, but vas's
		// AVX/SSE size heuristic may over-promote it (e.g. MOVHPD's m64 source
		// gets tagged xmmrm128 from the 128-bit xmm sibling). Since the bytes
		// of a memory reference don't depend on the matched width, and the
		// register operands pin the row, accept any xmm-memory width here.
		.xmmrm32 { parsed == .xmmreg || parsed == .xmmrm32 || parsed == .xmmrm64 || parsed == .xmmrm128 || parsed == .mem_any }
		.xmmrm64 { parsed == .xmmreg || parsed == .xmmrm32 || parsed == .xmmrm64 || parsed == .xmmrm128 || parsed == .mem_any }
		.xmmrm128 { parsed == .xmmreg || parsed == .xmmrm32 || parsed == .xmmrm64 || parsed == .xmmrm128 || parsed == .mem_any }
		// ymm: ymmreg also fills ymmrm/ymmrm256 slots; xmm fits ymmrm128 (low half).
		.ymmrm { parsed == .ymmreg || parsed == .ymmrm128 || parsed == .ymmrm256 }
		.ymmrm128 { parsed == .ymmreg || parsed == .xmmreg }
		.ymmrm256 { parsed == .ymmreg }
		// zmm subclasses
		.zmmrm { parsed == .zmmreg || parsed == .zmmrm128 || parsed == .zmmrm256 || parsed == .zmmrm512 }
		.zmmrm128 { parsed == .zmmreg || parsed == .xmmreg }
		.zmmrm256 { parsed == .zmmreg || parsed == .ymmreg }
		.zmmrm512 { parsed == .zmmreg }
		// K-mask: krm slot accepts a K register or any sized memory operand.
		.krm { parsed == .kreg || parsed == .rm8 || parsed == .rm16 || parsed == .rm32 || parsed == .rm64 }
		// Memory-only slots: satisfied by a parsed memory operand of the right
		// width (memory parses to rmN / xmmrmN / ymmrmN, never to a register
		// class) or by the unsized-memory wildcard. A register never matches.
		.mem8 { parsed == .rm8 || parsed == .mem_any }
		.mem16 { parsed == .rm16 || parsed == .mem_any }
		.mem32 { parsed == .rm32 || parsed == .xmmrm32 || parsed == .xmmrm64 || parsed == .xmmrm128 || parsed == .mem_any }
		.mem64 { parsed == .rm64 || parsed == .xmmrm32 || parsed == .xmmrm64 || parsed == .xmmrm128 || parsed == .mem_any }
		.mem128 { parsed == .xmmrm128 || parsed == .mem_any }
		.mem256 { parsed == .ymmrm256 || parsed == .mem_any }
		.mem80 { parsed == .mem80 || parsed == .mem_any }
		.mem_any {
			parsed in [OpClass.rm8, .rm16, .rm32, .rm64, .xmmrm32, .xmmrm64, .xmmrm128,
				.ymmrm256, .zmmrm512, .mem_any]
		}
		// fpureg slot also accepts an implicit fpu0 (ST(0)).
		.fpureg { parsed == .fpu0 }
		// label as relative branch target.
		.rel8 { parsed == .label }
		.rel32 { parsed == .label || parsed == .rel8 }
		else { false }
	}
}

// op_class_str renders an OpClass into a short human-readable name used in
// diagnostics ("reg64", "imm8", "xmmreg", ...). It mirrors the enum so the
// label the user sees matches the table they'd consult.
fn op_class_str(c OpClass) string {
	return match c {
		.@none { '<none>' }
		.reg8 { 'reg8' }
		.reg16 { 'reg16' }
		.reg32 { 'reg32' }
		.reg64 { 'reg64' }
		.rm8 { 'rm8' }
		.rm16 { 'rm16' }
		.rm32 { 'rm32' }
		.rm64 { 'rm64' }
		.imm8 { 'imm8' }
		.imm16 { 'imm16' }
		.imm32 { 'imm32' }
		.imm64 { 'imm64' }
		.imm_one { 'imm($=1)' }
		.reg_cl { 'reg(%cl)' }
		.xmmreg { 'xmmreg' }
		.xmmrm { 'xmmrm' }
		.xmmrm8 { 'xmmrm8' }
		.xmmrm16 { 'xmmrm16' }
		.xmmrm32 { 'xmmrm32' }
		.xmmrm64 { 'xmmrm64' }
		.xmmrm128 { 'xmmrm128' }
		.ymmreg { 'ymmreg' }
		.ymmrm { 'ymmrm' }
		.ymmrm128 { 'ymmrm128' }
		.ymmrm256 { 'ymmrm256' }
		.zmmreg { 'zmmreg' }
		.zmmrm { 'zmmrm' }
		.zmmrm128 { 'zmmrm128' }
		.zmmrm256 { 'zmmrm256' }
		.zmmrm512 { 'zmmrm512' }
		.kreg { 'kreg' }
		.krm { 'krm' }
		.mem_any { 'mem' }
		.mem8 { 'mem8' }
		.mem16 { 'mem16' }
		.mem32 { 'mem32' }
		.mem64 { 'mem64' }
		.mem128 { 'mem128' }
		.mem256 { 'mem256' }
		.mem80 { 'mem80' }
		.fpureg { 'fpureg' }
		.fpu0 { 'fpu0(%st)' }
		.label { 'label' }
		.rel8 { 'rel8' }
		.rel32 { 'rel32' }
	}
}

// op_class_list_str joins a list of OpClasses for diagnostics.
fn op_class_list_str(cs []OpClass) string {
	if cs.len == 0 {
		return '()'
	}
	mut s := '('
	for i, c in cs {
		if i > 0 {
			s += ', '
		}
		s += op_class_str(c)
	}
	s += ')'
	return s
}

// CandidateMatch describes a row that shares the mnemonic + arity with a
// failing lookup. `mismatch_at` is the first operand position whose class
// didn't satisfy the row, used to sort candidates by "closeness" so the
// most plausible alternatives surface first.
struct CandidateMatch {
	enc         &InstrEnc
	mismatch_at int  // 0..arity, or arity if all operands matched (impossible here)
}

// collect_candidates returns rows sharing the mnemonic + arity, ranked by
// the position of their first operand mismatch (later = closer to a match).
fn collect_candidates(mnemonic string, parsed []OpClass) []CandidateMatch {
	mut out := []CandidateMatch{}
	for table in [encoder.insns_table, encoder.generated_insns_table] {
		for i, _ in table {
			enc := unsafe { &table[i] }
			if enc.mnemonic != mnemonic || enc.operands.len != parsed.len {
				continue
			}
			mut at := 0
			for j, req in enc.operands {
				if !op_class_matches(parsed[j], req) {
					break
				}
				at = j + 1
			}
			out << CandidateMatch{
				enc:         enc
				mismatch_at: at
			}
		}
	}
	out.sort(a.mismatch_at > b.mismatch_at)
	return out
}

fn estimate_encoded_length(enc &InstrEnc) int {
	mut n := 0
	if enc.evex_present {
		n += 4 // 0x62 + 3 payload bytes
	} else if enc.vex_present {
		// 2-byte VEX is only available with mm=0F and W=0; otherwise 3-byte.
		// We don't know X/B at lookup time, so this is a lower bound.
		n += if enc.vex_mm == 1 && enc.vex_w == 0 { 2 } else { 3 }
	} else {
		n += enc.prefixes.len
		if enc.rex_w {
			n += 1
		}
	}
	n += enc.opcode.len
	if enc.reg_field != .@none {
		n += 1 // ModR/M
	}
	n += match enc.imm {
		.@none { 0 }
		.ib { 1 }
		.iw { 2 }
		.id { 4 }
		.iq { 8 }
	}
	n += match enc.rel {
		.@none { 0 }
		.rel8 { 1 }
		.rel32 { 4 }
	}
	return n
}

// MatchResult locates the chosen row by (table_id, index) so the emitter can
// fetch it later from either the hand-written or generated array.
pub struct MatchResult {
pub:
	from_generated bool
	index          int
}

fn find_best_match(mnemonic string, parsed_classes []OpClass, require_evex bool, imm_val i64) (MatchResult, bool) {
	mut best := MatchResult{}
	mut best_len := 0
	mut found := false

	for i, enc in encoder.insns_table {
		if enc.mnemonic != mnemonic || enc.operands.len != parsed_classes.len {
			continue
		}
		if require_evex && !enc.evex_present {
			continue
		}
		// A sign-extending ib form paired with a wider operand (rm16/32/64)
		// would corrupt values in 128..255.  Skip such encodings; the
		// imm32 row will be chosen instead.
		if enc.imm == .ib && imm_val > 127 && imm_val <= 255 {
			if enc.operands.any(fn (op OpClass) bool {
				return op in [OpClass.rm16, .rm32, .rm64, .reg16, .reg32, .reg64]
			}) {
				continue
			}
		}
		mut ok := true
		for j, req in enc.operands {
			if !op_class_matches(parsed_classes[j], req) {
				ok = false
				break
			}
		}
		if !ok {
			continue
		}
		l := estimate_encoded_length(&enc)
		if !found || l < best_len {
			best = MatchResult{
				from_generated: false
				index:          i
			}
			best_len = l
			found = true
		}
	}

	for i, enc in encoder.generated_insns_table {
		if enc.mnemonic != mnemonic || enc.operands.len != parsed_classes.len {
			continue
		}
		if require_evex && !enc.evex_present {
			continue
		}
		if enc.imm == .ib && imm_val > 127 && imm_val <= 255 {
			if enc.operands.any(fn (op OpClass) bool {
				return op in [OpClass.rm16, .rm32, .rm64, .reg16, .reg32, .reg64]
			}) {
				continue
			}
		}
		mut ok := true
		for j, req in enc.operands {
			if !op_class_matches(parsed_classes[j], req) {
				ok = false
				break
			}
		}
		if !ok {
			continue
		}
		l := estimate_encoded_length(&enc)
		if !found || l < best_len {
			best = MatchResult{
				from_generated: true
				index:          i
			}
			best_len = l
			found = true
		}
	}

	return best, found
}

fn lookup_row(m MatchResult) &InstrEnc {
	if m.from_generated {
		return &encoder.generated_insns_table[m.index]
	}
	return &encoder.insns_table[m.index]
}
