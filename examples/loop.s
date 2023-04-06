# ../vas -o loop.o loop.s && gcc -o loop.out loop.o && ./loop.out
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

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	# int a = 0
	movq $0, 0-4(%rbp)

loop_main:
	# a == 5 -> jmp loop_end
	cmpq $5, 0-4(%rbp)
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
	addq $1, 0-4(%rbp)

	# jmp loop_main
	jmp loop_main

loop_end:
	movq $0, %rdi
	callq exit

.section .note.GNU-stack, ""

.section .data, "wa"
msg3:
    .string "message 3"

