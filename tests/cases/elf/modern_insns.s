	.text
	.globl	modern
	.type	modern, @function
modern:
	# MOVQ between XMM and GPR (66 REX.W 0F 6E/7E) vs xmm/mem (F3 0F 7E / 66 0F D6)
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	movq	%xmm1, (%rdi)
	movq	(%rsi), %xmm2
	movq	%xmm3, %xmm4
	# condition-code mnemonics without a size suffix
	cmovne	%rdx, %rax
	cmovl	%eax, %ecx
	cmove	(%rsi), %rdi
	# R12/R13 base addressing (RBP/RSP encoding quirks via low 3 bits)
	movq	(%r13), %rax
	movq	(%r12), %rbx
	movq	(%r13,%rcx,8), %rdx
	movl	(%r12d,%ebx,4), %eax
	# lock-prefixed atomics + rip-relative (relocation offset must clear the prefix)
	lock	addq	$1, count(%rip)
	lock	cmpxchgl %eax, (%rdx)
	lock	xaddq	%rbx, (%rcx)
	xchgl	%eax, (%rdx)
	# string instructions with rep/repz/repnz prefixes
	rep	movsq
	rep	stosl
	rep	movsb
	repz	cmpsb
	repnz	scasb
	# packed / scalar SSE arithmetic
	addpd	%xmm1, %xmm0
	mulps	%xmm2, %xmm3
	subsd	%xmm4, %xmm5
	maxpd	(%rdi), %xmm6
	sqrtsd	%xmm7, %xmm8
	cvtdq2pd %xmm0, %xmm1
	ret
	.bss
	.local	count
	.comm	count,8,8
