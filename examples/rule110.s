# ../vas -o rule110.o rule110.s && gcc -o rule110.out rule110.o && ./rule110.out

.global	board
.bss
board:
	.zero 120

.data
.LC0:
	.string	" *"

.text
.global	main
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	$1, 112+board(%rip)
	movq	$0, -8(%rbp)
	jmp     .L2
.L7:
	movq	$0, -16(%rbp)
	jmp     .L3
.L4:
	movq	stdout(%rip), %rdx
	movq	-16(%rbp), %rax
	leaq	0(,%rax,4), %rcx
	leaq	board(%rip), %rax
	movl	(%rcx,%rax), %eax
	cltq
	leaq	.LC0(%rip), %rcx
	movzbl	(%rax,%rcx), %eax
	movsbl	%al, %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	fputc
	addq	$1, -16(%rbp)
.L3:
	cmpq	$29, -16(%rbp)
	jbe     .L4
	movq	stdout(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc
	movl	board(%rip), %eax
	leal	(%rax,%rax), %edx
	movl	4+board(%rip), %eax
	orl     %edx, %eax
	movl	%eax, -20(%rbp)
	movq	$1, -32(%rbp)
	jmp     .L5
.L6:
	movl	-20(%rbp), %eax
	addl	%eax, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movq	-32(%rbp), %rax
	addq	$1, %rax
	leaq	0(,%rax,4), %rdx
	leaq	board(%rip), %rax
	movl	(%rdx,%rax), %eax
	orl     %ecx, %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	$110, %edx
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	movl	%eax, %ecx
	movq	-32(%rbp), %rax
	leaq	0(,%rax,4), %rdx
	leaq	board(%rip), %rax
	movl	%ecx, (%rdx,%rax)
	addq	$1, -32(%rbp)
.L5:
	cmpq	$28, -32(%rbp)
	jbe     .L6
	addq	$1, -8(%rbp)
.L2:
	cmpq	$27, -8(%rbp)
	jbe     .L7
	movl	$0, %eax
	leave
	ret
.LFE0:

.section	.note.GNU-stack,""

