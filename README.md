
# vas: Assembler written in V

[![CI](https://github.com/v420v/vas/actions/workflows/ci.yml/badge.svg)](https://github.com/v420v/vas/actions/workflows/ci.yml)

[Docs](https://github.com/v420v/vas/blob/main/doc/docs.md) | 
[日本語](https://github.com/v420v/vas/blob/main/doc/ドキュメント.md)

Supports Linux x86-64 AT&T syntax only.

## Hello world!
```asm
# Hello world!

.global _start

.section .data, "aw"
msg:
  .string "Hello, world!\n"

.section .text, "ax"
_start:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp

  movq $1, %rax
  movq $1, %rdi
  movq $msg, %rsi
  movq $14, %rdx
  syscall

  movq $60, %rax
  movq $0, %rdi
  syscall

```

```sh
$ docker build ./ -t vas

# Linux or MacOS:
$ docker run --rm -it -v "$(pwd)":/root/env vas

# Windows (CMD):
$ docker run --rm -it -v "%cd%":/root/env vas

# Windows (PowerShell):
$ docker run --rm -it -v "${pwd}:/root/env" vas

# To leave the environment, enter `exit`.
```

## Build

```sh
$ v . -prod
```

## Run
```
$ vas <filename>.s
$ ld <filename>.o
$ ./a.out

> Hello world!!

```

## License
MIT
