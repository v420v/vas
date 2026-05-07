module main

// Adding a case:
//   1. Drop a .s file into tests/cases/pe/.
//   2. Run: ./vas -f pe tests/cases/pe/name.s
//   3. Run: md5 -q tests/cases/pe/name.o > tests/cases/pe/name.expected.md5
//   4. rm tests/cases/pe/name.o && commit both files.

fn testsuite_begin() {
	ensure_vas_built() or {
		assert false, '${err}'
	}
}

fn test_pe() {
	run_suite(pe_dir, 'pe')
}
