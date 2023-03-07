# ./vas puts.s
# gcc -o puts puts.o
# ./puts
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
