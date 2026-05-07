module main

import os
import crypto.md5

// regression_test.v — assembles every test case and byte-checks the output.
//
// Layout:
//   tests/cases/elf/   — ELF test cases: <name>.s + <name>.expected.md5
//   tests/cases/macho/ — Mach-O test cases: <name>.s + <name>.expected.md5
//
// Workflow:
//   v .                    # build the assembler binary at project root
//   v test tests/          # invoke this runner
//
// Adding a case:
//   ELF:
//     1. Drop a .s file into tests/cases/elf/.
//     2. Run: ./vas -f elf tests/cases/elf/name.s
//     3. Run: md5 -q tests/cases/elf/name.o > tests/cases/elf/name.expected.md5
//     4. rm tests/cases/elf/name.o && commit both files.
//   Mach-O:
//     1. Drop a .s file into tests/cases/macho/.
//     2. Run: ./vas -f macho tests/cases/macho/name.s
//     3. Run: md5 -q tests/cases/macho/name.o > tests/cases/macho/name.expected.md5
//     4. rm tests/cases/macho/name.o && commit both files.

const project_root = os.dir(os.dir(@FILE))
const elf_dir = os.join_path(project_root, 'tests', 'cases', 'elf')
const macho_dir = os.join_path(project_root, 'tests', 'cases', 'macho')
const vas_bin = os.join_path(project_root, 'vas')

fn ensure_vas_built() ! {
	// Always rebuild so tests see the latest encoder code; V's incremental
	// build keeps this cheap and avoids surprises from stale binaries.
	result := os.execute('cd ${project_root} && v .')
	if result.exit_code != 0 {
		return error('failed to build vas: ${result.output}')
	}
}

fn case_md5(dir string, name string, format string) !string {
	s_path := os.join_path(dir, '${name}.s')
	o_path := os.join_path(dir, '${name}.o')
	defer {
		os.rm(o_path) or {}
	}
	run := os.execute('${vas_bin} -f ${format} ${s_path}')
	if run.exit_code != 0 {
		return error('vas failed (exit=${run.exit_code}): ${run.output}')
	}
	bytes := os.read_bytes(o_path) or {
		return error('cannot read ${o_path}: ${err}')
	}
	return md5.sum(bytes).hex()
}

fn run_cases(dir string, format string, mut failures []string) int {
	entries := os.ls(dir) or {
		failures << 'cannot list ${dir}: ${err}'
		return 0
	}

	mut names := []string{}
	for entry in entries {
		if entry.ends_with('.s') {
			names << entry[..entry.len - 2]
		}
	}
	names.sort()

	for name in names {
		expected_path := os.join_path(dir, '${name}.expected.md5')
		actual := case_md5(dir, name, format) or {
			failures << '${name} (${format}): ${err}'
			continue
		}
		expected_raw := os.read_file(expected_path) or {
			failures << '${name} (${format}): missing ${name}.expected.md5'
			continue
		}
		expected := expected_raw.trim_space()
		if actual != expected {
			failures << '${name} (${format}): byte mismatch — actual=${actual} expected=${expected}'
		}
	}

	return names.len
}

fn test_regression() {
	ensure_vas_built() or {
		assert false, '${err}'
		return
	}

	mut failures := []string{}
	elf_count := run_cases(elf_dir, 'elf', mut failures)
	macho_count := run_cases(macho_dir, 'macho', mut failures)

	total := elf_count + macho_count
	if failures.len > 0 {
		for f in failures {
			eprintln('  FAIL: ${f}')
		}
		assert false, '${failures.len} of ${total} regression case(s) failed'
	}
	println('${elf_count} ELF + ${macho_count} Mach-O regression cases passed')
}
