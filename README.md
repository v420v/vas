# vas - x86-64 Assembler written in V

[![ELF CI](https://github.com/v420v/vas/actions/workflows/ci-elf.yml/badge.svg)](https://github.com/v420v/vas/actions/workflows/ci-elf.yml)
[![Mach-O CI](https://github.com/v420v/vas/actions/workflows/ci-macho.yml/badge.svg)](https://github.com/v420v/vas/actions/workflows/ci-macho.yml)
[![PE CI](https://github.com/v420v/vas/actions/workflows/ci-pe.yml/badge.svg)](https://github.com/v420v/vas/actions/workflows/ci-pe.yml)

vas is a small x86-64 assembler written in [V](https://vlang.io). It assembles the
same AT&T-syntax assembly as the GNU assembler (`as`), with instruction encodings
taken straight from NASM's table (`insns.dat`).

vas can assemble the *unmodified* gcc/g++ output of
real-world programs, including [SQLite](https://www.sqlite.org) and
[Lua](https://www.lua.org), without any changes to the generated assembly.
vas is also self-hosting: it assembles the assembly that V and gcc produce from
its own source, and the rebuilt assembler reproduces itself byte-for-byte.

## Installation

### Docker setup

```sh
# Build the Docker image
docker build ./ -t vas

# Run the container
# Linux/MacOS:
docker run --rm -it -v "$(pwd)":/root/env vas

# Windows (CMD):
docker run --rm -it -v "%cd%":/root/env vas

# Windows (PowerShell):
docker run --rm -it -v "${pwd}:/root/env" vas
```

### Build

Requires the V compiler to be installed.

```sh
v . -prod
```

## Usage

Basic usage:
```sh
vas [options] <input_file>.s
```

Options:
- `-o <filename>`: Set output file name (default: input_file.o)
- `-f <format>`: Output format: `elf`, `macho`, or `pe` (default: auto-detect from OS)
- `--keep-locals`: Keep local symbols (e.g., those starting with `.L`)

### Examples

The `examples/` directory has end-to-end showcases where vas stands in for the
GNU assembler: each script runs `gcc -S` to get AT&T assembly, `vas` to assemble
it, and `gcc`/`ld` to link. They need `v`, `gcc`, and `ld` on `PATH` (e.g. the
Docker container above), with `vas` already built (`v -o vas .`).

**SQLite** — assemble the SQLite amalgamation with vas and run real SQL:

```
$ bash examples/sqlite/build-sqlite.sh
==> vas: assemble each .s (vas replaces GNU as here)
   sqlite3.o 1252004 bytes, shell.o 507625 bytes
==> smoke test: run real SQL
--- vas-built SQLite ---
alice|9.5
carol|7.8
3|6.833|9.5
2870
SQLite 3.53.2 built by vas
```

**Lua** — assemble the whole Lua interpreter (every `src/*.c`) with vas and run
a script:

```
$ bash examples/lua/build-lua.sh
==> vas: assemble each .s (vas replaces GNU as here)
   assembled 33 objects
==> smoke test: run real Lua
--- vas-built Lua ---
fib 1..12 : 1 1 2 3 5 8 13 21 34 55 89 144
primes <40 : 2 3 5 7 11 13 17 19 23 29 31 37
Lua 5.4 — assembled by vas
```

**Self-hosting** — vas assembles the assembly that V and gcc emit from its own
source, until two generations produce a byte-identical object:

```
$ bash examples/selfhost/selfhost.sh
==> generation 1: vas assembles vas, then we link + test it
==> generation 2: vas1 assembles vas, then we link + test it
==> FIXPOINT at generation 2: gen2.o is byte-identical to gen1.o
==> vas now reproduces itself exactly — self-hosting verified.
```

The `examples/{linux,macos,windows}/` directories also hold minimal hand-written
ELF / Mach-O / PE programs.

## Testing

Regression tests live under `tests/cases/`, split by output format:

```
tests/cases/
  elf/    — ELF test cases:    <name>.s + <name>.expected.md5
  macho/  — Mach-O test cases: <name>.s + <name>.expected.md5
  pe/     — PE test cases:     <name>.s + <name>.expected.md5
```

The runner is a V `_test.v` file:

```sh
v test tests/
```

This rebuilds `vas`, assembles every case in all three directories, and asserts
the output bytes match the recorded MD5. To add a case:

```sh
# ELF example
$EDITOR tests/cases/elf/my_feature.s
./vas -f elf tests/cases/elf/my_feature.s
md5 -q tests/cases/elf/my_feature.o > tests/cases/elf/my_feature.expected.md5
rm tests/cases/elf/my_feature.o
v test tests/

# Mach-O example
$EDITOR tests/cases/macho/my_feature.s
./vas -f macho tests/cases/macho/my_feature.s
md5 -q tests/cases/macho/my_feature.o > tests/cases/macho/my_feature.expected.md5
rm tests/cases/macho/my_feature.o
v test tests/

# PE example
$EDITOR tests/cases/pe/my_feature.s
./vas -f pe tests/cases/pe/my_feature.s
md5 -q tests/cases/pe/my_feature.o > tests/cases/pe/my_feature.expected.md5
rm tests/cases/pe/my_feature.o
v test tests/
```

## Instruction table

The assembler's instruction set is data-driven: rows are generated from
NASM's `third_party/insns.dat` by `tools/gen_insns.v` and committed to
`encoder/insns_table.gen.v`. Regenerate after editing the parser:

```sh
v run tools/gen_insns.v
```

See `LICENSE-NASM` for the BSD-2-clause notice covering the bundled
`insns.dat` and the rows derived from it.

## Star History
<a href="https://www.star-history.com/#v420v/vas&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=v420v/vas&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=v420v/vas&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=v420v/vas&type=Date" />
 </picture>
</a>

- https://x.com/v_language/status/1643642842214957061

## License

This project is licensed under the MIT License - see the LICENSE file for details.

It also bundles `third_party/insns.dat` from [NASM](https://www.nasm.us/), the
Netwide Assembler, which `tools/gen_insns.v` uses to generate
`encoder/insns_table.gen.v`. That bundled file and any code generated from it
remain under NASM's 2-clause BSD license — see [LICENSE-NASM](LICENSE-NASM).
