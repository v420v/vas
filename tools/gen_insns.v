module main

// gen_insns.v
//
// Reads NASM's third_party/insns.dat and emits encoder/insns_table.gen.v with
// rows the encoder can use. This is intentionally a *minimal* subset:
//
//   - Per-line size macros ($bwdq, $wdq, $bwd, $wd, $dq, $wq) only
//   - Jcc / SETcc / CMOVcc rows expanded across all 16 condition codes
//   - Long-mode-compatible rows only (skip NOLONG, OBSOLETE, APX)
//   - No VEX / EVEX / XOP / vsib / mib
//   - Mnemonics restricted to the encoder's canonical set
//
// Anything outside that envelope is silently skipped and reported in the stats
// printed at the end. This file lives outside `encoder/` so the encoder
// crate has zero parse-time work; rerun manually:
//
//     v run tools/gen_insns.v

import os

const supported_canons = [
	// arith / logic / move
	'MOV', 'ADD', 'OR', 'ADC', 'SBB', 'AND', 'SUB', 'XOR', 'CMP', 'TEST',
	'NOT', 'NEG', 'MUL', 'DIV', 'IDIV', 'IMUL', 'LEA',
	// shifts / rotates
	'SHL', 'SHR', 'SAR', 'SAL', 'ROL', 'ROR', 'RCL', 'RCR',
	// inc/dec/exchange/compare-exchange
	'INC', 'DEC', 'XCHG', 'XADD', 'CMPXCHG',
	// bit scan / bswap / population
	'BSF', 'BSR', 'BSWAP', 'POPCNT', 'LZCNT', 'TZCNT',
	// stack / control
	'PUSH', 'POP', 'RET', 'SYSCALL', 'NOP', 'HLT', 'LEAVE',
	// sign/zero extension to AX/EAX/RAX (Intel names; AT&T spellings
	// CLTQ/CLTD/CQTO/CWTL canonicalize to these in the encoder).
	'CDQE', 'CDQ', 'CQO', 'CWDE', 'CBW',
	// jumps / calls
	'CALL', 'JMP',
	// Jcc family (16 conditional jumps)
	'JE', 'JNE', 'JL', 'JG', 'JLE', 'JGE', 'JNB', 'JBE', 'JNBE', 'JP', 'JA', 'JB', 'JS', 'JNS',
	'JO', 'JNO', 'JC', 'JNC', 'JZ', 'JNZ', 'JNA', 'JAE', 'JNGE', 'JNL', 'JNG', 'JNLE', 'JPE', 'JPO', 'JNP',
	// SETcc family
	'SETO', 'SETNO', 'SETB', 'SETNB', 'SETAE', 'SETE', 'SETNE', 'SETBE', 'SETA', 'SETPO',
	'SETL', 'SETGE', 'SETLE', 'SETG', 'SETC', 'SETNC', 'SETZ', 'SETNZ', 'SETP', 'SETPE', 'SETNP',
	'SETS', 'SETNS', 'SETNA', 'SETNBE', 'SETNGE', 'SETNL', 'SETNG', 'SETNLE',
	// CMOVcc family
	'CMOVO', 'CMOVNO', 'CMOVB', 'CMOVNB', 'CMOVAE', 'CMOVE', 'CMOVNE', 'CMOVBE', 'CMOVA',
	'CMOVS', 'CMOVNS', 'CMOVP', 'CMOVPO', 'CMOVL', 'CMOVGE', 'CMOVLE', 'CMOVG',
	'CMOVC', 'CMOVNC', 'CMOVZ', 'CMOVNZ', 'CMOVNA', 'CMOVNBE', 'CMOVPE', 'CMOVNGE', 'CMOVNL',
	'CMOVNG', 'CMOVNLE',
	// SSE / SSE2 (no VEX). Mnemonic carries the operand width; no AT&T suffix.
	'MOVSS', 'MOVSD', 'MOVAPS', 'MOVAPD', 'MOVUPS', 'MOVUPD', 'MOVD',
	'ADDSS', 'ADDSD', 'SUBSS', 'SUBSD', 'MULSS', 'MULSD', 'DIVSS', 'DIVSD',
	'UCOMISS', 'UCOMISD', 'COMISS', 'COMISD',
	'XORPS', 'XORPD', 'ANDPS', 'ANDPD', 'ORPS', 'ORPD', 'ANDNPS', 'ANDNPD', 'PXOR',
	'CVTSS2SD', 'CVTSD2SS',
	// Packed / extra SSE arithmetic emitted by the auto-vectorizer.
	'ADDPS', 'ADDPD', 'SUBPS', 'SUBPD', 'MULPS', 'MULPD', 'DIVPS', 'DIVPD',
	'MAXPS', 'MAXPD', 'MINPS', 'MINPD', 'MAXSS', 'MAXSD', 'MINSS', 'MINSD',
	'SQRTPS', 'SQRTPD', 'SQRTSS', 'SQRTSD', 'RSQRTPS', 'RSQRTSS', 'RCPPS', 'RCPSS',
	'HADDPD', 'HADDPS', 'HSUBPD', 'HSUBPS', 'ADDSUBPD', 'ADDSUBPS',
	'ROUNDPS', 'ROUNDPD', 'ROUNDSS', 'ROUNDSD',
	'BLENDPS', 'BLENDPD', 'BLENDVPS', 'BLENDVPD', 'DPPS', 'DPPD',
	// Packed integer/float conversions.
	'CVTDQ2PS', 'CVTPS2DQ', 'CVTTPS2DQ', 'CVTDQ2PD', 'CVTPD2DQ', 'CVTTPD2DQ',
	'CVTPS2PD', 'CVTPD2PS', 'CVTSS2SI', 'CVTSD2SI',
	// Asymmetric / forced-immediate move family
	'MOVZX', 'MOVSX', 'MOVSXD', 'MOVABSQ',
	// SSE conversion (asymmetric — integer side selected by AT&T L/Q suffix).
	'CVTSI2SS', 'CVTSI2SD', 'CVTTSS2SI', 'CVTTSD2SI', 'CVTSS2SI', 'CVTSD2SI',
	// SSE extract / insert for vectors (mri / rmi forms).
	'EXTRACTPS', 'INSERTPS', 'PEXTRB', 'PEXTRW', 'PEXTRD', 'PEXTRQ', 'PINSRB', 'PINSRW',
	'PINSRD', 'PINSRQ',
	// Double-width shift (mri form).
	'SHLD', 'SHRD',
	// BMI1 / BMI2 / ADX (bit manipulation, shift-without-flag).
	'BEXTR', 'BZHI', 'BLSI', 'BLSMSK', 'BLSR', 'MULX', 'PDEP', 'PEXT', 'RORX', 'SARX',
	'SHLX', 'SHRX', 'ADCX', 'ADOX',
	// SSE2/SSSE3 packed integer (no AT&T suffix).
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
	'PAVGB', 'PAVGW', 'PACKSSWB', 'PACKSSDW', 'PACKUSWB', 'PACKUSDW',
	'POR', 'PAND', 'PANDN',
	'PMOVMSKB', 'MOVMSKPS', 'MOVMSKPD',
	'PSLLW', 'PSLLD', 'PSLLQ', 'PSRLW', 'PSRLD', 'PSRLQ', 'PSRAW', 'PSRAD',
	'PSLLDQ', 'PSRLDQ',
	// SSE moves
	'MOVDQU', 'MOVDQA', 'MOVNTDQ', 'MOVNTPS', 'MOVNTPD', 'MOVNTI',
	'MOVHPS', 'MOVHPD', 'MOVLPS', 'MOVLPD', 'MOVHLPS', 'MOVLHPS',
	'MOVDDUP', 'MOVSHDUP', 'MOVSLDUP',
	'SHUFPS', 'SHUFPD', 'UNPCKHPS', 'UNPCKHPD', 'UNPCKLPS', 'UNPCKLPD',
	'CMPPS', 'CMPPD',
	// System / control / fence
	'CPUID', 'RDTSC', 'RDTSCP', 'RDPMC', 'RDMSR', 'WRMSR', 'RDPID', 'RDRAND', 'RDSEED',
	'CLI', 'STI', 'CLD', 'STD', 'CLC', 'STC', 'CMC', 'SAHF', 'LAHF',
	'INT', 'INT3', 'INTO', 'IRET', 'IRETQ', 'IRETD',
	'SYSENTER', 'SYSEXIT', 'SYSRET', 'SYSRETQ',
	'WBINVD', 'INVD', 'INVLPG', 'SWAPGS', 'MONITOR', 'MWAIT', 'PAUSE',
	'LFENCE', 'MFENCE', 'SFENCE',
	'CLAC', 'STAC', 'ENDBR32', 'ENDBR64', 'CLDEMOTE', 'SERIALIZE',
	'XEND', 'XTEST', 'XABORT', 'XBEGIN', 'XGETBV', 'XSETBV', 'XSAVE', 'XSAVES', 'XRSTOR', 'XRSTORS',
	'UD0', 'UD1', 'UD2', 'UD2A', 'UD2B',
	'AAA', 'AAD', 'AAM', 'AAS', 'DAA', 'DAS',
	'PUSHF', 'PUSHFQ', 'PUSHFD', 'POPF', 'POPFQ', 'POPFD',
	'PUSHA', 'PUSHAD', 'POPA', 'POPAD',
	'EMMS', 'GETSEC', 'RSM', 'TLBSYNC',
	// Cache / hint
	'CLFLUSH', 'CLFLUSHOPT', 'CLWB',
	'PREFETCH', 'PREFETCHT0', 'PREFETCHT1', 'PREFETCHT2', 'PREFETCHNTA',
	'PREFETCHW', 'PREFETCHWT1',
	// Atomic
	'CMPXCHG8B', 'CMPXCHG16B',
	// Base register read/write
	'WRFSBASE', 'WRGSBASE', 'RDFSBASE', 'RDGSBASE',
	// Bit-test (suffixed)
	'BT', 'BTS', 'BTR', 'BTC', 'MOVBE', 'CRC32',
	// Misc
	'PTWRITE', 'PCONFIG',
	// SSE2 / MMX MOVQ / MOVD that share spelling with the integer MOV.Q form
	// — the encoder's `Canon.alt_name` falls back to these rows when the
	// integer MOV row doesn't match xmm operands.
	'MOVQ', 'MOVD',
	// System / descriptor table / segment-load / VMM
	'LIDT', 'LGDT', 'SIDT', 'SGDT', 'LLDT', 'SLDT', 'LTR', 'STR',
	'LMSW', 'SMSW', 'LAR', 'LSL',
	'LDS', 'LES', 'LFS', 'LGS', 'LSS',
	'VMLAUNCH', 'VMRESUME', 'VMXOFF', 'VMXON', 'VMCALL', 'VMFUNC',
	'VMRUN', 'VMSAVE', 'VMLOAD', 'STGI', 'CLGI', 'INVLPGA',
	'VMCLEAR', 'VMPTRLD', 'VMPTRST', 'VMREAD', 'VMWRITE',
	'INVEPT', 'INVVPID', 'INVPCID',
	// CET (shadow stack)
	'INCSSPD', 'INCSSPQ', 'RDSSPD', 'RDSSPQ', 'SAVEPREVSSP', 'RSTORSSP',
	'WRSSD', 'WRSSQ', 'WRUSSD', 'WRUSSQ', 'SETSSBSY', 'CLRSSBSY',
	// XSAVE family extensions
	'XSAVEC', 'XSAVEC64', 'XSAVEOPT', 'XSAVEOPT64',
	// Recent additions (UMONITOR / UMWAIT / TPAUSE / MOVDIRI / MOVDIR64B / ENQCMD)
	'TPAUSE', 'UMONITOR', 'UMWAIT', 'MOVDIRI', 'MOVDIR64B',
	'ENQCMD', 'ENQCMDS', 'WAITPKG',
	// AMD-specific
	'CLZERO', 'MONITORX', 'MWAITX', 'WBNOINVD', 'IRETF',
	// AES / SHA / CRYPTO (non-VEX)
	'AESDEC', 'AESDECLAST', 'AESENC', 'AESENCLAST', 'AESIMC', 'AESKEYGENASSIST',
	'SHA1MSG1', 'SHA1MSG2', 'SHA1NEXTE', 'SHA1RNDS4',
	'SHA256MSG1', 'SHA256MSG2', 'SHA256RNDS2',
	'PCLMULQDQ',
	// Aliases / less-common
	'CMOVNP', 'RETN', 'RETF', 'CMPSD', 'CMPSS',
	'INSB', 'INSW', 'INSD', 'OUTSB', 'OUTSW', 'OUTSD',
	'IN', 'OUT',
	// FXSAVE / FNSAVE family
	'FXSAVE', 'FXSAVE64', 'FXRSTOR', 'FXRSTOR64',
	'FNSAVE', 'FRSTOR', 'FNSTENV', 'FLDENV', 'FNSTCW', 'FLDCW',
	'FUCOMI', 'FUCOMIP', 'FCOMI', 'FCOMIP', 'FCMOVE', 'FCMOVNE',
	'FCMOVB', 'FCMOVNB', 'FCMOVBE', 'FCMOVNBE', 'FCMOVU', 'FCMOVNU',
]

// cc codes per Intel SDM Appendix B.1.
// Includes the 16 base condition mnemonics plus the AT&T-flavored aliases
// (C/NC/Z/NZ/PE/NA/AE/NGE/NL/NG/NLE) that share opcodes with them.
const cc_table = [
	CcEntry{'O', 0x0},
	CcEntry{'NO', 0x1},
	CcEntry{'B', 0x2},
	CcEntry{'C', 0x2},
	CcEntry{'NB', 0x3},
	CcEntry{'NC', 0x3},
	CcEntry{'AE', 0x3},
	CcEntry{'E', 0x4},
	CcEntry{'Z', 0x4},
	CcEntry{'NE', 0x5},
	CcEntry{'NZ', 0x5},
	CcEntry{'BE', 0x6},
	CcEntry{'NA', 0x6},
	CcEntry{'A', 0x7},
	CcEntry{'NBE', 0x7},
	CcEntry{'S', 0x8},
	CcEntry{'NS', 0x9},
	CcEntry{'P', 0xa},
	CcEntry{'PE', 0xa},
	CcEntry{'PO', 0xb},
	CcEntry{'NP', 0xb},
	CcEntry{'L', 0xc},
	CcEntry{'NGE', 0xc},
	CcEntry{'GE', 0xd},
	CcEntry{'NL', 0xd},
	CcEntry{'LE', 0xe},
	CcEntry{'NG', 0xe},
	CcEntry{'G', 0xf},
	CcEntry{'NLE', 0xf},
]

struct CcEntry {
	suffix string
	value  u8
}

// Per-size context produced by macro expansion.
struct SizeCtx {
	letter      string // 'b' | 'w' | 'd' | 'q'
	op_class_sz int    // 8 | 16 | 32 | 64 — used for `rm#` / `reg#` / `imm#` substitution
	emits_o66   bool   // does `o#` add 0x66 prefix?
	rex_w       bool   // does `o#` set REX.W?
	opbump      u8     // adds to literal opcode byte when token has trailing `#`
	imm_token   string // 'ib' | 'iw' | 'id' (i# expansion)
	imm_ld_tok  string // 'ib' | 'iw' | 'id' | 'iq' (i## expansion)
	// `ko#`: AVX-512 mask-register VEX prefix combo (per size letter).
	//   b: pp=66 (1) w=0    w: pp=np (0) w=0
	//   d: pp=66 (1) w=1    q: pp=np (0) w=1
	// Also reused as the `XX##` opcode bump (b/w → +0, d/q → +1) since the
	// pattern matches ko_w.
	ko_pp u8
	ko_w  u8
	// `w##`: KSHIFT-family W bit (b → 0, w → 1, d → 0, q → 1). Distinct
	// from `w#` (which is rex_w).
	w_hh u8
}

fn size_ctx_for(letter string) SizeCtx {
	return match letter {
		'b' { SizeCtx{'b', 8, false, false, 0, 'ib', 'ib', 1, 0, 0} }
		'w' { SizeCtx{'w', 16, true, false, 1, 'iw', 'iw', 0, 0, 1} }
		'd' { SizeCtx{'d', 32, false, false, 1, 'id', 'id', 1, 1, 0} }
		'q' { SizeCtx{'q', 64, false, true, 1, 'id', 'iq', 0, 1, 1} } // q sign-extends i# from id
		'z' { SizeCtx{'z', 0, false, false, 0, '', '', 0, 0, 0} } // default-width form (RET, LEAVE)
		else { SizeCtx{'?', 0, false, false, 0, '', '', 0, 0, 0} }
	}
}

fn macro_letters(name string) []string {
	return match name {
		// Multi-size macros — expand into one row per letter.
		'\$bwdq' { ['b', 'w', 'd', 'q'] }
		'\$bwd' { ['b', 'w', 'd'] }
		'\$wdq' { ['w', 'd', 'q'] }
		'\$wd' { ['w', 'd'] }
		'\$dq' { ['d', 'q'] }
		'\$wq' { ['w', 'q'] }
		// Single-size macros — used by K-mask AVX-512 rows like `$k $b KMOV%`.
		'\$b' { ['b'] }
		'\$w' { ['w'] }
		'\$d' { ['d'] }
		'\$q' { ['q'] }
		// $zwd / $zwdq: NASM uses 'z' for the default-size form. We only emit
		// that variant; the explicit-size variants (RETW, RETD, RETQ etc.)
		// canonicalize back to the same row anyway.
		'\$zwd' { ['z'] }
		'\$zwdq' { ['z'] }
		else { []string{} }
	}
}

fn size_ctx_for_z() SizeCtx {
	return SizeCtx{'z', 0, false, false, 0, '', '', 0, 0, 0}
}

struct GenRow {
	mnemonic     string
	operands     []string // OpClass enum-symbol names (without the `.` prefix)
	op_order     string
	prefixes     []u8
	rex_w        bool
	opcode       []u8
	plus_reg     bool
	reg_field    string
	imm          string
	rel          string
	vex_present  bool
	vex_l        u8
	vex_w        u8
	vex_pp       u8
	vex_mm       u8
	evex_present bool
	evex_l       u8
	evex_w       u8
	evex_pp      u8
	evex_mm      u8
}

struct Stats {
mut:
	total            int
	blank_or_comment int
	meta_macro       int
	unsupported      int
	skipped_long     int // NOLONG / OBSOLETE
	skipped_apx      int
	skipped_vex      int
	skipped_op_tag   int
	skipped_operands int
	skipped_encoding int
	emitted          int
}

// -----------------------------------------------------------------------------
// Line tokenization
// -----------------------------------------------------------------------------

struct RawLine {
	macros      []string
	mnemonic    string
	operand_str string
	enc_tag     string
	enc_body    string
	flags       []string
}

fn split_ws(s string) []string {
	mut out := []string{}
	for tok in s.split_any(' \t') {
		t := tok.trim_space()
		if t != '' {
			out << t
		}
	}
	return out
}

fn tokenize_line(line string) ?RawLine {
	// strip ';' comment
	mut body := line
	if i := body.index(';') {
		body = body[..i]
	}
	body = body.trim_space()
	if body == '' {
		return none
	}

	// find encoding bracket
	lb := body.index('[') or { return none }
	rb := body.last_index(']') or { return none }
	if lb >= rb {
		return none
	}
	pre := body[..lb].trim_space()
	enc := body[lb + 1..rb].trim_space()
	post := body[rb + 1..].trim_space()

	parts := split_ws(pre)
	if parts.len < 2 {
		return none
	}

	mut macros := []string{}
	mut i := 0
	for i < parts.len && parts[i].starts_with('\$') {
		macros << parts[i]
		i++
	}
	if i + 2 > parts.len {
		return none
	}
	mnemonic := parts[i]
	operand_str := parts[i + 1]

	// encoding inside brackets:
	//   1 colon : `[tag: body]`              — most non-EVEX rows
	//   2 colons: `[tag:tuple_type: body]`   — EVEX rows. We currently ignore tuple_type
	//                                          (no disp8 compression yet) but must skip
	//                                          past it to reach the body.
	//   0 colons: `[ body]`                  — zero-operand instructions like `[ c3]`
	mut tag := ''
	mut enc_body := enc
	enc_parts := enc.split(':')
	if enc_parts.len >= 2 {
		tag = enc_parts[0].trim_space()
		enc_body = enc_parts[enc_parts.len - 1].trim_space()
	}

	mut flags := []string{}
	for tok in post.split(',') {
		t := tok.trim_space()
		if t != '' {
			flags << t
		}
	}

	return RawLine{
		macros:      macros
		mnemonic:    mnemonic
		operand_str: operand_str
		enc_tag:     tag
		enc_body:    enc_body
		flags:       flags
	}
}

// -----------------------------------------------------------------------------
// Filtering
// -----------------------------------------------------------------------------

fn flags_kill_long_mode(flags []string) bool {
	return 'NOLONG' in flags || 'OBSOLETE' in flags || 'PSEUDO' in flags
}

fn flags_apx(flags []string) bool {
	return 'APX' in flags
}

fn enc_has_advanced_prefix(body string) bool {
	for tok in split_ws(body) {
		// VEX and EVEX are now supported; only filter XOP, REX2, VSIB, MIB.
		if tok.starts_with('xop') || tok.starts_with('rex2') || tok.starts_with('vsib')
			|| tok.starts_with('vm32') || tok.starts_with('vm64') || tok in ['mib'] {
			return true
		}
	}
	return false
}

fn op_tag_supported(t string) bool {
	return t in ['', '-', 'r', 'm', 'i', 'rm', 'mr', 'mi', 'ri', 'rmi', 'mri', 'rvm',
		'mvr', 'rmv', 'vmi', 'rvmi', 'rvms', 'rvsm', 'r-', '-r']
}

// -----------------------------------------------------------------------------
// Operand spec parsing
// -----------------------------------------------------------------------------

fn parse_operand_spec(spec string, sz SizeCtx, default_size int) ?[]string {
	if spec == 'void' {
		return []string{}
	}
	// x87 `fpureg|to` rows encode the alternate "destination is ST(i)"
	// direction. The bare-fpureg row (without `|to`) covers the canonical
	// `fadd %st(i)` semantics; skipping the `|to` rows keeps lookup ties
	// resolving to that form.
	if spec.contains('|to') {
		return none
	}
	mut out := []string{}
	for raw in spec.split(',') {
		// drop |abs, |near etc. — keep the first alternative
		alt := raw.split('|')[0].trim_space()
		// drop trailing decoration: * ? :
		mut a := alt.trim_string_right('*').trim_string_right('?').trim_string_right(':')
		// strip a leading colon
		a = a.trim_string_left(':')
		// `xmmrm` / `ymmrm` without an explicit size resolves to the
		// operand-width flag (SB/SW/SD/SQ/SO/SY/SZ).
		if a == 'xmmrm' && default_size > 0 {
			a = 'xmmrm' + default_size.str()
		}
		if a == 'ymmrm' && default_size > 0 {
			a = 'ymmrm' + default_size.str()
		}
		if a == 'zmmrm' && default_size > 0 {
			a = 'zmmrm' + default_size.str()
		}
		oc := classify_operand(a, sz) or { return none }
		out << oc
	}
	return out
}

// resolve_op_size_flag picks the operand-width hint NASM uses when an
// operand spec is given without an explicit size (e.g. bare `xmmrm`).
//   SB=8 SW=16 SD=32 SQ=64 SO=128 SY=256 SZ=512
// Returns 0 if no such flag is present.
fn resolve_op_size_flag(flags []string) int {
	if 'SB' in flags {
		return 8
	}
	if 'SW' in flags {
		return 16
	}
	if 'SD' in flags {
		return 32
	}
	if 'SQ' in flags {
		return 64
	}
	if 'SO' in flags {
		return 128
	}
	if 'SY' in flags {
		return 256
	}
	if 'SZ' in flags {
		return 512
	}
	return 0
}

fn classify_operand(a string, sz SizeCtx) ?string {
	// K-mask registers: `kreg`, `kreg#` and `krm#` all refer to K0-K7. The
	// width hint in `#` is the *operation* width, not the register width
	// (K registers themselves are size-agnostic).
	if a.starts_with('kreg') {
		return 'kreg'
	}
	// `krm` / `krm#`: either a K register or a memory of mnemonic-determined
	// width. We classify it as the wildcard `krm` slot; the lookup table's
	// `op_class_matches` accepts both kreg and any rm* there.
	if a.starts_with('krm') {
		return 'krm'
	}
	// Broadcast memory operands `m{N}bcst` are alternative encodings of the
	// xmm/ymm/zmm-rm slot used with the `{1toK}` decorator. We don't emit
	// the decorator yet, but we classify them as the equivalent xmmrm/ymmrm/
	// zmmrm class so the rows generate (and behave like the non-broadcast
	// row when invoked without the decorator).
	if a.ends_with('bcst') {
		return 'xmmrm128'
	}
	// `sbyte` / `sbyte#`: always a signed byte that sign-extends to operand size.
	if a == 'sbyte' || a == 'sbyte#' {
		return 'imm8'
	}
	// `imm##` means the full immediate width (q gets imm64).
	if a == 'imm##' {
		return 'imm' + sz.op_class_sz.str()
	}
	// `imm#` means the sign-extended slot: q gets imm32, other sizes get natural width.
	if a == 'imm#' {
		sz_se := if sz.letter == 'q' { 32 } else { sz.op_class_sz }
		return 'imm' + sz_se.str()
	}
	// `mem` without a size is used by instructions that take a generic
	// memory pointer (CLFLUSH, PREFETCH*, FXSAVE, etc.). The `mem_any`
	// required slot matches a memory operand of any width (but not a register).
	if a == 'mem' && sz.op_class_sz == 0 {
		return 'mem_any'
	}
	// Generic single-`#` substitution (full size) for rm/reg/mem etc.
	s := a.replace('#', sz.op_class_sz.str())
	return match s {
		'reg8' { 'reg8' }
		'reg16' { 'reg16' }
		'reg32' { 'reg32' }
		'reg64' { 'reg64' }
		'rm8' { 'rm8' }
		'rm16' { 'rm16' }
		'rm32' { 'rm32' }
		'rm64' { 'rm64' }
		// Memory-ONLY GPR-width operands. Kept distinct from rmN so a register
		// can't satisfy a memory-only encoding (e.g. the `66 0F D6` MOVQ store
		// form, which a GPR must NOT match — it needs `66 REX.W 0F 7E`).
		'mem8' { 'mem8' }
		'mem16' { 'mem16' }
		'mem32' { 'mem32' }
		'mem64' { 'mem64' }
		// 80-bit memory (x87 long double / BCD: FLDT/FSTPT/FBLD/FBSTP).
		'mem80' { 'mem80' }
		'mem' { 'mem' + sz.op_class_sz.str() }
		'imm8' { 'imm8' }
		'imm16' { 'imm16' }
		'imm32' { 'imm32' }
		'imm64' { 'imm64' }
		// `imm` without an explicit size: the macro-expanded version becomes
		// imm8/16/32/64 from the size letter. Non-macro rows (no size letter)
		// default to imm8 — the encoding column always specifies the actual
		// width via `ib`/`iw`/`id`/`iq`, so the operand class is just for
		// matching against parsed values.
		'imm' {
			if sz.op_class_sz == 0 { 'imm8' } else { 'imm' + sz.op_class_sz.str() }
		}
		'short', 'near' { 'rel32' }
		'rel8' { 'rel8' }
		'rel32' { 'rel32' }
		// SSE: xmm registers and xmm/memory operands.
		'xmmreg' { 'xmmreg' }
		'xmmrm' { 'xmmrm' }
		'xmmrm8' { 'xmmrm8' }
		'xmmrm16' { 'xmmrm16' }
		'xmmrm32' { 'xmmrm32' }
		'xmmrm64' { 'xmmrm64' }
		'xmmrm128' { 'xmmrm128' }
		// Sized memory-only operands (no xmm reg side) appear in some AVX
		// rows. We classify them as xmmrm-of-the-same-size; the parsed form
		// (Indirection) will subclass-match.
		'mem128' { 'xmmrm128' }
		'mem256' { 'ymmrm256' }
		'mem512' { 'zmmrm512' }
		// AVX: ymm registers and ymm/memory operands.
		'ymmreg' { 'ymmreg' }
		'ymmrm' { 'ymmrm' }
		'ymmrm128' { 'ymmrm128' }
		'ymmrm256' { 'ymmrm256' }
		// AVX-512: zmm registers and zmm/memory operands.
		'zmmreg' { 'zmmreg' }
		'zmmrm' { 'zmmrm' }
		'zmmrm128' { 'zmmrm128' }
		'zmmrm256' { 'zmmrm256' }
		'zmmrm512' { 'zmmrm512' }
		// AVX-512 mask registers and the kreg-or-memory wildcard.
		'kreg' { 'kreg' }
		'krm' { 'krm' }
		// x87 FPU. We accept `fpureg` and `fpu0` (the implicit ST(0)).
		'fpureg' { 'fpureg' }
		'fpu0' { 'fpu0' }
		else { none }
	}
}

// -----------------------------------------------------------------------------
// Encoding parsing
// -----------------------------------------------------------------------------

fn is_hex_byte(s string) bool {
	if s.len != 2 {
		return false
	}
	for c in s {
		if !(c >= `0` && c <= `9`) && !(c >= `a` && c <= `f`) && !(c >= `A` && c <= `F`) {
			return false
		}
	}
	return true
}

fn parse_hex(s string) u8 {
	mut v := u8(0)
	for c in s {
		v *= 16
		if c >= `0` && c <= `9` {
			v += u8(c - `0`)
		} else if c >= `a` && c <= `f` {
			v += u8(c - `a`) + 10
		} else if c >= `A` && c <= `F` {
			v += u8(c - `A`) + 10
		}
	}
	return v
}

struct Enc {
mut:
	prefixes    []u8
	rex_w       bool
	opcode      []u8
	plus_reg    bool
	reg_field   string
	imm         string
	rel         string
	vex_present bool
	// vex_l / vex_w semantics: 0/1 are literal, 2 = "ignore" (lig/wig — encoded as 0).
	vex_l  u8
	vex_w  u8
	vex_pp u8 // 0=none, 1=66, 2=F3, 3=F2
	vex_mm u8 // 1=0F, 2=0F38, 3=0F3A
	// EVEX (AVX-512). Layout mirrors VEX but adds the 2-bit L'L for 512-bit
	// vectors and the 4-byte prefix is emitted differently.
	evex_present bool
	evex_l       u8 // 0=128, 1=256, 2=512
	evex_w       u8 // 0/1, 2=wig (encode 0)
	evex_pp      u8
	evex_mm      u8
}

// parse_evex_token decodes `evex.<mods>` similarly to VEX. The L'L field
// adds 512-bit (`512`) on top of `128` / `256`. APX-only modifiers like
// `nf` / `ndx` / `m4` / `nd0` / `nd1` are accepted but flagged so the caller
// can skip the row (we don't model APX yet).
fn parse_evex_token(tok string, mut enc Enc) (bool, bool) {
	if !tok.starts_with('evex.') {
		return false, false
	}
	enc.evex_present = true
	mut apx_only := false
	for mod in tok[5..].split('.') {
		match mod {
			'nds', 'nd', 'ndd' {} // vvvv source markers
			'lig' { enc.evex_l = 0 }
			'lz', 'l0', '128' { enc.evex_l = 0 }
			'l1', '256' { enc.evex_l = 1 }
			'l2', '512' { enc.evex_l = 2 }
			'wig' { enc.evex_w = 2 }
			'w0' { enc.evex_w = 0 }
			'w1' { enc.evex_w = 1 }
			'np' { enc.evex_pp = 0 }
			'66' { enc.evex_pp = 1 }
			'f3' { enc.evex_pp = 2 }
			'f2' { enc.evex_pp = 3 }
			'0f' { enc.evex_mm = 1 }
			'0f38' { enc.evex_mm = 2 }
			'0f3a' { enc.evex_mm = 3 }
			'm0' { enc.evex_mm = 0 }
			'm1' { enc.evex_mm = 1 }
			'm2' { enc.evex_mm = 2 }
			'm3' { enc.evex_mm = 3 }
			// APX-only modifiers — we don't generate APX rows.
			'nf', 'nf0', 'nf1', 'ndx', 'm4', 'zu' { apx_only = true }
			else {} // unknown — leave defaults
		}
	}
	return true, apx_only
}

// parse_vex_token decodes a single dotted token like `vex.nds.128.66.0f` into
// the VEX fields. Recognized modifiers include `lig` / `lz` / `l0` / `l1` /
// `128` / `256` for the L bit, `wig` / `w0` / `w1` for W, `np` / `66` / `f3`
// / `f2` for pp, and `0f` / `0f38` / `0f3a` for mm. Markers like `nds` /
// `ndx` (which name the vvvv operand) are ignored — our op_order tells us
// where vvvv comes from. `ko#` is K-mask's per-size pp+w combination,
// resolved against the macro-expansion size letter.
fn parse_vex_token(tok string, mut enc Enc, sz SizeCtx) bool {
	mut rest := ''
	if tok.starts_with('vex+.') {
		rest = tok[5..]
	} else if tok.starts_with('vex.') {
		rest = tok[4..]
	} else {
		return false
	}
	enc.vex_present = true
	for mod in rest.split('.') {
		match mod {
			'nds', 'nd', 'ndd', 'ndx', 'nd0', 'nd1' {} // vvvv source markers — handled by op_order
			'lig' { enc.vex_l = 2 }
			'lz', 'l0', '128' { enc.vex_l = 0 }
			'l1', '256' { enc.vex_l = 1 }
			'wig' { enc.vex_w = 2 }
			'w0' { enc.vex_w = 0 }
			'w1' { enc.vex_w = 1 }
			'w#' {
				// Per-size W bit: q-letter sets W=1, b/w/d → W=0. Reuses
				// SizeCtx.rex_w which tracks the same condition.
				enc.vex_w = if sz.rex_w { u8(1) } else { u8(0) }
			}
			'w##' {
				// KSHIFT-style W bit: b/d → 0, w/q → 1.
				enc.vex_w = sz.w_hh
			}
			'np' { enc.vex_pp = 0 }
			'66' { enc.vex_pp = 1 }
			'f3' { enc.vex_pp = 2 }
			'f2' { enc.vex_pp = 3 }
			'0f' { enc.vex_mm = 1 }
			'0f38' { enc.vex_mm = 2 }
			'0f3a' { enc.vex_mm = 3 }
			'm0' { enc.vex_mm = 0 }
			'm1' { enc.vex_mm = 1 }
			'm2' { enc.vex_mm = 2 }
			'm3' { enc.vex_mm = 3 }
			'ko#' {
				// K-mask per-size combo: implies mm=0F (already from `0f` token)
				// plus pp and W bits keyed off the macro size letter.
				enc.vex_pp = sz.ko_pp
				enc.vex_w = sz.ko_w
			}
			else {} // unknown modifier — leave defaults
		}
	}
	return true
}

fn parse_encoding(tag string, body string, sz SizeCtx, cc_value u8, cc_present bool) ?Enc {
	mut e := Enc{}
	mut prefixes := []u8{}
	mut rex_w := false
	mut opcode := []u8{}
	mut plus_reg := false
	mut reg_field := ''
	mut imm := ''
	mut rel := ''
	// `nw` ("no W"): a subsequent `o#` for q-size must NOT set REX.W.
	// Used by PUSH/POP and other long-mode-default-64 instructions.
	mut nw_active := false

	for tok in split_ws(body) {
		if tok.starts_with('vex.') || tok.starts_with('vex+.') {
			parse_vex_token(tok, mut e, sz)
			continue
		}
		if tok.starts_with('evex.') {
			_, apx_only := parse_evex_token(tok, mut e)
			if apx_only {
				return none
			}
			continue
		}
		// modifiers we silently ignore (hints, lock, hle, bound, REP/repe, default-size markers)
		if tok in ['np', 'hle', 'hlexr', 'lock', 'bnd', 'nf', 'osz', 'os', 'jcc8', 'jmp8',
			'wait', 'norep', 'norexb', 'norexx', 'norexr', 'norexw', '!osp', '!asp',
			'nof2', 'nof3', 'nohi', 'optw', 'optd', 'repe', 'adf', 'odf'] {
			continue
		}
		// `f3i` / `f2i` are F3/F2 SSE prefixes that allow operand-size
		// (0x66) coexistence. We emit them as plain prefix bytes.
		if tok == 'f3i' {
			prefixes << u8(0xf3)
			continue
		}
		if tok == 'f2i' {
			prefixes << u8(0xf2)
			continue
		}
		if tok == 'nw' {
			nw_active = true
			continue
		}

		// operand-size override
		match tok {
			'o16' {
				prefixes << u8(0x66)
				continue
			}
			'o32' {
				continue
			}
			'o64' {
				rex_w = true
				continue
			}
			'o64nw' {
				continue
			} // 64-bit operand, REX.W not required
			'rex.w' {
				rex_w = true
				continue
			}
			'a16', 'a32', 'a64' {
				continue
			} // address-size; we let the encoder emit 0x67 dynamically
			else {}
		}

		// `o#` and `od#` macros: operand-size prefix at this position.
		if tok == 'o#' || tok == 'od#' {
			if sz.emits_o66 {
				prefixes << u8(0x66)
			}
			if sz.rex_w && !nw_active {
				rex_w = true
			}
			continue
		}

		// /r, /digit, /is4 (FMA4 4-bit immediate carrying a register)
		if tok == '/r' {
			reg_field = 'slash_r'
			continue
		}
		if tok == '/is4' {
			// The /is4 register source is wired up by the rvms/rvsm op_order;
			// nothing additional to record on the encoding row.
			continue
		}
		if tok.len == 2 && tok[0] == `/` && tok[1] >= `0` && tok[1] <= `7` {
			reg_field = 'slash_d' + int(tok[1] - u8(`0`)).str()
			continue
		}

		// immediate placeholders
		if tok == 'ib' || tok == 'ib,s' || tok == 'ib,u' {
			imm = 'ib'
			continue
		}
		if tok == 'iw' {
			imm = 'iw'
			continue
		}
		if tok == 'id' || tok == 'id,s' || tok == 'id,u' {
			imm = 'id'
			continue
		}
		if tok == 'iq' {
			imm = 'iq'
			continue
		}
		if tok == 'i#' {
			imm = sz.imm_token
			continue
		}
		if tok == 'i##' {
			imm = sz.imm_ld_tok
			continue
		}
		if tok == 'iwd' {
			imm = if sz.letter == 'w' { 'iw' } else { 'id' }
			continue
		}
		if tok == 'iwdq' {
			imm = sz.imm_ld_tok
			continue
		}

		// relative
		if tok == 'rel' || tok == 'rel32' {
			rel = 'rel32'
			continue
		}
		// rel8 forms are skipped: the encoder always reserves a 4-byte slot
		// for forward-reference labels, so a rel8 row would emit the wrong
		// number of placeholder bytes for an unresolved branch target.
		if tok == 'rel8' {
			return none
		}
		if tok == 'rel16' {
			return none
		}

		// `XX+r` (literal +r), `XX+r#` (byte → XX+r, non-byte → (XX+8)+r), `XX+c` (cc opcode bump)
		if tok.contains('+') {
			plus := tok.index('+') or { -1 }
			head := tok[..plus]
			tail := tok[plus + 1..]
			if !is_hex_byte(head) {
				return none
			}
			head_byte := parse_hex(head)
			match tail {
				'r', 'rb', 'rw', 'rd', 'rq' {
					opcode << head_byte
					plus_reg = true
					continue
				}
				'r#' {
					non_byte_bump := if sz.letter == 'b' { u8(0) } else { u8(8) }
					opcode << head_byte + non_byte_bump
					plus_reg = true
					continue
				}
				'c' {
					if !cc_present {
						return none
					}
					opcode << head_byte + cc_value
					continue
				}
				else { return none }
			}
		}

		// literal hex byte, possibly with trailing `#` or `##` for size-keyed
		// opcode bumps. `XX#` adds 1 for any non-byte; `XX##` adds 1 only
		// for d/q (B/W share an opcode, D/Q share the next).
		mut t := tok
		mut bump := u8(0)
		if t.ends_with('##') {
			t = t[..t.len - 2]
			bump = sz.ko_w
		} else if t.ends_with('#') {
			t = t[..t.len - 1]
			bump = sz.opbump
		}
		if is_hex_byte(t) {
			b := parse_hex(t) + bump
			// Legacy SSE/operand/address-size prefixes (F2 F3 66 67 F0) that
			// appear before any real opcode byte are emitted as prefixes
			// (before REX), not as part of the opcode. After we see the first
			// non-prefix byte (e.g. 0F escape), every subsequent byte belongs
			// to the opcode.
			if opcode.len == 0 && bump == 0
				&& b in [u8(0xf0), u8(0xf2), u8(0xf3), u8(0x66), u8(0x67)] {
				prefixes << b
			} else {
				opcode << b
			}
			continue
		}
		// NASM shorthand: `0f3a` / `0f38` and similar 4-hex tokens are two
		// adjacent opcode bytes. Split them.
		if t.len == 4 && bump == 0 {
			lo := t[..2]
			hi := t[2..]
			if is_hex_byte(lo) && is_hex_byte(hi) {
				opcode << parse_hex(lo)
				opcode << parse_hex(hi)
				continue
			}
		}

		// anything else: bail out — caller will skip this row
		return none
	}

	_ = tag
	e.prefixes = prefixes
	e.rex_w = rex_w
	e.opcode = opcode
	e.plus_reg = plus_reg
	e.reg_field = reg_field
	e.imm = imm
	e.rel = rel
	return e
}

// -----------------------------------------------------------------------------
// Pipeline
// -----------------------------------------------------------------------------

fn (mut s Stats) try_emit(raw RawLine, mut out []GenRow) {
	if flags_kill_long_mode(raw.flags) {
		s.skipped_long++
		return
	}
	if flags_apx(raw.flags) {
		s.skipped_apx++
		return
	}
	if enc_has_advanced_prefix(raw.enc_body) {
		s.skipped_vex++
		return
	}
	if !op_tag_supported(raw.enc_tag) {
		s.skipped_op_tag++
		return
	}

	// Determine which size letters this row applies to.
	mut letters := ['']
	for m in raw.macros {
		l := macro_letters(m)
		if l.len > 0 {
			letters = l.clone()
			break
		}
	}

	// `Mnem%` is NASM's marker for "append the size letter to the mnemonic"
	// (e.g. KMOV% with $bwdq → KMOVB / KMOVW / KMOVD / KMOVQ; RET% with $zwdq
	// → RET for the z-form, RETW / RETD / RETQ for the others).
	// `%%` (rare 2-letter form like KUNPCK%%) requires a separate destination-
	// letter convention we don't model yet; skip those rows.
	mut mnem := raw.mnemonic
	if mnem.ends_with('%%') {
		s.skipped_encoding++
		return
	}

	// Determine cc expansion: if mnemonic is Jcc/SETcc/CMOVcc, expand.
	mut cc_iter := []CcEntry{}
	mut prefix := ''
	if mnem == 'Jcc' {
		cc_iter = cc_table.clone()
		prefix = 'J'
	} else if mnem == 'SETcc' {
		cc_iter = cc_table.clone()
		prefix = 'SET'
	} else if mnem == 'CMOVcc' {
		cc_iter = cc_table.clone()
		prefix = 'CMOV'
	} else {
		cc_iter = [CcEntry{'', 0}]
	}

	for letter in letters {
		sz := if letter == '' { SizeCtx{'', 0, false, false, 0, '', '', 0, 0, 0} } else { size_ctx_for(letter) }

		// `%` in the mnemonic gets replaced with the size letter (uppercase)
		// for non-default expansions. The z-form drops the `%` instead.
		expanded_mnem := if mnem.ends_with('%') {
			head := mnem[..mnem.len - 1]
			if letter == '' || letter == 'z' { head } else { head + letter.to_upper() }
		} else {
			mnem
		}

		for cc in cc_iter {
			canon := if prefix == '' { expanded_mnem.to_upper() } else { prefix + cc.suffix }
			// Accept (a) explicit supported_canons entries, (b) any V-prefixed
			// mnemonic (AVX/VEX), (c) any K-prefixed mnemonic (AVX-512 mask),
			// or (d) any F-prefixed mnemonic (x87 FPU).
			if canon !in supported_canons && !(canon.len > 1 && canon[0] == `V`)
				&& !(canon.len > 1 && canon[0] == `K`)
				&& !(canon.len > 1 && canon[0] == `F`) {
				s.unsupported++
				continue
			}
			ops := parse_operand_spec(raw.operand_str, sz, resolve_op_size_flag(raw.flags)) or {
				s.skipped_operands++
				continue
			}
			enc := parse_encoding(raw.enc_tag, raw.enc_body, sz, cc.value, prefix != '') or {
				s.skipped_encoding++
				continue
			}
			op_order := match raw.enc_tag {
				'', '-' { 'zo' }
				'r-' { 'r_skip' }
				'-r' { 'skip_r' }
				else { raw.enc_tag }
			}
			out << GenRow{
				mnemonic:     canon
				operands:     ops
				op_order:     op_order
				prefixes:     enc.prefixes
				rex_w:        enc.rex_w
				opcode:       enc.opcode
				plus_reg:     enc.plus_reg
				reg_field:    if enc.reg_field == '' { '@none' } else { enc.reg_field }
				imm:          if enc.imm == '' { '@none' } else { enc.imm }
				rel:          if enc.rel == '' { '@none' } else { enc.rel }
				vex_present:  enc.vex_present
				vex_l:        enc.vex_l
				vex_w:        enc.vex_w
				vex_pp:       enc.vex_pp
				vex_mm:       enc.vex_mm
				evex_present: enc.evex_present
				evex_l:       enc.evex_l
				evex_w:       enc.evex_w
				evex_pp:      enc.evex_pp
				evex_mm:      enc.evex_mm
			}
			s.emitted++
		}
	}
}

// -----------------------------------------------------------------------------
// Synthesis of meta-macro families
//
// NASM expands $arith and $shift via Perl templates in preinsns.pl. Re-
// implementing that engine in V is its own project, so we hardcode the
// resulting row sets — same shape, derivable from a few well-known templates.
// -----------------------------------------------------------------------------

struct MnemAt {
	name string
	n    u8 // 0..7 — opcode_base = n << 3, slash digit = n
}

// $arith    nf=nf ADD OR nf=,ADC nf=,SBB AND SUB XOR nf=,lock=,!evex,CMP
const arith_mnemonics = [
	MnemAt{'ADD', 0},
	MnemAt{'OR', 1},
	MnemAt{'ADC', 2},
	MnemAt{'SBB', 3},
	MnemAt{'AND', 4},
	MnemAt{'SUB', 5},
	MnemAt{'XOR', 6},
	MnemAt{'CMP', 7},
]

// $shift    ROL ROR RCL RCR SHL,SAL SHR - SAR
const shift_mnemonics = [
	MnemAt{'ROL', 0},
	MnemAt{'ROR', 1},
	MnemAt{'RCL', 2},
	MnemAt{'RCR', 3},
	MnemAt{'SHL', 4},
	MnemAt{'SAL', 4},
	MnemAt{'SHR', 5},
	MnemAt{'SAR', 7},
]

fn slash_d(n u8) string {
	return 'slash_d' + int(n).str()
}

fn synth_arith_rows() []GenRow {
	mut rows := []GenRow{}
	for am in arith_mnemonics {
		m := am.name
		b := am.n << 3
		sl := slash_d(am.n)
		// mr family: rm,reg
		rows << gen_row(m, ['rm8', 'reg8'], 'mr', []u8{}, false, [b + 0], false, 'slash_r',
			'@none')
		rows << gen_row(m, ['rm16', 'reg16'], 'mr', [u8(0x66)], false, [b + 1], false,
			'slash_r', '@none')
		rows << gen_row(m, ['rm32', 'reg32'], 'mr', []u8{}, false, [b + 1], false, 'slash_r',
			'@none')
		rows << gen_row(m, ['rm64', 'reg64'], 'mr', []u8{}, true, [b + 1], false, 'slash_r',
			'@none')
		// rm family: reg,rm
		rows << gen_row(m, ['reg8', 'rm8'], 'rm', []u8{}, false, [b + 2], false, 'slash_r',
			'@none')
		rows << gen_row(m, ['reg16', 'rm16'], 'rm', [u8(0x66)], false, [b + 3], false,
			'slash_r', '@none')
		rows << gen_row(m, ['reg32', 'rm32'], 'rm', []u8{}, false, [b + 3], false, 'slash_r',
			'@none')
		rows << gen_row(m, ['reg64', 'rm64'], 'rm', []u8{}, true, [b + 3], false, 'slash_r',
			'@none')
		// mi family: rm,imm — imm8 sign-extend short form when applicable.
		rows << gen_row_imm(m, ['rm8', 'imm8'], 'mi', []u8{}, false, [u8(0x80)], sl, 'ib')
		rows << gen_row_imm(m, ['rm16', 'imm8'], 'mi', [u8(0x66)], false, [u8(0x83)], sl,
			'ib')
		rows << gen_row_imm(m, ['rm16', 'imm16'], 'mi', [u8(0x66)], false, [u8(0x81)], sl,
			'iw')
		rows << gen_row_imm(m, ['rm32', 'imm8'], 'mi', []u8{}, false, [u8(0x83)], sl, 'ib')
		rows << gen_row_imm(m, ['rm32', 'imm32'], 'mi', []u8{}, false, [u8(0x81)], sl, 'id')
		rows << gen_row_imm(m, ['rm64', 'imm8'], 'mi', []u8{}, true, [u8(0x83)], sl, 'ib')
		rows << gen_row_imm(m, ['rm64', 'imm32'], 'mi', []u8{}, true, [u8(0x81)], sl, 'id')
	}
	return rows
}

// $shift expands to three encoding forms per (mnemonic, size):
//   rm,1     [m1: D0|D1 /n]              imm not encoded
//   rm,imm8  [mi: C0|C1 /n ib]
//   rm,%cl   [mc: D2|D3 /n]              CL implicit
// We represent the "1" form via OpClass.imm_one and CL form via OpClass.reg_cl.
fn synth_shift_rows() []GenRow {
	mut rows := []GenRow{}
	for sm in shift_mnemonics {
		m := sm.name
		sl := slash_d(sm.n)
		// rm,1 — opcodes D0/D1
		rows << gen_row(m, ['rm8', 'imm_one'], 'm1', []u8{}, false, [u8(0xd0)], false, sl,
			'@none')
		rows << gen_row(m, ['rm16', 'imm_one'], 'm1', [u8(0x66)], false, [u8(0xd1)], false,
			sl, '@none')
		rows << gen_row(m, ['rm32', 'imm_one'], 'm1', []u8{}, false, [u8(0xd1)], false, sl,
			'@none')
		rows << gen_row(m, ['rm64', 'imm_one'], 'm1', []u8{}, true, [u8(0xd1)], false, sl,
			'@none')
		// rm,imm8 — opcodes C0/C1
		rows << gen_row_imm(m, ['rm8', 'imm8'], 'mi', []u8{}, false, [u8(0xc0)], sl, 'ib')
		rows << gen_row_imm(m, ['rm16', 'imm8'], 'mi', [u8(0x66)], false, [u8(0xc1)], sl,
			'ib')
		rows << gen_row_imm(m, ['rm32', 'imm8'], 'mi', []u8{}, false, [u8(0xc1)], sl, 'ib')
		rows << gen_row_imm(m, ['rm64', 'imm8'], 'mi', []u8{}, true, [u8(0xc1)], sl, 'ib')
		// rm,%cl — opcodes D2/D3
		rows << gen_row(m, ['rm8', 'reg_cl'], 'mc', []u8{}, false, [u8(0xd2)], false, sl,
			'@none')
		rows << gen_row(m, ['rm16', 'reg_cl'], 'mc', [u8(0x66)], false, [u8(0xd3)], false,
			sl, '@none')
		rows << gen_row(m, ['rm32', 'reg_cl'], 'mc', []u8{}, false, [u8(0xd3)], false, sl,
			'@none')
		rows << gen_row(m, ['rm64', 'reg_cl'], 'mc', []u8{}, true, [u8(0xd3)], false, sl,
			'@none')
	}
	return rows
}

fn gen_row(m string, ops []string, ord string, prefixes []u8, rex_w bool, opcode []u8, plus_reg bool, reg_field string, imm string) GenRow {
	return GenRow{
		mnemonic:  m
		operands:  ops
		op_order:  ord
		prefixes:  prefixes
		rex_w:     rex_w
		opcode:    opcode
		plus_reg:  plus_reg
		reg_field: reg_field
		imm:       imm
		rel:       '@none'
	}
}

fn gen_row_imm(m string, ops []string, ord string, prefixes []u8, rex_w bool, opcode []u8, reg_field string, imm string) GenRow {
	return gen_row(m, ops, ord, prefixes, rex_w, opcode, false, reg_field, imm)
}

// -----------------------------------------------------------------------------
// Code emission
// -----------------------------------------------------------------------------

fn fmt_u8_array(bs []u8) string {
	if bs.len == 0 {
		return '[]u8{}'
	}
	mut s := '[u8(0x' + bs[0].hex() + ')'
	for i := 1; i < bs.len; i++ {
		s += ', 0x' + bs[i].hex()
	}
	s += ']'
	return s
}

fn fmt_str_list(ss []string, prefix string) string {
	if ss.len == 0 {
		return '[]OpClass{}'
	}
	mut s := '[' + prefix + ss[0]
	for i := 1; i < ss.len; i++ {
		s += ', ' + prefix + ss[i]
	}
	s += ']'
	return s
}

fn emit_v_file(rows []GenRow) string {
	mut s := '// AUTO-GENERATED by tools/gen_insns.v from third_party/insns.dat\n'
	s += '// Do not edit by hand. Regenerate with `v run tools/gen_insns.v`.\n'
	s += '// Source: NASM insns.dat (BSD-2-Clause). See LICENSE-NASM.\n\n'
	s += 'module encoder\n\n'
	s += 'pub const generated_insns_table = [\n'
	for r in rows {
		s += '\tInstrEnc{mnemonic: \'${r.mnemonic}\''
		s += ', operands: ${fmt_str_list(r.operands, '.')}'
		s += ', op_order: .${r.op_order}'
		if r.prefixes.len > 0 {
			s += ', prefixes: ${fmt_u8_array(r.prefixes)}'
		}
		if r.rex_w {
			s += ', rex_w: true'
		}
		s += ', opcode: ${fmt_u8_array(r.opcode)}'
		if r.plus_reg {
			s += ', plus_reg: true'
		}
		if r.reg_field != '@none' {
			s += ', reg_field: .${r.reg_field}'
		}
		if r.imm != '@none' {
			s += ', imm: .${r.imm}'
		}
		if r.rel != '@none' {
			s += ', rel: .${r.rel}'
		}
		if r.vex_present {
			s += ', vex_present: true'
			s += ', vex_l: ${r.vex_l}'
			s += ', vex_w: ${r.vex_w}'
			s += ', vex_pp: ${r.vex_pp}'
			s += ', vex_mm: ${r.vex_mm}'
		}
		if r.evex_present {
			s += ', evex_present: true'
			s += ', evex_l: ${r.evex_l}'
			s += ', evex_w: ${r.evex_w}'
			s += ', evex_pp: ${r.evex_pp}'
			s += ', evex_mm: ${r.evex_mm}'
		}
		s += '}\n'
	}
	s += ']\n'
	return s
}

// -----------------------------------------------------------------------------
// main
// -----------------------------------------------------------------------------

fn main() {
	src := os.read_lines('third_party/insns.dat') or {
		eprintln('cannot read third_party/insns.dat: ${err}')
		exit(1)
	}

	mut stats := Stats{}
	mut rows := []GenRow{}

	for line in src {
		stats.total++
		t := line.trim_space()
		if t == '' || t.starts_with(';') {
			stats.blank_or_comment++
			continue
		}
		// Skip meta-macro definitions: lines that begin with `$arith` /
		// `$shift` / `$eshift` / `$xshift` / `$hint` AND have no encoding
		// block. (Per-row modifiers like `$k $bwdq KMOV% ...` start with a
		// macro name but DO carry an encoding bracket, and we want those.)
		if (t.starts_with('\$arith') || t.starts_with('\$shift') || t.starts_with('\$eshift')
			|| t.starts_with('\$xshift') || t.starts_with('\$hint')) && !t.contains('[') {
			stats.meta_macro++
			continue
		}
		raw := tokenize_line(line) or {
			stats.skipped_encoding++
			continue
		}
		stats.try_emit(raw, mut rows)
	}

	// Synthesize meta-macro families that NASM expands via preinsns.pl
	// templates (which we do not re-implement here).
	rows << synth_arith_rows()
	rows << synth_shift_rows()

	// MOVABSQ: AT&T's forced 64-bit immediate form of MOV reg64, imm64. NASM's
	// equivalent row uses `imm:imm` syntax we don't parse, so synthesize it.
	rows << gen_row('MOVABSQ', ['reg64', 'imm64'], 'ri', []u8{}, true, [u8(0xb8)],
		true, '@none', 'iq')

	out := emit_v_file(rows)
	os.write_file('encoder/insns_table.gen.v', out) or {
		eprintln('cannot write generated file: ${err}')
		exit(1)
	}

	println('gen_insns: total=${stats.total}  emitted=${stats.emitted}')
	println('  blank/comment=${stats.blank_or_comment}  meta=${stats.meta_macro}')
	println('  no-long=${stats.skipped_long}  apx=${stats.skipped_apx}  vex/evex=${stats.skipped_vex}')
	println('  unsupported-mnem=${stats.unsupported}  bad-op-tag=${stats.skipped_op_tag}')
	println('  bad-operands=${stats.skipped_operands}  bad-encoding=${stats.skipped_encoding}')
}
