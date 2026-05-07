# ./vas -f macho examples/macos/call.s && clang -arch x86_64 examples/macos/call.o -o call.out && arch -x86_64 ./call.out
# > Hello, world!

.globl _main

.data
msg:
    .string "Hello, world!"

.text
print_hello:
    pushq %rbp
    movq  %rsp, %rbp
    leaq  msg(%rip), %rdi
    callq _puts
    popq  %rbp
    retq

_main:
    pushq %rbp
    movq  %rsp, %rbp
    callq print_hello
    xorl  %eax, %eax
    popq  %rbp
    retq
