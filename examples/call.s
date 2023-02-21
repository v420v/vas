# Hello world!

.global _start

.data
msg:
    .string "Hello, world!"

.text
print_hello:
    movq $1, %rax
    movq $1, %rdi
    leaq msg(%rip), %rsi
    movq $13, %rdx
    syscall

_start:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp

    callq print_hello

    movq $60, %rax
    movq $0, %rdi
    syscall

