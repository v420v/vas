
.global _start

bar:
    retq

_start:
    callq foo
    callq bar

    movq $60, %rax
    
    movq $35, %rdi

    addq $35, %rdi
    subq $35, %rdi
    
    addq $35, %rdi

    syscall

foo:
    retq

