
# vas: Assembler written in V

[Docs](https://github.com/v420v/vas/blob/main/doc/docs.md) | 
[日本語](https://github.com/v420v/vas/blob/main/doc/ドキュメント.md)

THIS SOFTWARE IS UNFINISHED!!!

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

[If V is not installed](https://github.com/vlang/v)

## Build

```sh
$ v . -prod -enable-globals
```

## Run
```
$ vas <filename>.s
$ ld <filename>.o
$ ./a.out

> Hello world!!

```

## Examples

### Game of Life

![GameOfLife](https://github.com/v420v/vas/assets/106643445/54bd3290-d76d-459d-9a96-f763d05d62da)

[https://github.com/v420v/vas/blob/main/examples/gol.s](https://github.com/v420v/vas/blob/main/examples/gol.s)

## License
MIT

## Contributing
Welcome!

## References
- https://github.com/DQNEO/goas port of GNU Assembler written in go
- https://github.com/skx/assembler Basic X86-64 assembler, written in golang
- https://web.mit.edu/rhel-doc/3/rhel-as-en-3/
- https://docs.oracle.com/cd/E19683-01/817-4912/6mkdg542u/index.html オブジェクトファイル形式

