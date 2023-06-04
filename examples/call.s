# ../vas call.s && ld -o call.out call.o && ./call.out
# > Hello, world!

.global _start

.data
msg:
    .string "Hello, world!\n"

.text
print_hello:
    movq $1, %rax
    movq $1, %rdi
    leaq msg(%rip), %rsi
    movq $14, %rdx
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

