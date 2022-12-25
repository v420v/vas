
foo:
    retq

bar:
    retQ

_start:
    callq foo
    callq bar

    movq $60, %rax
    movq $42, %rdi

    syscall

