# ../vas puts.s && gcc -o puts.out puts.o && ./puts.out
# > Hello, world!

.section .data, "wa"
msg:
  .string "Hello world!"

.section .text, "ax"
.global main
main:
  leaq msg(%rip), %rdi
  callq puts
  movq $0, %rax
  retq

.section .note.GNU-stack, ""
