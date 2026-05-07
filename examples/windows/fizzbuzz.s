# vas -f pe examples/windows/fizzbuzz.s && gcc -o fizzbuzz.exe examples/windows/fizzbuzz.o && ./fizzbuzz.exe

.globl main

.data
fizz:
    .string "fizz"
buzz:
    .string "buzz"
fizzbuzz_str:
    .string "fizzbuzz"
fmt:
    .string "%d\n"

.text
main:
    pushq %rbp
    movq  %rsp, %rbp
    subq  $48, %rsp          # 16 (local counter) + 32 (shadow)
    movq  $1, -8(%rbp)

loop_start:
    cmpq  $101, -8(%rbp)
    je    loop_end

    movq  -8(%rbp), %rax
    movq  $15, %rcx
    cqto
    idivq %rcx
    testq %rdx, %rdx
    jne   .L1
    leaq  fizzbuzz_str(%rip), %rcx
    callq puts
    jmp   .L2

.L1:
    movq  -8(%rbp), %rax
    movq  $3, %rcx
    cqto
    idivq %rcx
    testq %rdx, %rdx
    jne   .L3
    leaq  fizz(%rip), %rcx
    callq puts
    jmp   .L2

.L3:
    movq  -8(%rbp), %rax
    movq  $5, %rcx
    cqto
    idivq %rcx
    testq %rdx, %rdx
    jne   .L4
    leaq  buzz(%rip), %rcx
    callq puts
    jmp   .L2

.L4:
    movq  -8(%rbp), %rdx
    leaq  fmt(%rip), %rcx
    callq printf

.L2:
    addq  $1, -8(%rbp)
    jmp   loop_start

loop_end:
    xorl  %eax, %eax
    addq  $48, %rsp
    popq  %rbp
    retq
