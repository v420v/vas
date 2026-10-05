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
