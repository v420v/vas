
# vas: Assembler written in V

[Docs](https://github.com/v420v/vas/blob/main/doc/docs.md) |
[ドキュメント](https://github.com/v420v/vas/blob/main/doc/ドキュメント.md)

THIS SOFTWARE IS UNFINISHED!!!

Supports Linux x86-64 AT&T syntax only.

## Hello world!
```asm
# Hello world!

.global _start

.section .data, "aw"
msg:
  .string "Hello, world!"

.section .text, "ax"
_start:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp

  movq $1, %rax
  movq $1, %rdi
  leaq msg(%rip), %rsi
  movq $13, %rdx
  syscall

  movq $60, %rax
  movq $0, %rdi
  syscall

```

[If V is not installed](https://github.com/vlang/v)

## Quick Start

```sh
$ v vas.v -gc none
```

## Run
```
$ vas <filename>.s
$ ld <filename>.o
$ ./a.out

> Hello world!
```

## License
MIT

## Contributing
Welcome!

## References
- https://github.com/DQNEO/goas port of GNU Assembler written in go
- https://github.com/skx/assembler Basic X86-64 assembler, written in golang
- https://web.mit.edu/rhel-doc/3/rhel-as-en-3/ 
- https://docs.oracle.com/cd/E19683-01/817-4912/6mkdg542u/index.html#chapter6-26 オブジェクトファイル形式 (Japanese)

