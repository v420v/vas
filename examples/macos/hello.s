# ./vas -f macho examples/macos/hello.s && clang -arch x86_64 examples/macos/hello.o -o hello.out && arch -x86_64 ./hello.out
# > Hello, world!

.globl _main

.text
_main:
    pushq %rbp
    movq  %rsp, %rbp
    leaq  msg(%rip), %rdi
    callq _puts
    xorl  %eax, %eax
    popq  %rbp
    retq

.data
msg:
    .string "Hello, world!"
