# ./vas mem_ref.s
# ld -o mem_ref mem_ref.o
# ./mem_ref
# > world!

.global _start

.data
msg:
	.string "Hello, world!"

.text
_start:
	pushq %rbp
	movq %rsp, %rbp
	subq $16 + 1, %rsp

	# print "world!"
	movq $1, %rax
	movq $1, %rdi
	leaq msg+7(%rip), %rsi
	movq $7, %rdx
	syscall

	movq $60, %rax
	movq $0, %rdi
	syscall

