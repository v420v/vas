# Hello world!

.global _start

.section .data, "wa"
msg:
	.string "Hello, world!\n"

.section .text, "ax"
_start:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq $1, %rax
	movq $1, %rdi
	leaq msg(%rip), %rsi
	movq $14, %rdx
	syscall

	movq $60, %rax
	movq $0, %rdi
	syscall

