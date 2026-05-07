	.text
	.file	"sum.c"
	.globl	sum                             # -- Begin function sum
	.p2align	4, 0x90
	.type	sum,@function
sum:                                    # @sum
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	$0, -8(%rbp)
	movl	$1, -12(%rbp)
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	movl	-12(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jg	.LBB0_4
# %bb.2:                                #   in Loop: Header=BB0_1 Depth=1
	movl	-12(%rbp), %eax
	addl	-8(%rbp), %eax
	movl	%eax, -8(%rbp)
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
	movl	-12(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -12(%rbp)
	jmp	.LBB0_1
.LBB0_4:
	movl	-8(%rbp), %eax
	popq	%rbp
	retq
.Lfunc_end0:
	.size	sum, .Lfunc_end0-sum
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	movl	$10, %edi
	callq	sum
	addq	$16, %rsp
	popq	%rbp
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.ident	"Apple clang version 17.0.0 (clang-1700.6.4.2)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym sum
