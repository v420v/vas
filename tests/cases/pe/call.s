# pe local function call + external call

.globl main

.data
msg:
    .string "Hello, world!"

.text
print_hello:
    pushq %rbp
    movq  %rsp, %rbp
    leaq  msg(%rip), %rdi
    callq puts
    popq  %rbp
    retq

main:
    pushq %rbp
    movq  %rsp, %rbp
    callq print_hello
    xorl  %eax, %eax
    popq  %rbp
    retq
