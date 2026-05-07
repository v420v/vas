module main

// Adding a case:
//   1. Drop a .s file into tests/cases/macho/.
//   2. Run: ./vas -f macho tests/cases/macho/name.s
//   3. Run: md5 -q tests/cases/macho/name.o > tests/cases/macho/name.expected.md5
//   4. rm tests/cases/macho/name.o && commit both files.

fn testsuite_begin() {
	ensure_vas_built() or {
		assert false, '${err}'
	}
}

fn test_macho() {
	run_suite(macho_dir, 'macho')
}
