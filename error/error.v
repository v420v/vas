module error

import token

// vas reports three kinds of failure, each through exactly one function:
//
//   fatal     the input is wrong (syntax, range, unsupported for the chosen
//             output format). `file:line: error: msg`, exit 1.
//   fatal_env the environment failed (unreadable input, unwritable output,
//             bad command line). `vas: error: msg`, exit 1.
//   internal  vas itself is wrong: a state no input should be able to reach.
//             `vas: internal error: msg`, exit 2.
//
// Never `panic` for the first two, and never report a reachable input problem
// as `internal`.

pub const exit_user = 1
pub const exit_internal = 2

const issue_url = 'https://github.com/v420v/vas/issues/new?template=bug_report.yml'

// fatal reports an error in the input at `pos` and exits.
@[noreturn]
pub fn fatal(pos token.Position, msg string) {
	eprintln('\x1b[1m${pos.file_name}:${pos.line}: \x1b[91merror\x1b[0m\x1b[1m: ${msg} \x1b[0m')
	exit(exit_user)
}

// fatal_env reports a failure that has no source position and exits.
@[noreturn]
pub fn fatal_env(msg string) {
	eprintln('\x1b[1mvas: \x1b[91merror\x1b[0m\x1b[1m: ${msg} \x1b[0m')
	exit(exit_user)
}

// internal reports a bug in vas itself and exits.
@[noreturn]
pub fn internal(msg string) {
	eprintln('\x1b[1mvas: \x1b[91minternal error\x1b[0m\x1b[1m: ${msg} \x1b[0m')
	eprintln('This is a bug in vas, not in your input. Please open an issue and attach the')
	eprintln('assembly source and the command line that triggered it:')
	eprintln('  ${issue_url}')
	exit(exit_internal)
}
