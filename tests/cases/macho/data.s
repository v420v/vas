# macho multiple data labels, multiple pcrel relocations

.globl _main

.data
str1:
    .string "alpha"
str2:
    .string "beta"
str3:
    .string "gamma"

.text
_main:
    pushq %rbp
    movq  %rsp, %rbp
    leaq  str1(%rip), %rdi
    callq _puts
    leaq  str2(%rip), %rdi
    callq _puts
    leaq  str3(%rip), %rdi
    callq _puts
    xorl  %eax, %eax
    popq  %rbp
    retq
