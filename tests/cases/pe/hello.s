# pe basic: data section, pcrel leaq relocation, external call

.globl main

.data
msg:
    .string "Hello, world!"

.text
main:
    pushq %rbp
    movq  %rsp, %rbp
    leaq  msg(%rip), %rdi
    callq puts
    xorl  %eax, %eax
    popq  %rbp
    retq
