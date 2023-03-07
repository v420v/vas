# ./vas -o loop.o loop.s
# ld -o loop loop.o
# ./loop
# > Hello Hello Hello Hello Hello

.global _start

.section .data, "wa"
msg:
	.string "Hello "

.section .text, "ax"
_start:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	# int a = 0
	movq $0, %rax
	movq %rax, 0-4(%rbp)

loop_start:
	movq 0-4(%rbp), %rdi
	movq $5, %rax

	# a == 5 -> jmp loop_end
	cmp %rdi, %rax
	je loop_end

	# print msg
	movq $1, %rax
	movq $1, %rdi
	leaq msg(%rip), %rsi
	movq $7, %rdx
	syscall

	# a = a + 1
	movq 0-4(%rbp), %rax
	addq $1, %rax
	movq %rax, 0-4(%rbp)

	# jmp loop_start
	jmp loop_start

loop_end:
	movq $60, %rax
	movq $0, %rdi
	syscall

