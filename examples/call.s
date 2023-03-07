# ./vas call.s
# ld -o call call.o
# ./call
# > Hello, world! 2 3

.global _start

.section .data, "wa"
msg:
    .string "Hello, world!"

msg2:
    .string " 2 "

msg3:
    .string " 3 "

.section .text, "ax"
print_hello:
    movq $1, %rax
    movq $1, %rdi
    leaq msg(%rip), %rsi
    movq $13, %rdx
    syscall
    retq
    
2:
    movq $1, %rax
    movq $1, %rdi
    leaq msg2(%rip), %rsi
    movq $4, %rdx
    syscall
    retq

3:
    movq $1, %rax
    movq $1, %rdi
    leaq msg3(%rip), %rsi
    movq $4, %rdx
    syscall
    retq

_start:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp

    callq print_hello

    callq 2

    callq 3

    movq $60, %rax
    movq $0, %rdi
    syscall

