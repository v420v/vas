# ./vas -f macho examples/macos/loop.s && clang -arch x86_64 examples/macos/loop.o -o loop.out && arch -x86_64 ./loop.out
# message 1
# message 2
# message 3
# -------------------
# (×5)

.globl _main

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
_main:
    pushq %rbp
    movq  %rsp, %rbp
    subq  $16, %rsp
    movq  $0, -8(%rbp)

loop_start:
    cmpq $5, -8(%rbp)
    je   loop_end

    leaq msg1(%rip), %rdi
    callq _puts

    leaq msg2(%rip), %rdi
    callq _puts

    leaq msg3(%rip), %rdi
    callq _puts

    leaq line(%rip), %rdi
    callq _puts

    addq $1, -8(%rbp)
    jmp  loop_start

loop_end:
    xorl %eax, %eax
    leave
    retq
