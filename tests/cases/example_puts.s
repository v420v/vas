# ../vas puts.s && gcc -o puts.out puts.o && ./puts.out
# > Hello, world!

.data
msg:
  .string "Hello world!"

.text
.global main
main:
  leaq msg(%rip), %rdi
  callq puts
  movq $0, %rax
  retq

.section .note.GNU-stack, ""
