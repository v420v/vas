
# vas: Assembler written in V

THIS SOFTWARE IS UNFINISHED!!!

Supports Linux x86-64 AT&T syntax only.

```asm
# Hello world!

.global _start

msg:
  .string "Hello world!"

_start:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rbp

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

## Build

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
