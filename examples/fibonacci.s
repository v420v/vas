# ../vas -o fibonacci.o fibonacci.s && gcc -o fibonacci.out fibonacci.o && ./fibonacci.out
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

.section .text, "ax"
.global main
fib:
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx
    subq    $24, %rsp
    movl    %edi, -20(%rbp)
    cmpl    $1, -20(%rbp)
    jne     .L2
    movl    $0, %eax
    jmp     .L3
.L2:
    cmpl    $2, -20(%rbp)
    jne     .L4
    movl    $1, %eax
    jmp     .L3
.L4:
    movl    -20(%rbp), %eax
    subl    $1, %eax
    movl    %eax, %edi
    call    fib
    movl    %eax, %ebx
    movl    -20(%rbp), %eax
    subl    $2, %eax
    movl    %eax, %edi
    call    fib
    addl    %ebx, %eax
.L3:
    movq    -8(%rbp), %rbx
    leave
    ret
.LC0:
    .string "%d\n"
main:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp
    movl    $1, -4(%rbp)
    jmp     .L6
.L7:
    movl    -4(%rbp), %eax
    movl    %eax, %edi
    call    fib
    movl    %eax, %esi
    leaq    .LC0(%rip), %rdi
    movl    $0, %eax
    call    printf
    addl    $1, -4(%rbp)
.L6:
    cmpl    $14, -4(%rbp)
    jne     .L7
    movl    $0, %eax
    leave
    ret

.section .note.GNU-stack, ""

