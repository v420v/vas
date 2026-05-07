# macho basic: data section, pcrel leaq relocation, external callq

.globl _main

.data
msg:
    .string "Hello, world!"

.text
_main:
    pushq %rbp
    movq  %rsp, %rbp
    leaq  msg(%rip), %rdi
    callq _puts
    xorl  %eax, %eax
    popq  %rbp
    retq
