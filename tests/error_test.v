module main

import os

const errors_dir = os.join_path(project_root, 'tests', 'cases', 'errors')

fn testsuite_begin() {
	ensure_vas_built() or {
		assert false, '${err}'
	}
}

fn test_div_by_zero_clean_error() {
	s_path := os.join_path(errors_dir, 'div_by_zero.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for division by zero, got 0'
	assert !result.output.contains('panic'), 'expected clean error, got panic: ${result.output}'
	assert result.output.contains('division by zero'), 'expected "division by zero" in error output, got: ${result.output}'
}

fn test_modifier_width_clean_error() {
	s_path := os.join_path(errors_dir, 'modifier_width.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for `.long sym@GOTOFF`, got 0'
	assert !result.output.contains('panic'), 'expected clean error, got panic: ${result.output}'
	assert result.output.contains('cannot be used with a 4-byte value'), 'expected width error in output, got: ${result.output}'
}

fn test_leb128_symbol_clean_error() {
	s_path := os.join_path(errors_dir, 'leb128_symbol.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for `.uleb128 extern_sym`, got 0'
	assert !result.output.contains('panic'), 'expected clean error, got panic: ${result.output}'
	assert result.output.contains('label difference'), 'expected LEB128 error in output, got: ${result.output}'
}

fn test_tls_data_rejected_for_macho_and_pe() {
	s_path := os.join_path(errors_dir, 'tls_data_macho.s')
	for format in ['macho', 'pe'] {
		result := os.execute('${vas_bin} -f ${format} ${s_path}')
		assert result.exit_code != 0, 'expected non-zero exit for `.long x@TPOFF` with -f ${format}, got 0'
		assert !result.output.contains('panic'), 'expected clean error, got panic: ${result.output}'
		assert result.output.contains('ELF-only'), 'expected ELF-only error for -f ${format}, got: ${result.output}'
	}
}

fn test_bad_scale_nonzero_exit() {
	s_path := os.join_path(errors_dir, 'bad_scale.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for scale factor 3, got 0'
	assert result.output.contains('scale factor'), 'expected scale error in output, got: ${result.output}'
}

fn test_rsp_index_rejected() {
	s_path := os.join_path(errors_dir, 'rsp_index.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for %rsp as SIB index, got 0'
	assert result.output.contains('index register'), 'expected index-register error in output, got: ${result.output}'
}

fn test_high_byte_register_with_rex_rejected() {
	s_path := os.join_path(errors_dir, 'high_byte_rex.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for `movb %ah, %r8b`, got 0'
	assert result.output.contains('REX'), 'expected REX error in output, got: ${result.output}'
}

fn test_weakref_clean_error() {
	s_path := os.join_path(errors_dir, 'weakref.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for .weakref, got 0'
	assert result.output.contains('.weakref'), 'expected .weakref error in output, got: ${result.output}'
}

fn test_bad_octal_clean_error() {
	s_path := os.join_path(errors_dir, 'bad_octal.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for `.long 0789`, got 0'
	assert result.output.contains('octal'), 'expected octal error in output, got: ${result.output}'
}

fn test_comm_huge_size_clean_error() {
	s_path := os.join_path(errors_dir, 'comm_huge.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for `.comm buf, 0x100000001`, got 0'
	assert result.output.contains('exceeds'), 'expected size error in output, got: ${result.output}'
}

fn test_disp_out_of_range_clean_error() {
	s_path := os.join_path(errors_dir, 'disp_range.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for a 33-bit displacement, got 0'
	assert !result.output.contains('panic'), 'expected clean error, got panic: ${result.output}'
	assert result.output.contains('displacement'), 'expected displacement error in output, got: ${result.output}'
}

fn test_align_fill_width_mismatch_clean_error() {
	s_path := os.join_path(errors_dir, 'align_fill_width.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for 3 bytes of 4-byte fill, got 0'
	assert result.output.contains('not a multiple'), 'expected padding error in output, got: ${result.output}'
}

fn test_data_value_out_of_range_clean_error() {
	s_path := os.join_path(errors_dir, 'data_range.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for `.byte 300`, got 0'
	assert result.output.contains('out of range'), 'expected range error in output, got: ${result.output}'
}

fn test_unsigned_imm32_on_quad_operand_rejected() {
	s_path := os.join_path(errors_dir, 'imm32_unsigned_quad.s')
	result := os.execute('${vas_bin} -f elf ${s_path}')
	assert result.exit_code != 0, 'expected non-zero exit for `addq $0xffffffff, %rax`, got 0'
}

// Input errors are reported as `file:line: error: msg` with exit code 1: never
// a V panic, and never the internal-error path (exit code 2), which is
// reserved for bugs in vas itself.
fn test_input_errors_are_positioned_and_exit_1() {
	for name, want in {
		'xmm_index.s':         'general-purpose'
		'seg_register_disp.s': 'invalid expression'
		'bad_hex_escape.s':    'invalid hex escape'
		'bad_scale.s':         'scale factor'
		'div_by_zero.s':       'division by zero'
	} {
		result := os.execute('${vas_bin} -f elf ${os.join_path(errors_dir, name)}')
		assert result.exit_code == 1, '${name}: expected exit 1, got ${result.exit_code}: ${result.output}'
		assert result.output.contains('${name}:'), '${name}: expected file:line prefix, got: ${result.output}'
		assert result.output.contains(want), '${name}: expected `${want}`, got: ${result.output}'
		assert !result.output.contains('panic') && !result.output.contains('internal error'), '${name}: ${result.output}'
	}
}

fn test_backend_errors_carry_a_source_position() {
	s_path := os.join_path(errors_dir, 'tls_data_macho.s')
	for format in ['macho', 'pe'] {
		result := os.execute('${vas_bin} -f ${format} ${s_path}')
		assert result.exit_code == 1, '${format}: ${result.output}'
		assert result.output.contains('tls_data_macho.s:'), '${format}: expected file:line prefix, got: ${result.output}'
	}
}

fn test_unwritable_output_is_a_clean_error() {
	src := os.join_path(project_root, 'main.s')
	out := os.join_path(os.temp_dir(), 'vas_no_such_dir_${os.getpid()}', 'x.o')
	result := os.execute('${vas_bin} -f elf ${src} -o ${out}')
	assert result.exit_code == 1, 'expected exit 1, got ${result.exit_code}: ${result.output}'
	assert result.output.contains('cannot write'), 'expected write error, got: ${result.output}'
	assert !result.output.contains('panic'), 'expected clean error, got panic: ${result.output}'
	assert !os.exists(out)
}
