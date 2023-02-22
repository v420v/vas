# ./vas puts.s
# gcc -o puts puts.o
# ./puts
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
