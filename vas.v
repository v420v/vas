module main

import os
import flag
import parser
import gen
import encoding.binary

fn file_name_without_ext(file_name string) string {
	ext_len := os.file_ext(file_name).len
	bytes := file_name.bytes()
	return bytes[..bytes.len - ext_len].bytestr()
}

fn main() {
	mut fp := flag.new_flag_parser(os.args)
    fp.application('vas')
    fp.version('v0.0.0')
    fp.skip_executable()
    mut out_file := fp.string('o', `o`, 'out_file_none', 'set output file name')
    
    additional_args := fp.finalize() or {
        println(fp.usage())
        return
    }

	if additional_args.len < 1 {
		println(fp.usage())
        return
	}

	file_name := additional_args[0]

	if out_file == 'out_file_none' {
		out_file = file_name_without_ext(file_name) + '.o'
	}

	program := os.read_file(file_name) or {
		eprintln('error: reading file `${file_name}`')
		exit(1)
	}

	mut p := parser.new(program, file_name)
	mut instrs, mut defined_symbols, call_targets := p.parse()

	mut g := gen.new(out_file)

	for mut instr in instrs {
		instr.addr = g.addr
		g.addr += instr.code.len

		if instr.kind == .global {
			g.globals_count++

			symbol_name := instr.symbol_name
			for mut symbol in defined_symbols {
				if symbol.symbol_name == symbol_name {
					symbol.binding = gen.stb_global
				}
			}
		} else if instr.kind == .local {
			symbol_name := instr.symbol_name
			for mut symbol in defined_symbols {
				if symbol.symbol_name == symbol_name {
					symbol.binding = gen.stb_local
				}
			}
		} else {
			g.code << instr.code
		}
	}

	for call_target in call_targets {
		for mut symbol in defined_symbols {
			if symbol.symbol_name == call_target.target_symbol {
				mut buf := [u8(0), 0, 0, 0]
				binary.little_endian_put_u32(mut &buf, u32(symbol.addr - (call_target.caller.addr + 5)))
				g.code[call_target.caller.addr+1] = buf[0]
				g.code[call_target.caller.addr+2] = buf[1]
				g.code[call_target.caller.addr+3] = buf[2]
				g.code[call_target.caller.addr+4] = buf[3]
			}
		}
	}

	padding := (gen.align_to(g.code.len, 32) - g.code.len)
	for _ in 0 .. padding {
		g.code << 0
	}

	g.symbols = defined_symbols
	g.gen_elf()
}

