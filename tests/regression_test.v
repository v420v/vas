module main

import os
import crypto.md5

// regression_test.v — runs every `tests/cases/<name>.s` through `vas` and
// asserts the output `.o` byte-for-byte matches `tests/cases/<name>.expected.md5`.
//
// Workflow:
//   v .                    # build the assembler binary at project root
//   v test tests/          # invoke this runner
//
// Adding a case:
//   1. Drop a `.s` file into tests/cases/.
//   2. Run vas on it once to produce a `.o`.
//   3. `md5 -q name.o > name.expected.md5` (or equivalent on Linux).
//   4. Commit both files. The runner will pick the case up automatically.

const project_root = os.dir(os.dir(@FILE))
const cases_dir = os.join_path(project_root, 'tests', 'cases')
const vas_bin = os.join_path(project_root, 'vas')

fn ensure_vas_built() ! {
	// Always rebuild so tests see the latest encoder code; V's incremental
	// build keeps this cheap and avoids surprises from stale binaries.
	result := os.execute('cd ${project_root} && v .')
	if result.exit_code != 0 {
		return error('failed to build vas: ${result.output}')
	}
}

fn case_md5(s_path string, name string) !string {
	o_path := os.join_path(cases_dir, '${name}.o')
	defer {
		os.rm(o_path) or {}
	}
	run := os.execute('${vas_bin} ${s_path}')
	if run.exit_code != 0 {
		return error('vas failed (exit=${run.exit_code}): ${run.output}')
	}
	bytes := os.read_bytes(o_path) or {
		return error('cannot read ${o_path}: ${err}')
	}
	return md5.sum(bytes).hex()
}

fn test_regression() {
	ensure_vas_built() or {
		assert false, '${err}'
		return
	}

	entries := os.ls(cases_dir) or {
		assert false, 'cannot list cases dir ${cases_dir}: ${err}'
		return
	}

	mut cases := []string{}
	for entry in entries {
		if entry.ends_with('.s') {
			cases << entry
		}
	}
	cases.sort()

	mut failures := []string{}
	for case in cases {
		name := case[..case.len - 2]
		s_path := os.join_path(cases_dir, case)
		expected_path := os.join_path(cases_dir, '${name}.expected.md5')

		actual := case_md5(s_path, name) or {
			failures << '${name}: ${err}'
			continue
		}
		expected_raw := os.read_file(expected_path) or {
			failures << '${name}: missing ${name}.expected.md5'
			continue
		}
		expected := expected_raw.trim_space()
		if actual != expected {
			failures << '${name}: byte mismatch — actual=${actual} expected=${expected}'
		}
	}

	if failures.len > 0 {
		for f in failures {
			eprintln('  FAIL: ${f}')
		}
		assert false, '${failures.len} of ${cases.len} regression case(s) failed'
	}
	println('${cases.len} regression cases passed')
}
