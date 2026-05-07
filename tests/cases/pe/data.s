# pe multiple data labels, multiple pcrel relocations

.globl main

.data
str1:
    .string "alpha"
str2:
    .string "beta"
str3:
    .string "gamma"

.text
main:
    pushq %rbp
    movq  %rsp, %rbp
    leaq  str1(%rip), %rdi
    callq puts
    leaq  str2(%rip), %rdi
    callq puts
    leaq  str3(%rip), %rdi
    callq puts
    xorl  %eax, %eax
    popq  %rbp
    retq
