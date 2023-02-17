
.global _start

msg:
  .string "Hello world!"

_start:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rbp

  movq $1, %rax
  movq $1, %rdi
  leaq msg(%rip), %rsi
  movq $13, %rdx
  syscall

  movq $60, %rax
  movq $0, %rdi
  syscall



