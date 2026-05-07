# vas -f pe examples/windows/fibonacci.s && gcc -o fibonacci.exe examples/windows/fibonacci.o && ./fibonacci.exe
# 0
# 1
# 1
# 2
# 3
# 5
# 8
# 13
# 21
# 34
# 55
# 89
# 144

# Windows x64 ABI: args in %rcx, %rdx, %r8, %r9.
# %rbx and %rsi are non-volatile (callee-saved) on Windows x64.

.globl main

.text
fib:
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx
    pushq   %rsi
    subq    $32, %rsp       # shadow space; stack is 16-byte aligned here
    movl    %ecx, %ebx      # save n in %ebx (non-volatile)
    cmpl    $1, %ebx
    jne     .Lfib2
    movl    $0, %eax
    jmp     .Lfib3
.Lfib2:
    cmpl    $2, %ebx
    jne     .Lfib4
    movl    $1, %eax
    jmp     .Lfib3
.Lfib4:
    leal    -1(%rbx), %ecx
    callq   fib
    movl    %eax, %esi      # save fib(n-1) in %esi (non-volatile)
    leal    -2(%rbx), %ecx
    callq   fib
    addl    %esi, %eax      # fib(n-1) + fib(n-2)
.Lfib3:
    addq    $32, %rsp
    popq    %rsi
    popq    %rbx
    popq    %rbp
    retq

main:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $48, %rsp       # 16 (local counter) + 32 (shadow)
    movl    $1, -4(%rbp)
    jmp     .Lloop_test
.Lloop_body:
    movl    -4(%rbp), %ecx
    callq   fib
    movl    %eax, %edx      # arg2 = fib result
    leaq    .Lfmt(%rip), %rcx
    callq   printf
    addl    $1, -4(%rbp)
.Lloop_test:
    cmpl    $14, -4(%rbp)
    jne     .Lloop_body
    xorl    %eax, %eax
    addq    $48, %rsp
    popq    %rbp
    retq

.data
.Lfmt:
    .string "%d\n"
