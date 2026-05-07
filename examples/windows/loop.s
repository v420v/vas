# vas -f pe examples/windows/loop.s && gcc -o loop.exe examples/windows/loop.o && ./loop.exe
# message 1
# message 2
# message 3
# -------------------
# (×5)

.globl main

.data
msg1:
    .string "message 1"
msg2:
    .string "message 2"
msg3:
    .string "message 3"
line:
    .string "-------------------"

.text
main:
    pushq %rbp
    movq  %rsp, %rbp
    subq  $48, %rsp          # 16 (local counter) + 32 (shadow)
    movq  $0, -8(%rbp)

loop_start:
    cmpq  $5, -8(%rbp)
    je    loop_end

    leaq  msg1(%rip), %rcx
    callq puts

    leaq  msg2(%rip), %rcx
    callq puts

    leaq  msg3(%rip), %rcx
    callq puts

    leaq  line(%rip), %rcx
    callq puts

    addq  $1, -8(%rbp)
    jmp   loop_start

loop_end:
    xorl  %eax, %eax
    addq  $48, %rsp
    popq  %rbp
    retq
