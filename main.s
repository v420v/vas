# Hello world!

.global _start

.data
msg:
	.string "Hello, world!\n"

.text
_start:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq $1, %rax
	movq $1, %rdi
	movq $msg, %rsi
	movq $14, %rdx
	syscall

	movq $60, %rax
	movq $0, %rdi
	syscall

