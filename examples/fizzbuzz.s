# Fizz Buzz
# ../vas -o fizzbuzz.o fizzbuzz.s && gcc -o fizzbuzz.out fizzbuzz.o && ./fizzbuzz.out

.global main

.section .data, "wa"
fizz:
	.string "fizz\n"
buzz:
	.string "buzz\n"
fizzbuzz:
	.string "Fizz Buzz\n"
fmt:
	.string "%d\n"

.section .text, "ax"
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	# int a = 1
	movq $1, -4(%rbp)

loop_start:
	cmpq $101, -4(%rbp)
	je loop_end

	# check if it's multiple of 15
	movq -4(%rbp), %rax
	movq $15, %rbx
	cqto
	idivq %rbx

	movq $0, %rax
	cmpq %rdx, %rax
	jne .L1

	# print fizz buzz
	leaq fizzbuzz(%rip), %rdi
	call printf
	jmp .L2

.L1:
	# check if it's multiple of 3
	movq -4(%rbp), %rax
	movq $3, %rbx
	cqto
	idivq %rbx
	movq $0, %rax
	cmpq %rdx, %rax
	jne .L3
	leaq fizz(%rip), %rdi
	call printf
	jmp .L2

.L3:
	# check if it's multiple of 5
	movq -4(%rbp), %rax
	movq $5, %rbx
	cqto
	idivq %rbx
	movq $0, %rax
	cmpq %rdx, %rax
	jne .L4
	leaq buzz(%rip), %rdi
	call printf
	jmp .L2
.L4:
	# print number
	leaq fmt(%rip), %rdi
	movq -4(%rbp), %rsi
	callq printf

.L2:
	# increment
	movq -4(%rbp), %rax
	addq $1, %rax
	movq %rax, -4(%rbp)
	jmp loop_start

loop_end:
	movq $0, %rdi
	callq exit

.section .note.GNU-stack, ""

