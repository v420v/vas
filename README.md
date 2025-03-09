# vas - An x86-64 Assembler Written in V

[![CI](https://github.com/v420v/vas/actions/workflows/ci.yml/badge.svg)](https://github.com/v420v/vas/actions/workflows/ci.yml)

`vas` is a lightweight assembler written in the V programming language that supports Linux x86-64 assembly with AT&T syntax. It compiles assembly source files into object files that can be linked with `ld`.

## Features

- x86-64 instruction set support
- AT&T syntax
- ELF object file generation
- Support for common assembler directives
- Standard input support via `-` argument

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

## Posts on X

- https://x.com/v_language/status/1643642842214957061

- https://x.com/ibuki42O/status/1607026393518604290

- https://x.com/ibuki42O/status/1670080123369058304

## License

This project is licensed under the MIT License - see the LICENSE file for details.
