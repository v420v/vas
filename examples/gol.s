	.text
	.section .rodata, "a"
.LC0:
	.string	"\033[H"
.LC1:
	.string	"\033[07m  \033[m"
.LC2:
	.string	"  "
.LC3:
	.string	"\033[E"
	.text
	.global	show
show:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, -60(%rbp)
	movl	%edx, -64(%rbp)
	movl	-60(%rbp), %ebx
	movslq	%ebx, %rax
	subq	$1, %rax
	movq	%rax, -32(%rbp)
	movslq	%ebx, %rax
	movq	%rax, %r8
	movl	$0, %r9d
	movq	-56(%rbp), %rax
	movq	%rax, -40(%rbp)
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$0, -20(%rbp)
	jmp	.L2
.L7:
	movl	$0, -24(%rbp)
	jmp	.L3
.L6:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movslq	%ebx, %rax
	imulq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-24(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %eax
	testl	%eax, %eax
	je	.L4
	leaq	.LC1(%rip), %rax
	jmp	.L5
.L4:
	leaq	.LC2(%rip), %rax
.L5:
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	addl	$1, -24(%rbp)
.L3:
	movl	-24(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jl	.L6
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	addl	$1, -20(%rbp)
.L2:
	movl	-20(%rbp), %eax
	cmpl	-64(%rbp), %eax
	jl	.L7
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.global	evolve
evolve:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$152, %rsp
	movq	%rdi, -136(%rbp)
	movl	%esi, -140(%rbp)
	movl	%edx, -144(%rbp)
	movq	%rsp, %rax
	movq	%rax, -184(%rbp)
	movl	-140(%rbp), %r9d
	movslq	%r9d, %rax
	subq	$1, %rax
	movq	%rax, -88(%rbp)
	movslq	%r9d, %rax
	movq	%rax, %rcx
	movl	$0, %ebx
	movq	-136(%rbp), %rax
	movq	%rax, -96(%rbp)
	movl	-140(%rbp), %edi
	movl	-144(%rbp), %r8d
	movslq	%edi, %rax
	subq	$1, %rax
	movq	%rax, -104(%rbp)
	movslq	%edi, %rax
	movq	%rax, -176(%rbp)
	movq	$0, -168(%rbp)
	movslq	%edi, %rax
	leaq	0(,%rax,4), %rcx
	movslq	%r8d, %rax
	subq	$1, %rax
	movq	%rax, -112(%rbp)
	movslq	%edi, %rax
	movq	%rax, -160(%rbp)
	movq	$0, -152(%rbp)
	movslq	%r8d, %rax
	movq	%rax, %r14
	movl	$0, %r15d
	movq	-160(%rbp), %rbx
	movq	-152(%rbp), %rsi
	movq	%rsi, %rdx
	imulq	%r14, %rdx
	movq	%rbx, -160(%rbp)
	movq	%rsi, -152(%rbp)
	movq	%rbx, %rax
	imulq	%r15, %rax
	leaq	(%rdx,%rax), %rsi
	movq	-160(%rbp), %rax
	mulq	%r14
	addq	%rdx, %rsi
	movq	%rsi, %rdx
	movslq	%edi, %rax
	movq	%rax, %r12
	movl	$0, %r13d
	movslq	%r8d, %rax
	movq	%rax, %r10
	movl	$0, %r11d
	movq	%r13, %rdx
	imulq	%r10, %rdx
	movq	%r11, %rax
	imulq	%r12, %rax
	leaq	(%rdx,%rax), %rsi
	movq	%r12, %rax
	mulq	%r10
	addq	%rdx, %rsi
	movq	%rsi, %rdx
	movslq	%edi, %rdx
	movslq	%r8d, %rax
	imulq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %ebx
	movl	$0, %edx
	divq	%rbx
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$3, %rax
	shrq	$2, %rax
	salq	$2, %rax
	movq	%rax, -120(%rbp)
	movl	$0, -52(%rbp)
	jmp	.L9
.L21:
	movl	$0, -56(%rbp)
	jmp	.L10
.L20:
	movl	$0, -60(%rbp)
	movl	-52(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -64(%rbp)
	jmp	.L11
.L15:
	movl	-56(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -68(%rbp)
	jmp	.L12
.L14:
	movl	-64(%rbp), %edx
	movl	-144(%rbp), %eax
	addl	%edx, %eax
	cltd
	idivl	-144(%rbp)
	movl	%edx, %eax
	movslq	%eax, %rdx
	movslq	%r9d, %rax
	imulq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-96(%rbp), %rax
	leaq	(%rdx,%rax), %rsi
	movl	-68(%rbp), %edx
	movl	-140(%rbp), %eax
	addl	%edx, %eax
	cltd
	idivl	-140(%rbp)
	movl	%edx, %eax
	cltq
	movl	(%rsi,%rax,4), %eax
	testl	%eax, %eax
	je	.L13
	addl	$1, -60(%rbp)
.L13:
	addl	$1, -68(%rbp)
.L12:
	movl	-56(%rbp), %eax
	addl	$1, %eax
	cmpl	%eax, -68(%rbp)
	jle	.L14
	addl	$1, -64(%rbp)
.L11:
	movl	-52(%rbp), %eax
	addl	$1, %eax
	cmpl	%eax, -64(%rbp)
	jle	.L15
	movl	-52(%rbp), %eax
	movslq	%eax, %rdx
	movslq	%r9d, %rax
	imulq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-96(%rbp), %rax
	addq	%rax, %rdx
	movl	-56(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %eax
	testl	%eax, %eax
	je	.L16
	subl	$1, -60(%rbp)
.L16:
	cmpl	$3, -60(%rbp)
	je	.L17
	cmpl	$2, -60(%rbp)
	jne	.L18
	movl	-52(%rbp), %eax
	movslq	%eax, %rdx
	movslq	%r9d, %rax
	imulq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-96(%rbp), %rax
	addq	%rax, %rdx
	movl	-56(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %eax
	testl	%eax, %eax
	je	.L18
.L17:
	movl	$1, %eax
	jmp	.L19
.L18:
	movl	$0, %eax
.L19:
	movq	%rcx, %rdi
	shrq	$2, %rdi
	movl	%eax, %r8d
	movq	-120(%rbp), %rax
	movl	-56(%rbp), %edx
	movslq	%edx, %rsi
	movl	-52(%rbp), %edx
	movslq	%edx, %rdx
	imulq	%rdi, %rdx
	addq	%rsi, %rdx
	movl	%r8d, (%rax,%rdx,4)
	addl	$1, -56(%rbp)
.L10:
	movl	-56(%rbp), %eax
	cmpl	-140(%rbp), %eax
	jl	.L20
	addl	$1, -52(%rbp)
.L9:
	movl	-52(%rbp), %eax
	cmpl	-144(%rbp), %eax
	jl	.L21
	movl	$0, -72(%rbp)
	jmp	.L22
.L25:
	movl	$0, -76(%rbp)
	jmp	.L23
.L24:
	movq	%rcx, %r8
	shrq	$2, %r8
	movl	-72(%rbp), %eax
	movslq	%eax, %rdx
	movslq	%r9d, %rax
	imulq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-96(%rbp), %rax
	leaq	(%rdx,%rax), %rsi
	movq	-120(%rbp), %rax
	movl	-76(%rbp), %edx
	movslq	%edx, %rdi
	movl	-72(%rbp), %edx
	movslq	%edx, %rdx
	imulq	%r8, %rdx
	addq	%rdi, %rdx
	movl	(%rax,%rdx,4), %edx
	movl	-76(%rbp), %eax
	cltq
	movl	%edx, (%rsi,%rax,4)
	addl	$1, -76(%rbp)
.L23:
	movl	-76(%rbp), %eax
	cmpl	-140(%rbp), %eax
	jl	.L24
	addl	$1, -72(%rbp)
.L22:
	movl	-72(%rbp), %eax
	cmpl	-144(%rbp), %eax
	jl	.L25
	movq	-184(%rbp), %rsp
	nop
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.global	game
game:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$56, %rsp
	movl	%edi, -84(%rbp)
	movl	%esi, -88(%rbp)
	movl	-84(%rbp), %esi
	movl	-88(%rbp), %edi
	movslq	%esi, %r12
	subq	$1, %r12
	movq	%r12, -64(%rbp)
	movslq	%esi, %r12
	movq	%r12, %r14
	movl	$0, %r15d
	movslq	%esi, %r12
	leaq	0(,%r12,4), %r14
	movslq	%edi, %r12
	subq	$1, %r12
	movq	%r12, -72(%rbp)
	movslq	%esi, %r12
	movq	%r12, %r10
	movl	$0, %r11d
	movslq	%edi, %r12
	movq	%r12, %rax
	movl	$0, %edx
	movq	%r11, %r13
	imulq	%rax, %r13
	movq	%rdx, %r12
	imulq	%r10, %r12
	addq	%r13, %r12
	mulq	%r10
	leaq	(%r12,%rdx), %r10
	movq	%r10, %rdx
	movslq	%esi, %rax
	movq	%rax, %r8
	movl	$0, %r9d
	movslq	%edi, %rax
	movq	%rax, %rcx
	movl	$0, %ebx
	movq	%r9, %rdx
	imulq	%rcx, %rdx
	movq	%rbx, %rax
	imulq	%r8, %rax
	leaq	(%rdx,%rax), %r10
	movq	%r8, %rax
	mulq	%rcx
	leaq	(%r10,%rdx), %rcx
	movq	%rcx, %rdx
	movslq	%esi, %rdx
	movslq	%edi, %rax
	imulq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %ebx
	movl	$0, %edx
	divq	%rbx
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$3, %rax
	shrq	$2, %rax
	salq	$2, %rax
	movq	%rax, -80(%rbp)
	movl	$0, -52(%rbp)
	jmp	.L27
.L30:
	movl	$0, -56(%rbp)
	jmp	.L28
.L29:
	call	rand
	cmpl	$214748363, %eax
	setle	%al
	movq	%r14, %rdi
	shrq	$2, %rdi
	movzbl	%al, %edx
	movq	-80(%rbp), %rax
	movl	-52(%rbp), %ecx
	movslq	%ecx, %rsi
	movl	-56(%rbp), %ecx
	movslq	%ecx, %rcx
	imulq	%rdi, %rcx
	addq	%rsi, %rcx
	movl	%edx, (%rax,%rcx,4)
	addl	$1, -56(%rbp)
.L28:
	movl	-56(%rbp), %eax
	cmpl	-88(%rbp), %eax
	jl	.L29
	addl	$1, -52(%rbp)
.L27:
	movl	-52(%rbp), %eax
	cmpl	-84(%rbp), %eax
	jl	.L30
.L31:
	movl	-88(%rbp), %edx
	movl	-84(%rbp), %ecx
	movq	-80(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	show
	movl	-88(%rbp), %edx
	movl	-84(%rbp), %ecx
	movq	-80(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	evolve
	movl	$200000, %edi
	call	usleep
	jmp	.L31
	.global	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	cmpl	$1, -20(%rbp)
	jle	.L33
	movq	-32(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -4(%rbp)
.L33:
	cmpl	$2, -20(%rbp)
	jle	.L34
	movq	-32(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -8(%rbp)
.L34:
	cmpl	$0, -4(%rbp)
	jg	.L35
	movl	$30, -4(%rbp)
.L35:
	cmpl	$0, -8(%rbp)
	jg	.L36
	movl	$30, -8(%rbp)
.L36:
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	game
	movl	$0, %eax
	leave
	ret

.section	.note.GNU-stack,""

