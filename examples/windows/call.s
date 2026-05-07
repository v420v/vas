# vas -f pe examples/windows/call.s && gcc -o call.exe examples/windows/call.o && ./call.exe
# > Hello, world!

.globl main

.data
msg:
    .string "Hello, world!"

.text
print_hello:
    pushq %rbp
    movq  %rsp, %rbp
    subq  $32, %rsp
    leaq  msg(%rip), %rcx
    callq puts
    addq  $32, %rsp
    popq  %rbp
    retq

main:
    pushq %rbp
    movq  %rsp, %rbp
    subq  $32, %rsp
    callq print_hello
    xorl  %eax, %eax
    addq  $32, %rsp
    popq  %rbp
    retq
