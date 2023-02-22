# ./vas hello.s
# ld -o hello hello.o
# ./hello
# > Hello, world!

.global _start

.data
msg:
	.string "Hello, world!"

.text
_start:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq $1, %rax
	movq $1, %rdi
	leaq msg(%rip), %rsi
	movq $13, %rdx
	syscall

	movq $60, %rax
	movq $0, %rdi
	syscall

