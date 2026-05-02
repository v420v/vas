	.text
	.file	"tls.c"
	.globl	bump                            # -- Begin function bump
	.p2align	4, 0x90
	.type	bump,@function
bump:                                   # @bump
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%fs:0, %rax
	leaq	counter@TPOFF(%rax), %rcx
	movl	(%rcx), %eax
	addl	$1, %eax
	movl	%eax, (%rcx)
	popq	%rbp
	retq
.Lfunc_end0:
	.size	bump, .Lfunc_end0-bump
                                        # -- End function
	.type	counter,@object                 # @counter
	.section	.tbss,"awT",@nobits
	.globl	counter
	.p2align	2, 0x0
counter:
	.long	0                               # 0x0
	.size	counter, 4

	.ident	"Apple clang version 17.0.0 (clang-1700.6.4.2)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
