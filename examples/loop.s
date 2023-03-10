# ./vas -o hello.o hello.s
# gcc -o hello hello.o
# ./hello
# message 1
# message 2
# message 3
# -------------------
# message 1
# message 2
# message 3
# -------------------
# message 1
# message 2
# message 3
# -------------------
# message 1
# message 2
# message 3
# -------------------
# message 1
# message 2
# message 3
# -------------------

.global main

.global msg1

.global .data

.section .data, "wa"
msg1:
	.string "message 1"
msg2:
    .string "message 2"
line:
	.string "-------------------"

.section .text, "ax"
foo:
    retq

.section .text, "ax"
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	# int a = 0
	movq $0, %rax
	movq %rax, 0-4(%rbp)

loop_main:
	movq 0-4(%rbp), %rdi
	movq $5, %rax

	# a == 5 -> jmp loop_end
	cmpq %rdi, %rax
	je loop_end

	leaq msg1(%rip), %rdi
    callq puts

	leaq msg2(%rip), %rdi
    callq puts

	leaq msg3(%rip), %rdi
    callq puts

	leaq line(%rip), %rdi
    callq puts

	# a = a + 1
	movq 0-4(%rbp), %rax
	addq $1, %rax
	movq %rax, 0-4(%rbp)

	# jmp loop_main
	jmp loop_main

loop_end:
	movq $0, %rdi
	callq exit

.section .note.GNU-stack, ""

.section .data, "wa"
msg3:
    .string "message 3"

