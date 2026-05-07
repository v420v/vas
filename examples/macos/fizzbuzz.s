# ./vas -f macho examples/macos/fizzbuzz.s && clang -arch x86_64 examples/macos/fizzbuzz.o -o fizzbuzz.out && arch -x86_64 ./fizzbuzz.out

.globl _main

.data
fizz:
    .string "fizz"
buzz:
    .string "buzz"
fizzbuzz:
    .string "fizzbuzz"
fmt:
    .string "%d\n"

.text
_main:
    pushq %rbp
    movq  %rsp, %rbp
    subq  $16, %rsp
    movq  $1, -8(%rbp)

loop_start:
    cmpq $101, -8(%rbp)
    je   loop_end

    movq  -8(%rbp), %rax
    movq  $15, %rcx
    cqto
    idivq %rcx
    testq %rdx, %rdx
    jne   .L1
    leaq  fizzbuzz(%rip), %rdi
    callq _puts
    jmp   .L2

.L1:
    movq  -8(%rbp), %rax
    movq  $3, %rcx
    cqto
    idivq %rcx
    testq %rdx, %rdx
    jne   .L3
    leaq  fizz(%rip), %rdi
    callq _puts
    jmp   .L2

.L3:
    movq  -8(%rbp), %rax
    movq  $5, %rcx
    cqto
    idivq %rcx
    testq %rdx, %rdx
    jne   .L4
    leaq  buzz(%rip), %rdi
    callq _puts
    jmp   .L2

.L4:
    leaq  fmt(%rip), %rdi
    movq  -8(%rbp), %rsi
    callq _printf

.L2:
    addq $1, -8(%rbp)
    jmp  loop_start

loop_end:
    xorl %eax, %eax
    leave
    retq
