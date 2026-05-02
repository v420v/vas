	.text
	.file	"goto.c"
	.globl	dispatch                        # -- Begin function dispatch
	.p2align	4, 0x90
	.type	dispatch,@function
dispatch:                               # @dispatch
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -8(%rbp)
	movq	.L__const.dispatch.table(%rip), %rax
	movq	%rax, -32(%rbp)
	movq	.L__const.dispatch.table+8(%rip), %rax
	movq	%rax, -24(%rbp)
	movq	.L__const.dispatch.table+16(%rip), %rax
	movq	%rax, -16(%rbp)
	cmpl	$0, -8(%rbp)
	jl	.LBB0_2
# %bb.1:
	cmpl	$2, -8(%rbp)
	jle	.LBB0_3
.LBB0_2:
	movl	$0, -4(%rbp)
	jmp	.LBB0_7
.LBB0_3:
	movslq	-8(%rbp), %rax
	movq	-32(%rbp,%rax,8), %rax
	movq	%rax, -40(%rbp)                 # 8-byte Spill
	jmp	.LBB0_8
.Ltmp0:                                 # Block address taken
.LBB0_4:
	movl	$1, -4(%rbp)
	jmp	.LBB0_7
.Ltmp1:                                 # Block address taken
.LBB0_5:
	movl	$2, -4(%rbp)
	jmp	.LBB0_7
.Ltmp2:                                 # Block address taken
.LBB0_6:
	movl	$3, -4(%rbp)
.LBB0_7:
	movl	-4(%rbp), %eax
	popq	%rbp
	retq
.LBB0_8:
	movq	-40(%rbp), %rax                 # 8-byte Reload
	jmpq	*%rax
.Lfunc_end0:
	.size	dispatch, .Lfunc_end0-dispatch
                                        # -- End function
	.type	.L__const.dispatch.table,@object # @__const.dispatch.table
	.section	.data.rel.ro,"aw",@progbits
	.p2align	4, 0x0
.L__const.dispatch.table:
	.quad	.Ltmp0
	.quad	.Ltmp1
	.quad	.Ltmp2
	.size	.L__const.dispatch.table, 24

	.ident	"Apple clang version 17.0.0 (clang-1700.6.4.2)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym dispatch
