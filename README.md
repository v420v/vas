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
- `--keep-locals`: Keep local symbols (e.g., those starting with `.L`)

### Example

1. Create an assembly file (hello.s):
```asm
# Hello world example

.global _start

.section .data, "aw"
msg:
  .string "Hello, world!\n"

.section .text, "ax"
_start:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp

  movq $1, %rax    # write syscall
  movq $1, %rdi    # stdout
  movq $msg, %rsi  # message
  movq $14, %rdx   # length
  syscall

  movq $60, %rax   # exit syscall
  movq $0, %rdi    # status code 0
  syscall
```

2. Assemble the file:
```sh
vas hello.s
```

3. Link the object file:
```sh
ld hello.o
```

4. Run the executable:
```sh
./a.out
```

Output:
```
Hello, world!
```

## Testing

Regression tests live in `tests/cases/` as `<name>.s` (assembly source) +
`<name>.expected.md5` (expected MD5 of the assembled `.o`) pairs. The
runner is a V `_test.v` file:

```sh
v test tests/
```

This rebuilds `vas`, runs every case through it, and asserts the output
bytes match the recorded MD5. To add a case:

```sh
# 1. drop a new .s file
$EDITOR tests/cases/my_feature.s

# 2. record its expected output
v .                                  # ensure vas is fresh
./vas tests/cases/my_feature.s
md5 -q tests/cases/my_feature.o > tests/cases/my_feature.expected.md5
rm tests/cases/my_feature.o          # keep the dir clean

# 3. verify the new case is picked up
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
