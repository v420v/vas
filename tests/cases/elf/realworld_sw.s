	.text
	.file	"sw.c"
	.globl	classify                        # -- Begin function classify
	.p2align	4, 0x90
	.type	classify,@function
classify:                               # @classify
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -8(%rbp)
	movl	-8(%rbp), %eax
	decl	%eax
	movl	%eax, %ecx
	movq	%rcx, -16(%rbp)                 # 8-byte Spill
	subl	$4, %eax
	ja	.LBB0_6
# %bb.8:
	movq	-16(%rbp), %rax                 # 8-byte Reload
	leaq	.LJTI0_0(%rip), %rcx
	movslq	(%rcx,%rax,4), %rax
	addq	%rcx, %rax
	jmpq	*%rax
.LBB0_1:
	movl	$100, -4(%rbp)
	jmp	.LBB0_7
.LBB0_2:
	movl	$200, -4(%rbp)
	jmp	.LBB0_7
.LBB0_3:
	movl	$300, -4(%rbp)                  # imm = 0x12C
	jmp	.LBB0_7
.LBB0_4:
	movl	$400, -4(%rbp)                  # imm = 0x190
	jmp	.LBB0_7
.LBB0_5:
	movl	$500, -4(%rbp)                  # imm = 0x1F4
	jmp	.LBB0_7
.LBB0_6:
	movl	$0, -4(%rbp)
.LBB0_7:
	movl	-4(%rbp), %eax
	popq	%rbp
	retq
.Lfunc_end0:
	.size	classify, .Lfunc_end0-classify
	.section	.rodata,"a",@progbits
	.p2align	2, 0x0
.LJTI0_0:
	.long	.LBB0_1-.LJTI0_0
	.long	.LBB0_2-.LJTI0_0
	.long	.LBB0_3-.LJTI0_0
	.long	.LBB0_4-.LJTI0_0
	.long	.LBB0_5-.LJTI0_0
                                        # -- End function
	.ident	"Apple clang version 17.0.0 (clang-1700.6.4.2)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
