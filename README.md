
# vas: Assembler written in V

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

## How to do self hosting

```
# build
$ v . -prod -enable-globals

$ cd selfhost
$ ../vas -o v2.o vas.s
$ cc -o v2 v2.o

$ ./v2 -o v3.o vas.s
$ cc -o v3 v3.o

$ ./v3 --version
```
![image1](https://github.com/v420v/vas/assets/106643445/d95f1629-6f57-4ea2-a5d2-dce2cc82955a)

## Screens

### Game of Life

![gameoflife](https://github.com/v420v/vas/assets/106643445/af3e0d89-b796-4fd8-8603-31e926c776ea)

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

