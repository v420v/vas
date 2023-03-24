# ./vas call.s
# ld -o call call.o
# ./call
# > Hello, world!

.global _start

.section .data, "wa"
msg:
    .string "Hello, world!"

.section .text, "ax"
print_hello:
    movq $1, %rax
    movq $1, %rdi
    leaq msg(%rip), %rsi
    movq $13, %rdx
    syscall
    retq

_start:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp

    callq print_hello

    movq $60, %rax
    movq $0, %rdi
    syscall

