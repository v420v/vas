
.text
.global main
dump:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $64, %rsp
    movq    %rdi, -8(%rbp)
    movq    $1, -56(%rbp)
    movl    $32, %eax
    subq    -56(%rbp), %rax
    movb    $10, -48(%rbp,%rax)
.LBB0_1:
    movq    -8(%rbp), %rax
    movl    $10, %ecx
    xorl    %edx, %edx
    divq    %rcx
    addq    $48, %rdx
    movb    %dl, %cl
    movl    $32, %eax
    subq    -56(%rbp), %rax
    subq    $1, %rax
    movb    %cl, -48(%rbp,%rax)
    movq    -56(%rbp), %rax
    addq    $1, %rax
    movq    %rax, -56(%rbp)
    movq    -8(%rbp), %rax
    movl    $10, %ecx
    xorl    %edx, %edx
    divq    %rcx
    movq    %rax, -8(%rbp)
    cmpq    $0, -8(%rbp)
    jne     .LBB0_1
    movl    $32, %eax
    subq    -56(%rbp), %rax
    leaq    -48(%rbp), %rsi
    addq    %rax, %rsi
    movq    -56(%rbp), %rdx
    movl    $1, %edi
    callq   write
    addq    $64, %rsp
    popq    %rbp
    retq
main:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp
    movl    $0, -4(%rbp)
    movl    $12345, %edi
    callq   dump
    xorl    %eax, %eax
    addq    $16, %rsp
    popq    %rbp
    retq

.section .note.GNU-stack, ""

