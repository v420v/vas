	.text
	.file	"cxx.cc"
	.globl	_Z1gP1A                         # -- Begin function _Z1gP1A
	.p2align	4, 0x90
	.type	_Z1gP1A,@function
_Z1gP1A:                                # @_Z1gP1A
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rdi
	movq	(%rdi), %rax
	callq	*(%rax)
	addq	$16, %rsp
	popq	%rbp
	retq
.Lfunc_end0:
	.size	_Z1gP1A, .Lfunc_end0-_Z1gP1A
                                        # -- End function
	.globl	_Z4makev                        # -- Begin function _Z4makev
	.p2align	4, 0x90
	.type	_Z4makev,@function
_Z4makev:                               # @_Z4makev
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)                 # 8-byte Spill
	movq	%rdi, %rax
	movq	%rax, -16(%rbp)                 # 8-byte Spill
	movq	%rdi, -8(%rbp)
	xorl	%esi, %esi
	movl	$8, %edx
	callq	memset@PLT
	movq	-24(%rbp), %rdi                 # 8-byte Reload
	callq	_ZN1AC2Ev
	movq	-16(%rbp), %rax                 # 8-byte Reload
	addq	$32, %rsp
	popq	%rbp
	retq
.Lfunc_end1:
	.size	_Z4makev, .Lfunc_end1-_Z4makev
                                        # -- End function
	.section	.text._ZN1AC2Ev,"axG",@progbits,_ZN1AC2Ev,comdat
	.weak	_ZN1AC2Ev                       # -- Begin function _ZN1AC2Ev
	.p2align	4, 0x90
	.type	_ZN1AC2Ev,@function
_ZN1AC2Ev:                              # @_ZN1AC2Ev
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	_ZTV1A(%rip), %rcx
	addq	$16, %rcx
	movq	%rcx, (%rax)
	popq	%rbp
	retq
.Lfunc_end2:
	.size	_ZN1AC2Ev, .Lfunc_end2-_ZN1AC2Ev
                                        # -- End function
	.section	.text._ZN1A1fEv,"axG",@progbits,_ZN1A1fEv,comdat
	.weak	_ZN1A1fEv                       # -- Begin function _ZN1A1fEv
	.p2align	4, 0x90
	.type	_ZN1A1fEv,@function
_ZN1A1fEv:                              # @_ZN1A1fEv
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	$1, %eax
	popq	%rbp
	retq
.Lfunc_end3:
	.size	_ZN1A1fEv, .Lfunc_end3-_ZN1A1fEv
                                        # -- End function
	.type	_ZTV1A,@object                  # @_ZTV1A
	.section	.data.rel.ro._ZTV1A,"awG",@progbits,_ZTV1A,comdat
	.weak	_ZTV1A
	.p2align	3, 0x0
_ZTV1A:
	.quad	0
	.quad	0
	.quad	_ZN1A1fEv
	.size	_ZTV1A, 24

	.ident	"Apple clang version 17.0.0 (clang-1700.6.4.2)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
