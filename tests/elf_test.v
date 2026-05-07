module main

// Adding a case:
//   1. Drop a .s file into tests/cases/elf/.
//   2. Run: ./vas -f elf tests/cases/elf/name.s
//   3. Run: md5 -q tests/cases/elf/name.o > tests/cases/elf/name.expected.md5
//   4. rm tests/cases/elf/name.o && commit both files.

fn testsuite_begin() {
	ensure_vas_built() or {
		assert false, '${err}'
	}
}

fn test_elf() {
	run_suite(elf_dir, 'elf')
}
