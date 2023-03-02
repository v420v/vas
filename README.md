
# vas: Assembler written in V

THIS SOFTWARE IS UNFINISHED!!!

Supports Linux x86-64 AT&T syntax only.

```asm
# Hello world!

.global _start

.data
msg:
  .string "Hello, world!"

.text
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

## Contributing
Welcome!

## References
- https://github.com/DQNEO/goas port of GNU Assembler written in go
- https://github.com/skx/assembler Basic X86-64 assembler, written in golang
- https://web.mit.edu/rhel-doc/3/rhel-as-en-3/ 

