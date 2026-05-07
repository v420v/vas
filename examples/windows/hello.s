# vas -f pe examples/windows/hello.s && gcc -o hello.exe examples/windows/hello.o && ./hello.exe
# > Hello, world!

# Windows x64 ABI: first argument in %rcx (not %rdi).
# 32 bytes of shadow space must be reserved by the caller before any call.

.globl main

.data
msg:
    .string "Hello, world!"

.text
main:
    pushq %rbp
    movq  %rsp, %rbp
    subq  $32, %rsp          # shadow space
    leaq  msg(%rip), %rcx    # arg1 → %rcx
    callq puts
    xorl  %eax, %eax
    addq  $32, %rsp
    popq  %rbp
    retq
