	.text
	.file	"structs.c"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function make
.LCPI0_0:
	.quad	0x4008000000000000              # double 3
	.text
	.globl	make
	.p2align	4, 0x90
	.type	make,@function
make:                                   # @make
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax
	movl	%esi, -4(%rbp)
	movl	-4(%rbp), %ecx
	movl	%ecx, (%rdi)
	movl	-4(%rbp), %ecx
	shll	%ecx
	movslq	%ecx, %rcx
	movq	%rcx, 8(%rdi)
	cvtsi2sdl	-4(%rbp), %xmm0
	movsd	.LCPI0_0(%rip), %xmm1           # xmm1 = [3.0E+0,0.0E+0]
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, 16(%rdi)
	popq	%rbp
	retq
.Lfunc_end0:
	.size	make, .Lfunc_end0-make
                                        # -- End function
	.ident	"Apple clang version 17.0.0 (clang-1700.6.4.2)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
