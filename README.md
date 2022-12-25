
# vas: Assembler written in V

```asm
_start:
    callq foo
    callq bar

    movq $60, %rax
    movq $42, %rdi

    syscall

foo:
    retq

bar:
    retq
```

## Build
```sh
$ v vas.v
```

## Assemble
```
$ vas <filename>.s
$ ld <filename>.o
$ ./a.out
$ echo $?

42
```

## License
MIT
