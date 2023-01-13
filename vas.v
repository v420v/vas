module main

import os
import flag
import parser
import gen

fn file_name_without_ext(file_name string) string {
	ext_len := os.file_ext(file_name).len
	bytes := file_name.bytes()
	return bytes[..bytes.len - ext_len].bytestr()
}

const usage = 'Usage: vas [options] [ARGS]

Options:
  -o, --o                   set output file name
  -h, --help                display this help and exit
  --version                 output version information and exit

Examples:
  vas -o main.o main.s
  vas main.s'

fn main() {
	mut fp := flag.new_flag_parser(os.args)
    fp.application('vas')
    fp.version('v0.0.0')
    fp.skip_executable()
    mut out_file := fp.string('o', `o`, 'out_file_none', 'set output file name')
    
    additional_args := fp.finalize() or {
        println(usage)
        return
    }

	if additional_args.len < 1 {
		println(usage)
        return
	}

	file_name := additional_args[0]

	if out_file == 'out_file_none' {
		out_file = file_name_without_ext(file_name) + '.o'
	}

	mut p := parser.new(file_name)
	mut instrs := p.parse()

	mut g := gen.new(out_file)
	g.encode(mut instrs)

	g.write_code(instrs)
	g.gen_elf()
}

