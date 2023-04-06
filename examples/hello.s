# ../vas hello.s && ld -o hello.out hello.o && ./hello.out
# > Hello, world!

.global _start

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

.section .data, "wa"
msg:
	.string "Hello, world!\n"

