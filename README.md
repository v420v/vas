
# vas: Assembler written in V

THIS SOFTWARE IS UNFINISHED!!!

Supports Linux x86-64 AT&T syntax only.

```asm
.global _start

bar:
    retq

_start:
    callq foo
    callq bar

    movq $60, %rax
    
    movq $35, %rdi
    addq $35, %rdi

    syscall

foo:
    retq
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
$ echo $?

70
```

## License
MIT
