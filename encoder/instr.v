module encoder

import error
import encoding.binary
import strconv
import token

pub enum InstrKind {
	section
	global
	local
	string
	add
	sub
	lea
	mov
	xor
	cmp
	pop
	push
	call
	jmp
	jne
	je
	ret
	syscall
	nop
	hlt
	leave
	label
}

pub struct Instr {
pub mut:
	kind           InstrKind
	code           []u8
	symbol_name    string
	flags          string
	addr           i64
	binding        u8
	symbol_type    u8
	section        string [required]
	index          int
	varcode        &VariableCode = unsafe{nil}
	is_len_decided bool = true
	pos token.Position
}

pub struct CallTarget {
pub mut:
	target_symbol string
	caller      &Instr
}

pub struct RelaTextUser {
pub mut:
	uses   string
	instr  &Instr
	offset i64
	rtype  u64
	adjust int
}

pub struct VariableCode {
pub mut:
	trgt_symbol  string
	rel8_code    []u8
	rel8_offset  i64
	rel32_code   []u8
	rel32_offset i64
}

pub type Expr = Ident | Immediate | Register | Indirection | Number | Binop

pub struct Number {
pub:
	lit string
	pos token.Position
}

pub struct Binop {
pub:
	left_hs Expr
	right_hs Expr
	op token.TokenKind
	pos token.Position
}

pub struct Register {
pub:
	lit string
	pos token.Position
}

pub struct Immediate {
pub:
	expr Expr
	pos token.Position
}

pub struct Indirection {
pub:
	expr Expr
	regi Register
	pos token.Position
}

pub struct Ident {
pub:
	lit string
	pos token.Position
}

pub const (
	mod_indirection_with_no_displacement = u8(0b00)
	mod_indirection_with_displacement8   = u8(0b01)
	mod_indirection_with_displacement32  = u8(0b10)
	mod_regi = u8(0b11)
	rex_w    = u8(0x48)

	r_x86_64_none	   = 0
	r_x86_64_64		   = 1
	r_x86_64_pc32	   = 2
	r_x86_64_got32	   = 3
	r_x86_64_plt32	   = 4
	r_x86_64_copy	   = 5
	r_x86_64_glob_dat  = 6
	r_x86_64_jump_slot = 7
	r_x86_64_relative  = 8
	r_x86_64_gotpcrel  = 9
	r_x86_64_32		   = 10
	r_x86_64_32s	   = 11
	r_x86_64_16		   = 12
	r_x86_64_pc16	   = 13
	r_x86_64_8		   = 14
	r_x86_64_pc8	   = 15
	r_x86_64_pc64	   = 24

	stt_notype 			 = 0
	stt_object 			 = 1
	stt_func 			 = 2
	stt_section 		 = 3
	stt_file 			 = 4
	stt_common 			 = 5
	stt_tls 			 = 6
	stt_relc 			 = 8
	stt_srelc 			 = 9
	stt_loos 			 = 10
	stt_hios 			 = 12
	stt_loproc 			 = 13
	stt_hiproc 			 = 14
)

fn regi_size(regi Register) int {
	return if regi.lit[0] == `R` {
		64
	} else if  regi.lit[0] == `E` {
		32
	} else {
		panic('[internal error] somthing whent wrong...')
	}
}

fn check_regi_size(reg Register, size int) {
	reg_size := if reg.lit[0] == `R` {
		64
	} else {
		32
	}
	if reg_size != size {
		error.print(reg.pos, 'invalid operand for instruction')
		exit(0)
	}
}

fn reg_bits(reg Register) u8 {
	match reg.lit {
		'EAX', 'RAX' {
			return 0
		}
		'ECX', 'RCX' {
			return 1
		}
		'EDX', 'RDX' {
			return 2
		}
		'EBX', 'RBX' {
			return 3
		}
		'ESP', 'RSP' {
			return 4
		}
		'EBP', 'RBP' {
			return 5
		}
		'ESI', 'RSI' {
			return 6
		}
		'EDI', 'RDI' {
			return 7
		}
		else {
			error.print(reg.pos, 'invalid operand for instruction')
			exit(1)
		}
	}
}

pub fn align_to(n int, align int) int {
	return (n + align - 1) / align * align
}

fn is_in_i8_range(n int) bool {
	return -128 <= n && n <= 127
}

fn is_in_i32_range(n int) bool {
	return n < (1 << 31)
}

fn compose_mod_rm(mod u8, reg_op u8, rm u8) u8 {
	return (mod << 6) + (reg_op << 3) + rm
}

fn compose_sib(scale u8, index u8, base u8) u8 {
	return (scale<<6) + (index<<3) + base
}

fn eval_expr(expr Expr) int {
	return match expr {
		Number {
			strconv.atoi(expr.lit) or {
                error.print(expr.pos, 'atoi() failed')
                exit(1)
            }
		}
		Binop{
			match expr.op {
				.plus {
					eval_expr(expr.left_hs) + eval_expr(expr.right_hs)
				}
				.minus {
					eval_expr(expr.left_hs) - eval_expr(expr.right_hs)
				} else {
					panic('[internal error] somthing whent wrong...')
				}
			}
		}
		else {
			0
		}
	}
}

fn (mut e Encoder) get_disp_symbol(expr Expr, mut arr []string) {
	match expr {
		Binop {
			e.get_disp_symbol(expr.left_hs, mut arr)
			e.get_disp_symbol(expr.right_hs, mut arr)
		}
		Ident {
			arr << expr.lit
		}
		else {
		}
	}
}

fn (mut e Encoder) encode_indir_regi(op_code u8, indir Indirection, regi Register, mut instr &Instr, size int) {
	// disp(base)

	check_regi_size(regi, size)

	disp := eval_expr(indir.expr)
	base_is_rip := indir.regi.lit == 'RIP'
	base_is_sp := indir.regi.lit in ['RSP', 'ESP']
	base_is_bp := indir.regi.lit in ['RBP', 'EBP']

	mut used_symbols := []string{}
	e.get_disp_symbol(indir.expr, mut &used_symbols)
	if used_symbols.len >= 2 {
		error.print(indir.expr.pos, 'invalid operand for instruction')
		exit(1)
	}

	need_rela := used_symbols.len == 1

	mod_rm := if base_is_rip {
		compose_mod_rm(mod_indirection_with_no_displacement, reg_bits(regi), 0b101) // rip relative
	} else if need_rela {
		compose_sib(mod_indirection_with_displacement32, reg_bits(regi), reg_bits(indir.regi))
	} else if disp == 0 && !base_is_bp {
		compose_mod_rm(mod_indirection_with_no_displacement, reg_bits(regi), reg_bits(indir.regi))
	} else if is_in_i8_range(disp) {
		compose_sib(mod_indirection_with_displacement8, reg_bits(regi), reg_bits(indir.regi))
	} else if is_in_i32_range(disp) {
		compose_sib(mod_indirection_with_displacement32, reg_bits(regi), reg_bits(indir.regi))
	} else {
		panic('disp out range!')
	}

	if regi_size(indir.regi) == 32 {
		instr.code << 0x67
	}

	if size == 64 {
		instr.code << encoder.rex_w
	}

	instr.code << op_code
	instr.code << mod_rm

	if base_is_sp {
		instr.code << 0x24
	}

	instr_code_len := instr.code.len

	if need_rela {
		rtype := if base_is_rip {
			encoder.r_x86_64_pc32
		} else {
			encoder.r_x86_64_32s
		}
		rela_text_user := encoder.RelaTextUser{
			instr:  unsafe {instr},
			uses:   used_symbols[0],
			offset: instr_code_len
			rtype:  u64(rtype)
			adjust: eval_expr(indir.expr)
		}
		instr.code << [u8(0), 0, 0, 0]
		e.rela_text_users << rela_text_user
	} else {
		if disp != 0 || base_is_rip || base_is_bp {
			if base_is_rip {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(disp))
				instr.code << hex
			} else if is_in_i8_range(disp) {
				instr.code << u8(disp)
			} else if is_in_i32_range(disp) {
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(disp))
				instr.code << hex
			} else {
				panic('disp out range!')
			}
		}
	}
}

fn (mut e Encoder) encode_imm_regi(slash u8, rax_magic u8, imm Immediate, regi Register, mut instr &Instr, size int) {
	num := eval_expr(imm.expr)
	check_regi_size(regi, size)

	mod_rm := compose_mod_rm(mod_regi, slash, reg_bits(regi))

	if size == 64 {
		instr.code << encoder.rex_w
	}

	if is_in_i8_range(num) {
		instr.code << [u8(0x83), mod_rm, u8(num)]
	} else if is_in_i32_range(num) {
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(num))
		if regi.lit in ['RAX', 'EAX'] {
			instr.code << [rax_magic, hex[0], hex[1], hex[2], hex[3]]
		} else {
			instr.code << [u8(0x81), mod_rm, hex[0], hex[1], hex[2], hex[3]]
		}
	}
}

fn (mut e Encoder) encode_regi_regi(op_code u8, regi Register, regi2 Register, mut instr &Instr, size int) {
	check_regi_size(regi, size)
	check_regi_size(regi2, size)
	mod_rm := compose_mod_rm(mod_regi, reg_bits(regi), reg_bits(regi2))
	if size == 64 {
   		instr.code << encoder.rex_w
	}
	instr.code << op_code
	instr.code << mod_rm
}

fn (mut e Encoder) instr_string(value string, pos token.Position) {
	mut instr := Instr{kind: .string, pos: pos, section: e.current_section}
	arr := value.bytes()
	instr.code = arr
	instr.code << 0x00

	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_mov(size int, pos token.Position) {
	mut instr := Instr{kind: .mov, pos: pos, section: e.current_section}

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register && desti is Register {
		e.encode_regi_regi(u8(0x89), source, desti, mut &instr, size)
	} else if source is Indirection && desti is Register {
		e.encode_indir_regi(u8(0x8b), source, desti, mut &instr, size)
	} else if source is Register && desti is Indirection {
		e.encode_indir_regi(u8(0x89), desti, source, mut &instr, size)
	} else if source is Immediate && desti is Register {
		check_regi_size(desti, size)
		mut mod_rm := u8(0)
		if size == 64 {
			instr.code << [encoder.rex_w, 0xc7]
			mod_rm = 0xc0 + reg_bits(desti)
		} else if size == 32 {
			mod_rm = 0xB8 + reg_bits(desti)
		}
		num := eval_expr(source.expr)
		mut hex := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &hex, u32(num))
		instr.code << [mod_rm, hex[0], hex[1], hex[2], hex[3]]
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}

	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_pop(pos token.Position) {
	mut instr := Instr{kind: .pop, pos: pos, section: e.current_section}

	source := e.parse_operand()

	if source is Register {
		check_regi_size(source, 64)
		instr.code = [0x58 + reg_bits(source)]
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}

	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_push(pos token.Position) {
	mut instr := Instr{kind: .push, pos: pos, section: e.current_section}

	source := e.parse_operand()

	if source is Register {
		check_regi_size(source, 64)
		instr.code = [0x50 + reg_bits(source)]
	} else if source is Immediate {
		num := eval_expr(source.expr)
		if is_in_i8_range(num) {
			instr.code = [u8(0x6a), u8(num)]
		} else if is_in_i32_range(num) {
			mut hex := [u8(0), 0, 0, 0]
			binary.little_endian_put_u32(mut &hex, u32(num))
			instr.code = [u8(0x68), hex[0], hex[1], hex[2], hex[3]]
		} else {
			panic('internal error')
		}
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_addq(size int, pos token.Position) {
	mut instr := Instr{kind: .add, pos: pos, section: e.current_section}

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register && desti is Register {
		e.encode_regi_regi(u8(0x01), source, desti, mut &instr, size)
	} else if source is Immediate && desti is Register {
		slash := u8(0)
		rax_magic := u8(0x05)
		e.encode_imm_regi(slash, rax_magic, source, desti, mut instr, size)
	} else if source is Indirection && desti is Register {
		e.encode_indir_regi(u8(0x3), source, desti, mut &instr, size)
	} else if source is Register && desti is Indirection {
		e.encode_indir_regi(u8(0x1), desti, source, mut &instr, size)
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}
	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_subq(size int, pos token.Position) {
	mut instr := Instr{kind: .sub, pos: pos, section: e.current_section}

	source := e.parse_operand()
	e.expect(.comma)
	desti := e.parse_operand()

	if source is Register && desti is Register {
		e.encode_regi_regi(u8(0x29), source, desti, mut &instr, size)
	} else if source is Immediate && desti is Register {
		slash := u8(5)
		rax_magic := u8(0x2D)
		e.encode_imm_regi(slash, rax_magic, source, desti, mut instr, size)
	} else if source is Indirection && desti is Register {
		e.encode_indir_regi(u8(0x2b), source, desti, mut &instr, size)
	} else if source is Register && desti is Indirection {
		e.encode_indir_regi(u8(0x29), desti, source, mut &instr, size)
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}

	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_leaq(size int, pos token.Position) {
	mut instr := encoder.Instr{kind: .lea, pos: pos, section: e.current_section}

	source := e.parse_operand()
	e.expect(.comma)
	destination := e.parse_operand()

	if source is Indirection && destination is Register {
		e.encode_indir_regi(u8(0x8d), source, destination, mut &instr, size)
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}

	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_cmp(size int, pos token.Position) {
	mut instr := Instr{kind: .cmp, pos: pos, section: e.current_section}

	source := e.parse_operand()
	e.expect(.comma)
	destination := e.parse_operand()

	if source is Register && destination is Register {
		e.encode_regi_regi(u8(0x39), source, destination, mut &instr, size)
	} else if source is Immediate && destination is Register {
		slash := u8(7)
		rax_magic := u8(0x3D)
		e.encode_imm_regi(slash, rax_magic, source, destination, mut instr, size)
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}

	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_xorq(size int, pos token.Position) {
	mut instr := Instr{kind: .xor, pos: pos, section: e.current_section}

	source := e.parse_operand()
	e.expect(.comma)
	destination := e.parse_operand()

	if source is Register && destination is Register {
		e.encode_regi_regi(u8(0x31), source, destination, mut &instr, size)
	} else if source is Immediate && destination is Register {
		slash := u8(6)
		rax_magic := u8(0x35)
		e.encode_imm_regi(slash, rax_magic, source, destination, mut instr, size)
	} else {
		error.print(pos, 'invalid operand for instruction')
		exit(1)
	}

	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_call(pos token.Position) {
	instr := Instr{kind: .call, code: [u8(0xe8), 0, 0, 0, 0], pos: pos, section: e.current_section}

	source := e.parse_operand()
	
	target_sym_name := match source {
		Ident, Number {
			source.lit
		} else {
			error.print(pos, 'invalid operand for instruction')
			exit(1)
		}
	}

	call_target := CallTarget{
		target_symbol: target_sym_name
		caller: &instr
	}

	rela_text_user := encoder.RelaTextUser{
		instr:  &instr,
		offset: 1,
		uses:   target_sym_name,
		rtype:   encoder.r_x86_64_plt32
	}

	e.rela_text_users << rela_text_user
	e.instrs[e.current_section] << &instr
	e.call_targets << call_target
}

fn (mut e Encoder) instr_jmp(pos token.Position) {
	mut instr := Instr{is_len_decided: false, kind: .jmp, pos: pos, section: e.current_section}

	destination := e.parse_operand()

	target_sym_name := match destination {
		Ident, Number {
			destination.lit
		} else {
			error.print(pos, 'invalid operand for instruction')
			exit(1)
		}
	}

	varcode := &VariableCode{
		trgt_symbol: target_sym_name,
		rel8_code:   [u8(0xeb), 0],
		rel8_offset: 1,
		rel32_code:   [u8(0xe9), 0, 0, 0, 0],
		rel32_offset: 1,
	}

	instr.varcode = varcode

	e.variable_instrs << &instr
	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_jne(pos token.Position) {
	mut instr := Instr{is_len_decided: false, kind: .jne, pos: pos, section: e.current_section}

	destination := e.parse_operand()

	target_sym_name := match destination {
		Ident, Number {
			destination.lit
		} else {
			error.print(pos, 'invalid operand for instruction')
			exit(1)
		}
	}

	varcode := &VariableCode{
		trgt_symbol: target_sym_name,
		rel8_code:   [u8(0x75), 0],
		rel8_offset: 1,
		rel32_code:   [u8(0x0f), 0x85, 0, 0, 0, 0],
		rel32_offset: 2,
	}

	instr.varcode = varcode

	e.variable_instrs << &instr
	e.instrs[e.current_section] << &instr
}

fn (mut e Encoder) instr_je(pos token.Position) {
	mut instr := Instr{is_len_decided: false, kind: .je, pos: pos, section: e.current_section}

	destination := e.parse_operand()

	target_sym_name := match destination {
		Ident, Number {
			destination.lit
		} else {
			error.print(pos, 'invalid operand for instruction')
			exit(1)
		}
	}

	varcode := &VariableCode{
		trgt_symbol: target_sym_name,
		rel8_code:   [u8(0x74), 0],
		rel8_offset: 1,
		rel32_code:   [u8(0x0f), 0x84, 0, 0, 0, 0],
		rel32_offset: 2,
	}

	instr.varcode = varcode

	e.variable_instrs << &instr
	e.instrs[e.current_section] << &instr
}

//-----------------------------------------------------------
//------- Functions for variable length instructions --------
//-----------------------------------------------------------
// jmp jne je ... 

pub fn (mut e Encoder) add_index_to_instrs() {
	for name, _ in e.instrs {
		for i := 0; i < e.instrs[name].len; i++ {
			mut instr := e.instrs[name][i]
			instr.index = i
			//e.instrs[name][i].index = i
		}
	}
}

fn calc_distance(user_instr &Instr, symdef &Instr, instrs []&Instr) (int, int, int, bool) {
	unsafe {
    	mut from, mut to := symdef, instrs[user_instr.index+1]
    	forward := user_instr.index <= symdef.index

    	if forward {
    	    from, to = instrs[user_instr.index+1], symdef
    	}

    	mut has_variable_length := false
    	mut diff, mut min, mut max := 0, 0, 0

    	for instr := from; instr != to; instr = instrs[instr.index+1] {
    	    if !instr.is_len_decided {
    	        has_variable_length = true
    	        len_short, len_large := instr.varcode.rel8_code.len, instr.varcode.rel32_code.len
    	        min += len_short
    	        max += len_large
    	        diff += len_large
    	    } else {
    	        length := instr.code.len
    	        diff += length
    	        min += length
    	        max += length
    	    }
    	}

    	if !forward {
    	    diff, min, max = -diff, -min, -max
    	}
	
    	return diff, min, max, !has_variable_length
	}
}

pub fn (mut e Encoder) resolve_variable_length_instrs(mut instrs []&Instr) {
	mut todos := []&Instr{}
	for index := 0; index < instrs.len; index++ {
		name := instrs[index].varcode.trgt_symbol
		s := e.defined_symbols[name] or {
			panic('not implemented yet')
			// Relocation
			rela_text_user := encoder.RelaTextUser{
				instr:  instrs[index],
				offset: 1,
				uses:   name,
				rtype:   encoder.r_x86_64_plt32
			}
			e.rela_text_users << rela_text_user
			instrs[index].code = [u8(0xe9), 0x00, 0x00, 0x00, 0x00]
			instrs[index].is_len_decided = true
			continue
		}
		if instrs[index].section != s.section {
			panic('not implemented yet')
			rela_text_user := encoder.RelaTextUser{
				instr:  instrs[index],
				offset: 1,
				uses:   name,
				rtype:   encoder.r_x86_64_plt32
			}
			e.rela_text_users << rela_text_user
			instrs[index].code = [u8(0xe9), 0x00, 0x00, 0x00, 0x00]
			instrs[index].is_len_decided = true
			continue
		}
		diff, min, max, is_len_decided := calc_distance(instrs[index], s, e.instrs[instrs[index].section])
		if is_len_decided {
			if encoder.is_in_i8_range(diff) {
				instrs[index].code = instrs[index].varcode.rel8_code
				instrs[index].code[instrs[index].varcode.rel8_offset] = u8(diff)
			} else {
				diff_int32 := i32(diff)
				mut hex := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &hex, u32(diff_int32))

				mut code, offset := instrs[index].varcode.rel32_code.clone(), instrs[index].varcode.rel32_offset
				code[offset] = hex[0]
				code[offset+1] = hex[1]
				code[offset+2] = hex[2]
				code[offset+3] = hex[3]
				instrs[index].code = code
			}
			instrs[index].is_len_decided = true
		} else {
			if encoder.is_in_i8_range(max) {
				instrs[index].is_len_decided = true
				instrs[index].varcode.rel32_code = []u8{}
				instrs[index].code = instrs[index].varcode.rel8_code
			} else if !encoder.is_in_i8_range(min) {
				instrs[index].is_len_decided = true
				instrs[index].varcode.rel8_code = []u8{}
				instrs[index].code = instrs[index].varcode.rel32_code
			}
			todos << instrs[index]
		}
	}
	e.variable_instrs = todos
	if e.variable_instrs.len > 0 {
		e.resolve_variable_length_instrs(mut e.variable_instrs)
	}
}

// call instruction

pub fn (mut e Encoder) resolve_call_targets() {
	for call_target in e.call_targets {
		symbol := e.defined_symbols[call_target.target_symbol] or {
			continue
		}

		caller_section := call_target.caller.section

		// canot call symbol from a different section. need to relocate.
		if caller_section != symbol.section {
			panic('TODO: Needs to be relocated')
		}

		mut buf := [u8(0), 0, 0, 0]
		binary.little_endian_put_u32(mut &buf, u32(symbol.addr - (call_target.caller.addr + 5)))
		e.sections[caller_section].code[call_target.caller.addr+1] = buf[0]
		e.sections[caller_section].code[call_target.caller.addr+2] = buf[1]
		e.sections[caller_section].code[call_target.caller.addr+3] = buf[2]
		e.sections[caller_section].code[call_target.caller.addr+4] = buf[3]
	}
}

