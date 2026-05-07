# ./vas -f macho examples/macos/puts.s && clang -arch x86_64 examples/macos/puts.o -o puts.out && arch -x86_64 ./puts.out
# > Hello, world!

.globl _main

.data
msg:
    .string "Hello, world!"

.text
_main:
    pushq %rbp
    movq  %rsp, %rbp
    leaq  msg(%rip), %rdi
    callq _puts
    xorl  %eax, %eax
    popq  %rbp
    retq
