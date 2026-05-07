# vas - x86-64 Assembler written in V

[![CI](https://github.com/v420v/vas/actions/workflows/ci.yml/badge.svg)](https://github.com/v420v/vas/actions/workflows/ci.yml)

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

The `examples/` directory contains ready-to-run programs organized by platform:

```
examples/
  linux/    — ELF examples    (assemble with vas, link with ld/gcc)
  macos/    — Mach-O examples  (assemble with vas -f macho, link with clang)
  windows/  — PE/COFF examples (assemble with vas -f pe, link with gcc/MinGW)
```

**Linux (ELF):**
```sh
./vas examples/linux/hello.s && ld -o hello.out examples/linux/hello.o && ./hello.out
# > Hello, world!
```

**macOS (Mach-O, x86-64):**
```sh
./vas -f macho examples/macos/hello.s && clang -arch x86_64 examples/macos/hello.o -o hello.out && arch -x86_64 ./hello.out
# > Hello, world!
```

**Windows (PE/COFF, x86-64):**

Windows uses the Microsoft x64 ABI: the first four integer arguments are passed
in `%rcx`, `%rdx`, `%r8`, `%r9` (instead of `%rdi`, `%rsi`, `%rdx`, `%rcx`
on Linux/macOS), and the caller must reserve 32 bytes of shadow space before
every `call`.

Link with MinGW/GCC:
```sh
vas -f pe examples/windows/hello.s && gcc -o hello.exe examples/windows/hello.o && hello.exe
# > Hello, world!
```

Or with the MSVC linker:
```bat
vas -f pe examples\windows\hello.s
link /out:hello.exe /subsystem:console /defaultlib:ucrt examples\windows\hello.o
hello.exe
```

Cross-compile from Linux (requires `x86_64-w64-mingw32-gcc`):
```sh
./vas -f pe examples/windows/hello.s && x86_64-w64-mingw32-gcc -o hello.exe examples/windows/hello.o
```

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
