
# vas: Assembler written in V

```asm
_start:
    mov rax, 60
    mov rdi, 0

    call foo
    call bar

    syscall

foo:
    ret

bar:
    ret
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

34
```

## License
MIT
