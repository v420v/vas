
_start:
    mov rax, 60
    mov rdi, 42

    call foo
    call bar

    syscall

foo:
    ret

bar:
    ret

