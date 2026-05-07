module main

import os
import crypto.md5

const project_root = os.dir(os.dir(@FILE))
const elf_dir      = os.join_path(project_root, 'tests', 'cases', 'elf')
const macho_dir    = os.join_path(project_root, 'tests', 'cases', 'macho')
const pe_dir       = os.join_path(project_root, 'tests', 'cases', 'pe')
const vas_bin      = os.join_path(project_root, 'vas')

fn ensure_vas_built() ! {
	if !os.exists(vas_bin) {
		return error('vas binary not found at ${vas_bin} — run `v .` in the project root first')
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

// log opens /dev/tty to write directly to the controlling terminal,
// bypassing the pipe redirection V's test runner applies to fd 1 and fd 2.
fn log(msg string) {
	s := msg + '\n'
	fd := C.open(c'/dev/tty', C.O_WRONLY, 0)
	if fd >= 0 {
		C.write(fd, s.str, s.len)
		C.close(fd)
	}
}

// run_suite assembles every .s file in dir, compares the output MD5 against
// the paired .expected.md5, and prints a PASS/FAIL line per case.
// A single final assert reports all failures at once.
fn run_suite(dir string, format string) {
	entries := os.ls(dir) or {
		assert false, 'cannot list ${dir}: ${err}'
		return
	}

	mut names := []string{}
	for entry in entries {
		if entry.ends_with('.s') {
			names << entry[..entry.len - 2]
		}
	}
	names.sort()

	mut failures := []string{}
	for name in names {
		expected_path := os.join_path(dir, '${name}.expected.md5')
		actual := case_md5(dir, name, format) or {
			failures << '${name}: ${err}'
			log('  FAIL ${format}/${name}: ${err}')
			continue
		}
		expected_raw := os.read_file(expected_path) or {
			failures << '${name}: missing ${name}.expected.md5'
			log('  FAIL ${format}/${name}: missing ${name}.expected.md5')
			continue
		}
		expected := expected_raw.trim_space()
		if actual == expected {
			log('  PASS ${format}/${name}')
		} else {
			failures << '${name}: byte mismatch — actual=${actual} expected=${expected}'
			log('  FAIL ${format}/${name}: byte mismatch — actual=${actual} expected=${expected}')
		}
	}

	assert failures.len == 0,
		'${failures.len} of ${names.len} ${format} case(s) failed:\n  ' + failures.join('\n  ')
}
