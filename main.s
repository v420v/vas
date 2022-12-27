
.global _start

bar:
    retq

_start:
    callq foo
    callq bar

    movq $60, %rax
    movq $42, %rdi

    syscall

foo:
    retq

