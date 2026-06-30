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
