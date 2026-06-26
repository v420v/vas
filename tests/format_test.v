module main

import os

fn testsuite_begin() {
	ensure_vas_built() or {
		assert false, '${err}'
	}
}

fn test_invalid_format_exits_nonzero() {
	// Use the first available .s file from the elf cases as a valid input.
	entries := os.ls(elf_dir) or {
		assert false, 'cannot list ${elf_dir}: ${err}'
		return
	}
	mut s_file := ''
	for e in entries {
		if e.ends_with('.s') {
			s_file = os.join_path(elf_dir, e)
			break
		}
	}
	assert s_file != '', 'no .s file found in ${elf_dir}'

	result := os.execute('${vas_bin} -f notaformat ${s_file}')
	assert result.exit_code != 0, 'expected non-zero exit for invalid format, got 0'
	assert result.output.contains('notaformat'), 'error message should name the bad format'
	assert result.output.contains('elf'), 'error message should list valid formats'
}

fn test_wrong_case_format_exits_nonzero() {
	entries := os.ls(elf_dir) or {
		assert false, 'cannot list ${elf_dir}: ${err}'
		return
	}
	mut s_file := ''
	for e in entries {
		if e.ends_with('.s') {
			s_file = os.join_path(elf_dir, e)
			break
		}
	}
	assert s_file != '', 'no .s file found in ${elf_dir}'

	result := os.execute('${vas_bin} -f ELF ${s_file}')
	assert result.exit_code != 0, 'expected non-zero exit for wrong-case format "ELF", got 0'
	assert result.output.contains('ELF'), 'error message should name the bad format'
}
