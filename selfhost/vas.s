	.text
_us32_ge:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	cmpl	$2147483646, -4(%rbp)
	ja	.L2
	movl	-4(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jg	.L3
.L2:
	movl	$1, %eax
	jmp	.L4
.L3:
	movl	$0, %eax
.L4:
	popq	%rbp
	ret
_us32_eq:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	-4(%rbp), %eax
	testl	%eax, %eax
	js	.L7
	movl	-4(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jne	.L7
	movl	$1, %eax
	jmp	.L8
.L7:
	movl	$0, %eax
.L8:
	popq	%rbp
	ret
_us32_lt:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	cmpl	$2147483646, -4(%rbp)
	ja	.L11
	movl	-4(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jle	.L11
	movl	$1, %eax
	jmp	.L12
.L11:
	movl	$0, %eax
.L12:
	popq	%rbp
	ret
_wymum:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-24(%rbp), %rcx
	movq	(%rcx), %rcx
	movq	%rcx, -16(%rbp)
	movq	$0, -8(%rbp)
	movq	-32(%rbp), %rcx
	movq	(%rcx), %rcx
	movq	%rcx, %rax
	movl	$0, %edx
	movq	-8(%rbp), %rcx
	movq	%rcx, %rsi
	imulq	%rax, %rsi
	movq	-16(%rbp), %rcx
	imulq	%rdx, %rcx
	addq	%rsi, %rcx
	mulq	-16(%rbp)
	addq	%rdx, %rcx
	movq	%rcx, %rdx
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rax
	xorl	%edx, %edx
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	ret
_wymix:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	-16(%rbp), %rdx
	leaq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	_wymum
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax
	xorq	%rdx, %rax
	leave
	ret
_wyr8:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rcx
	leaq	-8(%rbp), %rax
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-8(%rbp), %rax
	leave
	ret
_wyr4:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rcx
	leaq	-4(%rbp), %rax
	movl	$4, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movl	-4(%rbp), %eax
	movl	%eax, %eax
	leave
	ret
_wyr3:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	salq	$16, %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	shrq	%rax
	movq	%rax, %rcx
	movq	-8(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	salq	$8, %rax
	orq	%rax, %rdx
	movq	-16(%rbp), %rax
	leaq	-1(%rax), %rcx
	movq	-8(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	orq	%rdx, %rax
	popq	%rbp
	ret
wyhash:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$88, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%rdx, -88(%rbp)
	movq	%rcx, -96(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	xorq	%rax, -88(%rbp)
	cmpq	$16, -80(%rbp)
	setbe	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	je	.L24
	cmpq	$3, -80(%rbp)
	seta	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	je	.L25
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	_wyr4
	salq	$32, %rax
	movq	%rax, %rbx
	movq	-80(%rbp), %rax
	shrq	$3, %rax
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	_wyr4
	orq	%rbx, %rax
	movq	%rax, -32(%rbp)
	movq	-80(%rbp), %rax
	leaq	-4(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	_wyr4
	salq	$32, %rax
	movq	%rax, %rbx
	movq	-80(%rbp), %rax
	shrq	$3, %rax
	salq	$2, %rax
	movq	-80(%rbp), %rdx
	subq	%rax, %rdx
	subq	$4, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	_wyr4
	orq	%rbx, %rax
	movq	%rax, -40(%rbp)
	jmp	.L26
.L25:
	cmpq	$0, -80(%rbp)
	setne	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	je	.L27
	movq	-80(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	_wyr3
	movq	%rax, -32(%rbp)
	movq	$0, -40(%rbp)
	jmp	.L26
.L27:
	movq	$0, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -32(%rbp)
	jmp	.L26
.L24:
	movq	-80(%rbp), %rax
	movq	%rax, -48(%rbp)
	cmpq	$48, -48(%rbp)
	seta	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	je	.L30
	movq	-88(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, -64(%rbp)
.L29:
	movq	-24(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	_wyr8
	xorq	-88(%rbp), %rax
	movq	%rax, %rbx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	_wyr8
	movq	-96(%rbp), %rdx
	addq	$8, %rdx
	movq	(%rdx), %rdx
	xorq	%rdx, %rax
	movq	%rbx, %rsi
	movq	%rax, %rdi
	call	_wymix
	movq	%rax, -88(%rbp)
	movq	-24(%rbp), %rax
	addq	$24, %rax
	movq	%rax, %rdi
	call	_wyr8
	xorq	-56(%rbp), %rax
	movq	%rax, %rbx
	movq	-24(%rbp), %rax
	addq	$16, %rax
	movq	%rax, %rdi
	call	_wyr8
	movq	-96(%rbp), %rdx
	addq	$16, %rdx
	movq	(%rdx), %rdx
	xorq	%rdx, %rax
	movq	%rbx, %rsi
	movq	%rax, %rdi
	call	_wymix
	movq	%rax, -56(%rbp)
	movq	-24(%rbp), %rax
	addq	$40, %rax
	movq	%rax, %rdi
	call	_wyr8
	xorq	-64(%rbp), %rax
	movq	%rax, %rbx
	movq	-24(%rbp), %rax
	addq	$32, %rax
	movq	%rax, %rdi
	call	_wyr8
	movq	-96(%rbp), %rdx
	addq	$24, %rdx
	movq	(%rdx), %rdx
	xorq	%rdx, %rax
	movq	%rbx, %rsi
	movq	%rax, %rdi
	call	_wymix
	movq	%rax, -64(%rbp)
	addq	$48, -24(%rbp)
	subq	$48, -48(%rbp)
	cmpq	$48, -48(%rbp)
	seta	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	jne	.L29
	movq	-56(%rbp), %rax
	xorq	-64(%rbp), %rax
	xorq	%rax, -88(%rbp)
	jmp	.L30
.L31:
	movq	-24(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	_wyr8
	xorq	-88(%rbp), %rax
	movq	%rax, %rbx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	_wyr8
	movq	-96(%rbp), %rdx
	addq	$8, %rdx
	movq	(%rdx), %rdx
	xorq	%rdx, %rax
	movq	%rbx, %rsi
	movq	%rax, %rdi
	call	_wymix
	movq	%rax, -88(%rbp)
	subq	$16, -48(%rbp)
	addq	$16, -24(%rbp)
.L30:
	cmpq	$16, -48(%rbp)
	seta	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	jne	.L31
	movq	-48(%rbp), %rax
	leaq	-16(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	_wyr8
	movq	%rax, -32(%rbp)
	movq	-48(%rbp), %rax
	leaq	-8(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	_wyr8
	movq	%rax, -40(%rbp)
.L26:
	movq	-40(%rbp), %rax
	xorq	-88(%rbp), %rax
	movq	%rax, %rdx
	movq	-96(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	xorq	-32(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	_wymix
	movq	%rax, %rdx
	movq	-96(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	xorq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	_wymix
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
_wyp:
	.quad	-6884282663029611473
	.quad	-1800455987208640293
	.quad	-8161530843051276573
	.quad	6384245875588680899
	.text
wyhash64:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movabsq	$-6884282663029611473, %rdx
	xorq	%rdx, %rax
	movq	%rax, -8(%rbp)
	movq	-16(%rbp), %rax
	movabsq	$-1800455987208640293, %rdx
	xorq	%rdx, %rax
	movq	%rax, -16(%rbp)
	leaq	-16(%rbp), %rdx
	leaq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	_wymum
	movq	-16(%rbp), %rax
	movabsq	$-1800455987208640293, %rdx
	xorq	%rax, %rdx
	movq	-8(%rbp), %rax
	movabsq	$-6884282663029611473, %rcx
	xorq	%rcx, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	_wymix
	leave
	ret
	.globl	_const_strconv__digit_pairs
	.bss
_const_strconv__digit_pairs:
	.zero	16
	.globl	_const_strconv__base_digits
_const_strconv__base_digits:
	.zero	16
	.globl	_const_digit_pairs
_const_digit_pairs:
	.zero	16
	.globl	_const_flag__space
_const_flag__space:
	.zero	16
	.globl	_const_flag__underline
_const_flag__underline:
	.zero	16
	.globl	_const_os__empty_str
_const_os__empty_str:
	.zero	16
	.globl	_const_os__dot_str
_const_os__dot_str:
	.zero	16
	.globl	_const_os__path_separator
_const_os__path_separator:
	.zero	16
	.globl	_const_math__bits__de_bruijn64
	.section	.rodata, "a"
_const_math__bits__de_bruijn64:
	.quad	285870213051353865
	.globl	_const_math__bits__de_bruijn64tab
	.bss
_const_math__bits__de_bruijn64tab:
	.zero	32
	.globl	_const_math__bits__two32
	.section	.rodata, "a"
_const_math__bits__two32:
	.quad	4294967296
	.globl	_const_math__bits__mask32
_const_math__bits__mask32:
	.quad	4294967295
	.globl	_const_strconv__single_plus_zero
_const_strconv__single_plus_zero:
	.zero	4
	.globl	_const_strconv__single_minus_zero
_const_strconv__single_minus_zero:
	.long	-2147483648
	.globl	_const_strconv__single_plus_infinity
_const_strconv__single_plus_infinity:
	.long	2139095040
	.globl	_const_strconv__single_minus_infinity
_const_strconv__single_minus_infinity:
	.long	-8388608
	.globl	_const_strconv__double_plus_zero
_const_strconv__double_plus_zero:
	.zero	8
	.globl	_const_strconv__double_minus_zero
_const_strconv__double_minus_zero:
	.quad	-9223372036854775808
	.globl	_const_strconv__double_plus_infinity
_const_strconv__double_plus_infinity:
	.quad	9218868437227405312
	.globl	_const_strconv__double_minus_infinity
_const_strconv__double_minus_infinity:
	.quad	-4503599627370496
	.globl	_const_strconv__max_u64
_const_strconv__max_u64:
	.quad	-1
	.globl	_const_strconv__ten_pow_table_64
	.bss
_const_strconv__ten_pow_table_64:
	.zero	32
	.globl	_const_strconv__mantbits64
	.section	.rodata, "a"
_const_strconv__mantbits64:
	.long	52
	.globl	_const_strconv__expbits64
_const_strconv__expbits64:
	.long	11
	.globl	_const_strconv__dec_round
	.bss
_const_strconv__dec_round:
	.zero	32
	.globl	_const_strconv__pow5_split_64
_const_strconv__pow5_split_64:
	.zero	32
	.globl	_const_strconv__pow5_inv_split_64
_const_strconv__pow5_inv_split_64:
	.zero	32
	.globl	g_main_argc
g_main_argc:
	.zero	4
	.globl	g_main_argv
g_main_argv:
	.zero	8
	.globl	as_cast_type_indexes
as_cast_type_indexes:
	.zero	32
	.globl	_const_max_load_factor
	.section	.rodata, "a"
_const_max_load_factor:
	.zero	8
	.globl	_const_hash_mask
_const_hash_mask:
	.long	16777215
	.globl	_const_probe_inc
_const_probe_inc:
	.long	16777216
	.globl	_const_none__
	.bss
_const_none__:
	.zero	32
	.globl	_const_os__o_rdonly
_const_os__o_rdonly:
	.zero	4
	.globl	_const_os__o_wronly
_const_os__o_wronly:
	.zero	4
	.globl	_const_os__o_rdwr
_const_os__o_rdwr:
	.zero	4
	.globl	_const_os__o_create
_const_os__o_create:
	.zero	4
	.globl	_const_os__o_noctty
_const_os__o_noctty:
	.zero	4
	.globl	_const_os__o_trunc
_const_os__o_trunc:
	.zero	4
	.globl	_const_os__o_append
_const_os__o_append:
	.zero	4
	.globl	_const_os__o_nonblock
_const_os__o_nonblock:
	.zero	4
	.globl	_const_os__o_sync
_const_os__o_sync:
	.zero	4
	.globl	_const_os__args
_const_os__args:
	.zero	32
	.globl	_const_encoder__r_x86_64_64
	.section	.rodata, "a"
_const_encoder__r_x86_64_64:
	.quad	1
	.globl	_const_encoder__r_x86_64_pc32
_const_encoder__r_x86_64_pc32:
	.quad	2
	.globl	_const_encoder__r_x86_64_plt32
_const_encoder__r_x86_64_plt32:
	.quad	4
	.globl	_const_encoder__r_x86_64_32
_const_encoder__r_x86_64_32:
	.quad	10
	.globl	_const_encoder__r_x86_64_32s
_const_encoder__r_x86_64_32s:
	.quad	11
	.globl	_const_encoder__r_x86_64_16
_const_encoder__r_x86_64_16:
	.quad	12
	.globl	_const_encoder__r_x86_64_8
_const_encoder__r_x86_64_8:
	.quad	14
	.globl	_const_encoder__mod_indirection_with_no_disp
_const_encoder__mod_indirection_with_no_disp:
	.zero	1
	.globl	_const_encoder__mod_indirection_with_disp8
_const_encoder__mod_indirection_with_disp8:
	.byte	1
	.globl	_const_encoder__mod_indirection_with_disp32
_const_encoder__mod_indirection_with_disp32:
	.byte	2
	.globl	_const_encoder__mod_regi
_const_encoder__mod_regi:
	.byte	3
	.globl	_const_encoder__operand_size_prefix16
_const_encoder__operand_size_prefix16:
	.byte	102
	.globl	_const_encoder__general_registers
	.bss
_const_encoder__general_registers:
	.zero	120
	.globl	_const_encoder__xmm_registers
_const_encoder__xmm_registers:
	.zero	120
	.globl	_const_elf__r_x86_64_64
	.section	.rodata, "a"
_const_elf__r_x86_64_64:
	.quad	1
	.globl	_const_elf__r_x86_64_pc32
_const_elf__r_x86_64_pc32:
	.quad	2
	.globl	_const_elf__r_x86_64_32
_const_elf__r_x86_64_32:
	.quad	10
	.globl	_const_elf__r_x86_64_32s
_const_elf__r_x86_64_32s:
	.quad	11
	.globl	_const_elf__r_x86_64_16
_const_elf__r_x86_64_16:
	.quad	12
	.globl	_const_elf__r_x86_64_8
_const_elf__r_x86_64_8:
	.quad	14
	.globl	_IError_None___index
_IError_None___index:
	.zero	4
	.globl	_IError_voidptr_index
_IError_voidptr_index:
	.long	1
	.globl	_IError_Error_index
_IError_Error_index:
	.long	2
	.globl	_IError_MessageError_index
_IError_MessageError_index:
	.long	3
	.globl	_IError_flag__UnknownFlagError_index
_IError_flag__UnknownFlagError_index:
	.long	4
	.globl	_IError_flag__ArgsCountError_index
_IError_flag__ArgsCountError_index:
	.long	5
	.globl	_IError_os__Eof_index
_IError_os__Eof_index:
	.long	6
	.globl	_IError_os__NotExpected_index
_IError_os__NotExpected_index:
	.long	7
	.globl	_IError_os__FileNotOpenedError_index
_IError_os__FileNotOpenedError_index:
	.long	8
	.globl	_IError_os__SizeOfTypeIs0Error_index
_IError_os__SizeOfTypeIs0Error_index:
	.long	9
	.globl	_IError_os__ExecutableNotFoundError_index
_IError_os__ExecutableNotFoundError_index:
	.long	10
	.text
None___msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_msg
	leave
	ret
None___code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_code
	leave
	ret
Error_msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_msg
	leave
	ret
Error_code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_code
	leave
	ret
MessageError_msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	-8(%rbp), %rcx
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	MessageError_msg
	addq	$32, %rsp
	leave
	ret
MessageError_code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	-8(%rbp), %rcx
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	MessageError_code
	addq	$32, %rsp
	leave
	ret
flag__UnknownFlagError_msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	flag__UnknownFlagError_msg
	leave
	ret
flag__UnknownFlagError_code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_code
	leave
	ret
flag__ArgsCountError_msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	flag__ArgsCountError_msg
	leave
	ret
flag__ArgsCountError_code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_code
	leave
	ret
os__Eof_msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_msg
	leave
	ret
os__Eof_code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_code
	leave
	ret
os__NotExpected_msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	-8(%rbp), %rcx
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	os__NotExpected_msg
	addq	$32, %rsp
	leave
	ret
os__NotExpected_code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	subq	$8, %rsp
	movq	-8(%rbp), %rcx
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	os__NotExpected_code
	addq	$32, %rsp
	leave
	ret
os__FileNotOpenedError_msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	os__FileNotOpenedError_msg
	leave
	ret
os__FileNotOpenedError_code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_code
	leave
	ret
os__SizeOfTypeIs0Error_msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	os__SizeOfTypeIs0Error_msg
	leave
	ret
os__SizeOfTypeIs0Error_code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_code
	leave
	ret
os__ExecutableNotFoundError_msg_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	os__ExecutableNotFoundError_msg
	leave
	ret
os__ExecutableNotFoundError_code_Interface_IError_method_wrapper:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	Error_code
	leave
	ret
	.globl	IError_name_table
	.section	.data.rel.local,"aw"
IError_name_table:
	.quad	None___msg_Interface_IError_method_wrapper
	.quad	None___code_Interface_IError_method_wrapper
	.quad	0
	.quad	0
	.quad	Error_msg_Interface_IError_method_wrapper
	.quad	Error_code_Interface_IError_method_wrapper
	.quad	MessageError_msg_Interface_IError_method_wrapper
	.quad	MessageError_code_Interface_IError_method_wrapper
	.quad	flag__UnknownFlagError_msg_Interface_IError_method_wrapper
	.quad	flag__UnknownFlagError_code_Interface_IError_method_wrapper
	.quad	flag__ArgsCountError_msg_Interface_IError_method_wrapper
	.quad	flag__ArgsCountError_code_Interface_IError_method_wrapper
	.quad	os__Eof_msg_Interface_IError_method_wrapper
	.quad	os__Eof_code_Interface_IError_method_wrapper
	.quad	os__NotExpected_msg_Interface_IError_method_wrapper
	.quad	os__NotExpected_code_Interface_IError_method_wrapper
	.quad	os__FileNotOpenedError_msg_Interface_IError_method_wrapper
	.quad	os__FileNotOpenedError_code_Interface_IError_method_wrapper
	.quad	os__SizeOfTypeIs0Error_msg_Interface_IError_method_wrapper
	.quad	os__SizeOfTypeIs0Error_code_Interface_IError_method_wrapper
	.quad	os__ExecutableNotFoundError_msg_Interface_IError_method_wrapper
	.quad	os__ExecutableNotFoundError_code_Interface_IError_method_wrapper
	.text
I_None___to_Interface_IError:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	$0, %ecx
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	%ecx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 24(%rax)
	movq	-40(%rbp), %rax
	popq	%rbp
	ret
I_MessageError_to_Interface_IError:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	$3, %edi
	movq	-48(%rbp), %rdx
	movq	-48(%rbp), %rax
	leaq	16(%rax), %rsi
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rcx
	movq	%rcx, (%rax)
	movq	-40(%rbp), %rax
	movl	%edi, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-40(%rbp), %rax
	movq	%rsi, 24(%rax)
	movq	-40(%rbp), %rax
	popq	%rbp
	ret
I_flag__UnknownFlagError_to_Interface_IError:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	$4, %ecx
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	%ecx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 24(%rax)
	movq	-40(%rbp), %rax
	popq	%rbp
	ret
I_flag__ArgsCountError_to_Interface_IError:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	$5, %ecx
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	%ecx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 24(%rax)
	movq	-40(%rbp), %rax
	popq	%rbp
	ret
I_os__Eof_to_Interface_IError:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	$6, %ecx
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	%ecx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 24(%rax)
	movq	-40(%rbp), %rax
	popq	%rbp
	ret
I_os__FileNotOpenedError_to_Interface_IError:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	$8, %ecx
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	%ecx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 24(%rax)
	movq	-40(%rbp), %rax
	popq	%rbp
	ret
I_os__SizeOfTypeIs0Error_to_Interface_IError:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	$9, %ecx
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	%ecx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, 24(%rax)
	movq	-40(%rbp), %rax
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC0:
	.string	"suffix_byte"
.LC1:
	.string	"suffix_word"
.LC2:
	.string	"suffix_long"
.LC3:
	.string	"suffix_quad"
.LC4:
	.string	"suffix_single"
.LC5:
	.string	"suffix_double"
.LC6:
	.string	"suffix_unkown"
.LC7:
	.string	"unknown enum value"
	.text
encoder__DataSize_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movl	%edi, -20(%rbp)
	cmpl	$6, -20(%rbp)
	ja	.L90
	movl	-20(%rbp), %ecx
	leaq	0(,%rcx,4), %rsi
	leaq	.L92(%rip), %rcx
	movl	(%rsi,%rcx), %ecx
	movslq	%ecx, %rcx
	leaq	.L92(%rip), %rsi
	addq	%rsi, %rcx
	jmp	*%rcx
	.section	.rodata, "a"
.L92:
	.text
.L98:
	leaq	.LC0(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$11, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L99
.L97:
	leaq	.LC1(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$11, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L99
.L96:
	leaq	.LC2(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$11, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L99
.L95:
	leaq	.LC3(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$11, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L99
.L94:
	leaq	.LC4(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$13, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L99
.L93:
	leaq	.LC5(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$13, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L99
.L91:
	leaq	.LC6(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$13, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L99
.L90:
	leaq	.LC7(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$18, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
.L99:
	movq	-8(%rbp), %rbx
	leave
	ret
encoder__Register_to_sumtype_encoder__RegiAll:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	-80(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rdx
	movq	-8(%rbp), %rax
	leaq	16(%rax), %r8
	movq	-8(%rbp), %rax
	leaq	20(%rax), %rdi
	movq	-8(%rbp), %rax
	leaq	21(%rax), %rsi
	movq	-72(%rbp), %rax
	movq	-8(%rbp), %rcx
	movq	%rcx, (%rax)
	movq	-72(%rbp), %rax
	movl	$165, 8(%rax)
	movq	-72(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-72(%rbp), %rax
	movq	%r8, 24(%rax)
	movq	-72(%rbp), %rax
	movq	%rdi, 32(%rax)
	movq	-72(%rbp), %rax
	movq	%rsi, 40(%rax)
	movq	-72(%rbp), %rax
	leave
	ret
encoder__Empty_to_sumtype_encoder__RegiAll:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	-80(%rbp), %rax
	movl	$24, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rdx
	movq	-8(%rbp), %rax
	leaq	16(%rax), %r8
	movq	-8(%rbp), %rax
	leaq	21(%rax), %rdi
	movq	-8(%rbp), %rax
	leaq	20(%rax), %rsi
	movq	-72(%rbp), %rax
	movq	-8(%rbp), %rcx
	movq	%rcx, (%rax)
	movq	-72(%rbp), %rax
	movl	$166, 8(%rax)
	movq	-72(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-72(%rbp), %rax
	movq	%r8, 24(%rax)
	movq	-72(%rbp), %rax
	movq	%rdi, 32(%rax)
	movq	-72(%rbp), %rax
	movq	%rsi, 40(%rax)
	movq	-72(%rbp), %rax
	leave
	ret
encoder__Xmm_to_sumtype_encoder__RegiAll:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	-80(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rdx
	movq	-8(%rbp), %rax
	leaq	16(%rax), %r8
	movq	-8(%rbp), %rax
	leaq	20(%rax), %rdi
	movq	-8(%rbp), %rax
	leaq	21(%rax), %rsi
	movq	-72(%rbp), %rax
	movq	-8(%rbp), %rcx
	movq	%rcx, (%rax)
	movq	-72(%rbp), %rax
	movl	$167, 8(%rax)
	movq	-72(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-72(%rbp), %rax
	movq	%r8, 24(%rax)
	movq	-72(%rbp), %rax
	movq	%rdi, 32(%rax)
	movq	-72(%rbp), %rax
	movq	%rsi, 40(%rax)
	movq	-72(%rbp), %rax
	leave
	ret
encoder__Xmm_to_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	24(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	$167, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rcx, 16(%rax)
	movq	-40(%rbp), %rax
	leave
	ret
encoder__Register_to_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	24(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	$165, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rcx, 16(%rax)
	movq	-40(%rbp), %rax
	leave
	ret
encoder__Number_to_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$40, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	16(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	$177, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rcx, 16(%rax)
	movq	-40(%rbp), %rax
	leave
	ret
encoder__Ident_to_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$40, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	16(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	$170, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rcx, 16(%rax)
	movq	-40(%rbp), %rax
	leave
	ret
encoder__Neg_to_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	24(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	$176, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rcx, 16(%rax)
	movq	-40(%rbp), %rax
	leave
	ret
encoder__Binop_to_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$80, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	56(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	$175, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rcx, 16(%rax)
	movq	-40(%rbp), %rax
	leave
	ret
encoder__Immediate_to_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	24(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	$169, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rcx, 16(%rax)
	movq	-40(%rbp), %rax
	leave
	ret
encoder__Star_to_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$72, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	48(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	$178, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rcx, 16(%rax)
	movq	-40(%rbp), %rax
	leave
	ret
encoder__Indirection_to_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$176, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	144(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movl	$168, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rcx, 16(%rax)
	movq	-40(%rbp), %rax
	leave
	ret
Array_encoder__DataSize_contains:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -20(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L126
.L129:
	movq	24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -20(%rbp)
	jne	.L127
	movl	$1, %eax
	jmp	.L128
.L127:
	addl	$1, -4(%rbp)
.L126:
	movl	36(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L129
	movl	$0, %eax
.L128:
	popq	%rbp
	ret
Array_string_contains:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L131
.L134:
	movq	24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	leaq	(%rax,%rdx), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	(%rcx), %rdi
	movq	8(%rcx), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	fast_string_eq
	testb	%al, %al
	je	.L132
	movl	$1, %eax
	jmp	.L133
.L132:
	addl	$1, -4(%rbp)
.L131:
	movl	36(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L134
	movl	$0, %eax
.L133:
	leave
	ret
Array_string_index:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	24(%rbp), %rax
	movq	%rax, -8(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L136
.L139:
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rcx
	movq	(%rcx), %rdi
	movq	8(%rcx), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	fast_string_eq
	testb	%al, %al
	je	.L137
	movl	-12(%rbp), %eax
	jmp	.L138
.L137:
	addl	$1, -12(%rbp)
	addq	$16, -8(%rbp)
.L136:
	movl	36(%rbp), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L139
	movl	$-1, %eax
.L138:
	leave
	ret
	.section	.rodata, "a"
.LC8:
	.string	"None__"
.LC9:
	.string	"voidptr"
.LC10:
	.string	"Error"
.LC11:
	.string	"MessageError"
.LC12:
	.string	"flag.UnknownFlagError"
.LC13:
	.string	"flag.ArgsCountError"
.LC14:
	.string	"os.Eof"
.LC15:
	.string	"os.NotExpected"
.LC16:
	.string	"os.FileNotOpenedError"
.LC17:
.LC18:
	.string	"os.ExecutableNotFoundError"
.LC19:
	.string	"unknown IError"
	.text
v_typeof_interface_IError:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	$0, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L141
	leaq	.LC8(%rip), %rax
	jmp	.L142
.L141:
	movl	$1, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L143
	leaq	.LC9(%rip), %rax
	jmp	.L142
.L143:
	movl	$2, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L144
	leaq	.LC10(%rip), %rax
	jmp	.L142
.L144:
	movl	$3, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L145
	leaq	.LC11(%rip), %rax
	jmp	.L142
.L145:
	movl	$4, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L146
	leaq	.LC12(%rip), %rax
	jmp	.L142
.L146:
	movl	$5, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L147
	leaq	.LC13(%rip), %rax
	jmp	.L142
.L147:
	movl	$6, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L148
	leaq	.LC14(%rip), %rax
	jmp	.L142
.L148:
	movl	$7, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L149
	leaq	.LC15(%rip), %rax
	jmp	.L142
.L149:
	movl	$8, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L150
	leaq	.LC16(%rip), %rax
	jmp	.L142
.L150:
	movl	$9, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L151
	leaq	.LC17(%rip), %rax
	jmp	.L142
.L151:
	movl	$10, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L152
	leaq	.LC18(%rip), %rax
	jmp	.L142
.L152:
	leaq	.LC19(%rip), %rax
.L142:
	popq	%rbp
	ret
v_typeof_interface_idx_IError:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	$0, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L154
	movl	$65609, %eax
	jmp	.L155
.L154:
	movl	$1, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L156
	movl	$2, %eax
	jmp	.L155
.L156:
	movl	$2, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L157
	movl	$74, %eax
	jmp	.L155
.L157:
	movl	$3, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L158
	movl	$75, %eax
	jmp	.L155
.L158:
	movl	$4, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L159
	movl	$65686, %eax
	jmp	.L155
.L159:
	movl	$5, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L160
	movl	$65687, %eax
	jmp	.L155
.L160:
	movl	$6, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L161
	movl	$113, %eax
	jmp	.L155
.L161:
	movl	$7, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L162
	movl	$114, %eax
	jmp	.L155
.L162:
	movl	$8, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L163
	movl	$65653, %eax
	jmp	.L155
.L163:
	movl	$9, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L164
	movl	$65654, %eax
	jmp	.L155
.L164:
	movl	$10, %eax
	cmpl	%eax, -4(%rbp)
	jne	.L165
	movl	$65668, %eax
	jmp	.L155
.L165:
	movl	$29, %eax
.L155:
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC20:
	.string	"encoder.Expr"
.LC21:
	.string	"encoder.Binop"
.LC22:
	.string	"encoder.Ident"
.LC23:
	.string	"encoder.Immediate"
.LC24:
	.string	"encoder.Indirection"
.LC25:
	.string	"encoder.Neg"
.LC26:
	.string	"encoder.Number"
.LC27:
	.string	"encoder.Register"
.LC28:
	.string	"encoder.Star"
.LC29:
	.string	"encoder.Xmm"
.LC30:
	.string	"unknown encoder.Expr"
	.text
	.globl	v_typeof_sumtype_encoder__Expr
v_typeof_sumtype_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	subl	$165, %eax
	cmpl	$14, %eax
	ja	.L167
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L169(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L169(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata, "a"
.L169:
	.text
.L168:
	leaq	.LC20(%rip), %rax
	jmp	.L179
.L173:
	leaq	.LC21(%rip), %rax
	jmp	.L179
.L174:
	leaq	.LC22(%rip), %rax
	jmp	.L179
.L175:
	leaq	.LC23(%rip), %rax
	jmp	.L179
.L176:
	leaq	.LC24(%rip), %rax
	jmp	.L179
.L172:
	leaq	.LC25(%rip), %rax
	jmp	.L179
.L171:
	leaq	.LC26(%rip), %rax
	jmp	.L179
.L178:
	leaq	.LC27(%rip), %rax
	jmp	.L179
.L170:
	leaq	.LC28(%rip), %rax
	jmp	.L179
.L177:
	leaq	.LC29(%rip), %rax
	jmp	.L179
.L167:
	leaq	.LC30(%rip), %rax
.L179:
	popq	%rbp
	ret
	.globl	v_typeof_sumtype_idx_encoder__Expr
v_typeof_sumtype_idx_encoder__Expr:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	subl	$165, %eax
	cmpl	$14, %eax
	ja	.L181
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L183(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L183(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata, "a"
.L183:
	.text
.L182:
	movl	$179, %eax
	jmp	.L193
.L187:
	movl	$175, %eax
	jmp	.L193
.L188:
	movl	$170, %eax
	jmp	.L193
.L189:
	movl	$169, %eax
	jmp	.L193
.L190:
	movl	$168, %eax
	jmp	.L193
.L186:
	movl	$176, %eax
	jmp	.L193
.L185:
	movl	$177, %eax
	jmp	.L193
.L192:
	movl	$165, %eax
	jmp	.L193
.L184:
	movl	$178, %eax
	jmp	.L193
.L191:
	movl	$167, %eax
	jmp	.L193
.L181:
	movl	$179, %eax
.L193:
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC31:
	.string	"encoder.RegiAll"
.LC32:
	.string	"encoder.Empty"
.LC33:
	.string	"unknown encoder.RegiAll"
	.text
	.globl	v_typeof_sumtype_encoder__RegiAll
v_typeof_sumtype_encoder__RegiAll:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	cmpl	$180, -4(%rbp)
	je	.L195
	cmpl	$180, -4(%rbp)
	jg	.L196
	cmpl	$167, -4(%rbp)
	je	.L197
	cmpl	$167, -4(%rbp)
	jg	.L196
	cmpl	$165, -4(%rbp)
	je	.L198
	cmpl	$166, -4(%rbp)
	je	.L199
	jmp	.L196
.L195:
	leaq	.LC31(%rip), %rax
	jmp	.L200
.L198:
	leaq	.LC27(%rip), %rax
	jmp	.L200
.L197:
	leaq	.LC29(%rip), %rax
	jmp	.L200
.L199:
	leaq	.LC32(%rip), %rax
	jmp	.L200
.L196:
	leaq	.LC33(%rip), %rax
.L200:
	popq	%rbp
	ret
	.globl	v_typeof_sumtype_idx_encoder__RegiAll
v_typeof_sumtype_idx_encoder__RegiAll:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	cmpl	$180, -4(%rbp)
	je	.L202
	cmpl	$180, -4(%rbp)
	jg	.L203
	cmpl	$167, -4(%rbp)
	je	.L204
	cmpl	$167, -4(%rbp)
	jg	.L203
	cmpl	$165, -4(%rbp)
	je	.L205
	cmpl	$166, -4(%rbp)
	je	.L206
	jmp	.L203
.L202:
	movl	$180, %eax
	jmp	.L207
.L205:
	movl	$165, %eax
	jmp	.L207
.L204:
	movl	$167, %eax
	jmp	.L207
.L206:
	movl	$166, %eax
	jmp	.L207
.L203:
	movl	$180, %eax
.L207:
	popq	%rbp
	ret
	.globl	strings__new_builder
strings__new_builder:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	leaq	-32(%rbp), %rax
	movl	-44(%rbp), %edx
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	-32(%rbp), %rax
	addq	$28, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	ArrayFlags_set
	movq	-40(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-40(%rbp), %rax
	leave
	ret
	.globl	strings__Builder_reuse_as_plain_u8_array
strings__Builder_reuse_as_plain_u8_array:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	addq	$28, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	ArrayFlags_clear
	movq	-8(%rbp), %rcx
	movq	-16(%rbp), %rsi
	movq	(%rsi), %rax
	movq	8(%rsi), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	16(%rsi), %rax
	movq	24(%rsi), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-8(%rbp), %rax
	leave
	ret
	.globl	strings__Builder_write_ptr
strings__Builder_write_ptr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	cmpl	$0, -20(%rbp)
	je	.L215
	movl	-20(%rbp), %edx
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_push_many
	jmp	.L212
.L215:
	nop
.L212:
	leave
	ret
	.globl	strings__Builder_write_rune
strings__Builder_write_rune:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movl	$0, -5(%rbp)
	movb	$0, -1(%rbp)
	leaq	-5(%rbp), %rdx
	movl	-44(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	utf32_to_str_no_malloc
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	-24(%rbp), %eax
	testl	%eax, %eax
	je	.L219
	movl	-24(%rbp), %edx
	movq	-32(%rbp), %rcx
	movq	-40(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_push_many
	jmp	.L216
.L219:
	nop
.L216:
	leave
	ret
	.globl	strings__Builder_write_runes
strings__Builder_write_runes:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	$0, -13(%rbp)
	movb	$0, -9(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L221
.L224:
	movq	24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -8(%rbp)
	leaq	-13(%rbp), %rdx
	movl	-8(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	utf32_to_str_no_malloc
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	-24(%rbp), %eax
	testl	%eax, %eax
	je	.L225
	movl	-24(%rbp), %edx
	movq	-32(%rbp), %rcx
	movq	-40(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_push_many
	jmp	.L223
.L225:
	nop
.L223:
	addl	$1, -4(%rbp)
.L221:
	movl	36(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L224
	nop
	nop
	leave
	ret
	.globl	strings__Builder_clear
strings__Builder_clear:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	24(%rax), %edx
	movq	-24(%rbp), %rbx
	leaq	-64(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rbx)
	movq	%rdx, 8(%rbx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 16(%rbx)
	movq	%rdx, 24(%rbx)
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strings__Builder_write_u8
strings__Builder_write_u8:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, %eax
	movb	%al, -28(%rbp)
	movzbl	-28(%rbp), %eax
	movb	%al, -1(%rbp)
	leaq	-1(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	nop
	leave
	ret
	.globl	strings__Builder_write_byte
strings__Builder_write_byte:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, %eax
	movb	%al, -28(%rbp)
	movzbl	-28(%rbp), %eax
	movb	%al, -1(%rbp)
	leaq	-1(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	nop
	leave
	ret
	.globl	strings__Builder_write
strings__Builder_write:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$136, %rsp
	movq	%rdi, -136(%rbp)
	movq	%rsi, -144(%rbp)
	movl	36(%rbp), %eax
	testl	%eax, %eax
	jne	.L230
	movl	$0, -72(%rbp)
	leaq	-128(%rbp), %rcx
	leaq	-72(%rbp), %rax
	movl	$4, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-136(%rbp), %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L229
.L230:
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movl	-108(%rbp), %edx
	movq	-120(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_push_many
	movl	36(%rbp), %eax
	movl	%eax, -68(%rbp)
	leaq	-64(%rbp), %rcx
	leaq	-68(%rbp), %rax
	movl	$4, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-136(%rbp), %rax
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-32(%rbp), %rcx
	movq	-24(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L229:
	movq	-136(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strings__Builder_drain_builder
strings__Builder_drain_builder:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$104, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	movq	-64(%rbp), %rax
	movl	20(%rax), %eax
	testl	%eax, %eax
	jle	.L234
	movq	-64(%rbp), %rcx
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	16(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	-28(%rbp), %edx
	movq	-40(%rbp), %rcx
	movq	-56(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_push_many
.L234:
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	strings__Builder_free
	movq	-64(%rbp), %rbx
	leaq	-112(%rbp), %rax
	movl	-68(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strings__new_builder
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, (%rbx)
	movq	%rdx, 8(%rbx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 16(%rbx)
	movq	%rdx, 24(%rbx)
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strings__Builder_byte_at
strings__Builder_byte_at:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-12(%rbp), %edi
	movq	-8(%rbp), %rcx
	subq	$32, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	%rax, 16(%rsi)
	movq	%rdx, 24(%rsi)
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	leave
	ret
	.globl	strings__Builder_write_string
strings__Builder_write_string:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	-24(%rbp), %eax
	testl	%eax, %eax
	je	.L240
	movl	-24(%rbp), %edx
	movq	-32(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_push_many
	jmp	.L237
.L240:
	nop
.L237:
	leave
	ret
	.globl	strings__Builder_go_back
strings__Builder_go_back:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	20(%rax), %eax
	subl	-12(%rbp), %eax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	array_trim
	nop
	leave
	ret
	.globl	strings__Builder_spart
	.hidden	strings__Builder_spart
strings__Builder_spart:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movl	%edx, -48(%rbp)
	movl	-48(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -24(%rbp)
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	movq	8(%rax), %rcx
	movl	-44(%rbp), %eax
	cltq
	addq	%rax, %rcx
	movq	-24(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-48(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strings__Builder_cut_last
strings__Builder_cut_last:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movq	-40(%rbp), %rax
	movl	20(%rax), %eax
	subl	-44(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-44(%rbp), %edx
	movl	-4(%rbp), %ecx
	movq	-40(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	strings__Builder_spart
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	-4(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	array_trim
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	leave
	ret
	.section	.rodata, "a"
.LC34:
	.string	""
	.text
	.globl	strings__Builder_cut_to
strings__Builder_cut_to:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rcx
	movl	20(%rcx), %ecx
	cmpl	%ecx, -28(%rbp)
	jle	.L247
	leaq	.LC34(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L248
.L247:
	movq	-24(%rbp), %rax
	movl	20(%rax), %eax
	subl	-28(%rbp), %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strings__Builder_cut_last
.L248:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strings__Builder_go_back_to
strings__Builder_go_back_to:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	array_trim
	nop
	leave
	ret
	.globl	strings__Builder_writeln
strings__Builder_writeln:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movl	-40(%rbp), %eax
	testl	%eax, %eax
	jle	.L251
	movl	-40(%rbp), %edx
	movq	-48(%rbp), %rcx
	movq	-24(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_push_many
.L251:
	movb	$10, -1(%rbp)
	leaq	-1(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	nop
	leave
	ret
	.globl	strings__Builder_last_n
strings__Builder_last_n:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rcx
	movl	20(%rcx), %ecx
	cmpl	%ecx, -28(%rbp)
	jle	.L253
	leaq	.LC34(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L254
.L253:
	movq	-24(%rbp), %rax
	movl	20(%rax), %eax
	subl	-28(%rbp), %eax
	movl	%eax, %ecx
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	strings__Builder_spart
.L254:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strings__Builder_after
strings__Builder_after:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rcx
	movl	20(%rcx), %ecx
	cmpl	%ecx, -28(%rbp)
	jl	.L256
	leaq	.LC34(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L257
.L256:
	movq	-24(%rbp), %rax
	movl	20(%rax), %eax
	subl	-28(%rbp), %eax
	movl	%eax, %edx
	movl	-28(%rbp), %ecx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	strings__Builder_spart
.L257:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strings__Builder_str
strings__Builder_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movb	$0, -9(%rbp)
	leaq	-9(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movq	-40(%rbp), %rax
	movl	20(%rax), %edx
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	memdup_noscan
	movq	%rax, -8(%rbp)
	movq	-40(%rbp), %rax
	movl	20(%rax), %eax
	leal	-1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	u8_vstring_with_len
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-40(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	array_trim
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	leave
	ret
	.globl	strings__Builder_ensure_cap
strings__Builder_ensure_cap:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movl	24(%rax), %eax
	cmpl	%eax, -28(%rbp)
	jle	.L264
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	imull	-28(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	vcalloc
	movq	%rax, -8(%rbp)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	je	.L263
	movq	-24(%rbp), %rax
	movl	20(%rax), %edx
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	imull	%edx, %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-24(%rbp), %rax
	addq	$28, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	ArrayFlags_has
	testb	%al, %al
	je	.L263
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
.L263:
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 8(%rax)
	movq	-24(%rbp), %rax
	movl	$0, 16(%rax)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	movl	%edx, 24(%rax)
	jmp	.L260
.L264:
	nop
.L260:
	leave
	ret
	.globl	strings__Builder_free
strings__Builder_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	je	.L267
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-8(%rbp), %rax
	movq	$0, 8(%rax)
.L267:
	nop
	leave
	ret
	.globl	math__bits__trailing_zeros_64
math__bits__trailing_zeros_64:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L269
	movl	$64, %eax
	jmp	.L270
.L269:
	movq	-8(%rbp), %rax
	negq	%rax
	andq	-8(%rbp), %rax
	movabsq	$285870213051353865, %rdx
	imulq	%rdx, %rax
	shrq	$58, %rax
	movl	%eax, %esi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	_const_math__bits__de_bruijn64tab(%rip), %rax
	movq	8+_const_math__bits__de_bruijn64tab(%rip), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	16+_const_math__bits__de_bruijn64tab(%rip), %rax
	movq	24+_const_math__bits__de_bruijn64tab(%rip), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%esi, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movzbl	%al, %eax
.L270:
	leave
	ret
	.globl	math__bits__mul_64
math__bits__mul_64:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movl	$4294967295, %ecx
	andq	-104(%rbp), %rcx
	movq	%rcx, -24(%rbp)
	movq	-104(%rbp), %rcx
	shrq	$32, %rcx
	movq	%rcx, -32(%rbp)
	movl	$4294967295, %ecx
	andq	-112(%rbp), %rcx
	movq	%rcx, -40(%rbp)
	movq	-112(%rbp), %rcx
	shrq	$32, %rcx
	movq	%rcx, -48(%rbp)
	movq	-24(%rbp), %rcx
	imulq	-40(%rbp), %rcx
	movq	%rcx, -56(%rbp)
	movq	-32(%rbp), %rcx
	imulq	-40(%rbp), %rcx
	movq	-56(%rbp), %rsi
	shrq	$32, %rsi
	addq	%rsi, %rcx
	movq	%rcx, -64(%rbp)
	movl	$4294967295, %ecx
	andq	-64(%rbp), %rcx
	movq	%rcx, -72(%rbp)
	movq	-64(%rbp), %rcx
	shrq	$32, %rcx
	movq	%rcx, -80(%rbp)
	movq	-24(%rbp), %rcx
	imulq	-48(%rbp), %rcx
	addq	%rcx, -72(%rbp)
	movq	-32(%rbp), %rcx
	movq	%rcx, %rsi
	imulq	-48(%rbp), %rsi
	movq	-80(%rbp), %rcx
	addq	%rcx, %rsi
	movq	-72(%rbp), %rcx
	shrq	$32, %rcx
	addq	%rsi, %rcx
	movq	%rcx, -88(%rbp)
	movq	-104(%rbp), %rcx
	imulq	-112(%rbp), %rcx
	movq	%rcx, -96(%rbp)
	movq	-88(%rbp), %rax
	movq	-96(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC35:
	.string	"common_parse_uint: wrong base "
.LC36:
	.string	" for "
.LC37:
	.string	"common_parse_uint: wrong bit size "
.LC38:
	.string	"common_parse_uint: integer overflow "
.LC39:
	.string	"common_parse_uint: syntax error "
	.text
	.globl	strconv__common_parse_uint
strconv__common_parse_uint:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$392, %rsp
	movq	%rdi, -360(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -384(%rbp)
	movq	%rdx, -376(%rbp)
	movl	%ecx, -364(%rbp)
	movl	%r8d, -368(%rbp)
	movl	%r9d, %edx
	movl	16(%rbp), %eax
	movb	%dl, -388(%rbp)
	movb	%al, -392(%rbp)
	movl	-368(%rbp), %ecx
	movl	-364(%rbp), %edx
	movq	-384(%rbp), %rsi
	movq	-376(%rbp), %rax
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	strconv__common_parse_uint2
	movq	%rax, -176(%rbp)
	movq	%rdx, -168(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, -24(%rbp)
	movl	-168(%rbp), %eax
	movl	%eax, -28(%rbp)
	cmpl	$0, -28(%rbp)
	je	.L274
	cmpb	$0, -388(%rbp)
	jne	.L275
	cmpb	$0, -392(%rbp)
	je	.L274
.L275:
	cmpl	$-1, -28(%rbp)
	je	.L276
	cmpl	$0, -28(%rbp)
	jns	.L277
	cmpl	$-3, -28(%rbp)
	je	.L278
	cmpl	$-2, -28(%rbp)
	je	.L279
	jmp	.L277
.L276:
	leaq	-352(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC35(%rip), %rax
	movq	%rax, -352(%rbp)
	movl	$30, -344(%rbp)
	movl	$1, -340(%rbp)
	movl	$65031, -336(%rbp)
	movl	-364(%rbp), %eax
	movl	%eax, -328(%rbp)
	leaq	.LC36(%rip), %rax
	movq	%rax, -312(%rbp)
	movl	$5, -304(%rbp)
	movl	$1, -300(%rbp)
	movl	$65040, -296(%rbp)
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -272(%rbp)
	movl	$1, -260(%rbp)
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	leaq	-160(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-360(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-360(%rbp), %rax
	movb	$1, (%rax)
	movq	-360(%rbp), %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L273
.L279:
	leaq	-352(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC37(%rip), %rax
	movq	%rax, -352(%rbp)
	movl	$34, -344(%rbp)
	movl	$1, -340(%rbp)
	movl	$65031, -336(%rbp)
	movl	-368(%rbp), %eax
	movl	%eax, -328(%rbp)
	leaq	.LC36(%rip), %rax
	movq	%rax, -312(%rbp)
	movl	$5, -304(%rbp)
	movl	$1, -300(%rbp)
	movl	$65040, -296(%rbp)
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -272(%rbp)
	movl	$1, -260(%rbp)
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	leaq	-128(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-360(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-360(%rbp), %rax
	movb	$1, (%rax)
	movq	-360(%rbp), %rcx
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L273
.L278:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -352(%rbp)
	movaps	%xmm0, -336(%rbp)
	movaps	%xmm0, -320(%rbp)
	movaps	%xmm0, -304(%rbp)
	movaps	%xmm0, -288(%rbp)
	leaq	.LC38(%rip), %rax
	movq	%rax, -352(%rbp)
	movl	$36, -344(%rbp)
	movl	$1, -340(%rbp)
	movl	$65040, -336(%rbp)
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, -328(%rbp)
	movq	%rdx, -320(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -312(%rbp)
	movl	$1, -300(%rbp)
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	leaq	-96(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-360(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-360(%rbp), %rax
	movb	$1, (%rax)
	movq	-360(%rbp), %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L273
.L277:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -352(%rbp)
	movaps	%xmm0, -336(%rbp)
	movaps	%xmm0, -320(%rbp)
	movaps	%xmm0, -304(%rbp)
	movaps	%xmm0, -288(%rbp)
	leaq	.LC39(%rip), %rax
	movq	%rax, -352(%rbp)
	movl	$32, -344(%rbp)
	movl	$1, -340(%rbp)
	movl	$65040, -336(%rbp)
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, -328(%rbp)
	movq	%rdx, -320(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -312(%rbp)
	movl	$1, -300(%rbp)
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	leaq	-64(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-360(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-360(%rbp), %rax
	movb	$1, (%rax)
	movq	-360(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L273
.L274:
	movq	-24(%rbp), %rax
	movq	%rax, -232(%rbp)
	leaq	-224(%rbp), %rcx
	leaq	-232(%rbp), %rax
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-360(%rbp), %rax
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L273:
	movq	-360(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strconv__common_parse_uint2
strconv__common_parse_uint2:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rsi, %rax
	movq	%rdi, %r10
	movq	%r10, %rsi
	movq	%r11, %rdi
	movq	%rax, %rdi
	movq	%rsi, -80(%rbp)
	movq	%rdi, -72(%rbp)
	movl	%edx, -84(%rbp)
	movl	%ecx, -88(%rbp)
	movl	-72(%rbp), %eax
	testl	%eax, %eax
	jg	.L283
	movl	$0, %r8d
	movq	%r9, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, %r9
	jmp	.L284
.L283:
	movl	-88(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-84(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	$0, -12(%rbp)
	cmpl	$0, -8(%rbp)
	jne	.L285
	movl	$10, -8(%rbp)
	movq	-80(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$48, %al
	jne	.L285
	movq	-80(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	orl	$32, %eax
	movb	%al, -30(%rbp)
	movl	-72(%rbp), %eax
	cmpl	$2, %eax
	jle	.L286
	cmpb	$98, -30(%rbp)
	jne	.L287
	movl	$2, -8(%rbp)
	addl	$2, -12(%rbp)
	jmp	.L288
.L287:
	cmpb	$111, -30(%rbp)
	jne	.L289
	movl	$8, -8(%rbp)
	addl	$2, -12(%rbp)
	jmp	.L288
.L289:
	cmpb	$120, -30(%rbp)
	jne	.L288
	movl	$16, -8(%rbp)
	addl	$2, -12(%rbp)
.L288:
	movq	-80(%rbp), %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$95, %al
	jne	.L285
	addl	$1, -12(%rbp)
	jmp	.L285
.L286:
	movl	-72(%rbp), %eax
	cmpl	$1, %eax
	jle	.L290
	movq	-80(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jbe	.L290
	movq	-80(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	ja	.L290
	movl	$10, -8(%rbp)
	addl	$1, -12(%rbp)
	jmp	.L285
.L290:
	movl	$8, -8(%rbp)
	addl	$1, -12(%rbp)
.L285:
	cmpl	$0, -4(%rbp)
	jne	.L291
	movl	$32, -4(%rbp)
	jmp	.L292
.L291:
	cmpl	$0, -4(%rbp)
	js	.L293
	cmpl	$64, -4(%rbp)
	jle	.L292
.L293:
	movl	$0, %r8d
	movq	%r9, %rdx
	movabsq	$-4294967296, %rax
	andq	%rax, %rdx
	movl	$4294967294, %eax
	orq	%rdx, %rax
	movq	%rax, %r9
	jmp	.L284
.L292:
	movq	$-1, %rcx
	movl	-8(%rbp), %eax
	movslq	%eax, %rdi
	movq	%rcx, %rax
	movl	$0, %edx
	divq	%rdi
	addq	$1, %rax
	movq	%rax, -40(%rbp)
	cmpl	$64, -4(%rbp)
	je	.L294
	movl	-4(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	salq	%cl, %rdx
	movq	%rdx, %rax
	subq	$1, %rax
	jmp	.L295
.L294:
	movq	$-1, %rax
.L295:
	movq	%rax, -48(%rbp)
	movq	$0, -24(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, -28(%rbp)
	jmp	.L296
.L309:
	movq	-80(%rbp), %rdx
	movl	-28(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -29(%rbp)
	cmpb	$95, -29(%rbp)
	jne	.L297
	movl	-28(%rbp), %eax
	cmpl	-12(%rbp), %eax
	je	.L298
	movl	-72(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -28(%rbp)
	jl	.L299
.L298:
	movl	$0, %r8d
	movq	%r9, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, %r9
	jmp	.L284
.L299:
	movq	-80(%rbp), %rax
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	subq	$1, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$95, %al
	je	.L300
	movq	-80(%rbp), %rax
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$95, %al
	jne	.L311
.L300:
	movl	$0, %r8d
	movq	%r9, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, %r9
	jmp	.L284
.L297:
	subb	$48, -29(%rbp)
	movzbl	-29(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jg	.L303
	subb	$7, -29(%rbp)
.L303:
	movzbl	-29(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jg	.L304
	subb	$32, -29(%rbp)
.L304:
	movzbl	-29(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jg	.L305
	movl	-28(%rbp), %eax
	addl	$1, %eax
	movq	-24(%rbp), %r8
	movl	%eax, %edx
	movq	%r9, %rcx
	movabsq	$-4294967296, %rax
	andq	%rcx, %rax
	orq	%rdx, %rax
	movq	%rax, %r9
	jmp	.L284
.L305:
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L306
	movq	-48(%rbp), %r8
	movq	%r9, %rdx
	movabsq	$-4294967296, %rax
	andq	%rax, %rdx
	movl	$4294967293, %eax
	orq	%rdx, %rax
	movq	%rax, %r9
	jmp	.L284
.L306:
	movl	-8(%rbp), %eax
	cltq
	movq	-24(%rbp), %rdx
	imulq	%rdx, %rax
	movq	%rax, -24(%rbp)
	movzbl	-29(%rbp), %edx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	-24(%rbp), %rax
	jb	.L307
	movq	-56(%rbp), %rax
	cmpq	%rax, -48(%rbp)
	jnb	.L308
.L307:
	movq	-48(%rbp), %r8
	movq	%r9, %rdx
	movabsq	$-4294967296, %rax
	andq	%rax, %rdx
	movl	$4294967293, %eax
	orq	%rdx, %rax
	movq	%rax, %r9
	jmp	.L284
.L308:
	movq	-56(%rbp), %rax
	movq	%rax, -24(%rbp)
	jmp	.L302
.L311:
	nop
.L302:
	addl	$1, -28(%rbp)
.L296:
	movl	-72(%rbp), %eax
	cmpl	%eax, -28(%rbp)
	jl	.L309
	movq	-24(%rbp), %r8
	movq	%r9, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, %r9
.L284:
	movq	%r8, %rax
	movq	%r9, %rdx
	popq	%rbp
	ret
	.globl	strconv__common_parse_int
strconv__common_parse_int:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$296, %rsp
	movq	%rdi, -264(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	movl	%ecx, -268(%rbp)
	movl	%r8d, -272(%rbp)
	movl	%r9d, %edx
	movl	16(%rbp), %eax
	movb	%dl, -292(%rbp)
	movb	%al, -296(%rbp)
	movl	-280(%rbp), %eax
	testl	%eax, %eax
	jg	.L313
	movq	$0, -168(%rbp)
	leaq	-256(%rbp), %rcx
	leaq	-168(%rbp), %rax
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-264(%rbp), %rax
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L312
.L313:
	movl	-272(%rbp), %eax
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jne	.L315
	movl	$32, -20(%rbp)
.L315:
	movq	-288(%rbp), %rax
	movq	-280(%rbp), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movb	$0, -21(%rbp)
	movq	-64(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$43, %al
	jne	.L316
	movl	-56(%rbp), %eax
	leal	-1(%rax), %edx
	movq	-64(%rbp), %rax
	addq	$1, %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	jmp	.L317
.L316:
	movq	-64(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	jne	.L317
	movb	$1, -21(%rbp)
	movl	-56(%rbp), %eax
	leal	-1(%rax), %edx
	movq	-64(%rbp), %rax
	addq	$1, %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
.L317:
	movzbl	-296(%rbp), %edi
	movzbl	-292(%rbp), %r9d
	leaq	-112(%rbp), %rax
	movl	-20(%rbp), %r8d
	movl	-268(%rbp), %ecx
	movq	-64(%rbp), %rsi
	movq	-56(%rbp), %rdx
	subq	$8, %rsp
	pushq	%rdi
	movq	%rax, %rdi
	call	strconv__common_parse_uint
	addq	$16, %rsp
	movzbl	-112(%rbp), %eax
	testb	%al, %al
	je	.L318
	leaq	-112(%rbp), %rcx
	leaq	-256(%rbp), %rax
	movl	$40, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-264(%rbp), %rax
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L312
.L318:
	leaq	-112(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	cmpq	$0, -32(%rbp)
	jne	.L319
	movq	$0, -176(%rbp)
	leaq	-256(%rbp), %rcx
	leaq	-176(%rbp), %rax
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-264(%rbp), %rax
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L312
.L319:
	movl	-20(%rbp), %eax
	subl	$1, %eax
	movl	$1, %edx
	movl	%eax, %ecx
	salq	%cl, %rdx
	movq	%rdx, %rax
	movq	%rax, -40(%rbp)
	cmpb	$0, -21(%rbp)
	jne	.L320
	movq	-32(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L320
	movq	-40(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -184(%rbp)
	leaq	-256(%rbp), %rcx
	leaq	-184(%rbp), %rax
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-264(%rbp), %rax
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L312
.L320:
	cmpb	$0, -21(%rbp)
	je	.L321
	movq	-32(%rbp), %rax
	cmpq	%rax, -40(%rbp)
	jnb	.L321
	movq	-40(%rbp), %rax
	negq	%rax
	movq	%rax, -192(%rbp)
	leaq	-256(%rbp), %rcx
	leaq	-192(%rbp), %rax
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-264(%rbp), %rax
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L312
.L321:
	cmpb	$0, -21(%rbp)
	je	.L322
	movq	-32(%rbp), %rax
	negq	%rax
	movq	%rax, -200(%rbp)
	leaq	-160(%rbp), %rcx
	leaq	-200(%rbp), %rax
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	jmp	.L323
.L322:
	movq	-32(%rbp), %rax
	movq	%rax, -208(%rbp)
	leaq	-160(%rbp), %rcx
	leaq	-208(%rbp), %rax
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
.L323:
	movq	-264(%rbp), %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L312:
	movq	-264(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strconv__parse_int
strconv__parse_int:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, -12(%rbp)
	movl	%r8d, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	-16(%rbp), %edi
	movl	-12(%rbp), %ecx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rdx
	subq	$8, %rsp
	pushq	$1
	movl	$1, %r9d
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	strconv__common_parse_int
	addq	$16, %rsp
	movq	-8(%rbp), %rax
	leave
	ret
	.globl	strconv__Dec64_get_string_64
	.hidden	strconv__Dec64_get_string_64
strconv__Dec64_get_string_64:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r9
	movq	%r9, %rsi
	movq	%r10, %rdi
	movq	%rax, %rdi
	movq	%rsi, -128(%rbp)
	movq	%rdi, -120(%rbp)
	movl	%edx, %eax
	movl	%ecx, -136(%rbp)
	movl	%r8d, -140(%rbp)
	movb	%al, -132(%rbp)
	movl	-136(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -4(%rbp)
	movl	-140(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -48(%rbp)
	movq	-128(%rbp), %rax
	movq	%rax, -16(%rbp)
	movl	-120(%rbp), %eax
	movl	%eax, -20(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	strconv__dec_digits
	movl	%eax, -24(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, -52(%rbp)
	movl	$0, -28(%rbp)
	movl	-48(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle	.L328
	movl	-48(%rbp), %eax
	subl	-24(%rbp), %eax
	movl	%eax, -28(%rbp)
.L328:
	movl	-24(%rbp), %eax
	leal	8(%rax), %edx
	movl	-28(%rbp), %eax
	leal	(%rdx,%rax), %esi
	leaq	-112(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	__new_array_with_default
	movl	$0, -32(%rbp)
	cmpb	$0, -132(%rbp)
	je	.L329
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$45, (%rax)
	addl	$1, -32(%rbp)
.L329:
	movl	$0, -36(%rbp)
	cmpl	$1, -24(%rbp)
	jg	.L330
	movl	$1, -36(%rbp)
.L330:
	movl	-4(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jge	.L331
	movq	8+_const_strconv__ten_pow_table_64(%rip), %rdx
	movl	-24(%rbp), %eax
	subl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	subq	$8, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, -16(%rbp)
	movq	8+_const_strconv__ten_pow_table_64(%rip), %rdx
	movl	-24(%rbp), %eax
	subl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdi
	movq	-16(%rbp), %rax
	movl	$0, %edx
	divq	%rdi
	movq	%rax, -16(%rbp)
	movq	-128(%rbp), %rax
	movq	8+_const_strconv__ten_pow_table_64(%rip), %rcx
	movl	-24(%rbp), %edx
	subl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rcx, %rdx
	movq	(%rdx), %rsi
	movl	$0, %edx
	divq	%rsi
	cmpq	-16(%rbp), %rax
	jnb	.L332
	addl	$1, -20(%rbp)
	addl	$1, -4(%rbp)
.L332:
	movl	-4(%rbp), %eax
	movl	%eax, -24(%rbp)
.L331:
	movl	-32(%rbp), %edx
	movl	-24(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -56(%rbp)
	movl	$0, -40(%rbp)
.L335:
	movl	-24(%rbp), %eax
	subl	-36(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -40(%rbp)
	jge	.L349
	movq	-16(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$3, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	movl	%edx, %ecx
	movq	-104(%rbp), %rdx
	movl	-56(%rbp), %eax
	subl	-40(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leal	48(%rcx), %edx
	movb	%dl, (%rax)
	movq	-16(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -16(%rbp)
	addl	$1, -32(%rbp)
	addl	$1, -40(%rbp)
	jmp	.L335
.L349:
	nop
	cmpl	$0, -136(%rbp)
	jne	.L336
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-104(%rbp), %rax
	movl	-32(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	jmp	.L346
.L336:
	cmpl	$0, -24(%rbp)
	jle	.L338
	movq	-104(%rbp), %rdx
	movl	-56(%rbp), %eax
	subl	-40(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$46, (%rax)
	addl	$1, -40(%rbp)
	addl	$1, -32(%rbp)
.L338:
	movl	-56(%rbp), %eax
	subl	-40(%rbp), %eax
	testl	%eax, %eax
	js	.L342
	movq	-16(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$3, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	movl	%edx, %ecx
	movq	-104(%rbp), %rdx
	movl	-56(%rbp), %eax
	subl	-40(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leal	48(%rcx), %edx
	movb	%dl, (%rax)
	addl	$1, -32(%rbp)
.L342:
	cmpl	$0, -28(%rbp)
	jle	.L350
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$48, (%rax)
	addl	$1, -32(%rbp)
	subl	$1, -28(%rbp)
	jmp	.L342
.L350:
	nop
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$101, (%rax)
	addl	$1, -32(%rbp)
	movl	-20(%rbp), %edx
	movl	-52(%rbp), %eax
	addl	%edx, %eax
	subl	$1, %eax
	movl	%eax, -44(%rbp)
	cmpl	$0, -44(%rbp)
	jns	.L343
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$45, (%rax)
	addl	$1, -32(%rbp)
	negl	-44(%rbp)
	jmp	.L344
.L343:
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$43, (%rax)
	addl	$1, -32(%rbp)
.L344:
	movl	-44(%rbp), %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	movl	%eax, %ecx
	sarl	$2, %ecx
	movl	%edx, %eax
	sarl	$31, %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	%eax, %eax
	subl	%eax, %edx
	movl	%edx, -60(%rbp)
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	movl	%edx, %ecx
	sarl	$2, %ecx
	cltd
	movl	%ecx, %eax
	subl	%edx, %eax
	movl	%eax, -44(%rbp)
	movl	-44(%rbp), %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	movl	%eax, %ecx
	sarl	$2, %ecx
	movl	%edx, %eax
	sarl	$31, %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	%eax, %eax
	subl	%eax, %edx
	movl	%edx, -64(%rbp)
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	movl	%edx, %ecx
	sarl	$2, %ecx
	cltd
	movl	%ecx, %eax
	subl	%edx, %eax
	movl	%eax, -68(%rbp)
	cmpl	$0, -68(%rbp)
	jle	.L345
	movl	-68(%rbp), %eax
	movl	%eax, %ecx
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leal	48(%rcx), %edx
	movb	%dl, (%rax)
	addl	$1, -32(%rbp)
.L345:
	movl	-64(%rbp), %eax
	movl	%eax, %ecx
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leal	48(%rcx), %edx
	movb	%dl, (%rax)
	addl	$1, -32(%rbp)
	movl	-60(%rbp), %eax
	movl	%eax, %ecx
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leal	48(%rcx), %edx
	movb	%dl, (%rax)
	addl	$1, -32(%rbp)
	movq	-104(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-104(%rbp), %rax
	movl	-32(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
.L346:
	leave
	ret
	.globl	strconv__f64_to_decimal_exact_int
	.hidden	strconv__f64_to_decimal_exact_int
strconv__f64_to_decimal_exact_int:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$56, %rsp
	movq	%rdi, -152(%rbp)
	movq	%rsi, -160(%rbp)
	movq	%rdx, -168(%rbp)
	movq	$0, -48(%rbp)
	movl	$0, -40(%rbp)
	movq	-168(%rbp), %rax
	subq	$1023, %rax
	movq	%rax, -8(%rbp)
	movl	$52, %eax
	movl	%eax, %eax
	cmpq	-8(%rbp), %rax
	jnb	.L352
	movq	-152(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-152(%rbp), %rax
	movb	$0, 16(%rax)
	jmp	.L353
.L352:
	movl	$52, %eax
	movl	%eax, %eax
	subq	-8(%rbp), %rax
	movq	%rax, -16(%rbp)
	movabsq	$4503599627370496, %rax
	orq	-160(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %rax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movl	%edx, %ecx
	shrq	%cl, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	-16(%rbp), %rdx
	movl	%edx, %ecx
	salq	%cl, %rax
	cmpq	%rax, -24(%rbp)
	je	.L354
	movq	-152(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-152(%rbp), %rax
	movb	$0, 16(%rax)
	jmp	.L353
.L354:
	movq	-48(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$3, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	testq	%rdx, %rdx
	jne	.L359
	movq	-48(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -48(%rbp)
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -40(%rbp)
	jmp	.L354
.L359:
	nop
	movq	-152(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-152(%rbp), %rax
	movb	$1, 16(%rax)
.L353:
	movq	-152(%rbp), %rax
	leave
	ret
	.globl	strconv__f64_to_decimal
	.hidden	strconv__f64_to_decimal
strconv__f64_to_decimal:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$264, %rsp
	movq	%rdi, -280(%rbp)
	movq	%rsi, -288(%rbp)
	movl	$0, -36(%rbp)
	movq	$0, -48(%rbp)
	cmpq	$0, -288(%rbp)
	jne	.L361
	movl	$52, %eax
	movl	%eax, %edx
	movl	$-1024, %eax
	subl	%edx, %eax
	movl	%eax, -36(%rbp)
	movq	-280(%rbp), %rax
	movq	%rax, -48(%rbp)
	jmp	.L362
.L361:
	movq	-288(%rbp), %rax
	movl	$52, %edx
	subl	%edx, %eax
	subl	$1025, %eax
	movl	%eax, -36(%rbp)
	movl	$52, %eax
	movl	$1, %edx
	movl	%eax, %ecx
	salq	%cl, %rdx
	movq	%rdx, %rax
	orq	-280(%rbp), %rax
	movq	%rax, -48(%rbp)
.L362:
	movq	-48(%rbp), %rax
	andl	$1, %eax
	testq	%rax, %rax
	sete	%al
	movb	%al, -98(%rbp)
	movzbl	-98(%rbp), %eax
	movb	%al, -99(%rbp)
	movq	-48(%rbp), %rax
	salq	$2, %rax
	movq	%rax, -112(%rbp)
	cmpq	$0, -280(%rbp)
	jne	.L363
	cmpq	$1, -288(%rbp)
	ja	.L364
.L363:
	movl	$1, %eax
	jmp	.L365
.L364:
	movl	$0, %eax
.L365:
	movzbl	%al, %eax
	movl	%eax, %edi
	call	strconv__bool_to_u64
	movq	%rax, -120(%rbp)
	movq	$0, -56(%rbp)
	movq	$0, -64(%rbp)
	movq	$0, -72(%rbp)
	movl	$0, -76(%rbp)
	movb	$0, -77(%rbp)
	movb	$0, -78(%rbp)
	cmpl	$0, -36(%rbp)
	js	.L366
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	strconv__log10_pow2
	movl	%eax, %ebx
	cmpl	$3, -36(%rbp)
	setg	%al
	movzbl	%al, %eax
	movl	%eax, %edi
	call	strconv__bool_to_u32
	subl	%eax, %ebx
	movl	%ebx, %edx
	movl	%edx, -140(%rbp)
	movl	-140(%rbp), %eax
	movl	%eax, -76(%rbp)
	movl	-140(%rbp), %eax
	movl	%eax, %edi
	call	strconv__pow5_bits
	addl	$121, %eax
	movl	%eax, -144(%rbp)
	movl	-140(%rbp), %eax
	subl	-36(%rbp), %eax
	movl	%eax, %edx
	movl	-144(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -148(%rbp)
	movl	-140(%rbp), %esi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	_const_strconv__pow5_inv_split_64(%rip), %rax
	movq	8+_const_strconv__pow5_inv_split_64(%rip), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	16+_const_strconv__pow5_inv_split_64(%rip), %rax
	movq	24+_const_strconv__pow5_inv_split_64(%rip), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%esi, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -256(%rbp)
	movq	%rdx, -248(%rbp)
	movq	-48(%rbp), %rax
	leaq	0(,%rax,4), %rdi
	movl	-148(%rbp), %ecx
	movq	-256(%rbp), %rdx
	movq	-248(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdx
	call	strconv__mul_shift_64
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %rax
	salq	$2, %rax
	leaq	2(%rax), %rdi
	movl	-148(%rbp), %ecx
	movq	-256(%rbp), %rdx
	movq	-248(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdx
	call	strconv__mul_shift_64
	movq	%rax, -64(%rbp)
	movq	-48(%rbp), %rax
	salq	$2, %rax
	subq	-120(%rbp), %rax
	leaq	-1(%rax), %rdi
	movl	-148(%rbp), %ecx
	movq	-256(%rbp), %rdx
	movq	-248(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdx
	call	strconv__mul_shift_64
	movq	%rax, -72(%rbp)
	cmpl	$21, -140(%rbp)
	ja	.L370
	movq	-112(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$2, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	testq	%rdx, %rdx
	jne	.L368
	movl	-140(%rbp), %edx
	movq	-112(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strconv__multiple_of_power_of_five_64
	movb	%al, -78(%rbp)
	jmp	.L370
.L368:
	cmpb	$0, -99(%rbp)
	je	.L369
	movq	-112(%rbp), %rax
	subq	-120(%rbp), %rax
	leaq	-1(%rax), %rdx
	movl	-140(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	strconv__multiple_of_power_of_five_64
	movb	%al, -77(%rbp)
	jmp	.L370
.L369:
	movq	-112(%rbp), %rax
	leaq	2(%rax), %rdx
	movl	-140(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	strconv__multiple_of_power_of_five_64
	testb	%al, %al
	je	.L370
	subq	$1, -64(%rbp)
	jmp	.L370
.L366:
	movl	-36(%rbp), %eax
	negl	%eax
	movl	%eax, %edi
	call	strconv__log10_pow5
	movl	%eax, %ebx
	cmpl	$-1, -36(%rbp)
	setl	%al
	movzbl	%al, %eax
	movl	%eax, %edi
	call	strconv__bool_to_u32
	subl	%eax, %ebx
	movl	%ebx, %edx
	movl	%edx, -124(%rbp)
	movl	-124(%rbp), %edx
	movl	-36(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -76(%rbp)
	movl	-36(%rbp), %eax
	negl	%eax
	movl	%eax, %edx
	movl	-124(%rbp), %eax
	subl	%eax, %edx
	movl	%edx, -128(%rbp)
	movl	-128(%rbp), %eax
	movl	%eax, %edi
	call	strconv__pow5_bits
	subl	$121, %eax
	movl	%eax, -132(%rbp)
	movl	-124(%rbp), %eax
	subl	-132(%rbp), %eax
	movl	%eax, -136(%rbp)
	movl	-128(%rbp), %esi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	_const_strconv__pow5_split_64(%rip), %rax
	movq	8+_const_strconv__pow5_split_64(%rip), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	16+_const_strconv__pow5_split_64(%rip), %rax
	movq	24+_const_strconv__pow5_split_64(%rip), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%esi, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -272(%rbp)
	movq	%rdx, -264(%rbp)
	movq	-48(%rbp), %rax
	leaq	0(,%rax,4), %rdi
	movl	-136(%rbp), %ecx
	movq	-272(%rbp), %rdx
	movq	-264(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdx
	call	strconv__mul_shift_64
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %rax
	salq	$2, %rax
	leaq	2(%rax), %rdi
	movl	-136(%rbp), %ecx
	movq	-272(%rbp), %rdx
	movq	-264(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdx
	call	strconv__mul_shift_64
	movq	%rax, -64(%rbp)
	movq	-48(%rbp), %rax
	salq	$2, %rax
	subq	-120(%rbp), %rax
	leaq	-1(%rax), %rdi
	movl	-136(%rbp), %ecx
	movq	-272(%rbp), %rdx
	movq	-264(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdx
	call	strconv__mul_shift_64
	movq	%rax, -72(%rbp)
	cmpl	$1, -124(%rbp)
	ja	.L371
	movb	$1, -78(%rbp)
	cmpb	$0, -99(%rbp)
	je	.L372
	cmpq	$1, -120(%rbp)
	sete	%al
	movb	%al, -77(%rbp)
	jmp	.L370
.L372:
	subq	$1, -64(%rbp)
	jmp	.L370
.L371:
	cmpl	$62, -124(%rbp)
	ja	.L370
	movl	-124(%rbp), %eax
	leal	-1(%rax), %edx
	movq	-112(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strconv__multiple_of_power_of_two_64
	movb	%al, -78(%rbp)
.L370:
	movl	$0, -84(%rbp)
	movb	$0, -85(%rbp)
	movq	$0, -96(%rbp)
	cmpb	$0, -77(%rbp)
	jne	.L382
	cmpb	$0, -78(%rbp)
	je	.L375
.L382:
	movq	-64(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -160(%rbp)
	movq	-72(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -168(%rbp)
	movq	-160(%rbp), %rax
	cmpq	%rax, -168(%rbp)
	jnb	.L404
	movq	-72(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$3, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	movq	%rdx, -176(%rbp)
	movq	-56(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -184(%rbp)
	movq	-56(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$3, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	movq	%rdx, -192(%rbp)
	cmpb	$0, -77(%rbp)
	je	.L378
	cmpq	$0, -176(%rbp)
	jne	.L378
	movl	$1, %eax
	jmp	.L379
.L378:
	movl	$0, %eax
.L379:
	movb	%al, -77(%rbp)
	cmpb	$0, -78(%rbp)
	je	.L380
	cmpb	$0, -85(%rbp)
	jne	.L380
	movl	$1, %eax
	jmp	.L381
.L380:
	movl	$0, %eax
.L381:
	movb	%al, -78(%rbp)
	movq	-192(%rbp), %rax
	movb	%al, -85(%rbp)
	movq	-184(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-160(%rbp), %rax
	movq	%rax, -64(%rbp)
	movq	-168(%rbp), %rax
	movq	%rax, -72(%rbp)
	addl	$1, -84(%rbp)
	jmp	.L382
.L404:
	nop
	cmpb	$0, -77(%rbp)
	je	.L383
.L387:
	movq	-72(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -200(%rbp)
	movq	-72(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$3, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	movq	%rdx, -208(%rbp)
	cmpq	$0, -208(%rbp)
	jne	.L405
	movq	-64(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -216(%rbp)
	movq	-56(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -224(%rbp)
	movq	-56(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$3, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	movq	%rdx, -232(%rbp)
	cmpb	$0, -78(%rbp)
	je	.L385
	cmpb	$0, -85(%rbp)
	jne	.L385
	movl	$1, %eax
	jmp	.L386
.L385:
	movl	$0, %eax
.L386:
	movb	%al, -78(%rbp)
	movq	-232(%rbp), %rax
	movb	%al, -85(%rbp)
	movq	-224(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-216(%rbp), %rax
	movq	%rax, -64(%rbp)
	movq	-200(%rbp), %rax
	movq	%rax, -72(%rbp)
	addl	$1, -84(%rbp)
	jmp	.L387
.L405:
	nop
.L383:
	cmpb	$0, -78(%rbp)
	je	.L388
	cmpb	$5, -85(%rbp)
	jne	.L388
	movq	-56(%rbp), %rax
	andl	$1, %eax
	testq	%rax, %rax
	jne	.L388
	movb	$4, -85(%rbp)
.L388:
	movq	-56(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-56(%rbp), %rax
	cmpq	-72(%rbp), %rax
	jne	.L389
	cmpb	$0, -99(%rbp)
	je	.L390
	cmpb	$0, -77(%rbp)
	je	.L390
.L389:
	cmpb	$4, -85(%rbp)
	jbe	.L406
.L390:
	addq	$1, -96(%rbp)
	jmp	.L406
.L375:
	movb	$0, -97(%rbp)
.L395:
	movq	-64(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rcx
	shrq	$2, %rcx
	movq	-72(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	cmpq	%rcx, %rax
	jb	.L393
	jmp	.L394
.L393:
	movq	-56(%rbp), %rcx
	movq	%rcx, %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	shrq	$2, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	cmpq	$49, %rdx
	seta	%al
	movb	%al, -97(%rbp)
	movq	-56(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, -56(%rbp)
	movq	-64(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, -64(%rbp)
	movq	-72(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, -72(%rbp)
	addl	$2, -84(%rbp)
	jmp	.L395
.L394:
	movq	-64(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rcx
	shrq	$3, %rcx
	movq	-72(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	cmpq	%rcx, %rax
	jnb	.L407
	movq	-56(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$3, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	cmpq	$4, %rdx
	seta	%al
	movb	%al, -97(%rbp)
	movq	-56(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -56(%rbp)
	movq	-64(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -64(%rbp)
	movq	-72(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, -72(%rbp)
	addl	$1, -84(%rbp)
	jmp	.L394
.L407:
	nop
	movq	-56(%rbp), %rax
	cmpq	-72(%rbp), %rax
	je	.L398
	cmpb	$0, -97(%rbp)
	je	.L399
.L398:
	movl	$1, %eax
	jmp	.L400
.L399:
	movl	$0, %eax
.L400:
	movzbl	%al, %eax
	movl	%eax, %edi
	call	strconv__bool_to_u64
	movq	-56(%rbp), %rdx
	addq	%rdx, %rax
	movq	%rax, -96(%rbp)
	jmp	.L392
.L406:
	nop
.L392:
	movl	-76(%rbp), %edx
	movl	-84(%rbp), %eax
	addl	%edx, %eax
	movq	-96(%rbp), %r12
	movl	%eax, %edx
	movq	%r13, %rcx
	movabsq	$-4294967296, %rax
	andq	%rcx, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rax
	movq	%r13, %rdx
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	strconv__f64_to_str
strconv__f64_to_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -104(%rbp)
	movl	%esi, -108(%rbp)
	movq	$0, -48(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -8(%rbp)
	movl	$52, %edx
	movl	$11, %eax
	addl	%edx, %eax
	movq	-8(%rbp), %rdx
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	testq	%rax, %rax
	setne	%al
	movb	%al, -9(%rbp)
	movl	$52, %eax
	movq	$-1, %rdx
	movl	%eax, %ecx
	salq	%cl, %rdx
	movq	%rdx, %rax
	notq	%rax
	andq	-8(%rbp), %rax
	movq	%rax, -24(%rbp)
	movl	$52, %edx
	movq	-8(%rbp), %rax
	movl	%edx, %ecx
	shrq	%cl, %rax
	movq	%rax, %rdx
	movl	$11, %eax
	movq	$-1, %rsi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	notq	%rax
	andq	%rdx, %rax
	movq	%rax, -32(%rbp)
	cmpq	$2047, -32(%rbp)
	je	.L409
	cmpq	$0, -32(%rbp)
	jne	.L410
	cmpq	$0, -24(%rbp)
	jne	.L410
.L409:
	cmpq	$0, -24(%rbp)
	sete	%al
	movzbl	%al, %edx
	cmpq	$0, -32(%rbp)
	sete	%al
	movzbl	%al, %ecx
	movzbl	-9(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	strconv__get_string_special
	jmp	.L413
.L410:
	leaq	-80(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strconv__f64_to_decimal_exact_int
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movzbl	-64(%rbp), %eax
	movb	%al, -33(%rbp)
	cmpb	$0, -33(%rbp)
	jne	.L412
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strconv__f64_to_decimal
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
.L412:
	movzbl	-9(%rbp), %edx
	movl	-108(%rbp), %ecx
	movq	-96(%rbp), %rsi
	movq	-88(%rbp), %rax
	movl	$0, %r8d
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	strconv__Dec64_get_string_64
.L413:
	leave
	ret
	.globl	strconv__f64_to_str_pad
strconv__f64_to_str_pad:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -104(%rbp)
	movl	%esi, -108(%rbp)
	movq	$0, -48(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -8(%rbp)
	movl	$52, %edx
	movl	$11, %eax
	addl	%edx, %eax
	movq	-8(%rbp), %rdx
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	testq	%rax, %rax
	setne	%al
	movb	%al, -9(%rbp)
	movl	$52, %eax
	movq	$-1, %rdx
	movl	%eax, %ecx
	salq	%cl, %rdx
	movq	%rdx, %rax
	notq	%rax
	andq	-8(%rbp), %rax
	movq	%rax, -24(%rbp)
	movl	$52, %edx
	movq	-8(%rbp), %rax
	movl	%edx, %ecx
	shrq	%cl, %rax
	movq	%rax, %rdx
	movl	$11, %eax
	movq	$-1, %rsi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	notq	%rax
	andq	%rdx, %rax
	movq	%rax, -32(%rbp)
	cmpq	$2047, -32(%rbp)
	je	.L415
	cmpq	$0, -32(%rbp)
	jne	.L416
	cmpq	$0, -24(%rbp)
	jne	.L416
.L415:
	cmpq	$0, -24(%rbp)
	sete	%al
	movzbl	%al, %edx
	cmpq	$0, -32(%rbp)
	sete	%al
	movzbl	%al, %ecx
	movzbl	-9(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	strconv__get_string_special
	jmp	.L419
.L416:
	leaq	-80(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strconv__f64_to_decimal_exact_int
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movzbl	-64(%rbp), %eax
	movb	%al, -33(%rbp)
	cmpb	$0, -33(%rbp)
	jne	.L418
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strconv__f64_to_decimal
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
.L418:
	movzbl	-9(%rbp), %edx
	movl	-108(%rbp), %edi
	movl	-108(%rbp), %ecx
	movq	-96(%rbp), %rsi
	movq	-88(%rbp), %rax
	movl	%edi, %r8d
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	strconv__Dec64_get_string_64
.L419:
	leave
	ret
	.globl	strconv__format_str_sb
strconv__format_str_sb:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rax
	movq	%rax, %rbx
	movq	%rcx, -48(%rbp)
	movq	%rbx, -40(%rbp)
	movq	%rdx, -56(%rbp)
	movl	20(%rbp), %eax
	testl	%eax, %eax
	jg	.L421
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	jmp	.L420
.L421:
	movl	20(%rbp), %ebx
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	utf8_str_visible_length
	subl	%eax, %ebx
	movl	%ebx, %edx
	movl	%edx, -28(%rbp)
	cmpl	$0, -28(%rbp)
	jg	.L423
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	jmp	.L420
.L423:
	movl	32(%rbp), %eax
	testl	%eax, %eax
	jne	.L424
	movl	$0, -20(%rbp)
	jmp	.L425
.L426:
	movzbl	16(%rbp), %eax
	movzbl	%al, %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	addl	$1, -20(%rbp)
.L425:
	movl	-20(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L426
.L424:
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	movl	32(%rbp), %eax
	cmpl	$1, %eax
	jne	.L420
	movl	$0, -24(%rbp)
	jmp	.L427
.L428:
	movzbl	16(%rbp), %eax
	movzbl	%al, %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	addl	$1, -24(%rbp)
.L427:
	movl	-24(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L428
.L420:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strconv__format_dec_sb
strconv__format_dec_sb:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	strconv__dec_digits
	movl	%eax, -40(%rbp)
	movzbl	28(%rbp), %eax
	testb	%al, %al
	je	.L430
	movzbl	29(%rbp), %eax
	testb	%al, %al
	je	.L431
.L430:
	movl	$1, %eax
	jmp	.L432
.L431:
	movl	$0, %eax
.L432:
	movl	%eax, -44(%rbp)
	movl	-44(%rbp), %edx
	movl	-40(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -48(%rbp)
	movl	20(%rbp), %eax
	subl	-48(%rbp), %eax
	movl	%eax, -52(%rbp)
	movb	$0, -1(%rbp)
	movl	32(%rbp), %eax
	testl	%eax, %eax
	jne	.L433
	movzbl	16(%rbp), %eax
	cmpb	$48, %al
	jne	.L434
	movzbl	28(%rbp), %eax
	testb	%al, %al
	je	.L435
	movzbl	29(%rbp), %eax
	testb	%al, %al
	je	.L434
	movq	-112(%rbp), %rax
	movl	$43, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	movb	$1, -1(%rbp)
	jmp	.L434
.L435:
	movq	-112(%rbp), %rax
	movl	$45, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	movb	$1, -1(%rbp)
.L434:
	movl	$0, -8(%rbp)
	jmp	.L436
.L437:
	movzbl	16(%rbp), %eax
	movzbl	%al, %edx
	movq	-112(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	addl	$1, -8(%rbp)
.L436:
	movl	-8(%rbp), %eax
	cmpl	-52(%rbp), %eax
	jl	.L437
.L433:
	cmpb	$0, -1(%rbp)
	jne	.L438
	movzbl	28(%rbp), %eax
	testb	%al, %al
	je	.L439
	movzbl	29(%rbp), %eax
	testb	%al, %al
	je	.L438
	movq	-112(%rbp), %rax
	movl	$43, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	jmp	.L438
.L439:
	movq	-112(%rbp), %rax
	movl	$45, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
.L438:
	movq	$0, -96(%rbp)
	movq	$0, -88(%rbp)
	movq	$0, -80(%rbp)
	movq	$0, -72(%rbp)
	movl	$20, -12(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	$0, -32(%rbp)
	cmpq	$0, -24(%rbp)
	je	.L440
.L443:
	cmpq	$0, -24(%rbp)
	je	.L451
	movq	-24(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	subq	%rdx, %rax
	addq	%rax, %rax
	movq	%rax, -32(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	_const_strconv__digit_pairs(%rip), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movl	-12(%rbp), %eax
	cltq
	movb	%dl, -96(%rbp,%rax)
	subl	$1, -12(%rbp)
	addq	$1, -32(%rbp)
	movq	_const_strconv__digit_pairs(%rip), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movl	-12(%rbp), %eax
	cltq
	movb	%dl, -96(%rbp,%rax)
	subl	$1, -12(%rbp)
	jmp	.L443
.L451:
	nop
	addl	$1, -12(%rbp)
	cmpq	$19, -32(%rbp)
	ja	.L444
	addl	$1, -12(%rbp)
.L444:
	leaq	-96(%rbp), %rdx
	movl	-12(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rcx
	movl	-40(%rbp), %edx
	movq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_ptr
	jmp	.L445
.L440:
	movq	-112(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
.L445:
	movl	32(%rbp), %eax
	cmpl	$1, %eax
	jne	.L452
	movl	$0, -36(%rbp)
	jmp	.L447
.L448:
	movzbl	16(%rbp), %eax
	movzbl	%al, %edx
	movq	-112(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	addl	$1, -36(%rbp)
.L447:
	movl	-36(%rbp), %eax
	cmpl	-52(%rbp), %eax
	jl	.L448
	nop
.L452:
	nop
	leave
	ret
	.section	.rodata, "a"
.LC40:
	.string	"[Float conversion error!!]"
	.text
	.globl	strconv__f64_to_str_lnd1
strconv__f64_to_str_lnd1:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$232, %rsp
	movq	%rdi, -248(%rbp)
	movl	%esi, -252(%rbp)
	movq	8+_const_strconv__dec_round(%rip), %rax
	movl	-252(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-248(%rbp), %rax
	addq	%rdx, %rax
	movl	$18, %esi
	movq	%rax, %rdi
	call	strconv__f64_to_str
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movl	-104(%rbp), %eax
	cmpl	$2, %eax
	jle	.L454
	movq	-112(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$110, %al
	je	.L455
	movq	-112(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$105, %al
	jne	.L454
.L455:
	movq	-112(%rbp), %r12
	movq	-104(%rbp), %r13
	jmp	.L456
.L454:
	movb	$0, -85(%rbp)
	movl	$1, -36(%rbp)
	movq	$0, -144(%rbp)
	movq	$0, -136(%rbp)
	movq	$0, -134(%rbp)
	movq	$0, -126(%rbp)
	movl	$1, -40(%rbp)
	movl	$0, -44(%rbp)
	movl	$0, -48(%rbp)
	movl	$0, -52(%rbp)
	movl	$1, -56(%rbp)
	movl	$-1, -60(%rbp)
	movl	$0, -64(%rbp)
	jmp	.L457
.L467:
	movq	-112(%rbp), %rdx
	movl	-64(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -86(%rbp)
	cmpb	$45, -86(%rbp)
	jne	.L458
	movl	$-1, -36(%rbp)
	addl	$1, -44(%rbp)
	jmp	.L459
.L458:
	cmpb	$43, -86(%rbp)
	jne	.L460
	movl	$1, -36(%rbp)
	addl	$1, -44(%rbp)
	jmp	.L459
.L460:
	cmpb	$47, -86(%rbp)
	jbe	.L461
	cmpb	$57, -86(%rbp)
	ja	.L461
	movl	-48(%rbp), %eax
	cltq
	movzbl	-86(%rbp), %edx
	movb	%dl, -144(%rbp,%rax)
	addl	$1, -48(%rbp)
	addl	$1, -44(%rbp)
	jmp	.L459
.L461:
	cmpb	$46, -86(%rbp)
	jne	.L462
	cmpl	$0, -36(%rbp)
	jle	.L463
	movl	-44(%rbp), %eax
	movl	%eax, -40(%rbp)
	jmp	.L464
.L463:
	movl	-44(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -40(%rbp)
.L464:
	addl	$1, -44(%rbp)
	jmp	.L459
.L462:
	cmpb	$101, -86(%rbp)
	jne	.L465
	addl	$1, -44(%rbp)
	jmp	.L466
.L465:
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	leaq	.LC40(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$26, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	jmp	.L456
.L459:
	addl	$1, -64(%rbp)
.L457:
	movl	-104(%rbp), %eax
	cmpl	%eax, -64(%rbp)
	jl	.L467
.L466:
	movl	-48(%rbp), %eax
	cltq
	movb	$0, -144(%rbp,%rax)
	movq	-112(%rbp), %rdx
	movl	-44(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	jne	.L468
	movl	$-1, -56(%rbp)
	addl	$1, -44(%rbp)
	jmp	.L469
.L468:
	movq	-112(%rbp), %rdx
	movl	-44(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$43, %al
	jne	.L469
	movl	$1, -56(%rbp)
	addl	$1, -44(%rbp)
.L469:
	movl	-44(%rbp), %eax
	movl	%eax, -68(%rbp)
.L472:
	movl	-104(%rbp), %eax
	cmpl	%eax, -68(%rbp)
	jge	.L502
	movl	-52(%rbp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %ecx
	movq	-112(%rbp), %rdx
	movl	-68(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	subl	$48, %eax
	addl	%ecx, %eax
	movl	%eax, -52(%rbp)
	addl	$1, -68(%rbp)
	jmp	.L472
.L502:
	nop
	movb	$0, -145(%rbp)
	movl	-52(%rbp), %eax
	leal	32(%rax), %esi
	leaq	-240(%rbp), %rax
	leaq	-145(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	__new_array_with_default
	movl	$0, -72(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	cmpl	$1, -36(%rbp)
	jne	.L473
	cmpb	$0, -85(%rbp)
	je	.L474
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$43, (%rax)
	addl	$1, -72(%rbp)
	jmp	.L474
.L473:
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$45, (%rax)
	addl	$1, -72(%rbp)
.L474:
	movl	$0, -44(%rbp)
	cmpl	$0, -56(%rbp)
	js	.L475
.L480:
	movl	-44(%rbp), %eax
	cltq
	movzbl	-144(%rbp,%rax), %eax
	testb	%al, %al
	jne	.L476
	jmp	.L477
.L476:
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rax, %rdx
	movl	-44(%rbp), %eax
	cltq
	movzbl	-144(%rbp,%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -72(%rbp)
	addl	$1, -44(%rbp)
	movl	-44(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl	.L480
	cmpl	$0, -52(%rbp)
	js	.L480
	cmpl	$0, -52(%rbp)
	jne	.L479
	movl	-72(%rbp), %eax
	movl	%eax, -60(%rbp)
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$46, (%rax)
	addl	$1, -72(%rbp)
.L479:
	subl	$1, -52(%rbp)
	jmp	.L480
.L477:
	cmpl	$0, -52(%rbp)
	js	.L503
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$48, (%rax)
	addl	$1, -72(%rbp)
	subl	$1, -52(%rbp)
	jmp	.L477
.L475:
	movb	$1, -73(%rbp)
.L487:
	cmpl	$0, -52(%rbp)
	jg	.L484
	jmp	.L485
.L484:
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$48, (%rax)
	addl	$1, -72(%rbp)
	subl	$1, -52(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L487
	movl	-72(%rbp), %eax
	movl	%eax, -60(%rbp)
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$46, (%rax)
	addl	$1, -72(%rbp)
	movb	$0, -73(%rbp)
	jmp	.L487
.L485:
	movl	-44(%rbp), %eax
	cltq
	movzbl	-144(%rbp,%rax), %eax
	testb	%al, %al
	je	.L504
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rax, %rdx
	movl	-44(%rbp), %eax
	cltq
	movzbl	-144(%rbp,%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -72(%rbp)
	addl	$1, -44(%rbp)
	jmp	.L485
.L503:
	nop
	jmp	.L483
.L504:
	nop
.L483:
	cmpl	$0, -252(%rbp)
	jg	.L489
	cmpl	$0, -60(%rbp)
	jns	.L490
	movl	-44(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -60(%rbp)
.L490:
	movq	-232(%rbp), %rax
	movl	-60(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -176(%rbp)
	movq	%rdx, -168(%rbp)
	leaq	-240(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
	movq	-176(%rbp), %r12
	movq	-168(%rbp), %r13
	jmp	.L456
.L489:
	cmpl	$0, -60(%rbp)
	js	.L491
	movl	-60(%rbp), %edx
	movl	-252(%rbp), %eax
	addl	%edx, %eax
	addl	$1, %eax
	movl	%eax, -72(%rbp)
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	$1, -80(%rbp)
	jmp	.L492
.L494:
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	subl	-80(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L493
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	subl	-80(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$48, (%rax)
.L493:
	addl	$1, -80(%rbp)
.L492:
	movl	-252(%rbp), %eax
	cmpl	-80(%rbp), %eax
	jge	.L494
	movq	-232(%rbp), %rax
	movl	-72(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -192(%rbp)
	movq	%rdx, -184(%rbp)
	leaq	-240(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
	movq	-192(%rbp), %r12
	movq	-184(%rbp), %r13
	jmp	.L456
.L491:
	cmpl	$0, -252(%rbp)
	jle	.L495
	movl	$0, -84(%rbp)
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$46, (%rax)
	addl	$1, -72(%rbp)
.L498:
	movl	-84(%rbp), %eax
	cmpl	-252(%rbp), %eax
	jge	.L505
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$48, (%rax)
	addl	$1, -72(%rbp)
	addl	$1, -84(%rbp)
	jmp	.L498
.L505:
	nop
	movq	-232(%rbp), %rdx
	movl	-72(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
.L495:
	movq	-232(%rbp), %rax
	movl	-72(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
	leaq	-240(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
	movq	-208(%rbp), %r12
	movq	-200(%rbp), %r13
.L456:
	movq	%r12, %rax
	movq	%r13, %rdx
	addq	$232, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	strconv__format_fl
strconv__format_fl:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$168, %rsp
	movq	%rdi, -168(%rbp)
	movl	24(%rbp), %edx
	movq	-168(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strconv__f64_to_str_lnd1
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-64(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$91, %al
	jne	.L507
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	jmp	.L508
.L507:
	movzbl	36(%rbp), %eax
	testb	%al, %al
	je	.L509
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	strconv__remove_tail_zeros
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L509:
	movq	$0, -160(%rbp)
	movq	$0, -152(%rbp)
	movq	$0, -144(%rbp)
	movq	$0, -136(%rbp)
	movq	$0, -128(%rbp)
	movq	$0, -120(%rbp)
	movq	$0, -112(%rbp)
	movq	$0, -104(%rbp)
	movl	$0, -20(%rbp)
	movl	$0, -24(%rbp)
	movl	$0, -28(%rbp)
	movzbl	16(%rbp), %eax
	cmpb	$48, %al
	jne	.L510
	movzbl	28(%rbp), %eax
	testb	%al, %al
	je	.L511
	movzbl	29(%rbp), %eax
	testb	%al, %al
	je	.L512
	movl	-24(%rbp), %eax
	cltq
	movb	$43, -128(%rbp,%rax)
	addl	$1, -24(%rbp)
	movl	$-1, -28(%rbp)
	jmp	.L512
.L511:
	movl	-24(%rbp), %eax
	cltq
	movb	$45, -128(%rbp,%rax)
	addl	$1, -24(%rbp)
	movl	$-1, -28(%rbp)
	jmp	.L512
.L510:
	movzbl	28(%rbp), %eax
	testb	%al, %al
	je	.L513
	movzbl	29(%rbp), %eax
	testb	%al, %al
	je	.L512
	movl	-20(%rbp), %eax
	cltq
	movb	$43, -160(%rbp,%rax)
	addl	$1, -20(%rbp)
	jmp	.L512
.L513:
	movl	-20(%rbp), %eax
	cltq
	movb	$45, -160(%rbp,%rax)
	addl	$1, -20(%rbp)
.L512:
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	leaq	-160(%rbp), %rsi
	movl	-20(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	%rsi, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	movl	-56(%rbp), %eax
	addl	%eax, -20(%rbp)
	movl	20(%rbp), %eax
	subl	-20(%rbp), %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -40(%rbp)
	movl	32(%rbp), %eax
	testl	%eax, %eax
	jne	.L514
	movl	$0, -32(%rbp)
	jmp	.L515
.L516:
	movzbl	16(%rbp), %edx
	movl	-24(%rbp), %eax
	cltq
	movb	%dl, -128(%rbp,%rax)
	addl	$1, -24(%rbp)
	addl	$1, -32(%rbp)
.L515:
	movl	-32(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl	.L516
.L514:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	leaq	-128(%rbp), %rcx
	movl	-24(%rbp), %eax
	cltq
	addq	%rax, %rcx
	leaq	-160(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	movl	-20(%rbp), %eax
	addl	%eax, -24(%rbp)
	movl	32(%rbp), %eax
	cmpl	$1, %eax
	jne	.L517
	movl	$0, -36(%rbp)
	jmp	.L518
.L519:
	movzbl	16(%rbp), %edx
	movl	-24(%rbp), %eax
	cltq
	movb	%dl, -128(%rbp,%rax)
	addl	$1, -24(%rbp)
	addl	$1, -36(%rbp)
.L518:
	movl	-36(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl	.L519
.L517:
	movl	-24(%rbp), %eax
	cltq
	movb	$0, -128(%rbp,%rax)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	tos_clone
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
.L508:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strconv__format_es
strconv__format_es:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$168, %rsp
	movq	%rdi, -168(%rbp)
	movl	24(%rbp), %edx
	movq	-168(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strconv__f64_to_str_pad
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movzbl	36(%rbp), %eax
	testb	%al, %al
	je	.L522
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	strconv__remove_tail_zeros
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L522:
	movq	$0, -160(%rbp)
	movq	$0, -152(%rbp)
	movq	$0, -144(%rbp)
	movq	$0, -136(%rbp)
	movq	$0, -128(%rbp)
	movq	$0, -120(%rbp)
	movq	$0, -112(%rbp)
	movq	$0, -104(%rbp)
	movl	$0, -20(%rbp)
	movl	$0, -24(%rbp)
	movl	$0, -28(%rbp)
	movzbl	16(%rbp), %eax
	cmpb	$48, %al
	jne	.L523
	movzbl	28(%rbp), %eax
	testb	%al, %al
	je	.L524
	movzbl	29(%rbp), %eax
	testb	%al, %al
	je	.L525
	movl	-24(%rbp), %eax
	cltq
	movb	$43, -128(%rbp,%rax)
	addl	$1, -24(%rbp)
	movl	$-1, -28(%rbp)
	jmp	.L525
.L524:
	movl	-24(%rbp), %eax
	cltq
	movb	$45, -128(%rbp,%rax)
	addl	$1, -24(%rbp)
	movl	$-1, -28(%rbp)
	jmp	.L525
.L523:
	movzbl	28(%rbp), %eax
	testb	%al, %al
	je	.L526
	movzbl	29(%rbp), %eax
	testb	%al, %al
	je	.L525
	movl	-20(%rbp), %eax
	cltq
	movb	$43, -160(%rbp,%rax)
	addl	$1, -20(%rbp)
	jmp	.L525
.L526:
	movl	-20(%rbp), %eax
	cltq
	movb	$45, -160(%rbp,%rax)
	addl	$1, -20(%rbp)
.L525:
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	leaq	-160(%rbp), %rsi
	movl	-20(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	%rsi, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	movl	-56(%rbp), %eax
	addl	%eax, -20(%rbp)
	movl	20(%rbp), %eax
	subl	-20(%rbp), %eax
	movl	%eax, %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -40(%rbp)
	movl	32(%rbp), %eax
	testl	%eax, %eax
	jne	.L527
	movl	$0, -32(%rbp)
	jmp	.L528
.L529:
	movzbl	16(%rbp), %edx
	movl	-24(%rbp), %eax
	cltq
	movb	%dl, -128(%rbp,%rax)
	addl	$1, -24(%rbp)
	addl	$1, -32(%rbp)
.L528:
	movl	-32(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl	.L529
.L527:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	leaq	-128(%rbp), %rcx
	movl	-24(%rbp), %eax
	cltq
	addq	%rax, %rcx
	leaq	-160(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	movl	-20(%rbp), %eax
	addl	%eax, -24(%rbp)
	movl	32(%rbp), %eax
	cmpl	$1, %eax
	jne	.L530
	movl	$0, -36(%rbp)
	jmp	.L531
.L532:
	movzbl	16(%rbp), %edx
	movl	-24(%rbp), %eax
	cltq
	movb	%dl, -128(%rbp,%rax)
	addl	$1, -24(%rbp)
	addl	$1, -36(%rbp)
.L531:
	movl	-36(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl	.L532
.L530:
	movl	-24(%rbp), %eax
	cltq
	movb	$0, -128(%rbp,%rax)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	tos_clone
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strconv__remove_tail_zeros
strconv__remove_tail_zeros:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	-56(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -48(%rbp)
	movl	$0, -20(%rbp)
	movl	$0, -24(%rbp)
.L537:
	movl	-56(%rbp), %eax
	cmpl	%eax, -24(%rbp)
	jge	.L535
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	je	.L535
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$43, %al
	je	.L535
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	ja	.L536
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	ja	.L535
.L536:
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -24(%rbp)
	addl	$1, -20(%rbp)
	jmp	.L537
.L535:
	movl	-56(%rbp), %eax
	cmpl	%eax, -24(%rbp)
	jge	.L541
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	je	.L539
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$43, %al
	jne	.L541
.L539:
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -24(%rbp)
	addl	$1, -20(%rbp)
.L541:
	movl	-56(%rbp), %eax
	cmpl	%eax, -24(%rbp)
	jge	.L540
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jbe	.L540
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	ja	.L540
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -24(%rbp)
	addl	$1, -20(%rbp)
	jmp	.L541
.L540:
	movl	-56(%rbp), %eax
	cmpl	%eax, -24(%rbp)
	jge	.L542
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$46, %al
	jne	.L542
	movl	-24(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -28(%rbp)
	movl	$0, -32(%rbp)
.L544:
	movl	-56(%rbp), %eax
	cmpl	%eax, -28(%rbp)
	jge	.L543
	movq	-64(%rbp), %rdx
	movl	-28(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jbe	.L543
	movq	-64(%rbp), %rdx
	movl	-28(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	ja	.L543
	movq	-64(%rbp), %rdx
	movl	-28(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	subl	$48, %eax
	addl	%eax, -32(%rbp)
	addl	$1, -28(%rbp)
	jmp	.L544
.L543:
	cmpl	$0, -32(%rbp)
	jle	.L545
	movl	-24(%rbp), %eax
	movl	%eax, -36(%rbp)
	jmp	.L546
.L547:
	movq	-64(%rbp), %rdx
	movl	-36(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -20(%rbp)
	addl	$1, -36(%rbp)
.L546:
	movl	-36(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L547
.L545:
	movl	-28(%rbp), %eax
	movl	%eax, -24(%rbp)
.L542:
	movl	-56(%rbp), %eax
	cmpl	%eax, -24(%rbp)
	jge	.L548
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$46, %al
	je	.L548
.L550:
	movq	-64(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -24(%rbp)
	addl	$1, -20(%rbp)
	movl	-56(%rbp), %eax
	cmpl	%eax, -24(%rbp)
	jge	.L552
	jmp	.L550
.L552:
	nop
.L548:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-20(%rbp), %edx
	movq	-48(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC41:
	.string	"invalid radix: "
.LC42:
	.string	" . It should be => 2 and <= 36"
.LC43:
	.string	"0"
.LC44:
	.string	"-"
	.text
	.globl	strconv__format_int
strconv__format_int:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$184, %rsp
	movq	%rdi, -200(%rbp)
	movl	%esi, -204(%rbp)
	cmpl	$1, -204(%rbp)
	jle	.L554
	cmpl	$36, -204(%rbp)
	jle	.L555
.L554:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -160(%rbp)
	movaps	%xmm0, -144(%rbp)
	movaps	%xmm0, -128(%rbp)
	leaq	.LC41(%rip), %rax
	movq	%rax, -192(%rbp)
	movl	$15, -184(%rbp)
	movl	$1, -180(%rbp)
	movl	$65031, -176(%rbp)
	movl	-204(%rbp), %eax
	movl	%eax, -168(%rbp)
	leaq	.LC42(%rip), %rax
	movq	%rax, -152(%rbp)
	movl	$30, -144(%rbp)
	movl	$1, -140(%rbp)
	leaq	-192(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L555:
	cmpq	$0, -200(%rbp)
	jne	.L556
	leaq	.LC43(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$1, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L557
.L556:
	movq	-200(%rbp), %rax
	movq	%rax, -40(%rbp)
	movb	$0, -41(%rbp)
	cmpq	$0, -200(%rbp)
	jns	.L558
	movb	$1, -41(%rbp)
	negq	-40(%rbp)
.L558:
	leaq	.LC34(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$0, -56(%rbp)
	movl	$1, -52(%rbp)
.L562:
	cmpq	$0, -40(%rbp)
	jne	.L559
	cmpb	$0, -41(%rbp)
	jne	.L560
	jmp	.L564
.L559:
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movl	-204(%rbp), %eax
	movslq	%eax, %rcx
	movq	-40(%rbp), %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	movl	%eax, -48(%rbp)
	movq	_const_strconv__base_digits(%rip), %rdx
	movl	-48(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %edi
	call	u8_ascii_str
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	-96(%rbp), %rdi
	movq	-88(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__plus
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	movl	-204(%rbp), %eax
	movslq	%eax, %rbx
	movq	-40(%rbp), %rax
	cqto
	idivq	%rbx
	movq	%rax, -40(%rbp)
	jmp	.L562
.L560:
	leaq	.LC44(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rsi, %rdi
	movq	%rbx, %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__plus
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	jmp	.L557
.L564:
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
.L557:
	addq	$184, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	strconv__format_uint
strconv__format_uint:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$168, %rsp
	movq	%rdi, -168(%rbp)
	movl	%esi, -172(%rbp)
	cmpl	$1, -172(%rbp)
	jle	.L566
	cmpl	$36, -172(%rbp)
	jle	.L567
.L566:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -160(%rbp)
	movaps	%xmm0, -144(%rbp)
	movaps	%xmm0, -128(%rbp)
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	leaq	.LC41(%rip), %rax
	movq	%rax, -160(%rbp)
	movl	$15, -152(%rbp)
	movl	$1, -148(%rbp)
	movl	$65031, -144(%rbp)
	movl	-172(%rbp), %eax
	movl	%eax, -136(%rbp)
	leaq	.LC42(%rip), %rax
	movq	%rax, -120(%rbp)
	movl	$30, -112(%rbp)
	movl	$1, -108(%rbp)
	leaq	-160(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L567:
	cmpq	$0, -168(%rbp)
	jne	.L568
	leaq	.LC43(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$1, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L569
.L568:
	movq	-168(%rbp), %rax
	movq	%rax, -24(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$0, -40(%rbp)
	movl	$1, -36(%rbp)
	movl	-172(%rbp), %eax
	cltq
	movq	%rax, -32(%rbp)
.L571:
	cmpq	$0, -24(%rbp)
	jne	.L570
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	jmp	.L569
.L570:
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	_const_strconv__base_digits(%rip), %rcx
	movq	-24(%rbp), %rax
	movl	$0, %edx
	divq	-32(%rbp)
	movq	%rdx, %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %edi
	call	u8_ascii_str
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	-80(%rbp), %rdi
	movq	-72(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__plus
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	movq	-24(%rbp), %rax
	movl	$0, %edx
	divq	-32(%rbp)
	movq	%rax, -24(%rbp)
	jmp	.L571
.L569:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strconv__bool_to_u32
	.hidden	strconv__bool_to_u32
strconv__bool_to_u32:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, %eax
	movb	%al, -4(%rbp)
	cmpb	$0, -4(%rbp)
	je	.L574
	movl	$1, %eax
	jmp	.L575
.L574:
	movl	$0, %eax
.L575:
	popq	%rbp
	ret
	.globl	strconv__bool_to_u64
	.hidden	strconv__bool_to_u64
strconv__bool_to_u64:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, %eax
	movb	%al, -4(%rbp)
	cmpb	$0, -4(%rbp)
	je	.L577
	movl	$1, %eax
	jmp	.L578
.L577:
	movl	$0, %eax
.L578:
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC45:
	.string	"nan"
.LC46:
	.string	"-inf"
.LC47:
	.string	"+inf"
.LC48:
	.string	"-0e+00"
.LC49:
	.string	"0e+00"
	.text
	.globl	strconv__get_string_special
	.hidden	strconv__get_string_special
strconv__get_string_special:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movl	%edx, %eax
	movl	%edi, %edx
	movb	%dl, -20(%rbp)
	movl	%esi, %edx
	movb	%dl, -24(%rbp)
	movb	%al, -28(%rbp)
	cmpb	$0, -28(%rbp)
	jne	.L580
	leaq	.LC45(%rip), %rcx
	movq	%rbx, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, %rbx
	movq	%rbx, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %rbx
	jmp	.L581
.L580:
	cmpb	$0, -24(%rbp)
	jne	.L582
	cmpb	$0, -20(%rbp)
	je	.L583
	leaq	.LC46(%rip), %rcx
	movq	%rbx, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, %rbx
	movq	%rbx, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %rbx
	jmp	.L581
.L583:
	leaq	.LC47(%rip), %rcx
	movq	%rbx, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, %rbx
	movq	%rbx, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %rbx
	jmp	.L581
.L582:
	cmpb	$0, -20(%rbp)
	je	.L584
	leaq	.LC48(%rip), %rcx
	movq	%rbx, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, %rbx
	movq	%rbx, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %rbx
	jmp	.L581
.L584:
	leaq	.LC49(%rip), %rcx
	movq	%rbx, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, %rbx
	movq	%rbx, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %rbx
.L581:
	movq	%rcx, %rax
	movq	%rbx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strconv__log10_pow2
	.hidden	strconv__log10_pow2
strconv__log10_pow2:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	imull	$78913, %eax, %eax
	shrl	$18, %eax
	popq	%rbp
	ret
	.globl	strconv__log10_pow5
	.hidden	strconv__log10_pow5
strconv__log10_pow5:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	imull	$732923, %eax, %eax
	shrl	$20, %eax
	popq	%rbp
	ret
	.globl	strconv__pow5_bits
	.hidden	strconv__pow5_bits
strconv__pow5_bits:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	imull	$1217359, %eax, %eax
	shrl	$19, %eax
	addl	$1, %eax
	popq	%rbp
	ret
	.globl	strconv__shift_right_128
	.hidden	strconv__shift_right_128
strconv__shift_right_128:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rdi, %rcx
	movq	%rsi, %rax
	movq	%rax, %rbx
	movq	%rcx, -32(%rbp)
	movq	%rbx, -24(%rbp)
	movl	%edx, -36(%rbp)
	movq	-24(%rbp), %rax
	movl	$64, %edx
	subl	-36(%rbp), %edx
	movl	%edx, %ecx
	salq	%cl, %rax
	movq	%rax, %rsi
	movq	-32(%rbp), %rdx
	movl	-36(%rbp), %eax
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	orq	%rsi, %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strconv__mul_shift_64
	.hidden	strconv__mul_shift_64
strconv__mul_shift_64:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$120, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movl	%ecx, -108(%rbp)
	movq	-120(%rbp), %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	math__bits__mul_64
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-128(%rbp), %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	math__bits__mul_64
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -96(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jnb	.L595
	movq	-88(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -88(%rbp)
.L595:
	movl	-108(%rbp), %eax
	leal	-64(%rax), %edx
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	strconv__shift_right_128
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	strconv__pow5_factor_64
	.hidden	strconv__pow5_factor_64
strconv__pow5_factor_64:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -8(%rbp)
	movl	$0, -12(%rbp)
.L600:
	movq	-8(%rbp), %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, -24(%rbp)
	movq	-8(%rbp), %rcx
	movabsq	$-3689348814741910323, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	shrq	$2, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	subq	%rax, %rcx
	movq	%rcx, %rdx
	movq	%rdx, -32(%rbp)
	cmpq	$0, -32(%rbp)
	je	.L598
	movl	-12(%rbp), %eax
	jmp	.L601
.L598:
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	addl	$1, -12(%rbp)
	jmp	.L600
.L601:
	popq	%rbp
	ret
	.globl	strconv__multiple_of_power_of_five_64
	.hidden	strconv__multiple_of_power_of_five_64
strconv__multiple_of_power_of_five_64:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	strconv__pow5_factor_64
	cmpl	-12(%rbp), %eax
	setnb	%al
	leave
	ret
	.globl	strconv__multiple_of_power_of_two_64
	.hidden	strconv__multiple_of_power_of_two_64
strconv__multiple_of_power_of_two_64:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	math__bits__trailing_zeros_64
	cmpl	-12(%rbp), %eax
	setnb	%al
	leave
	ret
	.globl	strconv__dec_digits
strconv__dec_digits:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movabsq	$9999999999, %rax
	cmpq	-8(%rbp), %rax
	jb	.L607
	cmpq	$99999, -8(%rbp)
	ja	.L608
	cmpq	$99, -8(%rbp)
	ja	.L609
	cmpq	$9, -8(%rbp)
	ja	.L610
	movl	$1, %eax
	jmp	.L611
.L610:
	movl	$2, %eax
	jmp	.L611
.L609:
	cmpq	$999, -8(%rbp)
	ja	.L612
	movl	$3, %eax
	jmp	.L611
.L612:
	cmpq	$9999, -8(%rbp)
	ja	.L613
	movl	$4, %eax
	jmp	.L611
.L613:
	movl	$5, %eax
	jmp	.L611
.L608:
	cmpq	$9999999, -8(%rbp)
	ja	.L614
	cmpq	$999999, -8(%rbp)
	ja	.L615
	movl	$6, %eax
	jmp	.L611
.L615:
	movl	$7, %eax
	jmp	.L611
.L614:
	cmpq	$99999999, -8(%rbp)
	ja	.L616
	movl	$8, %eax
	jmp	.L611
.L616:
	cmpq	$999999999, -8(%rbp)
	ja	.L617
	movl	$9, %eax
	jmp	.L611
.L617:
	movl	$10, %eax
	jmp	.L611
.L607:
	movabsq	$999999999999999, %rax
	cmpq	-8(%rbp), %rax
	jb	.L618
	movabsq	$999999999999, %rax
	cmpq	-8(%rbp), %rax
	jb	.L619
	movabsq	$99999999999, %rax
	cmpq	-8(%rbp), %rax
	jb	.L620
	movl	$11, %eax
	jmp	.L611
.L620:
	movl	$12, %eax
	jmp	.L611
.L619:
	movabsq	$9999999999999, %rax
	cmpq	-8(%rbp), %rax
	jb	.L621
	movl	$13, %eax
	jmp	.L611
.L621:
	movabsq	$99999999999999, %rax
	cmpq	-8(%rbp), %rax
	jb	.L622
	movl	$14, %eax
	jmp	.L611
.L622:
	movl	$15, %eax
	jmp	.L611
.L618:
	movabsq	$99999999999999999, %rax
	cmpq	-8(%rbp), %rax
	jb	.L623
	movabsq	$9999999999999999, %rax
	cmpq	-8(%rbp), %rax
	jb	.L624
	movl	$16, %eax
	jmp	.L611
.L624:
	movl	$17, %eax
	jmp	.L611
.L623:
	movabsq	$999999999999999999, %rax
	cmpq	-8(%rbp), %rax
	jb	.L625
	movl	$18, %eax
	jmp	.L611
.L625:
	movabsq	$-8446744073709551617, %rax
	cmpq	-8(%rbp), %rax
	jb	.L626
	movl	$19, %eax
	jmp	.L611
.L626:
	movl	$20, %eax
.L611:
	popq	%rbp
	ret
	.globl	__new_array
	.hidden	__new_array
__new_array:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -88(%rbp)
	movl	%esi, -92(%rbp)
	movl	%edx, -96(%rbp)
	movl	%ecx, -100(%rbp)
	movl	-96(%rbp), %edx
	movl	-92(%rbp), %eax
	cmpl	%eax, %edx
	cmovgel	%edx, %eax
	movl	%eax, -4(%rbp)
	movl	-100(%rbp), %eax
	movl	%eax, -48(%rbp)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movl	-100(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	vcalloc
	movq	%rax, -40(%rbp)
	movl	$0, -32(%rbp)
	movl	-92(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	$0, -20(%rbp)
	movq	-88(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-88(%rbp), %rax
	leave
	ret
	.globl	__new_array_with_default
	.hidden	__new_array_with_default
__new_array_with_default:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	movq	%rdi, -120(%rbp)
	movl	%esi, -124(%rbp)
	movl	%edx, -128(%rbp)
	movl	%ecx, -132(%rbp)
	movq	%r8, -144(%rbp)
	movl	-128(%rbp), %edx
	movl	-124(%rbp), %eax
	cmpl	%eax, %edx
	cmovgel	%edx, %eax
	movl	%eax, -20(%rbp)
	movl	-132(%rbp), %eax
	movl	%eax, -80(%rbp)
	movq	$0, -72(%rbp)
	movl	$0, -64(%rbp)
	movl	-124(%rbp), %eax
	movl	%eax, -60(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -56(%rbp)
	movl	$0, -52(%rbp)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movl	-132(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, -32(%rbp)
	cmpl	$0, -20(%rbp)
	jle	.L630
	cmpl	$0, -124(%rbp)
	jne	.L630
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__at_least_one
	movq	%rax, %rdi
	call	_v_malloc
	movq	%rax, -72(%rbp)
	jmp	.L631
.L630:
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	vcalloc
	movq	%rax, -72(%rbp)
.L631:
	cmpq	$0, -144(%rbp)
	je	.L632
	movq	-72(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L632
	movl	-80(%rbp), %eax
	cmpl	$1, %eax
	jne	.L633
	movq	-144(%rbp), %rax
	movzbl	(%rax), %eax
	movb	%al, -33(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L634
.L635:
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movzbl	-33(%rbp), %eax
	movb	%al, (%rdx)
	addl	$1, -12(%rbp)
.L634:
	movl	-60(%rbp), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L635
	jmp	.L632
.L633:
	movl	$0, -16(%rbp)
	jmp	.L636
.L637:
	movl	-80(%rbp), %eax
	movslq	%eax, %rdx
	movq	-144(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movl	-80(%rbp), %eax
	cltq
	addq	%rax, -8(%rbp)
	addl	$1, -16(%rbp)
.L636:
	movl	-60(%rbp), %eax
	cmpl	%eax, -16(%rbp)
	jl	.L637
.L632:
	movq	-120(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-120(%rbp), %rax
	leave
	ret
	.globl	__new_array_with_multi_default
	.hidden	__new_array_with_multi_default
__new_array_with_multi_default:
	pushq	%rbp
	movq	%rsp, %rbp
	addq	$-128, %rsp
	movq	%rdi, -104(%rbp)
	movl	%esi, -108(%rbp)
	movl	%edx, -112(%rbp)
	movl	%ecx, -116(%rbp)
	movq	%r8, -128(%rbp)
	movl	-112(%rbp), %edx
	movl	-108(%rbp), %eax
	cmpl	%eax, %edx
	cmovgel	%edx, %eax
	movl	%eax, -16(%rbp)
	movl	-116(%rbp), %eax
	movl	%eax, -64(%rbp)
	movq	$0, -56(%rbp)
	movl	$0, -48(%rbp)
	movl	-108(%rbp), %eax
	movl	%eax, -44(%rbp)
	movl	-16(%rbp), %eax
	movl	%eax, -40(%rbp)
	movl	$0, -36(%rbp)
	movl	-16(%rbp), %eax
	movslq	%eax, %rdx
	movl	-116(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	__at_least_one
	movq	%rax, %rdi
	call	vcalloc
	movq	%rax, -56(%rbp)
	cmpq	$0, -128(%rbp)
	je	.L640
	movq	-56(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L640
	movl	$0, -12(%rbp)
	jmp	.L641
.L642:
	movl	-64(%rbp), %eax
	movslq	%eax, %rdx
	movl	-64(%rbp), %eax
	imull	-12(%rbp), %eax
	movslq	%eax, %rcx
	movq	-128(%rbp), %rax
	addq	%rax, %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movl	-64(%rbp), %eax
	cltq
	addq	%rax, -8(%rbp)
	addl	$1, -12(%rbp)
.L641:
	movl	-44(%rbp), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L642
.L640:
	movq	-104(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-104(%rbp), %rax
	leave
	ret
	.globl	__new_array_with_array_default
	.hidden	__new_array_with_array_default
__new_array_with_array_default:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	movq	%rdi, -120(%rbp)
	movl	%esi, -124(%rbp)
	movl	%edx, -128(%rbp)
	movl	%ecx, -132(%rbp)
	movl	%r8d, -136(%rbp)
	movl	-128(%rbp), %edx
	movl	-124(%rbp), %eax
	cmpl	%eax, %edx
	cmovgel	%edx, %eax
	movl	%eax, -16(%rbp)
	movl	-132(%rbp), %eax
	movl	%eax, -48(%rbp)
	movl	-16(%rbp), %eax
	movslq	%eax, %rdx
	movl	-132(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	__at_least_one
	movq	%rax, %rdi
	call	_v_malloc
	movq	%rax, -40(%rbp)
	movl	$0, -32(%rbp)
	movl	-124(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-16(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	$0, -20(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L645
	movl	$0, -12(%rbp)
	jmp	.L646
.L647:
	leaq	-112(%rbp), %rax
	movl	-136(%rbp), %edx
	leaq	16(%rbp), %rsi
	movq	%rax, %rdi
	call	array_clone_to_depth
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	leaq	-112(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movl	-48(%rbp), %eax
	cltq
	addq	%rax, -8(%rbp)
	addl	$1, -12(%rbp)
.L646:
	movl	-28(%rbp), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L647
.L645:
	movq	-120(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-120(%rbp), %rax
	leave
	ret
	.globl	new_array_from_c_array
	.hidden	new_array_from_c_array
new_array_from_c_array:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -88(%rbp)
	movl	%esi, -92(%rbp)
	movl	%edx, -96(%rbp)
	movl	%ecx, -100(%rbp)
	movq	%r8, -112(%rbp)
	movl	-96(%rbp), %edx
	movl	-92(%rbp), %eax
	cmpl	%eax, %edx
	cmovgel	%edx, %eax
	movl	%eax, -4(%rbp)
	movl	-100(%rbp), %eax
	movl	%eax, -48(%rbp)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movl	-100(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	vcalloc
	movq	%rax, -40(%rbp)
	movl	$0, -32(%rbp)
	movl	-92(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	$0, -20(%rbp)
	movl	-92(%rbp), %eax
	movslq	%eax, %rdx
	movl	-100(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	-112(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-88(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-88(%rbp), %rax
	leave
	ret
	.section	.rodata, "a"
.LC50:
	.string	"array.ensure_cap: array with the flag `.nogrow` cannot grow in size, array required new size: "
	.text
	.globl	array_ensure_cap
	.hidden	array_ensure_cap
array_ensure_cap:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$136, %rsp
	movq	%rdi, -136(%rbp)
	movl	%esi, -140(%rbp)
	movq	-136(%rbp), %rax
	movl	24(%rax), %eax
	cmpl	%eax, -140(%rbp)
	jle	.L662
	movq	-136(%rbp), %rax
	addq	$28, %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	ArrayFlags_has
	testb	%al, %al
	je	.L654
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -128(%rbp)
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	leaq	.LC50(%rip), %rax
	movq	%rax, -128(%rbp)
	movl	$94, -120(%rbp)
	movl	$1, -116(%rbp)
	movl	$65031, -112(%rbp)
	movl	-140(%rbp), %eax
	movl	%eax, -104(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -88(%rbp)
	movl	$1, -76(%rbp)
	leaq	-128(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L654:
	movq	-136(%rbp), %rax
	movl	24(%rax), %eax
	testl	%eax, %eax
	jle	.L655
	movq	-136(%rbp), %rax
	movl	24(%rax), %eax
	jmp	.L656
.L655:
	movl	$2, %eax
.L656:
	movl	%eax, -20(%rbp)
.L659:
	movl	-140(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle	.L663
	sall	-20(%rbp)
	jmp	.L659
.L663:
	nop
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-136(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__at_least_one
	movq	%rax, %rdi
	call	_v_malloc
	movq	%rax, -40(%rbp)
	movq	-136(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	je	.L660
	movq	-136(%rbp), %rax
	movl	20(%rax), %eax
	movslq	%eax, %rdx
	movq	-136(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdx
	movq	-136(%rbp), %rax
	movq	8(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-136(%rbp), %rax
	addq	$28, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	ArrayFlags_has
	testb	%al, %al
	je	.L660
	movq	-136(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
.L660:
	movq	-136(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, 8(%rax)
	movq	-136(%rbp), %rax
	movl	$0, 16(%rax)
	movq	-136(%rbp), %rax
	movl	-20(%rbp), %edx
	movl	%edx, 24(%rax)
	jmp	.L651
.L662:
	nop
.L651:
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC51:
	.string	"array.repeat: count is negative: "
	.text
	.globl	array_repeat_to_depth
array_repeat_to_depth:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$216, %rsp
	movq	%rdi, -216(%rbp)
	movl	%esi, -220(%rbp)
	movl	%edx, -224(%rbp)
	cmpl	$0, -220(%rbp)
	jns	.L665
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -160(%rbp)
	movaps	%xmm0, -144(%rbp)
	leaq	.LC51(%rip), %rax
	movq	%rax, -208(%rbp)
	movl	$33, -200(%rbp)
	movl	$1, -196(%rbp)
	movl	$65031, -192(%rbp)
	movl	-220(%rbp), %eax
	movl	%eax, -184(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -168(%rbp)
	movl	$1, -156(%rbp)
	leaq	-208(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L665:
	movl	-220(%rbp), %eax
	movslq	%eax, %rdx
	movl	36(%rbp), %eax
	cltq
	imulq	%rax, %rdx
	movl	16(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L666
	movl	16(%rbp), %eax
	cltq
	movq	%rax, -24(%rbp)
.L666:
	movl	16(%rbp), %eax
	movl	%eax, -96(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	vcalloc
	movq	%rax, -88(%rbp)
	movl	$0, -80(%rbp)
	movl	36(%rbp), %eax
	imull	-220(%rbp), %eax
	movl	%eax, -76(%rbp)
	movl	36(%rbp), %eax
	imull	-220(%rbp), %eax
	movl	%eax, -72(%rbp)
	movl	$0, -68(%rbp)
	movl	36(%rbp), %eax
	testl	%eax, %eax
	jle	.L667
	movl	36(%rbp), %eax
	movslq	%eax, %rdx
	movl	16(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, -48(%rbp)
	movl	36(%rbp), %eax
	movslq	%eax, %rdx
	movl	-96(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, -56(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, -32(%rbp)
	cmpq	$0, -32(%rbp)
	je	.L667
	movl	$0, -36(%rbp)
	jmp	.L668
.L671:
	cmpl	$0, -224(%rbp)
	jle	.L669
	leaq	-208(%rbp), %rax
	movl	-224(%rbp), %edx
	leaq	16(%rbp), %rsi
	movq	%rax, %rdi
	call	array_clone_to_depth
	movq	-48(%rbp), %rdx
	movq	-200(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	jmp	.L670
.L669:
	movq	-48(%rbp), %rdx
	movq	24(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
.L670:
	movq	-56(%rbp), %rax
	addq	%rax, -32(%rbp)
	addl	$1, -36(%rbp)
.L668:
	movl	-36(%rbp), %eax
	cmpl	-220(%rbp), %eax
	jl	.L671
.L667:
	movq	-216(%rbp), %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-216(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC52:
	.string	"array.insert_many: index out of range (i == "
.LC53:
	.string	", a.len == "
.LC54:
	.string	")"
	.text
	.globl	array_insert_many
	.hidden	array_insert_many
array_insert_many:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$184, %rsp
	movq	%rdi, -168(%rbp)
	movl	%esi, -172(%rbp)
	movq	%rdx, -184(%rbp)
	movl	%ecx, -176(%rbp)
	cmpl	$0, -172(%rbp)
	js	.L674
	movq	-168(%rbp), %rax
	movl	20(%rax), %eax
	cmpl	%eax, -172(%rbp)
	jle	.L675
.L674:
	leaq	-160(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC52(%rip), %rax
	movq	%rax, -160(%rbp)
	movl	$44, -152(%rbp)
	movl	$1, -148(%rbp)
	movl	$65031, -144(%rbp)
	movl	-172(%rbp), %eax
	movl	%eax, -136(%rbp)
	leaq	.LC53(%rip), %rax
	movq	%rax, -120(%rbp)
	movl	$11, -112(%rbp)
	movl	$1, -108(%rbp)
	movl	$65031, -104(%rbp)
	movq	-168(%rbp), %rax
	movl	20(%rax), %eax
	movl	%eax, -96(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -80(%rbp)
	movl	$1, -72(%rbp)
	movl	$1, -68(%rbp)
	leaq	-160(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L675:
	movq	-168(%rbp), %rax
	movl	20(%rax), %edx
	movl	-176(%rbp), %eax
	addl	%eax, %edx
	movq	-168(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	array_ensure_cap
	movq	-168(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -20(%rbp)
	movl	-172(%rbp), %edi
	movq	-168(%rbp), %rcx
	subq	$32, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	%rax, 16(%rsi)
	movq	%rdx, 24(%rsi)
	call	array_get_unsafe
	addq	$32, %rsp
	movq	%rax, -32(%rbp)
	movq	-168(%rbp), %rax
	movl	20(%rax), %eax
	subl	-172(%rbp), %eax
	movslq	%eax, %rdx
	movl	-20(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rbx
	movl	-172(%rbp), %edx
	movl	-176(%rbp), %eax
	leal	(%rdx,%rax), %edi
	movq	-168(%rbp), %rcx
	subq	$32, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	%rax, 16(%rsi)
	movq	%rdx, 24(%rsi)
	call	array_get_unsafe
	addq	$32, %rsp
	movq	%rax, %rcx
	movq	-32(%rbp), %rax
	movq	%rbx, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemmove
	movl	-176(%rbp), %eax
	movslq	%eax, %rdx
	movl	-20(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdx
	movq	-184(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-168(%rbp), %rax
	movl	20(%rax), %edx
	movl	-176(%rbp), %eax
	addl	%eax, %edx
	movq	-168(%rbp), %rax
	movl	%edx, 20(%rax)
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	array_prepend_many
	.hidden	array_prepend_many
array_prepend_many:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movl	-20(%rbp), %ecx
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	array_insert_many
	nop
	leave
	ret
	.globl	array_delete
array_delete:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-12(%rbp), %ecx
	movq	-8(%rbp), %rax
	movl	$1, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	array_delete_many
	nop
	leave
	ret
	.section	.rodata, "a"
.LC55:
	.string	".."
.LC56:
	.string	"array.delete: index out of range (i == "
	.text
	.globl	array_delete_many
array_delete_many:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$296, %rsp
	movq	%rdi, -296(%rbp)
	movl	%esi, -300(%rbp)
	movl	%edx, -304(%rbp)
	cmpl	$0, -300(%rbp)
	js	.L679
	movl	-300(%rbp), %edx
	movl	-304(%rbp), %eax
	addl	%eax, %edx
	movq	-296(%rbp), %rax
	movl	20(%rax), %eax
	cmpl	%eax, %edx
	jle	.L680
.L679:
	cmpl	$1, -304(%rbp)
	jle	.L681
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -288(%rbp)
	movaps	%xmm0, -272(%rbp)
	movaps	%xmm0, -256(%rbp)
	movaps	%xmm0, -240(%rbp)
	movaps	%xmm0, -224(%rbp)
	leaq	.LC55(%rip), %rax
	movq	%rax, -288(%rbp)
	movl	$2, -280(%rbp)
	movl	$1, -276(%rbp)
	movl	$65031, -272(%rbp)
	movl	-300(%rbp), %edx
	movl	-304(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -264(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -248(%rbp)
	movl	$1, -236(%rbp)
	leaq	-288(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	jmp	.L682
.L681:
	leaq	.LC34(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$0, -40(%rbp)
	movl	$1, -36(%rbp)
.L682:
	leaq	-208(%rbp), %rdx
	movl	$0, %eax
	movl	$20, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC56(%rip), %rax
	movq	%rax, -208(%rbp)
	movl	$39, -200(%rbp)
	movl	$1, -196(%rbp)
	movl	$65031, -192(%rbp)
	movl	-300(%rbp), %eax
	movl	%eax, -184(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -168(%rbp)
	movl	$1, -156(%rbp)
	movl	$65040, -152(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	leaq	.LC53(%rip), %rax
	movq	%rax, -128(%rbp)
	movl	$11, -120(%rbp)
	movl	$1, -116(%rbp)
	movl	$65031, -112(%rbp)
	movq	-296(%rbp), %rax
	movl	20(%rax), %eax
	movl	%eax, -104(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -88(%rbp)
	movl	$1, -80(%rbp)
	movl	$1, -76(%rbp)
	leaq	-208(%rbp), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L680:
	movq	-296(%rbp), %rax
	addq	$28, %rax
	movl	$3, %esi
	movq	%rax, %rdi
	call	ArrayFlags_all
	testb	%al, %al
	je	.L683
	movq	-296(%rbp), %rax
	movl	20(%rax), %eax
	subl	-300(%rbp), %eax
	subl	-304(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	movq	-296(%rbp), %rax
	movq	8(%rax), %rcx
	movl	-300(%rbp), %edx
	movl	-304(%rbp), %eax
	addl	%edx, %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	addq	%rax, %rcx
	movq	-296(%rbp), %rax
	movq	8(%rax), %rsi
	movl	-300(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	addq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemmove
	movq	-296(%rbp), %rax
	movl	20(%rax), %eax
	subl	-304(%rbp), %eax
	movl	%eax, %edx
	movq	-296(%rbp), %rax
	movl	%edx, 20(%rax)
	jmp	.L678
.L683:
	movq	-296(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-296(%rbp), %rax
	movl	20(%rax), %eax
	subl	-304(%rbp), %eax
	movl	%eax, -28(%rbp)
	cmpl	$0, -28(%rbp)
	je	.L685
	movl	-28(%rbp), %eax
	jmp	.L686
.L685:
	movl	$1, %eax
.L686:
	movl	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	vcalloc
	movq	-296(%rbp), %rdx
	movq	%rax, 8(%rdx)
	movl	-300(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdx
	movq	-296(%rbp), %rax
	movq	8(%rax), %rax
	movq	-24(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-296(%rbp), %rax
	movl	20(%rax), %eax
	subl	-300(%rbp), %eax
	subl	-304(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	movl	-300(%rbp), %edx
	movl	-304(%rbp), %eax
	addl	%edx, %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rax, %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-296(%rbp), %rax
	movq	8(%rax), %rsi
	movl	-300(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	addq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-296(%rbp), %rax
	addq	$28, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	ArrayFlags_has
	testb	%al, %al
	je	.L687
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	_v_free
.L687:
	movq	-296(%rbp), %rax
	movl	-28(%rbp), %edx
	movl	%edx, 20(%rax)
	movq	-296(%rbp), %rax
	movl	-32(%rbp), %edx
	movl	%edx, 24(%rax)
.L678:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	array_trim
array_trim:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	20(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jge	.L690
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	movl	%edx, 20(%rax)
.L690:
	nop
	popq	%rbp
	ret
	.globl	array_get_unsafe
	.hidden	array_get_unsafe
array_get_unsafe:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movq	24(%rbp), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movl	16(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	addq	%rcx, %rax
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC57:
	.string	"array.get: index out of range (i == "
	.text
	.globl	array_get
	.hidden	array_get
array_get:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$152, %rsp
	movl	%edi, -148(%rbp)
	cmpl	$0, -148(%rbp)
	js	.L694
	movl	36(%rbp), %eax
	cmpl	%eax, -148(%rbp)
	jl	.L695
.L694:
	leaq	-144(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC57(%rip), %rax
	movq	%rax, -144(%rbp)
	movl	$36, -136(%rbp)
	movl	$1, -132(%rbp)
	movl	$65031, -128(%rbp)
	movl	-148(%rbp), %eax
	movl	%eax, -120(%rbp)
	leaq	.LC53(%rip), %rax
	movq	%rax, -104(%rbp)
	movl	$11, -96(%rbp)
	movl	$1, -92(%rbp)
	movl	$65031, -88(%rbp)
	movl	36(%rbp), %eax
	movl	%eax, -80(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$1, -56(%rbp)
	movl	$1, -52(%rbp)
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L695:
	movq	24(%rbp), %rcx
	movl	-148(%rbp), %eax
	movslq	%eax, %rdx
	movl	16(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	addq	%rcx, %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	array_get_with_check
	.hidden	array_get_with_check
array_get_with_check:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	js	.L698
	movl	36(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L699
.L698:
	movl	$0, %eax
	jmp	.L700
.L699:
	movq	24(%rbp), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movl	16(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	addq	%rcx, %rax
.L700:
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC58:
	.string	"array.first: array is empty"
	.text
	.globl	array_first
array_first:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$8, %rsp
	movl	36(%rbp), %ecx
	testl	%ecx, %ecx
	jne	.L702
	leaq	.LC58(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$27, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L702:
	movq	24(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC59:
	.string	"array.last: array is empty"
	.text
	.globl	array_last
array_last:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$8, %rsp
	movl	36(%rbp), %ecx
	testl	%ecx, %ecx
	jne	.L705
	leaq	.LC59(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$26, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L705:
	movq	24(%rbp), %rcx
	movl	36(%rbp), %eax
	subl	$1, %eax
	movslq	%eax, %rdx
	movl	16(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	addq	%rcx, %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC60:
	.string	"array.pop: array is empty"
	.text
	.globl	array_pop
array_pop:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rcx
	movl	20(%rcx), %ecx
	testl	%ecx, %ecx
	jne	.L708
	leaq	.LC60(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$25, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L708:
	movq	-40(%rbp), %rax
	movl	20(%rax), %eax
	subl	$1, %eax
	movl	%eax, -20(%rbp)
	movq	-40(%rbp), %rax
	movq	8(%rax), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	addq	%rcx, %rax
	movq	%rax, -32(%rbp)
	movq	-40(%rbp), %rax
	movl	-20(%rbp), %edx
	movl	%edx, 20(%rax)
	movq	-32(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC61:
	.string	"array.slice: invalid slice index ("
.LC62:
	.string	" > "
.LC63:
	.string	"array.slice: slice bounds out of range ("
.LC64:
	.string	" >= "
.LC65:
	.string	" < 0)"
	.text
	.globl	array_slice
	.hidden	array_slice
array_slice:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$248, %rsp
	movq	%rdi, -248(%rbp)
	movl	%esi, -252(%rbp)
	movl	%edx, -256(%rbp)
	movl	-256(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	-252(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle	.L711
	leaq	-240(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC61(%rip), %rax
	movq	%rax, -240(%rbp)
	movl	$34, -232(%rbp)
	movl	$1, -228(%rbp)
	movl	$65031, -224(%rbp)
	movl	-252(%rbp), %eax
	movl	%eax, -216(%rbp)
	leaq	.LC62(%rip), %rax
	movq	%rax, -200(%rbp)
	movl	$3, -192(%rbp)
	movl	$1, -188(%rbp)
	movl	$65031, -184(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -176(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -160(%rbp)
	movl	$1, -152(%rbp)
	movl	$1, -148(%rbp)
	leaq	-240(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L711:
	movl	36(%rbp), %eax
	cmpl	%eax, -20(%rbp)
	jle	.L712
	leaq	-240(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC63(%rip), %rax
	movq	%rax, -240(%rbp)
	movl	$40, -232(%rbp)
	movl	$1, -228(%rbp)
	movl	$65031, -224(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -216(%rbp)
	leaq	.LC64(%rip), %rax
	movq	%rax, -200(%rbp)
	movl	$4, -192(%rbp)
	movl	$1, -188(%rbp)
	movl	$65031, -184(%rbp)
	movl	36(%rbp), %eax
	movl	%eax, -176(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -160(%rbp)
	movl	$1, -152(%rbp)
	movl	$1, -148(%rbp)
	leaq	-240(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L712:
	cmpl	$0, -252(%rbp)
	jns	.L713
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -240(%rbp)
	movaps	%xmm0, -224(%rbp)
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	leaq	.LC63(%rip), %rax
	movq	%rax, -240(%rbp)
	movl	$40, -232(%rbp)
	movl	$1, -228(%rbp)
	movl	$65031, -224(%rbp)
	movl	-252(%rbp), %eax
	movl	%eax, -216(%rbp)
	leaq	.LC65(%rip), %rax
	movq	%rax, -200(%rbp)
	movl	$5, -192(%rbp)
	movl	$1, -188(%rbp)
	leaq	-240(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L713:
	movl	-252(%rbp), %eax
	movslq	%eax, %rdx
	movl	16(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, -32(%rbp)
	movq	24(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -40(%rbp)
	movl	-20(%rbp), %eax
	subl	-252(%rbp), %eax
	movl	%eax, -44(%rbp)
	movl	16(%rbp), %eax
	movl	%eax, -80(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -72(%rbp)
	movl	32(%rbp), %eax
	movq	-32(%rbp), %rdx
	addl	%edx, %eax
	movl	%eax, -64(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, -60(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, -56(%rbp)
	movl	$0, -52(%rbp)
	movq	-248(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-248(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	array_slice_ni
	.hidden	array_slice_ni
array_slice_ni:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$24, %rsp
	movq	%rdi, -136(%rbp)
	movl	%esi, -140(%rbp)
	movl	%edx, -144(%rbp)
	movl	-144(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-140(%rbp), %eax
	movl	%eax, -8(%rbp)
	cmpl	$0, -8(%rbp)
	jns	.L716
	movl	36(%rbp), %eax
	addl	%eax, -8(%rbp)
	cmpl	$0, -8(%rbp)
	jns	.L716
	movl	$0, -8(%rbp)
.L716:
	cmpl	$0, -4(%rbp)
	jns	.L717
	movl	36(%rbp), %eax
	addl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jns	.L717
	movl	$0, -4(%rbp)
.L717:
	movl	36(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L718
	movl	36(%rbp), %eax
	movl	%eax, -4(%rbp)
.L718:
	movl	36(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jge	.L719
	movl	-8(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jle	.L720
.L719:
	movl	16(%rbp), %eax
	movl	%eax, -128(%rbp)
	movq	24(%rbp), %rax
	movq	%rax, -120(%rbp)
	movl	$0, -112(%rbp)
	movl	$0, -108(%rbp)
	movl	$0, -104(%rbp)
	movl	$0, -100(%rbp)
	movq	-136(%rbp), %rcx
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	jmp	.L715
.L720:
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movl	16(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	24(%rbp), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -24(%rbp)
	movl	-4(%rbp), %eax
	subl	-8(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	16(%rbp), %eax
	movl	%eax, -64(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -56(%rbp)
	movl	32(%rbp), %eax
	movq	-16(%rbp), %rdx
	addl	%edx, %eax
	movl	%eax, -48(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -44(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -40(%rbp)
	movl	$0, -36(%rbp)
	movq	-136(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
.L715:
	movq	-136(%rbp), %rax
	leave
	ret
	.globl	array_slice2
	.hidden	array_slice2
array_slice2:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movl	%ecx, %eax
	movb	%al, -36(%rbp)
	cmpb	$0, -36(%rbp)
	je	.L724
	movl	36(%rbp), %eax
	jmp	.L725
.L724:
	movl	-32(%rbp), %eax
.L725:
	movl	%eax, -4(%rbp)
	movq	-24(%rbp), %rdi
	movl	-4(%rbp), %r8d
	movl	-28(%rbp), %esi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%r8d, %edx
	call	array_slice
	addq	$32, %rsp
	movq	-24(%rbp), %rax
	leave
	ret
	.globl	array_clone_static_to_depth
	.hidden	array_clone_static_to_depth
array_clone_static_to_depth:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	leaq	16(%rbp), %rsi
	movq	%rax, %rdi
	call	array_clone_to_depth
	movq	-8(%rbp), %rax
	leave
	ret
	.globl	array_clone
array_clone:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %rcx
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_clone_to_depth
	movq	-8(%rbp), %rax
	leave
	ret
	.globl	array_clone_to_depth
array_clone_to_depth:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$208, %rsp
	movq	%rdi, -184(%rbp)
	movq	%rsi, -192(%rbp)
	movl	%edx, -196(%rbp)
	movq	-192(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -48(%rbp)
	movq	-192(%rbp), %rax
	movl	24(%rax), %eax
	movslq	%eax, %rdx
	movq	-192(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	vcalloc
	movq	%rax, -40(%rbp)
	movl	$0, -32(%rbp)
	movq	-192(%rbp), %rax
	movl	20(%rax), %eax
	movl	%eax, -28(%rbp)
	movq	-192(%rbp), %rax
	movl	24(%rax), %eax
	movl	%eax, -24(%rbp)
	movl	$0, -20(%rbp)
	cmpl	$0, -196(%rbp)
	jle	.L732
	movq	-192(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %esi
	movl	$32, %edi
	call	_us32_eq
	testb	%al, %al
	je	.L732
	movq	-192(%rbp), %rax
	movl	20(%rax), %eax
	testl	%eax, %eax
	js	.L732
	movq	-192(%rbp), %rax
	movl	24(%rax), %edx
	movq	-192(%rbp), %rax
	movl	20(%rax), %eax
	cmpl	%eax, %edx
	jl	.L732
	movl	$0, -4(%rbp)
	jmp	.L733
.L734:
	movl	$0, -176(%rbp)
	movq	$0, -168(%rbp)
	movl	$0, -160(%rbp)
	movl	$0, -156(%rbp)
	movl	$0, -152(%rbp)
	movl	$0, -148(%rbp)
	movl	-4(%rbp), %edi
	movq	-192(%rbp), %rcx
	subq	$32, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	%rax, 16(%rsi)
	movq	%rdx, 24(%rsi)
	call	array_get_unsafe
	addq	$32, %rsp
	movq	%rax, %rcx
	leaq	-176(%rbp), %rax
	movl	$32, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movl	-196(%rbp), %eax
	leal	-1(%rax), %edx
	leaq	-144(%rbp), %rax
	leaq	-176(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_clone_to_depth
	leaq	-144(%rbp), %rdx
	movl	-4(%rbp), %ecx
	leaq	-48(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	array_set_unsafe
	addl	$1, -4(%rbp)
.L733:
	movq	-192(%rbp), %rax
	movl	20(%rax), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L734
	movq	-184(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	jmp	.L737
.L732:
	movq	-192(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	je	.L736
	movq	-192(%rbp), %rax
	movl	24(%rax), %eax
	movslq	%eax, %rdx
	movq	-192(%rbp), %rax
	movl	(%rax), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdx
	movq	-192(%rbp), %rax
	movq	8(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
.L736:
	movq	-184(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
.L737:
	movq	-184(%rbp), %rax
	leave
	ret
	.globl	array_set_unsafe
	.hidden	array_set_unsafe
array_set_unsafe:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	8(%rax), %rsi
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rcx
	movl	-12(%rbp), %eax
	cltq
	imulq	%rcx, %rax
	leaq	(%rsi,%rax), %rcx
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	nop
	leave
	ret
	.section	.rodata, "a"
.LC66:
	.string	"array.set: index out of range (i == "
	.text
	.globl	array_set
	.hidden	array_set
array_set:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$168, %rsp
	movq	%rdi, -152(%rbp)
	movl	%esi, -156(%rbp)
	movq	%rdx, -168(%rbp)
	cmpl	$0, -156(%rbp)
	js	.L740
	movq	-152(%rbp), %rax
	movl	20(%rax), %eax
	cmpl	%eax, -156(%rbp)
	jl	.L741
.L740:
	leaq	-144(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC66(%rip), %rax
	movq	%rax, -144(%rbp)
	movl	$36, -136(%rbp)
	movl	$1, -132(%rbp)
	movl	$65031, -128(%rbp)
	movl	-156(%rbp), %eax
	movl	%eax, -120(%rbp)
	leaq	.LC53(%rip), %rax
	movq	%rax, -104(%rbp)
	movl	$11, -96(%rbp)
	movl	$1, -92(%rbp)
	movl	$65031, -88(%rbp)
	movq	-152(%rbp), %rax
	movl	20(%rax), %eax
	movl	%eax, -80(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$1, -56(%rbp)
	movl	$1, -52(%rbp)
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L741:
	movq	-152(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-152(%rbp), %rax
	movq	8(%rax), %rsi
	movq	-152(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rcx
	movl	-156(%rbp), %eax
	cltq
	imulq	%rcx, %rax
	leaq	(%rsi,%rax), %rcx
	movq	-168(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	array_push
	.hidden	array_push
array_push:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	20(%rax), %edx
	movq	-8(%rbp), %rax
	movl	24(%rax), %eax
	cmpl	%eax, %edx
	jl	.L743
	movq	-8(%rbp), %rax
	movl	20(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	array_ensure_cap
.L743:
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	8(%rax), %rsi
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rcx
	movq	-8(%rbp), %rax
	movl	20(%rax), %eax
	cltq
	imulq	%rcx, %rax
	leaq	(%rsi,%rax), %rcx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	movq	-8(%rbp), %rax
	movl	20(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, 20(%rax)
	nop
	leave
	ret
	.globl	array_push_many
array_push_many:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	%edx, -52(%rbp)
	cmpl	$0, -52(%rbp)
	jle	.L750
	cmpq	$0, -48(%rbp)
	je	.L750
	movq	-40(%rbp), %rax
	movl	20(%rax), %edx
	movl	-52(%rbp), %eax
	addl	%eax, %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	array_ensure_cap
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	cmpq	%rax, -48(%rbp)
	jne	.L748
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	je	.L748
	leaq	-32(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_clone
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movl	-52(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	movq	-24(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	8(%rdx), %rsi
	movq	-40(%rbp), %rdx
	movl	(%rdx), %edx
	movslq	%edx, %rcx
	movq	-40(%rbp), %rdx
	movl	20(%rdx), %edx
	movslq	%edx, %rdx
	imulq	%rcx, %rdx
	leaq	(%rsi,%rdx), %rcx
	movq	%rdi, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	jmp	.L749
.L748:
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	je	.L749
	cmpq	$0, -48(%rbp)
	je	.L749
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movl	-52(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rsi
	movq	-40(%rbp), %rax
	movq	8(%rax), %rcx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	movl	20(%rax), %eax
	cltq
	imulq	%rdx, %rax
	addq	%rax, %rcx
	movq	-48(%rbp), %rax
	movq	%rsi, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
.L749:
	movq	-40(%rbp), %rax
	movl	20(%rax), %edx
	movl	-52(%rbp), %eax
	addl	%eax, %edx
	movq	-40(%rbp), %rax
	movl	%edx, 20(%rax)
	jmp	.L744
.L750:
	nop
.L744:
	leave
	ret
	.globl	array_reverse
array_reverse:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$96, %rsp
	movq	%rdi, -88(%rbp)
	movl	36(%rbp), %eax
	cmpl	$1, %eax
	jg	.L752
	movq	-88(%rbp), %rcx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	jmp	.L756
.L752:
	movl	16(%rbp), %eax
	movl	%eax, -48(%rbp)
	movl	40(%rbp), %eax
	movslq	%eax, %rdx
	movl	16(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	vcalloc
	movq	%rax, -40(%rbp)
	movl	$0, -32(%rbp)
	movl	36(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	40(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	$0, -20(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L754
.L755:
	movl	36(%rbp), %eax
	subl	$1, %eax
	subl	-4(%rbp), %eax
	movl	%eax, %esi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%esi, %edi
	call	array_get_unsafe
	addq	$32, %rsp
	movq	%rax, %rdx
	movl	-4(%rbp), %ecx
	leaq	-48(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	array_set_unsafe
	addl	$1, -4(%rbp)
.L754:
	movl	36(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L755
	movq	-88(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
.L756:
	movq	-88(%rbp), %rax
	leave
	ret
	.globl	array_free
array_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	addq	$28, %rax
	movl	$8, %esi
	movq	%rax, %rdi
	call	ArrayFlags_has
	testb	%al, %al
	jne	.L760
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movl	16(%rax), %eax
	cltq
	subq	%rax, %rdx
	movq	%rdx, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-24(%rbp), %rax
	movq	$0, 8(%rax)
	jmp	.L757
.L760:
	nop
.L757:
	leave
	ret
	.globl	Array_string_free
Array_string_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L762
.L763:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	addl	$1, -4(%rbp)
.L762:
	movq	-24(%rbp), %rax
	movl	20(%rax), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L763
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
	nop
	leave
	ret
	.section	.rodata, "a"
.LC67:
	.string	", "
	.text
	.globl	Array_string_str
Array_string_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$88, %rsp
	movl	$4, -36(%rbp)
	movl	36(%rbp), %eax
	testl	%eax, %eax
	jle	.L765
	movq	24(%rbp), %rax
	movl	8(%rax), %eax
	addl	%eax, -36(%rbp)
	movl	36(%rbp), %eax
	movl	-36(%rbp), %edx
	imull	%edx, %eax
	movl	%eax, -36(%rbp)
.L765:
	addl	$2, -36(%rbp)
	leaq	-80(%rbp), %rax
	movl	-36(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strings__new_builder
	leaq	-80(%rbp), %rax
	movl	$91, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	movl	$0, -40(%rbp)
	jmp	.L766
.L768:
	movq	24(%rbp), %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	leaq	-80(%rbp), %rax
	movl	$39, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-80(%rbp), %rax
	movl	$39, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	movl	36(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -40(%rbp)
	jge	.L767
	leaq	.LC67(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	leaq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
.L767:
	addl	$1, -40(%rbp)
.L766:
	movl	36(%rbp), %eax
	cmpl	%eax, -40(%rbp)
	jl	.L768
	leaq	-80(%rbp), %rax
	movl	$93, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	strings__Builder_str
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	strings__Builder_free
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	addq	$88, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	array_pointers
array_pointers:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	leaq	-48(%rbp), %rax
	movl	$0, %r8d
	movl	$8, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movl	$0, -4(%rbp)
	jmp	.L771
.L772:
	movl	-4(%rbp), %esi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%esi, %edi
	call	array_get_unsafe
	addq	$32, %rsp
	movq	%rax, -56(%rbp)
	leaq	-56(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	addl	$1, -4(%rbp)
.L771:
	movl	36(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L772
	movq	-72(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-72(%rbp), %rax
	leave
	ret
	.globl	vhalt
	.hidden	vhalt
vhalt:
	pushq	%rbp
	movq	%rsp, %rbp
.L775:
	jmp	.L775
	.section	.rodata, "a"
.LC68:
	.string	"signal %d: segmentation fault\n"
	.text
	.globl	v_segmentation_fault_handler
	.hidden	v_segmentation_fault_handler
v_segmentation_fault_handler:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	stderr(%rip), %rax
	movl	-4(%rbp), %edx
	leaq	.LC68(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	call	print_backtrace
	movl	-4(%rbp), %eax
	subl	$-128, %eax
	movl	%eax, %edi
	call	_v_exit
	.globl	_v_exit
_v_exit:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	exit
	.section	.rodata, "a"
.LC69:
	.string	"ab258ae"
	.text
	.globl	vcommithash
	.hidden	vcommithash
vcommithash:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	.LC69(%rip), %rax
	movq	%rax, %rdi
	call	tos5
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC70:
	.string	"option not set ("
	.text
	.globl	panic_option_not_set
panic_option_not_set:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$104, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	movaps	%xmm0, -32(%rbp)
	leaq	.LC70(%rip), %rax
	movq	%rax, -96(%rbp)
	movl	$16, -88(%rbp)
	movl	$1, -84(%rbp)
	movl	$65040, -80(%rbp)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -72(%rbp)
	movq	%rdx, -64(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -56(%rbp)
	movl	$1, -48(%rbp)
	movl	$1, -44(%rbp)
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
	.section	.rodata, "a"
.LC71:
	.string	"result not set ("
	.text
	.globl	panic_result_not_set
panic_result_not_set:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$104, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	movaps	%xmm0, -32(%rbp)
	leaq	.LC71(%rip), %rax
	movq	%rax, -96(%rbp)
	movl	$16, -88(%rbp)
	movl	$1, -84(%rbp)
	movl	$65040, -80(%rbp)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -72(%rbp)
	movq	%rdx, -64(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -56(%rbp)
	movl	$1, -48(%rbp)
	movl	$1, -44(%rbp)
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
	.section	.rodata, "a"
.LC72:
	.string	"V panic: "
.LC73:
	.string	"v hash: "
	.text
	.globl	_v_panic
_v_panic:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$104, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rbx
	movq	%rcx, -112(%rbp)
	movq	%rbx, -104(%rbp)
	leaq	.LC72(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$9, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	eprint
	movq	-112(%rbp), %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	eprintln
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	movaps	%xmm0, -32(%rbp)
	leaq	.LC73(%rip), %rax
	movq	%rax, -96(%rbp)
	movl	$8, -88(%rbp)
	movl	$1, -84(%rbp)
	movl	$65040, -80(%rbp)
	call	vcommithash
	movq	%rax, -72(%rbp)
	movq	%rdx, -64(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -56(%rbp)
	movl	$1, -44(%rbp)
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	eprintln
	movl	$1, %edi
	call	print_backtrace_skipping_top_frames
	movl	$1, %edi
	call	exit
	.section	.rodata, "a"
.LC74:
	.string	"eprintln(NIL)"
	.text
	.globl	eprintln
eprintln:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rbx
	movq	%rcx, -32(%rbp)
	movq	%rbx, -24(%rbp)
	movq	-32(%rbp), %rcx
	testq	%rcx, %rcx
	jne	.L784
	leaq	.LC74(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$13, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	eprintln
	jmp	.L783
.L784:
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	movq	stderr(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdx
	movl	$2, %edi
	call	_writeln_to_fd
	movq	stderr(%rip), %rax
	movq	%rax, %rdi
	call	fflush
.L783:
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC75:
	.string	"eprint(NIL)"
	.text
	.globl	eprint
eprint:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rbx
	movq	%rcx, -32(%rbp)
	movq	%rbx, -24(%rbp)
	movq	-32(%rbp), %rcx
	testq	%rcx, %rcx
	jne	.L787
	leaq	.LC75(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$11, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	eprint
	jmp	.L786
.L787:
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	movq	stderr(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	movl	-24(%rbp), %edx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	_write_buf_to_fd
	movq	stderr(%rip), %rax
	movq	%rax, %rdi
	call	fflush
.L786:
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC76:
	.string	"println(NIL)"
	.text
	.globl	println
println:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rbx
	movq	%rcx, -32(%rbp)
	movq	%rbx, -24(%rbp)
	movq	-32(%rbp), %rcx
	testq	%rcx, %rcx
	jne	.L790
	leaq	.LC76(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$12, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	println
	jmp	.L789
.L790:
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdx
	movl	$1, %edi
	call	_writeln_to_fd
.L789:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	_writeln_to_fd
	.hidden	_writeln_to_fd
_writeln_to_fd:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movl	%edi, -20(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movb	$0, -1(%rbp)
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -8(%rbp)
	movl	-8(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	_v_malloc
	movq	%rax, -16(%rbp)
	movb	$1, -1(%rbp)
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rcx
	movq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movb	$10, (%rax)
	movl	-8(%rbp), %edx
	movq	-16(%rbp), %rcx
	movl	-20(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	_write_buf_to_fd
	cmpb	$0, -1(%rbp)
	je	.L794
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	_v_free
.L794:
	nop
	leave
	ret
	.globl	_write_buf_to_fd
	.hidden	_write_buf_to_fd
_write_buf_to_fd:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movl	%edx, -40(%rbp)
	cmpl	$0, -40(%rbp)
	jle	.L801
	movq	-48(%rbp), %rax
	movq	%rax, -8(%rbp)
	movl	-40(%rbp), %eax
	cltq
	movq	%rax, -16(%rbp)
	movq	$0, -32(%rbp)
	movq	stdout(%rip), %rax
	movq	%rax, -24(%rbp)
	cmpl	$2, -36(%rbp)
	jne	.L800
	movq	stderr(%rip), %rax
	movq	%rax, -24(%rbp)
.L800:
	cmpq	$0, -16(%rbp)
	jle	.L802
	movq	-16(%rbp), %rdx
	movq	-24(%rbp), %rcx
	movq	-8(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	addq	%rax, -8(%rbp)
	movq	-32(%rbp), %rax
	subq	%rax, -16(%rbp)
	jmp	.L800
.L801:
	nop
	jmp	.L795
.L802:
	nop
.L795:
	leave
	ret
	.section	.rodata, "a"
.LC77:
	.string	"malloc("
.LC78:
	.string	" <= 0)"
.LC79:
	.string	") failed"
	.text
	.globl	_v_malloc
_v_malloc:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$120, %rsp
	movq	%rdi, -120(%rbp)
	cmpq	$0, -120(%rbp)
	jg	.L804
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	leaq	.LC77(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$7, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65033, -96(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, -88(%rbp)
	leaq	.LC78(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$6, -64(%rbp)
	movl	$1, -60(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L804:
	movq	$0, -24(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L805
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	leaq	.LC77(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$7, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65033, -96(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, -88(%rbp)
	leaq	.LC79(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$8, -64(%rbp)
	movl	$1, -60(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L805:
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC80:
	.string	"malloc_noscan("
	.text
	.globl	malloc_noscan
malloc_noscan:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$120, %rsp
	movq	%rdi, -120(%rbp)
	cmpq	$0, -120(%rbp)
	jg	.L808
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	leaq	.LC80(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$14, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65033, -96(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, -88(%rbp)
	leaq	.LC78(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$6, -64(%rbp)
	movl	$1, -60(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L808:
	movq	$0, -24(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L809
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	leaq	.LC80(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$14, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65033, -96(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, -88(%rbp)
	leaq	.LC79(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$8, -64(%rbp)
	movl	$1, -60(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L809:
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	__at_least_one
	.hidden	__at_least_one
__at_least_one:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L812
	movl	$1, %eax
	jmp	.L813
.L812:
	movq	-8(%rbp), %rax
.L813:
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC81:
	.string	"malloc_uncollectable("
	.text
	.globl	malloc_uncollectable
malloc_uncollectable:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$120, %rsp
	movq	%rdi, -120(%rbp)
	cmpq	$0, -120(%rbp)
	jg	.L815
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	leaq	.LC81(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$21, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65033, -96(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, -88(%rbp)
	leaq	.LC78(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$6, -64(%rbp)
	movl	$1, -60(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L815:
	movq	$0, -24(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L816
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	leaq	.LC81(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$21, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65033, -96(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, -88(%rbp)
	leaq	.LC79(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$8, -64(%rbp)
	movl	$1, -60(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L816:
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC82:
	.string	"realloc("
	.text
	.globl	v_realloc
v_realloc:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$120, %rsp
	movq	%rdi, -120(%rbp)
	movq	%rsi, -128(%rbp)
	movq	$0, -24(%rbp)
	movq	-128(%rbp), %rdx
	movq	-120(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L819
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	leaq	.LC82(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$8, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65033, -96(%rbp)
	movq	-128(%rbp), %rax
	movq	%rax, -88(%rbp)
	leaq	.LC79(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$8, -64(%rbp)
	movl	$1, -60(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L819:
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC83:
	.string	"realloc_data("
	.text
	.globl	realloc_data
realloc_data:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$200, %rsp
	movq	%rdi, -200(%rbp)
	movl	%esi, -204(%rbp)
	movl	%edx, -208(%rbp)
	movq	$0, -24(%rbp)
	movl	-208(%rbp), %eax
	movslq	%eax, %rdx
	movq	-200(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L822
	leaq	-192(%rbp), %rdx
	movl	$0, %eax
	movl	$20, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC83(%rip), %rax
	movq	%rax, -192(%rbp)
	movl	$13, -184(%rbp)
	movl	$1, -180(%rbp)
	movl	$65041, -176(%rbp)
	movq	-200(%rbp), %rax
	movq	%rax, -168(%rbp)
	leaq	.LC67(%rip), %rax
	movq	%rax, -152(%rbp)
	movl	$2, -144(%rbp)
	movl	$1, -140(%rbp)
	movl	$65031, -136(%rbp)
	movl	-204(%rbp), %eax
	movl	%eax, -128(%rbp)
	leaq	.LC67(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$2, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65031, -96(%rbp)
	movl	-208(%rbp), %eax
	movl	%eax, -88(%rbp)
	leaq	.LC79(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$8, -64(%rbp)
	movl	$1, -60(%rbp)
	leaq	-192(%rbp), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L822:
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC84:
	.string	"calloc("
	.text
	.globl	vcalloc
vcalloc:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$104, %rsp
	movq	%rdi, -104(%rbp)
	cmpq	$0, -104(%rbp)
	jns	.L825
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	movaps	%xmm0, -32(%rbp)
	leaq	.LC84(%rip), %rax
	movq	%rax, -96(%rbp)
	movl	$7, -88(%rbp)
	movl	$1, -84(%rbp)
	movl	$65033, -80(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, -72(%rbp)
	leaq	.LC65(%rip), %rax
	movq	%rax, -56(%rbp)
	movl	$5, -48(%rbp)
	movl	$1, -44(%rbp)
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L825:
	cmpq	$0, -104(%rbp)
	jne	.L826
	movl	$0, %eax
	jmp	.L827
.L826:
	movq	-104(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	calloc
.L827:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	vcalloc_noscan
vcalloc_noscan:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	vcalloc
	leave
	ret
	.globl	_v_free
_v_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	nop
	leave
	ret
	.globl	memdup
memdup:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	cmpl	$0, -28(%rbp)
	jne	.L832
	movl	$1, %edi
	call	vcalloc
	jmp	.L833
.L832:
	movl	-28(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	_v_malloc
	movq	%rax, -8(%rbp)
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
.L833:
	leave
	ret
	.globl	memdup_noscan
memdup_noscan:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	cmpl	$0, -28(%rbp)
	jne	.L835
	movl	$1, %edi
	call	vcalloc_noscan
	jmp	.L836
.L835:
	movl	-28(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -8(%rbp)
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
.L836:
	leave
	ret
	.globl	memdup_uncollectable
memdup_uncollectable:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	cmpl	$0, -28(%rbp)
	jne	.L838
	movl	$1, %edi
	call	vcalloc
	jmp	.L839
.L838:
	movl	-28(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc_uncollectable
	movq	%rax, -8(%rbp)
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
.L839:
	leave
	ret
	.section	.rodata, "a"
.LC85:
	.string	"fixed array index out of range (index: "
.LC86:
	.string	", len: "
	.text
	.globl	v_fixed_index
	.hidden	v_fixed_index
v_fixed_index:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$160, %rsp
	movl	%edi, -148(%rbp)
	movl	%esi, -152(%rbp)
	cmpl	$0, -148(%rbp)
	js	.L841
	movl	-148(%rbp), %eax
	cmpl	-152(%rbp), %eax
	jl	.L842
.L841:
	leaq	-144(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC85(%rip), %rax
	movq	%rax, -144(%rbp)
	movl	$39, -136(%rbp)
	movl	$1, -132(%rbp)
	movl	$65031, -128(%rbp)
	movl	-148(%rbp), %eax
	movl	%eax, -120(%rbp)
	leaq	.LC86(%rip), %rax
	movq	%rax, -104(%rbp)
	movl	$7, -96(%rbp)
	movl	$1, -92(%rbp)
	movl	$65031, -88(%rbp)
	movl	-152(%rbp), %eax
	movl	%eax, -80(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$1, -56(%rbp)
	movl	$1, -52(%rbp)
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L842:
	movl	-148(%rbp), %eax
	leave
	ret
	.globl	print_backtrace
print_backtrace:
	pushq	%rbp
	movq	%rsp, %rbp
	nop
	popq	%rbp
	ret
	.globl	isnil
isnil:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	sete	%al
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC87:
	.string	"as cast: cannot cast `"
.LC88:
	.string	"` to `"
.LC89:
	.string	"`"
	.text
	.globl	__as_cast
	.hidden	__as_cast
__as_cast:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$232, %rsp
	movq	%rdi, -232(%rbp)
	movl	%esi, -236(%rbp)
	movl	%edx, -240(%rbp)
	movl	-236(%rbp), %eax
	cmpl	-240(%rbp), %eax
	je	.L848
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	as_cast_type_indexes(%rip), %rax
	movq	8+as_cast_type_indexes(%rip), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	16+as_cast_type_indexes(%rip), %rax
	movq	24+as_cast_type_indexes(%rip), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	16(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	as_cast_type_indexes(%rip), %rax
	movq	8+as_cast_type_indexes(%rip), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	16+as_cast_type_indexes(%rip), %rax
	movq	24+as_cast_type_indexes(%rip), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	16(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L849
.L852:
	movq	8+as_cast_type_indexes(%rip), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rax, %rcx
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	16(%rcx), %rax
	movq	%rax, -80(%rbp)
	movl	-96(%rbp), %eax
	cmpl	%eax, -236(%rbp)
	jne	.L850
	movq	-88(%rbp), %rdx
	movq	-80(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
.L850:
	movl	-96(%rbp), %eax
	cmpl	%eax, -240(%rbp)
	jne	.L851
	movq	-88(%rbp), %rdx
	movq	-80(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
.L851:
	addl	$1, -20(%rbp)
.L849:
	movl	20+as_cast_type_indexes(%rip), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L852
	leaq	-224(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC87(%rip), %rax
	movq	%rax, -224(%rbp)
	movl	$22, -216(%rbp)
	movl	$1, -212(%rbp)
	movl	$65040, -208(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -200(%rbp)
	movq	%rdx, -192(%rbp)
	leaq	.LC88(%rip), %rax
	movq	%rax, -184(%rbp)
	movl	$6, -176(%rbp)
	movl	$1, -172(%rbp)
	movl	$65040, -168(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	leaq	.LC89(%rip), %rax
	movq	%rax, -144(%rbp)
	movl	$1, -136(%rbp)
	movl	$1, -132(%rbp)
	leaq	-224(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L848:
	movq	-232(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	VAssertMetaInfo_free
VAssertMetaInfo_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$24, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$40, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$56, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$72, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$88, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$104, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$120, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$136, %rax
	movq	%rax, %rdi
	call	string_free
	nop
	leave
	ret
	.globl	builtin_init
	.hidden	builtin_init
builtin_init:
	pushq	%rbp
	movq	%rsp, %rbp
	nop
	popq	%rbp
	ret
	.globl	print_backtrace_skipping_top_frames
	.hidden	print_backtrace_skipping_top_frames
print_backtrace_skipping_top_frames:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	-20(%rbp), %eax
	addl	$2, %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	print_backtrace_skipping_top_frames_linux
	leave
	ret
	.globl	print_backtrace_skipping_top_frames_linux
	.hidden	print_backtrace_skipping_top_frames_linux
print_backtrace_skipping_top_frames_linux:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	$1, %eax
	popq	%rbp
	ret
	.globl	vstrlen
vstrlen:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	leave
	ret
	.globl	vstrlen_char
vstrlen_char:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	leave
	ret
	.globl	vmemcpy
vmemcpy:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %rdx
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	leave
	ret
	.globl	vmemmove
vmemmove:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %rdx
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memmove
	leave
	ret
	.globl	vmemcmp
vmemcmp:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %rdx
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcmp
	leave
	ret
	.globl	vmemset
vmemset:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %rdx
	movl	-12(%rbp), %ecx
	movq	-8(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	memset
	leave
	ret
	.globl	isize_str
isize_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	i64_str
	leave
	ret
	.globl	usize_str
usize_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	u64_str
	leave
	ret
	.globl	char_str
char_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	u64_hex
	leave
	ret
	.globl	int_str_l
	.hidden	int_str_l
int_str_l:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$72, %rsp
	movl	%edi, -68(%rbp)
	movl	%esi, -72(%rbp)
	movl	-68(%rbp), %ecx
	movslq	%ecx, %rcx
	movq	%rcx, -24(%rbp)
	movl	$0, -28(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L879
	leaq	.LC43(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$1, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L880
.L879:
	movb	$0, -29(%rbp)
	cmpq	$0, -24(%rbp)
	jns	.L881
	negq	-24(%rbp)
	movb	$1, -29(%rbp)
.L881:
	movl	-72(%rbp), %eax
	movl	%eax, -36(%rbp)
	movl	-72(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -48(%rbp)
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	subl	$1, -36(%rbp)
.L884:
	cmpq	$0, -24(%rbp)
	jle	.L889
	movq	-24(%rbp), %rcx
	movabsq	$-6640827866535438581, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	leaq	(%rdx,%rcx), %rax
	sarq	$6, %rax
	sarq	$63, %rcx
	movq	%rcx, %rdx
	subq	%rdx, %rax
	movl	%eax, -52(%rbp)
	movq	-24(%rbp), %rax
	movl	%eax, %edx
	movl	-52(%rbp), %eax
	imull	$-100, %eax, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, -28(%rbp)
	movl	-52(%rbp), %eax
	cltq
	movq	%rax, -24(%rbp)
	movq	_const_digit_pairs(%rip), %rdx
	movl	-28(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	subl	$1, -36(%rbp)
	addl	$1, -28(%rbp)
	movq	_const_digit_pairs(%rip), %rdx
	movl	-28(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	subl	$1, -36(%rbp)
	jmp	.L884
.L889:
	nop
	addl	$1, -36(%rbp)
	cmpl	$19, -28(%rbp)
	jg	.L885
	addl	$1, -36(%rbp)
.L885:
	cmpb	$0, -29(%rbp)
	je	.L886
	subl	$1, -36(%rbp)
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movb	$45, (%rax)
.L886:
	movl	-72(%rbp), %eax
	subl	-36(%rbp), %eax
	movl	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	movl	-36(%rbp), %eax
	movslq	%eax, %rcx
	movq	-48(%rbp), %rax
	addq	%rax, %rcx
	movq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemmove
	movl	-56(%rbp), %edx
	movq	-48(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
.L880:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	i8_str
i8_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, %eax
	movb	%al, -4(%rbp)
	movsbl	-4(%rbp), %eax
	movl	$5, %esi
	movl	%eax, %edi
	call	int_str_l
	leave
	ret
	.globl	i16_str
i16_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, %eax
	movw	%ax, -4(%rbp)
	movswl	-4(%rbp), %eax
	movl	$7, %esi
	movl	%eax, %edi
	call	int_str_l
	leave
	ret
	.globl	u16_str
u16_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	movl	$7, %esi
	movl	%eax, %edi
	call	int_str_l
	leave
	ret
	.globl	int_str
int_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	$12, %esi
	movl	%eax, %edi
	call	int_str_l
	leave
	ret
	.globl	u32_str
u32_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movl	%edi, -52(%rbp)
	movl	-52(%rbp), %ecx
	movl	%ecx, -20(%rbp)
	movl	$0, -24(%rbp)
	cmpl	$0, -20(%rbp)
	jne	.L899
	leaq	.LC43(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$1, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L900
.L899:
	movl	$12, -32(%rbp)
	movl	-32(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -40(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	subl	$1, -28(%rbp)
.L903:
	cmpl	$0, -20(%rbp)
	je	.L907
	movl	-20(%rbp), %eax
	movl	%eax, %eax
	imulq	$1374389535, %rax, %rax
	shrq	$32, %rax
	shrl	$5, %eax
	movl	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	imull	$100, %eax, %eax
	movl	-20(%rbp), %edx
	subl	%eax, %edx
	leal	(%rdx,%rdx), %eax
	movl	%eax, -24(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, -20(%rbp)
	movq	_const_digit_pairs(%rip), %rdx
	movl	-24(%rbp), %eax
	addq	%rdx, %rax
	movl	-28(%rbp), %edx
	movslq	%edx, %rcx
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	subl	$1, -28(%rbp)
	addl	$1, -24(%rbp)
	movq	_const_digit_pairs(%rip), %rdx
	movl	-24(%rbp), %eax
	addq	%rdx, %rax
	movl	-28(%rbp), %edx
	movslq	%edx, %rcx
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	subl	$1, -28(%rbp)
	jmp	.L903
.L907:
	nop
	addl	$1, -28(%rbp)
	cmpl	$19, -24(%rbp)
	ja	.L904
	addl	$1, -28(%rbp)
.L904:
	movl	-32(%rbp), %eax
	subl	-28(%rbp), %eax
	movl	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	movl	-28(%rbp), %eax
	movslq	%eax, %rcx
	movq	-40(%rbp), %rax
	addq	%rax, %rcx
	movq	-40(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemmove
	movl	-48(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
.L900:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	int_literal_str
int_literal_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	i64_str
	leave
	ret
	.section	.rodata, "a"
.LC90:
	.string	"-9223372036854775808"
	.text
	.globl	i64_str
i64_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$88, %rsp
	movq	%rdi, -88(%rbp)
	movq	-88(%rbp), %rcx
	movq	%rcx, -24(%rbp)
	movq	$0, -32(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L911
	leaq	.LC43(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$1, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L912
.L911:
	movabsq	$-9223372036854775808, %rcx
	cmpq	%rcx, -24(%rbp)
	jne	.L913
	leaq	.LC90(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$20, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L912
.L913:
	movl	$20, -44(%rbp)
	movl	-44(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -56(%rbp)
	movb	$0, -33(%rbp)
	cmpq	$0, -24(%rbp)
	jns	.L914
	negq	-24(%rbp)
	movb	$1, -33(%rbp)
.L914:
	movl	-44(%rbp), %eax
	movl	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	subl	$1, -40(%rbp)
.L917:
	cmpq	$0, -24(%rbp)
	jle	.L922
	movq	-24(%rbp), %rcx
	movabsq	$-6640827866535438581, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	leaq	(%rdx,%rcx), %rax
	sarq	$6, %rax
	movq	%rcx, %rdx
	sarq	$63, %rdx
	subq	%rdx, %rax
	movq	%rax, -64(%rbp)
	movq	-24(%rbp), %rax
	movl	%eax, %edx
	movq	-64(%rbp), %rax
	imull	$100, %eax, %eax
	subl	%eax, %edx
	leal	(%rdx,%rdx), %eax
	movl	%eax, %eax
	movq	%rax, -32(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	_const_digit_pairs(%rip), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rcx
	movq	-56(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	subl	$1, -40(%rbp)
	addq	$1, -32(%rbp)
	movq	_const_digit_pairs(%rip), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rcx
	movq	-56(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	subl	$1, -40(%rbp)
	jmp	.L917
.L922:
	nop
	addl	$1, -40(%rbp)
	cmpq	$19, -32(%rbp)
	jg	.L918
	addl	$1, -40(%rbp)
.L918:
	cmpb	$0, -33(%rbp)
	je	.L919
	subl	$1, -40(%rbp)
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movb	$45, (%rax)
.L919:
	movl	-44(%rbp), %eax
	subl	-40(%rbp), %eax
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	movl	-40(%rbp), %eax
	movslq	%eax, %rcx
	movq	-56(%rbp), %rax
	addq	%rax, %rcx
	movq	-56(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemmove
	movl	-68(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
.L912:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	u64_str
u64_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$72, %rsp
	movq	%rdi, -72(%rbp)
	movq	-72(%rbp), %rcx
	movq	%rcx, -24(%rbp)
	movq	$0, -32(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L924
	leaq	.LC43(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$1, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L925
.L924:
	movl	$20, -40(%rbp)
	movl	-40(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -48(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	subl	$1, -36(%rbp)
.L928:
	cmpq	$0, -24(%rbp)
	je	.L932
	movq	-24(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	subq	%rdx, %rax
	addq	%rax, %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	_const_digit_pairs(%rip), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	subl	$1, -36(%rbp)
	addq	$1, -32(%rbp)
	movq	_const_digit_pairs(%rip), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	subl	$1, -36(%rbp)
	jmp	.L928
.L932:
	nop
	addl	$1, -36(%rbp)
	cmpq	$19, -32(%rbp)
	ja	.L929
	addl	$1, -36(%rbp)
.L929:
	movl	-40(%rbp), %eax
	subl	-36(%rbp), %eax
	movl	%eax, -60(%rbp)
	movl	-60(%rbp), %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	movl	-36(%rbp), %eax
	movslq	%eax, %rcx
	movq	-48(%rbp), %rax
	addq	%rax, %rcx
	movq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemmove
	movl	-60(%rbp), %edx
	movq	-48(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
.L925:
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC91:
	.string	"true"
.LC92:
	.string	"false"
	.text
	.globl	bool_str
bool_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movl	%edi, %ecx
	movb	%cl, -20(%rbp)
	cmpb	$0, -20(%rbp)
	je	.L934
	leaq	.LC91(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$4, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L935
.L934:
	leaq	.LC92(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$5, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
.L935:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	u64_to_hex
	.hidden	u64_to_hex
u64_to_hex:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, %eax
	movb	%al, -60(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	movb	$0, -32(%rbp)
	movzbl	-60(%rbp), %eax
	cltq
	movb	$0, -48(%rbp,%rax)
	movl	$0, -28(%rbp)
	movzbl	-60(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -28(%rbp)
	jmp	.L938
.L941:
	movq	-24(%rbp), %rax
	andl	$15, %eax
	movb	%al, -29(%rbp)
	cmpb	$9, -29(%rbp)
	ja	.L939
	movzbl	-29(%rbp), %eax
	addl	$48, %eax
	jmp	.L940
.L939:
	movzbl	-29(%rbp), %eax
	addl	$87, %eax
.L940:
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	movb	%al, -48(%rbp,%rdx)
	shrq	$4, -24(%rbp)
	subl	$1, -28(%rbp)
.L938:
	cmpl	$0, -28(%rbp)
	jns	.L941
	movzbl	-60(%rbp), %ebx
	movzbl	-60(%rbp), %eax
	leal	1(%rax), %edx
	leaq	-48(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	memdup
	movl	%ebx, %esi
	movq	%rax, %rdi
	call	tos
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	u64_to_hex_no_leading_zeros
	.hidden	u64_to_hex_no_leading_zeros
u64_to_hex_no_leading_zeros:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, %eax
	movb	%al, -60(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	movb	$0, -32(%rbp)
	movzbl	-60(%rbp), %eax
	cltq
	movb	$0, -48(%rbp,%rax)
	movl	$0, -12(%rbp)
	movzbl	-60(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -12(%rbp)
	jmp	.L944
.L949:
	movq	-8(%rbp), %rax
	andl	$15, %eax
	movb	%al, -13(%rbp)
	cmpb	$9, -13(%rbp)
	ja	.L945
	movzbl	-13(%rbp), %eax
	addl	$48, %eax
	jmp	.L946
.L945:
	movzbl	-13(%rbp), %eax
	addl	$87, %eax
.L946:
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	movb	%al, -48(%rbp,%rdx)
	shrq	$4, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L951
	subl	$1, -12(%rbp)
.L944:
	cmpl	$0, -12(%rbp)
	jns	.L949
	jmp	.L948
.L951:
	nop
.L948:
	movzbl	-60(%rbp), %eax
	subl	-12(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	leal	1(%rax), %edx
	leaq	-48(%rbp), %rcx
	movl	-12(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	movl	-20(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	tos
	leave
	ret
	.section	.rodata, "a"
.LC93:
	.string	"00"
	.text
	.globl	u8_hex
u8_hex:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movl	%edi, %ecx
	movb	%cl, -20(%rbp)
	cmpb	$0, -20(%rbp)
	jne	.L953
	leaq	.LC93(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$2, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L954
.L953:
	movzbl	-20(%rbp), %eax
	movl	$2, %esi
	movq	%rax, %rdi
	call	u64_to_hex
.L954:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	u64_hex
u64_hex:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L956
	leaq	.LC43(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$1, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L957
.L956:
	movq	-24(%rbp), %rax
	movl	$16, %esi
	movq	%rax, %rdi
	call	u64_to_hex_no_leading_zeros
.L957:
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC94:
	.string	"0x"
	.text
	.globl	voidptr_str
voidptr_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	u64_hex
	leaq	.LC94(%rip), %r12
	movq	%r13, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$2, %rcx
	movq	%rcx, %r13
	movq	%r13, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %r13
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rsi, %rdi
	movq	%rbx, %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__plus
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	byteptr_str
byteptr_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	u64_hex
	leaq	.LC94(%rip), %r12
	movq	%r13, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$2, %rcx
	movq	%rcx, %r13
	movq	%r13, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %r13
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rsi, %rdi
	movq	%rbx, %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__plus
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	charptr_str
charptr_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	u64_hex
	leaq	.LC94(%rip), %r12
	movq	%r13, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$2, %rcx
	movq	%rcx, %r13
	movq	%r13, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %r13
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rsi, %rdi
	movq	%rbx, %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__plus
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	u8_str
u8_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, %eax
	movb	%al, -4(%rbp)
	movzbl	-4(%rbp), %eax
	movl	$7, %esi
	movl	%eax, %edi
	call	int_str_l
	leave
	ret
	.globl	u8_ascii_str
u8_ascii_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movl	%edi, %eax
	movb	%al, -36(%rbp)
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	movl	$2, %edi
	call	malloc_noscan
	movq	%rax, -32(%rbp)
	movl	$1, -24(%rbp)
	movq	-32(%rbp), %rax
	movzbl	-36(%rbp), %edx
	movb	%dl, (%rax)
	movq	-32(%rbp), %rax
	addq	$1, %rax
	movb	$0, (%rax)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC95:
	.string	"`\\0`"
.LC96:
	.string	"`\\a`"
.LC97:
	.string	"`\\b`"
.LC98:
	.string	"`\\t`"
.LC99:
	.string	"`\\n`"
.LC100:
	.string	"`\\v`"
.LC101:
	.string	"`\\f`"
.LC102:
	.string	"`\\r`"
.LC103:
	.string	"`\\e`"
	.text
	.globl	u8_str_escaped
u8_str_escaped:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$88, %rsp
	movl	%edi, %eax
	movb	%al, -100(%rbp)
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$1, -36(%rbp)
	cmpb	$0, -100(%rbp)
	jne	.L969
	leaq	.LC95(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$4, -40(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L970
.L969:
	cmpb	$7, -100(%rbp)
	jne	.L971
	leaq	.LC96(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$4, -40(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L970
.L971:
	cmpb	$8, -100(%rbp)
	jne	.L972
	leaq	.LC97(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$4, -40(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L970
.L972:
	cmpb	$9, -100(%rbp)
	jne	.L973
	leaq	.LC98(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$4, -40(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L970
.L973:
	cmpb	$10, -100(%rbp)
	jne	.L974
	leaq	.LC99(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$4, -40(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L970
.L974:
	cmpb	$11, -100(%rbp)
	jne	.L975
	leaq	.LC100(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$4, -40(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L970
.L975:
	cmpb	$12, -100(%rbp)
	jne	.L976
	leaq	.LC101(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$4, -40(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L970
.L976:
	cmpb	$13, -100(%rbp)
	jne	.L977
	leaq	.LC102(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$4, -40(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L970
.L977:
	cmpb	$27, -100(%rbp)
	jne	.L978
	leaq	.LC103(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$4, -40(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L970
.L978:
	cmpb	$31, -100(%rbp)
	jbe	.L979
	cmpb	$126, -100(%rbp)
	ja	.L979
	movzbl	-100(%rbp), %eax
	movl	%eax, %edi
	call	u8_ascii_str
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	jmp	.L970
.L979:
	movzbl	-100(%rbp), %eax
	movl	%eax, %edi
	call	u8_hex
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	leaq	.LC94(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rsi, %rdi
	movq	%rbx, %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__plus
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
.L970:
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	addq	$88, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	Array_u8_bytestr
Array_u8_bytestr:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movl	36(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -24(%rbp)
	movl	36(%rbp), %eax
	movslq	%eax, %rdx
	movq	24(%rbp), %rcx
	movq	-24(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movl	36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	36(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	fast_string_eq
	.hidden	fast_string_eq
fast_string_eq:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -16(%rbp)
	movq	%rdi, -8(%rbp)
	movq	%rdx, -32(%rbp)
	movq	%rcx, -24(%rbp)
	movl	-8(%rbp), %edx
	movl	-24(%rbp), %eax
	cmpl	%eax, %edx
	je	.L984
	movl	$0, %eax
	jmp	.L985
.L984:
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rcx
	movq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcmp
	testl	%eax, %eax
	sete	%al
.L985:
	leave
	ret
	.globl	map_hash_string
	.hidden	map_hash_string
map_hash_string:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movl	-8(%rbp), %eax
	movslq	%eax, %rsi
	movq	-16(%rbp), %rax
	leaq	_wyp(%rip), %rdx
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	%rax, %rdi
	call	wyhash
	leave
	ret
	.globl	map_hash_int_1
	.hidden	map_hash_int_1
map_hash_int_1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	$0, %esi
	movq	%rax, %rdi
	call	wyhash64
	leave
	ret
	.globl	map_hash_int_2
	.hidden	map_hash_int_2
map_hash_int_2:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	movl	$0, %esi
	movq	%rax, %rdi
	call	wyhash64
	leave
	ret
	.globl	map_hash_int_4
	.hidden	map_hash_int_4
map_hash_int_4:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %eax
	movl	$0, %esi
	movq	%rax, %rdi
	call	wyhash64
	leave
	ret
	.globl	map_hash_int_8
	.hidden	map_hash_int_8
map_hash_int_8:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	wyhash64
	leave
	ret
	.globl	DenseArray_zeros_to_end
	.hidden	DenseArray_zeros_to_end
DenseArray_zeros_to_end:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%rbx
	subq	$48, %rsp
	movq	%rdi, -56(%rbp)
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	movq	%rax, %rdi
	call	_v_malloc
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	cltq
	movq	%rax, %rdi
	call	_v_malloc
	movq	%rax, -40(%rbp)
	movl	$0, -20(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L997
.L1000:
	movl	-24(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	DenseArray_has_index
	testb	%al, %al
	je	.L998
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	je	.L999
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rbx
	movl	-20(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	DenseArray_key
	movq	%rax, %rcx
	movq	-40(%rbp), %rax
	movq	%rbx, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rbx
	movl	-24(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	DenseArray_key
	movq	%rax, %r12
	movl	-20(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	DenseArray_key
	movq	%rbx, %rdx
	movq	%r12, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rbx
	movl	-24(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	DenseArray_key
	movq	%rax, %rcx
	movq	-40(%rbp), %rax
	movq	%rbx, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcpy
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rbx
	movl	-20(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	DenseArray_value
	movq	%rax, %rcx
	movq	-32(%rbp), %rax
	movq	%rbx, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rbx
	movl	-24(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	DenseArray_value
	movq	%rax, %r12
	movl	-20(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	DenseArray_value
	movq	%rbx, %rdx
	movq	%r12, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rbx
	movl	-24(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	DenseArray_value
	movq	%rax, %rcx
	movq	-32(%rbp), %rax
	movq	%rbx, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcpy
.L999:
	addl	$1, -20(%rbp)
.L998:
	addl	$1, -24(%rbp)
.L997:
	movq	-56(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, -24(%rbp)
	jl	.L1000
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-56(%rbp), %rax
	movl	$0, 16(%rax)
	movq	-56(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-56(%rbp), %rax
	movl	-20(%rbp), %edx
	movl	%edx, 12(%rax)
	movq	-56(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, -44(%rbp)
	movl	-20(%rbp), %eax
	movl	$8, %edx
	cmpl	%edx, %eax
	cmovgel	%eax, %edx
	movq	-56(%rbp), %rax
	movl	%edx, 8(%rax)
	movq	-56(%rbp), %rax
	movl	4(%rax), %edx
	movq	-56(%rbp), %rax
	movl	8(%rax), %eax
	imull	%eax, %edx
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	imull	-44(%rbp), %eax
	movl	%eax, %ecx
	movq	-56(%rbp), %rax
	movq	40(%rax), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	realloc_data
	movq	-56(%rbp), %rdx
	movq	%rax, 40(%rdx)
	movq	-56(%rbp), %rax
	movl	(%rax), %edx
	movq	-56(%rbp), %rax
	movl	8(%rax), %eax
	imull	%eax, %edx
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	imull	-44(%rbp), %eax
	movl	%eax, %ecx
	movq	-56(%rbp), %rax
	movq	32(%rax), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	realloc_data
	movq	-56(%rbp), %rdx
	movq	%rax, 32(%rdx)
	nop
	addq	$48, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	ret
	.globl	new_dense_array
	.hidden	new_dense_array
new_dense_array:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$88, %rsp
	movq	%rdi, -88(%rbp)
	movl	%esi, -92(%rbp)
	movl	%edx, -96(%rbp)
	movl	$8, -20(%rbp)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movl	-92(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	__at_least_one
	movq	%rax, %rdi
	call	_v_malloc
	movq	%rax, %rbx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movl	-96(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	__at_least_one
	movq	%rax, %rdi
	call	_v_malloc
	movq	-88(%rbp), %rdx
	movl	-92(%rbp), %ecx
	movl	%ecx, (%rdx)
	movq	-88(%rbp), %rdx
	movl	-96(%rbp), %ecx
	movl	%ecx, 4(%rdx)
	movq	-88(%rbp), %rdx
	movl	-20(%rbp), %ecx
	movl	%ecx, 8(%rdx)
	movq	-88(%rbp), %rdx
	movl	$0, 12(%rdx)
	movq	-88(%rbp), %rdx
	movl	$0, 16(%rdx)
	movq	-88(%rbp), %rdx
	movq	$0, 24(%rdx)
	movq	-88(%rbp), %rdx
	movq	%rbx, 32(%rdx)
	movq	-88(%rbp), %rdx
	movq	%rax, 40(%rdx)
	movq	-88(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	DenseArray_key
	.hidden	DenseArray_key
DenseArray_key:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movq	32(%rax), %rdx
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	imull	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	popq	%rbp
	ret
	.globl	DenseArray_value
	.hidden	DenseArray_value
DenseArray_value:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movq	40(%rax), %rdx
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	imull	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	popq	%rbp
	ret
	.globl	DenseArray_has_index
	.hidden	DenseArray_has_index
DenseArray_has_index:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	testl	%eax, %eax
	je	.L1008
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L1009
.L1008:
	movl	$1, %eax
	jmp	.L1010
.L1009:
	movl	$0, %eax
.L1010:
	popq	%rbp
	ret
	.globl	DenseArray_expand
	.hidden	DenseArray_expand
DenseArray_expand:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, -4(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movl	-4(%rbp), %edx
	imull	%edx, %eax
	movl	%eax, -8(%rbp)
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	movl	-4(%rbp), %edx
	imull	%edx, %eax
	movl	%eax, -12(%rbp)
	movq	-24(%rbp), %rax
	movl	8(%rax), %edx
	movq	-24(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, %edx
	jne	.L1013
	movq	-24(%rbp), %rax
	movl	8(%rax), %edx
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	sarl	$3, %eax
	addl	%eax, %edx
	movq	-24(%rbp), %rax
	movl	%edx, 8(%rax)
	movq	-24(%rbp), %rax
	movl	(%rax), %edx
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	imull	%eax, %edx
	movq	-24(%rbp), %rax
	movq	32(%rax), %rax
	movl	-8(%rbp), %ecx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	realloc_data
	movq	-24(%rbp), %rdx
	movq	%rax, 32(%rdx)
	movq	-24(%rbp), %rax
	movl	4(%rax), %edx
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	imull	%eax, %edx
	movq	-24(%rbp), %rax
	movq	40(%rax), %rax
	movl	-12(%rbp), %ecx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	realloc_data
	movq	-24(%rbp), %rdx
	movq	%rax, 40(%rdx)
	movq	-24(%rbp), %rax
	movl	16(%rax), %eax
	testl	%eax, %eax
	je	.L1013
	movq	-24(%rbp), %rax
	movl	8(%rax), %edx
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movl	-4(%rbp), %ecx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	realloc_data
	movq	-24(%rbp), %rdx
	movq	%rax, 24(%rdx)
	movq	-24(%rbp), %rax
	movl	8(%rax), %edx
	movq	-24(%rbp), %rax
	movl	12(%rax), %eax
	subl	%eax, %edx
	movslq	%edx, %rax
	movq	-24(%rbp), %rdx
	movq	24(%rdx), %rcx
	movq	-24(%rbp), %rdx
	movl	12(%rdx), %edx
	movslq	%edx, %rdx
	addq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$0, %esi
	movq	%rcx, %rdi
	call	vmemset
.L1013:
	movq	-24(%rbp), %rax
	movl	12(%rax), %eax
	movl	%eax, -16(%rbp)
	movq	-24(%rbp), %rax
	movl	16(%rax), %eax
	testl	%eax, %eax
	je	.L1014
	movq	-24(%rbp), %rax
	movq	24(%rax), %rdx
	movl	-16(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
.L1014:
	movq	-24(%rbp), %rax
	movl	12(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 12(%rax)
	movl	-16(%rbp), %eax
	leave
	ret
	.globl	map_eq_string
	.hidden	map_eq_string
map_eq_string:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	-8(%rbp), %rcx
	movq	(%rcx), %rdi
	movq	8(%rcx), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	fast_string_eq
	leave
	ret
	.globl	map_eq_int_1
	.hidden	map_eq_int_1
map_eq_int_1:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %edx
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	sete	%al
	popq	%rbp
	ret
	.globl	map_eq_int_2
	.hidden	map_eq_int_2
map_eq_int_2:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movzwl	(%rax), %edx
	movq	-16(%rbp), %rax
	movzwl	(%rax), %eax
	cmpw	%ax, %dx
	sete	%al
	popq	%rbp
	ret
	.globl	map_eq_int_4
	.hidden	map_eq_int_4
map_eq_int_4:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	sete	%al
	popq	%rbp
	ret
	.globl	map_eq_int_8
	.hidden	map_eq_int_8
map_eq_int_8:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, %rdx
	sete	%al
	popq	%rbp
	ret
	.globl	map_clone_string
	.hidden	map_clone_string
map_clone_string:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	nop
	leave
	ret
	.globl	map_clone_int_1
	.hidden	map_clone_int_1
map_clone_int_1:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movzbl	(%rax), %edx
	movq	-8(%rbp), %rax
	movb	%dl, (%rax)
	nop
	popq	%rbp
	ret
	.globl	map_clone_int_2
	.hidden	map_clone_int_2
map_clone_int_2:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movzwl	(%rax), %edx
	movq	-8(%rbp), %rax
	movw	%dx, (%rax)
	nop
	popq	%rbp
	ret
	.globl	map_clone_int_4
	.hidden	map_clone_int_4
map_clone_int_4:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, (%rax)
	nop
	popq	%rbp
	ret
	.globl	map_clone_int_8
	.hidden	map_clone_int_8
map_clone_int_8:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	ret
	.globl	map_free_string
	.hidden	map_free_string
map_free_string:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	leaq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	nop
	leave
	ret
	.globl	map_free_nop
	.hidden	map_free_nop
map_free_nop:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	nop
	popq	%rbp
	ret
	.globl	new_map
	.hidden	new_map
new_map:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$248, %rsp
	movq	%rdi, -216(%rbp)
	movl	%esi, -220(%rbp)
	movl	%edx, -224(%rbp)
	movq	%rcx, -232(%rbp)
	movq	%r8, -240(%rbp)
	movq	%r9, -248(%rbp)
	movl	$144, -20(%rbp)
	movl	-220(%rbp), %eax
	movl	%eax, %esi
	movl	$8, %edi
	call	_us32_lt
	movb	%al, -21(%rbp)
	leaq	-80(%rbp), %rax
	movl	-224(%rbp), %edx
	movl	-220(%rbp), %ecx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	new_dense_array
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	vcalloc_noscan
	movq	%rax, %rdx
	movq	-216(%rbp), %rax
	movl	-220(%rbp), %ecx
	movl	%ecx, (%rax)
	movq	-216(%rbp), %rax
	movl	-224(%rbp), %ecx
	movl	%ecx, 4(%rax)
	movq	-216(%rbp), %rax
	movl	$30, 8(%rax)
	movq	-216(%rbp), %rax
	movb	$16, 12(%rax)
	movq	-216(%rbp), %rax
	movb	$5, 13(%rax)
	movq	-216(%rbp), %rax
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	-216(%rbp), %rax
	movq	%rdx, 64(%rax)
	movq	-216(%rbp), %rax
	movl	$4, 72(%rax)
	movq	-216(%rbp), %rax
	movzbl	-21(%rbp), %edx
	movb	%dl, 76(%rax)
	movq	-216(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rdx, 80(%rax)
	movq	-216(%rbp), %rax
	movq	-240(%rbp), %rdx
	movq	%rdx, 88(%rax)
	movq	-216(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rdx, 96(%rax)
	movq	-216(%rbp), %rax
	movq	16(%rbp), %rdx
	movq	%rdx, 104(%rax)
	movq	-216(%rbp), %rax
	movl	$0, 112(%rax)
	movq	-216(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	new_map_init
	.hidden	new_map_init
new_map_init:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$200, %rsp
	movq	%rdi, -168(%rbp)
	movq	%rsi, -176(%rbp)
	movq	%rdx, -184(%rbp)
	movq	%rcx, -192(%rbp)
	movq	%r8, -200(%rbp)
	movl	%r9d, -204(%rbp)
	leaq	-160(%rbp), %rax
	movq	-192(%rbp), %r8
	movq	-184(%rbp), %rdi
	movq	-176(%rbp), %rcx
	movl	24(%rbp), %edx
	movl	16(%rbp), %esi
	subq	$8, %rsp
	pushq	-200(%rbp)
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	new_map
	addq	$16, %rsp
	movq	32(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	40(%rbp), %rax
	movq	%rax, -32(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L1036
.L1037:
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rcx
	leaq	-160(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	map_set
	movl	16(%rbp), %eax
	cltq
	addq	%rax, -24(%rbp)
	movl	24(%rbp), %eax
	cltq
	addq	%rax, -32(%rbp)
	addl	$1, -36(%rbp)
.L1036:
	movl	-36(%rbp), %eax
	cmpl	-204(%rbp), %eax
	jl	.L1037
	movq	-168(%rbp), %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 64(%rax)
	movq	%rbx, 72(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 80(%rax)
	movq	%rbx, 88(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 96(%rax)
	movq	%rbx, 104(%rax)
	movq	-48(%rbp), %rdx
	movq	%rdx, 112(%rax)
	movq	-168(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	map_move
map_move:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$152, %rsp
	movq	%rdi, -152(%rbp)
	movq	%rsi, -160(%rbp)
	movq	-160(%rbp), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -144(%rbp)
	movq	%rbx, -136(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -128(%rbp)
	movq	%rbx, -120(%rbp)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, -112(%rbp)
	movq	%rbx, -104(%rbp)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, -96(%rbp)
	movq	%rbx, -88(%rbp)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, -80(%rbp)
	movq	%rbx, -72(%rbp)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, -64(%rbp)
	movq	%rbx, -56(%rbp)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, -48(%rbp)
	movq	%rbx, -40(%rbp)
	movq	112(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-160(%rbp), %rax
	movl	$120, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	vmemset
	movq	-152(%rbp), %rax
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 64(%rax)
	movq	%rbx, 72(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 80(%rax)
	movq	%rbx, 88(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 96(%rax)
	movq	%rbx, 104(%rax)
	movq	-32(%rbp), %rdx
	movq	%rdx, 112(%rax)
	movq	-152(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	map_clear
map_clear:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, 112(%rax)
	movq	-8(%rbp), %rax
	movl	$0, 8(%rax)
	movq	-8(%rbp), %rax
	movl	$0, 28(%rax)
	nop
	popq	%rbp
	ret
	.globl	map_key_to_index
	.hidden	map_key_to_index
map_key_to_index:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-56(%rbp), %rax
	movq	80(%rax), %rdx
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	*%rdx
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, %eax
	andq	-24(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movzbl	13(%rax), %eax
	movzbl	%al, %eax
	movq	-24(%rbp), %rdx
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	movl	$16777215, %edx
	movl	%edx, %edx
	andq	%rdx, %rax
	movl	$16777216, %edx
	movl	%edx, %edx
	orq	%rdx, %rax
	movq	%rax, -40(%rbp)
	movq	-32(%rbp), %rax
	movl	%eax, %edx
	movq	-40(%rbp), %rax
	movl	%eax, %ecx
	movl	%edx, %edx
	movabsq	$-4294967296, %rax
	andq	%rbx, %rax
	orq	%rdx, %rax
	movq	%rax, %rbx
	movl	%ecx, %eax
	salq	$32, %rax
	movl	%ebx, %edx
	orq	%rdx, %rax
	movq	%rax, %rbx
	movq	%rbx, %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	map_meta_less
	.hidden	map_meta_less
map_meta_less:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movl	-28(%rbp), %edx
	movl	%edx, -4(%rbp)
	movl	-32(%rbp), %edx
	movl	%edx, -8(%rbp)
.L1047:
	movq	-24(%rbp), %rdx
	movq	64(%rdx), %rdx
	movl	-4(%rbp), %ecx
	salq	$2, %rcx
	addq	%rcx, %rdx
	movl	(%rdx), %edx
	cmpl	%edx, -8(%rbp)
	jnb	.L1050
	addl	$2, -4(%rbp)
	movl	$16777216, %edx
	addl	%edx, -8(%rbp)
	jmp	.L1047
.L1050:
	nop
	movl	-4(%rbp), %edx
	movabsq	$-4294967296, %rcx
	andq	%rcx, %rax
	orq	%rdx, %rax
	movl	-8(%rbp), %edx
	salq	$32, %rdx
	movl	%eax, %eax
	orq	%rdx, %rax
	popq	%rbp
	ret
	.globl	map_meta_greater
	.hidden	map_meta_greater
map_meta_greater:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movl	%edx, -48(%rbp)
	movl	%ecx, -52(%rbp)
	movl	-48(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	-52(%rbp), %eax
	movl	%eax, -12(%rbp)
.L1055:
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-8(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L1057
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-8(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	-4(%rbp), %eax
	jnb	.L1054
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-8(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -16(%rbp)
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-8(%rbp), %edx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movl	%eax, (%rdx)
	movl	-16(%rbp), %eax
	movl	%eax, -4(%rbp)
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-8(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -20(%rbp)
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-8(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	-12(%rbp), %eax
	movl	%eax, (%rdx)
	movl	-20(%rbp), %eax
	movl	%eax, -12(%rbp)
.L1054:
	addl	$2, -8(%rbp)
	movl	$16777216, %eax
	addl	%eax, -4(%rbp)
	jmp	.L1055
.L1057:
	nop
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-8(%rbp), %edx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movl	%eax, (%rdx)
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-8(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	-12(%rbp), %eax
	movl	%eax, (%rdx)
	movl	-4(%rbp), %eax
	shrl	$24, %eax
	subl	$1, %eax
	movl	%eax, -24(%rbp)
	movl	-24(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	map_ensure_extra_metas
	nop
	leave
	ret
	.section	.rodata, "a"
.LC104:
	.string	"Probe overflow"
	.text
	.globl	map_ensure_extra_metas
	.hidden	map_ensure_extra_metas
map_ensure_extra_metas:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, -72(%rbp)
	movl	%esi, -76(%rbp)
	movl	-76(%rbp), %eax
	leal	(%rax,%rax), %edx
	movq	-72(%rbp), %rax
	movl	72(%rax), %eax
	cmpl	%eax, %edx
	jne	.L1060
	movl	$4, -36(%rbp)
	movq	-72(%rbp), %rax
	movl	8(%rax), %edx
	movq	-72(%rbp), %rax
	movl	72(%rax), %eax
	addl	%edx, %eax
	addl	$2, %eax
	movl	%eax, -40(%rbp)
	movq	-72(%rbp), %rax
	movl	72(%rax), %eax
	leal	4(%rax), %edx
	movq	-72(%rbp), %rax
	movl	%edx, 72(%rax)
	movq	-72(%rbp), %rax
	movl	8(%rax), %edx
	movq	-72(%rbp), %rax
	movl	72(%rax), %eax
	addl	%edx, %eax
	addl	$2, %eax
	movl	%eax, -44(%rbp)
	movl	-36(%rbp), %eax
	imull	-44(%rbp), %eax
	movl	%eax, %edx
	movl	-36(%rbp), %eax
	imull	-40(%rbp), %eax
	movl	%eax, %ecx
	movq	-72(%rbp), %rax
	movq	64(%rax), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	realloc_data
	movq	%rax, -56(%rbp)
	movq	-72(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rdx, 64(%rax)
	movq	-72(%rbp), %rax
	movq	64(%rax), %rax
	movl	-44(%rbp), %edx
	salq	$2, %rdx
	subq	$16, %rdx
	addq	%rdx, %rax
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	vmemset
	cmpl	$252, -76(%rbp)
	jne	.L1060
	leaq	.LC104(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$14, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L1060:
	nop
	addq	$56, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	map_set
	.hidden	map_set
map_set:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -88(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%rdx, -104(%rbp)
	movq	-88(%rbp), %rax
	movl	112(%rax), %eax
	leal	(%rax,%rax), %ecx
	movq	-88(%rbp), %rax
	movl	8(%rax), %esi
	movl	%ecx, %eax
	movl	$0, %edx
	divl	%esi
	movl	%eax, -12(%rbp)
	movl	$0, %eax
	cmpl	-12(%rbp), %eax
	jnb	.L1062
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	map_expand
.L1062:
	movq	-96(%rbp), %rdx
	movq	-88(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_key_to_index
	movq	%rax, -64(%rbp)
	movl	-64(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-60(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %ecx
	movq	-88(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	map_meta_less
	movq	%rax, -72(%rbp)
	movl	-72(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-68(%rbp), %eax
	movl	%eax, -8(%rbp)
.L1067:
	movq	-88(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jne	.L1069
	movq	-88(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -16(%rbp)
	movq	-88(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-16(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -24(%rbp)
	movq	-88(%rbp), %rax
	movq	88(%rax), %rcx
	movq	-24(%rbp), %rdx
	movq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	testb	%al, %al
	je	.L1065
	movq	-88(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-16(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_value
	movq	%rax, -32(%rbp)
	movq	-88(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rdx
	movq	-104(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	jmp	.L1061
.L1065:
	addl	$2, -4(%rbp)
	movl	$16777216, %eax
	addl	%eax, -8(%rbp)
	jmp	.L1067
.L1069:
	nop
	movq	-88(%rbp), %rax
	addq	$16, %rax
	movq	%rax, %rdi
	call	DenseArray_expand
	movl	%eax, -36(%rbp)
	movq	-88(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-36(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -48(%rbp)
	movq	-88(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-36(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_value
	movq	%rax, -56(%rbp)
	movq	-88(%rbp), %rax
	movq	96(%rax), %rcx
	movq	-96(%rbp), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	movq	-88(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rdx
	movq	-104(%rbp), %rcx
	movq	-56(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movl	-36(%rbp), %ecx
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %esi
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	map_meta_greater
	movq	-88(%rbp), %rax
	movl	112(%rax), %eax
	leal	1(%rax), %edx
	movq	-88(%rbp), %rax
	movl	%edx, 112(%rax)
.L1061:
	leave
	ret
	.globl	map_expand
	.hidden	map_expand
map_expand:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, -4(%rbp)
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	addl	$2, %eax
	addl	%eax, %eax
	leal	-2(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 8(%rax)
	movq	-24(%rbp), %rax
	movzbl	12(%rax), %eax
	testb	%al, %al
	jne	.L1071
	movq	-24(%rbp), %rax
	movzbl	13(%rax), %eax
	leal	16(%rax), %edx
	movq	-24(%rbp), %rax
	movb	%dl, 13(%rax)
	movq	-24(%rbp), %rax
	movb	$16, 12(%rax)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	map_rehash
	jmp	.L1073
.L1071:
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	map_cached_rehash
	movq	-24(%rbp), %rax
	movzbl	12(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movb	%dl, 12(%rax)
.L1073:
	nop
	leave
	ret
	.globl	map_rehash
	.hidden	map_rehash
map_rehash:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	8(%rax), %edx
	movq	-24(%rbp), %rax
	movl	72(%rax), %eax
	addl	%edx, %eax
	addl	$2, %eax
	sall	$2, %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	map_reserve
	nop
	leave
	ret
	.globl	map_reserve
map_reserve:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, -60(%rbp)
	movl	-60(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	v_realloc
	movq	%rax, -16(%rbp)
	movq	-56(%rbp), %rax
	movq	-16(%rbp), %rdx
	movq	%rdx, 64(%rax)
	movl	-60(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	vmemset
	movl	$0, -4(%rbp)
	jmp	.L1076
.L1079:
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_has_index
	testb	%al, %al
	je	.L1080
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_key_to_index
	movq	%rax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -32(%rbp)
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %ecx
	movq	-56(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	map_meta_less
	movq	%rax, -48(%rbp)
	movl	-48(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, -32(%rbp)
	movl	-4(%rbp), %ecx
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %esi
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	map_meta_greater
	jmp	.L1078
.L1080:
	nop
.L1078:
	addl	$1, -4(%rbp)
.L1076:
	movq	-56(%rbp), %rax
	movl	28(%rax), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L1079
	nop
	nop
	leave
	ret
	.globl	map_cached_rehash
	.hidden	map_cached_rehash
map_cached_rehash:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movl	%esi, -76(%rbp)
	movq	-72(%rbp), %rax
	movq	64(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-72(%rbp), %rax
	movl	8(%rax), %edx
	movq	-72(%rbp), %rax
	movl	72(%rax), %eax
	addl	%edx, %eax
	addl	$2, %eax
	sall	$2, %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	vcalloc
	movq	-72(%rbp), %rdx
	movq	%rax, 64(%rdx)
	movq	-72(%rbp), %rax
	movl	72(%rax), %eax
	movl	%eax, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L1082
.L1085:
	movl	-4(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L1086
	movl	-4(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	shrl	$24, %eax
	subl	$1, %eax
	addl	%eax, %eax
	movl	%eax, -32(%rbp)
	movl	-4(%rbp), %eax
	subl	-32(%rbp), %eax
	movl	%eax, %edx
	movq	-72(%rbp), %rax
	movl	8(%rax), %eax
	shrl	%eax
	andl	%edx, %eax
	movl	%eax, -36(%rbp)
	movq	-72(%rbp), %rax
	movzbl	13(%rax), %eax
	movzbl	%al, %eax
	movl	-28(%rbp), %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	orl	-36(%rbp), %eax
	movl	%eax, %edx
	movq	-72(%rbp), %rax
	movl	8(%rax), %eax
	andl	%edx, %eax
	movl	%eax, -40(%rbp)
	movl	$16777215, %eax
	andl	-28(%rbp), %eax
	movl	$16777216, %edx
	orl	%edx, %eax
	movl	%eax, -44(%rbp)
	movl	-44(%rbp), %edx
	movl	-40(%rbp), %ecx
	movq	-72(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	map_meta_less
	movq	%rax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl	%eax, -40(%rbp)
	movl	-52(%rbp), %eax
	movl	%eax, -44(%rbp)
	movl	-4(%rbp), %eax
	addl	$1, %eax
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -48(%rbp)
	movl	-48(%rbp), %ecx
	movl	-44(%rbp), %edx
	movl	-40(%rbp), %esi
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	map_meta_greater
	jmp	.L1084
.L1086:
	nop
.L1084:
	addl	$2, -4(%rbp)
.L1082:
	movl	-76(%rbp), %edx
	movl	-24(%rbp), %eax
	addl	%edx, %eax
	cmpl	-4(%rbp), %eax
	jnb	.L1085
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	_v_free
	nop
	leave
	ret
	.globl	map_get_and_set
	.hidden	map_get_and_set
map_get_and_set:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
.L1093:
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_key_to_index
	movq	%rax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -8(%rbp)
.L1092:
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jne	.L1088
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	88(%rax), %rcx
	movq	-24(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	testb	%al, %al
	je	.L1088
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_value
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	jmp	.L1094
.L1088:
	addl	$2, -4(%rbp)
	movl	$16777216, %eax
	addl	%eax, -8(%rbp)
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	-8(%rbp), %eax
	jb	.L1096
	jmp	.L1092
.L1096:
	nop
	movq	-72(%rbp), %rdx
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	map_set
	jmp	.L1093
.L1094:
	leave
	ret
	.globl	map_get
	.hidden	map_get
map_get:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_key_to_index
	movq	%rax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -8(%rbp)
.L1102:
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jne	.L1098
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	88(%rax), %rcx
	movq	-24(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	testb	%al, %al
	je	.L1098
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_value
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	jmp	.L1103
.L1098:
	addl	$2, -4(%rbp)
	movl	$16777216, %eax
	addl	%eax, -8(%rbp)
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	-8(%rbp), %eax
	jb	.L1105
	jmp	.L1102
.L1105:
	nop
	movq	-72(%rbp), %rax
.L1103:
	leave
	ret
	.globl	map_get_check
	.hidden	map_get_check
map_get_check:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_key_to_index
	movq	%rax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -8(%rbp)
.L1111:
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jne	.L1107
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	88(%rax), %rcx
	movq	-24(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	testb	%al, %al
	je	.L1107
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_value
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	jmp	.L1112
.L1107:
	addl	$2, -4(%rbp)
	movl	$16777216, %eax
	addl	%eax, -8(%rbp)
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	-8(%rbp), %eax
	jb	.L1114
	jmp	.L1111
.L1114:
	nop
	movl	$0, %eax
.L1112:
	leave
	ret
	.globl	map_exists
	.hidden	map_exists
map_exists:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_key_to_index
	movq	%rax, -32(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -8(%rbp)
.L1120:
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jne	.L1116
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-40(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -24(%rbp)
	movq	-40(%rbp), %rax
	movq	88(%rax), %rcx
	movq	-24(%rbp), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	testb	%al, %al
	je	.L1116
	movl	$1, %eax
	jmp	.L1121
.L1116:
	addl	$2, -4(%rbp)
	movl	$16777216, %eax
	addl	%eax, -8(%rbp)
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	-8(%rbp), %eax
	jb	.L1123
	jmp	.L1120
.L1123:
	nop
	movl	$0, %eax
.L1121:
	leave
	ret
	.globl	DenseArray_delete
	.hidden	DenseArray_delete
DenseArray_delete:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	testl	%eax, %eax
	jne	.L1125
	movq	-8(%rbp), %rax
	movl	8(%rax), %eax
	cltq
	movq	%rax, %rdi
	call	vcalloc
	movq	-8(%rbp), %rdx
	movq	%rax, 24(%rdx)
.L1125:
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, 16(%rax)
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$1, (%rax)
	nop
	leave
	ret
	.globl	map_delete
map_delete:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_key_to_index
	movq	%rax, -32(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %ecx
	movq	-56(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	map_meta_less
	movq	%rax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -8(%rbp)
.L1136:
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jne	.L1139
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	88(%rax), %rcx
	movq	-24(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	testb	%al, %al
	je	.L1129
.L1132:
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$2, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	shrl	$24, %eax
	cmpl	$1, %eax
	jbe	.L1140
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$2, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	$16777216, %esi
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %ecx
	salq	$2, %rcx
	addq	%rcx, %rax
	subl	%esi, %edx
	movl	%edx, (%rax)
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$3, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	leaq	(%rax,%rdx), %rcx
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	addl	$1, %edx
	movl	%edx, %edx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	(%rcx), %eax
	movl	%eax, (%rdx)
	addl	$2, -4(%rbp)
	jmp	.L1132
.L1140:
	nop
	movq	-56(%rbp), %rax
	movl	112(%rax), %eax
	leal	-1(%rax), %edx
	movq	-56(%rbp), %rax
	movl	%edx, 112(%rax)
	movq	-56(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_delete
	movq	-56(%rbp), %rax
	movq	64(%rax), %rax
	movl	-4(%rbp), %edx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	$0, (%rax)
	movq	-56(%rbp), %rax
	movq	104(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	*%rdx
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	vmemset
	movq	-56(%rbp), %rax
	movl	28(%rax), %eax
	cmpl	$32, %eax
	jle	.L1141
	movq	-56(%rbp), %rax
	movl	28(%rax), %eax
	sarl	%eax
	movl	%eax, %edx
	movq	-56(%rbp), %rax
	movl	32(%rax), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	_us32_ge
	testb	%al, %al
	je	.L1142
	movq	-56(%rbp), %rax
	addq	$16, %rax
	movq	%rax, %rdi
	call	DenseArray_zeros_to_end
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	map_rehash
	jmp	.L1142
.L1129:
	addl	$2, -4(%rbp)
	movl	$16777216, %eax
	addl	%eax, -8(%rbp)
	jmp	.L1136
.L1139:
	nop
	jmp	.L1126
.L1141:
	nop
	jmp	.L1126
.L1142:
	nop
.L1126:
	leave
	ret
	.globl	map_keys
map_keys:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	-80(%rbp), %rax
	movl	(%rax), %edx
	movq	-80(%rbp), %rax
	movl	112(%rax), %esi
	leaq	-64(%rbp), %rax
	movl	%edx, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	__new_array
	movq	-56(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-80(%rbp), %rax
	movl	32(%rax), %eax
	testl	%eax, %eax
	jne	.L1144
	movl	$0, -12(%rbp)
	jmp	.L1145
.L1146:
	movq	-80(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -32(%rbp)
	movq	-80(%rbp), %rax
	movq	96(%rax), %rcx
	movq	-32(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	movq	-80(%rbp), %rax
	movl	(%rax), %eax
	cltq
	addq	%rax, -8(%rbp)
	addl	$1, -12(%rbp)
.L1145:
	movq	-80(%rbp), %rax
	movl	28(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L1146
	movq	-72(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	jmp	.L1152
.L1144:
	movl	$0, -16(%rbp)
	jmp	.L1148
.L1151:
	movq	-80(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-16(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_has_index
	testb	%al, %al
	je	.L1153
	movq	-80(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-16(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -24(%rbp)
	movq	-80(%rbp), %rax
	movq	96(%rax), %rcx
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	movq	-80(%rbp), %rax
	movl	(%rax), %eax
	cltq
	addq	%rax, -8(%rbp)
	jmp	.L1150
.L1153:
	nop
.L1150:
	addl	$1, -16(%rbp)
.L1148:
	movq	-80(%rbp), %rax
	movl	28(%rax), %eax
	cmpl	%eax, -16(%rbp)
	jl	.L1151
	movq	-72(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
.L1152:
	movq	-72(%rbp), %rax
	leave
	ret
	.globl	map_values
map_values:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	-80(%rbp), %rax
	movl	4(%rax), %edx
	movq	-80(%rbp), %rax
	movl	112(%rax), %esi
	leaq	-64(%rbp), %rax
	movl	%edx, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	__new_array
	movq	-56(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-80(%rbp), %rax
	movl	32(%rax), %eax
	testl	%eax, %eax
	jne	.L1155
	movq	-80(%rbp), %rax
	movl	4(%rax), %edx
	movq	-80(%rbp), %rax
	movl	28(%rax), %eax
	imull	%edx, %eax
	movslq	%eax, %rdx
	movq	-80(%rbp), %rax
	movq	56(%rax), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-72(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	jmp	.L1161
.L1155:
	movl	$0, -12(%rbp)
	jmp	.L1157
.L1160:
	movq	-80(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_has_index
	testb	%al, %al
	je	.L1162
	movq	-80(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_value
	movq	%rax, -24(%rbp)
	movq	-80(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-80(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	addq	%rax, -8(%rbp)
	jmp	.L1159
.L1162:
	nop
.L1159:
	addl	$1, -12(%rbp)
.L1157:
	movq	-80(%rbp), %rax
	movl	28(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L1160
	movq	-72(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
.L1161:
	movq	-72(%rbp), %rax
	leave
	ret
	.globl	DenseArray_clone
	.hidden	DenseArray_clone
DenseArray_clone:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$120, %rsp
	movq	%rdi, -120(%rbp)
	movq	%rsi, -128(%rbp)
	movq	-128(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -64(%rbp)
	movq	-128(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, -60(%rbp)
	movq	-128(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, -56(%rbp)
	movq	-128(%rbp), %rax
	movl	12(%rax), %eax
	movl	%eax, -52(%rbp)
	movq	-128(%rbp), %rax
	movl	16(%rax), %eax
	movl	%eax, -48(%rbp)
	movq	$0, -40(%rbp)
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	movq	-128(%rbp), %rax
	movl	16(%rax), %eax
	testl	%eax, %eax
	je	.L1164
	movq	-128(%rbp), %rax
	movl	8(%rax), %edx
	movq	-128(%rbp), %rax
	movq	24(%rax), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -40(%rbp)
.L1164:
	movq	-128(%rbp), %rax
	movl	8(%rax), %edx
	movq	-128(%rbp), %rax
	movl	(%rax), %eax
	imull	%eax, %edx
	movq	-128(%rbp), %rax
	movq	32(%rax), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -32(%rbp)
	movq	-128(%rbp), %rax
	movl	8(%rax), %edx
	movq	-128(%rbp), %rax
	movl	4(%rax), %eax
	imull	%eax, %edx
	movq	-128(%rbp), %rax
	movq	40(%rax), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -24(%rbp)
	movq	-120(%rbp), %rax
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-32(%rbp), %rcx
	movq	-24(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-120(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	map_clone
map_clone:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%rbx
	subq	$272, %rsp
	movq	%rdi, -280(%rbp)
	movq	%rsi, -288(%rbp)
	movq	-288(%rbp), %rax
	movl	8(%rax), %edx
	movq	-288(%rbp), %rax
	movl	72(%rax), %eax
	addl	%edx, %eax
	addl	$2, %eax
	sall	$2, %eax
	movl	%eax, -24(%rbp)
	movq	-288(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -144(%rbp)
	movq	-288(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, -140(%rbp)
	movq	-288(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, -136(%rbp)
	movq	-288(%rbp), %rax
	movzbl	12(%rax), %eax
	movb	%al, -132(%rbp)
	movq	-288(%rbp), %rax
	movzbl	13(%rax), %eax
	movb	%al, -131(%rbp)
	movq	-288(%rbp), %rax
	leaq	16(%rax), %rdx
	leaq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	DenseArray_clone
	movl	-24(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -80(%rbp)
	movq	-288(%rbp), %rax
	movl	72(%rax), %eax
	movl	%eax, -72(%rbp)
	movq	-288(%rbp), %rax
	movzbl	76(%rax), %eax
	movb	%al, -68(%rbp)
	movq	-288(%rbp), %rax
	movq	80(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-288(%rbp), %rax
	movq	88(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-288(%rbp), %rax
	movq	96(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-288(%rbp), %rax
	movq	104(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-288(%rbp), %rax
	movl	112(%rax), %eax
	movl	%eax, -32(%rbp)
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	-288(%rbp), %rax
	movq	64(%rax), %rcx
	movq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-288(%rbp), %rax
	movzbl	76(%rax), %eax
	testb	%al, %al
	jne	.L1167
	movq	-280(%rbp), %rax
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 64(%rax)
	movq	%rbx, 72(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 80(%rax)
	movq	%rbx, 88(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 96(%rax)
	movq	%rbx, 104(%rax)
	movq	-32(%rbp), %rdx
	movq	%rdx, 112(%rax)
	jmp	.L1173
.L1167:
	movl	$0, -20(%rbp)
	jmp	.L1169
.L1172:
	movq	-288(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-20(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_has_index
	testb	%al, %al
	je	.L1174
	movq	-288(%rbp), %rax
	movq	96(%rax), %rbx
	movq	-288(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-20(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, %r12
	movl	-20(%rbp), %eax
	leaq	-144(%rbp), %rdx
	addq	$16, %rdx
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%r12, %rsi
	movq	%rax, %rdi
	call	*%rbx
	jmp	.L1171
.L1174:
	nop
.L1171:
	addl	$1, -20(%rbp)
.L1169:
	movq	-288(%rbp), %rax
	movl	28(%rax), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L1172
	movq	-280(%rbp), %rax
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 64(%rax)
	movq	%rbx, 72(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 80(%rax)
	movq	%rbx, 88(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 96(%rax)
	movq	%rbx, 104(%rax)
	movq	-32(%rbp), %rdx
	movq	%rdx, 112(%rax)
.L1173:
	movq	-280(%rbp), %rax
	addq	$272, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	ret
	.globl	map_free
map_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	64(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-40(%rbp), %rax
	movq	$0, 64(%rax)
	movq	-40(%rbp), %rax
	movl	32(%rax), %eax
	testl	%eax, %eax
	jne	.L1176
	movl	$0, -4(%rbp)
	jmp	.L1177
.L1178:
	movq	-40(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -24(%rbp)
	movq	-40(%rbp), %rax
	movq	104(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	*%rdx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	vmemset
	addl	$1, -4(%rbp)
.L1177:
	movq	-40(%rbp), %rax
	movl	28(%rax), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L1178
	jmp	.L1179
.L1176:
	movl	$0, -8(%rbp)
	jmp	.L1180
.L1183:
	movq	-40(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-8(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_has_index
	testb	%al, %al
	je	.L1187
	movq	-40(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-8(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	DenseArray_key
	movq	%rax, -16(%rbp)
	movq	-40(%rbp), %rax
	movq	104(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	*%rdx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	vmemset
	jmp	.L1182
.L1187:
	nop
.L1182:
	addl	$1, -8(%rbp)
.L1180:
	movq	-40(%rbp), %rax
	movl	28(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L1183
.L1179:
	movq	-40(%rbp), %rax
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L1184
	movq	-40(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-40(%rbp), %rax
	movq	$0, 40(%rax)
.L1184:
	movq	-40(%rbp), %rax
	movq	48(%rax), %rax
	testq	%rax, %rax
	je	.L1185
	movq	-40(%rbp), %rax
	movq	48(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-40(%rbp), %rax
	movq	$0, 48(%rax)
.L1185:
	movq	-40(%rbp), %rax
	movq	56(%rax), %rax
	testq	%rax, %rax
	je	.L1186
	movq	-40(%rbp), %rax
	movq	56(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-40(%rbp), %rax
	movq	$0, 56(%rax)
.L1186:
	movq	-40(%rbp), %rax
	movq	$0, 80(%rax)
	movq	-40(%rbp), %rax
	movq	$0, 88(%rax)
	movq	-40(%rbp), %rax
	movq	$0, 96(%rax)
	movq	-40(%rbp), %rax
	movq	$0, 104(%rax)
	nop
	leave
	ret
	.globl	IError_free
IError_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
	nop
	leave
	ret
	.section	.rodata, "a"
.LC105:
	.string	"none"
.LC106:
	.string	": "
	.text
	.globl	IError_str
IError_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$136, %rsp
	movl	24(%rbp), %ecx
	movl	$0, %esi
	cmpl	%esi, %ecx
	jne	.L1190
	leaq	.LC105(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$4, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L1196
.L1190:
	movl	24(%rbp), %eax
	movl	$2, %edx
	cmpl	%edx, %eax
	jne	.L1192
	call	Error_msg
	jmp	.L1196
.L1192:
	movl	24(%rbp), %eax
	movl	$3, %edx
	cmpl	%edx, %eax
	jne	.L1193
	movq	16(%rbp), %rcx
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	MessageError_msg
	addq	$32, %rsp
	jmp	.L1196
.L1193:
	leaq	-144(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC34(%rip), %rax
	movq	%rax, -144(%rbp)
	movl	$1, -132(%rbp)
	movl	$65040, -128(%rbp)
	movl	24(%rbp), %eax
	movl	%eax, %edi
	call	v_typeof_interface_IError
	movq	%rax, %rdi
	call	charptr_vstring_literal
	movq	%rax, -120(%rbp)
	movq	%rdx, -112(%rbp)
	leaq	.LC106(%rip), %rax
	movq	%rax, -104(%rbp)
	movl	$2, -96(%rbp)
	movl	$1, -92(%rbp)
	movl	$65040, -88(%rbp)
	movl	24(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdx
	leaq	IError_name_table(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movq	16(%rbp), %rax
	movq	%rax, %rdi
	call	*%rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$1, -52(%rbp)
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
.L1196:
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	Error_msg
Error_msg:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	leaq	.LC34(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	Error_code
Error_code:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %eax
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC107:
	.string	"; code: "
	.text
	.globl	MessageError_msg
MessageError_msg:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$136, %rsp
	movl	32(%rbp), %eax
	testl	%eax, %eax
	jle	.L1202
	leaq	-144(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC34(%rip), %rax
	movq	%rax, -144(%rbp)
	movl	$1, -132(%rbp)
	movl	$65040, -128(%rbp)
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -120(%rbp)
	movq	%rdx, -112(%rbp)
	leaq	.LC107(%rip), %rax
	movq	%rax, -104(%rbp)
	movl	$8, -96(%rbp)
	movl	$1, -92(%rbp)
	movl	$65031, -88(%rbp)
	movl	32(%rbp), %eax
	movl	%eax, -80(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$1, -52(%rbp)
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	jmp	.L1203
.L1202:
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
.L1203:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	MessageError_code
MessageError_code:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	32(%rbp), %eax
	popq	%rbp
	ret
	.globl	MessageError_free
MessageError_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	nop
	leave
	ret
	.globl	None___str
	.hidden	None___str
None___str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	leaq	.LC105(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$4, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	_v_error
_v_error:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	$0, -16(%rbp)
	leaq	-32(%rbp), %rax
	movl	$24, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	I_MessageError_to_Interface_IError
	movq	-40(%rbp), %rax
	leave
	ret
	.globl	error_with_code
error_with_code:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	%ecx, -44(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, -16(%rbp)
	leaq	-32(%rbp), %rax
	movl	$24, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	I_MessageError_to_Interface_IError
	movq	-40(%rbp), %rax
	leave
	ret
	.globl	_option_ok
	.hidden	_option_ok
_option_ok:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	movq	-64(%rbp), %rax
	movb	$0, (%rax)
	movq	-64(%rbp), %rcx
	movq	_const_none__(%rip), %rax
	movq	8+_const_none__(%rip), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	16+_const_none__(%rip), %rax
	movq	24+_const_none__(%rip), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	movl	-68(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	addq	$8, %rax
	leaq	32(%rax), %rcx
	movq	-56(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	nop
	leave
	ret
	.globl	_result_ok
	.hidden	_result_ok
_result_ok:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	movq	-64(%rbp), %rax
	movb	$0, (%rax)
	movq	-64(%rbp), %rcx
	movq	_const_none__(%rip), %rax
	movq	8+_const_none__(%rip), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	16+_const_none__(%rip), %rax
	movq	24+_const_none__(%rip), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	movl	-68(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	addq	$8, %rax
	leaq	32(%rax), %rcx
	movq	-56(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	nop
	leave
	ret
	.globl	none_str
none_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	leaq	.LC105(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$4, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	rune_str
rune_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	utf32_to_str
	leave
	ret
	.section	.rodata, "a"
.LC108:
	.string	"TODO"
	.text
	.globl	mapnode_free
	.hidden	mapnode_free
mapnode_free:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	leaq	.LC108(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$4, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	println
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	SortedMap_free
SortedMap_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	je	.L1223
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	mapnode_free
	jmp	.L1220
.L1223:
	nop
.L1220:
	leave
	ret
	.globl	tos_clone
tos_clone:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	tos2
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC109:
	.string	"tos(): nil string"
	.text
	.globl	tos
tos:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L1227
	leaq	.LC109(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$17, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L1227:
	movl	$0, %eax
	movl	$0, %edx
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %ecx
	movq	%rdx, %rdi
	movabsq	$-4294967296, %rsi
	andq	%rdi, %rsi
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC110:
	.string	"tos2: nil string"
	.text
	.globl	tos2
tos2:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L1230
	leaq	.LC110(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$16, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L1230:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	vstrlen
	movl	%eax, %ecx
	movl	$0, %eax
	movl	$0, %edx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rdx, %rdi
	movabsq	$-4294967296, %rcx
	andq	%rdi, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC111:
	.string	"tos3: nil string"
	.text
	.globl	tos3
tos3:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L1233
	leaq	.LC111(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$16, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L1233:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	vstrlen_char
	movl	%eax, %ecx
	movl	$0, %eax
	movl	$0, %edx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rdx, %rdi
	movabsq	$-4294967296, %rcx
	andq	%rdi, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	tos5
tos5:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L1236
	leaq	.LC34(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L1237
.L1236:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	vstrlen_char
	movl	%eax, %ecx
	movl	$0, %eax
	movl	$0, %edx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rdx, %rdi
	movabsq	$-4294967296, %rcx
	andq	%rdi, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
.L1237:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	u8_vstring
u8_vstring:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	vstrlen
	movl	%eax, %ecx
	movl	$0, %eax
	movl	$0, %edx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rdx, %rdi
	movabsq	$-4294967296, %rcx
	andq	%rdi, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	u8_vstring_with_len
u8_vstring_with_len:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %ecx
	movq	%rdx, %rdi
	movabsq	$-4294967296, %rsi
	andq	%rdi, %rsi
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %ecx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_clone_static
	.hidden	string_clone_static
string_clone_static:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	leave
	ret
	.globl	string_clone
string_clone:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rbx
	movq	%rcx, -48(%rbp)
	movq	%rbx, -40(%rbp)
	movl	-40(%rbp), %ecx
	testl	%ecx, %ecx
	jne	.L1246
	leaq	.LC34(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L1247
.L1246:
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	movl	-40(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -32(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-32(%rbp), %rdx
	movl	-40(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
.L1247:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_replace
string_replace:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$232, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r10
	movq	%r10, %rsi
	movq	%r11, %rdi
	movq	%rax, %rdi
	movq	%rsi, -176(%rbp)
	movq	%rdi, -168(%rbp)
	movq	%rdx, -192(%rbp)
	movq	%rcx, -184(%rbp)
	movq	%r8, -208(%rbp)
	movq	%r9, -200(%rbp)
	movb	$0, -45(%rbp)
	movl	-168(%rbp), %eax
	testl	%eax, %eax
	je	.L1250
	movl	-184(%rbp), %eax
	testl	%eax, %eax
	je	.L1250
	movl	-184(%rbp), %edx
	movl	-168(%rbp), %eax
	cmpl	%eax, %edx
	jle	.L1251
.L1250:
	movq	-176(%rbp), %rdx
	movq	-168(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	jmp	.L1252
.L1251:
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	-176(%rbp), %rdi
	movq	-168(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_contains
	testb	%al, %al
	jne	.L1253
	movq	-176(%rbp), %rdx
	movq	-168(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	jmp	.L1252
.L1253:
	movl	-168(%rbp), %eax
	movl	-184(%rbp), %ebx
	cltd
	idivl	%ebx
	movl	%eax, %edx
	leaq	-240(%rbp), %rax
	movl	$0, %r8d
	movl	$4, %ecx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movb	$1, -45(%rbp)
	movl	$0, -20(%rbp)
.L1257:
	movl	-20(%rbp), %ecx
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	-176(%rbp), %rdi
	movq	-168(%rbp), %rsi
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_index_after
	movl	%eax, -20(%rbp)
	cmpl	$-1, -20(%rbp)
	jne	.L1254
	movl	-92(%rbp), %eax
	testl	%eax, %eax
	je	.L1255
	jmp	.L1270
.L1254:
	movl	-20(%rbp), %eax
	movl	%eax, -116(%rbp)
	leaq	-116(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movl	-184(%rbp), %eax
	addl	%eax, -20(%rbp)
	jmp	.L1257
.L1255:
	movq	-176(%rbp), %rdx
	movq	-168(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	cmpb	$0, -45(%rbp)
	je	.L1258
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
.L1258:
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	jmp	.L1252
.L1270:
	movl	-168(%rbp), %ecx
	movl	-92(%rbp), %eax
	movl	-200(%rbp), %esi
	movl	-184(%rbp), %edx
	subl	%edx, %esi
	imull	%esi, %eax
	addl	%ecx, %eax
	movl	%eax, -52(%rbp)
	movl	-52(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -64(%rbp)
	movl	$0, -24(%rbp)
	movl	$0, -28(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L1259
.L1264:
	movq	-104(%rbp), %rax
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -68(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -36(%rbp)
	jmp	.L1260
.L1261:
	movq	-176(%rbp), %rdx
	movl	-36(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rcx
	movq	-64(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -24(%rbp)
	addl	$1, -36(%rbp)
.L1260:
	movl	-36(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	.L1261
	movl	-184(%rbp), %edx
	movl	-68(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -28(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L1262
.L1263:
	movq	-208(%rbp), %rdx
	movl	-40(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rcx
	movq	-64(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -24(%rbp)
	addl	$1, -40(%rbp)
.L1262:
	movl	-200(%rbp), %eax
	cmpl	%eax, -40(%rbp)
	jl	.L1263
	addl	$1, -32(%rbp)
.L1259:
	movl	-92(%rbp), %eax
	cmpl	%eax, -32(%rbp)
	jl	.L1264
	movl	-168(%rbp), %eax
	cmpl	%eax, -28(%rbp)
	jge	.L1265
	movl	-28(%rbp), %eax
	movl	%eax, -44(%rbp)
	jmp	.L1266
.L1267:
	movq	-176(%rbp), %rdx
	movl	-44(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rcx
	movq	-64(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -24(%rbp)
	addl	$1, -44(%rbp)
.L1266:
	movl	-168(%rbp), %eax
	cmpl	%eax, -44(%rbp)
	jl	.L1267
.L1265:
	movl	-52(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-52(%rbp), %edx
	movq	-64(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	cmpb	$0, -45(%rbp)
	je	.L1268
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
.L1268:
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
.L1252:
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC112:
	.string	"string.eq(): nil string"
	.text
	.globl	string__eq
	.hidden	string__eq
string__eq:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r10
	movq	%r10, %rsi
	movq	%r11, %rdi
	movq	%rax, %rdi
	movq	%rsi, -48(%rbp)
	movq	%rdi, -40(%rbp)
	movq	%rdx, -64(%rbp)
	movq	%rcx, -56(%rbp)
	movq	-48(%rbp), %rax
	testq	%rax, %rax
	jne	.L1272
	leaq	.LC112(%rip), %r8
	movq	%r9, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$23, %rax
	movq	%rax, %r9
	movq	%r9, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r9
	movq	%r8, %rcx
	movq	%r9, %rbx
	movq	%r8, %rax
	movq	%r9, %rdx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L1272:
	movl	-40(%rbp), %edx
	movl	-56(%rbp), %eax
	cmpl	%eax, %edx
	je	.L1273
	movl	$0, %eax
	jmp	.L1274
.L1273:
	movl	-40(%rbp), %eax
	testl	%eax, %eax
	jle	.L1275
	movl	-40(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -20(%rbp)
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-64(%rbp), %rcx
	movl	-20(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	je	.L1275
	movl	$0, %eax
	jmp	.L1274
.L1275:
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcmp
	testl	%eax, %eax
	sete	%al
.L1274:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string__lt
	.hidden	string__lt
string__lt:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -32(%rbp)
	movq	%rdi, -24(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -40(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L1277
.L1282:
	movl	-40(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jge	.L1278
	movq	-32(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movq	-48(%rbp), %rcx
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	cmpb	%al, %dl
	jnb	.L1279
.L1278:
	movl	$0, %eax
	jmp	.L1280
.L1279:
	movq	-32(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-48(%rbp), %rcx
	movl	-4(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	jnb	.L1281
	movl	$1, %eax
	jmp	.L1280
.L1281:
	addl	$1, -4(%rbp)
.L1277:
	movl	-24(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L1282
	movl	-24(%rbp), %edx
	movl	-40(%rbp), %eax
	cmpl	%eax, %edx
	jge	.L1283
	movl	$1, %eax
	jmp	.L1280
.L1283:
	movl	$0, %eax
.L1280:
	popq	%rbp
	ret
	.globl	string__plus
	.hidden	string__plus
string__plus:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$72, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -64(%rbp)
	movq	%rdi, -56(%rbp)
	movq	%rdx, -80(%rbp)
	movq	%rcx, -72(%rbp)
	movl	-72(%rbp), %edx
	movl	-56(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -20(%rbp)
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	movl	-20(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -48(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -40(%rbp)
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movl	-72(%rbp), %eax
	movslq	%eax, %rdx
	movq	-80(%rbp), %rax
	movq	-48(%rbp), %rsi
	movl	-56(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	%rsi, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC113:
	.string	"substr("
.LC114:
	.string	") out of bounds (len="
	.text
	.globl	string_substr
string_substr:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$232, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -224(%rbp)
	movq	%rdi, -216(%rbp)
	movl	%edx, -228(%rbp)
	movl	%ecx, -232(%rbp)
	movl	-228(%rbp), %eax
	cmpl	-232(%rbp), %eax
	jg	.L1287
	movl	-216(%rbp), %eax
	cmpl	%eax, -228(%rbp)
	jg	.L1287
	movl	-216(%rbp), %eax
	cmpl	%eax, -232(%rbp)
	jg	.L1287
	cmpl	$0, -228(%rbp)
	js	.L1287
	cmpl	$0, -232(%rbp)
	jns	.L1288
.L1287:
	leaq	-208(%rbp), %rdx
	movl	$0, %eax
	movl	$20, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC113(%rip), %rax
	movq	%rax, -208(%rbp)
	movl	$7, -200(%rbp)
	movl	$1, -196(%rbp)
	movl	$65031, -192(%rbp)
	movl	-228(%rbp), %eax
	movl	%eax, -184(%rbp)
	leaq	.LC67(%rip), %rax
	movq	%rax, -168(%rbp)
	movl	$2, -160(%rbp)
	movl	$1, -156(%rbp)
	movl	$65031, -152(%rbp)
	movl	-232(%rbp), %eax
	movl	%eax, -144(%rbp)
	leaq	.LC114(%rip), %rax
	movq	%rax, -128(%rbp)
	movl	$21, -120(%rbp)
	movl	$1, -116(%rbp)
	movl	$65031, -112(%rbp)
	movl	-216(%rbp), %eax
	movl	%eax, -104(%rbp)
	leaq	.LC54(%rip), %rax
	movq	%rax, -88(%rbp)
	movl	$1, -80(%rbp)
	movl	$1, -76(%rbp)
	leaq	-208(%rbp), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L1288:
	movl	-232(%rbp), %eax
	subl	-228(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	-216(%rbp), %eax
	cmpl	%eax, -20(%rbp)
	jne	.L1289
	movq	-224(%rbp), %rdx
	movq	-216(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	jmp	.L1290
.L1289:
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	movl	-20(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -48(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -40(%rbp)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-224(%rbp), %rcx
	movl	-228(%rbp), %eax
	cltq
	addq	%rax, %rcx
	movq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
.L1290:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_substr_ni
string_substr_ni:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r10
	movq	%r10, %rsi
	movq	%r11, %rdi
	movq	%rax, %rdi
	movq	%rsi, -48(%rbp)
	movq	%rdi, -40(%rbp)
	movl	%edx, -52(%rbp)
	movl	%ecx, -56(%rbp)
	movl	-52(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-56(%rbp), %eax
	movl	%eax, -8(%rbp)
	cmpl	$0, -4(%rbp)
	jns	.L1293
	movl	-40(%rbp), %eax
	addl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jns	.L1293
	movl	$0, -4(%rbp)
.L1293:
	cmpl	$0, -8(%rbp)
	jns	.L1294
	movl	-40(%rbp), %eax
	addl	%eax, -8(%rbp)
	cmpl	$0, -8(%rbp)
	jns	.L1294
	movl	$0, -8(%rbp)
.L1294:
	movl	-40(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L1295
	movl	-40(%rbp), %eax
	movl	%eax, -8(%rbp)
.L1295:
	movl	-40(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jg	.L1296
	movl	-8(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jge	.L1297
.L1296:
	leaq	.LC34(%rip), %r8
	movq	%r9, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, %r9
	movq	%r9, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r9
	jmp	.L1298
.L1297:
	movl	-8(%rbp), %eax
	subl	-4(%rbp), %eax
	movl	%eax, -12(%rbp)
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	movl	-12(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -32(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rcx
	movl	-4(%rbp), %eax
	cltq
	addq	%rax, %rcx
	movq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-32(%rbp), %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-32(%rbp), %r8
	movq	-24(%rbp), %r9
.L1298:
	movq	%r8, %rax
	movq	%r9, %rdx
	leave
	ret
	.globl	string_index_
	.hidden	string_index_
string_index_:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -32(%rbp)
	movq	%rdi, -24(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -40(%rbp)
	movl	-40(%rbp), %edx
	movl	-24(%rbp), %eax
	cmpl	%eax, %edx
	jg	.L1301
	movl	-40(%rbp), %eax
	testl	%eax, %eax
	jne	.L1302
.L1301:
	movl	$-1, %eax
	jmp	.L1303
.L1302:
	movl	-40(%rbp), %eax
	cmpl	$2, %eax
	jle	.L1304
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rdi
	movq	-24(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_index_kmp
	jmp	.L1303
.L1304:
	movl	$0, -4(%rbp)
.L1310:
	movl	-24(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jge	.L1312
	movl	$0, -8(%rbp)
.L1308:
	movl	-40(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jge	.L1307
	movq	-32(%rbp), %rdx
	movl	-4(%rbp), %ecx
	movl	-8(%rbp), %eax
	addl	%ecx, %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-48(%rbp), %rcx
	movl	-8(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	jne	.L1307
	addl	$1, -8(%rbp)
	jmp	.L1308
.L1307:
	movl	-40(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jne	.L1309
	movl	-4(%rbp), %eax
	jmp	.L1303
.L1309:
	addl	$1, -4(%rbp)
	jmp	.L1310
.L1312:
	nop
	movl	$-1, %eax
.L1303:
	leave
	ret
	.globl	string_index_kmp
	.hidden	string_index_kmp
string_index_kmp:
	pushq	%rbp
	movq	%rsp, %rbp
	addq	$-128, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r9
	movq	%r9, %rsi
	movq	%r10, %rdi
	movq	%rax, %rdi
	movq	%rsi, -80(%rbp)
	movq	%rdi, -72(%rbp)
	movq	%rdx, -96(%rbp)
	movq	%rcx, -88(%rbp)
	movb	$0, -13(%rbp)
	movl	-88(%rbp), %edx
	movl	-72(%rbp), %eax
	cmpl	%eax, %edx
	jle	.L1314
	movl	$-1, %eax
	jmp	.L1327
.L1314:
	movl	-88(%rbp), %esi
	leaq	-128(%rbp), %rax
	movl	$0, %r8d
	movl	$4, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movb	$1, -13(%rbp)
	movl	$0, -4(%rbp)
	movl	$1, -8(%rbp)
	jmp	.L1316
.L1318:
	movq	-96(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-96(%rbp), %rcx
	movl	-8(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	je	.L1317
	cmpl	$0, -4(%rbp)
	jle	.L1317
	movq	-56(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	subq	$4, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	jmp	.L1318
.L1317:
	movq	-96(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-96(%rbp), %rcx
	movl	-8(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	jne	.L1319
	addl	$1, -4(%rbp)
.L1319:
	movq	-56(%rbp), %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movl	%eax, (%rdx)
	addl	$1, -8(%rbp)
.L1316:
	movl	-88(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L1318
	movl	$0, -4(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L1320
.L1322:
	movq	-96(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-80(%rbp), %rcx
	movl	-12(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	je	.L1321
	cmpl	$0, -4(%rbp)
	jle	.L1321
	movq	-56(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	subq	$4, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	jmp	.L1322
.L1321:
	movq	-96(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-80(%rbp), %rcx
	movl	-12(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	jne	.L1323
	addl	$1, -4(%rbp)
.L1323:
	movl	-88(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jne	.L1324
	movl	-88(%rbp), %eax
	movl	-12(%rbp), %edx
	subl	%eax, %edx
	leal	1(%rdx), %eax
	movl	%eax, -24(%rbp)
	cmpb	$0, -13(%rbp)
	je	.L1325
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
.L1325:
	movl	-24(%rbp), %eax
	jmp	.L1327
.L1324:
	addl	$1, -12(%rbp)
.L1320:
	movl	-72(%rbp), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L1322
	movl	$-1, -20(%rbp)
	cmpb	$0, -13(%rbp)
	je	.L1326
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
.L1326:
	movl	-20(%rbp), %eax
.L1327:
	leave
	ret
	.globl	string_last_index_
	.hidden	string_last_index_
string_last_index_:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -32(%rbp)
	movq	%rdi, -24(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -40(%rbp)
	movl	-40(%rbp), %edx
	movl	-24(%rbp), %eax
	cmpl	%eax, %edx
	jg	.L1329
	movl	-40(%rbp), %eax
	testl	%eax, %eax
	jne	.L1330
.L1329:
	movl	$-1, %eax
	jmp	.L1331
.L1330:
	movl	-24(%rbp), %edx
	movl	-40(%rbp), %eax
	subl	%eax, %edx
	movl	%edx, -4(%rbp)
.L1337:
	cmpl	$0, -4(%rbp)
	js	.L1339
	movl	$0, -8(%rbp)
.L1335:
	movl	-40(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jge	.L1334
	movq	-32(%rbp), %rdx
	movl	-4(%rbp), %ecx
	movl	-8(%rbp), %eax
	addl	%ecx, %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-48(%rbp), %rcx
	movl	-8(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	jne	.L1334
	addl	$1, -8(%rbp)
	jmp	.L1335
.L1334:
	movl	-40(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jne	.L1336
	movl	-4(%rbp), %eax
	jmp	.L1331
.L1336:
	subl	$1, -4(%rbp)
	jmp	.L1337
.L1339:
	nop
	movl	$-1, %eax
.L1331:
	popq	%rbp
	ret
	.globl	string_last_index
string_last_index:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$184, %rsp
	movq	%rdi, -152(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -176(%rbp)
	movq	%rdx, -168(%rbp)
	movq	%rcx, %rax
	movq	%r8, %rcx
	movq	%rcx, %rdx
	movq	%rax, -192(%rbp)
	movq	%rdx, -184(%rbp)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	-176(%rbp), %rdi
	movq	-168(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_last_index_
	movl	%eax, -20(%rbp)
	cmpl	$-1, -20(%rbp)
	jne	.L1341
	movq	-152(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-152(%rbp), %rax
	movb	$2, (%rax)
	movq	-152(%rbp), %rcx
	movq	_const_none__(%rip), %rax
	movq	8+_const_none__(%rip), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	16+_const_none__(%rip), %rax
	movq	24+_const_none__(%rip), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1340
.L1341:
	movl	-20(%rbp), %eax
	movl	%eax, -84(%rbp)
	leaq	-80(%rbp), %rcx
	leaq	-84(%rbp), %rax
	movl	$4, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_option_ok
	movq	-152(%rbp), %rax
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L1340:
	movq	-152(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_index_after
string_index_after:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rsi, %rax
	movq	%rdi, %r9
	movq	%r9, %rsi
	movq	%r10, %rdi
	movq	%rax, %rdi
	movq	%rsi, -32(%rbp)
	movq	%rdi, -24(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -40(%rbp)
	movl	%r8d, -52(%rbp)
	movl	-40(%rbp), %edx
	movl	-24(%rbp), %eax
	cmpl	%eax, %edx
	jle	.L1345
	movl	$-1, %eax
	jmp	.L1346
.L1345:
	movl	-52(%rbp), %eax
	movl	%eax, -4(%rbp)
	cmpl	$0, -52(%rbp)
	jns	.L1347
	movl	$0, -4(%rbp)
.L1347:
	movl	-24(%rbp), %eax
	cmpl	%eax, -52(%rbp)
	jl	.L1348
	movl	$-1, %eax
	jmp	.L1346
.L1348:
	movl	-4(%rbp), %eax
	movl	%eax, -8(%rbp)
.L1354:
	movl	-24(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jge	.L1356
	movl	$0, -12(%rbp)
	movl	-8(%rbp), %eax
	movl	%eax, -16(%rbp)
.L1352:
	movl	-40(%rbp), %eax
	cmpl	%eax, -12(%rbp)
	jge	.L1351
	movq	-32(%rbp), %rdx
	movl	-16(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-48(%rbp), %rcx
	movl	-12(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	jne	.L1351
	addl	$1, -12(%rbp)
	addl	$1, -16(%rbp)
	jmp	.L1352
.L1351:
	movl	-40(%rbp), %eax
	cmpl	%eax, -12(%rbp)
	jne	.L1353
	movl	-8(%rbp), %eax
	jmp	.L1346
.L1353:
	addl	$1, -8(%rbp)
	jmp	.L1354
.L1356:
	nop
	movl	$-1, %eax
.L1346:
	popq	%rbp
	ret
	.globl	string_index_u8
string_index_u8:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rdi, %rcx
	movq	%rsi, %rax
	movq	%rax, %rbx
	movq	%rcx, -48(%rbp)
	movq	%rbx, -40(%rbp)
	movl	%edx, %eax
	movb	%al, -52(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L1358
.L1361:
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -21(%rbp)
	movzbl	-21(%rbp), %eax
	cmpb	-52(%rbp), %al
	jne	.L1359
	movl	-20(%rbp), %eax
	jmp	.L1360
.L1359:
	addl	$1, -20(%rbp)
.L1358:
	movl	-40(%rbp), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L1361
	movl	$-1, %eax
.L1360:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_contains_u8
string_contains_u8:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rdi, %rcx
	movq	%rsi, %rax
	movq	%rax, %rbx
	movq	%rcx, -48(%rbp)
	movq	%rbx, -40(%rbp)
	movl	%edx, %eax
	movb	%al, -52(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L1363
.L1366:
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -21(%rbp)
	movzbl	-52(%rbp), %eax
	cmpb	-21(%rbp), %al
	jne	.L1364
	movl	$1, %eax
	jmp	.L1365
.L1364:
	addl	$1, -20(%rbp)
.L1363:
	movl	-40(%rbp), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L1366
	movl	$0, %eax
.L1365:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_contains
string_contains:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -16(%rbp)
	movq	%rdi, -8(%rbp)
	movq	%rdx, -32(%rbp)
	movq	%rcx, -24(%rbp)
	movl	-24(%rbp), %eax
	testl	%eax, %eax
	jne	.L1368
	movl	$1, %eax
	jmp	.L1369
.L1368:
	movl	-24(%rbp), %eax
	cmpl	$1, %eax
	jne	.L1370
	movq	-32(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %edx
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_contains_u8
	jmp	.L1369
.L1370:
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	-16(%rbp), %rdi
	movq	-8(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_index_
	cmpl	$-1, %eax
	setne	%al
.L1369:
	leave
	ret
	.globl	string_starts_with
string_starts_with:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -32(%rbp)
	movq	%rdi, -24(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -40(%rbp)
	movl	-40(%rbp), %edx
	movl	-24(%rbp), %eax
	cmpl	%eax, %edx
	jle	.L1372
	movl	$0, %eax
	jmp	.L1373
.L1372:
	movl	$0, -4(%rbp)
	jmp	.L1374
.L1376:
	movq	-32(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movq	-48(%rbp), %rcx
	movl	-4(%rbp), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	je	.L1375
	movl	$0, %eax
	jmp	.L1373
.L1375:
	addl	$1, -4(%rbp)
.L1374:
	movl	-40(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L1376
	movl	$1, %eax
.L1373:
	popq	%rbp
	ret
	.globl	string_to_lower
string_to_lower:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movl	-40(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -32(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L1378
.L1381:
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$64, %al
	jbe	.L1379
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$90, %al
	ja	.L1379
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movl	-20(%rbp), %eax
	movslq	%eax, %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	addl	$32, %edx
	movb	%dl, (%rax)
	jmp	.L1380
.L1379:
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
.L1380:
	addl	$1, -20(%rbp)
.L1378:
	movl	-40(%rbp), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L1381
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-40(%rbp), %edx
	movq	-32(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_to_upper
string_to_upper:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movl	-40(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -32(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L1384
.L1387:
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$96, %al
	jbe	.L1385
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$122, %al
	ja	.L1385
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movl	-20(%rbp), %eax
	movslq	%eax, %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	subl	$32, %edx
	movb	%dl, (%rax)
	jmp	.L1386
.L1385:
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
.L1386:
	addl	$1, -20(%rbp)
.L1384:
	movl	-40(%rbp), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L1387
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-40(%rbp), %edx
	movq	-32(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC115:
	.string	" \n\t\013\f\r"
	.text
	.globl	string_trim_space
string_trim_space:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rbx
	movq	%rcx, -32(%rbp)
	movq	%rbx, -24(%rbp)
	leaq	.LC115(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$6, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	-32(%rbp), %rdi
	movq	-24(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_trim
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rax
	movq	%rbx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_trim
string_trim:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -32(%rbp)
	movq	%rdi, -24(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -40(%rbp)
	movl	-24(%rbp), %eax
	testl	%eax, %eax
	jle	.L1392
	movl	-40(%rbp), %eax
	testl	%eax, %eax
	jg	.L1393
.L1392:
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	jmp	.L1395
.L1393:
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rdi
	movq	-24(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_trim_indexes
	movq	%rax, -16(%rbp)
	movl	-16(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	-8(%rbp), %ecx
	movl	-4(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
.L1395:
	leave
	ret
	.globl	string_trim_indexes
string_trim_indexes:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rsi, %r8
	movq	%rdi, %r9
	movq	%r9, %rsi
	movq	%r10, %rdi
	movq	%r8, %rdi
	movq	%rsi, -48(%rbp)
	movq	%rdi, -40(%rbp)
	movq	%rdx, -64(%rbp)
	movq	%rcx, -56(%rbp)
	movl	$0, -4(%rbp)
	movl	-40(%rbp), %edx
	subl	$1, %edx
	movl	%edx, -8(%rbp)
	movb	$1, -9(%rbp)
.L1408:
	movl	-40(%rbp), %edx
	cmpl	%edx, -4(%rbp)
	jg	.L1397
	cmpl	$-1, -8(%rbp)
	jl	.L1397
	cmpb	$0, -9(%rbp)
	je	.L1397
	movb	$0, -9(%rbp)
	movl	$0, -16(%rbp)
	jmp	.L1398
.L1401:
	movq	-64(%rbp), %rcx
	movl	-16(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movb	%dl, -21(%rbp)
	movq	-48(%rbp), %rcx
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	cmpb	%dl, -21(%rbp)
	jne	.L1399
	addl	$1, -4(%rbp)
	movb	$1, -9(%rbp)
	jmp	.L1400
.L1399:
	addl	$1, -16(%rbp)
.L1398:
	movl	-56(%rbp), %edx
	cmpl	%edx, -16(%rbp)
	jl	.L1401
.L1400:
	movl	$0, -20(%rbp)
	jmp	.L1402
.L1405:
	movq	-64(%rbp), %rcx
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movb	%dl, -22(%rbp)
	movq	-48(%rbp), %rcx
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	cmpb	%dl, -22(%rbp)
	jne	.L1403
	subl	$1, -8(%rbp)
	movb	$1, -9(%rbp)
	jmp	.L1404
.L1403:
	addl	$1, -20(%rbp)
.L1402:
	movl	-56(%rbp), %edx
	cmpl	%edx, -20(%rbp)
	jl	.L1405
.L1404:
	movl	-4(%rbp), %edx
	cmpl	-8(%rbp), %edx
	jle	.L1408
	movabsq	$-4294967296, %rdx
	andq	%rdx, %rax
	movl	%eax, %eax
	jmp	.L1409
.L1397:
	movl	-8(%rbp), %edx
	leal	1(%rdx), %ecx
	movl	-4(%rbp), %edx
	movabsq	$-4294967296, %rsi
	andq	%rsi, %rax
	orq	%rdx, %rax
	movl	%ecx, %edx
	salq	$32, %rdx
	movl	%eax, %eax
	orq	%rdx, %rax
.L1409:
	popq	%rbp
	ret
	.globl	compare_strings
compare_strings:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	-8(%rbp), %rcx
	movq	(%rcx), %rdi
	movq	8(%rcx), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__lt
	testb	%al, %al
	je	.L1411
	movl	$-1, %eax
	jmp	.L1412
.L1411:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	-16(%rbp), %rcx
	movq	(%rcx), %rdi
	movq	8(%rcx), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__lt
	testb	%al, %al
	je	.L1413
	movl	$1, %eax
	jmp	.L1412
.L1413:
	movl	$0, %eax
.L1412:
	leave
	ret
	.globl	string_str
string_str:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	leave
	ret
	.section	.rodata, "a"
.LC116:
	.string	"string index out of range: "
.LC117:
	.string	" / "
	.text
	.globl	string_at
	.hidden	string_at
string_at:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$168, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rax
	movq	%rax, %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movl	%edx, -164(%rbp)
	cmpl	$0, -164(%rbp)
	js	.L1417
	movl	-152(%rbp), %eax
	cmpl	%eax, -164(%rbp)
	jl	.L1418
.L1417:
	leaq	-144(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC116(%rip), %rax
	movq	%rax, -144(%rbp)
	movl	$27, -136(%rbp)
	movl	$1, -132(%rbp)
	movl	$65031, -128(%rbp)
	movl	-164(%rbp), %eax
	movl	%eax, -120(%rbp)
	leaq	.LC117(%rip), %rax
	movq	%rax, -104(%rbp)
	movl	$3, -96(%rbp)
	movl	$1, -92(%rbp)
	movl	$65031, -88(%rbp)
	movl	-152(%rbp), %eax
	movl	%eax, -80(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$1, -52(%rbp)
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L1418:
	movq	-160(%rbp), %rdx
	movl	-164(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_at_with_check
	.hidden	string_at_with_check
string_at_with_check:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$152, %rsp
	movq	%rdi, -136(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	movl	%ecx, -140(%rbp)
	cmpl	$0, -140(%rbp)
	js	.L1421
	movl	-152(%rbp), %eax
	cmpl	%eax, -140(%rbp)
	jl	.L1422
.L1421:
	movq	-136(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-136(%rbp), %rax
	movb	$2, (%rax)
	movq	-136(%rbp), %rcx
	movq	_const_none__(%rip), %rax
	movq	8+_const_none__(%rip), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	16+_const_none__(%rip), %rax
	movq	24+_const_none__(%rip), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1420
.L1422:
	movq	-160(%rbp), %rdx
	movl	-140(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -65(%rbp)
	leaq	-128(%rbp), %rcx
	leaq	-65(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_option_ok
	movq	-136(%rbp), %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L1420:
	movq	-136(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC118:
	.string	"double string.free() detected\n"
	.text
	.globl	string_free
string_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	$-98761234, %eax
	jne	.L1426
	leaq	.LC118(%rip), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	vstrlen
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	_write_buf_to_fd
	jmp	.L1425
.L1426:
	movq	-24(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	$1, %eax
	je	.L1430
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L1430
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	_v_free
	movq	-24(%rbp), %rax
	movq	$0, (%rax)
	movq	-24(%rbp), %rax
	movl	$-98761234, 12(%rax)
	jmp	.L1425
.L1430:
	nop
.L1425:
	leave
	ret
	.globl	string_all_after_last
string_all_after_last:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -32(%rbp)
	movq	%rdi, -24(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -40(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rdi
	movq	-24(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_last_index_
	movl	%eax, -4(%rbp)
	cmpl	$-1, -4(%rbp)
	jne	.L1432
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	jmp	.L1433
.L1432:
	movl	-24(%rbp), %edx
	movl	-40(%rbp), %ecx
	movl	-4(%rbp), %eax
	leal	(%rcx,%rax), %edi
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	movl	%edx, %ecx
	movl	%edi, %edx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
.L1433:
	leave
	ret
	.globl	Array_string_join
Array_string_join:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$88, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rbx
	movq	%rcx, -96(%rbp)
	movq	%rbx, -88(%rbp)
	movl	36(%rbp), %ecx
	testl	%ecx, %ecx
	jne	.L1435
	leaq	.LC34(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	jmp	.L1436
.L1435:
	movl	$0, -20(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L1437
.L1438:
	movq	24(%rbp), %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	-56(%rbp), %edx
	movl	-88(%rbp), %eax
	addl	%edx, %eax
	addl	%eax, -20(%rbp)
	addl	$1, -24(%rbp)
.L1437:
	movl	36(%rbp), %eax
	cmpl	%eax, -24(%rbp)
	jl	.L1438
	movl	-88(%rbp), %eax
	subl	%eax, -20(%rbp)
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	movl	-20(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -48(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -40(%rbp)
	movl	$0, -28(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L1439
.L1441:
	movq	24(%rbp), %rax
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movl	-72(%rbp), %eax
	movslq	%eax, %rdx
	movq	-80(%rbp), %rax
	movq	-48(%rbp), %rsi
	movl	-28(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	%rsi, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	movl	-72(%rbp), %eax
	addl	%eax, -28(%rbp)
	movl	36(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -32(%rbp)
	je	.L1440
	movl	-88(%rbp), %eax
	movslq	%eax, %rdx
	movq	-96(%rbp), %rax
	movq	-48(%rbp), %rsi
	movl	-28(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	%rsi, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	movl	-88(%rbp), %eax
	addl	%eax, -28(%rbp)
.L1440:
	addl	$1, -32(%rbp)
.L1439:
	movl	36(%rbp), %eax
	cmpl	%eax, -32(%rbp)
	jl	.L1441
	movq	-48(%rbp), %rdx
	movl	-40(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
.L1436:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	string_bytes
string_bytes:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	-56(%rbp), %eax
	testl	%eax, %eax
	jne	.L1444
	movq	-40(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	jmp	.L1446
.L1444:
	movl	-56(%rbp), %esi
	leaq	-32(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	__new_array_with_default
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rcx
	movq	-24(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	vmemcpy
	movq	-40(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
.L1446:
	movq	-40(%rbp), %rax
	leave
	ret
	.section	.rodata, "a"
.LC119:
	.string	"string.repeat: count is negative: "
	.text
	.globl	string_repeat
string_repeat:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$152, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -144(%rbp)
	movq	%rdi, -136(%rbp)
	movl	%edx, -148(%rbp)
	cmpl	$0, -148(%rbp)
	jns	.L1448
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -128(%rbp)
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	leaq	.LC119(%rip), %rax
	movq	%rax, -128(%rbp)
	movl	$34, -120(%rbp)
	movl	$1, -116(%rbp)
	movl	$65031, -112(%rbp)
	movl	-148(%rbp), %eax
	movl	%eax, -104(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -88(%rbp)
	movl	$1, -76(%rbp)
	leaq	-128(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L1448:
	cmpl	$0, -148(%rbp)
	jne	.L1449
	leaq	.LC34(%rip), %rcx
	movq	%rbx, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, %rbx
	movq	%rbx, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %rbx
	jmp	.L1450
.L1449:
	cmpl	$1, -148(%rbp)
	jne	.L1451
	movq	-144(%rbp), %rdx
	movq	-136(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, %rcx
	movq	%rdx, %rbx
	jmp	.L1450
.L1451:
	movl	-136(%rbp), %eax
	imull	-148(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -32(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L1452
.L1453:
	movl	-136(%rbp), %eax
	movslq	%eax, %rdx
	movq	-144(%rbp), %rax
	movl	-136(%rbp), %ecx
	imull	-20(%rbp), %ecx
	movslq	%ecx, %rsi
	movq	-32(%rbp), %rcx
	addq	%rsi, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	vmemcpy
	addl	$1, -20(%rbp)
.L1452:
	movl	-20(%rbp), %eax
	cmpl	-148(%rbp), %eax
	jl	.L1453
	movl	-136(%rbp), %eax
	movl	-148(%rbp), %edx
	imull	%edx, %eax
	movl	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-36(%rbp), %edx
	movq	-32(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	u8_vstring_with_len
	movq	%rax, %rcx
	movq	%rdx, %rbx
.L1450:
	movq	%rcx, %rax
	movq	%rbx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	byteptr_vstring
byteptr_vstring:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	vstrlen
	movl	%eax, %ecx
	movl	$0, %eax
	movl	$0, %edx
	movq	-24(%rbp), %rax
	movl	%ecx, %esi
	movq	%rdx, %rdi
	movabsq	$-4294967296, %rcx
	andq	%rdi, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	byteptr_vstring_with_len
byteptr_vstring_with_len:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %ecx
	movq	%rdx, %rdi
	movabsq	$-4294967296, %rsi
	andq	%rdi, %rsi
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %ecx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	charptr_vstring
charptr_vstring:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	subq	$16, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	vstrlen_char
	movq	-24(%rbp), %r12
	movl	%eax, %edx
	movq	%r13, %rcx
	movabsq	$-4294967296, %rax
	andq	%rcx, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %eax
	movq	%rax, %r13
	movq	%r12, %rax
	movq	%r13, %rdx
	addq	$16, %rsp
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	charptr_vstring_with_len
charptr_vstring_with_len:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %ecx
	movq	%rdx, %rdi
	movabsq	$-4294967296, %rsi
	andq	%rdi, %rsi
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %ecx
	movq	%rcx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	byteptr_vstring_literal
byteptr_vstring_literal:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	subq	$16, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	vstrlen
	movq	-24(%rbp), %r12
	movl	%eax, %edx
	movq	%r13, %rcx
	movabsq	$-4294967296, %rax
	andq	%rcx, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rax
	movq	%r13, %rdx
	addq	$16, %rsp
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	charptr_vstring_literal
charptr_vstring_literal:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	subq	$16, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	vstrlen_char
	movq	-24(%rbp), %r12
	movl	%eax, %edx
	movq	%r13, %rcx
	movabsq	$-4294967296, %rax
	andq	%rcx, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rax
	movq	%r13, %rdx
	addq	$16, %rsp
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC120:
	.string	"no_str"
.LC121:
	.string	"c"
.LC122:
	.string	"u8"
.LC123:
	.string	"i8"
.LC124:
	.string	"u16"
.LC125:
	.string	"i16"
.LC126:
	.string	"u32"
.LC127:
	.string	"i32"
.LC128:
	.string	"u64"
.LC129:
	.string	"i64"
.LC130:
	.string	"f32"
.LC131:
	.string	"f64"
.LC132:
	.string	"s"
.LC133:
	.string	"p"
.LC134:
	.string	"vp"
	.text
	.globl	StrIntpType_str
StrIntpType_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movl	%edi, -36(%rbp)
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$1, -20(%rbp)
	cmpl	$18, -36(%rbp)
	ja	.L1467
	movl	-36(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L1469(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L1469(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata, "a"
.L1469:
	.text
.L1487:
	leaq	.LC120(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$6, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1486:
	leaq	.LC121(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$1, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1485:
	leaq	.LC122(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$2, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1484:
	leaq	.LC123(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$2, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1483:
	leaq	.LC124(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1482:
	leaq	.LC125(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1481:
	leaq	.LC126(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1480:
	leaq	.LC127(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1479:
	leaq	.LC128(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1478:
	leaq	.LC129(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1475:
	leaq	.LC130(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1474:
	leaq	.LC131(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1473:
	leaq	.LC130(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1472:
	leaq	.LC131(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1477:
	leaq	.LC130(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1476:
	leaq	.LC131(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$3, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1471:
	leaq	.LC132(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$1, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1470:
	leaq	.LC133(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$1, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
	jmp	.L1467
.L1468:
	leaq	.LC134(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$2, -24(%rbp)
	movl	$1, -20(%rbp)
	nop
.L1467:
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	fabs32
	.hidden	fabs32
fabs32:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	popq	%rbp
	ret
	.globl	fabs64
	.hidden	fabs64
fabs64:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	popq	%rbp
	ret
	.globl	abs64
	.hidden	abs64
abs64:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdx
	negq	%rdx
	cmovnsq	%rdx, %rax
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC135:
	.string	"-0"
.LC136:
	.string	"+INF"
.LC137:
	.string	"-INF"
.LC138:
	.string	"***ERROR!***"
	.text
	.globl	StrIntpData_process_str_intp_data
	.hidden	StrIntpData_process_str_intp_data
StrIntpData_process_str_intp_data:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$648, %rsp
	movq	%rdi, -648(%rbp)
	movq	%rsi, -656(%rbp)
	movq	-648(%rbp), %rcx
	movl	16(%rcx), %ecx
	movl	%ecx, -64(%rbp)
	movl	-64(%rbp), %ecx
	andl	$31, %ecx
	movl	%ecx, -68(%rbp)
	movl	-64(%rbp), %ecx
	shrl	$5, %ecx
	andl	$1, %ecx
	movl	%ecx, -72(%rbp)
	movl	-64(%rbp), %ecx
	andl	$128, %ecx
	testl	%ecx, %ecx
	setne	%cl
	movb	%cl, -73(%rbp)
	movl	-64(%rbp), %ecx
	shrl	$8, %ecx
	andl	$1, %ecx
	movl	%ecx, -80(%rbp)
	movl	-64(%rbp), %ecx
	shrl	$9, %ecx
	andl	$127, %ecx
	movl	%ecx, -84(%rbp)
	movl	-64(%rbp), %ecx
	andl	$65536, %ecx
	testl	%ecx, %ecx
	setne	%cl
	movb	%cl, -85(%rbp)
	movl	-64(%rbp), %ecx
	shrl	$17, %ecx
	movswl	%cx, %ecx
	andl	$1023, %ecx
	movl	%ecx, -92(%rbp)
	movl	-64(%rbp), %ecx
	shrl	$27, %ecx
	andl	$15, %ecx
	movl	%ecx, -20(%rbp)
	movl	-64(%rbp), %ecx
	shrl	$31, %ecx
	movb	%cl, -93(%rbp)
	cmpl	$0, -68(%rbp)
	je	.L1586
	cmpl	$0, -20(%rbp)
	jle	.L1498
	addl	$2, -20(%rbp)
.L1498:
	movb	$32, -21(%rbp)
	cmpb	$0, -93(%rbp)
	je	.L1499
	movb	$48, -21(%rbp)
.L1499:
	cmpl	$0, -92(%rbp)
	jle	.L1500
	movl	-92(%rbp), %ecx
	jmp	.L1501
.L1500:
	movl	$-1, %ecx
.L1501:
	movl	%ecx, -100(%rbp)
	cmpl	$127, -84(%rbp)
	je	.L1502
	movl	-84(%rbp), %ecx
	jmp	.L1503
.L1502:
	movl	$-1, %ecx
.L1503:
	movl	%ecx, -104(%rbp)
	cmpl	$1, -80(%rbp)
	sete	%cl
	movb	%cl, -105(%rbp)
	movzbl	-21(%rbp), %ecx
	movb	%cl, -160(%rbp)
	movl	-100(%rbp), %ecx
	movl	%ecx, -156(%rbp)
	movl	-104(%rbp), %ecx
	movl	%ecx, -152(%rbp)
	movb	$1, -148(%rbp)
	movzbl	-105(%rbp), %ecx
	movb	%cl, -147(%rbp)
	movl	$1, -144(%rbp)
	movzbl	-85(%rbp), %ecx
	movb	%cl, -140(%rbp)
	cmpb	$0, -93(%rbp)
	jne	.L1504
	cmpl	$0, -72(%rbp)
	je	.L1505
	cmpl	$1, -72(%rbp)
	je	.L1506
	jmp	.L1585
.L1505:
	movl	$1, -144(%rbp)
	jmp	.L1509
.L1506:
	movl	$0, -144(%rbp)
	jmp	.L1509
.L1585:
	movl	$1, -144(%rbp)
	jmp	.L1509
.L1504:
	movl	$0, -144(%rbp)
.L1509:
	cmpl	$16, -68(%rbp)
	jne	.L1510
	leaq	.LC34(%rip), %rax
	movq	%rax, -208(%rbp)
	movl	$0, -200(%rbp)
	movl	$1, -196(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1511
	movq	-648(%rbp), %rax
	movq	24(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
	jmp	.L1512
.L1511:
	movq	-648(%rbp), %rax
	movq	24(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
.L1512:
	cmpl	$0, -92(%rbp)
	jne	.L1513
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	jmp	.L1514
.L1513:
	movq	-656(%rbp), %r8
	movq	-208(%rbp), %rdi
	movq	-200(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
.L1514:
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1510:
	cmpl	$3, -68(%rbp)
	je	.L1515
	cmpl	$5, -68(%rbp)
	je	.L1515
	cmpl	$7, -68(%rbp)
	je	.L1515
	cmpl	$9, -68(%rbp)
	jne	.L1516
.L1515:
	movq	-648(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, -32(%rbp)
	cmpl	$3, -68(%rbp)
	jne	.L1517
	movq	-648(%rbp), %rax
	movzbl	24(%rax), %eax
	movsbq	%al, %rax
	movq	%rax, -32(%rbp)
	jmp	.L1518
.L1517:
	cmpl	$5, -68(%rbp)
	jne	.L1519
	movq	-648(%rbp), %rax
	movzwl	24(%rax), %eax
	movswq	%ax, %rax
	movq	%rax, -32(%rbp)
	jmp	.L1518
.L1519:
	cmpl	$7, -68(%rbp)
	jne	.L1518
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	cltq
	movq	%rax, -32(%rbp)
.L1518:
	cmpl	$0, -20(%rbp)
	jne	.L1520
	cmpl	$0, -92(%rbp)
	jne	.L1521
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	i64_str
	movq	%rax, -224(%rbp)
	movq	%rdx, -216(%rbp)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-224(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1521:
	cmpq	$0, -32(%rbp)
	jns	.L1522
	movb	$0, -148(%rbp)
.L1522:
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	abs64
	movq	%rax, %rdi
	movq	-656(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	strconv__format_dec_sb
	addq	$32, %rsp
	jmp	.L1495
.L1520:
	cmpl	$3, -20(%rbp)
	jne	.L1524
	movl	$2, -20(%rbp)
.L1524:
	movq	-32(%rbp), %rax
	movq	%rax, -40(%rbp)
	movb	$0, -41(%rbp)
	cmpq	$0, -32(%rbp)
	jns	.L1525
	cmpb	$32, -21(%rbp)
	je	.L1525
	movq	-32(%rbp), %rax
	negq	%rax
	movq	%rax, -40(%rbp)
	movb	$1, -41(%rbp)
.L1525:
	movl	-20(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strconv__format_int
	movq	%rax, -240(%rbp)
	movq	%rdx, -232(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1526
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, -256(%rbp)
	movq	%rdx, -248(%rbp)
	movq	-240(%rbp), %rdx
	movq	-232(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -240(%rbp)
	movq	%rdx, -232(%rbp)
	leaq	-256(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1526:
	cmpb	$0, -41(%rbp)
	je	.L1527
	movq	-656(%rbp), %rax
	movl	$45, %esi
	movq	%rax, %rdi
	call	strings__Builder_write_u8
	movl	-156(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -156(%rbp)
.L1527:
	cmpl	$0, -92(%rbp)
	jne	.L1528
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	jmp	.L1529
.L1528:
	movq	-656(%rbp), %r8
	movq	-240(%rbp), %rdi
	movq	-232(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
.L1529:
	leaq	-240(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1516:
	cmpl	$2, -68(%rbp)
	je	.L1530
	cmpl	$4, -68(%rbp)
	je	.L1530
	cmpl	$6, -68(%rbp)
	je	.L1530
	cmpl	$8, -68(%rbp)
	jne	.L1531
.L1530:
	movq	-648(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, -56(%rbp)
	cmpl	$2, -68(%rbp)
	jne	.L1532
	movq	-648(%rbp), %rax
	movzbl	24(%rax), %eax
	movzbl	%al, %eax
	movq	%rax, -56(%rbp)
	jmp	.L1533
.L1532:
	cmpl	$4, -68(%rbp)
	jne	.L1534
	movq	-648(%rbp), %rax
	movzwl	24(%rax), %eax
	movzwl	%ax, %eax
	movq	%rax, -56(%rbp)
	jmp	.L1533
.L1534:
	cmpl	$6, -68(%rbp)
	jne	.L1533
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	movl	%eax, %eax
	movq	%rax, -56(%rbp)
.L1533:
	cmpl	$0, -20(%rbp)
	jne	.L1535
	cmpl	$0, -92(%rbp)
	jne	.L1536
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	u64_str
	movq	%rax, -272(%rbp)
	movq	%rdx, -264(%rbp)
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-272(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1536:
	movq	-656(%rbp), %rsi
	movq	-56(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	strconv__format_dec_sb
	addq	$32, %rsp
	jmp	.L1495
.L1535:
	cmpl	$3, -20(%rbp)
	jne	.L1538
	movl	$2, -20(%rbp)
.L1538:
	movl	-20(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strconv__format_uint
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1539
	movq	-288(%rbp), %rax
	movq	-280(%rbp), %rdx
	movq	%rax, -304(%rbp)
	movq	%rdx, -296(%rbp)
	movq	-288(%rbp), %rdx
	movq	-280(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	leaq	-304(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1539:
	cmpl	$0, -92(%rbp)
	jne	.L1540
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	jmp	.L1541
.L1540:
	movq	-656(%rbp), %r8
	movq	-288(%rbp), %rdi
	movq	-280(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
.L1541:
	leaq	-288(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1531:
	cmpl	$17, -68(%rbp)
	jne	.L1542
	movq	-648(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, -136(%rbp)
	movl	$16, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jne	.L1543
	cmpl	$0, -92(%rbp)
	jne	.L1544
	movq	-136(%rbp), %rax
	movq	%rax, %rdi
	call	u64_str
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-320(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1544:
	movq	-656(%rbp), %rsi
	movq	-136(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	strconv__format_dec_sb
	addq	$32, %rsp
	jmp	.L1495
.L1543:
	movl	-20(%rbp), %edx
	movq	-136(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	strconv__format_uint
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1546
	movq	-336(%rbp), %rax
	movq	-328(%rbp), %rdx
	movq	%rax, -352(%rbp)
	movq	%rdx, -344(%rbp)
	movq	-336(%rbp), %rdx
	movq	-328(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	leaq	-352(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1546:
	cmpl	$0, -92(%rbp)
	jne	.L1547
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	jmp	.L1548
.L1547:
	movq	-656(%rbp), %r8
	movq	-336(%rbp), %rdi
	movq	-328(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
.L1548:
	leaq	-336(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1542:
	movb	$0, -57(%rbp)
	cmpl	$0, -92(%rbp)
	jne	.L1549
	cmpl	$127, -84(%rbp)
	jne	.L1549
	movl	$3, -152(%rbp)
	movb	$1, -57(%rbp)
.L1549:
	movl	-152(%rbp), %ecx
	testl	%ecx, %ecx
	jns	.L1550
	movl	$3, -152(%rbp)
.L1550:
	cmpl	$18, -68(%rbp)
	ja	.L1551
	movl	-68(%rbp), %ecx
	leaq	0(,%rcx,4), %rsi
	leaq	.L1553(%rip), %rcx
	movl	(%rsi,%rcx), %ecx
	movslq	%ecx, %rcx
	leaq	.L1553(%rip), %rsi
	addq	%rsi, %rcx
	jmp	*%rcx
	.section	.rodata, "a"
.L1553:
	.text
.L1555:
	cmpb	$0, -57(%rbp)
	jne	.L1588
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	movl	$0, %edx
	cmpl	%edx, %eax
	jne	.L1563
	leaq	.LC43(%rip), %rax
	movq	%rax, -384(%rbp)
	movl	$1, -376(%rbp)
	movl	$1, -372(%rbp)
	movq	-656(%rbp), %r8
	movq	-384(%rbp), %rdi
	movq	-376(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
	leaq	-384(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1563:
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	movl	$-2147483648, %edx
	cmpl	%edx, %eax
	jne	.L1565
	leaq	.LC135(%rip), %rax
	movq	%rax, -400(%rbp)
	movl	$2, -392(%rbp)
	movl	$1, -388(%rbp)
	movq	-656(%rbp), %r8
	movq	-400(%rbp), %rdi
	movq	-392(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
	leaq	-400(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1565:
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	movl	$2139095040, %edx
	cmpl	%edx, %eax
	jne	.L1566
	leaq	.LC47(%rip), %rax
	movq	%rax, -416(%rbp)
	movl	$4, -408(%rbp)
	movl	$1, -404(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1567
	leaq	.LC136(%rip), %rax
	movq	%rax, -416(%rbp)
	movl	$4, -408(%rbp)
	movl	$1, -404(%rbp)
.L1567:
	movq	-656(%rbp), %r8
	movq	-416(%rbp), %rdi
	movq	-408(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
	leaq	-416(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1566:
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	movl	$-8388608, %edx
	cmpl	%edx, %eax
	jne	.L1568
	leaq	.LC46(%rip), %rax
	movq	%rax, -432(%rbp)
	movl	$4, -424(%rbp)
	movl	$1, -420(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1569
	leaq	.LC137(%rip), %rax
	movq	%rax, -432(%rbp)
	movl	$4, -424(%rbp)
	movl	$1, -420(%rbp)
.L1569:
	movq	-656(%rbp), %r8
	movq	-432(%rbp), %rdi
	movq	-424(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
	leaq	-432(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1568:
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	movl	%eax, %edi
	call	fabs32
	movl	%eax, -124(%rbp)
	cmpl	$999998, -124(%rbp)
	ja	.L1570
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	movl	%eax, %esi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	strconv__format_fl
	addq	$32, %rsp
	movq	%rax, -448(%rbp)
	movq	%rdx, -440(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1571
	movq	-448(%rbp), %rax
	movq	-440(%rbp), %rdx
	movq	%rax, -464(%rbp)
	movq	%rdx, -456(%rbp)
	movq	-448(%rbp), %rdx
	movq	-440(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -448(%rbp)
	movq	%rdx, -440(%rbp)
	leaq	-464(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1571:
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-448(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1570:
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	movl	%eax, %esi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	strconv__format_es
	addq	$32, %rsp
	movq	%rax, -368(%rbp)
	movq	%rdx, -360(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1572
	movq	-368(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rax, -480(%rbp)
	movq	%rdx, -472(%rbp)
	movq	-368(%rbp), %rdx
	movq	-360(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -368(%rbp)
	movq	%rdx, -360(%rbp)
	leaq	-480(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1572:
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-368(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1588
.L1554:
	cmpb	$0, -57(%rbp)
	jne	.L1589
	movq	-648(%rbp), %rax
	movq	24(%rax), %rax
	movl	$0, %edx
	cmpq	%rdx, %rax
	jne	.L1574
	leaq	.LC43(%rip), %rax
	movq	%rax, -512(%rbp)
	movl	$1, -504(%rbp)
	movl	$1, -500(%rbp)
	movq	-656(%rbp), %r8
	movq	-512(%rbp), %rdi
	movq	-504(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
	leaq	-512(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1574:
	movq	-648(%rbp), %rax
	movq	24(%rax), %rdx
	movabsq	$-9223372036854775808, %rax
	cmpq	%rax, %rdx
	jne	.L1576
	leaq	.LC135(%rip), %rax
	movq	%rax, -528(%rbp)
	movl	$2, -520(%rbp)
	movl	$1, -516(%rbp)
	movq	-656(%rbp), %r8
	movq	-528(%rbp), %rdi
	movq	-520(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
	leaq	-528(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1576:
	movq	-648(%rbp), %rax
	movq	24(%rax), %rdx
	movabsq	$9218868437227405312, %rax
	cmpq	%rax, %rdx
	jne	.L1577
	leaq	.LC47(%rip), %rax
	movq	%rax, -544(%rbp)
	movl	$4, -536(%rbp)
	movl	$1, -532(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1578
	leaq	.LC136(%rip), %rax
	movq	%rax, -544(%rbp)
	movl	$4, -536(%rbp)
	movl	$1, -532(%rbp)
.L1578:
	movq	-656(%rbp), %r8
	movq	-544(%rbp), %rdi
	movq	-536(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
	leaq	-544(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1577:
	movq	-648(%rbp), %rax
	movq	24(%rax), %rdx
	movabsq	$-4503599627370496, %rax
	cmpq	%rax, %rdx
	jne	.L1579
	leaq	.LC46(%rip), %rax
	movq	%rax, -560(%rbp)
	movl	$4, -552(%rbp)
	movl	$1, -548(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1580
	leaq	.LC137(%rip), %rax
	movq	%rax, -560(%rbp)
	movl	$4, -552(%rbp)
	movl	$1, -548(%rbp)
.L1580:
	movq	-656(%rbp), %r8
	movq	-560(%rbp), %rdi
	movq	-552(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rdx
	call	strconv__format_str_sb
	addq	$32, %rsp
	leaq	-560(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1579:
	movq	-648(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	fabs64
	movq	%rax, -120(%rbp)
	cmpq	$999998, -120(%rbp)
	ja	.L1581
	movq	-648(%rbp), %rax
	movq	24(%rax), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	strconv__format_fl
	addq	$32, %rsp
	movq	%rax, -576(%rbp)
	movq	%rdx, -568(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1582
	movq	-576(%rbp), %rax
	movq	-568(%rbp), %rdx
	movq	%rax, -592(%rbp)
	movq	%rdx, -584(%rbp)
	movq	-576(%rbp), %rdx
	movq	-568(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -576(%rbp)
	movq	%rdx, -568(%rbp)
	leaq	-592(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1582:
	movq	-576(%rbp), %rcx
	movq	-568(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-576(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1581:
	movq	-648(%rbp), %rax
	movq	24(%rax), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	strconv__format_es
	addq	$32, %rsp
	movq	%rax, -496(%rbp)
	movq	%rdx, -488(%rbp)
	cmpb	$0, -73(%rbp)
	je	.L1583
	movq	-496(%rbp), %rax
	movq	-488(%rbp), %rdx
	movq	%rax, -608(%rbp)
	movq	%rdx, -600(%rbp)
	movq	-496(%rbp), %rdx
	movq	-488(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -496(%rbp)
	movq	%rdx, -488(%rbp)
	leaq	-608(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1583:
	movq	-496(%rbp), %rcx
	movq	-488(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-496(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1589
.L1560:
	movq	-648(%rbp), %rax
	movl	24(%rax), %eax
	movl	%eax, %edi
	call	utf32_to_str
	movq	%rax, -624(%rbp)
	movq	%rdx, -616(%rbp)
	movq	-624(%rbp), %rcx
	movq	-616(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-624(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1552:
	movq	-648(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	u64_hex
	movq	%rax, -640(%rbp)
	movq	%rdx, -632(%rbp)
	movq	-640(%rbp), %rcx
	movq	-632(%rbp), %rdx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	leaq	-640(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	jmp	.L1495
.L1551:
	leaq	.LC138(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$12, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	-656(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
	nop
	jmp	.L1495
.L1586:
	nop
	jmp	.L1495
.L1587:
	nop
	jmp	.L1495
.L1588:
	nop
	jmp	.L1495
.L1589:
	nop
.L1495:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	str_intp
str_intp:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movl	%edi, -68(%rbp)
	movq	%rsi, -80(%rbp)
	leaq	-48(%rbp), %rax
	movl	$256, %esi
	movq	%rax, %rdi
	call	strings__new_builder
	movl	$0, -4(%rbp)
	jmp	.L1591
.L1594:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	8(%rax), %eax
	testl	%eax, %eax
	je	.L1592
	movq	-16(%rbp), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rdx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_string
.L1592:
	movq	-16(%rbp), %rax
	movl	16(%rax), %eax
	testl	%eax, %eax
	je	.L1593
	leaq	-48(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	StrIntpData_process_str_intp_data
.L1593:
	addl	$1, -4(%rbp)
.L1591:
	movl	-4(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	.L1594
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	strings__Builder_str
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	strings__Builder_free
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	leave
	ret
	.globl	utf32_to_str
utf32_to_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movl	%edi, -52(%rbp)
	movl	$5, %edi
	call	malloc_noscan
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rdx
	movl	-52(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	utf32_to_str_no_malloc
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movl	-40(%rbp), %eax
	testl	%eax, %eax
	jne	.L1597
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	_v_free
.L1597:
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	utf32_to_str_no_malloc
utf32_to_str_no_malloc:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	subq	$32, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rdx
	movl	-36(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	utf32_decode_to_buffer
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jne	.L1600
	leaq	.LC34(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	jmp	.L1601
.L1600:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-20(%rbp), %edx
	movq	-48(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	%rax, %r12
	movq	%rdx, %r13
.L1601:
	movq	%r12, %rax
	movq	%r13, %rdx
	addq	$32, %rsp
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	utf32_decode_to_buffer
utf32_decode_to_buffer:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -4(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -16(%rbp)
	cmpl	$127, -4(%rbp)
	jg	.L1604
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	movl	$1, %eax
	jmp	.L1605
.L1604:
	cmpl	$2047, -4(%rbp)
	jg	.L1606
	movl	-4(%rbp), %eax
	sarl	$6, %eax
	orl	$-64, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	movl	-4(%rbp), %eax
	andl	$63, %eax
	orl	$-128, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	addq	$1, %rax
	movb	%dl, (%rax)
	movl	$2, %eax
	jmp	.L1605
.L1606:
	cmpl	$65535, -4(%rbp)
	jg	.L1607
	movl	-4(%rbp), %eax
	sarl	$12, %eax
	orl	$-32, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	movl	-4(%rbp), %eax
	sarl	$6, %eax
	andl	$63, %eax
	orl	$-128, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	addq	$1, %rax
	movb	%dl, (%rax)
	movl	-4(%rbp), %eax
	andl	$63, %eax
	orl	$-128, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	addq	$2, %rax
	movb	%dl, (%rax)
	movl	$3, %eax
	jmp	.L1605
.L1607:
	cmpl	$1114111, -4(%rbp)
	jg	.L1608
	movl	-4(%rbp), %eax
	sarl	$18, %eax
	orl	$-16, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	movl	-4(%rbp), %eax
	sarl	$12, %eax
	andl	$63, %eax
	orl	$-128, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	addq	$1, %rax
	movb	%dl, (%rax)
	movl	-4(%rbp), %eax
	sarl	$6, %eax
	andl	$63, %eax
	orl	$-128, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	addq	$2, %rax
	movb	%dl, (%rax)
	movl	-4(%rbp), %eax
	andl	$63, %eax
	orl	$-128, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	addq	$3, %rax
	movb	%dl, (%rax)
	movl	$4, %eax
	jmp	.L1605
.L1608:
	movl	$0, %eax
.L1605:
	popq	%rbp
	ret
	.globl	utf8_str_visible_length
utf8_str_visible_length:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	$0, -4(%rbp)
	movl	$1, -12(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L1610
.L1635:
	movq	-64(%rbp), %rdx
	movl	-8(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -13(%rbp)
	movq	-64(%rbp), %rdx
	movl	-8(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	shrb	$3, %al
	movzbl	%al, %eax
	andl	$30, %eax
	movl	$-452984832, %edx
	movl	%eax, %ecx
	shrl	%cl, %edx
	movl	%edx, %eax
	andl	$3, %eax
	addl	$1, %eax
	movl	%eax, -12(%rbp)
	movl	-8(%rbp), %edx
	movl	-12(%rbp), %eax
	addl	%eax, %edx
	movl	-56(%rbp), %eax
	cmpl	%eax, %edx
	jle	.L1611
	movl	-4(%rbp), %eax
	jmp	.L1612
.L1611:
	addl	$1, -4(%rbp)
	cmpl	$1, -12(%rbp)
	je	.L1636
	cmpl	$2, -12(%rbp)
	jne	.L1615
	movzbl	-13(%rbp), %eax
	sall	$8, %eax
	movl	%eax, %ecx
	movq	-64(%rbp), %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	orl	%ecx, %eax
	cltq
	movq	%rax, -40(%rbp)
	cmpq	$52351, -40(%rbp)
	jbe	.L1614
	cmpq	$52655, -40(%rbp)
	ja	.L1614
	subl	$1, -4(%rbp)
	jmp	.L1614
.L1615:
	cmpl	$3, -12(%rbp)
	jne	.L1616
	movzbl	-13(%rbp), %eax
	sall	$16, %eax
	movl	%eax, %ecx
	movq	-64(%rbp), %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	sall	$8, %eax
	movl	%eax, %esi
	movq	-64(%rbp), %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	addq	$2, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	orl	%esi, %eax
	orl	%ecx, %eax
	movl	%eax, %eax
	movq	%rax, -32(%rbp)
	cmpq	$14789295, -32(%rbp)
	jbe	.L1617
	cmpq	$14789759, -32(%rbp)
	jbe	.L1618
.L1617:
	cmpq	$14792575, -32(%rbp)
	jbe	.L1619
	cmpq	$14792831, -32(%rbp)
	jbe	.L1618
.L1619:
	cmpq	$14844815, -32(%rbp)
	jbe	.L1620
	cmpq	$14845055, -32(%rbp)
	jbe	.L1618
.L1620:
	cmpq	$15710367, -32(%rbp)
	jbe	.L1621
	cmpq	$15710383, -32(%rbp)
	ja	.L1621
.L1618:
	subl	$1, -4(%rbp)
	jmp	.L1614
.L1621:
	cmpq	$14779519, -32(%rbp)
	jbe	.L1623
	cmpq	$14779807, -32(%rbp)
	jbe	.L1624
.L1623:
	cmpq	$14858879, -32(%rbp)
	jbe	.L1625
	cmpq	$14860181, -32(%rbp)
	jbe	.L1624
.L1625:
	cmpq	$14909567, -32(%rbp)
	jbe	.L1626
	cmpq	$14989183, -32(%rbp)
	jbe	.L1624
.L1626:
	cmpq	$14989439, -32(%rbp)
	jbe	.L1627
	cmpq	$15368319, -32(%rbp)
	jbe	.L1624
.L1627:
	cmpq	$15377823, -32(%rbp)
	jbe	.L1628
	cmpq	$15378335, -32(%rbp)
	jbe	.L1624
.L1628:
	cmpq	$15380607, -32(%rbp)
	jbe	.L1629
	cmpq	$15572655, -32(%rbp)
	jbe	.L1624
.L1629:
	cmpq	$15705215, -32(%rbp)
	jbe	.L1630
	cmpq	$15707263, -32(%rbp)
	jbe	.L1624
.L1630:
	cmpq	$15710391, -32(%rbp)
	jbe	.L1614
	cmpq	$15710639, -32(%rbp)
	ja	.L1614
.L1624:
	addl	$1, -4(%rbp)
	jmp	.L1614
.L1616:
	cmpl	$4, -12(%rbp)
	jne	.L1614
	movzbl	-13(%rbp), %eax
	sall	$24, %eax
	movl	%eax, %ecx
	movq	-64(%rbp), %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	sall	$16, %eax
	movl	%eax, %esi
	movq	-64(%rbp), %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	addq	$2, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	sall	$8, %eax
	orl	%eax, %esi
	movq	-64(%rbp), %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	addq	$3, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	orl	%esi, %eax
	orl	%ecx, %eax
	movl	%eax, %eax
	movq	%rax, -24(%rbp)
	cmpq	$262113407, -24(%rbp)
	jbe	.L1631
	movl	$4036987535, %eax
	cmpq	-24(%rbp), %rax
	jnb	.L1632
.L1631:
	movl	$4036988031, %eax
	cmpq	-24(%rbp), %rax
	jnb	.L1633
	movl	$4036992144, %eax
	cmpq	-24(%rbp), %rax
	jnb	.L1632
.L1633:
	movl	$4036994191, %eax
	cmpq	-24(%rbp), %rax
	jnb	.L1634
	movl	$4036994991, %eax
	cmpq	-24(%rbp), %rax
	jnb	.L1632
.L1634:
	movl	$4037050495, %eax
	cmpq	-24(%rbp), %rax
	jnb	.L1614
	movl	$4051730559, %eax
	cmpq	-24(%rbp), %rax
	jb	.L1614
.L1632:
	addl	$1, -4(%rbp)
	jmp	.L1614
.L1636:
	nop
.L1614:
	movl	-12(%rbp), %eax
	addl	%eax, -8(%rbp)
.L1610:
	movl	-56(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L1635
	movl	-4(%rbp), %eax
.L1612:
	popq	%rbp
	ret
	.globl	ArrayFlags_has
ArrayFlags_has:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edx
	movl	-12(%rbp), %eax
	andl	%edx, %eax
	testl	%eax, %eax
	setne	%al
	popq	%rbp
	ret
	.globl	ArrayFlags_all
ArrayFlags_all:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edx
	movl	-12(%rbp), %eax
	andl	%eax, %edx
	movl	-12(%rbp), %eax
	cmpl	%eax, %edx
	sete	%al
	popq	%rbp
	ret
	.globl	ArrayFlags_set
ArrayFlags_set:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edx
	movl	-12(%rbp), %eax
	orl	%edx, %eax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movl	%edx, (%rax)
	nop
	popq	%rbp
	ret
	.globl	ArrayFlags_clear
ArrayFlags_clear:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edx
	movl	-12(%rbp), %eax
	notl	%eax
	andl	%edx, %eax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movl	%edx, (%rax)
	nop
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC139:
	.string	"Unknown flag `"
	.text
	.globl	flag__UnknownFlagError_msg
	.hidden	flag__UnknownFlagError_msg
flag__UnknownFlagError_msg:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$120, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	leaq	.LC139(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$14, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65040, -96(%rbp)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, -88(%rbp)
	movq	%rdx, -80(%rbp)
	leaq	.LC89(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$1, -64(%rbp)
	movl	$1, -60(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC140:
	.string	"Expected no arguments, but got "
.LC141:
	.string	"Expected at most "
.LC142:
	.string	" arguments, but got "
.LC143:
	.string	"Expected at least "
	.text
	.globl	flag__ArgsCountError_msg
	.hidden	flag__ArgsCountError_msg
flag__ArgsCountError_msg:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$200, %rsp
	movq	%rdi, -200(%rbp)
	movl	-196(%rbp), %eax
	testl	%eax, %eax
	jne	.L1646
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -160(%rbp)
	movaps	%xmm0, -144(%rbp)
	movaps	%xmm0, -128(%rbp)
	leaq	.LC140(%rip), %rax
	movq	%rax, -192(%rbp)
	movl	$31, -184(%rbp)
	movl	$1, -180(%rbp)
	movl	$65031, -176(%rbp)
	movl	-200(%rbp), %eax
	movl	%eax, -168(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -152(%rbp)
	movl	$1, -140(%rbp)
	leaq	-192(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	jmp	.L1647
.L1646:
	movl	-200(%rbp), %edx
	movl	-196(%rbp), %eax
	cmpl	%eax, %edx
	jle	.L1648
	leaq	-192(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC141(%rip), %rax
	movq	%rax, -192(%rbp)
	movl	$17, -184(%rbp)
	movl	$1, -180(%rbp)
	movl	$65031, -176(%rbp)
	movl	-196(%rbp), %eax
	movl	%eax, -168(%rbp)
	leaq	.LC142(%rip), %rax
	movq	%rax, -152(%rbp)
	movl	$20, -144(%rbp)
	movl	$1, -140(%rbp)
	movl	$65031, -136(%rbp)
	movl	-200(%rbp), %eax
	movl	%eax, -128(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$1, -100(%rbp)
	leaq	-192(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	jmp	.L1647
.L1648:
	leaq	-192(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC143(%rip), %rax
	movq	%rax, -192(%rbp)
	movl	$18, -184(%rbp)
	movl	$1, -180(%rbp)
	movl	$65031, -176(%rbp)
	movl	-196(%rbp), %eax
	movl	%eax, -168(%rbp)
	leaq	.LC142(%rip), %rax
	movq	%rax, -152(%rbp)
	movl	$20, -144(%rbp)
	movl	$1, -140(%rbp)
	movl	$65031, -136(%rbp)
	movl	-200(%rbp), %eax
	movl	%eax, -128(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$1, -100(%rbp)
	leaq	-192(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
.L1647:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	flag__Flag_free
	.hidden	flag__Flag_free
flag__Flag_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$24, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$40, %rax
	movq	%rax, %rdi
	call	string_free
	nop
	leave
	ret
	.section	.rodata, "a"
.LC144:
	.string	"            desc: "
.LC145:
	.string	"            usag: "
.LC146:
	.string	"\n"
.LC147:
	.string	"            abbr: `"
.LC148:
	.string	"`\n"
.LC149:
	.string	"            name: "
.LC150:
	.string	"    flag:\n"
	.text
	.globl	flag__Flag_str
flag__Flag_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$376, %rsp
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -384(%rbp)
	movaps	%xmm0, -368(%rbp)
	movaps	%xmm0, -352(%rbp)
	movaps	%xmm0, -336(%rbp)
	movaps	%xmm0, -320(%rbp)
	leaq	.LC144(%rip), %rax
	movq	%rax, -384(%rbp)
	movl	$18, -376(%rbp)
	movl	$1, -372(%rbp)
	movl	$65040, -368(%rbp)
	movq	56(%rbp), %rax
	movq	64(%rbp), %rdx
	movq	%rax, -360(%rbp)
	movq	%rdx, -352(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -344(%rbp)
	movl	$1, -332(%rbp)
	leaq	-384(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %r14
	movq	%rdx, %r15
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -304(%rbp)
	movaps	%xmm0, -288(%rbp)
	movaps	%xmm0, -272(%rbp)
	movaps	%xmm0, -256(%rbp)
	movaps	%xmm0, -240(%rbp)
	leaq	.LC145(%rip), %rax
	movq	%rax, -304(%rbp)
	movl	$18, -296(%rbp)
	movl	$1, -292(%rbp)
	movl	$65040, -288(%rbp)
	movq	40(%rbp), %rax
	movq	48(%rbp), %rdx
	movq	%rax, -280(%rbp)
	movq	%rdx, -272(%rbp)
	leaq	.LC146(%rip), %rax
	movq	%rax, -264(%rbp)
	movl	$1, -256(%rbp)
	movl	$1, -252(%rbp)
	leaq	-304(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -416(%rbp)
	movq	%rdx, -408(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -224(%rbp)
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -160(%rbp)
	leaq	.LC147(%rip), %rax
	movq	%rax, -224(%rbp)
	movl	$19, -216(%rbp)
	movl	$1, -212(%rbp)
	movl	$65040, -208(%rbp)
	movzbl	32(%rbp), %eax
	movzbl	%al, %eax
	movl	%eax, %edi
	call	u8_ascii_str
	movq	%rax, -200(%rbp)
	movq	%rdx, -192(%rbp)
	leaq	.LC148(%rip), %rax
	movq	%rax, -184(%rbp)
	movl	$2, -176(%rbp)
	movl	$1, -172(%rbp)
	leaq	-224(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -400(%rbp)
	movq	%rdx, -392(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -144(%rbp)
	movaps	%xmm0, -128(%rbp)
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	leaq	.LC149(%rip), %rax
	movq	%rax, -144(%rbp)
	movl	$18, -136(%rbp)
	movl	$1, -132(%rbp)
	movl	$65040, -128(%rbp)
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -120(%rbp)
	movq	%rdx, -112(%rbp)
	leaq	.LC146(%rip), %rax
	movq	%rax, -104(%rbp)
	movl	$1, -96(%rbp)
	movl	$1, -92(%rbp)
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	leaq	.LC150(%rip), %r12
	movq	%r13, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$10, %rcx
	movq	%rcx, %r13
	movq	%r13, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %r13
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rsi, %rdi
	movq	%rbx, %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__plus
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %rax
	movq	-400(%rbp), %rdx
	movq	-392(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__plus
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %rax
	movq	-416(%rbp), %rdx
	movq	-408(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__plus
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %rax
	movq	%r14, %rdx
	movq	%r15, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__plus
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	addq	$376, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC151:
	.string	"\n  []Flag = ["
.LC152:
	.string	"  ]"
	.text
	.globl	Array_flag__Flag_str
Array_flag__Flag_str:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$200, %rsp
	leaq	-96(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	.LC151(%rip), %rax
	movq	%rax, -240(%rbp)
	movq	-232(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$13, %rax
	movq	%rax, -232(%rbp)
	movq	-232(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -232(%rbp)
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	leaq	-112(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movl	$0, -52(%rbp)
	jmp	.L1654
.L1655:
	movq	24(%rbp), %rcx
	movl	-52(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -224(%rbp)
	movq	%rbx, -216(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -208(%rbp)
	movq	%rbx, -200(%rbp)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, -192(%rbp)
	movq	%rbx, -184(%rbp)
	movq	48(%rax), %rax
	movq	%rax, -176(%rbp)
	subq	$8, %rsp
	subq	$56, %rsp
	movq	%rsp, %rax
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-176(%rbp), %rdx
	movq	%rdx, 48(%rax)
	call	flag__Flag_str
	addq	$64, %rsp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	leaq	-160(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	addl	$1, -52(%rbp)
.L1654:
	movl	36(%rbp), %eax
	cmpl	%eax, -52(%rbp)
	jl	.L1655
	leaq	.LC152(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	%r14, %rcx
	movq	%r15, %rbx
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	leaq	-128(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	leaq	.LC146(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	call	Array_string_join
	addq	$32, %rsp
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	flag__FlagParser_free
	.hidden	flag__FlagParser_free
flag__FlagParser_free:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$120, %rsp
	movq	%rdi, -120(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L1658
.L1659:
	movq	-120(%rbp), %rax
	movq	144(%rax), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	addl	$1, -20(%rbp)
.L1658:
	movq	-120(%rbp), %rax
	movl	156(%rax), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L1659
	movq	-120(%rbp), %rax
	addq	$136, %rax
	movq	%rax, %rdi
	call	array_free
	movl	$0, -24(%rbp)
	jmp	.L1660
.L1661:
	movq	-120(%rbp), %rax
	movq	184(%rax), %rcx
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -112(%rbp)
	movq	%rbx, -104(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -96(%rbp)
	movq	%rbx, -88(%rbp)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, -80(%rbp)
	movq	%rbx, -72(%rbp)
	movq	48(%rax), %rax
	movq	%rax, -64(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	flag__Flag_free
	addl	$1, -24(%rbp)
.L1660:
	movq	-120(%rbp), %rax
	movl	196(%rax), %eax
	cmpl	%eax, -24(%rbp)
	jl	.L1661
	movq	-120(%rbp), %rax
	addq	$176, %rax
	movq	%rax, %rdi
	call	array_free
	movq	-120(%rbp), %rax
	addq	$208, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-120(%rbp), %rax
	addq	$224, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-120(%rbp), %rax
	addq	$240, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-120(%rbp), %rax
	addq	$264, %rax
	movq	%rax, %rdi
	call	string_free
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC153:
	.string	"--"
.LC154:
	.string	"display this help and exit"
.LC155:
	.string	"output version information and exit"
	.text
	.globl	flag__new_flag_parser
flag__new_flag_parser:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$504, %rsp
	leaq	-80(%rbp), %rax
	movl	$0, %edx
	leaq	16(%rbp), %rsi
	movq	%rax, %rdi
	call	array_clone_to_depth
	leaq	.LC153(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	call	Array_string_index
	addq	$32, %rsp
	movl	%eax, -36(%rbp)
	leaq	-112(%rbp), %rax
	movl	$0, %edx
	leaq	16(%rbp), %rsi
	movq	%rax, %rdi
	call	array_clone_to_depth
	leaq	-144(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	cmpl	$0, -36(%rbp)
	js	.L1663
	movl	-36(%rbp), %edx
	leaq	-112(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	array_trim
	movl	-60(%rbp), %eax
	cmpl	%eax, -36(%rbp)
	jge	.L1663
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, -496(%rbp)
	movq	%rdx, -488(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -480(%rbp)
	movq	%rdx, -472(%rbp)
	movl	-476(%rbp), %esi
	movl	-36(%rbp), %eax
	leal	1(%rax), %r8d
	leaq	-528(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-496(%rbp), %rax
	movq	-488(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-480(%rbp), %rax
	movq	-472(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%esi, %edx
	movl	%r8d, %esi
	call	array_slice
	addq	$32, %rsp
	movq	-528(%rbp), %rax
	movq	-520(%rbp), %rdx
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	movq	-512(%rbp), %rax
	movq	-504(%rbp), %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
.L1663:
	leaq	-464(%rbp), %rdx
	movl	$0, %eax
	movl	$40, %ecx
	movq	%rdx, %rdi
	rep stosq
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, -464(%rbp)
	movq	%rdx, -456(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -448(%rbp)
	movq	%rdx, -440(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -432(%rbp)
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, -424(%rbp)
	movq	%rdx, -416(%rbp)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, -408(%rbp)
	movq	%rdx, -400(%rbp)
	leaq	-392(%rbp), %rax
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array
	leaq	.LC154(%rip), %rax
	movq	%rax, -360(%rbp)
	movl	$26, -352(%rbp)
	movl	$1, -348(%rbp)
	leaq	.LC155(%rip), %rax
	movq	%rax, -344(%rbp)
	movl	$35, -336(%rbp)
	movl	$1, -332(%rbp)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -328(%rbp)
	movq	%rdx, -320(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, -312(%rbp)
	movq	%rdx, -304(%rbp)
	movl	$4048, -296(%rbp)
	leaq	-288(%rbp), %rax
	movl	$56, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -256(%rbp)
	movl	$1, -244(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -240(%rbp)
	movl	$1, -228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -224(%rbp)
	movl	$1, -212(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -200(%rbp)
	movl	$1, -188(%rbp)
	leaq	-176(%rbp), %rax
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array
	leaq	-464(%rbp), %rax
	movl	$320, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	flag__FlagParser_application
flag__FlagParser_application:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 208(%rcx)
	movq	%rdx, 216(%rcx)
	nop
	popq	%rbp
	ret
	.globl	flag__FlagParser_version
flag__FlagParser_version:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 224(%rcx)
	movq	%rdx, 232(%rcx)
	nop
	popq	%rbp
	ret
	.globl	flag__FlagParser_skip_executable
flag__FlagParser_skip_executable:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	addq	$136, %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	array_delete
	nop
	leave
	ret
	.globl	flag__FlagParser_allow_unknown_args
flag__FlagParser_allow_unknown_args:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movb	$1, 280(%rax)
	nop
	popq	%rbp
	ret
	.globl	flag__FlagParser_add_flag
	.hidden	flag__FlagParser_add_flag
flag__FlagParser_add_flag:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$176, %rsp
	movq	%rdi, -136(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	movl	%ecx, %eax
	movq	%r8, -176(%rbp)
	movq	%r9, -168(%rbp)
	movb	%al, -140(%rbp)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movzbl	-140(%rbp), %eax
	movb	%al, -112(%rbp)
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, -104(%rbp)
	movq	%rdx, -96(%rbp)
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -88(%rbp)
	movq	%rdx, -80(%rbp)
	movq	-136(%rbp), %rax
	leaq	176(%rax), %rdx
	leaq	-128(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	nop
	leave
	ret
	.section	.rodata, "a"
.LC156:
	.string	"="
	.text
	.globl	flag__FlagParser_parse_value
	.hidden	flag__FlagParser_parse_value
flag__FlagParser_parse_value:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$504, %rsp
	movq	%rdi, -472(%rbp)
	movq	%rsi, -480(%rbp)
	movq	%rdx, -496(%rbp)
	movq	%rcx, -488(%rbp)
	movl	%r8d, %eax
	movb	%al, -500(%rbp)
	movb	$0, -61(%rbp)
	movb	$0, -62(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -160(%rbp)
	movaps	%xmm0, -144(%rbp)
	leaq	.LC153(%rip), %rax
	movq	%rax, -208(%rbp)
	movl	$2, -200(%rbp)
	movl	$1, -196(%rbp)
	movl	$65040, -192(%rbp)
	movq	-496(%rbp), %rax
	movq	-488(%rbp), %rdx
	movq	%rax, -184(%rbp)
	movq	%rdx, -176(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -168(%rbp)
	movl	$1, -156(%rbp)
	leaq	-208(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movb	$1, -61(%rbp)
	leaq	-240(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	-544(%rbp), %rax
	movl	$0, %r8d
	movl	$4, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-544(%rbp), %rax
	movq	-536(%rbp), %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	-528(%rbp), %rax
	movq	-520(%rbp), %rdx
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movb	$1, -62(%rbp)
	movb	$0, -49(%rbp)
	movl	$0, -56(%rbp)
	jmp	.L1671
.L1690:
	movq	-480(%rbp), %rax
	movq	144(%rax), %rax
	movl	-56(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	cmpb	$0, -49(%rbp)
	je	.L1672
	movb	$0, -49(%rbp)
	jmp	.L1689
.L1672:
	movl	-280(%rbp), %eax
	testl	%eax, %eax
	je	.L1696
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	$45, %al
	jne	.L1696
	movl	-280(%rbp), %eax
	cmpl	$2, %eax
	jne	.L1676
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	$45, %al
	jne	.L1676
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	%al, -500(%rbp)
	je	.L1677
.L1676:
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	-288(%rbp), %rdi
	movq	-280(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__eq
	testb	%al, %al
	je	.L1678
.L1677:
	movl	-56(%rbp), %eax
	leal	1(%rax), %edx
	movq	-480(%rbp), %rax
	movl	156(%rax), %eax
	cmpl	%eax, %edx
	jl	.L1679
	leaq	-464(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	cmpb	$0, -62(%rbp)
	je	.L1680
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
.L1680:
	cmpb	$0, -61(%rbp)
	je	.L1681
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1681:
	movq	-472(%rbp), %rcx
	movq	-464(%rbp), %rax
	movq	-456(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-448(%rbp), %rax
	movq	-440(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	jmp	.L1687
.L1679:
	movl	-56(%rbp), %eax
	leal	1(%rax), %edi
	movq	-480(%rbp), %rcx
	subq	$32, %rsp
	movq	%rsp, %rsi
	movq	136(%rcx), %rax
	movq	144(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	152(%rcx), %rax
	movq	160(%rcx), %rdx
	movq	%rax, 16(%rsi)
	movq	%rdx, 24(%rsi)
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -304(%rbp)
	movq	%rdx, -296(%rbp)
	movl	-296(%rbp), %eax
	cmpl	$2, %eax
	jle	.L1683
	movq	-304(%rbp), %rsi
	movq	-296(%rbp), %rax
	movl	$2, %ecx
	movl	$0, %edx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, -352(%rbp)
	movq	%rdx, -344(%rbp)
	leaq	.LC153(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-352(%rbp), %rsi
	movq	-344(%rbp), %rax
	movq	%r12, %rdx
	movq	%r13, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L1684
	leaq	-352(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	leaq	-464(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	cmpb	$0, -62(%rbp)
	je	.L1685
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
.L1685:
	cmpb	$0, -61(%rbp)
	je	.L1686
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1686:
	movq	-472(%rbp), %rcx
	movq	-464(%rbp), %rax
	movq	-456(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-448(%rbp), %rax
	movq	-440(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	jmp	.L1687
.L1684:
	leaq	-352(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1683:
	movl	-56(%rbp), %eax
	leal	1(%rax), %edi
	movq	-480(%rbp), %rcx
	subq	$32, %rsp
	movq	%rsp, %rsi
	movq	136(%rcx), %rax
	movq	144(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	152(%rcx), %rax
	movq	160(%rcx), %rdx
	movq	%rax, 16(%rsi)
	movq	%rdx, 24(%rsi)
	call	array_get
	addq	$32, %rsp
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	leaq	-320(%rbp), %rdx
	leaq	-240(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movl	-56(%rbp), %eax
	movl	%eax, -324(%rbp)
	leaq	-324(%rbp), %rdx
	leaq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movl	-56(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -328(%rbp)
	leaq	-328(%rbp), %rdx
	leaq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movb	$1, -49(%rbp)
	jmp	.L1689
.L1678:
	movl	-280(%rbp), %edx
	movl	-88(%rbp), %eax
	addl	$1, %eax
	cmpl	%eax, %edx
	jle	.L1689
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -464(%rbp)
	movaps	%xmm0, -448(%rbp)
	movaps	%xmm0, -432(%rbp)
	movaps	%xmm0, -416(%rbp)
	movaps	%xmm0, -400(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -464(%rbp)
	movl	$1, -452(%rbp)
	movl	$65040, -448(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, -440(%rbp)
	movq	%rdx, -432(%rbp)
	leaq	.LC156(%rip), %rax
	movq	%rax, -424(%rbp)
	movl	$1, -416(%rbp)
	movl	$1, -412(%rbp)
	leaq	-464(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %r14
	movq	%rdx, %r15
	movl	-88(%rbp), %eax
	leal	1(%rax), %edx
	movq	-288(%rbp), %rsi
	movq	-280(%rbp), %rax
	movl	%edx, %ecx
	movl	$0, %edx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %rax
	movq	%r14, %rdx
	movq	%r15, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L1689
	movl	-280(%rbp), %edx
	movl	-88(%rbp), %eax
	leal	1(%rax), %edi
	movq	-288(%rbp), %rsi
	movq	-280(%rbp), %rax
	movl	%edx, %ecx
	movl	%edi, %edx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -368(%rbp)
	movq	%rdx, -360(%rbp)
	leaq	-368(%rbp), %rdx
	leaq	-240(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movl	-56(%rbp), %eax
	movl	%eax, -372(%rbp)
	leaq	-372(%rbp), %rdx
	leaq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	nop
	jmp	.L1689
.L1696:
	nop
.L1689:
	addl	$1, -56(%rbp)
.L1671:
	movq	-480(%rbp), %rax
	movl	156(%rax), %eax
	cmpl	%eax, -56(%rbp)
	jl	.L1690
	movl	$0, -60(%rbp)
	jmp	.L1691
.L1692:
	movq	-120(%rbp), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	subl	-60(%rbp), %eax
	movq	-480(%rbp), %rdx
	addq	$136, %rdx
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	array_delete
	addl	$1, -60(%rbp)
.L1691:
	movl	-108(%rbp), %eax
	cmpl	%eax, -60(%rbp)
	jl	.L1692
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, -272(%rbp)
	movq	%rdx, -264(%rbp)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, -256(%rbp)
	movq	%rdx, -248(%rbp)
	cmpb	$0, -62(%rbp)
	je	.L1693
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	array_free
.L1693:
	cmpb	$0, -61(%rbp)
	je	.L1694
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
.L1694:
	movq	-472(%rbp), %rcx
	movq	-272(%rbp), %rax
	movq	-264(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
.L1687:
	movq	-472(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC157:
	.string	"parameter '"
.LC158:
	.string	"' not found"
	.text
	.globl	flag__FlagParser_parse_bool_value
	.hidden	flag__FlagParser_parse_bool_value
flag__FlagParser_parse_bool_value:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$648, %rsp
	movq	%rdi, -616(%rbp)
	movq	%rsi, -624(%rbp)
	movq	%rdx, -640(%rbp)
	movq	%rcx, -632(%rbp)
	movl	%r8d, %eax
	movb	%al, -644(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -544(%rbp)
	movaps	%xmm0, -528(%rbp)
	movaps	%xmm0, -512(%rbp)
	movaps	%xmm0, -496(%rbp)
	movaps	%xmm0, -480(%rbp)
	leaq	.LC153(%rip), %rax
	movq	%rax, -544(%rbp)
	movl	$2, -536(%rbp)
	movl	$1, -532(%rbp)
	movl	$65040, -528(%rbp)
	movq	-640(%rbp), %rax
	movq	-632(%rbp), %rdx
	movq	%rax, -520(%rbp)
	movq	%rdx, -512(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -504(%rbp)
	movl	$1, -492(%rbp)
	leaq	-544(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -256(%rbp)
	movq	%rdx, -248(%rbp)
	movl	$0, -52(%rbp)
	jmp	.L1698
.L1713:
	movq	-624(%rbp), %rax
	movq	144(%rax), %rax
	movl	-52(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -272(%rbp)
	movq	%rdx, -264(%rbp)
	movl	-264(%rbp), %eax
	testl	%eax, %eax
	je	.L1715
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	$45, %al
	jne	.L1716
	movl	-264(%rbp), %eax
	cmpl	$2, %eax
	jne	.L1702
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	$45, %al
	jne	.L1702
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	%al, -644(%rbp)
	je	.L1703
.L1702:
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	-272(%rbp), %rdi
	movq	-264(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__eq
	testb	%al, %al
	je	.L1704
.L1703:
	movq	-624(%rbp), %rax
	movl	156(%rax), %edx
	movl	-52(%rbp), %eax
	addl	$1, %eax
	cmpl	%eax, %edx
	jle	.L1705
	leaq	.LC91(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movl	-52(%rbp), %eax
	leal	1(%rax), %edi
	movq	-624(%rbp), %rcx
	subq	$32, %rsp
	movq	%rsp, %rsi
	movq	136(%rcx), %rax
	movq	144(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	152(%rcx), %rax
	movq	160(%rcx), %rdx
	movq	%rax, 16(%rsi)
	movq	%rdx, 24(%rsi)
	call	array_get
	addq	$32, %rsp
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movq	%r12, %rdx
	movq	%r13, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L1706
	leaq	.LC92(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movl	-52(%rbp), %eax
	leal	1(%rax), %edi
	movq	-624(%rbp), %rcx
	subq	$32, %rsp
	movq	%rsp, %rsi
	movq	136(%rcx), %rax
	movq	144(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	152(%rcx), %rax
	movq	160(%rcx), %rdx
	movq	%rax, 16(%rsi)
	movq	%rdx, 24(%rsi)
	call	array_get
	addq	$32, %rsp
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movq	%r14, %rdx
	movq	%r15, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L1705
.L1706:
	movl	-52(%rbp), %eax
	leal	1(%rax), %edi
	movq	-624(%rbp), %rcx
	subq	$32, %rsp
	movq	%rsp, %rsi
	movq	136(%rcx), %rax
	movq	144(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	152(%rcx), %rax
	movq	160(%rcx), %rdx
	movq	%rax, 16(%rsi)
	movq	%rdx, 24(%rsi)
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	movl	-52(%rbp), %eax
	leal	1(%rax), %edx
	movq	-624(%rbp), %rax
	addq	$136, %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	array_delete
	movq	-624(%rbp), %rax
	leaq	136(%rax), %rdx
	movl	-52(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	array_delete
	movq	-288(%rbp), %rax
	movq	-280(%rbp), %rdx
	movq	%rax, -304(%rbp)
	movq	%rdx, -296(%rbp)
	leaq	-464(%rbp), %rcx
	leaq	-304(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-616(%rbp), %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-416(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1712
.L1705:
	movq	-624(%rbp), %rax
	leaq	136(%rax), %rdx
	movl	-52(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	array_delete
	leaq	.LC91(%rip), %rax
	movq	%rax, -320(%rbp)
	movl	$4, -312(%rbp)
	movl	$1, -308(%rbp)
	leaq	-464(%rbp), %rcx
	leaq	-320(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-616(%rbp), %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-416(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1712
.L1704:
	movl	-264(%rbp), %edx
	movl	-248(%rbp), %eax
	addl	$1, %eax
	cmpl	%eax, %edx
	jle	.L1709
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -464(%rbp)
	movaps	%xmm0, -448(%rbp)
	movaps	%xmm0, -432(%rbp)
	movaps	%xmm0, -416(%rbp)
	movaps	%xmm0, -400(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -464(%rbp)
	movl	$1, -452(%rbp)
	movl	$65040, -448(%rbp)
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rax, -440(%rbp)
	movq	%rdx, -432(%rbp)
	leaq	.LC156(%rip), %rax
	movq	%rax, -424(%rbp)
	movl	$1, -416(%rbp)
	movl	$1, -412(%rbp)
	leaq	-464(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -688(%rbp)
	movq	%rdx, -680(%rbp)
	movl	-248(%rbp), %eax
	leal	1(%rax), %edx
	movq	-272(%rbp), %rsi
	movq	-264(%rbp), %rax
	movl	%edx, %ecx
	movl	$0, %edx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %rax
	movq	-688(%rbp), %rdx
	movq	-680(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L1709
	movl	-264(%rbp), %edx
	movl	-248(%rbp), %eax
	leal	1(%rax), %edi
	movq	-272(%rbp), %rsi
	movq	-264(%rbp), %rax
	movl	%edx, %ecx
	movl	%edi, %edx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	movq	-624(%rbp), %rax
	leaq	136(%rax), %rdx
	movl	-52(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	array_delete
	movq	-336(%rbp), %rax
	movq	-328(%rbp), %rdx
	movq	%rax, -352(%rbp)
	movq	%rdx, -344(%rbp)
	leaq	-608(%rbp), %rcx
	leaq	-352(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-616(%rbp), %rax
	movq	-608(%rbp), %rcx
	movq	-600(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-592(%rbp), %rcx
	movq	-584(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-576(%rbp), %rcx
	movq	-568(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-560(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1712
.L1709:
	movl	-264(%rbp), %eax
	cmpl	$1, %eax
	jle	.L1711
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	$45, %al
	jne	.L1711
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	$45, %al
	je	.L1711
	movzbl	-644(%rbp), %edx
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_index_u8
	cmpl	$-1, %eax
	je	.L1711
	leaq	.LC34(%rip), %rax
	movq	%rax, -672(%rbp)
	movq	-664(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, -664(%rbp)
	movq	-664(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -664(%rbp)
	movzbl	-644(%rbp), %eax
	movl	%eax, %edi
	call	u8_ascii_str
	movq	-272(%rbp), %rdi
	movq	-264(%rbp), %rsi
	movq	-672(%rbp), %r8
	movq	-664(%rbp), %r9
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_replace
	movq	%rax, -368(%rbp)
	movq	%rdx, -360(%rbp)
	movq	-624(%rbp), %rax
	leaq	136(%rax), %rcx
	leaq	-368(%rbp), %rdx
	movl	-52(%rbp), %eax
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	array_set
	leaq	.LC91(%rip), %rax
	movq	%rax, -384(%rbp)
	movl	$4, -376(%rbp)
	movl	$1, -372(%rbp)
	leaq	-464(%rbp), %rcx
	leaq	-384(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-616(%rbp), %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-416(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1712
.L1715:
	nop
	jmp	.L1711
.L1716:
	nop
.L1711:
	addl	$1, -52(%rbp)
.L1698:
	movq	-624(%rbp), %rax
	movl	156(%rax), %eax
	cmpl	%eax, -52(%rbp)
	jl	.L1713
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -160(%rbp)
	movaps	%xmm0, -144(%rbp)
	movaps	%xmm0, -128(%rbp)
	movaps	%xmm0, -112(%rbp)
	leaq	.LC157(%rip), %rax
	movq	%rax, -176(%rbp)
	movl	$11, -168(%rbp)
	movl	$1, -164(%rbp)
	movl	$65040, -160(%rbp)
	movq	-640(%rbp), %rax
	movq	-632(%rbp), %rdx
	movq	%rax, -152(%rbp)
	movq	%rdx, -144(%rbp)
	leaq	.LC158(%rip), %rax
	movq	%rax, -136(%rbp)
	movl	$11, -128(%rbp)
	movl	$1, -124(%rbp)
	leaq	-176(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	leaq	-96(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-616(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	%xmm0, 48(%rax)
	movq	-616(%rbp), %rax
	movb	$1, (%rax)
	movq	-616(%rbp), %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
.L1712:
	movq	-616(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC159:
	.string	"<bool>"
.LC160:
	.string	"' not provided"
	.text
	.globl	flag__FlagParser_bool_opt
flag__FlagParser_bool_opt:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$360, %rsp
	movq	%rdi, -344(%rbp)
	movq	%rsi, -352(%rbp)
	movq	%rdx, -368(%rbp)
	movq	%rcx, -360(%rbp)
	movl	%r8d, %eax
	movb	%al, -372(%rbp)
	movb	$0, -33(%rbp)
	leaq	.LC159(%rip), %r10
	movq	%r11, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, %r11
	movq	%r11, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r11
	movzbl	-372(%rbp), %ecx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	-368(%rbp), %rsi
	movq	-360(%rbp), %rbx
	movq	-352(%rbp), %rdi
	pushq	%r11
	pushq	%r10
	movq	%rax, %r8
	movq	%rdx, %r9
	movq	%rbx, %rdx
	call	flag__FlagParser_add_flag
	addq	$16, %rsp
	movzbl	-372(%rbp), %ecx
	leaq	-304(%rbp), %rdi
	movq	-368(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	-352(%rbp), %rsi
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	flag__FlagParser_parse_bool_value
	movzbl	-304(%rbp), %eax
	testb	%al, %al
	je	.L1718
	movq	-296(%rbp), %rax
	movq	-288(%rbp), %rdx
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	movq	-280(%rbp), %rax
	movq	-272(%rbp), %rdx
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -240(%rbp)
	movaps	%xmm0, -224(%rbp)
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	leaq	.LC157(%rip), %rax
	movq	%rax, -240(%rbp)
	movl	$11, -232(%rbp)
	movl	$1, -228(%rbp)
	movl	$65040, -224(%rbp)
	movq	-368(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rax, -216(%rbp)
	movq	%rdx, -208(%rbp)
	leaq	.LC160(%rip), %rax
	movq	%rax, -200(%rbp)
	movl	$14, -192(%rbp)
	movl	$1, -188(%rbp)
	leaq	-240(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	leaq	-80(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-344(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-344(%rbp), %rax
	movb	$1, (%rax)
	movq	-344(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1717
.L1718:
	leaq	-304(%rbp), %rax
	addq	$40, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	leaq	.LC91(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-160(%rbp), %rsi
	movq	-152(%rbp), %rax
	movq	%r12, %rdx
	movq	%r13, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	movb	%al, -33(%rbp)
	movzbl	-33(%rbp), %eax
	movb	%al, -129(%rbp)
	leaq	-128(%rbp), %rcx
	leaq	-129(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-344(%rbp), %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L1717:
	movq	-344(%rbp), %rax
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	flag__FlagParser_bool
flag__FlagParser_bool:
	pushq	%rbp
	movq	%rsp, %rbp
	addq	$-128, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movl	%ecx, %eax
	movl	%r8d, %edx
	movb	%al, -108(%rbp)
	movl	%edx, %eax
	movb	%al, -112(%rbp)
	movzbl	-108(%rbp), %ecx
	leaq	-64(%rbp), %rdi
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	-104(%rbp), %rsi
	pushq	24(%rbp)
	pushq	16(%rbp)
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	flag__FlagParser_bool_opt
	addq	$16, %rsp
	movzbl	-64(%rbp), %eax
	testb	%al, %al
	je	.L1722
	movq	-56(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-40(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movzbl	-112(%rbp), %eax
	jmp	.L1724
.L1722:
	movzbl	-24(%rbp), %eax
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
.L1724:
	leave
	ret
	.section	.rodata, "a"
.LC161:
	.string	"<string>"
	.text
	.globl	flag__FlagParser_string_opt
flag__FlagParser_string_opt:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$296, %rsp
	movq	%rdi, -264(%rbp)
	movq	%rsi, -272(%rbp)
	movq	%rdx, -288(%rbp)
	movq	%rcx, -280(%rbp)
	movl	%r8d, %eax
	movb	%al, -292(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$0, -56(%rbp)
	movl	$1, -52(%rbp)
	leaq	.LC161(%rip), %r10
	movq	%r11, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$8, %rax
	movq	%rax, %r11
	movq	%r11, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r11
	movzbl	-292(%rbp), %ecx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	-288(%rbp), %rsi
	movq	-280(%rbp), %rbx
	movq	-272(%rbp), %rdi
	pushq	%r11
	pushq	%r10
	movq	%rax, %r8
	movq	%rdx, %r9
	movq	%rbx, %rdx
	call	flag__FlagParser_add_flag
	addq	$16, %rsp
	movzbl	-292(%rbp), %ecx
	leaq	-256(%rbp), %rdi
	movq	-288(%rbp), %rax
	movq	-280(%rbp), %rdx
	movq	-272(%rbp), %rsi
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	flag__FlagParser_parse_value
	movl	-236(%rbp), %eax
	testl	%eax, %eax
	jne	.L1726
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -224(%rbp)
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -160(%rbp)
	leaq	.LC157(%rip), %rax
	movq	%rax, -224(%rbp)
	movl	$11, -216(%rbp)
	movl	$1, -212(%rbp)
	movl	$65040, -208(%rbp)
	movq	-288(%rbp), %rax
	movq	-280(%rbp), %rdx
	movq	%rax, -200(%rbp)
	movq	%rdx, -192(%rbp)
	leaq	.LC160(%rip), %rax
	movq	%rax, -184(%rbp)
	movl	$14, -176(%rbp)
	movl	$1, -172(%rbp)
	leaq	-224(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	leaq	-48(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-264(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	%xmm0, 48(%rax)
	movq	-264(%rbp), %rax
	movb	$1, (%rax)
	movq	-264(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1727
.L1726:
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	leaq	-128(%rbp), %rcx
	leaq	-144(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-264(%rbp), %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-80(%rbp), %rdx
	movq	%rdx, 48(%rax)
.L1727:
	movq	-264(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	flag__FlagParser_string
flag__FlagParser_string:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$160, %rsp
	movq	%rdi, -120(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	movl	%ecx, %eax
	movq	%r8, -160(%rbp)
	movq	%r9, -152(%rbp)
	movb	%al, -124(%rbp)
	movzbl	-124(%rbp), %ecx
	leaq	-64(%rbp), %rdi
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	-120(%rbp), %rsi
	pushq	24(%rbp)
	pushq	16(%rbp)
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	flag__FlagParser_string_opt
	addq	$16, %rsp
	movzbl	-64(%rbp), %eax
	testb	%al, %al
	je	.L1730
	movq	-56(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movq	-40(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	jmp	.L1732
.L1730:
	leaq	-64(%rbp), %rax
	addq	$40, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
.L1732:
	leave
	ret
	.section	.rodata, "a"
.LC162:
	.string	"[ARGS]"
.LC163:
	.string	" "
.LC164:
	.string	"Usage: "
.LC165:
	.string	" [options] "
.LC166:
	.string	"   or: "
.LC167:
	.string	"Description: "
.LC168:
	.string	"This application does not expect any arguments"
.LC169:
	.string	"at least "
.LC170:
	.string	"at most "
.LC171:
	.string	"exactly "
.LC172:
	.string	" and "
.LC173:
	.string	"The arguments should be "
.LC174:
	.string	" in number."
.LC175:
	.string	"Options:"
.LC176:
	.string	"  "
.LC177:
	.string	"   "
.LC178:
	.string	"- ,"
	.text
	.globl	flag__FlagParser_usage
flag__FlagParser_usage:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$1016, %rsp
	movq	%rdi, -840(%rbp)
	movq	-840(%rbp), %rax
	movl	256(%rax), %eax
	testl	%eax, %eax
	setg	%al
	movb	%al, -61(%rbp)
	movq	-840(%rbp), %rax
	movl	168(%rax), %eax
	testl	%eax, %eax
	jle	.L1734
	movq	-840(%rbp), %rax
	movl	168(%rax), %eax
	cmpl	$4048, %eax
	je	.L1734
	movl	$1, %eax
	jmp	.L1735
.L1734:
	movl	$0, %eax
.L1735:
	movb	%al, -62(%rbp)
	movq	-840(%rbp), %rax
	movl	256(%rax), %eax
	testl	%eax, %eax
	jne	.L1736
	movq	-840(%rbp), %rax
	movl	168(%rax), %eax
	testl	%eax, %eax
	jne	.L1736
	movl	$1, %eax
	jmp	.L1737
.L1736:
	movl	$0, %eax
.L1737:
	movb	%al, -63(%rbp)
	movq	-840(%rbp), %rax
	movl	272(%rax), %eax
	testl	%eax, %eax
	jle	.L1738
	movq	-840(%rbp), %rax
	movq	272(%rax), %rdx
	movq	264(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	jmp	.L1739
.L1738:
	leaq	.LC162(%rip), %rax
	movq	%rax, -80(%rbp)
	movl	$6, -72(%rbp)
	movl	$1, -68(%rbp)
.L1739:
	cmpb	$0, -63(%rbp)
	je	.L1740
	leaq	.LC34(%rip), %rax
	movq	%rax, -80(%rbp)
	movl	$0, -72(%rbp)
	movl	$1, -68(%rbp)
.L1740:
	leaq	-112(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-840(%rbp), %rax
	movl	232(%rax), %eax
	testl	%eax, %eax
	je	.L1741
	leaq	-720(%rbp), %rsi
	movl	$0, %eax
	movl	$15, %edx
	movq	%rsi, %rdi
	movq	%rdx, %rcx
	rep stosq
	leaq	.LC34(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	-840(%rbp), %rax
	movq	216(%rax), %rdx
	movq	208(%rax), %rax
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC163(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -672(%rbp)
	movl	$1, -668(%rbp)
	movl	$65040, -664(%rbp)
	movq	-840(%rbp), %rax
	movq	232(%rax), %rdx
	movq	224(%rax), %rax
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -640(%rbp)
	movl	$1, -628(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	leaq	-160(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -800(%rbp)
	movaps	%xmm0, -784(%rbp)
	movaps	%xmm0, -768(%rbp)
	movaps	%xmm0, -752(%rbp)
	movaps	%xmm0, -736(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -800(%rbp)
	movl	$1, -788(%rbp)
	movl	$65040, -784(%rbp)
	movq	_const_flag__underline(%rip), %rax
	movq	8+_const_flag__underline(%rip), %rdx
	movq	%rax, -776(%rbp)
	movq	%rdx, -768(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -760(%rbp)
	movl	$1, -748(%rbp)
	leaq	-800(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -176(%rbp)
	movq	%rdx, -168(%rbp)
	leaq	-176(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
.L1741:
	movq	-840(%rbp), %rax
	movl	92(%rax), %eax
	testl	%eax, %eax
	jne	.L1742
	leaq	-720(%rbp), %rsi
	movl	$0, %eax
	movl	$15, %edx
	movq	%rsi, %rdi
	movq	%rdx, %rcx
	rep stosq
	leaq	.LC164(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$7, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	-840(%rbp), %rax
	movq	216(%rax), %rdx
	movq	208(%rax), %rax
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC165(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$11, -672(%rbp)
	movl	$1, -668(%rbp)
	movl	$65040, -664(%rbp)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -640(%rbp)
	movl	$1, -628(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -192(%rbp)
	movq	%rdx, -184(%rbp)
	leaq	-192(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1743
.L1742:
	movl	$0, -52(%rbp)
	jmp	.L1744
.L1747:
	movq	-840(%rbp), %rax
	movq	80(%rax), %rdx
	movl	-52(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
	cmpl	$0, -52(%rbp)
	jne	.L1745
	leaq	-720(%rbp), %rsi
	movl	$0, %eax
	movl	$15, %edx
	movq	%rsi, %rdi
	movq	%rdx, %rcx
	rep stosq
	leaq	.LC164(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$7, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	-840(%rbp), %rax
	movq	216(%rax), %rdx
	movq	208(%rax), %rax
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC163(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -672(%rbp)
	movl	$1, -668(%rbp)
	movl	$65040, -664(%rbp)
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -640(%rbp)
	movl	$1, -628(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -224(%rbp)
	movq	%rdx, -216(%rbp)
	leaq	-224(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1746
.L1745:
	leaq	-720(%rbp), %rsi
	movl	$0, %eax
	movl	$15, %edx
	movq	%rsi, %rdi
	movq	%rdx, %rcx
	rep stosq
	leaq	.LC166(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$7, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	-840(%rbp), %rax
	movq	216(%rax), %rdx
	movq	208(%rax), %rax
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC163(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -672(%rbp)
	movl	$1, -668(%rbp)
	movl	$65040, -664(%rbp)
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -640(%rbp)
	movl	$1, -628(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -240(%rbp)
	movq	%rdx, -232(%rbp)
	leaq	-240(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
.L1746:
	addl	$1, -52(%rbp)
.L1744:
	movq	-840(%rbp), %rax
	movl	92(%rax), %eax
	cmpl	%eax, -52(%rbp)
	jl	.L1747
.L1743:
	leaq	.LC34(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	leaq	-128(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movq	-840(%rbp), %rax
	movl	248(%rax), %eax
	testl	%eax, %eax
	je	.L1748
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -720(%rbp)
	movaps	%xmm0, -704(%rbp)
	movaps	%xmm0, -688(%rbp)
	movaps	%xmm0, -672(%rbp)
	movaps	%xmm0, -656(%rbp)
	leaq	.LC167(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$13, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	-840(%rbp), %rax
	movq	248(%rax), %rdx
	movq	240(%rax), %rax
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -668(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -256(%rbp)
	movq	%rdx, -248(%rbp)
	leaq	-256(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	leaq	.LC34(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	%r14, %rcx
	movq	%r15, %rbx
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -272(%rbp)
	movq	%rdx, -264(%rbp)
	leaq	-272(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
.L1748:
	cmpb	$0, -61(%rbp)
	jne	.L1749
	cmpb	$0, -62(%rbp)
	jne	.L1749
	cmpb	$0, -63(%rbp)
	je	.L1750
.L1749:
	cmpb	$0, -63(%rbp)
	je	.L1751
	leaq	.LC168(%rip), %rax
	movq	%rax, -944(%rbp)
	movq	-936(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$46, %rax
	movq	%rax, -936(%rbp)
	movq	-936(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -936(%rbp)
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	leaq	-288(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	leaq	.LC34(%rip), %rax
	movq	%rax, -960(%rbp)
	movq	-952(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, -952(%rbp)
	movq	-952(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -952(%rbp)
	movq	-960(%rbp), %rax
	movq	-952(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -304(%rbp)
	movq	%rdx, -296(%rbp)
	leaq	-304(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1750
.L1751:
	leaq	-800(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	cmpb	$0, -61(%rbp)
	je	.L1752
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -720(%rbp)
	movaps	%xmm0, -704(%rbp)
	movaps	%xmm0, -688(%rbp)
	movaps	%xmm0, -672(%rbp)
	movaps	%xmm0, -656(%rbp)
	leaq	.LC169(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$9, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65031, -704(%rbp)
	movq	-840(%rbp), %rax
	movl	256(%rax), %eax
	movl	%eax, -696(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -668(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -368(%rbp)
	movq	%rdx, -360(%rbp)
	leaq	-368(%rbp), %rdx
	leaq	-800(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
.L1752:
	cmpb	$0, -62(%rbp)
	je	.L1753
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -720(%rbp)
	movaps	%xmm0, -704(%rbp)
	movaps	%xmm0, -688(%rbp)
	movaps	%xmm0, -672(%rbp)
	movaps	%xmm0, -656(%rbp)
	leaq	.LC170(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$8, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65031, -704(%rbp)
	movq	-840(%rbp), %rax
	movl	168(%rax), %eax
	movl	%eax, -696(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -668(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -384(%rbp)
	movq	%rdx, -376(%rbp)
	leaq	-384(%rbp), %rdx
	leaq	-800(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
.L1753:
	cmpb	$0, -61(%rbp)
	je	.L1754
	cmpb	$0, -62(%rbp)
	je	.L1754
	movq	-840(%rbp), %rax
	movl	256(%rax), %edx
	movq	-840(%rbp), %rax
	movl	168(%rax), %eax
	cmpl	%eax, %edx
	jne	.L1754
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -720(%rbp)
	movaps	%xmm0, -704(%rbp)
	movaps	%xmm0, -688(%rbp)
	movaps	%xmm0, -672(%rbp)
	movaps	%xmm0, -656(%rbp)
	leaq	.LC171(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$8, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65031, -704(%rbp)
	movq	-840(%rbp), %rax
	movl	256(%rax), %eax
	movl	%eax, -696(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -668(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -400(%rbp)
	movq	%rdx, -392(%rbp)
	leaq	-880(%rbp), %rdi
	leaq	-400(%rbp), %rax
	movq	%rax, %r8
	movl	$16, %ecx
	movl	$1, %edx
	movl	$1, %esi
	call	new_array_from_c_array
	movq	-880(%rbp), %rax
	movq	-872(%rbp), %rdx
	movq	%rax, -800(%rbp)
	movq	%rdx, -792(%rbp)
	movq	-864(%rbp), %rax
	movq	-856(%rbp), %rdx
	movq	%rax, -784(%rbp)
	movq	%rdx, -776(%rbp)
.L1754:
	leaq	.LC172(%rip), %rax
	movq	%rax, -976(%rbp)
	movq	-968(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -968(%rbp)
	movq	-968(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -968(%rbp)
	movq	-976(%rbp), %rax
	movq	-968(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-800(%rbp), %rax
	movq	-792(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-784(%rbp), %rax
	movq	-776(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	call	Array_string_join
	addq	$32, %rsp
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -720(%rbp)
	movaps	%xmm0, -704(%rbp)
	movaps	%xmm0, -688(%rbp)
	movaps	%xmm0, -672(%rbp)
	movaps	%xmm0, -656(%rbp)
	leaq	.LC173(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$24, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	-320(%rbp), %rax
	movq	-312(%rbp), %rdx
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC174(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$11, -672(%rbp)
	movl	$1, -668(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	leaq	-336(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	leaq	.LC34(%rip), %rax
	movq	%rax, -992(%rbp)
	movq	-984(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, -984(%rbp)
	movq	-984(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -984(%rbp)
	movq	-992(%rbp), %rax
	movq	-984(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -352(%rbp)
	movq	%rdx, -344(%rbp)
	leaq	-352(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
.L1750:
	movq	-840(%rbp), %rax
	movl	196(%rax), %eax
	testl	%eax, %eax
	jle	.L1755
	leaq	.LC175(%rip), %rax
	movq	%rax, -1008(%rbp)
	movq	-1000(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$8, %rax
	movq	%rax, -1000(%rbp)
	movq	-1000(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -1000(%rbp)
	movq	-1008(%rbp), %rax
	movq	-1000(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -416(%rbp)
	movq	%rdx, -408(%rbp)
	leaq	-416(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movl	$0, -56(%rbp)
	jmp	.L1756
.L1763:
	movq	-840(%rbp), %rax
	movq	184(%rax), %rcx
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rax, %rcx
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, -800(%rbp)
	movq	%rdx, -792(%rbp)
	movq	16(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	%rax, -784(%rbp)
	movq	%rdx, -776(%rbp)
	movq	32(%rcx), %rax
	movq	40(%rcx), %rdx
	movq	%rax, -768(%rbp)
	movq	%rdx, -760(%rbp)
	movq	48(%rcx), %rax
	movq	%rax, -752(%rbp)
	leaq	-832(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movzbl	-784(%rbp), %eax
	testb	%al, %al
	je	.L1757
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -720(%rbp)
	movaps	%xmm0, -704(%rbp)
	movaps	%xmm0, -688(%rbp)
	movaps	%xmm0, -672(%rbp)
	movaps	%xmm0, -656(%rbp)
	leaq	.LC44(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$1, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movzbl	-784(%rbp), %eax
	movzbl	%al, %eax
	movl	%eax, %edi
	call	u8_ascii_str
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -668(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -496(%rbp)
	movq	%rdx, -488(%rbp)
	leaq	-496(%rbp), %rdx
	leaq	-832(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
.L1757:
	movl	-792(%rbp), %eax
	testl	%eax, %eax
	je	.L1758
	leaq	.LC159(%rip), %rax
	movq	%rax, -1056(%rbp)
	movq	-1048(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -1048(%rbp)
	movq	-1048(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -1048(%rbp)
	movq	-760(%rbp), %rsi
	movq	-752(%rbp), %rax
	movq	-1056(%rbp), %rdx
	movq	-1048(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_contains
	testb	%al, %al
	jne	.L1759
	leaq	-720(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC153(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$2, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	-800(%rbp), %rax
	movq	-792(%rbp), %rdx
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC163(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -672(%rbp)
	movl	$1, -668(%rbp)
	movl	$65040, -664(%rbp)
	movq	-760(%rbp), %rax
	movq	-752(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -640(%rbp)
	movl	$1, -628(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -512(%rbp)
	movq	%rdx, -504(%rbp)
	leaq	-512(%rbp), %rdx
	leaq	-832(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1758
.L1759:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -720(%rbp)
	movaps	%xmm0, -704(%rbp)
	movaps	%xmm0, -688(%rbp)
	movaps	%xmm0, -672(%rbp)
	movaps	%xmm0, -656(%rbp)
	leaq	.LC153(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$2, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	-800(%rbp), %rax
	movq	-792(%rbp), %rdx
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -668(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -528(%rbp)
	movq	%rdx, -520(%rbp)
	leaq	-528(%rbp), %rdx
	leaq	-832(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
.L1758:
	leaq	.LC67(%rip), %rax
	movq	%rax, -1040(%rbp)
	movq	-1032(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -1032(%rbp)
	movq	-1032(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -1032(%rbp)
	movq	-1040(%rbp), %rax
	movq	-1032(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-832(%rbp), %rax
	movq	-824(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-816(%rbp), %rax
	movq	-808(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	call	Array_string_join
	addq	$32, %rsp
	leaq	.LC176(%rip), %rbx
	movq	%rbx, -1024(%rbp)
	movq	-1016(%rbp), %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$2, %rcx
	movq	%rcx, -1016(%rbp)
	movq	-1016(%rbp), %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, -1016(%rbp)
	movq	-1024(%rbp), %rcx
	movq	-1016(%rbp), %rbx
	movq	%rcx, %rsi
	movq	%rbx, %rdi
	movq	%rsi, %rdi
	movq	%rbx, %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__plus
	movq	%rax, -432(%rbp)
	movq	%rdx, -424(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -448(%rbp)
	movl	$0, -440(%rbp)
	movl	$1, -436(%rbp)
	movl	8+_const_flag__space(%rip), %eax
	leal	-1(%rax), %edx
	movl	-424(%rbp), %eax
	cmpl	%eax, %edx
	jg	.L1761
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -720(%rbp)
	movaps	%xmm0, -704(%rbp)
	movaps	%xmm0, -688(%rbp)
	movaps	%xmm0, -672(%rbp)
	movaps	%xmm0, -656(%rbp)
	leaq	.LC146(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$1, -712(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	_const_flag__space(%rip), %rax
	movq	8+_const_flag__space(%rip), %rdx
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -668(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, -448(%rbp)
	movq	%rdx, -440(%rbp)
	jmp	.L1762
.L1761:
	movl	8+_const_flag__space(%rip), %ecx
	movl	-424(%rbp), %edx
	movq	_const_flag__space(%rip), %rsi
	movq	8+_const_flag__space(%rip), %rax
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, -448(%rbp)
	movq	%rdx, -440(%rbp)
.L1762:
	leaq	-720(%rbp), %rdx
	movl	$0, %eax
	movl	$20, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC34(%rip), %rax
	movq	%rax, -720(%rbp)
	movl	$1, -708(%rbp)
	movl	$65040, -704(%rbp)
	movq	-432(%rbp), %rax
	movq	-424(%rbp), %rdx
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -680(%rbp)
	movl	$1, -668(%rbp)
	movl	$65040, -664(%rbp)
	movq	-448(%rbp), %rax
	movq	-440(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -640(%rbp)
	movl	$1, -628(%rbp)
	movl	$65040, -624(%rbp)
	movq	-776(%rbp), %rax
	movq	-768(%rbp), %rdx
	movq	%rax, -616(%rbp)
	movq	%rdx, -608(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -600(%rbp)
	movl	$1, -588(%rbp)
	leaq	-720(%rbp), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	str_intp
	movq	%rax, -464(%rbp)
	movq	%rdx, -456(%rbp)
	movq	-464(%rbp), %rdx
	movq	-456(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -480(%rbp)
	movq	%rdx, -472(%rbp)
	leaq	-480(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	addl	$1, -56(%rbp)
.L1756:
	movq	-840(%rbp), %rax
	movl	196(%rax), %eax
	cmpl	%eax, -56(%rbp)
	jl	.L1763
.L1755:
	movl	$0, -60(%rbp)
	jmp	.L1764
.L1765:
	movq	-840(%rbp), %rax
	movq	296(%rax), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -544(%rbp)
	movq	%rdx, -536(%rbp)
	movq	-544(%rbp), %rdx
	movq	-536(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -560(%rbp)
	movq	%rdx, -552(%rbp)
	leaq	-560(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	addl	$1, -60(%rbp)
.L1764:
	movq	-840(%rbp), %rax
	movl	308(%rax), %eax
	cmpl	%eax, -60(%rbp)
	jl	.L1765
	leaq	.LC177(%rip), %rax
	movq	%rax, -928(%rbp)
	movq	-920(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -920(%rbp)
	movq	-920(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -920(%rbp)
	leaq	.LC178(%rip), %rax
	movq	%rax, -912(%rbp)
	movq	-904(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -904(%rbp)
	movq	-904(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -904(%rbp)
	leaq	.LC146(%rip), %rax
	movq	%rax, -896(%rbp)
	movq	-888(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, -888(%rbp)
	movq	-888(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -888(%rbp)
	movq	-896(%rbp), %rax
	movq	-888(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	call	Array_string_join
	addq	$32, %rsp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %rax
	movq	-928(%rbp), %r8
	movq	-920(%rbp), %r9
	movq	-912(%rbp), %rdx
	movq	-904(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_replace
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC179:
	.string	"no such flag"
	.text
	.globl	flag__FlagParser_find_existing_flag
	.hidden	flag__FlagParser_find_existing_flag
flag__FlagParser_find_existing_flag:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$408, %rsp
	movq	%rdi, -408(%rbp)
	movq	%rsi, -416(%rbp)
	movq	%rdx, -432(%rbp)
	movq	%rcx, -424(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L1768
.L1771:
	movq	-416(%rbp), %rax
	movq	184(%rax), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -400(%rbp)
	movq	%rbx, -392(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -384(%rbp)
	movq	%rbx, -376(%rbp)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, -368(%rbp)
	movq	%rbx, -360(%rbp)
	movq	48(%rax), %rax
	movq	%rax, -352(%rbp)
	movq	-432(%rbp), %rax
	movq	-424(%rbp), %rdx
	movq	-400(%rbp), %rdi
	movq	-392(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__eq
	testb	%al, %al
	je	.L1769
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	movq	-368(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rax, -304(%rbp)
	movq	%rdx, -296(%rbp)
	movq	-352(%rbp), %rax
	movq	%rax, -288(%rbp)
	leaq	-272(%rbp), %rcx
	leaq	-336(%rbp), %rax
	movl	$56, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-408(%rbp), %rax
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, 64(%rax)
	movq	%rbx, 72(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 80(%rax)
	movq	%rbx, 88(%rax)
	jmp	.L1770
.L1769:
	addl	$1, -36(%rbp)
.L1768:
	movq	-416(%rbp), %rax
	movl	196(%rax), %eax
	cmpl	%eax, -36(%rbp)
	jl	.L1771
	leaq	.LC179(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$12, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-80(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-408(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %eax
	movl	$12, %edx
	movq	%rsi, %rdi
	movq	%rdx, %rcx
	rep stosq
	movq	-408(%rbp), %rax
	movb	$1, (%rax)
	movq	-408(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
.L1770:
	movq	-408(%rbp), %rax
	addq	$408, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC180:
	.string	"help"
.LC181:
	.string	"version"
	.text
	.globl	flag__FlagParser_handle_builtin_options
	.hidden	flag__FlagParser_handle_builtin_options
flag__FlagParser_handle_builtin_options:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$376, %rsp
	movq	%rdi, -392(%rbp)
	movb	$0, -49(%rbp)
	movb	$0, -50(%rbp)
	leaq	.LC180(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$4, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	leaq	-160(%rbp), %rdi
	movq	-392(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	flag__FlagParser_find_existing_flag
	movzbl	-160(%rbp), %eax
	testb	%al, %al
	je	.L1774
	movq	-152(%rbp), %rax
	movq	-144(%rbp), %rdx
	movq	%rax, -384(%rbp)
	movq	%rdx, -376(%rbp)
	movq	-136(%rbp), %rax
	movq	-128(%rbp), %rdx
	movq	%rax, -368(%rbp)
	movq	%rdx, -360(%rbp)
	leaq	.LC180(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	%r14, %rcx
	movq	%r15, %rbx
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rcx, %rsi
	movq	%rdx, %rdi
	movq	-392(%rbp), %rax
	movq	-392(%rbp), %rdx
	pushq	112(%rdx)
	pushq	104(%rdx)
	movl	$0, %r8d
	movl	$104, %ecx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	flag__FlagParser_bool
	addq	$16, %rsp
	movb	%al, -50(%rbp)
.L1774:
	leaq	.LC181(%rip), %rax
	movq	%rax, -416(%rbp)
	movq	-408(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -408(%rbp)
	movq	-408(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -408(%rbp)
	leaq	-256(%rbp), %rax
	movq	-392(%rbp), %rsi
	movq	-416(%rbp), %rdx
	movq	-408(%rbp), %rcx
	movq	%rax, %rdi
	call	flag__FlagParser_find_existing_flag
	movzbl	-256(%rbp), %eax
	testb	%al, %al
	je	.L1775
	movq	-248(%rbp), %rax
	movq	-240(%rbp), %rdx
	movq	%rax, -384(%rbp)
	movq	%rdx, -376(%rbp)
	movq	-232(%rbp), %rax
	movq	-224(%rbp), %rdx
	movq	%rax, -368(%rbp)
	movq	%rdx, -360(%rbp)
	leaq	.LC181(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rcx, %rsi
	movq	%rdx, %rdi
	movq	-392(%rbp), %rax
	movq	-392(%rbp), %rdx
	pushq	128(%rdx)
	pushq	120(%rdx)
	movl	$0, %r8d
	movl	$0, %ecx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	flag__FlagParser_bool
	addq	$16, %rsp
	movb	%al, -49(%rbp)
.L1775:
	cmpb	$0, -50(%rbp)
	je	.L1776
	movq	-392(%rbp), %rax
	movq	%rax, %rdi
	call	flag__FlagParser_usage
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	println
	movl	$0, %edi
	call	_v_exit
.L1776:
	cmpb	$0, -49(%rbp)
	je	.L1778
	leaq	-384(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC34(%rip), %rax
	movq	%rax, -384(%rbp)
	movl	$1, -372(%rbp)
	movl	$65040, -368(%rbp)
	movq	-392(%rbp), %rax
	movq	216(%rax), %rdx
	movq	208(%rax), %rax
	movq	%rax, -360(%rbp)
	movq	%rdx, -352(%rbp)
	leaq	.LC163(%rip), %rax
	movq	%rax, -344(%rbp)
	movl	$1, -336(%rbp)
	movl	$1, -332(%rbp)
	movl	$65040, -328(%rbp)
	movq	-392(%rbp), %rax
	movq	232(%rax), %rdx
	movq	224(%rax), %rax
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -304(%rbp)
	movl	$1, -292(%rbp)
	leaq	-384(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	println
	movl	$0, %edi
	call	_v_exit
.L1778:
	nop
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	flag__FlagParser_finalize
flag__FlagParser_finalize:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$440, %rsp
	movq	%rdi, -456(%rbp)
	movq	%rsi, -464(%rbp)
	movq	-464(%rbp), %rax
	movq	%rax, %rdi
	call	flag__FlagParser_handle_builtin_options
	movq	-464(%rbp), %rax
	leaq	136(%rax), %rcx
	leaq	-208(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_clone_to_depth
	movq	-464(%rbp), %rax
	movzbl	280(%rax), %eax
	testb	%al, %al
	jne	.L1780
	movl	$0, -36(%rbp)
	jmp	.L1781
.L1786:
	movq	-200(%rbp), %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	movl	-328(%rbp), %eax
	cmpl	$1, %eax
	jle	.L1782
	leaq	.LC153(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-336(%rbp), %rsi
	movq	-328(%rbp), %rax
	movl	$2, %ecx
	movl	$0, %edx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %rax
	movq	%r12, %rdx
	movq	%r13, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L1783
.L1782:
	movl	-328(%rbp), %eax
	cmpl	$2, %eax
	jne	.L1784
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	$45, %al
	jne	.L1784
.L1783:
	movq	-336(%rbp), %rax
	movq	-328(%rbp), %rdx
	movq	%rax, -352(%rbp)
	movq	%rdx, -344(%rbp)
	leaq	-352(%rbp), %rax
	movl	$16, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	I_flag__UnknownFlagError_to_Interface_IError
	movq	-456(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movups	%xmm0, 48(%rax)
	movq	%xmm0, 64(%rax)
	movq	-456(%rbp), %rax
	movb	$1, (%rax)
	movq	-456(%rbp), %rcx
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1779
.L1784:
	addl	$1, -36(%rbp)
.L1781:
	movl	-188(%rbp), %eax
	cmpl	%eax, -36(%rbp)
	jl	.L1786
.L1780:
	movl	-188(%rbp), %edx
	movq	-464(%rbp), %rax
	movl	256(%rax), %eax
	cmpl	%eax, %edx
	jge	.L1787
	movq	-464(%rbp), %rax
	movl	256(%rax), %eax
	testl	%eax, %eax
	jle	.L1787
	movl	-188(%rbp), %eax
	movl	%eax, -360(%rbp)
	movq	-464(%rbp), %rax
	movl	256(%rax), %eax
	movl	%eax, -356(%rbp)
	leaq	-360(%rbp), %rax
	movl	$8, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	I_flag__ArgsCountError_to_Interface_IError
	movq	-456(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movups	%xmm0, 48(%rax)
	movq	%xmm0, 64(%rax)
	movq	-456(%rbp), %rax
	movb	$1, (%rax)
	movq	-456(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1779
.L1787:
	movl	-188(%rbp), %edx
	movq	-464(%rbp), %rax
	movl	168(%rax), %eax
	cmpl	%eax, %edx
	jle	.L1788
	movq	-464(%rbp), %rax
	movl	168(%rax), %eax
	testl	%eax, %eax
	jle	.L1788
	movl	-188(%rbp), %eax
	movl	%eax, -368(%rbp)
	movq	-464(%rbp), %rax
	movl	168(%rax), %eax
	movl	%eax, -364(%rbp)
	leaq	-368(%rbp), %rax
	movl	$8, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	I_flag__ArgsCountError_to_Interface_IError
	movq	-456(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movups	%xmm0, 48(%rax)
	movq	%xmm0, 64(%rax)
	movq	-456(%rbp), %rax
	movb	$1, (%rax)
	movq	-456(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1779
.L1788:
	movl	-188(%rbp), %eax
	testl	%eax, %eax
	jle	.L1789
	movq	-464(%rbp), %rax
	movl	168(%rax), %eax
	testl	%eax, %eax
	jne	.L1789
	movq	-464(%rbp), %rax
	movl	256(%rax), %eax
	testl	%eax, %eax
	jne	.L1789
	movl	-188(%rbp), %eax
	movl	%eax, -376(%rbp)
	movl	$0, -372(%rbp)
	leaq	-376(%rbp), %rax
	movl	$8, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	I_flag__ArgsCountError_to_Interface_IError
	movq	-456(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movups	%xmm0, 48(%rax)
	movq	%xmm0, 64(%rax)
	movq	-456(%rbp), %rax
	movb	$1, (%rax)
	movq	-456(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1779
.L1789:
	movq	-464(%rbp), %rcx
	movq	40(%rcx), %rax
	movq	48(%rcx), %rdx
	movq	%rax, -448(%rbp)
	movq	%rdx, -440(%rbp)
	movq	56(%rcx), %rax
	movq	64(%rcx), %rdx
	movq	%rax, -432(%rbp)
	movq	%rdx, -424(%rbp)
	movl	-428(%rbp), %edx
	movq	-440(%rbp), %rcx
	leaq	-208(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_push_many
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, -304(%rbp)
	movq	%rdx, -296(%rbp)
	leaq	-288(%rbp), %rcx
	leaq	-320(%rbp), %rax
	movl	$32, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-456(%rbp), %rax
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	-224(%rbp), %rdx
	movq	%rdx, 64(%rax)
.L1779:
	movq	-456(%rbp), %rax
	addq	$440, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	strings__textscanner__TextScanner_free
strings__textscanner__TextScanner_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	nop
	leave
	ret
	.globl	encoding__binary__little_endian_put_u16
encoding__binary__little_endian_put_u16:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movl	%esi, %eax
	movw	%ax, -28(%rbp)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movzbl	1(%rax), %eax
	movb	%al, -1(%rbp)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movzwl	-28(%rbp), %edx
	movb	%dl, (%rax)
	movzwl	-28(%rbp), %eax
	shrw	$8, %ax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$1, %rax
	movb	%dl, (%rax)
	nop
	popq	%rbp
	ret
	.globl	encoding__binary__little_endian_put_u32
encoding__binary__little_endian_put_u32:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movzbl	3(%rax), %eax
	movb	%al, -1(%rbp)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movl	-28(%rbp), %edx
	movb	%dl, (%rax)
	movl	-28(%rbp), %eax
	shrl	$8, %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$1, %rax
	movb	%dl, (%rax)
	movl	-28(%rbp), %eax
	shrl	$16, %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$2, %rax
	movb	%dl, (%rax)
	movl	-28(%rbp), %eax
	shrl	$24, %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$3, %rax
	movb	%dl, (%rax)
	nop
	popq	%rbp
	ret
	.globl	encoding__binary__little_endian_put_u64
encoding__binary__little_endian_put_u64:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movzbl	7(%rax), %eax
	movb	%al, -1(%rbp)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	-32(%rbp), %rdx
	movb	%dl, (%rax)
	movq	-32(%rbp), %rax
	shrq	$8, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$1, %rax
	movb	%dl, (%rax)
	movq	-32(%rbp), %rax
	shrq	$16, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$2, %rax
	movb	%dl, (%rax)
	movq	-32(%rbp), %rax
	shrq	$24, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$3, %rax
	movb	%dl, (%rax)
	movq	-32(%rbp), %rax
	shrq	$32, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$4, %rax
	movb	%dl, (%rax)
	movq	-32(%rbp), %rax
	shrq	$40, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$5, %rax
	movb	%dl, (%rax)
	movq	-32(%rbp), %rax
	shrq	$48, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$6, %rax
	movb	%dl, (%rax)
	movq	-32(%rbp), %rax
	shrq	$56, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	addq	$7, %rax
	movb	%dl, (%rax)
	nop
	popq	%rbp
	ret
	.globl	os__fd_close
os__fd_close:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	cmpl	$-1, -20(%rbp)
	jne	.L1796
	movl	$0, -8(%rbp)
	movl	-8(%rbp), %eax
	jmp	.L1797
.L1796:
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
.L1797:
	leave
	ret
	.globl	os__NotExpected_msg
	.hidden	os__NotExpected_msg
os__NotExpected_msg:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	popq	%rbp
	ret
	.globl	os__NotExpected_code
	.hidden	os__NotExpected_code
os__NotExpected_code:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	32(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	popq	%rbp
	ret
	.globl	os__fix_windows_path
	.hidden	os__fix_windows_path
os__fix_windows_path:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC182:
	.string	"r+"
.LC183:
	.string	"b"
.LC184:
	.string	"Failed to open or create file \""
.LC185:
	.string	"\""
	.text
	.globl	os__open_file
os__open_file:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$360, %rsp
	movq	%rdi, -360(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -384(%rbp)
	movq	%rdx, -376(%rbp)
	movq	%rcx, %rax
	movq	%r8, %rcx
	movq	%rcx, %rdx
	movq	%rax, -400(%rbp)
	movq	%rdx, -392(%rbp)
	movl	$0, -52(%rbp)
	movb	$0, -53(%rbp)
	movl	$0, -60(%rbp)
	jmp	.L1805
.L1814:
	movq	-400(%rbp), %rdx
	movl	-60(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -81(%rbp)
	cmpb	$119, -81(%rbp)
	jne	.L1806
	movl	_const_os__o_create(%rip), %edx
	movl	_const_os__o_trunc(%rip), %eax
	orl	%eax, %edx
	movl	_const_os__o_wronly(%rip), %eax
	orl	%edx, %eax
	orl	%eax, -52(%rbp)
	jmp	.L1807
.L1806:
	cmpb	$97, -81(%rbp)
	jne	.L1808
	movl	_const_os__o_create(%rip), %edx
	movl	_const_os__o_append(%rip), %eax
	orl	%eax, %edx
	movl	_const_os__o_wronly(%rip), %eax
	orl	%edx, %eax
	orl	%eax, -52(%rbp)
	movb	$1, -53(%rbp)
	jmp	.L1807
.L1808:
	cmpb	$114, -81(%rbp)
	jne	.L1809
	movl	_const_os__o_rdonly(%rip), %eax
	orl	%eax, -52(%rbp)
	jmp	.L1807
.L1809:
	cmpb	$98, -81(%rbp)
	je	.L1807
	cmpb	$115, -81(%rbp)
	jne	.L1811
	movl	_const_os__o_sync(%rip), %eax
	orl	%eax, -52(%rbp)
	jmp	.L1807
.L1811:
	cmpb	$110, -81(%rbp)
	jne	.L1812
	movl	_const_os__o_nonblock(%rip), %eax
	orl	%eax, -52(%rbp)
	jmp	.L1807
.L1812:
	cmpb	$99, -81(%rbp)
	jne	.L1813
	movl	_const_os__o_noctty(%rip), %eax
	orl	%eax, -52(%rbp)
	jmp	.L1807
.L1813:
	cmpb	$43, -81(%rbp)
	jne	.L1807
	movl	_const_os__o_wronly(%rip), %eax
	notl	%eax
	andl	%eax, -52(%rbp)
	movl	_const_os__o_rdwr(%rip), %eax
	orl	%eax, -52(%rbp)
.L1807:
	addl	$1, -60(%rbp)
.L1805:
	movl	-392(%rbp), %eax
	cmpl	%eax, -60(%rbp)
	jl	.L1814
	leaq	.LC182(%rip), %r10
	movq	%r11, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, %r11
	movq	%r11, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r11
	movq	-400(%rbp), %rsi
	movq	-392(%rbp), %rax
	movq	%r10, %rdx
	movq	%r11, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L1815
	movl	_const_os__o_rdwr(%rip), %eax
	movl	%eax, -52(%rbp)
.L1815:
	movl	$438, -64(%rbp)
	movl	36(%rbp), %eax
	testl	%eax, %eax
	jle	.L1816
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movl	(%rax), %eax
	movl	%eax, -64(%rbp)
.L1816:
	movq	-384(%rbp), %rdx
	movq	-376(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	os__fix_windows_path
	movq	%rax, -176(%rbp)
	movq	%rdx, -168(%rbp)
	movq	-176(%rbp), %rax
	movl	-64(%rbp), %edx
	movl	-52(%rbp), %ecx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	movl	%eax, -72(%rbp)
	cmpl	$-1, -72(%rbp)
	jne	.L1817
	call	__errno_location
	movl	(%rax), %eax
	movl	%eax, %edi
	call	os__posix_get_error_msg
	leaq	-160(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-360(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	%xmm0, 48(%rax)
	movq	-360(%rbp), %rax
	movb	$1, (%rax)
	movq	-360(%rbp), %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1818
.L1817:
	leaq	.LC34(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	.LC183(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	-400(%rbp), %rsi
	movq	-392(%rbp), %rax
	movq	%r12, %r8
	movq	%r13, %r9
	movq	%r14, %rdx
	movq	%r15, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_replace
	movq	%rax, -192(%rbp)
	movq	%rdx, -184(%rbp)
	movq	-192(%rbp), %rdx
	movl	-72(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	fdopen
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	isnil
	testb	%al, %al
	je	.L1819
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -352(%rbp)
	movaps	%xmm0, -336(%rbp)
	movaps	%xmm0, -320(%rbp)
	movaps	%xmm0, -304(%rbp)
	movaps	%xmm0, -288(%rbp)
	leaq	.LC184(%rip), %rax
	movq	%rax, -352(%rbp)
	movl	$31, -344(%rbp)
	movl	$1, -340(%rbp)
	movl	$65040, -336(%rbp)
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, -328(%rbp)
	movq	%rdx, -320(%rbp)
	leaq	.LC185(%rip), %rax
	movq	%rax, -312(%rbp)
	movl	$1, -304(%rbp)
	movl	$1, -300(%rbp)
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	leaq	-128(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-360(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	%xmm0, 48(%rax)
	movq	-360(%rbp), %rax
	movb	$1, (%rax)
	movq	-360(%rbp), %rcx
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1818
.L1819:
	cmpb	$0, -53(%rbp)
	je	.L1820
	movq	-80(%rbp), %rax
	movl	$2, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseeko
.L1820:
	movq	-80(%rbp), %rax
	movq	%rax, -272(%rbp)
	movl	-72(%rbp), %eax
	movl	%eax, -264(%rbp)
	movb	$1, -260(%rbp)
	leaq	-256(%rbp), %rcx
	leaq	-272(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-360(%rbp), %rax
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-208(%rbp), %rdx
	movq	%rdx, 48(%rax)
.L1818:
	movq	-360(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC186:
	.string	"0 bytes written"
	.text
	.globl	os__File_write
os__File_write:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$216, %rsp
	movq	%rdi, -232(%rbp)
	movq	%rsi, -240(%rbp)
	movq	-240(%rbp), %rax
	movzbl	12(%rax), %eax
	testb	%al, %al
	jne	.L1823
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	os__error_file_not_opened
	movq	-232(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-232(%rbp), %rax
	movb	$1, (%rax)
	movq	-232(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1822
.L1823:
	movq	-240(%rbp), %rax
	movq	(%rax), %rcx
	movl	36(%rbp), %eax
	movslq	%eax, %rdx
	movq	24(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movl	%eax, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jne	.L1825
	movl	36(%rbp), %eax
	testl	%eax, %eax
	je	.L1825
	leaq	.LC186(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$15, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-80(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-232(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-232(%rbp), %rax
	movb	$1, (%rax)
	movq	-232(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1822
.L1825:
	movl	-36(%rbp), %eax
	movl	%eax, -164(%rbp)
	leaq	-160(%rbp), %rcx
	leaq	-164(%rbp), %rax
	movl	$4, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-232(%rbp), %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L1822:
	movq	-232(%rbp), %rax
	addq	$216, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC187:
	.string	"file read error"
	.text
	.globl	os__fread
	.hidden	os__fread
os__fread:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$232, %rsp
	movq	%rdi, -232(%rbp)
	movq	%rsi, -240(%rbp)
	movl	%edx, -244(%rbp)
	movl	%ecx, -248(%rbp)
	movq	%r8, -256(%rbp)
	movl	-248(%rbp), %eax
	movslq	%eax, %rdx
	movl	-244(%rbp), %eax
	movslq	%eax, %rsi
	movq	-256(%rbp), %rcx
	movq	-240(%rbp), %rax
	movq	%rax, %rdi
	call	fread
	movl	%eax, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jg	.L1828
	movq	-256(%rbp), %rax
	movq	%rax, %rdi
	call	feof
	testl	%eax, %eax
	je	.L1829
	leaq	-164(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	I_os__Eof_to_Interface_IError
	movq	-232(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-232(%rbp), %rax
	movb	$1, (%rax)
	movq	-232(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1827
.L1829:
	movq	-256(%rbp), %rax
	movq	%rax, %rdi
	call	ferror
	testl	%eax, %eax
	je	.L1828
	leaq	.LC187(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$15, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-80(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-232(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-232(%rbp), %rax
	movb	$1, (%rax)
	movq	-232(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1827
.L1828:
	movl	-36(%rbp), %eax
	movl	%eax, -164(%rbp)
	leaq	-160(%rbp), %rcx
	leaq	-164(%rbp), %rax
	movl	$4, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-232(%rbp), %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L1827:
	movq	-232(%rbp), %rax
	addq	$232, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC188:
	.string	"os: file not opened"
	.text
	.globl	os__FileNotOpenedError_msg
os__FileNotOpenedError_msg:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	leaq	.LC188(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$19, -24(%rbp)
	movl	$1, -20(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC189:
	.string	"os: size of type is 0"
	.text
	.globl	os__SizeOfTypeIs0Error_msg
os__SizeOfTypeIs0Error_msg:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	leaq	.LC189(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$21, -24(%rbp)
	movl	$1, -20(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	os__error_file_not_opened
	.hidden	os__error_file_not_opened
os__error_file_not_opened:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	leaq	-32(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	I_os__FileNotOpenedError_to_Interface_IError
	movq	-40(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-40(%rbp), %rax
	leave
	ret
	.globl	os__error_size_of_type_0
	.hidden	os__error_size_of_type_0
os__error_size_of_type_0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, %rdx
	leaq	-32(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	I_os__SizeOfTypeIs0Error_to_Interface_IError
	movq	-40(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-40(%rbp), %rax
	leave
	ret
	.section	.rodata, "a"
.LC190:
	.string	"incomplete struct write"
	.text
	.globl	os__File_write_struct_T_elf__Elf64_Ehdr
os__File_write_struct_T_elf__Elf64_Ehdr:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$280, %rsp
	movq	%rdi, -280(%rbp)
	movq	%rsi, -288(%rbp)
	movq	%rdx, -296(%rbp)
	movq	-288(%rbp), %rax
	movzbl	12(%rax), %eax
	testb	%al, %al
	jne	.L1841
	leaq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	os__error_file_not_opened
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1840
.L1841:
	movl	$64, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jne	.L1843
	leaq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	os__error_size_of_type_0
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1840
.L1843:
	call	__errno_location
	movl	$0, (%rax)
	movq	-288(%rbp), %rax
	movq	(%rax), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movl	%eax, -40(%rbp)
	call	__errno_location
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L1844
	call	__errno_location
	movl	(%rax), %eax
	movl	%eax, %edi
	call	os__posix_get_error_msg
	leaq	-112(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1840
.L1844:
	movl	-40(%rbp), %eax
	cmpl	-36(%rbp), %eax
	je	.L1845
	leaq	.LC190(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$23, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-80(%rbp), %rax
	movl	-40(%rbp), %edx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdi
	movl	%edx, %ecx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	error_with_code
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1840
.L1845:
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
.L1840:
	movq	-280(%rbp), %rax
	addq	$280, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	os__File_write_struct_T_elf__Elf64_Sym
os__File_write_struct_T_elf__Elf64_Sym:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$280, %rsp
	movq	%rdi, -280(%rbp)
	movq	%rsi, -288(%rbp)
	movq	%rdx, -296(%rbp)
	movq	-288(%rbp), %rax
	movzbl	12(%rax), %eax
	testb	%al, %al
	jne	.L1848
	leaq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	os__error_file_not_opened
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1847
.L1848:
	movl	$24, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jne	.L1850
	leaq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	os__error_size_of_type_0
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1847
.L1850:
	call	__errno_location
	movl	$0, (%rax)
	movq	-288(%rbp), %rax
	movq	(%rax), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movl	%eax, -40(%rbp)
	call	__errno_location
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L1851
	call	__errno_location
	movl	(%rax), %eax
	movl	%eax, %edi
	call	os__posix_get_error_msg
	leaq	-112(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1847
.L1851:
	movl	-40(%rbp), %eax
	cmpl	-36(%rbp), %eax
	je	.L1852
	leaq	.LC190(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$23, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-80(%rbp), %rax
	movl	-40(%rbp), %edx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdi
	movl	%edx, %ecx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	error_with_code
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1847
.L1852:
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
.L1847:
	movq	-280(%rbp), %rax
	addq	$280, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	os__File_write_struct_T_elf__Elf64_Rela
os__File_write_struct_T_elf__Elf64_Rela:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$280, %rsp
	movq	%rdi, -280(%rbp)
	movq	%rsi, -288(%rbp)
	movq	%rdx, -296(%rbp)
	movq	-288(%rbp), %rax
	movzbl	12(%rax), %eax
	testb	%al, %al
	jne	.L1855
	leaq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	os__error_file_not_opened
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1854
.L1855:
	movl	$24, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jne	.L1857
	leaq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	os__error_size_of_type_0
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1854
.L1857:
	call	__errno_location
	movl	$0, (%rax)
	movq	-288(%rbp), %rax
	movq	(%rax), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movl	%eax, -40(%rbp)
	call	__errno_location
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L1858
	call	__errno_location
	movl	(%rax), %eax
	movl	%eax, %edi
	call	os__posix_get_error_msg
	leaq	-112(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1854
.L1858:
	movl	-40(%rbp), %eax
	cmpl	-36(%rbp), %eax
	je	.L1859
	leaq	.LC190(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$23, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-80(%rbp), %rax
	movl	-40(%rbp), %edx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdi
	movl	%edx, %ecx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	error_with_code
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1854
.L1859:
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
.L1854:
	movq	-280(%rbp), %rax
	addq	$280, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	os__File_write_struct_T_elf__Elf64_Shdr
os__File_write_struct_T_elf__Elf64_Shdr:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$280, %rsp
	movq	%rdi, -280(%rbp)
	movq	%rsi, -288(%rbp)
	movq	%rdx, -296(%rbp)
	movq	-288(%rbp), %rax
	movzbl	12(%rax), %eax
	testb	%al, %al
	jne	.L1862
	leaq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	os__error_file_not_opened
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1861
.L1862:
	movl	$64, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jne	.L1864
	leaq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	os__error_size_of_type_0
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1861
.L1864:
	call	__errno_location
	movl	$0, (%rax)
	movq	-288(%rbp), %rax
	movq	(%rax), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-296(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movl	%eax, -40(%rbp)
	call	__errno_location
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L1865
	call	__errno_location
	movl	(%rax), %eax
	movl	%eax, %edi
	call	os__posix_get_error_msg
	leaq	-112(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1861
.L1865:
	movl	-40(%rbp), %eax
	cmpl	-36(%rbp), %eax
	je	.L1866
	leaq	.LC190(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$23, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-80(%rbp), %rax
	movl	-40(%rbp), %edx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdi
	movl	%edx, %ecx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	error_with_code
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-280(%rbp), %rax
	movb	$1, (%rax)
	movq	-280(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1861
.L1866:
	movq	-280(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
.L1861:
	movq	-280(%rbp), %rax
	addq	$280, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC191:
	.string	"fseek failed"
.LC192:
	.string	"ftell failed"
.LC193:
	.string	"int("
.LC194:
	.string	") cast results in "
	.text
	.globl	os__find_cfile_size
	.hidden	os__find_cfile_size
os__find_cfile_size:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$328, %rsp
	movq	%rdi, -360(%rbp)
	movq	%rsi, -368(%rbp)
	movq	-368(%rbp), %rax
	movl	$2, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseek
	movl	%eax, -52(%rbp)
	movq	-368(%rbp), %rax
	movq	%rax, %rdi
	call	ftell
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	je	.L1869
	cmpl	$0, -52(%rbp)
	je	.L1869
	leaq	.LC191(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$12, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	leaq	-176(%rbp), %rax
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%r14, %rcx
	movq	%r15, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-360(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-360(%rbp), %rax
	movb	$1, (%rax)
	movq	-360(%rbp), %rcx
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1868
.L1869:
	cmpl	$0, -52(%rbp)
	je	.L1871
	cmpq	$0, -64(%rbp)
	jns	.L1871
	leaq	.LC192(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$12, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-144(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-360(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-360(%rbp), %rax
	movb	$1, (%rax)
	movq	-360(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1868
.L1871:
	movq	-64(%rbp), %rax
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	cltq
	cmpq	%rax, -64(%rbp)
	jle	.L1872
	leaq	-352(%rbp), %rdx
	movl	$0, %eax
	movl	$15, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC193(%rip), %rax
	movq	%rax, -352(%rbp)
	movl	$4, -344(%rbp)
	movl	$1, -340(%rbp)
	movl	$65033, -336(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -328(%rbp)
	leaq	.LC194(%rip), %rax
	movq	%rax, -312(%rbp)
	movl	$18, -304(%rbp)
	movl	$1, -300(%rbp)
	movl	$65031, -296(%rbp)
	movl	-68(%rbp), %eax
	movl	%eax, -288(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -272(%rbp)
	movl	$1, -260(%rbp)
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	str_intp
	leaq	-112(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-360(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-360(%rbp), %rax
	movb	$1, (%rax)
	movq	-360(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1868
.L1872:
	movq	-368(%rbp), %rax
	movq	%rax, %rdi
	call	rewind
	movl	-68(%rbp), %eax
	movl	%eax, -228(%rbp)
	leaq	-224(%rbp), %rcx
	leaq	-228(%rbp), %rax
	movl	$4, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-360(%rbp), %rax
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L1868:
	movq	-360(%rbp), %rax
	addq	$328, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	os__slurp_file_in_builder
	.hidden	os__slurp_file_in_builder
os__slurp_file_in_builder:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$4392, %rsp
	movq	%rdi, -4392(%rbp)
	movq	%rsi, -4400(%rbp)
	movq	$0, -4128(%rbp)
	movq	$0, -4120(%rbp)
	leaq	-4112(%rbp), %rdx
	movl	$0, %eax
	movl	$510, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	-4160(%rbp), %rax
	movl	$4096, %esi
	movq	%rax, %rdi
	call	strings__new_builder
.L1878:
	leaq	-4352(%rbp), %rax
	movq	-4400(%rbp), %rdx
	leaq	-4128(%rbp), %rsi
	movq	%rdx, %r8
	movl	$4096, %ecx
	movl	$1, %edx
	movq	%rax, %rdi
	call	os__fread
	movzbl	-4352(%rbp), %eax
	testb	%al, %al
	je	.L1875
	movq	-4344(%rbp), %rax
	movq	-4336(%rbp), %rdx
	movq	%rax, -4384(%rbp)
	movq	%rdx, -4376(%rbp)
	movq	-4328(%rbp), %rax
	movq	-4320(%rbp), %rdx
	movq	%rax, -4368(%rbp)
	movq	%rdx, -4360(%rbp)
	movl	-4376(%rbp), %eax
	movl	$6, %edx
	cmpl	%edx, %eax
	jne	.L1876
	movq	-4160(%rbp), %rax
	movq	-4152(%rbp), %rdx
	movq	%rax, -4272(%rbp)
	movq	%rdx, -4264(%rbp)
	movq	-4144(%rbp), %rax
	movq	-4136(%rbp), %rdx
	movq	%rax, -4256(%rbp)
	movq	%rdx, -4248(%rbp)
	leaq	-4240(%rbp), %rcx
	leaq	-4272(%rbp), %rax
	movl	$32, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-4392(%rbp), %rax
	movq	-4240(%rbp), %rcx
	movq	-4232(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-4224(%rbp), %rcx
	movq	-4216(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-4208(%rbp), %rcx
	movq	-4200(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-4192(%rbp), %rcx
	movq	-4184(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	-4176(%rbp), %rdx
	movq	%rdx, 64(%rax)
	jmp	.L1874
.L1876:
	leaq	-4160(%rbp), %rax
	movq	%rax, %rdi
	call	strings__Builder_free
	movq	-4392(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movups	%xmm0, 48(%rax)
	movq	%xmm0, 64(%rax)
	movq	-4392(%rbp), %rax
	movb	$1, (%rax)
	movq	-4392(%rbp), %rcx
	movq	-4384(%rbp), %rax
	movq	-4376(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-4368(%rbp), %rax
	movq	-4360(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1874
.L1875:
	leaq	-4352(%rbp), %rax
	addq	$40, %rax
	movl	(%rax), %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %edx
	leaq	-4128(%rbp), %rcx
	leaq	-4160(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strings__Builder_write_ptr
	jmp	.L1878
.L1874:
	movq	-4392(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC195:
	.string	"rb"
.LC196:
	.string	"fread failed"
	.text
	.globl	os__read_file
os__read_file:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$504, %rsp
	movq	%rdi, -504(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -528(%rbp)
	movq	%rdx, -520(%rbp)
	movb	$0, -33(%rbp)
	leaq	.LC195(%rip), %rax
	movq	%rax, -96(%rbp)
	movl	$2, -88(%rbp)
	movl	$1, -84(%rbp)
	leaq	-144(%rbp), %rax
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rdi
	movq	-528(%rbp), %rsi
	movq	-520(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	os__vfopen
	movzbl	-144(%rbp), %eax
	testb	%al, %al
	je	.L1881
	leaq	-144(%rbp), %rcx
	leaq	-400(%rbp), %rax
	movl	$40, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-504(%rbp), %rax
	movq	-400(%rbp), %rcx
	movq	-392(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-352(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1882
.L1881:
	leaq	-144(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movb	$1, -33(%rbp)
	leaq	-192(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	os__find_cfile_size
	movzbl	-192(%rbp), %eax
	testb	%al, %al
	je	.L1883
	cmpb	$0, -33(%rbp)
	je	.L1884
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
.L1884:
	leaq	-192(%rbp), %rcx
	leaq	-400(%rbp), %rax
	movl	$40, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-504(%rbp), %rax
	movq	-400(%rbp), %rcx
	movq	-392(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-352(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1882
.L1883:
	leaq	-192(%rbp), %rax
	addq	$40, %rax
	movl	(%rax), %eax
	movl	%eax, -52(%rbp)
	cmpl	$0, -52(%rbp)
	jne	.L1885
	leaq	-400(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	os__slurp_file_in_builder
	movzbl	-400(%rbp), %eax
	testb	%al, %al
	je	.L1886
	cmpb	$0, -33(%rbp)
	je	.L1887
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
.L1887:
	leaq	-400(%rbp), %rcx
	leaq	-464(%rbp), %rax
	movl	$40, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-504(%rbp), %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-416(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1882
.L1886:
	leaq	-400(%rbp), %rax
	leaq	40(%rax), %rcx
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, -496(%rbp)
	movq	%rdx, -488(%rbp)
	movq	16(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	%rax, -480(%rbp)
	movq	%rdx, -472(%rbp)
	leaq	-496(%rbp), %rax
	movq	%rax, %rdi
	call	strings__Builder_str
	movq	%rax, -272(%rbp)
	movq	%rdx, -264(%rbp)
	leaq	-496(%rbp), %rax
	movq	%rax, %rdi
	call	strings__Builder_free
	movq	-272(%rbp), %rax
	movq	-264(%rbp), %rdx
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	leaq	-464(%rbp), %rcx
	leaq	-288(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	cmpb	$0, -33(%rbp)
	je	.L1889
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
.L1889:
	movq	-504(%rbp), %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-416(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1882
.L1885:
	movl	-52(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc_noscan
	movq	%rax, -64(%rbp)
	movl	-52(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rcx
	movq	-64(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread
	movl	%eax, -68(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	feof
	movl	%eax, -72(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	ferror
	movl	%eax, -76(%rbp)
	cmpl	$0, -72(%rbp)
	jne	.L1890
	cmpl	$0, -76(%rbp)
	je	.L1890
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	_v_free
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -400(%rbp)
	movaps	%xmm0, -384(%rbp)
	movaps	%xmm0, -368(%rbp)
	movq	%xmm0, -352(%rbp)
	movb	$1, -400(%rbp)
	leaq	.LC196(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$12, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-392(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	cmpb	$0, -33(%rbp)
	je	.L1891
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
.L1891:
	movq	-504(%rbp), %rax
	movq	-400(%rbp), %rcx
	movq	-392(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-352(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1882
.L1890:
	movl	-68(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	cmpl	$0, -68(%rbp)
	jne	.L1893
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	u8_vstring
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	leaq	-400(%rbp), %rcx
	leaq	-320(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	cmpb	$0, -33(%rbp)
	je	.L1894
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
.L1894:
	movq	-504(%rbp), %rax
	movq	-400(%rbp), %rcx
	movq	-392(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-352(%rbp), %rdx
	movq	%rdx, 48(%rax)
	jmp	.L1882
.L1893:
	movl	-68(%rbp), %edx
	movq	-64(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	u8_vstring_with_len
	movq	%rax, -304(%rbp)
	movq	%rdx, -296(%rbp)
	leaq	-400(%rbp), %rcx
	leaq	-304(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	cmpb	$0, -33(%rbp)
	je	.L1895
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
.L1895:
	movq	-504(%rbp), %rax
	movq	-400(%rbp), %rcx
	movq	-392(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-352(%rbp), %rdx
	movq	%rdx, 48(%rax)
.L1882:
	movq	-504(%rbp), %rax
	addq	$504, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC197:
	.string	"vfopen called with \"\""
.LC198:
	.string	"failed to open file \""
	.text
	.globl	os__vfopen
os__vfopen:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$280, %rsp
	movq	%rdi, -248(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -272(%rbp)
	movq	%rdx, -264(%rbp)
	movq	%rcx, %rax
	movq	%r8, %rcx
	movq	%rcx, %rdx
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	movl	-264(%rbp), %eax
	testl	%eax, %eax
	jne	.L1898
	leaq	.LC197(%rip), %r10
	movq	%r11, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$21, %rax
	movq	%rax, %r11
	movq	%r11, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r11
	leaq	-96(%rbp), %rax
	movq	%r10, %rsi
	movq	%r11, %rdi
	movq	%r10, %rcx
	movq	%r11, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-248(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-248(%rbp), %rax
	movb	$1, (%rax)
	movq	-248(%rbp), %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1897
.L1898:
	movq	$0, -24(%rbp)
	movq	-288(%rbp), %rdx
	movq	-272(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	isnil
	testb	%al, %al
	je	.L1900
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -240(%rbp)
	movaps	%xmm0, -224(%rbp)
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	leaq	.LC198(%rip), %rax
	movq	%rax, -240(%rbp)
	movl	$21, -232(%rbp)
	movl	$1, -228(%rbp)
	movl	$65040, -224(%rbp)
	movq	-272(%rbp), %rax
	movq	-264(%rbp), %rdx
	movq	%rax, -216(%rbp)
	movq	%rdx, -208(%rbp)
	leaq	.LC185(%rip), %rax
	movq	%rax, -200(%rbp)
	movl	$1, -192(%rbp)
	movl	$1, -188(%rbp)
	leaq	-240(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	leaq	-64(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rdx, %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	_v_error
	movq	-248(%rbp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, 32(%rax)
	movq	-248(%rbp), %rax
	movb	$1, (%rax)
	movq	-248(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	jmp	.L1897
.L1900:
	movq	-24(%rbp), %rax
	movq	%rax, -152(%rbp)
	leaq	-240(%rbp), %rcx
	leaq	-152(%rbp), %rax
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_result_ok
	movq	-248(%rbp), %rax
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
.L1897:
	movq	-248(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	os__posix_get_error_msg
os__posix_get_error_msg:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$72, %rsp
	movl	%edi, -68(%rbp)
	movl	-68(%rbp), %eax
	movl	%eax, %edi
	call	strerror
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L1903
	leaq	.LC34(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$0, -56(%rbp)
	movl	$1, -52(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	jmp	.L1905
.L1903:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	tos3
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
.L1905:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	os__get_raw_line
os__get_raw_line:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$72, %rsp
	movq	$0, -32(%rbp)
	movq	$0, -40(%rbp)
	movq	stdin(%rip), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-40(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	getline
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	$0, %edx
	testl	%eax, %eax
	cmovnsl	%eax, %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	tos
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	cmpl	$0, -20(%rbp)
	jle	.L1907
	movq	-40(%rbp), %rax
	testq	%rax, %rax
	je	.L1907
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	free
.L1907:
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	os__getwd
os__getwd:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$4136, %rsp
	movq	$0, -4144(%rbp)
	movq	$0, -4136(%rbp)
	leaq	-4128(%rbp), %rdx
	movl	$0, %eax
	movl	$510, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	-4144(%rbp), %rax
	movl	$4096, %esi
	movq	%rax, %rdi
	call	getcwd
	testq	%rax, %rax
	jne	.L1910
	leaq	.LC34(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$0, -40(%rbp)
	movl	$1, -36(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	jmp	.L1911
.L1910:
	leaq	-4144(%rbp), %rax
	movq	%rax, %rdi
	call	tos_clone
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
.L1911:
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	os__Result_free
os__Result_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	string_free
	nop
	leave
	ret
	.globl	os__file_ext
os__file_ext:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	movl	-136(%rbp), %eax
	cmpl	$2, %eax
	jg	.L1915
	movq	_const_os__empty_str(%rip), %rax
	movq	8+_const_os__empty_str(%rip), %rdx
	jmp	.L1920
.L1915:
	movq	-144(%rbp), %rdx
	movq	-136(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	os__file_name
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	leaq	-80(%rbp), %rax
	movq	_const_os__dot_str(%rip), %rcx
	movq	8+_const_os__dot_str(%rip), %rdi
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	string_last_index
	movzbl	-80(%rbp), %eax
	testb	%al, %al
	je	.L1917
	movq	-72(%rbp), %rax
	movq	-64(%rbp), %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	-56(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movq	_const_os__empty_str(%rip), %rax
	movq	8+_const_os__empty_str(%rip), %rdx
	jmp	.L1920
.L1917:
	leaq	-80(%rbp), %rax
	addq	$40, %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	-24(%rbp), %eax
	cmpl	%eax, %edx
	jge	.L1918
	cmpl	$0, -4(%rbp)
	jne	.L1919
.L1918:
	movq	_const_os__empty_str(%rip), %rax
	movq	8+_const_os__empty_str(%rip), %rdx
	jmp	.L1920
.L1919:
	movl	-24(%rbp), %ecx
	movl	-4(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
.L1920:
	leave
	ret
	.section	.rodata, "a"
.LC199:
	.string	"/"
.LC200:
	.string	"\\"
	.text
	.globl	os__file_name
os__file_name:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$72, %rsp
	movq	%rdi, %rcx
	movq	%rsi, %rbx
	movq	%rcx, -80(%rbp)
	movq	%rbx, -72(%rbp)
	leaq	.LC199(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$1, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	_const_os__path_separator(%rip), %rdi
	movq	8+_const_os__path_separator(%rip), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__eq
	testb	%al, %al
	je	.L1922
	leaq	.LC200(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$1, -24(%rbp)
	movl	$1, -20(%rbp)
	jmp	.L1923
.L1922:
	leaq	.LC199(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$1, -24(%rbp)
	movl	$1, -20(%rbp)
.L1923:
	movq	_const_os__path_separator(%rip), %rcx
	movq	8+_const_os__path_separator(%rip), %rbx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	-80(%rbp), %rdi
	movq	-72(%rbp), %rsi
	movq	%rcx, %r8
	movq	%rbx, %r9
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_replace
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	_const_os__path_separator(%rip), %rax
	movq	8+_const_os__path_separator(%rip), %rdx
	movq	-48(%rbp), %rdi
	movq	-40(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string_all_after_last
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, %rax
	movq	%rbx, %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	os__get_raw_lines_joined
os__get_raw_lines_joined:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$88, %rsp
	leaq	.LC34(%rip), %rax
	movq	%rax, -48(%rbp)
	movl	$0, -40(%rbp)
	movl	$1, -36(%rbp)
	leaq	-80(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
.L1928:
	call	os__get_raw_line
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movl	-40(%rbp), %eax
	testl	%eax, %eax
	jg	.L1926
	leaq	.LC34(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	call	Array_string_join
	addq	$32, %rsp
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	jmp	.L1929
.L1926:
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	leaq	-112(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1928
.L1929:
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC201:
	.string	"os: failed to find executable"
	.text
	.globl	os__ExecutableNotFoundError_msg
os__ExecutableNotFoundError_msg:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	leaq	.LC201(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	$29, -24(%rbp)
	movl	$1, -20(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	os__init_os_args
	.hidden	os__init_os_args
os__init_os_args:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -88(%rbp)
	movl	%esi, -92(%rbp)
	movq	%rdx, -104(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -64(%rbp)
	movl	$0, -56(%rbp)
	movl	$1, -52(%rbp)
	leaq	-48(%rbp), %rax
	leaq	-64(%rbp), %rdx
	movl	-92(%rbp), %esi
	movq	%rdx, %r8
	movl	$16, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	__new_array_with_default
	movl	$0, -4(%rbp)
	jmp	.L1933
.L1934:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	tos_clone
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	leaq	-80(%rbp), %rdx
	movl	-4(%rbp), %ecx
	leaq	-48(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	array_set
	addl	$1, -4(%rbp)
.L1933:
	movl	-4(%rbp), %eax
	cmpl	-92(%rbp), %eax
	jl	.L1934
	movq	-88(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movq	-88(%rbp), %rax
	leave
	ret
	.globl	os__File_close
os__File_close:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movzbl	12(%rax), %eax
	testb	%al, %al
	je	.L1939
	movq	-8(%rbp), %rax
	movb	$0, 12(%rax)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	fflush
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	fclose
	jmp	.L1936
.L1939:
	nop
.L1936:
	leave
	ret
	.globl	os__Process_close
os__Process_close:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	24(%rax), %eax
	testl	%eax, %eax
	je	.L1947
	movq	-24(%rbp), %rax
	movl	24(%rax), %eax
	cmpl	$5, %eax
	je	.L1947
	movq	-24(%rbp), %rax
	movl	$5, 24(%rax)
	movl	$0, -4(%rbp)
	jmp	.L1944
.L1946:
	movl	-4(%rbp), %eax
	movl	$3, %esi
	movl	%eax, %edi
	call	v_fixed_index
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movslq	%edx, %rdx
	addq	$32, %rdx
	movl	12(%rax,%rdx,4), %eax
	testl	%eax, %eax
	je	.L1945
	movl	-4(%rbp), %eax
	movl	$3, %esi
	movl	%eax, %edi
	call	v_fixed_index
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movslq	%edx, %rdx
	addq	$32, %rdx
	movl	12(%rax,%rdx,4), %eax
	movl	%eax, %edi
	call	os__fd_close
.L1945:
	addl	$1, -4(%rbp)
.L1944:
	cmpl	$2, -4(%rbp)
	jle	.L1946
	jmp	.L1940
.L1947:
	nop
.L1940:
	leave
	ret
	.globl	os__Process_free
os__Process_free:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	os__Process_close
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$32, %rax
	movq	%rax, %rdi
	call	string_free
	movq	-8(%rbp), %rax
	addq	$48, %rax
	movq	%rax, %rdi
	call	array_free
	movq	-8(%rbp), %rax
	addq	$104, %rax
	movq	%rax, %rdi
	call	array_free
	nop
	leave
	ret
	.section	.rodata, "a"
.LC202:
	.string	"\033[1m"
.LC203:
	.string	":"
.LC204:
	.string	": \033[91merror\033[0m\033[1m: "
.LC205:
	.string	" \033[0m"
	.text
	.globl	error__print
error__print:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$192, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -192(%rbp)
	movq	%rdx, -184(%rbp)
	leaq	-176(%rbp), %rdx
	movl	$0, %eax
	movl	$20, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC202(%rip), %rax
	movq	%rax, -176(%rbp)
	movl	$4, -168(%rbp)
	movl	$1, -164(%rbp)
	movl	$65040, -160(%rbp)
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -152(%rbp)
	movq	%rdx, -144(%rbp)
	leaq	.LC203(%rip), %rax
	movq	%rax, -136(%rbp)
	movl	$1, -128(%rbp)
	movl	$1, -124(%rbp)
	movl	$65031, -120(%rbp)
	movl	32(%rbp), %eax
	movl	%eax, -112(%rbp)
	leaq	.LC204(%rip), %rax
	movq	%rax, -96(%rbp)
	movl	$22, -88(%rbp)
	movl	$1, -84(%rbp)
	movl	$65040, -80(%rbp)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, -72(%rbp)
	movq	%rdx, -64(%rbp)
	leaq	.LC205(%rip), %rax
	movq	%rax, -56(%rbp)
	movl	$5, -48(%rbp)
	movl	$1, -44(%rbp)
	leaq	-176(%rbp), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	str_intp
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	eprintln
	nop
	leave
	ret
	.globl	lexer__new
lexer__new:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rsi, %rax
	movq	%rdi, %r8
	movq	%r8, %rsi
	movq	%r9, %rdi
	movq	%rax, %rdi
	movq	%rsi, -96(%rbp)
	movq	%rdi, -88(%rbp)
	movq	%rdx, -112(%rbp)
	movq	%rcx, -104(%rbp)
	movl	-104(%rbp), %eax
	testl	%eax, %eax
	je	.L1951
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	movzbl	%al, %eax
	jmp	.L1952
.L1951:
	movl	$0, %eax
.L1952:
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movb	%al, -80(%rbp)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -72(%rbp)
	movq	%rdx, -64(%rbp)
	movl	$0, -56(%rbp)
	movl	$1, -52(%rbp)
	movl	$0, -48(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, -40(%rbp)
	movq	%rdx, -32(%rbp)
	leaq	-80(%rbp), %rax
	movl	$56, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	leave
	ret
	.globl	lexer__Lexer_advance
	.hidden	lexer__Lexer_advance
lexer__Lexer_advance:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	32(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, 32(%rax)
	movq	-8(%rbp), %rax
	movl	24(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, 24(%rax)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$10, %al
	jne	.L1955
	movq	-8(%rbp), %rax
	movl	$0, 32(%rax)
	movq	-8(%rbp), %rax
	movl	28(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, 28(%rax)
.L1955:
	movq	-8(%rbp), %rax
	movl	16(%rax), %edx
	movq	-8(%rbp), %rax
	movl	24(%rax), %eax
	cmpl	%eax, %edx
	jne	.L1956
	movq	-8(%rbp), %rax
	movb	$0, (%rax)
	jmp	.L1958
.L1956:
	movq	-8(%rbp), %rax
	movl	24(%rax), %edx
	movq	-8(%rbp), %rax
	movq	8(%rax), %rcx
	movq	16(%rax), %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	movq	-8(%rbp), %rdx
	movb	%al, (%rdx)
.L1958:
	nop
	leave
	ret
	.globl	lexer__Lexer_peak
	.hidden	lexer__Lexer_peak
lexer__Lexer_peak:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movl	16(%rax), %edx
	movq	-24(%rbp), %rax
	movl	24(%rax), %ecx
	movl	-28(%rbp), %eax
	addl	%ecx, %eax
	cmpl	%eax, %edx
	jne	.L1960
	movb	$0, -2(%rbp)
	movzbl	-2(%rbp), %eax
	jmp	.L1961
.L1960:
	movq	-24(%rbp), %rax
	movl	24(%rax), %edx
	movl	-28(%rbp), %eax
	addl	%eax, %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rcx
	movq	16(%rax), %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
.L1961:
	leave
	ret
	.globl	lexer__Lexer_current_pos
	.hidden	lexer__Lexer_current_pos
lexer__Lexer_current_pos:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	48(%rax), %rdx
	movq	40(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-80(%rbp), %rax
	movl	28(%rax), %eax
	movl	%eax, -16(%rbp)
	movq	-72(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-16(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	-72(%rbp), %rax
	popq	%rbp
	ret
	.globl	lexer__Lexer_skip_comment
	.hidden	lexer__Lexer_skip_comment
lexer__Lexer_skip_comment:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
.L1966:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$10, %al
	je	.L1967
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L1967
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	jmp	.L1966
.L1967:
	nop
	leave
	ret
	.globl	lexer__Lexer_is_hex
	.hidden	lexer__Lexer_is_hex
lexer__Lexer_is_hex:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	16(%rax), %edx
	movq	-24(%rbp), %rax
	movl	24(%rax), %eax
	addl	$1, %eax
	cmpl	%eax, %edx
	jne	.L1969
	movb	$0, -2(%rbp)
	movzbl	-2(%rbp), %eax
	jmp	.L1970
.L1969:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$48, %al
	jne	.L1971
	movq	-24(%rbp), %rax
	movl	24(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rcx
	movq	16(%rax), %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	$120, %al
	je	.L1972
	movq	-24(%rbp), %rax
	movl	24(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rcx
	movq	16(%rax), %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	cmpb	$88, %al
	jne	.L1971
.L1972:
	movl	$1, %eax
	jmp	.L1973
.L1971:
	movl	$0, %eax
.L1973:
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
.L1970:
	leave
	ret
	.globl	lexer__Lexer_read_number
	.hidden	lexer__Lexer_read_number
lexer__Lexer_read_number:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$168, %rsp
	movq	%rdi, -168(%rbp)
	movq	%rsi, -176(%rbp)
	leaq	-48(%rbp), %rax
	movq	-176(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_current_pos
	movq	-176(%rbp), %rax
	movl	24(%rax), %eax
	movl	%eax, -20(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_is_hex
	testb	%al, %al
	je	.L1975
	movq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
.L1980:
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jbe	.L1976
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	jbe	.L1977
.L1976:
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$96, %al
	jbe	.L1978
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$122, %al
	jbe	.L1977
.L1978:
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$64, %al
	jbe	.L1979
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$90, %al
	ja	.L1979
.L1977:
	movq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	jmp	.L1980
.L1975:
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jbe	.L1979
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	ja	.L1979
	movq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	jmp	.L1975
.L1979:
	movq	-176(%rbp), %rax
	movl	24(%rax), %ecx
	movl	-20(%rbp), %edx
	movq	-176(%rbp), %rax
	movq	8(%rax), %rsi
	movq	16(%rax), %rax
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	$1, -112(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -104(%rbp)
	movq	%rdx, -96(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -88(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-168(%rbp), %rax
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-168(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	lexer__Lexer_read_ident
	.hidden	lexer__Lexer_read_ident
lexer__Lexer_read_ident:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$168, %rsp
	movq	%rdi, -168(%rbp)
	movq	%rsi, -176(%rbp)
	leaq	-48(%rbp), %rax
	movq	-176(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_current_pos
	movq	-176(%rbp), %rax
	movl	24(%rax), %eax
	movl	%eax, -20(%rbp)
.L1988:
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$96, %al
	jbe	.L1983
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$122, %al
	jbe	.L1984
.L1983:
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$64, %al
	jbe	.L1985
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$90, %al
	jbe	.L1984
.L1985:
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jbe	.L1986
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	jbe	.L1984
.L1986:
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$95, %al
	je	.L1984
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$46, %al
	je	.L1984
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	je	.L1984
	movq	-176(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$36, %al
	jne	.L1987
.L1984:
	movq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	jmp	.L1988
.L1987:
	movq	-176(%rbp), %rax
	movl	24(%rax), %ecx
	movl	-20(%rbp), %edx
	movq	-176(%rbp), %rax
	movq	8(%rax), %rsi
	movq	16(%rax), %rax
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string_substr
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	$0, -112(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -104(%rbp)
	movq	%rdx, -96(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -88(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-168(%rbp), %rax
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-168(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	lexer__Lexer_read_string
	.hidden	lexer__Lexer_read_string
lexer__Lexer_read_string:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$200, %rsp
	movq	%rdi, -200(%rbp)
	movq	%rsi, -208(%rbp)
	leaq	-48(%rbp), %rax
	movq	-208(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_current_pos
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	leaq	-80(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
.L2007:
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$34, %al
	je	.L2010
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$92, %al
	jne	.L1993
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$110, %al
	jne	.L1994
	movb	$10, -177(%rbp)
	leaq	-177(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L1994:
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$116, %al
	jne	.L1996
	movb	$9, -178(%rbp)
	leaq	-178(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L1996:
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$97, %al
	jne	.L1997
	movb	$7, -179(%rbp)
	leaq	-179(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L1997:
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$98, %al
	jne	.L1998
	movb	$8, -180(%rbp)
	leaq	-180(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L1998:
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$102, %al
	jne	.L1999
	movb	$12, -181(%rbp)
	leaq	-181(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L1999:
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$118, %al
	jne	.L2000
	movb	$11, -182(%rbp)
	leaq	-182(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L2000:
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$48, %al
	jne	.L2001
	movq	-208(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	lexer__Lexer_peak
	cmpb	$51, %al
	jne	.L2002
	movq	-208(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	lexer__Lexer_peak
	cmpb	$51, %al
	jne	.L2002
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movb	$27, -183(%rbp)
	leaq	-183(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L2002:
	movq	-208(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	lexer__Lexer_peak
	cmpb	$49, %al
	jne	.L2004
	movq	-208(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	lexer__Lexer_peak
	cmpb	$49, %al
	jne	.L2004
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movb	$9, -184(%rbp)
	leaq	-184(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L2004:
	movq	-208(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	lexer__Lexer_peak
	cmpb	$50, %al
	jne	.L2005
	movq	-208(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	lexer__Lexer_peak
	cmpb	$50, %al
	jne	.L2005
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movb	$18, -185(%rbp)
	leaq	-185(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L2005:
	movb	$0, -186(%rbp)
	leaq	-186(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	jmp	.L1995
.L2001:
	movb	$92, -187(%rbp)
	leaq	-187(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	movb	%al, -188(%rbp)
	leaq	-188(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
.L1995:
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	jmp	.L2007
.L1993:
	movq	-208(%rbp), %rax
	movzbl	(%rax), %eax
	movb	%al, -189(%rbp)
	leaq	-189(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	jmp	.L2007
.L2010:
	nop
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movl	$2, -128(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -120(%rbp)
	movq	%rdx, -112(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -104(%rbp)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	call	Array_u8_bytestr
	addq	$32, %rsp
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-200(%rbp), %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-200(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	lexer__Lexer_single_letter_token
	.hidden	lexer__Lexer_single_letter_token
lexer__Lexer_single_letter_token:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$184, %rsp
	movq	%rdi, -152(%rbp)
	movq	%rsi, -160(%rbp)
	movq	%rdx, -176(%rbp)
	movq	%rcx, -168(%rbp)
	movl	%r8d, -180(%rbp)
	leaq	-48(%rbp), %rax
	movq	-160(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_current_pos
	movq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	movl	-180(%rbp), %eax
	movl	%eax, -96(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -88(%rbp)
	movq	%rdx, -80(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-152(%rbp), %rax
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-152(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC206:
	.string	""
	.string	""
.LC207:
	.string	"("
.LC208:
	.string	"+"
.LC209:
	.string	"*"
.LC210:
	.string	"$"
.LC211:
	.string	"%"
.LC212:
	.string	","
.LC213:
	.string	"unexpected token `"
	.text
	.globl	lexer__Lexer_lex
lexer__Lexer_lex:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$424, %rsp
	movq	%rdi, -328(%rbp)
	movq	%rsi, -336(%rbp)
.L2038:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L2014
	movl	$14, -128(%rbp)
	leaq	-120(%rbp), %rax
	movq	-336(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_current_pos
	leaq	.LC206(%rip), %rax
	movq	%rax, -96(%rbp)
	movl	$1, -88(%rbp)
	movl	$1, -84(%rbp)
	movq	-328(%rbp), %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2014:
	leaq	-208(%rbp), %rdx
	movq	-336(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	lexer__Lexer_current_pos
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	je	.L2016
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$9, %al
	jne	.L2017
.L2016:
	movq	-336(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	jmp	.L2018
.L2017:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jbe	.L2019
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	ja	.L2019
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_read_number
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2019:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$96, %al
	jbe	.L2021
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$122, %al
	jbe	.L2022
.L2021:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$64, %al
	jbe	.L2023
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$90, %al
	jbe	.L2022
.L2023:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$95, %al
	je	.L2022
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$46, %al
	jne	.L2024
.L2022:
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_read_ident
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2024:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$34, %al
	jne	.L2025
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_read_string
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2025:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$35, %al
	jne	.L2026
	movq	-336(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_skip_comment
	jmp	.L2038
.L2026:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$10, %al
	jne	.L2027
	movq	-336(%rbp), %rax
	movq	%rax, %rdi
	call	lexer__Lexer_advance
	jmp	.L2038
.L2027:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$58, %al
	jne	.L2028
	leaq	.LC203(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$4, %r8d
	movq	%r12, %rdx
	movq	%r13, %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2028:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$40, %al
	jne	.L2029
	leaq	.LC207(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$5, %r8d
	movq	%r14, %rdx
	movq	%r15, %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2029:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$41, %al
	jne	.L2030
	leaq	.LC54(%rip), %rax
	movq	%rax, -352(%rbp)
	movq	-344(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, -344(%rbp)
	movq	-344(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -344(%rbp)
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$6, %r8d
	movq	-352(%rbp), %rdx
	movq	-344(%rbp), %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2030:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$43, %al
	jne	.L2031
	leaq	.LC208(%rip), %rax
	movq	%rax, -368(%rbp)
	movq	-360(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, -360(%rbp)
	movq	-360(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -360(%rbp)
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$7, %r8d
	movq	-368(%rbp), %rdx
	movq	-360(%rbp), %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2031:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	jne	.L2032
	leaq	.LC44(%rip), %rax
	movq	%rax, -384(%rbp)
	movq	-376(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, -376(%rbp)
	movq	-376(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -376(%rbp)
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$8, %r8d
	movq	-384(%rbp), %rdx
	movq	-376(%rbp), %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2032:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$42, %al
	jne	.L2033
	leaq	.LC209(%rip), %rax
	movq	%rax, -400(%rbp)
	movq	-392(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, -392(%rbp)
	movq	-392(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -392(%rbp)
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$9, %r8d
	movq	-400(%rbp), %rdx
	movq	-392(%rbp), %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2033:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$47, %al
	jne	.L2034
	leaq	.LC199(%rip), %rax
	movq	%rax, -416(%rbp)
	movq	-408(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, -408(%rbp)
	movq	-408(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -408(%rbp)
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$10, %r8d
	movq	-416(%rbp), %rdx
	movq	-408(%rbp), %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2034:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$36, %al
	jne	.L2035
	leaq	.LC210(%rip), %rax
	movq	%rax, -432(%rbp)
	movq	-424(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, -424(%rbp)
	movq	-424(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -424(%rbp)
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$12, %r8d
	movq	-432(%rbp), %rdx
	movq	-424(%rbp), %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2035:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$37, %al
	jne	.L2036
	leaq	.LC211(%rip), %rax
	movq	%rax, -448(%rbp)
	movq	-440(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, -440(%rbp)
	movq	-440(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -440(%rbp)
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$11, %r8d
	movq	-448(%rbp), %rdx
	movq	-440(%rbp), %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2036:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$44, %al
	jne	.L2037
	leaq	.LC212(%rip), %rax
	movq	%rax, -464(%rbp)
	movq	-456(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$1, %rax
	movq	%rax, -456(%rbp)
	movq	-456(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -456(%rbp)
	leaq	-320(%rbp), %rax
	movq	-336(%rbp), %rsi
	movl	$3, %r8d
	movq	-464(%rbp), %rdx
	movq	-456(%rbp), %rcx
	movq	%rax, %rdi
	call	lexer__Lexer_single_letter_token
	movq	-328(%rbp), %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	jmp	.L2015
.L2037:
	movq	-336(%rbp), %rax
	movzbl	(%rax), %eax
	movb	%al, -225(%rbp)
	leaq	-80(%rbp), %rax
	leaq	-225(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	call	Array_u8_bytestr
	addq	$32, %rsp
	movq	%rax, -224(%rbp)
	movq	%rdx, -216(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -320(%rbp)
	movaps	%xmm0, -304(%rbp)
	movaps	%xmm0, -288(%rbp)
	movaps	%xmm0, -272(%rbp)
	movaps	%xmm0, -256(%rbp)
	leaq	.LC213(%rip), %rax
	movq	%rax, -320(%rbp)
	movl	$18, -312(%rbp)
	movl	$1, -308(%rbp)
	movl	$65040, -304(%rbp)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, -296(%rbp)
	movq	%rdx, -288(%rbp)
	leaq	.LC89(%rip), %rax
	movq	%rax, -280(%rbp)
	movl	$1, -272(%rbp)
	movl	$1, -268(%rbp)
	leaq	-320(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-192(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2018:
	jmp	.L2038
.L2015:
	movq	-328(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC214:
	.string	"unkown attribute "
	.text
	.globl	encoder__section_flags
	.hidden	encoder__section_flags
encoder__section_flags:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$120, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movl	$0, -20(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L2041
.L2046:
	movq	-128(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -25(%rbp)
	cmpb	$97, -25(%rbp)
	jne	.L2042
	orl	$2, -20(%rbp)
	jmp	.L2043
.L2042:
	cmpb	$120, -25(%rbp)
	jne	.L2044
	orl	$4, -20(%rbp)
	jmp	.L2043
.L2044:
	cmpb	$119, -25(%rbp)
	jne	.L2045
	orl	$1, -20(%rbp)
	jmp	.L2043
.L2045:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -112(%rbp)
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	leaq	.LC214(%rip), %rax
	movq	%rax, -112(%rbp)
	movl	$17, -104(%rbp)
	movl	$1, -100(%rbp)
	movl	$65026, -96(%rbp)
	movzbl	-25(%rbp), %eax
	movb	%al, -88(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$1, -60(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L2043:
	addl	$1, -24(%rbp)
.L2041:
	movl	-120(%rbp), %eax
	cmpl	%eax, -24(%rbp)
	jl	.L2046
	movl	-20(%rbp), %eax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC215:
	.string	"array index out of range"
.LC216:
	.string	"undefined symbol `"
.LC217:
	.string	"sections cannot be global"
	.text
	.globl	encoder__Encoder_change_symbol_binding
	.hidden	encoder__Encoder_change_symbol_binding
encoder__Encoder_change_symbol_binding:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$376, %rsp
	movq	%rdi, -376(%rbp)
	movl	%esi, %eax
	movb	%al, -380(%rbp)
	movq	56(%rbp), %rax
	movq	64(%rbp), %rdx
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
	movq	-376(%rbp), %rax
	movq	192(%rax), %rcx
	movq	200(%rax), %rbx
	movq	%rcx, -192(%rbp)
	movq	%rbx, -184(%rbp)
	movq	208(%rax), %rcx
	movq	216(%rax), %rbx
	movq	%rcx, -176(%rbp)
	movq	%rbx, -168(%rbp)
	movq	224(%rax), %rcx
	movq	232(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	240(%rax), %rcx
	movq	248(%rax), %rbx
	movq	%rcx, -144(%rbp)
	movq	%rbx, -136(%rbp)
	movq	256(%rax), %rcx
	movq	264(%rax), %rbx
	movq	%rcx, -128(%rbp)
	movq	%rbx, -120(%rbp)
	movq	272(%rax), %rcx
	movq	280(%rax), %rbx
	movq	%rcx, -112(%rbp)
	movq	%rbx, -104(%rbp)
	movq	288(%rax), %rcx
	movq	296(%rax), %rbx
	movq	%rcx, -96(%rbp)
	movq	%rbx, -88(%rbp)
	movq	304(%rax), %rax
	movq	%rax, -80(%rbp)
	leaq	-208(%rbp), %rdx
	leaq	-192(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_get_check
	movq	%rax, -56(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -256(%rbp)
	movaps	%xmm0, -240(%rbp)
	movaps	%xmm0, -224(%rbp)
	cmpq	$0, -56(%rbp)
	je	.L2049
	leaq	-256(%rbp), %rax
	leaq	40(%rax), %rdx
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	jmp	.L2050
.L2049:
	movb	$2, -256(%rbp)
	leaq	.LC215(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$24, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-416(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-416(%rbp), %rax
	movq	-408(%rbp), %rdx
	movq	%rax, -248(%rbp)
	movq	%rdx, -240(%rbp)
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, -232(%rbp)
	movq	%rdx, -224(%rbp)
.L2050:
	movzbl	-256(%rbp), %eax
	testb	%al, %al
	je	.L2051
	movq	-248(%rbp), %rax
	movq	-240(%rbp), %rdx
	movq	%rax, -368(%rbp)
	movq	%rdx, -360(%rbp)
	movq	-232(%rbp), %rax
	movq	-224(%rbp), %rdx
	movq	%rax, -352(%rbp)
	movq	%rdx, -344(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -336(%rbp)
	movaps	%xmm0, -320(%rbp)
	movaps	%xmm0, -304(%rbp)
	movaps	%xmm0, -288(%rbp)
	movaps	%xmm0, -272(%rbp)
	leaq	.LC216(%rip), %rax
	movq	%rax, -336(%rbp)
	movl	$18, -328(%rbp)
	movl	$1, -324(%rbp)
	movl	$65040, -320(%rbp)
	movq	56(%rbp), %rax
	movq	64(%rbp), %rdx
	movq	%rax, -312(%rbp)
	movq	%rdx, -304(%rbp)
	leaq	.LC89(%rip), %rax
	movq	%rax, -296(%rbp)
	movl	$1, -288(%rbp)
	movl	$1, -284(%rbp)
	leaq	-336(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	128(%rbp), %rax
	movq	136(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	144(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2051:
	leaq	-256(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	cmpb	$1, -380(%rbp)
	jne	.L2052
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$1, %eax
	jne	.L2052
	leaq	.LC217(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$25, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	%r14, %rcx
	movq	%r15, %rbx
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	128(%rbp), %rax
	movq	136(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	144(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2052:
	movq	-64(%rbp), %rax
	movzbl	-380(%rbp), %edx
	movb	%dl, 80(%rax)
	nop
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_change_symbol_visibility
	.hidden	encoder__Encoder_change_symbol_visibility
encoder__Encoder_change_symbol_visibility:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$376, %rsp
	movq	%rdi, -360(%rbp)
	movl	%esi, %eax
	movb	%al, -364(%rbp)
	movq	56(%rbp), %rax
	movq	64(%rbp), %rdx
	movq	%rax, -192(%rbp)
	movq	%rdx, -184(%rbp)
	movq	-360(%rbp), %rax
	movq	192(%rax), %rcx
	movq	200(%rax), %rbx
	movq	%rcx, -176(%rbp)
	movq	%rbx, -168(%rbp)
	movq	208(%rax), %rcx
	movq	216(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	224(%rax), %rcx
	movq	232(%rax), %rbx
	movq	%rcx, -144(%rbp)
	movq	%rbx, -136(%rbp)
	movq	240(%rax), %rcx
	movq	248(%rax), %rbx
	movq	%rcx, -128(%rbp)
	movq	%rbx, -120(%rbp)
	movq	256(%rax), %rcx
	movq	264(%rax), %rbx
	movq	%rcx, -112(%rbp)
	movq	%rbx, -104(%rbp)
	movq	272(%rax), %rcx
	movq	280(%rax), %rbx
	movq	%rcx, -96(%rbp)
	movq	%rbx, -88(%rbp)
	movq	288(%rax), %rcx
	movq	296(%rax), %rbx
	movq	%rcx, -80(%rbp)
	movq	%rbx, -72(%rbp)
	movq	304(%rax), %rax
	movq	%rax, -64(%rbp)
	leaq	-192(%rbp), %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_get_check
	movq	%rax, -40(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -240(%rbp)
	movaps	%xmm0, -224(%rbp)
	movaps	%xmm0, -208(%rbp)
	cmpq	$0, -40(%rbp)
	je	.L2054
	leaq	-240(%rbp), %rax
	leaq	40(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	jmp	.L2055
.L2054:
	movb	$2, -240(%rbp)
	leaq	.LC215(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$24, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-400(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, -232(%rbp)
	movq	%rdx, -224(%rbp)
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, -216(%rbp)
	movq	%rdx, -208(%rbp)
.L2055:
	movzbl	-240(%rbp), %eax
	testb	%al, %al
	je	.L2056
	movq	-232(%rbp), %rax
	movq	-224(%rbp), %rdx
	movq	%rax, -352(%rbp)
	movq	%rdx, -344(%rbp)
	movq	-216(%rbp), %rax
	movq	-208(%rbp), %rdx
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -320(%rbp)
	movaps	%xmm0, -304(%rbp)
	movaps	%xmm0, -288(%rbp)
	movaps	%xmm0, -272(%rbp)
	movaps	%xmm0, -256(%rbp)
	leaq	.LC216(%rip), %rax
	movq	%rax, -320(%rbp)
	movl	$18, -312(%rbp)
	movl	$1, -308(%rbp)
	movl	$65040, -304(%rbp)
	movq	56(%rbp), %rax
	movq	64(%rbp), %rdx
	movq	%rax, -296(%rbp)
	movq	%rdx, -288(%rbp)
	leaq	.LC89(%rip), %rax
	movq	%rax, -280(%rbp)
	movl	$1, -272(%rbp)
	movl	$1, -268(%rbp)
	leaq	-320(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	128(%rbp), %rax
	movq	136(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	144(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2056:
	leaq	-240(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movzbl	-364(%rbp), %edx
	movb	%dl, 81(%rax)
	nop
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	encoder__Encoder_fix_same_section_relocations
	.hidden	encoder__Encoder_fix_same_section_relocations
encoder__Encoder_fix_same_section_relocations:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$976, %rsp
	movq	%rdi, -968(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L2058
.L2067:
	movq	-968(%rbp), %rax
	movq	168(%rax), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-968(%rbp), %rax
	movq	192(%rax), %rcx
	movq	200(%rax), %rbx
	movq	%rcx, -880(%rbp)
	movq	%rbx, -872(%rbp)
	movq	208(%rax), %rcx
	movq	216(%rax), %rbx
	movq	%rcx, -864(%rbp)
	movq	%rbx, -856(%rbp)
	movq	224(%rax), %rcx
	movq	232(%rax), %rbx
	movq	%rcx, -848(%rbp)
	movq	%rbx, -840(%rbp)
	movq	240(%rax), %rcx
	movq	248(%rax), %rbx
	movq	%rcx, -832(%rbp)
	movq	%rbx, -824(%rbp)
	movq	256(%rax), %rcx
	movq	264(%rax), %rbx
	movq	%rcx, -816(%rbp)
	movq	%rbx, -808(%rbp)
	movq	272(%rax), %rcx
	movq	280(%rax), %rbx
	movq	%rcx, -800(%rbp)
	movq	%rbx, -792(%rbp)
	movq	288(%rax), %rcx
	movq	296(%rax), %rbx
	movq	%rcx, -784(%rbp)
	movq	%rbx, -776(%rbp)
	movq	304(%rax), %rax
	movq	%rax, -768(%rbp)
	leaq	-96(%rbp), %rdx
	leaq	-880(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_get_check
	movq	%rax, -56(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -928(%rbp)
	movaps	%xmm0, -912(%rbp)
	movaps	%xmm0, -896(%rbp)
	cmpq	$0, -56(%rbp)
	je	.L2059
	leaq	-928(%rbp), %rax
	leaq	40(%rax), %rdx
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	jmp	.L2060
.L2059:
	movb	$2, -928(%rbp)
	leaq	.LC215(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$24, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-1008(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-1008(%rbp), %rax
	movq	-1000(%rbp), %rdx
	movq	%rax, -920(%rbp)
	movq	%rdx, -912(%rbp)
	movq	-992(%rbp), %rax
	movq	-984(%rbp), %rdx
	movq	%rax, -904(%rbp)
	movq	%rdx, -896(%rbp)
.L2060:
	movzbl	-928(%rbp), %eax
	testb	%al, %al
	jne	.L2066
	leaq	-928(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	96(%rax), %rdx
	movq	88(%rax), %rax
	movq	-64(%rbp), %rcx
	movq	88(%rcx), %rdi
	movq	96(%rcx), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	string__eq
	testb	%al, %al
	je	.L2068
	movq	-64(%rbp), %rax
	movzbl	80(%rax), %eax
	cmpb	$1, %al
	je	.L2069
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movzbl	104(%rax), %eax
	testb	%al, %al
	jne	.L2065
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	movl	$2, %edx
	cmpq	%rdx, %rax
	jne	.L2070
.L2065:
	movq	-64(%rbp), %rax
	movq	72(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	72(%rax), %rax
	subq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movl	28(%rax), %eax
	cltq
	subq	%rax, %rdx
	movq	-48(%rbp), %rax
	movl	40(%rax), %eax
	cltq
	addq	%rdx, %rax
	movq	%rax, -72(%rbp)
	movb	$0, -100(%rbp)
	movb	$0, -99(%rbp)
	movb	$0, -98(%rbp)
	movb	$0, -97(%rbp)
	leaq	-960(%rbp), %rax
	leaq	-100(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$4, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-72(%rbp), %rax
	movl	%eax, %edx
	leaq	-960(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoding__binary__little_endian_put_u32
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-960(%rbp), %rax
	movq	-952(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -137(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	72(%rax), %rax
	movl	%eax, %edx
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	addl	%edx, %eax
	movl	%eax, %r14d
	movq	$0, -136(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	96(%rax), %rdx
	movq	88(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	-968(%rbp), %rax
	movq	312(%rax), %rcx
	movq	320(%rax), %rbx
	movq	%rcx, -752(%rbp)
	movq	%rbx, -744(%rbp)
	movq	328(%rax), %rcx
	movq	336(%rax), %rbx
	movq	%rcx, -736(%rbp)
	movq	%rbx, -728(%rbp)
	movq	344(%rax), %rcx
	movq	352(%rax), %rbx
	movq	%rcx, -720(%rbp)
	movq	%rbx, -712(%rbp)
	movq	360(%rax), %rcx
	movq	368(%rax), %rbx
	movq	%rcx, -704(%rbp)
	movq	%rbx, -696(%rbp)
	movq	376(%rax), %rcx
	movq	384(%rax), %rbx
	movq	%rcx, -688(%rbp)
	movq	%rbx, -680(%rbp)
	movq	392(%rax), %rcx
	movq	400(%rax), %rbx
	movq	%rcx, -672(%rbp)
	movq	%rbx, -664(%rbp)
	movq	408(%rax), %rcx
	movq	416(%rax), %rbx
	movq	%rcx, -656(%rbp)
	movq	%rbx, -648(%rbp)
	movq	424(%rax), %rax
	movq	%rax, -640(%rbp)
	leaq	-136(%rbp), %rdx
	leaq	-128(%rbp), %rcx
	leaq	-752(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	map_get
	movq	(%rax), %rax
	movq	%rax, %rcx
	leaq	-137(%rbp), %rax
	movq	%rax, %rdx
	movl	%r14d, %esi
	movq	%rcx, %rdi
	call	array_set
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-960(%rbp), %rax
	movq	-952(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$1, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -169(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	72(%rax), %rax
	movl	%eax, %edx
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	addl	%edx, %eax
	addl	$1, %eax
	movl	%eax, %r14d
	movq	$0, -168(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	96(%rax), %rdx
	movq	88(%rax), %rax
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	movq	-968(%rbp), %rax
	movq	312(%rax), %rcx
	movq	320(%rax), %rbx
	movq	%rcx, -624(%rbp)
	movq	%rbx, -616(%rbp)
	movq	328(%rax), %rcx
	movq	336(%rax), %rbx
	movq	%rcx, -608(%rbp)
	movq	%rbx, -600(%rbp)
	movq	344(%rax), %rcx
	movq	352(%rax), %rbx
	movq	%rcx, -592(%rbp)
	movq	%rbx, -584(%rbp)
	movq	360(%rax), %rcx
	movq	368(%rax), %rbx
	movq	%rcx, -576(%rbp)
	movq	%rbx, -568(%rbp)
	movq	376(%rax), %rcx
	movq	384(%rax), %rbx
	movq	%rcx, -560(%rbp)
	movq	%rbx, -552(%rbp)
	movq	392(%rax), %rcx
	movq	400(%rax), %rbx
	movq	%rcx, -544(%rbp)
	movq	%rbx, -536(%rbp)
	movq	408(%rax), %rcx
	movq	416(%rax), %rbx
	movq	%rcx, -528(%rbp)
	movq	%rbx, -520(%rbp)
	movq	424(%rax), %rax
	movq	%rax, -512(%rbp)
	leaq	-168(%rbp), %rdx
	leaq	-160(%rbp), %rcx
	leaq	-624(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	map_get
	movq	(%rax), %rax
	movq	%rax, %rcx
	leaq	-169(%rbp), %rax
	movq	%rax, %rdx
	movl	%r14d, %esi
	movq	%rcx, %rdi
	call	array_set
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-960(%rbp), %rax
	movq	-952(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -201(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	72(%rax), %rax
	movl	%eax, %edx
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	addl	%edx, %eax
	addl	$2, %eax
	movl	%eax, %r14d
	movq	$0, -200(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	96(%rax), %rdx
	movq	88(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	%rdx, -184(%rbp)
	movq	-968(%rbp), %rax
	movq	312(%rax), %rcx
	movq	320(%rax), %rbx
	movq	%rcx, -496(%rbp)
	movq	%rbx, -488(%rbp)
	movq	328(%rax), %rcx
	movq	336(%rax), %rbx
	movq	%rcx, -480(%rbp)
	movq	%rbx, -472(%rbp)
	movq	344(%rax), %rcx
	movq	352(%rax), %rbx
	movq	%rcx, -464(%rbp)
	movq	%rbx, -456(%rbp)
	movq	360(%rax), %rcx
	movq	368(%rax), %rbx
	movq	%rcx, -448(%rbp)
	movq	%rbx, -440(%rbp)
	movq	376(%rax), %rcx
	movq	384(%rax), %rbx
	movq	%rcx, -432(%rbp)
	movq	%rbx, -424(%rbp)
	movq	392(%rax), %rcx
	movq	400(%rax), %rbx
	movq	%rcx, -416(%rbp)
	movq	%rbx, -408(%rbp)
	movq	408(%rax), %rcx
	movq	416(%rax), %rbx
	movq	%rcx, -400(%rbp)
	movq	%rbx, -392(%rbp)
	movq	424(%rax), %rax
	movq	%rax, -384(%rbp)
	leaq	-200(%rbp), %rdx
	leaq	-192(%rbp), %rcx
	leaq	-496(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	map_get
	movq	(%rax), %rax
	movq	%rax, %rcx
	leaq	-201(%rbp), %rax
	movq	%rax, %rdx
	movl	%r14d, %esi
	movq	%rcx, %rdi
	call	array_set
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-960(%rbp), %rax
	movq	-952(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$3, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -233(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	72(%rax), %rax
	movl	%eax, %edx
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	addl	%edx, %eax
	addl	$3, %eax
	movl	%eax, %r14d
	movq	$0, -232(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	96(%rax), %rdx
	movq	88(%rax), %rax
	movq	%rax, -224(%rbp)
	movq	%rdx, -216(%rbp)
	movq	-968(%rbp), %rax
	movq	312(%rax), %rcx
	movq	320(%rax), %rbx
	movq	%rcx, -368(%rbp)
	movq	%rbx, -360(%rbp)
	movq	328(%rax), %rcx
	movq	336(%rax), %rbx
	movq	%rcx, -352(%rbp)
	movq	%rbx, -344(%rbp)
	movq	344(%rax), %rcx
	movq	352(%rax), %rbx
	movq	%rcx, -336(%rbp)
	movq	%rbx, -328(%rbp)
	movq	360(%rax), %rcx
	movq	368(%rax), %rbx
	movq	%rcx, -320(%rbp)
	movq	%rbx, -312(%rbp)
	movq	376(%rax), %rcx
	movq	384(%rax), %rbx
	movq	%rcx, -304(%rbp)
	movq	%rbx, -296(%rbp)
	movq	392(%rax), %rcx
	movq	400(%rax), %rbx
	movq	%rcx, -288(%rbp)
	movq	%rbx, -280(%rbp)
	movq	408(%rax), %rcx
	movq	416(%rax), %rbx
	movq	%rcx, -272(%rbp)
	movq	%rbx, -264(%rbp)
	movq	424(%rax), %rax
	movq	%rax, -256(%rbp)
	leaq	-232(%rbp), %rdx
	leaq	-224(%rbp), %rcx
	leaq	-368(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	map_get
	movq	(%rax), %rax
	movq	%rax, %rcx
	leaq	-233(%rbp), %rax
	movq	%rax, %rdx
	movl	%r14d, %esi
	movq	%rcx, %rdi
	call	array_set
	movq	-48(%rbp), %rax
	movb	$1, 44(%rax)
	jmp	.L2066
.L2068:
	nop
	jmp	.L2066
.L2069:
	nop
	jmp	.L2066
.L2070:
	nop
.L2066:
	addl	$1, -36(%rbp)
.L2058:
	movq	-968(%rbp), %rax
	movl	180(%rax), %eax
	cmpl	%eax, -36(%rbp)
	jl	.L2067
	nop
	nop
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC218:
	.string	"this should not happen"
	.text
	.globl	encoder__Encoder_assign_addresses
encoder__Encoder_assign_addresses:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$344, %rsp
	movq	%rdi, -344(%rbp)
	movl	$0, -52(%rbp)
	jmp	.L2072
.L2083:
	movq	-344(%rbp), %rax
	movq	136(%rax), %rax
	movl	-52(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	96(%rax), %rdx
	movq	88(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movq	-344(%rbp), %rax
	movq	312(%rax), %rcx
	movq	320(%rax), %rbx
	movq	%rcx, -256(%rbp)
	movq	%rbx, -248(%rbp)
	movq	328(%rax), %rcx
	movq	336(%rax), %rbx
	movq	%rcx, -240(%rbp)
	movq	%rbx, -232(%rbp)
	movq	344(%rax), %rcx
	movq	352(%rax), %rbx
	movq	%rcx, -224(%rbp)
	movq	%rbx, -216(%rbp)
	movq	360(%rax), %rcx
	movq	368(%rax), %rbx
	movq	%rcx, -208(%rbp)
	movq	%rbx, -200(%rbp)
	movq	376(%rax), %rcx
	movq	384(%rax), %rbx
	movq	%rcx, -192(%rbp)
	movq	%rbx, -184(%rbp)
	movq	392(%rax), %rcx
	movq	400(%rax), %rbx
	movq	%rcx, -176(%rbp)
	movq	%rbx, -168(%rbp)
	movq	408(%rax), %rcx
	movq	416(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	424(%rax), %rax
	movq	%rax, -144(%rbp)
	leaq	-112(%rbp), %rdx
	leaq	-256(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_exists
	testb	%al, %al
	jne	.L2073
	leaq	-304(%rbp), %rax
	movl	$1, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array
	movl	$0, -272(%rbp)
	movl	$0, -268(%rbp)
	movq	$0, -136(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	96(%rax), %rdx
	movq	88(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	-344(%rbp), %rax
	leaq	312(%rax), %rcx
	leaq	-136(%rbp), %rdx
	leaq	-128(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	map_get_and_set
	movq	%rax, %rbx
	leaq	-304(%rbp), %rax
	movl	$40, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, (%rbx)
.L2073:
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	96(%rax), %rdx
	movq	88(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-344(%rbp), %rax
	movq	312(%rax), %rcx
	movq	320(%rax), %rbx
	movq	%rcx, -256(%rbp)
	movq	%rbx, -248(%rbp)
	movq	328(%rax), %rcx
	movq	336(%rax), %rbx
	movq	%rcx, -240(%rbp)
	movq	%rbx, -232(%rbp)
	movq	344(%rax), %rcx
	movq	352(%rax), %rbx
	movq	%rcx, -224(%rbp)
	movq	%rbx, -216(%rbp)
	movq	360(%rax), %rcx
	movq	368(%rax), %rbx
	movq	%rcx, -208(%rbp)
	movq	%rbx, -200(%rbp)
	movq	376(%rax), %rcx
	movq	384(%rax), %rbx
	movq	%rcx, -192(%rbp)
	movq	%rbx, -184(%rbp)
	movq	392(%rax), %rcx
	movq	400(%rax), %rbx
	movq	%rcx, -176(%rbp)
	movq	%rbx, -168(%rbp)
	movq	408(%rax), %rcx
	movq	416(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	424(%rax), %rax
	movq	%rax, -144(%rbp)
	leaq	-96(%rbp), %rdx
	leaq	-256(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_get_check
	movq	%rax, -72(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -304(%rbp)
	movaps	%xmm0, -288(%rbp)
	movaps	%xmm0, -272(%rbp)
	cmpq	$0, -72(%rbp)
	je	.L2074
	leaq	-304(%rbp), %rax
	leaq	40(%rax), %rdx
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	jmp	.L2075
.L2074:
	movb	$2, -304(%rbp)
	leaq	.LC215(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$24, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-384(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, -296(%rbp)
	movq	%rdx, -288(%rbp)
	movq	-368(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rax, -280(%rbp)
	movq	%rdx, -272(%rbp)
.L2075:
	movzbl	-304(%rbp), %eax
	testb	%al, %al
	je	.L2076
	movq	-296(%rbp), %rax
	movq	-288(%rbp), %rdx
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	movq	-280(%rbp), %rax
	movq	-272(%rbp), %rdx
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	leaq	.LC218(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$22, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	%r14, %rcx
	movq	%r15, %rbx
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L2076:
	leaq	-304(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	cmpl	$1, %eax
	jne	.L2077
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	56(%rax), %rdx
	movq	64(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__section_flags
	movq	-80(%rbp), %rdx
	movl	%eax, 36(%rdx)
	jmp	.L2078
.L2077:
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	cmpl	$2, %eax
	jne	.L2079
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	-344(%rbp), %rdi
	subq	$8, %rsp
	subq	$136, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rax
	movq	%rax, 128(%rdx)
	movl	$1, %esi
	call	encoder__Encoder_change_symbol_binding
	addq	$144, %rsp
	jmp	.L2078
.L2079:
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	cmpl	$3, %eax
	jne	.L2080
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	-344(%rbp), %rdi
	subq	$8, %rsp
	subq	$136, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rax
	movq	%rax, 128(%rdx)
	movl	$0, %esi
	call	encoder__Encoder_change_symbol_binding
	addq	$144, %rsp
	jmp	.L2078
.L2080:
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	cmpl	$4, %eax
	jne	.L2081
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	-344(%rbp), %rdi
	subq	$8, %rsp
	subq	$136, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rax
	movq	%rax, 128(%rdx)
	movl	$2, %esi
	call	encoder__Encoder_change_symbol_visibility
	addq	$144, %rsp
	jmp	.L2078
.L2081:
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	cmpl	$5, %eax
	jne	.L2082
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	-344(%rbp), %rdi
	subq	$8, %rsp
	subq	$136, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rax
	movq	%rax, 128(%rdx)
	movl	$1, %esi
	call	encoder__Encoder_change_symbol_visibility
	addq	$144, %rsp
	jmp	.L2078
.L2082:
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	cmpl	$6, %eax
	jne	.L2078
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	-344(%rbp), %rdi
	subq	$8, %rsp
	subq	$136, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rax
	movq	%rax, 128(%rdx)
	movl	$3, %esi
	call	encoder__Encoder_change_symbol_visibility
	addq	$144, %rsp
.L2078:
	movq	-80(%rbp), %rax
	movl	32(%rax), %edx
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movslq	%edx, %rdx
	movq	%rdx, 72(%rax)
	movq	-80(%rbp), %rax
	movl	32(%rax), %edx
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movl	28(%rax), %eax
	addl	%eax, %edx
	movq	-80(%rbp), %rax
	movl	%edx, 32(%rax)
	movq	-64(%rbp), %rax
	movq	(%rax), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	movl	-316(%rbp), %edx
	movq	-328(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	array_push_many
	addl	$1, -52(%rbp)
.L2072:
	movq	-344(%rbp), %rax
	movl	148(%rax), %eax
	cmpl	%eax, -52(%rbp)
	jl	.L2083
	movq	-344(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_fix_same_section_relocations
	nop
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_add_imm_rela
	.hidden	encoder__Encoder_add_imm_rela
encoder__Encoder_add_imm_rela:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$224, %rsp
	movq	%rdi, -200(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -224(%rbp)
	movq	%rdx, -216(%rbp)
	movl	%ecx, -204(%rbp)
	movl	%r8d, -208(%rbp)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-200(%rbp), %rax
	movq	120(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-200(%rbp), %rax
	movq	120(%rax), %rax
	movl	28(%rax), %eax
	cltq
	movq	%rax, -24(%rbp)
	movq	$0, -16(%rbp)
	movl	-204(%rbp), %eax
	movl	%eax, -8(%rbp)
	movb	$0, -4(%rbp)
	cmpl	$0, -208(%rbp)
	jne	.L2085
	movl	$14, %eax
	movq	%rax, -16(%rbp)
	movb	$0, -145(%rbp)
	movq	-200(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-145(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2086
.L2085:
	cmpl	$1, -208(%rbp)
	jne	.L2087
	movl	$12, %eax
	movq	%rax, -16(%rbp)
	movb	$0, -147(%rbp)
	movb	$0, -146(%rbp)
	leaq	-192(%rbp), %rax
	leaq	-147(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-172(%rbp), %edx
	movq	-184(%rbp), %rax
	movq	-200(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	jmp	.L2086
.L2087:
	cmpl	$2, -208(%rbp)
	jne	.L2088
	movl	$10, %eax
	movq	%rax, -16(%rbp)
	movb	$0, -151(%rbp)
	movb	$0, -150(%rbp)
	movb	$0, -149(%rbp)
	movb	$0, -148(%rbp)
	leaq	-192(%rbp), %rax
	leaq	-151(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$4, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-172(%rbp), %edx
	movq	-184(%rbp), %rax
	movq	-200(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	jmp	.L2086
.L2088:
	cmpl	$3, -208(%rbp)
	jne	.L2086
	movl	$11, %eax
	movq	%rax, -16(%rbp)
	movb	$0, -155(%rbp)
	movb	$0, -154(%rbp)
	movb	$0, -153(%rbp)
	movb	$0, -152(%rbp)
	leaq	-192(%rbp), %rax
	leaq	-155(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$4, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-172(%rbp), %edx
	movq	-184(%rbp), %rax
	movq	-200(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
.L2086:
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movq	-200(%rbp), %rax
	leaq	160(%rax), %rdx
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	nop
	leave
	ret
	.section	.rodata, "a"
.LC219:
	.string	"unreachable"
	.text
	.globl	encoder__Encoder_add_imm_value
	.hidden	encoder__Encoder_add_imm_value
encoder__Encoder_add_imm_value:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$104, %rsp
	movq	%rdi, -120(%rbp)
	movl	%esi, -124(%rbp)
	movl	%edx, -128(%rbp)
	movl	-124(%rbp), %eax
	movl	%eax, %edi
	call	encoder__is_in_i8_range
	testb	%al, %al
	jne	.L2090
	cmpl	$0, -128(%rbp)
	jne	.L2091
.L2090:
	movl	-124(%rbp), %eax
	movb	%al, -33(%rbp)
	movq	-120(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-33(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	nop
	jmp	.L2089
.L2091:
	cmpl	$1, -128(%rbp)
	jne	.L2093
	movb	$0, -35(%rbp)
	movb	$0, -34(%rbp)
	leaq	-112(%rbp), %rax
	leaq	-35(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-124(%rbp), %eax
	movzwl	%ax, %edx
	leaq	-112(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoding__binary__little_endian_put_u16
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	-60(%rbp), %edx
	movq	-72(%rbp), %rax
	movq	-120(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	jmp	.L2089
.L2093:
	movl	-124(%rbp), %eax
	movl	%eax, %edi
	call	encoder__is_in_i32_range
	testb	%al, %al
	je	.L2094
	movb	$0, -39(%rbp)
	movb	$0, -38(%rbp)
	movb	$0, -37(%rbp)
	movb	$0, -36(%rbp)
	leaq	-112(%rbp), %rax
	leaq	-39(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$4, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-124(%rbp), %edx
	leaq	-112(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoding__binary__little_endian_put_u32
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	-60(%rbp), %edx
	movq	-72(%rbp), %rax
	movq	-120(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	jmp	.L2089
.L2094:
	leaq	.LC219(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$11, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L2089:
	addq	$104, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	encoder__Encoder_add_imm_value2
	.hidden	encoder__Encoder_add_imm_value2
encoder__Encoder_add_imm_value2:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$96, %rsp
	movq	%rdi, -88(%rbp)
	movl	%esi, -92(%rbp)
	movl	%edx, -96(%rbp)
	cmpl	$0, -96(%rbp)
	jne	.L2096
	movl	-92(%rbp), %eax
	movb	%al, -1(%rbp)
	leaq	-48(%rbp), %rax
	leaq	-1(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-28(%rbp), %edx
	movq	-40(%rbp), %rax
	movq	-88(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	jmp	.L2099
.L2096:
	cmpl	$1, -96(%rbp)
	jne	.L2098
	movb	$0, -3(%rbp)
	movb	$0, -2(%rbp)
	leaq	-80(%rbp), %rax
	leaq	-3(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-92(%rbp), %eax
	movzwl	%ax, %edx
	leaq	-80(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoding__binary__little_endian_put_u16
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -5(%rbp)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$1, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -4(%rbp)
	leaq	-48(%rbp), %rax
	leaq	-5(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-28(%rbp), %edx
	movq	-40(%rbp), %rax
	movq	-88(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	jmp	.L2099
.L2098:
	movb	$0, -9(%rbp)
	movb	$0, -8(%rbp)
	movb	$0, -7(%rbp)
	movb	$0, -6(%rbp)
	leaq	-80(%rbp), %rax
	leaq	-9(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$4, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-92(%rbp), %edx
	leaq	-80(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoding__binary__little_endian_put_u32
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -13(%rbp)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$1, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -12(%rbp)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -11(%rbp)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$3, %edi
	call	array_get
	addq	$32, %rsp
	movzbl	(%rax), %eax
	movb	%al, -10(%rbp)
	leaq	-48(%rbp), %rax
	leaq	-13(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$4, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-28(%rbp), %edx
	movq	-40(%rbp), %rax
	movq	-88(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
.L2099:
	nop
	leave
	ret
	.section	.rodata, "a"
.LC220:
	.string	"invalid operand for instruction"
	.text
	.globl	encoder__Encoder_cmov
	.hidden	encoder__Encoder_cmov
encoder__Encoder_cmov:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$424, %rsp
	movq	%rdi, -440(%rbp)
	movl	%esi, -444(%rbp)
	movl	%edx, -448(%rbp)
	movl	-444(%rbp), %edx
	movq	-440(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-256(%rbp), %rax
	movq	-440(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_two_operand
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	movq	-240(%rbp), %rax
	movq	%rax, -272(%rbp)
	movq	-232(%rbp), %rax
	movq	-224(%rbp), %rdx
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	movq	-216(%rbp), %rax
	movq	%rax, -304(%rbp)
	movl	-280(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2101
	movl	-312(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2101
	movl	-448(%rbp), %eax
	movl	%eax, -388(%rbp)
	leaq	-208(%rbp), %rax
	leaq	-388(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-288(%rbp), %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -384(%rbp)
	movq	%xmm0, -368(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -384(%rbp)
	movl	$1, -372(%rbp)
	leaq	-128(%rbp), %rax
	leaq	-384(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-320(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-440(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -432(%rbp)
	movq	%rdx, -424(%rbp)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, -416(%rbp)
	movq	%rdx, -408(%rbp)
	movl	-412(%rbp), %edx
	movq	-424(%rbp), %rax
	movq	-440(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-288(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movq	-320(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -389(%rbp)
	movq	-440(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-389(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2103
.L2101:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-272(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2103:
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC221:
	.string	"invalid immediate operand"
	.text
	.globl	encoder__Encoder_mov
	.hidden	encoder__Encoder_mov
encoder__Encoder_mov:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$2280, %rsp
	movq	%rdi, -2296(%rbp)
	movl	%esi, -2300(%rbp)
	movq	-2296(%rbp), %rax
	movl	$26, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-1696(%rbp), %rax
	movq	-2296(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_two_operand
	movq	-1696(%rbp), %rax
	movq	-1688(%rbp), %rdx
	movq	%rax, -1728(%rbp)
	movq	%rdx, -1720(%rbp)
	movq	-1680(%rbp), %rax
	movq	%rax, -1712(%rbp)
	movq	-1672(%rbp), %rax
	movq	-1664(%rbp), %rdx
	movq	%rax, -1760(%rbp)
	movq	%rdx, -1752(%rbp)
	movq	-1656(%rbp), %rax
	movq	%rax, -1744(%rbp)
	movl	-1720(%rbp), %eax
	cmpl	$167, %eax
	jne	.L2105
	movl	-1752(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2105
	movq	-1760(%rbp), %rax
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	$3, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	$1, -1832(%rbp)
	movl	$3, -1828(%rbp)
	leaq	-1648(%rbp), %rax
	leaq	-1832(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1760(%rbp), %rdx
	leaq	-1616(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1824(%rbp)
	movq	%xmm0, -1808(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1824(%rbp)
	movl	$1, -1812(%rbp)
	leaq	-1568(%rbp), %rax
	leaq	-1824(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1728(%rbp), %rdx
	leaq	-1520(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Xmm_to_sumtype_encoder__RegiAll
	movq	-2296(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1648(%rbp), %rax
	movq	-1640(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1632(%rbp), %rax
	movq	-1624(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1616(%rbp), %rcx
	movq	-1608(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1600(%rbp), %rcx
	movq	-1592(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1584(%rbp), %rcx
	movq	-1576(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1568(%rbp), %rcx
	movq	-1560(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1552(%rbp), %rcx
	movq	-1544(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1536(%rbp), %rcx
	movq	-1528(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1520(%rbp), %rcx
	movq	-1512(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1504(%rbp), %rcx
	movq	-1496(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1488(%rbp), %rcx
	movq	-1480(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movb	$15, -1835(%rbp)
	movb	$126, -1834(%rbp)
	leaq	-2256(%rbp), %rax
	leaq	-1835(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-2236(%rbp), %edx
	movq	-2248(%rbp), %rax
	movq	-2296(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1760(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movq	-1728(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1833(%rbp)
	movq	-2296(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1833(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2106
.L2105:
	movl	-1720(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2107
	movl	-1752(%rbp), %eax
	cmpl	$167, %eax
	jne	.L2107
	movq	-1728(%rbp), %rax
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	$3, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	$1, -1912(%rbp)
	movl	$3, -1908(%rbp)
	leaq	-1472(%rbp), %rax
	leaq	-1912(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1728(%rbp), %rdx
	leaq	-1440(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1904(%rbp)
	movq	%xmm0, -1888(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1904(%rbp)
	movl	$1, -1892(%rbp)
	leaq	-1392(%rbp), %rax
	leaq	-1904(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1760(%rbp), %rdx
	leaq	-1344(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Xmm_to_sumtype_encoder__RegiAll
	movq	-2296(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1472(%rbp), %rax
	movq	-1464(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1456(%rbp), %rax
	movq	-1448(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1440(%rbp), %rcx
	movq	-1432(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1424(%rbp), %rcx
	movq	-1416(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1408(%rbp), %rcx
	movq	-1400(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1392(%rbp), %rcx
	movq	-1384(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1376(%rbp), %rcx
	movq	-1368(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1360(%rbp), %rcx
	movq	-1352(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1344(%rbp), %rcx
	movq	-1336(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1328(%rbp), %rcx
	movq	-1320(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1312(%rbp), %rcx
	movq	-1304(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movb	$15, -1915(%rbp)
	movb	$110, -1914(%rbp)
	leaq	-2256(%rbp), %rax
	leaq	-1915(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-2236(%rbp), %edx
	movq	-2248(%rbp), %rax
	movq	-2296(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1728(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movq	-1760(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1913(%rbp)
	movq	-2296(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1913(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2106
.L2107:
	movl	-1720(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2108
	movl	-1752(%rbp), %eax
	cmpl	$167, %eax
	jne	.L2108
	movq	-1728(%rbp), %rax
	movq	-2296(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	$4, -1920(%rbp)
	leaq	-1296(%rbp), %rax
	leaq	-1920(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1728(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-1264(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1728(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-1216(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1760(%rbp), %rdx
	leaq	-1168(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Xmm_to_sumtype_encoder__RegiAll
	movq	-2296(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1296(%rbp), %rax
	movq	-1288(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1280(%rbp), %rax
	movq	-1272(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1264(%rbp), %rcx
	movq	-1256(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1248(%rbp), %rcx
	movq	-1240(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1232(%rbp), %rcx
	movq	-1224(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1216(%rbp), %rcx
	movq	-1208(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1200(%rbp), %rcx
	movq	-1192(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1184(%rbp), %rcx
	movq	-1176(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1168(%rbp), %rcx
	movq	-1160(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1152(%rbp), %rcx
	movq	-1144(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1136(%rbp), %rcx
	movq	-1128(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movb	$15, -1922(%rbp)
	movb	$126, -1921(%rbp)
	leaq	-2256(%rbp), %rax
	leaq	-1922(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-2236(%rbp), %edx
	movq	-2248(%rbp), %rax
	movq	-2296(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1760(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-1728(%rbp), %rax
	movq	-2296(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2106
.L2108:
	movl	-1720(%rbp), %eax
	cmpl	$167, %eax
	jne	.L2109
	movl	-1752(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2109
	movq	-1760(%rbp), %rax
	movq	-2296(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	$1, -1928(%rbp)
	leaq	-1120(%rbp), %rax
	leaq	-1928(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1760(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-1088(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1760(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-1040(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1728(%rbp), %rdx
	leaq	-992(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Xmm_to_sumtype_encoder__RegiAll
	movq	-2296(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1120(%rbp), %rax
	movq	-1112(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1104(%rbp), %rax
	movq	-1096(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1088(%rbp), %rcx
	movq	-1080(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1072(%rbp), %rcx
	movq	-1064(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1056(%rbp), %rcx
	movq	-1048(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1040(%rbp), %rcx
	movq	-1032(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1024(%rbp), %rcx
	movq	-1016(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1008(%rbp), %rcx
	movq	-1000(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-992(%rbp), %rcx
	movq	-984(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-976(%rbp), %rcx
	movq	-968(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-960(%rbp), %rcx
	movq	-952(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movb	$15, -1930(%rbp)
	movb	$-42, -1929(%rbp)
	leaq	-2256(%rbp), %rax
	leaq	-1930(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-2236(%rbp), %edx
	movq	-2248(%rbp), %rax
	movq	-2296(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1728(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-1760(%rbp), %rax
	movq	-2296(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2106
.L2109:
	movl	-1720(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2110
	cmpl	$0, -2300(%rbp)
	jne	.L2111
	movb	$-120, -1931(%rbp)
	leaq	-2288(%rbp), %rax
	leaq	-1931(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	jmp	.L2112
.L2111:
	movb	$-119, -1932(%rbp)
	leaq	-2288(%rbp), %rax
	leaq	-1932(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
.L2112:
	movq	-1728(%rbp), %rax
	movl	-2300(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1752(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2113
	movq	-1760(%rbp), %rax
	movl	-2300(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-2300(%rbp), %eax
	movl	%eax, -2004(%rbp)
	leaq	-944(%rbp), %rax
	leaq	-2004(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1760(%rbp), %rdx
	leaq	-912(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -2000(%rbp)
	movq	%xmm0, -1984(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -2000(%rbp)
	movl	$1, -1988(%rbp)
	leaq	-864(%rbp), %rax
	leaq	-2000(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1728(%rbp), %rdx
	leaq	-816(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-2296(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-928(%rbp), %rax
	movq	-920(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-912(%rbp), %rcx
	movq	-904(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-896(%rbp), %rcx
	movq	-888(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-880(%rbp), %rcx
	movq	-872(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-864(%rbp), %rcx
	movq	-856(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-848(%rbp), %rcx
	movq	-840(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-832(%rbp), %rcx
	movq	-824(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-816(%rbp), %rcx
	movq	-808(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-800(%rbp), %rcx
	movq	-792(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-784(%rbp), %rcx
	movq	-776(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-2288(%rbp), %rax
	movq	-2280(%rbp), %rdx
	movq	%rax, -2256(%rbp)
	movq	%rdx, -2248(%rbp)
	movq	-2272(%rbp), %rax
	movq	-2264(%rbp), %rdx
	movq	%rax, -2240(%rbp)
	movq	%rdx, -2232(%rbp)
	movl	-2236(%rbp), %edx
	movq	-2248(%rbp), %rax
	movq	-2296(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1760(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movq	-1728(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -2005(%rbp)
	movq	-2296(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-2005(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2106
.L2113:
	movl	-1752(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2110
	movq	-1760(%rbp), %rax
	movq	-2296(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-2300(%rbp), %eax
	movl	%eax, -2012(%rbp)
	leaq	-768(%rbp), %rax
	leaq	-2012(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1760(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-736(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1760(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-688(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1728(%rbp), %rdx
	leaq	-640(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-2296(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-768(%rbp), %rax
	movq	-760(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-752(%rbp), %rax
	movq	-744(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-736(%rbp), %rcx
	movq	-728(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-720(%rbp), %rcx
	movq	-712(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-704(%rbp), %rcx
	movq	-696(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-688(%rbp), %rcx
	movq	-680(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-672(%rbp), %rcx
	movq	-664(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-656(%rbp), %rcx
	movq	-648(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-640(%rbp), %rcx
	movq	-632(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-624(%rbp), %rcx
	movq	-616(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-608(%rbp), %rcx
	movq	-600(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-2288(%rbp), %rax
	movq	-2280(%rbp), %rdx
	movq	%rax, -2256(%rbp)
	movq	%rdx, -2248(%rbp)
	movq	-2272(%rbp), %rax
	movq	-2264(%rbp), %rdx
	movq	%rax, -2240(%rbp)
	movq	%rdx, -2232(%rbp)
	movl	-2236(%rbp), %edx
	movq	-2248(%rbp), %rax
	movq	-2296(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1728(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-1760(%rbp), %rax
	movq	-2296(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2106
.L2110:
	movl	-1720(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2116
	movl	-1752(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2116
	cmpl	$0, -2300(%rbp)
	jne	.L2117
	movb	$-118, -2013(%rbp)
	leaq	-2288(%rbp), %rax
	leaq	-2013(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	jmp	.L2118
.L2117:
	movb	$-117, -2014(%rbp)
	leaq	-2288(%rbp), %rax
	leaq	-2014(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
.L2118:
	movq	-1760(%rbp), %rax
	movl	-2300(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movq	-1728(%rbp), %rax
	movq	-2296(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-2300(%rbp), %eax
	movl	%eax, -2020(%rbp)
	leaq	-592(%rbp), %rax
	leaq	-2020(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1728(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-560(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1728(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-512(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1760(%rbp), %rdx
	leaq	-464(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-2296(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-576(%rbp), %rax
	movq	-568(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-560(%rbp), %rcx
	movq	-552(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-544(%rbp), %rcx
	movq	-536(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-528(%rbp), %rcx
	movq	-520(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-512(%rbp), %rcx
	movq	-504(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-496(%rbp), %rcx
	movq	-488(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-480(%rbp), %rcx
	movq	-472(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-2288(%rbp), %rax
	movq	-2280(%rbp), %rdx
	movq	%rax, -2256(%rbp)
	movq	%rdx, -2248(%rbp)
	movq	-2272(%rbp), %rax
	movq	-2264(%rbp), %rdx
	movq	%rax, -2240(%rbp)
	movq	%rdx, -2232(%rbp)
	movl	-2236(%rbp), %edx
	movq	-2248(%rbp), %rax
	movq	-2296(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1760(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-1728(%rbp), %rax
	movq	-2296(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2106
.L2116:
	movl	-1720(%rbp), %eax
	cmpl	$169, %eax
	jne	.L2119
	movl	-1752(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2120
	movq	-1760(%rbp), %rax
	movl	-2300(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-2300(%rbp), %eax
	movl	%eax, -2148(%rbp)
	leaq	-416(%rbp), %rax
	leaq	-2148(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1760(%rbp), %rdx
	leaq	-384(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -2144(%rbp)
	movq	%xmm0, -2128(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -2144(%rbp)
	movl	$1, -2132(%rbp)
	leaq	-336(%rbp), %rax
	leaq	-2144(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -2080(%rbp)
	movq	%xmm0, -2064(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -2080(%rbp)
	movl	$1, -2068(%rbp)
	leaq	-288(%rbp), %rax
	leaq	-2080(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-2296(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-416(%rbp), %rax
	movq	-408(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-352(%rbp), %rcx
	movq	-344(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	cmpl	$3, -2300(%rbp)
	jne	.L2121
	movb	$-57, -2150(%rbp)
	movq	-2296(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-2150(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1760(%rbp), %rax
	movzbl	20(%rax), %eax
	andl	$7, %eax
	subl	$64, %eax
	movb	%al, -49(%rbp)
	jmp	.L2122
.L2121:
	cmpl	$0, -2300(%rbp)
	jne	.L2123
	movq	-1760(%rbp), %rax
	movzbl	20(%rax), %eax
	andl	$7, %eax
	subl	$80, %eax
	movb	%al, -49(%rbp)
	jmp	.L2122
.L2123:
	movq	-1760(%rbp), %rax
	movzbl	20(%rax), %eax
	andl	$7, %eax
	subl	$72, %eax
	movb	%al, -49(%rbp)
.L2122:
	movzbl	-49(%rbp), %eax
	movb	%al, -2149(%rbp)
	movq	-2296(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-2149(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2124
.L2120:
	movl	-1752(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2125
	movq	-1760(%rbp), %rax
	movq	-2296(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-2300(%rbp), %eax
	movl	%eax, -2212(%rbp)
	leaq	-240(%rbp), %rax
	leaq	-2212(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1760(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1760(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -2208(%rbp)
	movq	%xmm0, -2192(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -2208(%rbp)
	movl	$1, -2196(%rbp)
	leaq	-112(%rbp), %rax
	leaq	-2208(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-2296(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	cmpl	$0, -2300(%rbp)
	jne	.L2126
	movl	$-58, %eax
	jmp	.L2127
.L2126:
	movl	$-57, %eax
.L2127:
	movb	%al, -2213(%rbp)
	movq	-2296(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-2213(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1760(%rbp), %rax
	movq	-2296(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movl	$0, %esi
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2124
.L2125:
	leaq	.LC220(%rip), %rax
	movq	%rax, -2320(%rbp)
	movq	-2312(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, -2312(%rbp)
	movq	-2312(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -2312(%rbp)
	movq	-1744(%rbp), %rcx
	movq	-2320(%rbp), %rax
	movq	-2312(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2124:
	leaq	-2256(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-1728(%rbp), %rcx
	leaq	-2256(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -56(%rbp)
	movl	-2236(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2128
	leaq	.LC221(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$25, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	-1728(%rbp), %rcx
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2128:
	movl	-2236(%rbp), %eax
	cmpl	$1, %eax
	sete	%al
	movb	%al, -57(%rbp)
	cmpb	$0, -57(%rbp)
	je	.L2129
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2256(%rbp), %rax
	movq	-2248(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2240(%rbp), %rax
	movq	-2232(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movl	-2300(%rbp), %edi
	movl	-56(%rbp), %ecx
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	movq	-2296(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_rela
	jmp	.L2106
.L2129:
	movl	-2300(%rbp), %edx
	movl	-56(%rbp), %ecx
	movq	-2296(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_value2
	jmp	.L2106
.L2119:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-1712(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2106:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC222:
	.string	"movsq"
.LC223:
	.string	"stosq"
	.text
	.globl	encoder__Encoder_rep
	.hidden	encoder__Encoder_rep
encoder__Encoder_rep:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	subq	$112, %rsp
	movq	%rdi, -120(%rbp)
	movq	-120(%rbp), %rax
	movl	$28, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-64(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	movl	-56(%rbp), %eax
	cmpl	$170, %eax
	jne	.L2133
	leaq	.LC222(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	-64(%rbp), %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movq	%r14, %rdx
	movq	%r15, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2134
	movb	$-13, -67(%rbp)
	movb	$72, -66(%rbp)
	movb	$-91, -65(%rbp)
	leaq	-112(%rbp), %rax
	leaq	-67(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$3, %edx
	movl	$3, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-92(%rbp), %edx
	movq	-104(%rbp), %rax
	movq	-120(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	jmp	.L2138
.L2134:
	leaq	.LC223(%rip), %rax
	movq	%rax, -144(%rbp)
	movq	-136(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -136(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movq	-144(%rbp), %rdx
	movq	-136(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2133
	movb	$-13, -70(%rbp)
	movb	$72, -69(%rbp)
	movb	$-85, -68(%rbp)
	leaq	-112(%rbp), %rax
	leaq	-70(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$3, %edx
	movl	$3, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-92(%rbp), %edx
	movq	-104(%rbp), %rax
	movq	-120(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	jmp	.L2138
.L2133:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-48(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2138:
	leaq	-32(%rbp), %rsp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_movabsq
	.hidden	encoder__Encoder_movabsq
encoder__Encoder_movabsq:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$616, %rsp
	movq	%rdi, -648(%rbp)
	movq	-648(%rbp), %rax
	movl	$27, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-288(%rbp), %rax
	movq	-648(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_two_operand
	movq	-288(%rbp), %rax
	movq	-280(%rbp), %rdx
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	movq	-272(%rbp), %rax
	movq	%rax, -304(%rbp)
	movq	-264(%rbp), %rax
	movq	-256(%rbp), %rdx
	movq	%rax, -352(%rbp)
	movq	%rdx, -344(%rbp)
	movq	-248(%rbp), %rax
	movq	%rax, -336(%rbp)
	movl	-312(%rbp), %eax
	cmpl	$169, %eax
	jne	.L2140
	movl	-344(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2140
	movq	-352(%rbp), %rax
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	$3, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	$3, -484(%rbp)
	leaq	-240(%rbp), %rax
	leaq	-484(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-352(%rbp), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -480(%rbp)
	movq	%xmm0, -464(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -480(%rbp)
	movl	$1, -468(%rbp)
	leaq	-160(%rbp), %rax
	leaq	-480(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -416(%rbp)
	movq	%xmm0, -400(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -416(%rbp)
	movl	$1, -404(%rbp)
	leaq	-112(%rbp), %rax
	leaq	-416(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-648(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-352(%rbp), %rax
	movzbl	20(%rax), %eax
	andl	$7, %eax
	subl	$72, %eax
	movb	%al, -485(%rbp)
	movq	-648(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-485(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	leaq	-640(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-320(%rbp), %rcx
	leaq	-640(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movq	%rax, -56(%rbp)
	movl	-620(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2141
	leaq	.LC221(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$25, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	-320(%rbp), %rcx
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2141:
	movl	-620(%rbp), %eax
	cmpl	$1, %eax
	sete	%al
	movb	%al, -57(%rbp)
	cmpb	$0, -57(%rbp)
	je	.L2142
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-640(%rbp), %rax
	movq	-632(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-624(%rbp), %rax
	movq	-616(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -608(%rbp)
	movq	%rdx, -600(%rbp)
	movq	-648(%rbp), %rax
	movq	120(%rax), %rax
	movq	%rax, -592(%rbp)
	movq	-648(%rbp), %rax
	movq	120(%rax), %rax
	movl	28(%rax), %eax
	cltq
	movq	%rax, -584(%rbp)
	movq	$0, -576(%rbp)
	movq	-56(%rbp), %rax
	movl	%eax, -568(%rbp)
	movb	$0, -564(%rbp)
	movl	$1, %eax
	movq	%rax, -576(%rbp)
	movq	$0, -493(%rbp)
	leaq	-560(%rbp), %rax
	leaq	-493(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$8, %edx
	movl	$8, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-540(%rbp), %edx
	movq	-552(%rbp), %rax
	movq	-648(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-608(%rbp), %rax
	movq	-600(%rbp), %rdx
	movq	%rax, -560(%rbp)
	movq	%rdx, -552(%rbp)
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, -544(%rbp)
	movq	%rdx, -536(%rbp)
	movq	-576(%rbp), %rax
	movq	-568(%rbp), %rdx
	movq	%rax, -528(%rbp)
	movq	%rdx, -520(%rbp)
	movq	-648(%rbp), %rax
	leaq	160(%rax), %rdx
	leaq	-560(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2145
.L2142:
	movq	$0, -501(%rbp)
	leaq	-608(%rbp), %rax
	leaq	-501(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$8, %edx
	movl	$8, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-56(%rbp), %rdx
	leaq	-608(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoding__binary__little_endian_put_u64
	movq	-608(%rbp), %rax
	movq	-600(%rbp), %rdx
	movq	%rax, -560(%rbp)
	movq	%rdx, -552(%rbp)
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, -544(%rbp)
	movq	%rdx, -536(%rbp)
	movl	-540(%rbp), %edx
	movq	-552(%rbp), %rax
	movq	-648(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	jmp	.L2145
.L2140:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-304(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2145:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_mul
	.hidden	encoder__Encoder_mul
encoder__Encoder_mul:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$680, %rsp
	movq	%rdi, -696(%rbp)
	movl	%esi, -700(%rbp)
	movq	-696(%rbp), %rax
	movl	$24, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-416(%rbp), %rax
	movq	-696(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	movq	-696(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$3, %eax
	je	.L2147
	cmpl	$0, -700(%rbp)
	jne	.L2148
	movb	$-10, -417(%rbp)
	leaq	-688(%rbp), %rax
	leaq	-417(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	jmp	.L2149
.L2148:
	movb	$-9, -418(%rbp)
	leaq	-688(%rbp), %rax
	leaq	-418(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
.L2149:
	movl	-408(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2150
	movq	-416(%rbp), %rax
	movl	-700(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-700(%rbp), %eax
	movl	%eax, -548(%rbp)
	leaq	-384(%rbp), %rax
	leaq	-548(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-416(%rbp), %rdx
	leaq	-352(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -544(%rbp)
	movq	%xmm0, -528(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -544(%rbp)
	movl	$1, -532(%rbp)
	leaq	-304(%rbp), %rax
	leaq	-544(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -480(%rbp)
	movq	%xmm0, -464(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -480(%rbp)
	movl	$1, -468(%rbp)
	leaq	-256(%rbp), %rax
	leaq	-480(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-696(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-368(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-352(%rbp), %rcx
	movq	-344(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-688(%rbp), %rax
	movq	-680(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	movq	-672(%rbp), %rax
	movq	-664(%rbp), %rdx
	movq	%rax, -640(%rbp)
	movq	%rdx, -632(%rbp)
	movl	-636(%rbp), %edx
	movq	-648(%rbp), %rax
	movq	-696(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-416(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	$4, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -549(%rbp)
	movq	-696(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-549(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2154
.L2150:
	movl	-408(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2147
	movq	-416(%rbp), %rax
	movq	-696(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-700(%rbp), %eax
	movl	%eax, -612(%rbp)
	leaq	-208(%rbp), %rax
	leaq	-612(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-416(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-416(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -608(%rbp)
	movq	%xmm0, -592(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -608(%rbp)
	movl	$1, -596(%rbp)
	leaq	-80(%rbp), %rax
	leaq	-608(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-696(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-688(%rbp), %rax
	movq	-680(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	movq	-672(%rbp), %rax
	movq	-664(%rbp), %rdx
	movq	%rax, -640(%rbp)
	movq	%rdx, -632(%rbp)
	movl	-636(%rbp), %edx
	movq	-648(%rbp), %rax
	movq	-696(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-416(%rbp), %rax
	movq	-696(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movl	$4, %esi
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2154
.L2147:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-400(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2154:
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC224:
	.string	"AH"
.LC225:
	.string	"CH"
.LC226:
	.string	"DH"
.LC227:
	.string	"BH"
.LC228:
	.string	"can't encode `%"
.LC229:
	.string	"` in an instruction requiring REX prefix"
	.text
	.globl	encoder__Encoder_mov_zero_or_sign_extend
	.hidden	encoder__Encoder_mov_zero_or_sign_extend
encoder__Encoder_mov_zero_or_sign_extend:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$696, %rsp
	movq	%rdi, -680(%rbp)
	movl	%esi, -684(%rbp)
	movl	%edx, -688(%rbp)
	movq	-680(%rbp), %rax
	movl	$30, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-448(%rbp), %rax
	movq	-680(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_two_operand
	movq	-448(%rbp), %rax
	movq	-440(%rbp), %rdx
	movq	%rax, -480(%rbp)
	movq	%rdx, -472(%rbp)
	movq	-432(%rbp), %rax
	movq	%rax, -464(%rbp)
	movq	-424(%rbp), %rax
	movq	-416(%rbp), %rdx
	movq	%rax, -512(%rbp)
	movq	%rdx, -504(%rbp)
	movq	-408(%rbp), %rax
	movq	%rax, -496(%rbp)
	movl	-472(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2156
	movl	-504(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2156
	cmpl	$3, -688(%rbp)
	jne	.L2157
	leaq	.LC224(%rip), %rax
	movq	%rax, -704(%rbp)
	movq	-696(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -696(%rbp)
	movq	-696(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -696(%rbp)
	movq	-480(%rbp), %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movq	-704(%rbp), %rdx
	movq	-696(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2158
	leaq	.LC225(%rip), %rax
	movq	%rax, -720(%rbp)
	movq	-712(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -712(%rbp)
	movq	-712(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -712(%rbp)
	movq	-480(%rbp), %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movq	-720(%rbp), %rdx
	movq	-712(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2158
	leaq	.LC226(%rip), %rax
	movq	%rax, -736(%rbp)
	movq	-728(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -728(%rbp)
	movq	-728(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -728(%rbp)
	movq	-480(%rbp), %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movq	-736(%rbp), %rdx
	movq	-728(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2158
	leaq	.LC227(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	-480(%rbp), %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movq	%r14, %rdx
	movq	%r15, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2157
.L2158:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -672(%rbp)
	movaps	%xmm0, -656(%rbp)
	movaps	%xmm0, -640(%rbp)
	movaps	%xmm0, -624(%rbp)
	movaps	%xmm0, -608(%rbp)
	leaq	.LC228(%rip), %rax
	movq	%rax, -672(%rbp)
	movl	$15, -664(%rbp)
	movl	$1, -660(%rbp)
	movl	$65040, -656(%rbp)
	movq	-480(%rbp), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -648(%rbp)
	movq	%rdx, -640(%rbp)
	leaq	.LC229(%rip), %rax
	movq	%rax, -632(%rbp)
	movl	$40, -624(%rbp)
	movl	$1, -620(%rbp)
	leaq	-672(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	-480(%rbp), %rcx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2157:
	movq	-480(%rbp), %rax
	movl	-684(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movq	-512(%rbp), %rax
	movl	-688(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-688(%rbp), %eax
	movl	%eax, -580(%rbp)
	leaq	-400(%rbp), %rax
	leaq	-580(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-480(%rbp), %rdx
	leaq	-368(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -576(%rbp)
	movq	%xmm0, -560(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -576(%rbp)
	movl	$1, -564(%rbp)
	leaq	-320(%rbp), %rax
	leaq	-576(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-512(%rbp), %rdx
	leaq	-272(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-680(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-352(%rbp), %rcx
	movq	-344(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -672(%rbp)
	movq	%rdx, -664(%rbp)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	movl	-652(%rbp), %edx
	movq	-664(%rbp), %rax
	movq	-680(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-480(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movq	-512(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -581(%rbp)
	movq	-680(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-581(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2159
.L2156:
	movl	-472(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2160
	movl	-504(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2160
	movq	-512(%rbp), %rax
	movl	-688(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movq	-480(%rbp), %rax
	movq	-680(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-688(%rbp), %eax
	movl	%eax, -588(%rbp)
	leaq	-224(%rbp), %rax
	leaq	-588(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-480(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-192(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-480(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-512(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-680(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -672(%rbp)
	movq	%rdx, -664(%rbp)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	movl	-652(%rbp), %edx
	movq	-664(%rbp), %rax
	movq	-680(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-512(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-480(%rbp), %rax
	movq	-680(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2159
.L2160:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-464(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2159:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_test
	.hidden	encoder__Encoder_test
encoder__Encoder_test:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$1400, %rsp
	movq	%rdi, -1416(%rbp)
	movl	%esi, -1420(%rbp)
	movq	-1416(%rbp), %rax
	movl	$29, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-992(%rbp), %rax
	movq	-1416(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_two_operand
	movq	-992(%rbp), %rax
	movq	-984(%rbp), %rdx
	movq	%rax, -1024(%rbp)
	movq	%rdx, -1016(%rbp)
	movq	-976(%rbp), %rax
	movq	%rax, -1008(%rbp)
	movq	-968(%rbp), %rax
	movq	-960(%rbp), %rdx
	movq	%rax, -1056(%rbp)
	movq	%rdx, -1048(%rbp)
	movq	-952(%rbp), %rax
	movq	%rax, -1040(%rbp)
	movl	-1016(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2163
	cmpl	$0, -1420(%rbp)
	jne	.L2164
	movb	$-124, -1057(%rbp)
	leaq	-1408(%rbp), %rax
	leaq	-1057(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	jmp	.L2165
.L2164:
	movb	$-123, -1058(%rbp)
	leaq	-1408(%rbp), %rax
	leaq	-1058(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
.L2165:
	movq	-1024(%rbp), %rax
	movl	-1420(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1048(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2166
	movq	-1056(%rbp), %rax
	movl	-1420(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1420(%rbp), %eax
	movl	%eax, -1124(%rbp)
	leaq	-944(%rbp), %rax
	leaq	-1124(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1056(%rbp), %rdx
	leaq	-912(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1120(%rbp)
	movq	%xmm0, -1104(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1120(%rbp)
	movl	$1, -1108(%rbp)
	leaq	-864(%rbp), %rax
	leaq	-1120(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1024(%rbp), %rdx
	leaq	-816(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1416(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-928(%rbp), %rax
	movq	-920(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-912(%rbp), %rcx
	movq	-904(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-896(%rbp), %rcx
	movq	-888(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-880(%rbp), %rcx
	movq	-872(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-864(%rbp), %rcx
	movq	-856(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-848(%rbp), %rcx
	movq	-840(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-832(%rbp), %rcx
	movq	-824(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-816(%rbp), %rcx
	movq	-808(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-800(%rbp), %rcx
	movq	-792(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-784(%rbp), %rcx
	movq	-776(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-1408(%rbp), %rax
	movq	-1400(%rbp), %rdx
	movq	%rax, -1376(%rbp)
	movq	%rdx, -1368(%rbp)
	movq	-1392(%rbp), %rax
	movq	-1384(%rbp), %rdx
	movq	%rax, -1360(%rbp)
	movq	%rdx, -1352(%rbp)
	movl	-1356(%rbp), %edx
	movq	-1368(%rbp), %rax
	movq	-1416(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1056(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movq	-1024(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1125(%rbp)
	movq	-1416(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1125(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2169
.L2166:
	movl	-1048(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2163
	movq	-1056(%rbp), %rax
	movq	-1416(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1420(%rbp), %eax
	movl	%eax, -1132(%rbp)
	leaq	-768(%rbp), %rax
	leaq	-1132(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1056(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-736(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1056(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-688(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1024(%rbp), %rdx
	leaq	-640(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1416(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-768(%rbp), %rax
	movq	-760(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-752(%rbp), %rax
	movq	-744(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-736(%rbp), %rcx
	movq	-728(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-720(%rbp), %rcx
	movq	-712(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-704(%rbp), %rcx
	movq	-696(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-688(%rbp), %rcx
	movq	-680(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-672(%rbp), %rcx
	movq	-664(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-656(%rbp), %rcx
	movq	-648(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-640(%rbp), %rcx
	movq	-632(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-624(%rbp), %rcx
	movq	-616(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-608(%rbp), %rcx
	movq	-600(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-1408(%rbp), %rax
	movq	-1400(%rbp), %rdx
	movq	%rax, -1376(%rbp)
	movq	%rdx, -1368(%rbp)
	movq	-1392(%rbp), %rax
	movq	-1384(%rbp), %rdx
	movq	%rax, -1360(%rbp)
	movq	%rdx, -1352(%rbp)
	movl	-1356(%rbp), %edx
	movq	-1368(%rbp), %rax
	movq	-1416(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1024(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-1056(%rbp), %rax
	movq	-1416(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2169
.L2163:
	movl	-1016(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2170
	movl	-1048(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2170
	cmpl	$0, -1420(%rbp)
	jne	.L2171
	movb	$-124, -1133(%rbp)
	leaq	-1408(%rbp), %rax
	leaq	-1133(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	jmp	.L2172
.L2171:
	movb	$-123, -1134(%rbp)
	leaq	-1408(%rbp), %rax
	leaq	-1134(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
.L2172:
	movq	-1056(%rbp), %rax
	movl	-1420(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movq	-1024(%rbp), %rax
	movq	-1416(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1420(%rbp), %eax
	movl	%eax, -1140(%rbp)
	leaq	-592(%rbp), %rax
	leaq	-1140(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1024(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-560(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1024(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-512(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1056(%rbp), %rdx
	leaq	-464(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1416(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-576(%rbp), %rax
	movq	-568(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-560(%rbp), %rcx
	movq	-552(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-544(%rbp), %rcx
	movq	-536(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-528(%rbp), %rcx
	movq	-520(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-512(%rbp), %rcx
	movq	-504(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-496(%rbp), %rcx
	movq	-488(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-480(%rbp), %rcx
	movq	-472(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-1408(%rbp), %rax
	movq	-1400(%rbp), %rdx
	movq	%rax, -1376(%rbp)
	movq	%rdx, -1368(%rbp)
	movq	-1392(%rbp), %rax
	movq	-1384(%rbp), %rdx
	movq	%rax, -1360(%rbp)
	movq	%rdx, -1352(%rbp)
	movl	-1356(%rbp), %edx
	movq	-1368(%rbp), %rax
	movq	-1416(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1056(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-1024(%rbp), %rax
	movq	-1416(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2169
.L2170:
	movl	-1016(%rbp), %eax
	cmpl	$169, %eax
	jne	.L2173
	leaq	-1376(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-1024(%rbp), %rcx
	leaq	-1376(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -52(%rbp)
	movl	-1356(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2174
	leaq	.LC221(%rip), %rax
	movq	%rax, -1440(%rbp)
	movq	-1432(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$25, %rax
	movq	%rax, -1432(%rbp)
	movq	-1432(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -1432(%rbp)
	movq	-1024(%rbp), %rcx
	movq	-1440(%rbp), %rax
	movq	-1432(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2174:
	movl	-1356(%rbp), %eax
	cmpl	$1, %eax
	sete	%al
	movb	%al, -53(%rbp)
	cmpl	$0, -1420(%rbp)
	jne	.L2175
	movl	$-10, %eax
	jmp	.L2176
.L2175:
	movl	$-9, %eax
.L2176:
	movb	%al, -54(%rbp)
	movl	-1048(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2177
	movq	-1056(%rbp), %rax
	movl	-1420(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1420(%rbp), %eax
	movl	%eax, -1268(%rbp)
	leaq	-416(%rbp), %rax
	leaq	-1268(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1056(%rbp), %rdx
	leaq	-384(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1264(%rbp)
	movq	%xmm0, -1248(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1264(%rbp)
	movl	$1, -1252(%rbp)
	leaq	-336(%rbp), %rax
	leaq	-1264(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1200(%rbp)
	movq	%xmm0, -1184(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1200(%rbp)
	movl	$1, -1188(%rbp)
	leaq	-288(%rbp), %rax
	leaq	-1200(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1416(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-416(%rbp), %rax
	movq	-408(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-352(%rbp), %rcx
	movq	-344(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-54(%rbp), %eax
	movb	%al, -1269(%rbp)
	movq	-1416(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1269(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1056(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1270(%rbp)
	movq	-1416(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1270(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2178
.L2177:
	movl	-1048(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2179
	movq	-1056(%rbp), %rax
	movq	-1416(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1420(%rbp), %eax
	movl	%eax, -1332(%rbp)
	leaq	-240(%rbp), %rax
	leaq	-1332(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1056(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1056(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1328(%rbp)
	movq	%xmm0, -1312(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1328(%rbp)
	movl	$1, -1316(%rbp)
	leaq	-112(%rbp), %rax
	leaq	-1328(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1416(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-54(%rbp), %eax
	movb	%al, -1333(%rbp)
	movq	-1416(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1333(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1056(%rbp), %rax
	movq	-1416(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movl	$0, %esi
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2178
.L2179:
	leaq	.LC220(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	-1024(%rbp), %rcx
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2178:
	cmpb	$0, -53(%rbp)
	je	.L2180
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1376(%rbp), %rax
	movq	-1368(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1360(%rbp), %rax
	movq	-1352(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movl	-1420(%rbp), %edi
	movl	-52(%rbp), %ecx
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	movq	-1416(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_rela
	jmp	.L2169
.L2180:
	movl	-1420(%rbp), %edx
	movl	-52(%rbp), %ecx
	movq	-1416(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_value2
	jmp	.L2169
.L2173:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-1008(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2169:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_arith_instr
	.hidden	encoder__Encoder_arith_instr
encoder__Encoder_arith_instr:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$1384, %rsp
	movq	%rdi, -1384(%rbp)
	movl	%esi, -1388(%rbp)
	movl	%ecx, %eax
	movl	%r8d, -1400(%rbp)
	movb	%dl, -1392(%rbp)
	movb	%al, -1396(%rbp)
	movl	-1388(%rbp), %edx
	movq	-1384(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-992(%rbp), %rax
	movq	-1384(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_two_operand
	movq	-992(%rbp), %rax
	movq	-984(%rbp), %rdx
	movq	%rax, -1024(%rbp)
	movq	%rdx, -1016(%rbp)
	movq	-976(%rbp), %rax
	movq	%rax, -1008(%rbp)
	movq	-968(%rbp), %rax
	movq	-960(%rbp), %rdx
	movq	%rax, -1056(%rbp)
	movq	%rdx, -1048(%rbp)
	movq	-952(%rbp), %rax
	movq	%rax, -1040(%rbp)
	movl	-1016(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2184
	cmpl	$0, -1400(%rbp)
	je	.L2185
	movzbl	-1392(%rbp), %eax
	addl	$1, %eax
	jmp	.L2186
.L2185:
	movzbl	-1392(%rbp), %eax
.L2186:
	movb	%al, -49(%rbp)
	movq	-1024(%rbp), %rax
	movl	-1400(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1048(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2187
	movq	-1056(%rbp), %rax
	movl	-1400(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1400(%rbp), %eax
	movl	%eax, -1124(%rbp)
	leaq	-944(%rbp), %rax
	leaq	-1124(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1056(%rbp), %rdx
	leaq	-912(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1120(%rbp)
	movq	%xmm0, -1104(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1120(%rbp)
	movl	$1, -1108(%rbp)
	leaq	-864(%rbp), %rax
	leaq	-1120(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1024(%rbp), %rdx
	leaq	-816(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1384(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-928(%rbp), %rax
	movq	-920(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-912(%rbp), %rcx
	movq	-904(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-896(%rbp), %rcx
	movq	-888(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-880(%rbp), %rcx
	movq	-872(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-864(%rbp), %rcx
	movq	-856(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-848(%rbp), %rcx
	movq	-840(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-832(%rbp), %rcx
	movq	-824(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-816(%rbp), %rcx
	movq	-808(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-800(%rbp), %rcx
	movq	-792(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-784(%rbp), %rcx
	movq	-776(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-49(%rbp), %eax
	movb	%al, -1125(%rbp)
	movq	-1384(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1125(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1056(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movq	-1024(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1126(%rbp)
	movq	-1384(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1126(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2188
.L2187:
	movl	-1048(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2184
	movq	-1056(%rbp), %rax
	movq	-1384(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1400(%rbp), %eax
	movl	%eax, -1132(%rbp)
	leaq	-768(%rbp), %rax
	leaq	-1132(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1056(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-736(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1056(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-688(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1024(%rbp), %rdx
	leaq	-640(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1384(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-768(%rbp), %rax
	movq	-760(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-752(%rbp), %rax
	movq	-744(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-736(%rbp), %rcx
	movq	-728(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-720(%rbp), %rcx
	movq	-712(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-704(%rbp), %rcx
	movq	-696(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-688(%rbp), %rcx
	movq	-680(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-672(%rbp), %rcx
	movq	-664(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-656(%rbp), %rcx
	movq	-648(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-640(%rbp), %rcx
	movq	-632(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-624(%rbp), %rcx
	movq	-616(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-608(%rbp), %rcx
	movq	-600(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-49(%rbp), %eax
	movb	%al, -1133(%rbp)
	movq	-1384(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1133(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1024(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-1056(%rbp), %rax
	movq	-1384(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2188
.L2184:
	movl	-1016(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2189
	movl	-1048(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2189
	cmpl	$0, -1400(%rbp)
	jne	.L2190
	movzbl	-1392(%rbp), %eax
	addl	$2, %eax
	jmp	.L2191
.L2190:
	movzbl	-1392(%rbp), %eax
	addl	$3, %eax
.L2191:
	movb	%al, -50(%rbp)
	movq	-1056(%rbp), %rax
	movl	-1400(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movq	-1024(%rbp), %rax
	movq	-1384(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1400(%rbp), %eax
	movl	%eax, -1140(%rbp)
	leaq	-592(%rbp), %rax
	leaq	-1140(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1024(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-560(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1024(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-512(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1056(%rbp), %rdx
	leaq	-464(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1384(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-576(%rbp), %rax
	movq	-568(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-560(%rbp), %rcx
	movq	-552(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-544(%rbp), %rcx
	movq	-536(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-528(%rbp), %rcx
	movq	-520(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-512(%rbp), %rcx
	movq	-504(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-496(%rbp), %rcx
	movq	-488(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-480(%rbp), %rcx
	movq	-472(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-50(%rbp), %eax
	movb	%al, -1141(%rbp)
	movq	-1384(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1141(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1056(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-1024(%rbp), %rax
	movq	-1384(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2188
.L2189:
	movl	-1016(%rbp), %eax
	cmpl	$169, %eax
	jne	.L2192
	leaq	-1376(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-1024(%rbp), %rcx
	leaq	-1376(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -56(%rbp)
	movl	-1356(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2193
	leaq	.LC221(%rip), %rax
	movq	%rax, -1424(%rbp)
	movq	-1416(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$25, %rax
	movq	%rax, -1416(%rbp)
	movq	-1416(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -1416(%rbp)
	movq	-1024(%rbp), %rcx
	movq	-1424(%rbp), %rax
	movq	-1416(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2193:
	movl	-1356(%rbp), %eax
	cmpl	$1, %eax
	sete	%al
	movb	%al, -57(%rbp)
	cmpl	$0, -1400(%rbp)
	je	.L2194
	movl	-56(%rbp), %eax
	movl	%eax, %edi
	call	encoder__is_in_i8_range
	testb	%al, %al
	je	.L2195
	cmpb	$0, -57(%rbp)
	jne	.L2195
	movl	$-125, %eax
	jmp	.L2197
.L2195:
	movl	$-127, %eax
	jmp	.L2197
.L2194:
	movl	$-128, %eax
.L2197:
	movb	%al, -58(%rbp)
	movl	-1048(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2198
	movq	-1056(%rbp), %rax
	movl	-1400(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1400(%rbp), %eax
	movl	%eax, -1268(%rbp)
	leaq	-416(%rbp), %rax
	leaq	-1268(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1056(%rbp), %rdx
	leaq	-384(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1264(%rbp)
	movq	%xmm0, -1248(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1264(%rbp)
	movl	$1, -1252(%rbp)
	leaq	-336(%rbp), %rax
	leaq	-1264(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1200(%rbp)
	movq	%xmm0, -1184(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1200(%rbp)
	movl	$1, -1188(%rbp)
	leaq	-288(%rbp), %rax
	leaq	-1200(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1384(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-416(%rbp), %rax
	movq	-408(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-352(%rbp), %rcx
	movq	-344(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-58(%rbp), %eax
	movb	%al, -1269(%rbp)
	movq	-1384(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1269(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1056(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movzbl	-1396(%rbp), %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1270(%rbp)
	movq	-1384(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1270(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2199
.L2198:
	movl	-1048(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2200
	movq	-1056(%rbp), %rax
	movq	-1384(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1400(%rbp), %eax
	movl	%eax, -1332(%rbp)
	leaq	-240(%rbp), %rax
	leaq	-1332(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1056(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1056(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1328(%rbp)
	movq	%xmm0, -1312(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1328(%rbp)
	movl	$1, -1316(%rbp)
	leaq	-112(%rbp), %rax
	leaq	-1328(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1384(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-58(%rbp), %eax
	movb	%al, -1333(%rbp)
	movq	-1384(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1333(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movzbl	-1396(%rbp), %esi
	movq	-1056(%rbp), %rax
	movq	-1384(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2199
.L2200:
	leaq	.LC220(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	-1024(%rbp), %rcx
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2199:
	cmpb	$0, -57(%rbp)
	je	.L2201
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1376(%rbp), %rax
	movq	-1368(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1360(%rbp), %rax
	movq	-1352(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movl	-1400(%rbp), %edi
	movl	-56(%rbp), %ecx
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	movq	-1384(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_rela
	jmp	.L2188
.L2201:
	movl	-1400(%rbp), %edx
	movl	-56(%rbp), %ecx
	movq	-1384(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_value
	jmp	.L2188
.L2192:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-1008(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2188:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_imul
	.hidden	encoder__Encoder_imul
encoder__Encoder_imul:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$1464, %rsp
	movq	%rdi, -1496(%rbp)
	movl	%esi, -1500(%rbp)
	movq	-1496(%rbp), %rax
	movl	$20, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-976(%rbp), %rax
	movq	-1496(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	movq	-1496(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$3, %eax
	je	.L2205
	cmpl	$0, -1500(%rbp)
	jne	.L2206
	movb	$-10, -1073(%rbp)
	leaq	-1488(%rbp), %rax
	leaq	-1073(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	jmp	.L2207
.L2206:
	movb	$-9, -1074(%rbp)
	leaq	-1488(%rbp), %rax
	leaq	-1074(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
.L2207:
	movl	-968(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2208
	movq	-976(%rbp), %rax
	movl	-1500(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1500(%rbp), %eax
	movl	%eax, -1204(%rbp)
	leaq	-944(%rbp), %rax
	leaq	-1204(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-976(%rbp), %rdx
	leaq	-912(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1200(%rbp)
	movq	%xmm0, -1184(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1200(%rbp)
	movl	$1, -1188(%rbp)
	leaq	-864(%rbp), %rax
	leaq	-1200(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1136(%rbp)
	movq	%xmm0, -1120(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1136(%rbp)
	movl	$1, -1124(%rbp)
	leaq	-816(%rbp), %rax
	leaq	-1136(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1496(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-928(%rbp), %rax
	movq	-920(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-912(%rbp), %rcx
	movq	-904(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-896(%rbp), %rcx
	movq	-888(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-880(%rbp), %rcx
	movq	-872(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-864(%rbp), %rcx
	movq	-856(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-848(%rbp), %rcx
	movq	-840(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-832(%rbp), %rcx
	movq	-824(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-816(%rbp), %rcx
	movq	-808(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-800(%rbp), %rcx
	movq	-792(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-784(%rbp), %rcx
	movq	-776(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-1488(%rbp), %rax
	movq	-1480(%rbp), %rdx
	movq	%rax, -1456(%rbp)
	movq	%rdx, -1448(%rbp)
	movq	-1472(%rbp), %rax
	movq	-1464(%rbp), %rdx
	movq	%rax, -1440(%rbp)
	movq	%rdx, -1432(%rbp)
	movl	-1436(%rbp), %edx
	movq	-1448(%rbp), %rax
	movq	-1496(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-976(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	$5, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1205(%rbp)
	movq	-1496(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1205(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2211
.L2208:
	movl	-968(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2205
	movq	-976(%rbp), %rax
	movq	-1496(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1500(%rbp), %eax
	movl	%eax, -1268(%rbp)
	leaq	-768(%rbp), %rax
	leaq	-1268(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-976(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-736(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-976(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-688(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1264(%rbp)
	movq	%xmm0, -1248(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1264(%rbp)
	movl	$1, -1252(%rbp)
	leaq	-640(%rbp), %rax
	leaq	-1264(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1496(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-768(%rbp), %rax
	movq	-760(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-752(%rbp), %rax
	movq	-744(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-736(%rbp), %rcx
	movq	-728(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-720(%rbp), %rcx
	movq	-712(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-704(%rbp), %rcx
	movq	-696(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-688(%rbp), %rcx
	movq	-680(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-672(%rbp), %rcx
	movq	-664(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-656(%rbp), %rcx
	movq	-648(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-640(%rbp), %rcx
	movq	-632(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-624(%rbp), %rcx
	movq	-616(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-608(%rbp), %rcx
	movq	-600(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-1488(%rbp), %rax
	movq	-1480(%rbp), %rdx
	movq	%rax, -1456(%rbp)
	movq	%rdx, -1448(%rbp)
	movq	-1472(%rbp), %rax
	movq	-1464(%rbp), %rdx
	movq	%rax, -1440(%rbp)
	movq	%rdx, -1432(%rbp)
	movl	-1436(%rbp), %edx
	movq	-1448(%rbp), %rax
	movq	-1496(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-976(%rbp), %rax
	movq	-1496(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movl	$5, %esi
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2211
.L2205:
	movq	-1496(%rbp), %rax
	movl	$3, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	leaq	-1008(%rbp), %rax
	movq	-1496(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	movl	-968(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2212
	movl	-1000(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2212
	movq	-1008(%rbp), %rax
	movl	-1500(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movq	-976(%rbp), %rax
	movq	-1496(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1500(%rbp), %eax
	movl	%eax, -1272(%rbp)
	leaq	-592(%rbp), %rax
	leaq	-1272(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-976(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-560(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-976(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-512(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1008(%rbp), %rdx
	leaq	-464(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1496(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-576(%rbp), %rax
	movq	-568(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-560(%rbp), %rcx
	movq	-552(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-544(%rbp), %rcx
	movq	-536(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-528(%rbp), %rcx
	movq	-520(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-512(%rbp), %rcx
	movq	-504(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-496(%rbp), %rcx
	movq	-488(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-480(%rbp), %rcx
	movq	-472(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movb	$15, -1274(%rbp)
	movb	$-81, -1273(%rbp)
	leaq	-1456(%rbp), %rax
	leaq	-1274(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-1436(%rbp), %edx
	movq	-1448(%rbp), %rax
	movq	-1496(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-1008(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-976(%rbp), %rax
	movq	-1496(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2211
.L2212:
	movl	-968(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2213
	movl	-1000(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2213
	movq	-976(%rbp), %rax
	movl	-1500(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movq	-1008(%rbp), %rax
	movl	-1500(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1500(%rbp), %eax
	movl	%eax, -1348(%rbp)
	leaq	-416(%rbp), %rax
	leaq	-1348(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-976(%rbp), %rdx
	leaq	-384(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1344(%rbp)
	movq	%xmm0, -1328(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1344(%rbp)
	movl	$1, -1332(%rbp)
	leaq	-336(%rbp), %rax
	leaq	-1344(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1008(%rbp), %rdx
	leaq	-288(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1496(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-416(%rbp), %rax
	movq	-408(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-352(%rbp), %rcx
	movq	-344(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movb	$15, -1351(%rbp)
	movb	$-81, -1350(%rbp)
	leaq	-1456(%rbp), %rax
	leaq	-1351(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-1436(%rbp), %edx
	movq	-1448(%rbp), %rax
	movq	-1496(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-976(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movq	-1008(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1349(%rbp)
	movq	-1496(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1349(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2211
.L2213:
	movq	-1496(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$3, %eax
	je	.L2214
	movq	-1008(%rbp), %rax
	movq	-1000(%rbp), %rdx
	movq	%rax, -1040(%rbp)
	movq	%rdx, -1032(%rbp)
	movq	-992(%rbp), %rax
	movq	%rax, -1024(%rbp)
	jmp	.L2215
.L2214:
	movq	-1496(%rbp), %rax
	movl	$3, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	leaq	-1040(%rbp), %rax
	movq	-1496(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
.L2215:
	movq	-1040(%rbp), %rax
	movq	-1032(%rbp), %rdx
	movq	%rax, -1072(%rbp)
	movq	%rdx, -1064(%rbp)
	movq	-1024(%rbp), %rax
	movq	%rax, -1056(%rbp)
	movl	-968(%rbp), %eax
	cmpl	$169, %eax
	jne	.L2216
	movl	-1000(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2216
	movl	-1064(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2216
	leaq	-1456(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-976(%rbp), %rcx
	leaq	-1456(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -52(%rbp)
	movl	-1436(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2217
	leaq	.LC221(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$25, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	-976(%rbp), %rcx
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2217:
	movl	-1436(%rbp), %eax
	cmpl	$1, %eax
	sete	%al
	movb	%al, -53(%rbp)
	movl	-52(%rbp), %eax
	movl	%eax, %edi
	call	encoder__is_in_i8_range
	testb	%al, %al
	je	.L2218
	cmpb	$0, -53(%rbp)
	jne	.L2218
	movl	$107, %eax
	jmp	.L2219
.L2218:
	movl	$105, %eax
.L2219:
	movb	%al, -54(%rbp)
	movq	-1008(%rbp), %rax
	movl	-1500(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movq	-1072(%rbp), %rax
	movl	-1500(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1500(%rbp), %eax
	movl	%eax, -1412(%rbp)
	leaq	-240(%rbp), %rax
	leaq	-1412(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1008(%rbp), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1408(%rbp)
	movq	%xmm0, -1392(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1408(%rbp)
	movl	$1, -1396(%rbp)
	leaq	-160(%rbp), %rax
	leaq	-1408(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1072(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1496(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-54(%rbp), %eax
	movb	%al, -1413(%rbp)
	movq	-1496(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1413(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1008(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movq	-1072(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1414(%rbp)
	movq	-1496(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1414(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	cmpb	$0, -53(%rbp)
	je	.L2220
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1456(%rbp), %rax
	movq	-1448(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1440(%rbp), %rax
	movq	-1432(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movl	-1500(%rbp), %edi
	movl	-52(%rbp), %ecx
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	movq	-1496(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_rela
	jmp	.L2211
.L2220:
	movl	-1500(%rbp), %edx
	movl	-52(%rbp), %ecx
	movq	-1496(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_value
	jmp	.L2211
.L2216:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-960(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2211:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_one_operand_arith
	.hidden	encoder__Encoder_one_operand_arith
encoder__Encoder_one_operand_arith:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$696, %rsp
	movq	%rdi, -696(%rbp)
	movl	%esi, -700(%rbp)
	movl	%edx, %eax
	movl	%ecx, -708(%rbp)
	movb	%al, -704(%rbp)
	movl	-700(%rbp), %edx
	movq	-696(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-416(%rbp), %rax
	movq	-696(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	cmpl	$0, -708(%rbp)
	jne	.L2224
	movb	$-10, -449(%rbp)
	leaq	-448(%rbp), %rax
	leaq	-449(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	jmp	.L2225
.L2224:
	movb	$-9, -450(%rbp)
	leaq	-448(%rbp), %rax
	leaq	-450(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
.L2225:
	movl	-408(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2226
	movq	-416(%rbp), %rax
	movl	-708(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-708(%rbp), %eax
	movl	%eax, -580(%rbp)
	leaq	-384(%rbp), %rax
	leaq	-580(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-416(%rbp), %rdx
	leaq	-352(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -576(%rbp)
	movq	%xmm0, -560(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -576(%rbp)
	movl	$1, -564(%rbp)
	leaq	-304(%rbp), %rax
	leaq	-576(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -512(%rbp)
	movq	%xmm0, -496(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -512(%rbp)
	movl	$1, -500(%rbp)
	leaq	-256(%rbp), %rax
	leaq	-512(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-696(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-368(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-352(%rbp), %rcx
	movq	-344(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-240(%rbp), %rcx
	movq	-232(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-224(%rbp), %rcx
	movq	-216(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-448(%rbp), %rax
	movq	-440(%rbp), %rdx
	movq	%rax, -688(%rbp)
	movq	%rdx, -680(%rbp)
	movq	-432(%rbp), %rax
	movq	-424(%rbp), %rdx
	movq	%rax, -672(%rbp)
	movq	%rdx, -664(%rbp)
	movl	-668(%rbp), %edx
	movq	-680(%rbp), %rax
	movq	-696(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-416(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movzbl	-704(%rbp), %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -581(%rbp)
	movq	-696(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-581(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2227
.L2226:
	movl	-408(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2228
	movq	-416(%rbp), %rax
	movq	-696(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-708(%rbp), %eax
	movl	%eax, -644(%rbp)
	leaq	-208(%rbp), %rax
	leaq	-644(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-416(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-416(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -640(%rbp)
	movq	%xmm0, -624(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -640(%rbp)
	movl	$1, -628(%rbp)
	leaq	-80(%rbp), %rax
	leaq	-640(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-696(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	-448(%rbp), %rax
	movq	-440(%rbp), %rdx
	movq	%rax, -688(%rbp)
	movq	%rdx, -680(%rbp)
	movq	-432(%rbp), %rax
	movq	-424(%rbp), %rdx
	movq	%rax, -672(%rbp)
	movq	%rdx, -664(%rbp)
	movl	-668(%rbp), %edx
	movq	-680(%rbp), %rax
	movq	-696(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movzbl	-704(%rbp), %esi
	movq	-416(%rbp), %rax
	movq	-696(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2227
.L2228:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-400(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2227:
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	encoder__Encoder_lea
	.hidden	encoder__Encoder_lea
encoder__Encoder_lea:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$360, %rsp
	movq	%rdi, -360(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -384(%rbp)
	movq	%rdx, -376(%rbp)
	movq	-360(%rbp), %rax
	movl	$25, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	movq	-384(%rbp), %rdx
	movq	-376(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, -36(%rbp)
	leaq	-272(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_two_operand
	movq	-272(%rbp), %rax
	movq	-264(%rbp), %rdx
	movq	%rax, -304(%rbp)
	movq	%rdx, -296(%rbp)
	movq	-256(%rbp), %rax
	movq	%rax, -288(%rbp)
	movq	-248(%rbp), %rax
	movq	-240(%rbp), %rdx
	movq	%rax, -336(%rbp)
	movq	%rdx, -328(%rbp)
	movq	-232(%rbp), %rax
	movq	%rax, -320(%rbp)
	movl	-296(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2231
	movl	-328(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2231
	movq	-336(%rbp), %rax
	movl	-36(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movq	-304(%rbp), %rax
	movq	-360(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-36(%rbp), %eax
	movl	%eax, -340(%rbp)
	leaq	-224(%rbp), %rax
	leaq	-340(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-304(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-192(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-304(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-336(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-360(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movb	$-115, -341(%rbp)
	movq	-360(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-341(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-336(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %esi
	movq	-304(%rbp), %rax
	movq	-360(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2233
.L2231:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-288(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2233:
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	encoder__Encoder_set
	.hidden	encoder__Encoder_set
encoder__Encoder_set:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$408, %rsp
	movq	%rdi, -424(%rbp)
	movl	%esi, -428(%rbp)
	movl	-428(%rbp), %edx
	movq	-424(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-240(%rbp), %rax
	movq	-424(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	movl	-232(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2235
	movq	-240(%rbp), %rax
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	$0, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	$0, -372(%rbp)
	leaq	-208(%rbp), %rax
	leaq	-372(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-240(%rbp), %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -368(%rbp)
	movq	%xmm0, -352(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -368(%rbp)
	movl	$1, -356(%rbp)
	leaq	-128(%rbp), %rax
	leaq	-368(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -304(%rbp)
	movq	%xmm0, -288(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -304(%rbp)
	movl	$1, -292(%rbp)
	leaq	-80(%rbp), %rax
	leaq	-304(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-424(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -416(%rbp)
	movq	%rdx, -408(%rbp)
	movq	32(%rbp), %rax
	movq	40(%rbp), %rdx
	movq	%rax, -400(%rbp)
	movq	%rdx, -392(%rbp)
	movl	-396(%rbp), %edx
	movq	-408(%rbp), %rax
	movq	-424(%rbp), %rcx
	movq	120(%rcx), %rcx
	addq	$8, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	array_push_many
	movq	-240(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -373(%rbp)
	movq	-424(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-373(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2237
.L2235:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-224(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2237:
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC230:
	.string	"CL"
	.text
	.globl	encoder__Encoder_shift
	.hidden	encoder__Encoder_shift
encoder__Encoder_shift:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$1736, %rsp
	movq	%rdi, -1704(%rbp)
	movl	%esi, -1708(%rbp)
	movl	%edx, %eax
	movl	%ecx, -1716(%rbp)
	movb	%al, -1712(%rbp)
	movl	-1708(%rbp), %edx
	movq	-1704(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-1152(%rbp), %rax
	movq	-1704(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	movq	-1704(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$3, %eax
	je	.L2239
	cmpl	$0, -1716(%rbp)
	jne	.L2240
	movl	$-48, %eax
	jmp	.L2241
.L2240:
	movl	$-47, %eax
.L2241:
	movb	%al, -49(%rbp)
	movl	-1144(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2242
	movq	-1152(%rbp), %rax
	movl	-1716(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1716(%rbp), %eax
	movl	%eax, -1316(%rbp)
	leaq	-1120(%rbp), %rax
	leaq	-1316(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1152(%rbp), %rdx
	leaq	-1088(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1312(%rbp)
	movq	%xmm0, -1296(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1312(%rbp)
	movl	$1, -1300(%rbp)
	leaq	-1040(%rbp), %rax
	leaq	-1312(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1248(%rbp)
	movq	%xmm0, -1232(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1248(%rbp)
	movl	$1, -1236(%rbp)
	leaq	-992(%rbp), %rax
	leaq	-1248(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1704(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1120(%rbp), %rax
	movq	-1112(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1104(%rbp), %rax
	movq	-1096(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1088(%rbp), %rcx
	movq	-1080(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1072(%rbp), %rcx
	movq	-1064(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1056(%rbp), %rcx
	movq	-1048(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-1040(%rbp), %rcx
	movq	-1032(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-1024(%rbp), %rcx
	movq	-1016(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-1008(%rbp), %rcx
	movq	-1000(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-992(%rbp), %rcx
	movq	-984(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-976(%rbp), %rcx
	movq	-968(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-960(%rbp), %rcx
	movq	-952(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-49(%rbp), %eax
	movb	%al, -1317(%rbp)
	movq	-1704(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1317(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1152(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movzbl	-1712(%rbp), %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1318(%rbp)
	movq	-1704(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1318(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2243
.L2242:
	movl	-1144(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2239
	movq	-1152(%rbp), %rax
	movq	-1704(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1716(%rbp), %eax
	movl	%eax, -1380(%rbp)
	leaq	-944(%rbp), %rax
	leaq	-1380(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1152(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-912(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1152(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-864(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1376(%rbp)
	movq	%xmm0, -1360(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1376(%rbp)
	movl	$1, -1364(%rbp)
	leaq	-816(%rbp), %rax
	leaq	-1376(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1704(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-928(%rbp), %rax
	movq	-920(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-912(%rbp), %rcx
	movq	-904(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-896(%rbp), %rcx
	movq	-888(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-880(%rbp), %rcx
	movq	-872(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-864(%rbp), %rcx
	movq	-856(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-848(%rbp), %rcx
	movq	-840(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-832(%rbp), %rcx
	movq	-824(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-816(%rbp), %rcx
	movq	-808(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-800(%rbp), %rcx
	movq	-792(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-784(%rbp), %rcx
	movq	-776(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-49(%rbp), %eax
	movb	%al, -1381(%rbp)
	movq	-1704(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1381(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movzbl	-1712(%rbp), %esi
	movq	-1152(%rbp), %rax
	movq	-1704(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2243
.L2239:
	movq	-1704(%rbp), %rax
	movl	$3, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	leaq	-1184(%rbp), %rax
	movq	-1704(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	movl	-1144(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2244
	leaq	.LC230(%rip), %rax
	movq	%rax, -1744(%rbp)
	movq	-1736(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -1736(%rbp)
	movq	-1736(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -1736(%rbp)
	movq	-1152(%rbp), %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rax
	movq	-1744(%rbp), %rdx
	movq	-1736(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2245
	leaq	.LC220(%rip), %rax
	movq	%rax, -1760(%rbp)
	movq	-1752(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, -1752(%rbp)
	movq	-1752(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -1752(%rbp)
	movq	-1152(%rbp), %rcx
	movq	-1760(%rbp), %rax
	movq	-1752(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2245:
	cmpl	$0, -1716(%rbp)
	jne	.L2246
	movl	$-46, %eax
	jmp	.L2247
.L2246:
	movl	$-45, %eax
.L2247:
	movb	%al, -50(%rbp)
	movl	-1176(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2248
	movq	-1184(%rbp), %rax
	movl	-1716(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1716(%rbp), %eax
	movl	%eax, -1444(%rbp)
	leaq	-768(%rbp), %rax
	leaq	-1444(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1184(%rbp), %rdx
	leaq	-736(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1440(%rbp)
	movq	%xmm0, -1424(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1440(%rbp)
	movl	$1, -1428(%rbp)
	leaq	-688(%rbp), %rax
	leaq	-1440(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1152(%rbp), %rdx
	leaq	-640(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1704(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-768(%rbp), %rax
	movq	-760(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-752(%rbp), %rax
	movq	-744(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-736(%rbp), %rcx
	movq	-728(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-720(%rbp), %rcx
	movq	-712(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-704(%rbp), %rcx
	movq	-696(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-688(%rbp), %rcx
	movq	-680(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-672(%rbp), %rcx
	movq	-664(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-656(%rbp), %rcx
	movq	-648(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-640(%rbp), %rcx
	movq	-632(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-624(%rbp), %rcx
	movq	-616(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-608(%rbp), %rcx
	movq	-600(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-50(%rbp), %eax
	movb	%al, -1445(%rbp)
	movq	-1704(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1445(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1184(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movzbl	-1712(%rbp), %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1446(%rbp)
	movq	-1704(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1446(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2243
.L2248:
	movl	-1176(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2244
	movq	-1184(%rbp), %rax
	movq	-1704(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1716(%rbp), %eax
	movl	%eax, -1452(%rbp)
	leaq	-592(%rbp), %rax
	leaq	-1452(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1184(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-560(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1184(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-512(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1152(%rbp), %rdx
	leaq	-464(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1704(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-576(%rbp), %rax
	movq	-568(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-560(%rbp), %rcx
	movq	-552(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-544(%rbp), %rcx
	movq	-536(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-528(%rbp), %rcx
	movq	-520(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-512(%rbp), %rcx
	movq	-504(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-496(%rbp), %rcx
	movq	-488(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-480(%rbp), %rcx
	movq	-472(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-464(%rbp), %rcx
	movq	-456(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-448(%rbp), %rcx
	movq	-440(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-432(%rbp), %rcx
	movq	-424(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-50(%rbp), %eax
	movb	%al, -1453(%rbp)
	movq	-1704(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1453(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movzbl	-1712(%rbp), %esi
	movq	-1184(%rbp), %rax
	movq	-1704(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2243
.L2244:
	movl	-1144(%rbp), %eax
	cmpl	$169, %eax
	jne	.L2249
	leaq	-1696(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-1152(%rbp), %rcx
	leaq	-1696(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -56(%rbp)
	movl	-1676(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2250
	leaq	.LC221(%rip), %rax
	movq	%rax, -1776(%rbp)
	movq	-1768(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$25, %rax
	movq	%rax, -1768(%rbp)
	movq	-1768(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -1768(%rbp)
	movq	-1152(%rbp), %rax
	movq	16(%rax), %rcx
	movq	-1776(%rbp), %rax
	movq	-1768(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2250:
	movl	-1676(%rbp), %eax
	cmpl	$1, %eax
	sete	%al
	movb	%al, -57(%rbp)
	cmpl	$1, -56(%rbp)
	jne	.L2251
	cmpb	$0, -57(%rbp)
	jne	.L2251
	cmpl	$0, -1716(%rbp)
	jne	.L2252
	movl	$-48, %eax
	jmp	.L2254
.L2252:
	movl	$-47, %eax
	jmp	.L2254
.L2251:
	cmpl	$0, -1716(%rbp)
	jne	.L2255
	movl	$-64, %eax
	jmp	.L2254
.L2255:
	movl	$-63, %eax
.L2254:
	movb	%al, -58(%rbp)
	movl	-1176(%rbp), %eax
	cmpl	$165, %eax
	jne	.L2257
	movq	-1184(%rbp), %rax
	movl	-1716(%rbp), %esi
	subq	$48, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movl	%esi, %edi
	call	encoder__Register_check_regi_size
	addq	$48, %rsp
	movl	-1716(%rbp), %eax
	movl	%eax, -1588(%rbp)
	leaq	-416(%rbp), %rax
	leaq	-1588(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1184(%rbp), %rdx
	leaq	-384(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1584(%rbp)
	movq	%xmm0, -1568(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1584(%rbp)
	movl	$1, -1572(%rbp)
	leaq	-336(%rbp), %rax
	leaq	-1584(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1520(%rbp)
	movq	%xmm0, -1504(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1520(%rbp)
	movl	$1, -1508(%rbp)
	leaq	-288(%rbp), %rax
	leaq	-1520(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1704(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-416(%rbp), %rax
	movq	-408(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-384(%rbp), %rcx
	movq	-376(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-368(%rbp), %rcx
	movq	-360(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-352(%rbp), %rcx
	movq	-344(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-336(%rbp), %rcx
	movq	-328(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-320(%rbp), %rcx
	movq	-312(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-304(%rbp), %rcx
	movq	-296(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-288(%rbp), %rcx
	movq	-280(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-272(%rbp), %rcx
	movq	-264(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-256(%rbp), %rcx
	movq	-248(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-58(%rbp), %eax
	movb	%al, -1589(%rbp)
	movq	-1704(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1589(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-1184(%rbp), %rax
	movzbl	20(%rax), %eax
	movzbl	%al, %eax
	andl	$7, %eax
	movl	%eax, %edx
	movzbl	-1712(%rbp), %ecx
	movl	$3, %eax
	movzbl	%al, %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -1590(%rbp)
	movq	-1704(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1590(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2258
.L2257:
	movl	-1176(%rbp), %eax
	cmpl	$168, %eax
	jne	.L2259
	movq	-1184(%rbp), %rax
	movq	-1704(%rbp), %rsi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_segment_override_prefix
	addq	$176, %rsp
	movl	-1716(%rbp), %eax
	movl	%eax, -1652(%rbp)
	leaq	-240(%rbp), %rax
	leaq	-1652(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-1184(%rbp), %rax
	leaq	24(%rax), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	movq	-1184(%rbp), %rax
	leaq	72(%rax), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__RegiAll
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -1648(%rbp)
	movq	%xmm0, -1632(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -1648(%rbp)
	movl	$1, -1636(%rbp)
	leaq	-112(%rbp), %rax
	leaq	-1648(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Empty_to_sumtype_encoder__RegiAll
	movq	-1704(%rbp), %rsi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	subq	$48, %rsp
	movq	%rsp, %rax
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	%rsi, %rdi
	call	encoder__Encoder_add_prefix
	addq	$176, %rsp
	movzbl	-58(%rbp), %eax
	movb	%al, -1653(%rbp)
	movq	-1704(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1653(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movzbl	-1712(%rbp), %esi
	movq	-1184(%rbp), %rax
	movq	-1704(%rbp), %rdi
	subq	$176, %rsp
	movq	%rsp, %rdx
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	movq	48(%rax), %rcx
	movq	56(%rax), %rbx
	movq	%rcx, 48(%rdx)
	movq	%rbx, 56(%rdx)
	movq	64(%rax), %rcx
	movq	72(%rax), %rbx
	movq	%rcx, 64(%rdx)
	movq	%rbx, 72(%rdx)
	movq	80(%rax), %rcx
	movq	88(%rax), %rbx
	movq	%rcx, 80(%rdx)
	movq	%rbx, 88(%rdx)
	movq	96(%rax), %rcx
	movq	104(%rax), %rbx
	movq	%rcx, 96(%rdx)
	movq	%rbx, 104(%rdx)
	movq	112(%rax), %rcx
	movq	120(%rax), %rbx
	movq	%rcx, 112(%rdx)
	movq	%rbx, 120(%rdx)
	movq	128(%rax), %rcx
	movq	136(%rax), %rbx
	movq	%rcx, 128(%rdx)
	movq	%rbx, 136(%rdx)
	movq	144(%rax), %rcx
	movq	152(%rax), %rbx
	movq	%rcx, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	160(%rax), %rcx
	movq	168(%rax), %rbx
	movq	%rcx, 160(%rdx)
	movq	%rbx, 168(%rdx)
	call	encoder__Encoder_add_modrm_sib_disp
	addq	$176, %rsp
	jmp	.L2258
.L2259:
	leaq	.LC220(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	-1168(%rbp), %rcx
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2258:
	cmpb	$0, -57(%rbp)
	je	.L2260
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1696(%rbp), %rax
	movq	-1688(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1680(%rbp), %rax
	movq	-1672(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	movq	-1704(%rbp), %rax
	movl	$0, %r8d
	movl	$0, %ecx
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_rela
	jmp	.L2243
.L2260:
	cmpl	$1, -56(%rbp)
	je	.L2243
	movl	-56(%rbp), %eax
	movzbl	%al, %ecx
	movq	-1704(%rbp), %rax
	movl	$0, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_add_imm_value
	jmp	.L2243
.L2249:
	leaq	.LC220(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$31, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-1136(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2243:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC231:
	.string	"symbol `"
.LC232:
	.string	"` is already defined"
	.text
	.globl	encoder__Encoder_add_section
	.hidden	encoder__Encoder_add_section
encoder__Encoder_add_section:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$696, %rsp
	movq	%rdi, -648(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -672(%rbp)
	movq	%rdx, -664(%rbp)
	movq	%rcx, %rax
	movq	%r8, %rcx
	movq	%rcx, %rdx
	movq	%rax, -688(%rbp)
	movq	%rdx, -680(%rbp)
	movq	-648(%rbp), %rcx
	movq	-672(%rbp), %rax
	movq	-664(%rbp), %rdx
	movq	%rax, 104(%rcx)
	movq	%rdx, 112(%rcx)
	leaq	-336(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$1, -336(%rbp)
	leaq	-328(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	.LC34(%rip), %rax
	movq	%rax, -296(%rbp)
	movl	$1, -284(%rbp)
	movq	-688(%rbp), %rax
	movq	-680(%rbp), %rdx
	movq	%rax, -280(%rbp)
	movq	%rdx, -272(%rbp)
	movb	$3, -254(%rbp)
	movq	-672(%rbp), %rax
	movq	-664(%rbp), %rdx
	movq	%rax, -248(%rbp)
	movq	%rdx, -240(%rbp)
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, -224(%rbp)
	movq	%rdx, -216(%rbp)
	movq	32(%rbp), %rax
	movq	%rax, -208(%rbp)
	leaq	-336(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -344(%rbp)
	movq	-648(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-344(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-672(%rbp), %rax
	movq	-664(%rbp), %rdx
	movq	%rax, -480(%rbp)
	movq	%rdx, -472(%rbp)
	movq	-648(%rbp), %rax
	movq	192(%rax), %rcx
	movq	200(%rax), %rbx
	movq	%rcx, -464(%rbp)
	movq	%rbx, -456(%rbp)
	movq	208(%rax), %rcx
	movq	216(%rax), %rbx
	movq	%rcx, -448(%rbp)
	movq	%rbx, -440(%rbp)
	movq	224(%rax), %rcx
	movq	232(%rax), %rbx
	movq	%rcx, -432(%rbp)
	movq	%rbx, -424(%rbp)
	movq	240(%rax), %rcx
	movq	248(%rax), %rbx
	movq	%rcx, -416(%rbp)
	movq	%rbx, -408(%rbp)
	movq	256(%rax), %rcx
	movq	264(%rax), %rbx
	movq	%rcx, -400(%rbp)
	movq	%rbx, -392(%rbp)
	movq	272(%rax), %rcx
	movq	280(%rax), %rbx
	movq	%rcx, -384(%rbp)
	movq	%rbx, -376(%rbp)
	movq	288(%rax), %rcx
	movq	296(%rax), %rbx
	movq	%rcx, -368(%rbp)
	movq	%rbx, -360(%rbp)
	movq	304(%rax), %rax
	movq	%rax, -352(%rbp)
	leaq	-480(%rbp), %rdx
	leaq	-464(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_get_check
	movq	%rax, -48(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -528(%rbp)
	movaps	%xmm0, -512(%rbp)
	movaps	%xmm0, -496(%rbp)
	cmpq	$0, -48(%rbp)
	je	.L2264
	leaq	-528(%rbp), %rax
	leaq	40(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	jmp	.L2265
.L2264:
	movb	$2, -528(%rbp)
	leaq	.LC215(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$24, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-720(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-720(%rbp), %rax
	movq	-712(%rbp), %rdx
	movq	%rax, -520(%rbp)
	movq	%rdx, -512(%rbp)
	movq	-704(%rbp), %rax
	movq	-696(%rbp), %rdx
	movq	%rax, -504(%rbp)
	movq	%rdx, -496(%rbp)
.L2265:
	movzbl	-528(%rbp), %eax
	testb	%al, %al
	jne	.L2266
	leaq	-528(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$107, %eax
	jne	.L2268
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -640(%rbp)
	movaps	%xmm0, -624(%rbp)
	movaps	%xmm0, -608(%rbp)
	movaps	%xmm0, -592(%rbp)
	movaps	%xmm0, -576(%rbp)
	leaq	.LC231(%rip), %rax
	movq	%rax, -640(%rbp)
	movl	$8, -632(%rbp)
	movl	$1, -628(%rbp)
	movl	$65040, -624(%rbp)
	movq	-672(%rbp), %rax
	movq	-664(%rbp), %rdx
	movq	%rax, -616(%rbp)
	movq	%rdx, -608(%rbp)
	leaq	.LC232(%rip), %rax
	movq	%rax, -600(%rbp)
	movl	$20, -592(%rbp)
	movl	$1, -588(%rbp)
	leaq	-640(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	32(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2266:
	movq	-520(%rbp), %rax
	movq	-512(%rbp), %rdx
	movq	%rax, -640(%rbp)
	movq	%rdx, -632(%rbp)
	movq	-504(%rbp), %rax
	movq	-496(%rbp), %rdx
	movq	%rax, -624(%rbp)
	movq	%rdx, -616(%rbp)
	movq	$0, -552(%rbp)
	movq	-672(%rbp), %rax
	movq	-664(%rbp), %rdx
	movq	%rax, -544(%rbp)
	movq	%rdx, -536(%rbp)
	movq	-648(%rbp), %rax
	leaq	192(%rax), %rcx
	leaq	-552(%rbp), %rdx
	leaq	-544(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	map_get_and_set
	movq	-40(%rbp), %rdx
	movq	%rdx, (%rax)
.L2268:
	nop
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	encoder__Encoder_section
	.hidden	encoder__Encoder_section
encoder__Encoder_section:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	-72(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -16(%rbp)
	movq	-72(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	movq	-72(%rbp), %rax
	movl	$3, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	movq	-72(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-72(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	movq	-64(%rbp), %r8
	movq	-56(%rbp), %r10
	movq	-48(%rbp), %rsi
	movq	-40(%rbp), %r9
	movq	-72(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-16(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rcx
	movq	%r10, %r8
	movq	%r9, %rdx
	call	encoder__Encoder_add_section
	addq	$32, %rsp
	nop
	leave
	ret
	.globl	encoder__Encoder_zero
	.hidden	encoder__Encoder_zero
encoder__Encoder_zero:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	-56(%rbp), %rax
	movl	$12, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-32(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-16(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	encoder__eval_expr
	addq	$32, %rsp
	movl	%eax, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L2271
.L2272:
	movb	$0, -33(%rbp)
	movq	-56(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-33(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	addl	$1, -4(%rbp)
.L2271:
	movl	-4(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jl	.L2272
	nop
	nop
	leave
	ret
	.globl	encoder__Encoder_string
	.hidden	encoder__Encoder_string
encoder__Encoder_string:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$88, %rsp
	movq	%rdi, -56(%rbp)
	movq	-56(%rbp), %rax
	movl	$7, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	movq	-56(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-56(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	movq	-56(%rbp), %rax
	movq	120(%rax), %rbx
	leaq	-96(%rbp), %rax
	movq	-32(%rbp), %rcx
	movq	-24(%rbp), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	string_bytes
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 8(%rbx)
	movq	%rdx, 16(%rbx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 24(%rbx)
	movq	%rdx, 32(%rbx)
	movb	$0, -33(%rbp)
	movq	-56(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-33(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC233:
	.string	"invalid operand"
	.text
	.globl	encoder__Encoder_byte
	.hidden	encoder__Encoder_byte
encoder__Encoder_byte:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$232, %rsp
	movq	%rdi, -216(%rbp)
	movq	-216(%rbp), %rax
	movl	$8, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-64(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	leaq	-96(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	-96(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -36(%rbp)
	movl	-76(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2275
	leaq	.LC233(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$15, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-48(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2275:
	movl	-76(%rbp), %eax
	cmpl	$1, %eax
	jne	.L2276
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
	movq	-216(%rbp), %rax
	movq	120(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	$0, -184(%rbp)
	movl	$14, %eax
	movq	%rax, -176(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -168(%rbp)
	movb	$0, -164(%rbp)
	leaq	-208(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -144(%rbp)
	movq	%rbx, -136(%rbp)
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	-216(%rbp), %rax
	leaq	160(%rax), %rdx
	leaq	-160(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movb	$0, -97(%rbp)
	movq	-216(%rbp), %rax
	movq	120(%rax), %rbx
	leaq	-256(%rbp), %rax
	leaq	-97(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rax, 8(%rbx)
	movq	%rdx, 16(%rbx)
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, 24(%rbx)
	movq	%rdx, 32(%rbx)
	jmp	.L2278
.L2276:
	movl	-36(%rbp), %eax
	movb	%al, -98(%rbp)
	movq	-216(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-98(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
.L2278:
	nop
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	encoder__Encoder_word
	.hidden	encoder__Encoder_word
encoder__Encoder_word:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$232, %rsp
	movq	%rdi, -216(%rbp)
	movq	-216(%rbp), %rax
	movl	$9, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-64(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	leaq	-96(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	-96(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -36(%rbp)
	movl	-76(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2280
	leaq	.LC233(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$15, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-48(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2280:
	movl	-76(%rbp), %eax
	cmpl	$1, %eax
	jne	.L2281
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
	movq	-216(%rbp), %rax
	movq	120(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	$0, -184(%rbp)
	movl	$12, %eax
	movq	%rax, -176(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -168(%rbp)
	movb	$0, -164(%rbp)
	leaq	-208(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -144(%rbp)
	movq	%rbx, -136(%rbp)
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	-216(%rbp), %rax
	leaq	160(%rax), %rdx
	leaq	-160(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movb	$0, -98(%rbp)
	movb	$0, -97(%rbp)
	movq	-216(%rbp), %rax
	movq	120(%rax), %rbx
	leaq	-256(%rbp), %rax
	leaq	-98(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rax, 8(%rbx)
	movq	%rdx, 16(%rbx)
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, 24(%rbx)
	movq	%rdx, 32(%rbx)
	jmp	.L2283
.L2281:
	movb	$0, -100(%rbp)
	movb	$0, -99(%rbp)
	leaq	-160(%rbp), %rax
	leaq	-100(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-36(%rbp), %eax
	movzwl	%ax, %edx
	leaq	-160(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoding__binary__little_endian_put_u16
	movq	-216(%rbp), %rax
	movq	120(%rax), %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
.L2283:
	nop
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	encoder__Encoder_long
	.hidden	encoder__Encoder_long
encoder__Encoder_long:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$232, %rsp
	movq	%rdi, -216(%rbp)
	movq	-216(%rbp), %rax
	movl	$10, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-64(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	leaq	-96(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	-96(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -36(%rbp)
	movl	-76(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2285
	leaq	.LC233(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$15, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-48(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2285:
	movl	-76(%rbp), %eax
	cmpl	$1, %eax
	jne	.L2286
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
	movq	-216(%rbp), %rax
	movq	120(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	$0, -184(%rbp)
	movl	$10, %eax
	movq	%rax, -176(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -168(%rbp)
	movb	$0, -164(%rbp)
	leaq	-208(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -144(%rbp)
	movq	%rbx, -136(%rbp)
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	-216(%rbp), %rax
	leaq	160(%rax), %rdx
	leaq	-160(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movb	$0, -100(%rbp)
	movb	$0, -99(%rbp)
	movb	$0, -98(%rbp)
	movb	$0, -97(%rbp)
	movq	-216(%rbp), %rax
	movq	120(%rax), %rbx
	leaq	-256(%rbp), %rax
	leaq	-100(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$4, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rax, 8(%rbx)
	movq	%rdx, 16(%rbx)
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, 24(%rbx)
	movq	%rdx, 32(%rbx)
	jmp	.L2288
.L2286:
	movb	$0, -104(%rbp)
	movb	$0, -103(%rbp)
	movb	$0, -102(%rbp)
	movb	$0, -101(%rbp)
	leaq	-160(%rbp), %rax
	leaq	-104(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$4, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-36(%rbp), %edx
	leaq	-160(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoding__binary__little_endian_put_u32
	movq	-216(%rbp), %rax
	movq	120(%rax), %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
.L2288:
	nop
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	encoder__Encoder_quad
	.hidden	encoder__Encoder_quad
encoder__Encoder_quad:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$248, %rsp
	movq	%rdi, -232(%rbp)
	movq	-232(%rbp), %rax
	movl	$11, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_set_current_instr
	leaq	-80(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	leaq	-112(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	-112(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-64(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -36(%rbp)
	movl	-92(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2290
	leaq	.LC233(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$15, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	-64(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2290:
	movl	-92(%rbp), %eax
	cmpl	$1, %eax
	jne	.L2291
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$0, %edi
	call	array_get
	addq	$32, %rsp
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -224(%rbp)
	movq	%rdx, -216(%rbp)
	movq	-232(%rbp), %rax
	movq	120(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	$0, -200(%rbp)
	movl	$1, %eax
	movq	%rax, -192(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -184(%rbp)
	movb	$0, -180(%rbp)
	leaq	-224(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -48(%rbp)
	movq	$0, -120(%rbp)
	movq	-232(%rbp), %rax
	movq	120(%rax), %rbx
	leaq	-272(%rbp), %rax
	leaq	-120(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$8, %edx
	movl	$8, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-272(%rbp), %rax
	movq	-264(%rbp), %rdx
	movq	%rax, 8(%rbx)
	movq	%rdx, 16(%rbx)
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rax, 24(%rbx)
	movq	%rdx, 32(%rbx)
	movq	-48(%rbp), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -176(%rbp)
	movq	%rbx, -168(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	movq	-232(%rbp), %rax
	leaq	160(%rax), %rdx
	leaq	-176(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2293
.L2291:
	movq	$0, -128(%rbp)
	leaq	-176(%rbp), %rax
	leaq	-128(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$8, %edx
	movl	$8, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoding__binary__little_endian_put_u64
	movq	-232(%rbp), %rax
	movq	120(%rax), %rcx
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
.L2293:
	nop
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC234:
	.string	".text"
.LC235:
	.string	"aw"
.LC236:
	.string	".bss"
.LC237:
	.string	".data"
.LC238:
	.string	"ax"
	.text
	.globl	encoder__new
encoder__new:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$600, %rsp
	movq	%rdi, -552(%rbp)
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rdx
	movq	%rax, -576(%rbp)
	movq	%rdx, -568(%rbp)
	leaq	-112(%rbp), %rax
	movq	-552(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_lex
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -544(%rbp)
	movq	%rdx, -536(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, -528(%rbp)
	movq	%rdx, -520(%rbp)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, -512(%rbp)
	movq	%rdx, -504(%rbp)
	movq	-552(%rbp), %rcx
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, -496(%rbp)
	movq	%rdx, -488(%rbp)
	movq	16(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	%rax, -480(%rbp)
	movq	%rdx, -472(%rbp)
	movq	32(%rcx), %rax
	movq	40(%rcx), %rdx
	movq	%rax, -464(%rbp)
	movq	%rdx, -456(%rbp)
	movq	48(%rcx), %rax
	movq	%rax, -448(%rbp)
	leaq	.LC234(%rip), %rax
	movq	%rax, -440(%rbp)
	movl	$5, -432(%rbp)
	movl	$1, -428(%rbp)
	movq	$0, -424(%rbp)
	leaq	-416(%rbp), %rax
	movl	$0, %r8d
	movl	$8, %ecx
	movl	$1500000, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	-384(%rbp), %rax
	movl	$48, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array
	leaq	-352(%rbp), %rdi
	subq	$8, %rsp
	leaq	map_free_string(%rip), %rax
	pushq	%rax
	leaq	map_clone_string(%rip), %r9
	leaq	map_eq_string(%rip), %r8
	leaq	map_hash_string(%rip), %rax
	movq	%rax, %rcx
	movl	$8, %edx
	movl	$16, %esi
	call	new_map
	addq	$16, %rsp
	leaq	-232(%rbp), %rdi
	subq	$8, %rsp
	leaq	map_free_string(%rip), %rax
	pushq	%rax
	leaq	map_clone_string(%rip), %r9
	leaq	map_eq_string(%rip), %r8
	leaq	map_hash_string(%rip), %rax
	movq	%rax, %rcx
	movl	$8, %edx
	movl	$16, %esi
	call	new_map
	addq	$16, %rsp
	leaq	-544(%rbp), %rax
	movl	$432, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -56(%rbp)
	leaq	.LC235(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	.LC236(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rcx, %r8
	movq	%rdx, %r10
	movq	%r14, %rcx
	movq	%r15, %rbx
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rcx, %rsi
	movq	%rdx, %r9
	movq	-56(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-104(%rbp), %rax
	movq	-96(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-88(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rcx
	movq	%r10, %r8
	movq	%r9, %rdx
	call	encoder__Encoder_add_section
	addq	$32, %rsp
	leaq	.LC235(%rip), %rax
	movq	%rax, -608(%rbp)
	movq	-600(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -600(%rbp)
	movq	-600(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -600(%rbp)
	leaq	.LC237(%rip), %rax
	movq	%rax, -592(%rbp)
	movq	-584(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -584(%rbp)
	movq	-584(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -584(%rbp)
	movq	-608(%rbp), %rax
	movq	-600(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %r8
	movq	%rdx, %r10
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %r9
	movq	-56(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-104(%rbp), %rax
	movq	-96(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-88(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rcx
	movq	%r10, %r8
	movq	%r9, %rdx
	call	encoder__Encoder_add_section
	addq	$32, %rsp
	leaq	.LC238(%rip), %rax
	movq	%rax, -640(%rbp)
	movq	-632(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -632(%rbp)
	movq	-632(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -632(%rbp)
	leaq	.LC234(%rip), %rax
	movq	%rax, -624(%rbp)
	movq	-616(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -616(%rbp)
	movq	-616(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -616(%rbp)
	movq	-640(%rbp), %rax
	movq	-632(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %r8
	movq	%rdx, %r10
	movq	-624(%rbp), %rax
	movq	-616(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %r9
	movq	-56(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-104(%rbp), %rax
	movq	-96(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-88(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rcx
	movq	%r10, %r8
	movq	%r9, %rdx
	call	encoder__Encoder_add_section
	addq	$32, %rsp
	movq	-56(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_set_current_instr
	.hidden	encoder__Encoder_set_current_instr
encoder__Encoder_set_current_instr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$176, %rsp
	movq	%rdi, -168(%rbp)
	movl	%esi, -172(%rbp)
	leaq	-144(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	-172(%rbp), %eax
	movl	%eax, -144(%rbp)
	leaq	-136(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	.LC34(%rip), %rax
	movq	%rax, -104(%rbp)
	movl	$1, -92(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -88(%rbp)
	movl	$1, -76(%rbp)
	movq	-168(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	%rdx, -48(%rbp)
	movq	-168(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -16(%rbp)
	leaq	-144(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -8(%rbp)
	movq	-168(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 120(%rax)
	movq	-8(%rbp), %rax
	movq	%rax, -152(%rbp)
	movq	-168(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-152(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	nop
	leave
	ret
	.globl	encoder__Encoder_next
	.hidden	encoder__Encoder_next
encoder__Encoder_next:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$72, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	leaq	48(%rax), %rdx
	movq	-24(%rbp), %rbx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	lexer__Lexer_lex
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, (%rbx)
	movq	%rdx, 8(%rbx)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 16(%rbx)
	movq	%rdx, 24(%rbx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 32(%rbx)
	movq	%rdx, 40(%rbx)
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	encoder__Encoder_expect
	.hidden	encoder__Encoder_expect
encoder__Encoder_expect:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$104, %rsp
	movq	%rdi, -104(%rbp)
	movl	%esi, -108(%rbp)
	movq	-104(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, -108(%rbp)
	je	.L2299
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -96(%rbp)
	movaps	%xmm0, -80(%rbp)
	movaps	%xmm0, -64(%rbp)
	movaps	%xmm0, -48(%rbp)
	movaps	%xmm0, -32(%rbp)
	leaq	.LC213(%rip), %rax
	movq	%rax, -96(%rbp)
	movl	$18, -88(%rbp)
	movl	$1, -84(%rbp)
	movl	$65040, -80(%rbp)
	movq	-104(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	%rdx, -64(%rbp)
	leaq	.LC89(%rip), %rax
	movq	%rax, -56(%rbp)
	movl	$1, -48(%rbp)
	movl	$1, -44(%rbp)
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	movq	-104(%rbp), %rcx
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	24(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2299:
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC239:
	.string	"unkown register `"
	.text
	.globl	encoder__Encoder_parse_register
	.hidden	encoder__Encoder_parse_register
encoder__Encoder_parse_register:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$728, %rsp
	movq	%rdi, -728(%rbp)
	movq	%rsi, -736(%rbp)
	movq	-736(%rbp), %rax
	movl	$11, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	movq	-736(%rbp), %rax
	movq	32(%rax), %rdx
	movq	40(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, -224(%rbp)
	movq	%rdx, -216(%rbp)
	movq	_const_encoder__xmm_registers(%rip), %rax
	movq	8+_const_encoder__xmm_registers(%rip), %rdx
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
	movq	16+_const_encoder__xmm_registers(%rip), %rax
	movq	24+_const_encoder__xmm_registers(%rip), %rdx
	movq	%rax, -192(%rbp)
	movq	%rdx, -184(%rbp)
	movq	32+_const_encoder__xmm_registers(%rip), %rax
	movq	40+_const_encoder__xmm_registers(%rip), %rdx
	movq	%rax, -176(%rbp)
	movq	%rdx, -168(%rbp)
	movq	48+_const_encoder__xmm_registers(%rip), %rax
	movq	56+_const_encoder__xmm_registers(%rip), %rdx
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	movq	64+_const_encoder__xmm_registers(%rip), %rax
	movq	72+_const_encoder__xmm_registers(%rip), %rdx
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	movq	80+_const_encoder__xmm_registers(%rip), %rax
	movq	88+_const_encoder__xmm_registers(%rip), %rdx
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	96+_const_encoder__xmm_registers(%rip), %rax
	movq	104+_const_encoder__xmm_registers(%rip), %rdx
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movq	112+_const_encoder__xmm_registers(%rip), %rax
	movq	%rax, -96(%rbp)
	leaq	-224(%rbp), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_get_check
	movq	%rax, -56(%rbp)
	leaq	-320(%rbp), %rdx
	movl	$0, %eax
	movl	$11, %ecx
	movq	%rdx, %rdi
	rep stosq
	cmpq	$0, -56(%rbp)
	je	.L2301
	leaq	-320(%rbp), %rax
	leaq	40(%rax), %rdx
	movq	-56(%rbp), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	jmp	.L2302
.L2301:
	movb	$2, -320(%rbp)
	leaq	.LC215(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$24, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	leaq	-768(%rbp), %rax
	movq	%r14, %rsi
	movq	%r15, %rdi
	movq	%r14, %rcx
	movq	%r15, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-768(%rbp), %rax
	movq	-760(%rbp), %rdx
	movq	%rax, -312(%rbp)
	movq	%rdx, -304(%rbp)
	movq	-752(%rbp), %rax
	movq	-744(%rbp), %rdx
	movq	%rax, -296(%rbp)
	movq	%rdx, -288(%rbp)
.L2302:
	movzbl	-320(%rbp), %eax
	testb	%al, %al
	jne	.L2303
	leaq	-320(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -720(%rbp)
	movq	%rbx, -712(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -704(%rbp)
	movq	%rbx, -696(%rbp)
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -688(%rbp)
	movq	%rdx, -680(%rbp)
	movq	-736(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -680(%rbp)
	movq	-736(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	movq	-728(%rbp), %rax
	leaq	-720(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Xmm_to_sumtype_encoder__Expr
	jmp	.L2304
.L2303:
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, -464(%rbp)
	movq	%rdx, -456(%rbp)
	movq	_const_encoder__general_registers(%rip), %rax
	movq	8+_const_encoder__general_registers(%rip), %rdx
	movq	%rax, -448(%rbp)
	movq	%rdx, -440(%rbp)
	movq	16+_const_encoder__general_registers(%rip), %rax
	movq	24+_const_encoder__general_registers(%rip), %rdx
	movq	%rax, -432(%rbp)
	movq	%rdx, -424(%rbp)
	movq	32+_const_encoder__general_registers(%rip), %rax
	movq	40+_const_encoder__general_registers(%rip), %rdx
	movq	%rax, -416(%rbp)
	movq	%rdx, -408(%rbp)
	movq	48+_const_encoder__general_registers(%rip), %rax
	movq	56+_const_encoder__general_registers(%rip), %rdx
	movq	%rax, -400(%rbp)
	movq	%rdx, -392(%rbp)
	movq	64+_const_encoder__general_registers(%rip), %rax
	movq	72+_const_encoder__general_registers(%rip), %rdx
	movq	%rax, -384(%rbp)
	movq	%rdx, -376(%rbp)
	movq	80+_const_encoder__general_registers(%rip), %rax
	movq	88+_const_encoder__general_registers(%rip), %rdx
	movq	%rax, -368(%rbp)
	movq	%rdx, -360(%rbp)
	movq	96+_const_encoder__general_registers(%rip), %rax
	movq	104+_const_encoder__general_registers(%rip), %rdx
	movq	%rax, -352(%rbp)
	movq	%rdx, -344(%rbp)
	movq	112+_const_encoder__general_registers(%rip), %rax
	movq	%rax, -336(%rbp)
	leaq	-464(%rbp), %rdx
	leaq	-448(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_get_check
	movq	%rax, -64(%rbp)
	leaq	-560(%rbp), %rdx
	movl	$0, %eax
	movl	$11, %ecx
	movq	%rdx, %rdi
	rep stosq
	cmpq	$0, -64(%rbp)
	je	.L2305
	leaq	-560(%rbp), %rax
	leaq	40(%rax), %rdx
	movq	-64(%rbp), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, (%rdx)
	movq	%rbx, 8(%rdx)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16(%rdx)
	movq	%rbx, 24(%rdx)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32(%rdx)
	movq	%rbx, 40(%rdx)
	jmp	.L2306
.L2305:
	movb	$2, -560(%rbp)
	leaq	.LC215(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$24, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	-768(%rbp), %rax
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%rbx, %rdx
	movq	%rax, %rdi
	call	_v_error
	movq	-768(%rbp), %rax
	movq	-760(%rbp), %rdx
	movq	%rax, -552(%rbp)
	movq	%rdx, -544(%rbp)
	movq	-752(%rbp), %rax
	movq	-744(%rbp), %rdx
	movq	%rax, -536(%rbp)
	movq	%rdx, -528(%rbp)
.L2306:
	movzbl	-560(%rbp), %eax
	testb	%al, %al
	jne	.L2307
	leaq	-560(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -720(%rbp)
	movq	%rbx, -712(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -704(%rbp)
	movq	%rbx, -696(%rbp)
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -688(%rbp)
	movq	%rdx, -680(%rbp)
	movq	-736(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -680(%rbp)
	movq	-736(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	movq	-728(%rbp), %rax
	leaq	-720(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Register_to_sumtype_encoder__Expr
	jmp	.L2304
.L2307:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -640(%rbp)
	movaps	%xmm0, -624(%rbp)
	movaps	%xmm0, -608(%rbp)
	movaps	%xmm0, -592(%rbp)
	movaps	%xmm0, -576(%rbp)
	leaq	.LC239(%rip), %rax
	movq	%rax, -640(%rbp)
	movl	$17, -632(%rbp)
	movl	$1, -628(%rbp)
	movl	$65040, -624(%rbp)
	movq	-736(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -616(%rbp)
	movq	%rdx, -608(%rbp)
	leaq	.LC89(%rip), %rax
	movq	%rax, -600(%rbp)
	movl	$1, -592(%rbp)
	movl	$1, -588(%rbp)
	leaq	-640(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	movq	-736(%rbp), %rcx
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	24(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2304:
	movq	-728(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_parse_factor
	.hidden	encoder__Encoder_parse_factor
encoder__Encoder_parse_factor:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$296, %rsp
	movq	%rdi, -296(%rbp)
	movq	%rsi, -304(%rbp)
	movq	-304(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$1, %eax
	jne	.L2310
	movq	-304(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-304(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	movq	-304(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -272(%rbp)
	movq	%rdx, -264(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -256(%rbp)
	leaq	-96(%rbp), %rax
	leaq	-288(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Number_to_sumtype_encoder__Expr
	movq	-296(%rbp), %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-80(%rbp), %rax
	movq	%rax, 16(%rcx)
	jmp	.L2309
.L2310:
	movq	-304(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jne	.L2312
	movq	-304(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -112(%rbp)
	movq	%rdx, -104(%rbp)
	movq	-304(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	movq	-304(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -272(%rbp)
	movq	%rdx, -264(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -256(%rbp)
	leaq	-144(%rbp), %rax
	leaq	-288(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Ident_to_sumtype_encoder__Expr
	movq	-296(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-128(%rbp), %rax
	movq	%rax, 16(%rcx)
	jmp	.L2309
.L2312:
	movq	-304(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$8, %eax
	jne	.L2313
	movq	-304(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	leaq	-176(%rbp), %rax
	movq	-304(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_factor
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, -288(%rbp)
	movq	%rdx, -280(%rbp)
	movq	-160(%rbp), %rax
	movq	%rax, -272(%rbp)
	movq	-304(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -264(%rbp)
	movq	%rdx, -256(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -248(%rbp)
	leaq	-208(%rbp), %rax
	leaq	-288(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Neg_to_sumtype_encoder__Expr
	movq	-296(%rbp), %rcx
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-192(%rbp), %rax
	movq	%rax, 16(%rcx)
	jmp	.L2309
.L2313:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -288(%rbp)
	movaps	%xmm0, -272(%rbp)
	movaps	%xmm0, -256(%rbp)
	movaps	%xmm0, -240(%rbp)
	movaps	%xmm0, -224(%rbp)
	leaq	.LC213(%rip), %rax
	movq	%rax, -288(%rbp)
	movl	$18, -280(%rbp)
	movl	$1, -276(%rbp)
	movl	$65040, -272(%rbp)
	movq	-304(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -264(%rbp)
	movq	%rdx, -256(%rbp)
	leaq	.LC89(%rip), %rax
	movq	%rax, -248(%rbp)
	movl	$1, -240(%rbp)
	movl	$1, -236(%rbp)
	leaq	-288(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	movq	-304(%rbp), %rcx
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	24(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2309:
	movq	-296(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	encoder__Encoder_parse_expr
	.hidden	encoder__Encoder_parse_expr
encoder__Encoder_parse_expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$224, %rsp
	movq	%rdi, -216(%rbp)
	movq	%rsi, -224(%rbp)
	leaq	-32(%rbp), %rax
	movq	-224(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_factor
	movq	-224(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$7, %eax
	je	.L2316
	movq	-224(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$8, %eax
	je	.L2316
	movq	-224(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$9, %eax
	je	.L2316
	movq	-224(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$10, %eax
	jne	.L2317
.L2316:
	movq	-224(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	movq	-224(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -48(%rbp)
	movq	-224(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	leaq	-96(%rbp), %rax
	movq	-224(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_expr
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, -208(%rbp)
	movq	%rdx, -200(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, -192(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, -184(%rbp)
	movq	%rdx, -176(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, -168(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -160(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -152(%rbp)
	movq	%rdx, -144(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -136(%rbp)
	leaq	-128(%rbp), %rax
	leaq	-208(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Binop_to_sumtype_encoder__Expr
	movq	-216(%rbp), %rcx
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-112(%rbp), %rax
	movq	%rax, 16(%rcx)
	jmp	.L2315
.L2317:
	movq	-216(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-16(%rbp), %rax
	movq	%rax, 16(%rcx)
.L2315:
	movq	-216(%rbp), %rax
	leave
	ret
	.globl	encoder__Encoder_parse_two_operand
	.hidden	encoder__Encoder_parse_two_operand
encoder__Encoder_parse_two_operand:
	pushq	%rbp
	movq	%rsp, %rbp
	addq	$-128, %rsp
	movq	%rdi, -120(%rbp)
	movq	%rsi, -128(%rbp)
	leaq	-32(%rbp), %rax
	movq	-128(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	movq	-128(%rbp), %rax
	movl	$3, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	leaq	-64(%rbp), %rax
	movq	-128(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_operand
	movq	-120(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-16(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	-120(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, 24(%rcx)
	movq	%rdx, 32(%rcx)
	movq	-48(%rbp), %rax
	movq	%rax, 40(%rcx)
	movq	-120(%rbp), %rax
	leave
	ret
	.section	.rodata, "a"
.LC240:
	.string	"1"
	.text
	.globl	encoder__Encoder_parse_operand
	.hidden	encoder__Encoder_parse_operand
encoder__Encoder_parse_operand:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$936, %rsp
	movq	%rdi, -904(%rbp)
	movq	%rsi, -912(%rbp)
	movq	-912(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -192(%rbp)
	movq	%rdx, -184(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -176(%rbp)
	movq	-912(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$12, %eax
	jne	.L2323
	movq	-912(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	leaq	-800(%rbp), %rax
	movq	-912(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_expr
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, -776(%rbp)
	movq	%rdx, -768(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, -760(%rbp)
	leaq	-336(%rbp), %rax
	leaq	-800(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Immediate_to_sumtype_encoder__Expr
	movq	-904(%rbp), %rcx
	movq	-336(%rbp), %rax
	movq	-328(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-320(%rbp), %rax
	movq	%rax, 16(%rcx)
	jmp	.L2324
.L2323:
	movq	-912(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$11, %eax
	jne	.L2325
	leaq	-368(%rbp), %rax
	movq	-912(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_register
	movq	-904(%rbp), %rcx
	movq	-368(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-352(%rbp), %rax
	movq	%rax, 16(%rcx)
	jmp	.L2324
.L2325:
	movq	-912(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$9, %eax
	jne	.L2326
	movq	-912(%rbp), %rax
	movl	$9, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	leaq	-432(%rbp), %rax
	movq	-912(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_register
	movl	-424(%rbp), %ecx
	movq	-432(%rbp), %rax
	movl	$165, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	__as_cast
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -144(%rbp)
	movq	%rbx, -136(%rbp)
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	%rdx, -120(%rbp)
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, -848(%rbp)
	movq	%rdx, -840(%rbp)
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, -832(%rbp)
	movq	%rdx, -824(%rbp)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, -816(%rbp)
	movq	%rdx, -808(%rbp)
	movq	-848(%rbp), %rax
	movq	-840(%rbp), %rdx
	movq	%rax, -800(%rbp)
	movq	%rdx, -792(%rbp)
	movq	-832(%rbp), %rax
	movq	-824(%rbp), %rdx
	movq	%rax, -784(%rbp)
	movq	%rdx, -776(%rbp)
	movq	-816(%rbp), %rax
	movq	-808(%rbp), %rdx
	movq	%rax, -768(%rbp)
	movq	%rdx, -760(%rbp)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, -752(%rbp)
	movq	%rdx, -744(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, -736(%rbp)
	leaq	-400(%rbp), %rax
	leaq	-800(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Star_to_sumtype_encoder__Expr
	movq	-904(%rbp), %rcx
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-384(%rbp), %rax
	movq	%rax, 16(%rcx)
	jmp	.L2324
.L2326:
	movq	-912(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$5, %eax
	jne	.L2327
	leaq	.LC43(%rip), %rax
	movq	%rax, -896(%rbp)
	movl	$1, -888(%rbp)
	movl	$1, -884(%rbp)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, -880(%rbp)
	movq	%rdx, -872(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, -864(%rbp)
	leaq	-464(%rbp), %rax
	leaq	-896(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Number_to_sumtype_encoder__Expr
	jmp	.L2328
.L2327:
	leaq	-464(%rbp), %rax
	movq	-912(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_expr
.L2328:
	movq	-912(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$5, %eax
	je	.L2329
	movq	-904(%rbp), %rcx
	movq	-464(%rbp), %rax
	movq	-456(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-448(%rbp), %rax
	movq	%rax, 16(%rcx)
	jmp	.L2324
.L2329:
	movq	-912(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	leaq	-800(%rbp), %rdx
	movl	$0, %eax
	movl	$22, %ecx
	movq	%rdx, %rdi
	rep stosq
	movq	-464(%rbp), %rax
	movq	-456(%rbp), %rdx
	movq	%rax, -800(%rbp)
	movq	%rdx, -792(%rbp)
	movq	-448(%rbp), %rax
	movq	%rax, -784(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -776(%rbp)
	movl	$1, -764(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -752(%rbp)
	movl	$1, -740(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -728(%rbp)
	movl	$1, -716(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -704(%rbp)
	movl	$1, -692(%rbp)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, -656(%rbp)
	movq	%rdx, -648(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, -640(%rbp)
	movq	-912(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$3, %eax
	je	.L2331
	movb	$1, -632(%rbp)
	leaq	-560(%rbp), %rax
	movq	-912(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_register
	movl	-552(%rbp), %ecx
	movq	-560(%rbp), %rax
	movl	$165, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	__as_cast
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -112(%rbp)
	movq	%rbx, -104(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -96(%rbp)
	movq	%rbx, -88(%rbp)
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -776(%rbp)
	movq	%rdx, -768(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, -760(%rbp)
	movq	%rdx, -752(%rbp)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, -744(%rbp)
	movq	%rdx, -736(%rbp)
.L2331:
	movq	-912(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$3, %eax
	jne	.L2332
	movb	$1, -631(%rbp)
	movq	-912(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	leaq	-624(%rbp), %rax
	movq	-912(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_register
	movl	-616(%rbp), %ecx
	movq	-624(%rbp), %rax
	movl	$165, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	__as_cast
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, -64(%rbp)
	movq	%rbx, -56(%rbp)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, -48(%rbp)
	movq	%rbx, -40(%rbp)
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, -728(%rbp)
	movq	%rdx, -720(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -712(%rbp)
	movq	%rdx, -704(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, -696(%rbp)
	movq	%rdx, -688(%rbp)
	movq	-912(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$3, %eax
	jne	.L2333
	movq	-912(%rbp), %rax
	movl	$3, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	leaq	-592(%rbp), %rax
	movq	-912(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_parse_expr
	jmp	.L2334
.L2333:
	leaq	.LC240(%rip), %rax
	movq	%rax, -848(%rbp)
	movl	$1, -840(%rbp)
	movl	$1, -836(%rbp)
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, -832(%rbp)
	movq	%rdx, -824(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, -816(%rbp)
	leaq	-944(%rbp), %rax
	leaq	-848(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Number_to_sumtype_encoder__Expr
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, -592(%rbp)
	movq	%rdx, -584(%rbp)
	movq	-928(%rbp), %rax
	movq	%rax, -576(%rbp)
.L2334:
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, -680(%rbp)
	movq	%rdx, -672(%rbp)
	movq	-576(%rbp), %rax
	movq	%rax, -664(%rbp)
.L2332:
	movq	-912(%rbp), %rax
	movl	$6, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	movq	-904(%rbp), %rax
	leaq	-800(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	encoder__Indirection_to_sumtype_encoder__Expr
.L2324:
	movq	-904(%rbp), %rax
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC241:
	.string	"invalid number `expr.lit`"
.LC242:
	.string	"not implemented yet"
.LC243:
	.string	"not implmented yet"
	.text
	.globl	encoder__eval_expr_get_symbol_64
	.hidden	encoder__eval_expr_get_symbol_64
encoder__eval_expr_get_symbol_64:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$152, %rsp
	movq	%rdi, -168(%rbp)
	movq	$0, -40(%rbp)
	movl	24(%rbp), %esi
	cmpl	$177, %esi
	jne	.L2337
	movq	16(%rbp), %rax
	leaq	-128(%rbp), %rdi
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movl	$64, %r8d
	movl	$0, %ecx
	movq	%rdx, %rsi
	movq	%rax, %rdx
	call	strconv__parse_int
	movzbl	-128(%rbp), %eax
	testb	%al, %al
	je	.L2338
	movq	-120(%rbp), %rax
	movq	-112(%rbp), %rdx
	movq	%rax, -160(%rbp)
	movq	%rdx, -152(%rbp)
	movq	-104(%rbp), %rax
	movq	-96(%rbp), %rdx
	movq	%rax, -144(%rbp)
	movq	%rdx, -136(%rbp)
	leaq	.LC241(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$25, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	16(%rbp), %rcx
	movq	%r12, %rsi
	movq	%r13, %rdi
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	16(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	32(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2338:
	leaq	-128(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	jmp	.L2339
.L2337:
	movl	24(%rbp), %esi
	cmpl	$175, %esi
	jne	.L2340
	movq	$0, -48(%rbp)
	movq	16(%rbp), %rax
	movl	48(%rax), %eax
	cmpl	$7, %eax
	jne	.L2341
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movq	%rax, %rbx
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	addq	%rbx, %rax
	movq	%rax, -48(%rbp)
	jmp	.L2342
.L2341:
	movq	16(%rbp), %rax
	movl	48(%rax), %eax
	cmpl	$8, %eax
	jne	.L2343
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movq	%rax, %rbx
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	subq	%rax, %rbx
	movq	%rbx, %rdx
	movq	%rdx, -48(%rbp)
	jmp	.L2342
.L2343:
	movq	16(%rbp), %rax
	movl	48(%rax), %eax
	cmpl	$9, %eax
	jne	.L2344
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movq	%rax, %rbx
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	imulq	%rbx, %rax
	movq	%rax, -48(%rbp)
	jmp	.L2342
.L2344:
	movq	16(%rbp), %rax
	movl	48(%rax), %eax
	cmpl	$10, %eax
	jne	.L2345
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movq	%rax, %rbx
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	24(%rcx), %rax
	movq	32(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	40(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movq	%rax, %rdi
	movq	%rbx, %rax
	cqto
	idivq	%rdi
	movq	%rax, -48(%rbp)
	jmp	.L2342
.L2345:
	leaq	.LC242(%rip), %rcx
	movq	%rbx, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$19, %rax
	movq	%rax, %rbx
	movq	%rbx, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %rbx
	movq	%rcx, %rsi
	movq	%rbx, %rdi
	movq	%rcx, %rax
	movq	%rbx, %rdx
	movq	%rsi, %rcx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L2342:
	movq	-48(%rbp), %rax
	movq	%rax, -40(%rbp)
	jmp	.L2339
.L2340:
	movl	24(%rbp), %ecx
	cmpl	$170, %ecx
	jne	.L2346
	movq	16(%rbp), %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_clone
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	leaq	-80(%rbp), %rdx
	movq	-168(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	array_push
	movq	$0, -40(%rbp)
	jmp	.L2339
.L2346:
	movl	24(%rbp), %ecx
	cmpl	$176, %ecx
	jne	.L2347
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	negq	%rax
	movq	%rax, -40(%rbp)
	jmp	.L2339
.L2347:
	movl	24(%rbp), %ecx
	cmpl	$169, %ecx
	jne	.L2348
	movq	16(%rbp), %rcx
	movq	-168(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movq	%rax, -40(%rbp)
	jmp	.L2339
.L2348:
	leaq	.LC243(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$18, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L2339:
	movq	-40(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.globl	encoder__eval_expr
	.hidden	encoder__eval_expr
encoder__eval_expr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	leaq	-48(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	-48(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	32(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	leave
	ret
	.section	.rodata, "a"
.LC244:
	.string	"unkown DataSize"
	.text
	.globl	encoder__get_size_by_suffix
	.hidden	encoder__get_size_by_suffix
encoder__get_size_by_suffix:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movl	-56(%rbp), %eax
	leal	-1(%rax), %ebx
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rsi, %rcx
	movq	%rdx, %rax
	movl	%ebx, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	string_at
	movb	%al, -37(%rbp)
	movl	$0, -36(%rbp)
	cmpb	$81, -37(%rbp)
	jne	.L2353
	movl	$3, -36(%rbp)
	jmp	.L2354
.L2353:
	cmpb	$76, -37(%rbp)
	jne	.L2355
	movl	$2, -36(%rbp)
	jmp	.L2354
.L2355:
	cmpb	$87, -37(%rbp)
	jne	.L2356
	movl	$1, -36(%rbp)
	jmp	.L2354
.L2356:
	cmpb	$66, -37(%rbp)
	jne	.L2357
	movl	$0, -36(%rbp)
	jmp	.L2354
.L2357:
	leaq	.LC244(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$15, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L2354:
	movl	-36(%rbp), %eax
	movl	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC245:
	.string	"invalid size of register for instruction."
	.text
	.globl	encoder__Register_check_regi_size
	.hidden	encoder__Register_check_regi_size
encoder__Register_check_regi_size:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movl	%edi, -20(%rbp)
	movl	32(%rbp), %ecx
	cmpl	%ecx, -20(%rbp)
	je	.L2361
	leaq	.LC245(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$41, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	40(%rbp), %rax
	movq	48(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	56(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$0, %edi
	call	_v_exit
.L2361:
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.globl	encoder__rex
	.hidden	encoder__rex
encoder__rex:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%ecx, %eax
	movl	%edi, %ecx
	movb	%cl, -20(%rbp)
	movl	%esi, %ecx
	movb	%cl, -24(%rbp)
	movb	%dl, -28(%rbp)
	movb	%al, -32(%rbp)
	movzbl	-20(%rbp), %eax
	sall	$3, %eax
	orl	$64, %eax
	movl	%eax, %edx
	movzbl	-24(%rbp), %eax
	sall	$2, %eax
	orl	%eax, %edx
	movzbl	-28(%rbp), %eax
	addl	%eax, %eax
	orl	%eax, %edx
	movzbl	-32(%rbp), %eax
	orl	%edx, %eax
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
	popq	%rbp
	ret
	.globl	encoder__Encoder_add_prefix
	.hidden	encoder__Encoder_add_prefix
encoder__Encoder_add_prefix:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movb	$0, -1(%rbp)
	movb	$0, -2(%rbp)
	movb	$0, -3(%rbp)
	movb	$0, -4(%rbp)
	movq	48(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$7, %al
	jbe	.L2365
	movb	$1, -2(%rbp)
.L2365:
	movq	96(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$7, %al
	jbe	.L2366
	movb	$1, -3(%rbp)
.L2366:
	movq	144(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$7, %al
	jbe	.L2367
	movb	$1, -4(%rbp)
.L2367:
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	160(%rbp), %rax
	movq	168(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	176(%rbp), %rax
	movq	184(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$1, %edi
	call	Array_encoder__DataSize_contains
	addq	$32, %rsp
	testb	%al, %al
	je	.L2368
	movl	$102, %eax
	movb	%al, -5(%rbp)
	movq	-24(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-5(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
.L2368:
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	160(%rbp), %rax
	movq	168(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	176(%rbp), %rax
	movq	184(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$4, %edi
	call	Array_encoder__DataSize_contains
	addq	$32, %rsp
	testb	%al, %al
	je	.L2369
	movb	$-13, -6(%rbp)
	movq	-24(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-6(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
.L2369:
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	160(%rbp), %rax
	movq	168(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	176(%rbp), %rax
	movq	184(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$5, %edi
	call	Array_encoder__DataSize_contains
	addq	$32, %rsp
	testb	%al, %al
	je	.L2370
	movb	$-14, -7(%rbp)
	movq	-24(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-7(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
.L2370:
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	160(%rbp), %rax
	movq	168(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	176(%rbp), %rax
	movq	184(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$3, %edi
	call	Array_encoder__DataSize_contains
	addq	$32, %rsp
	testb	%al, %al
	je	.L2371
	movb	$1, -1(%rbp)
.L2371:
	cmpb	$0, -1(%rbp)
	jne	.L2372
	cmpb	$0, -2(%rbp)
	jne	.L2372
	cmpb	$0, -4(%rbp)
	jne	.L2372
	cmpb	$0, -3(%rbp)
	jne	.L2372
	movq	56(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L2372
	movq	152(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L2374
.L2372:
	movzbl	-4(%rbp), %ecx
	movzbl	-3(%rbp), %edx
	movzbl	-2(%rbp), %esi
	movzbl	-1(%rbp), %eax
	movl	%eax, %edi
	call	encoder__rex
	movb	%al, -8(%rbp)
	movq	-24(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-8(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
.L2374:
	nop
	leave
	ret
	.globl	encoder__is_in_i8_range
	.hidden	encoder__is_in_i8_range
encoder__is_in_i8_range:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -20(%rbp)
	cmpl	$-128, -20(%rbp)
	jl	.L2376
	cmpl	$127, -20(%rbp)
	jg	.L2376
	movl	$1, %eax
	jmp	.L2377
.L2376:
	movl	$0, %eax
.L2377:
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
	popq	%rbp
	ret
	.globl	encoder__is_in_i32_range
	.hidden	encoder__is_in_i32_range
encoder__is_in_i32_range:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -20(%rbp)
	movb	$1, -1(%rbp)
	movzbl	-1(%rbp), %eax
	popq	%rbp
	ret
	.globl	encoder__compose_mod_rm
	.hidden	encoder__compose_mod_rm
encoder__compose_mod_rm:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%esi, %ecx
	movl	%edx, %eax
	movl	%edi, %edx
	movb	%dl, -20(%rbp)
	movl	%ecx, %edx
	movb	%dl, -24(%rbp)
	movb	%al, -28(%rbp)
	movzbl	-20(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movzbl	-24(%rbp), %eax
	sall	$3, %eax
	addl	%eax, %edx
	movzbl	-28(%rbp), %eax
	addl	%edx, %eax
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC246:
	.string	".SECTION"
.LC247:
	.string	".TEXT"
.LC248:
	.string	".DATA"
.LC249:
	.string	"wa"
.LC250:
	.string	".BSS"
.LC251:
	.string	".GLOBAL"
.LC252:
	.string	".GLOBL"
.LC253:
	.string	".LOCAL"
.LC254:
	.string	".HIDDEN"
.LC255:
	.string	".INTERNAL"
.LC256:
	.string	".PROTECTED"
.LC257:
	.string	".STRING"
.LC258:
	.string	".BYTE"
.LC259:
	.string	".WORD"
.LC260:
	.string	".LONG"
.LC261:
	.string	".QUAD"
.LC262:
	.string	".ZERO"
.LC263:
	.string	"POP"
.LC264:
	.string	"POPQ"
.LC265:
	.string	"PUSHQ"
.LC266:
	.string	"PUSH"
.LC267:
	.string	"CALLQ"
.LC268:
	.string	"CALL"
.LC269:
	.string	"LEAQ"
.LC270:
	.string	"LEAL"
.LC271:
	.string	"LEAW"
.LC272:
	.string	"NOTQ"
.LC273:
	.string	"NOTL"
.LC274:
	.string	"NOTW"
.LC275:
	.string	"NOTB"
.LC276:
	.string	"NEGQ"
.LC277:
	.string	"NEGL"
.LC278:
	.string	"NEGW"
.LC279:
	.string	"NEGB"
.LC280:
	.string	"DIVQ"
.LC281:
	.string	"DIVL"
.LC282:
	.string	"DIVW"
.LC283:
	.string	"DIVB"
.LC284:
	.string	"IDIVQ"
.LC285:
	.string	"IDIVL"
.LC286:
	.string	"IDIVW"
.LC287:
	.string	"IDIVB"
.LC288:
	.string	"IMULQ"
.LC289:
	.string	"IMULL"
.LC290:
	.string	"IMULW"
.LC291:
	.string	"MULQ"
.LC292:
	.string	"MULL"
.LC293:
	.string	"MULW"
.LC294:
	.string	"MULB"
.LC295:
	.string	"MOVQ"
.LC296:
	.string	"MOVL"
.LC297:
	.string	"MOVW"
.LC298:
	.string	"MOVB"
.LC299:
	.string	"MOVZBW"
.LC300:
	.string	"MOVZBL"
.LC301:
	.string	"MOVZBQ"
.LC302:
	.string	"MOVZWQ"
.LC303:
	.string	"MOVZWL"
.LC304:
	.string	"MOVSBL"
.LC305:
	.string	"MOVSBW"
.LC306:
	.string	"MOVSBQ"
.LC307:
	.string	"MOVSWL"
.LC308:
	.string	"MOVSWQ"
.LC309:
	.string	"MOVSLQ"
.LC310:
	.string	"MOVABSQ"
.LC311:
	.string	"TESTQ"
.LC312:
	.string	"TESTL"
.LC313:
	.string	"TESTW"
.LC314:
	.string	"TESTB"
.LC315:
	.string	"ADDQ"
.LC316:
	.string	"ADDL"
.LC317:
	.string	"ADDW"
.LC318:
	.string	"ADDB"
.LC319:
	.string	"ORQ"
.LC320:
	.string	"ORL"
.LC321:
	.string	"ORW"
.LC322:
	.string	"ORB"
.LC323:
	.string	"ADCQ"
.LC324:
	.string	"ADCL"
.LC325:
	.string	"ADCW"
.LC326:
	.string	"ADCB"
.LC327:
	.string	"SBBQ"
.LC328:
	.string	"SBBL"
.LC329:
	.string	"SBBW"
.LC330:
	.string	"SBBB"
.LC331:
	.string	"ANDQ"
.LC332:
	.string	"ANDL"
.LC333:
	.string	"ANDW"
.LC334:
	.string	"ANDB"
.LC335:
	.string	"SUBQ"
.LC336:
	.string	"SUBL"
.LC337:
	.string	"SUBW"
.LC338:
	.string	"SUBB"
.LC339:
	.string	"XORQ"
.LC340:
	.string	"XORL"
.LC341:
	.string	"XORW"
.LC342:
	.string	"XORB"
.LC343:
	.string	"CMPQ"
.LC344:
	.string	"CMPL"
.LC345:
	.string	"CMPW"
.LC346:
	.string	"CMPB"
.LC347:
	.string	"SHLQ"
.LC348:
	.string	"SHLL"
.LC349:
	.string	"SHLW"
.LC350:
	.string	"SHLB"
.LC351:
	.string	"SHRQ"
.LC352:
	.string	"SHRL"
.LC353:
	.string	"SHRW"
.LC354:
	.string	"SHRB"
.LC355:
	.string	"SARQ"
.LC356:
	.string	"SARL"
.LC357:
	.string	"SARW"
.LC358:
	.string	"SARB"
.LC359:
	.string	"SALQ"
.LC360:
	.string	"SALL"
.LC361:
	.string	"SALW"
.LC362:
	.string	"SALB"
.LC363:
	.string	"SETO"
.LC364:
	.string	"SETNO"
.LC365:
	.string	"SETB"
.LC366:
	.string	"SETAE"
.LC367:
	.string	"SETE"
.LC368:
	.string	"SETNE"
.LC369:
	.string	"SETNB"
.LC370:
	.string	"SETBE"
.LC371:
	.string	"SETA"
.LC372:
	.string	"SETPO"
.LC373:
	.string	"SETL"
.LC374:
	.string	"SETG"
.LC375:
	.string	"SETLE"
.LC376:
	.string	"SETGE"
.LC377:
	.string	"JMP"
.LC378:
	.string	"JNE"
.LC379:
	.string	"JE"
.LC380:
	.string	"JL"
.LC381:
	.string	"JG"
.LC382:
	.string	"JLE"
.LC383:
	.string	"JGE"
.LC384:
	.string	"JNB"
.LC385:
	.string	"JBE"
.LC386:
	.string	"JNBE"
.LC387:
	.string	"JP"
.LC388:
	.string	"JA"
.LC389:
	.string	"JB"
.LC390:
	.string	"JS"
.LC391:
	.string	"JNS"
.LC392:
	.string	"REP"
.LC393:
	.string	"CVTTSS2SIL"
.LC394:
	.string	"CVTSI2SSQ"
.LC395:
	.string	"CVTSI2SDQ"
.LC396:
	.string	"MOVD"
.LC397:
	.string	"XORPD"
.LC398:
	.string	"XORPS"
.LC399:
	.string	"MOVSS"
.LC400:
	.string	"MOVSD"
.LC401:
	.string	"MOVAPS"
.LC402:
	.string	"MOVUPS"
.LC403:
	.string	"PXOR"
.LC404:
	.string	"CVTSD2SS"
.LC405:
	.string	"CVTSS2SD"
.LC406:
	.string	"UCOMISS"
.LC407:
	.string	"UCOMISD"
.LC408:
	.string	"COMISS"
.LC409:
	.string	"COMISD"
.LC410:
	.string	"SUBSS"
.LC411:
	.string	"SUBSD"
.LC412:
	.string	"ADDSS"
.LC413:
	.string	"ADDSD"
.LC414:
	.string	"MULSS"
.LC415:
	.string	"MULSD"
.LC416:
	.string	"DIVSS"
.LC417:
	.string	"DIVSD"
.LC418:
	.string	"CMOVSQ"
.LC419:
	.string	"CMOVSL"
.LC420:
	.string	"CMOVSW"
.LC421:
	.string	"CMOVNSQ"
.LC422:
	.string	"CMOVNSL"
.LC423:
	.string	"CMOVNSW"
.LC424:
	.string	"CMOVGEQ"
.LC425:
	.string	"CMOVGEL"
.LC426:
	.string	"CMOVGEW"
.LC427:
	.string	"RETQ"
.LC428:
	.string	"RET"
.LC429:
	.string	"SYSCALL"
.LC430:
	.string	"NOPQ"
.LC431:
	.string	"NOP"
.LC432:
	.string	"HLT"
.LC433:
	.string	"LEAVE"
.LC434:
	.string	"CLTQ"
.LC435:
	.string	"CLTD"
.LC436:
	.string	"CQTO"
.LC437:
	.string	"CWTL"
.LC438:
	.string	"unkwoun instruction `"
	.text
	.globl	encoder__Encoder_encode_instr
	.hidden	encoder__Encoder_encode_instr
encoder__Encoder_encode_instr:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$6584, %rsp
	movq	%rdi, -3496(%rbp)
	movq	-3496(%rbp), %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdx
	movq	%rax, -2624(%rbp)
	movq	%rdx, -2616(%rbp)
	movq	24(%rcx), %rax
	movq	%rax, -2608(%rbp)
	movq	-3496(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -2640(%rbp)
	movq	%rdx, -2632(%rbp)
	movq	-2640(%rbp), %rdx
	movq	-2632(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_upper
	movq	%rax, -2656(%rbp)
	movq	%rdx, -2648(%rbp)
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	movq	-3496(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$4, %eax
	jne	.L2384
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$107, -3280(%rbp)
	leaq	-3272(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-2640(%rbp), %rax
	movq	-2632(%rbp), %rdx
	movq	%rax, -3240(%rbp)
	movq	%rdx, -3232(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -56(%rbp)
	movq	-3496(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_expect
	movq	-2640(%rbp), %rax
	movq	-2632(%rbp), %rdx
	movq	%rax, -2704(%rbp)
	movq	%rdx, -2696(%rbp)
	movq	-3496(%rbp), %rax
	movq	192(%rax), %rcx
	movq	200(%rax), %rbx
	movq	%rcx, -3408(%rbp)
	movq	%rbx, -3400(%rbp)
	movq	208(%rax), %rcx
	movq	216(%rax), %rbx
	movq	%rcx, -3392(%rbp)
	movq	%rbx, -3384(%rbp)
	movq	224(%rax), %rcx
	movq	232(%rax), %rbx
	movq	%rcx, -3376(%rbp)
	movq	%rbx, -3368(%rbp)
	movq	240(%rax), %rcx
	movq	248(%rax), %rbx
	movq	%rcx, -3360(%rbp)
	movq	%rbx, -3352(%rbp)
	movq	256(%rax), %rcx
	movq	264(%rax), %rbx
	movq	%rcx, -3344(%rbp)
	movq	%rbx, -3336(%rbp)
	movq	272(%rax), %rcx
	movq	280(%rax), %rbx
	movq	%rcx, -3328(%rbp)
	movq	%rbx, -3320(%rbp)
	movq	288(%rax), %rcx
	movq	296(%rax), %rbx
	movq	%rcx, -3312(%rbp)
	movq	%rbx, -3304(%rbp)
	movq	304(%rax), %rax
	movq	%rax, -3296(%rbp)
	leaq	-2704(%rbp), %rdx
	leaq	-3408(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	map_exists
	testb	%al, %al
	je	.L2385
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -3488(%rbp)
	movaps	%xmm0, -3472(%rbp)
	movaps	%xmm0, -3456(%rbp)
	movaps	%xmm0, -3440(%rbp)
	movaps	%xmm0, -3424(%rbp)
	leaq	.LC231(%rip), %rax
	movq	%rax, -3488(%rbp)
	movl	$8, -3480(%rbp)
	movl	$1, -3476(%rbp)
	movl	$65040, -3472(%rbp)
	movq	-2640(%rbp), %rax
	movq	-2632(%rbp), %rdx
	movq	%rax, -3464(%rbp)
	movq	%rdx, -3456(%rbp)
	leaq	.LC232(%rip), %rax
	movq	%rax, -3448(%rbp)
	movl	$20, -3440(%rbp)
	movl	$1, -3436(%rbp)
	leaq	-3488(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2608(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2385:
	movq	$0, -2680(%rbp)
	movq	-2640(%rbp), %rax
	movq	-2632(%rbp), %rdx
	movq	%rax, -2672(%rbp)
	movq	%rdx, -2664(%rbp)
	movq	-3496(%rbp), %rax
	leaq	192(%rax), %rcx
	leaq	-2680(%rbp), %rdx
	leaq	-2672(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	map_get_and_set
	movq	-56(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-56(%rbp), %rax
	movq	%rax, -2688(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-2688(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2384:
	leaq	.LC246(%rip), %rax
	movq	%rax, -3520(%rbp)
	movq	-3512(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$8, %rax
	movq	%rax, -3512(%rbp)
	movq	-3512(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3512(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3520(%rbp), %rdx
	movq	-3512(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2387
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_section
	jmp	.L2383
.L2387:
	leaq	.LC247(%rip), %rax
	movq	%rax, -3536(%rbp)
	movq	-3528(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3528(%rbp)
	movq	-3528(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3528(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3536(%rbp), %rdx
	movq	-3528(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2389
	leaq	.LC238(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	leaq	.LC234(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rcx, %r8
	movq	%rdx, %r10
	movq	%r14, %rcx
	movq	%r15, %rbx
	movq	%r14, %rax
	movq	%r15, %rdx
	movq	%rcx, %rsi
	movq	%rdx, %r9
	movq	-3496(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2608(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rcx
	movq	%r10, %r8
	movq	%r9, %rdx
	call	encoder__Encoder_add_section
	addq	$32, %rsp
	jmp	.L2383
.L2389:
	leaq	.LC248(%rip), %rax
	movq	%rax, -3552(%rbp)
	movq	-3544(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3544(%rbp)
	movq	-3544(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3544(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3552(%rbp), %rdx
	movq	-3544(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2391
	leaq	.LC249(%rip), %rax
	movq	%rax, -3584(%rbp)
	movq	-3576(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -3576(%rbp)
	movq	-3576(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3576(%rbp)
	leaq	.LC237(%rip), %rax
	movq	%rax, -3568(%rbp)
	movq	-3560(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3560(%rbp)
	movq	-3560(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3560(%rbp)
	movq	-3584(%rbp), %rax
	movq	-3576(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %r8
	movq	%rdx, %r10
	movq	-3568(%rbp), %rax
	movq	-3560(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %r9
	movq	-3496(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2608(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rcx
	movq	%r10, %r8
	movq	%r9, %rdx
	call	encoder__Encoder_add_section
	addq	$32, %rsp
	jmp	.L2383
.L2391:
	leaq	.LC250(%rip), %rax
	movq	%rax, -3600(%rbp)
	movq	-3592(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3592(%rbp)
	movq	-3592(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3592(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3600(%rbp), %rdx
	movq	-3592(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2393
	leaq	.LC249(%rip), %rax
	movq	%rax, -3632(%rbp)
	movq	-3624(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -3624(%rbp)
	movq	-3624(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3624(%rbp)
	leaq	.LC236(%rip), %rax
	movq	%rax, -3616(%rbp)
	movq	-3608(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3608(%rbp)
	movq	-3608(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3608(%rbp)
	movq	-3632(%rbp), %rax
	movq	-3624(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %r8
	movq	%rdx, %r10
	movq	-3616(%rbp), %rax
	movq	-3608(%rbp), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movq	%rdx, %r9
	movq	-3496(%rbp), %rdi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2608(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%r8, %rcx
	movq	%r10, %r8
	movq	%r9, %rdx
	call	encoder__Encoder_add_section
	addq	$32, %rsp
	jmp	.L2383
.L2393:
	leaq	.LC251(%rip), %rax
	movq	%rax, -3648(%rbp)
	movq	-3640(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -3640(%rbp)
	movq	-3640(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3640(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3648(%rbp), %rdx
	movq	-3640(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2395
	leaq	.LC252(%rip), %rax
	movq	%rax, -3664(%rbp)
	movq	-3656(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -3656(%rbp)
	movq	-3656(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3656(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3664(%rbp), %rdx
	movq	-3656(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2396
.L2395:
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$2, -3280(%rbp)
	leaq	-3272(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-3496(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -3240(%rbp)
	movq	%rdx, -3232(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -2712(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-2712(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	jmp	.L2383
.L2396:
	leaq	.LC253(%rip), %rax
	movq	%rax, -3680(%rbp)
	movq	-3672(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -3672(%rbp)
	movq	-3672(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3672(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3680(%rbp), %rdx
	movq	-3672(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2398
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$3, -3280(%rbp)
	leaq	-3272(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-3496(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -3240(%rbp)
	movq	%rdx, -3232(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -2720(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-2720(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	jmp	.L2383
.L2398:
	leaq	.LC254(%rip), %rax
	movq	%rax, -3696(%rbp)
	movq	-3688(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -3688(%rbp)
	movq	-3688(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3688(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3696(%rbp), %rdx
	movq	-3688(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2400
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$4, -3280(%rbp)
	leaq	-3272(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-3496(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -3240(%rbp)
	movq	%rdx, -3232(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -2728(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-2728(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	jmp	.L2383
.L2400:
	leaq	.LC255(%rip), %rax
	movq	%rax, -3712(%rbp)
	movq	-3704(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$9, %rax
	movq	%rax, -3704(%rbp)
	movq	-3704(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3704(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3712(%rbp), %rdx
	movq	-3704(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2402
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$5, -3280(%rbp)
	leaq	-3272(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-3496(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -3240(%rbp)
	movq	%rdx, -3232(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -2736(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-2736(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	jmp	.L2383
.L2402:
	leaq	.LC256(%rip), %rax
	movq	%rax, -3728(%rbp)
	movq	-3720(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$10, %rax
	movq	%rax, -3720(%rbp)
	movq	-3720(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3720(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3728(%rbp), %rdx
	movq	-3720(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2404
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$6, -3280(%rbp)
	leaq	-3272(%rbp), %rax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-3496(%rbp), %rax
	movq	40(%rax), %rdx
	movq	32(%rax), %rax
	movq	%rax, -3240(%rbp)
	movq	%rdx, -3232(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -2744(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-2744(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_next
	jmp	.L2383
.L2404:
	leaq	.LC257(%rip), %rax
	movq	%rax, -3744(%rbp)
	movq	-3736(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -3736(%rbp)
	movq	-3736(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3736(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3744(%rbp), %rdx
	movq	-3736(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2406
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_string
	jmp	.L2383
.L2406:
	leaq	.LC258(%rip), %rax
	movq	%rax, -3760(%rbp)
	movq	-3752(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3752(%rbp)
	movq	-3752(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3752(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3760(%rbp), %rdx
	movq	-3752(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2408
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_byte
	jmp	.L2383
.L2408:
	leaq	.LC259(%rip), %rax
	movq	%rax, -3776(%rbp)
	movq	-3768(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3768(%rbp)
	movq	-3768(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3768(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3776(%rbp), %rdx
	movq	-3768(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2410
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_word
	jmp	.L2383
.L2410:
	leaq	.LC260(%rip), %rax
	movq	%rax, -3792(%rbp)
	movq	-3784(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3784(%rbp)
	movq	-3784(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3784(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3792(%rbp), %rdx
	movq	-3784(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2412
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_long
	jmp	.L2383
.L2412:
	leaq	.LC261(%rip), %rax
	movq	%rax, -3808(%rbp)
	movq	-3800(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3800(%rbp)
	movq	-3800(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3800(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3808(%rbp), %rdx
	movq	-3800(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2414
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_quad
	jmp	.L2383
.L2414:
	leaq	.LC262(%rip), %rax
	movq	%rax, -3824(%rbp)
	movq	-3816(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3816(%rbp)
	movq	-3816(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3816(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3824(%rbp), %rdx
	movq	-3816(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2416
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_zero
	jmp	.L2383
.L2416:
	leaq	.LC263(%rip), %rax
	movq	%rax, -3840(%rbp)
	movq	-3832(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -3832(%rbp)
	movq	-3832(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3832(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3840(%rbp), %rdx
	movq	-3832(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2418
	leaq	.LC264(%rip), %rax
	movq	%rax, -3856(%rbp)
	movq	-3848(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3848(%rbp)
	movq	-3848(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3848(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3856(%rbp), %rdx
	movq	-3848(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2419
.L2418:
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_pop
	jmp	.L2383
.L2419:
	leaq	.LC265(%rip), %rax
	movq	%rax, -3872(%rbp)
	movq	-3864(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3864(%rbp)
	movq	-3864(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3864(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3872(%rbp), %rdx
	movq	-3864(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2421
	leaq	.LC266(%rip), %rax
	movq	%rax, -3888(%rbp)
	movq	-3880(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3880(%rbp)
	movq	-3880(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3880(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3888(%rbp), %rdx
	movq	-3880(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2422
.L2421:
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_push
	jmp	.L2383
.L2422:
	leaq	.LC267(%rip), %rax
	movq	%rax, -3904(%rbp)
	movq	-3896(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -3896(%rbp)
	movq	-3896(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3896(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3904(%rbp), %rdx
	movq	-3896(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2424
	leaq	.LC268(%rip), %rax
	movq	%rax, -3920(%rbp)
	movq	-3912(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3912(%rbp)
	movq	-3912(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3912(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3920(%rbp), %rdx
	movq	-3912(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2425
.L2424:
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_call
	jmp	.L2383
.L2425:
	leaq	.LC269(%rip), %rax
	movq	%rax, -3936(%rbp)
	movq	-3928(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3928(%rbp)
	movq	-3928(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3928(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3936(%rbp), %rdx
	movq	-3928(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2427
	leaq	.LC270(%rip), %rax
	movq	%rax, -3952(%rbp)
	movq	-3944(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3944(%rbp)
	movq	-3944(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3944(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3952(%rbp), %rdx
	movq	-3944(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2427
	leaq	.LC271(%rip), %rax
	movq	%rax, -3968(%rbp)
	movq	-3960(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3960(%rbp)
	movq	-3960(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3960(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3968(%rbp), %rdx
	movq	-3960(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2428
.L2427:
	movq	-2656(%rbp), %rcx
	movq	-2648(%rbp), %rdx
	movq	-3496(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	encoder__Encoder_lea
	jmp	.L2383
.L2428:
	leaq	.LC272(%rip), %rax
	movq	%rax, -3984(%rbp)
	movq	-3976(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3976(%rbp)
	movq	-3976(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3976(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-3984(%rbp), %rdx
	movq	-3976(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2430
	leaq	.LC273(%rip), %rax
	movq	%rax, -4000(%rbp)
	movq	-3992(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -3992(%rbp)
	movq	-3992(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -3992(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4000(%rbp), %rdx
	movq	-3992(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2430
	leaq	.LC274(%rip), %rax
	movq	%rax, -4016(%rbp)
	movq	-4008(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4008(%rbp)
	movq	-4008(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4008(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4016(%rbp), %rdx
	movq	-4008(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2430
	leaq	.LC275(%rip), %rax
	movq	%rax, -4032(%rbp)
	movq	-4024(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4024(%rbp)
	movq	-4024(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4024(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4032(%rbp), %rdx
	movq	-4024(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2431
.L2430:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %ecx
	movl	$2, %edx
	movl	$32, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_one_operand_arith
	jmp	.L2383
.L2431:
	leaq	.LC276(%rip), %rax
	movq	%rax, -4048(%rbp)
	movq	-4040(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4040(%rbp)
	movq	-4040(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4040(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4048(%rbp), %rdx
	movq	-4040(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2433
	leaq	.LC277(%rip), %rax
	movq	%rax, -4064(%rbp)
	movq	-4056(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4056(%rbp)
	movq	-4056(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4056(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4064(%rbp), %rdx
	movq	-4056(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2433
	leaq	.LC278(%rip), %rax
	movq	%rax, -4080(%rbp)
	movq	-4072(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4072(%rbp)
	movq	-4072(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4072(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4080(%rbp), %rdx
	movq	-4072(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2433
	leaq	.LC279(%rip), %rax
	movq	%rax, -4096(%rbp)
	movq	-4088(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4088(%rbp)
	movq	-4088(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4088(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4096(%rbp), %rdx
	movq	-4088(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2434
.L2433:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %ecx
	movl	$3, %edx
	movl	$23, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_one_operand_arith
	jmp	.L2383
.L2434:
	leaq	.LC280(%rip), %rax
	movq	%rax, -4112(%rbp)
	movq	-4104(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4104(%rbp)
	movq	-4104(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4104(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4112(%rbp), %rdx
	movq	-4104(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2436
	leaq	.LC281(%rip), %rax
	movq	%rax, -4128(%rbp)
	movq	-4120(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4120(%rbp)
	movq	-4120(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4120(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4128(%rbp), %rdx
	movq	-4120(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2436
	leaq	.LC282(%rip), %rax
	movq	%rax, -4144(%rbp)
	movq	-4136(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4136(%rbp)
	movq	-4136(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4136(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4144(%rbp), %rdx
	movq	-4136(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2436
	leaq	.LC283(%rip), %rax
	movq	%rax, -4160(%rbp)
	movq	-4152(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4152(%rbp)
	movq	-4152(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4152(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4160(%rbp), %rdx
	movq	-4152(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2437
.L2436:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %ecx
	movl	$6, %edx
	movl	$22, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_one_operand_arith
	jmp	.L2383
.L2437:
	leaq	.LC284(%rip), %rax
	movq	%rax, -4176(%rbp)
	movq	-4168(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4168(%rbp)
	movq	-4168(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4168(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4176(%rbp), %rdx
	movq	-4168(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2439
	leaq	.LC285(%rip), %rax
	movq	%rax, -4192(%rbp)
	movq	-4184(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4184(%rbp)
	movq	-4184(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4184(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4192(%rbp), %rdx
	movq	-4184(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2439
	leaq	.LC286(%rip), %rax
	movq	%rax, -4208(%rbp)
	movq	-4200(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4200(%rbp)
	movq	-4200(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4200(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4208(%rbp), %rdx
	movq	-4200(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2439
	leaq	.LC287(%rip), %rax
	movq	%rax, -4224(%rbp)
	movq	-4216(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4216(%rbp)
	movq	-4216(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4216(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4224(%rbp), %rdx
	movq	-4216(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2440
.L2439:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %ecx
	movl	$7, %edx
	movl	$21, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_one_operand_arith
	jmp	.L2383
.L2440:
	leaq	.LC288(%rip), %rax
	movq	%rax, -4240(%rbp)
	movq	-4232(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4232(%rbp)
	movq	-4232(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4232(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4240(%rbp), %rdx
	movq	-4232(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2442
	leaq	.LC289(%rip), %rax
	movq	%rax, -4256(%rbp)
	movq	-4248(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4248(%rbp)
	movq	-4248(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4248(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4256(%rbp), %rdx
	movq	-4248(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2442
	leaq	.LC290(%rip), %rax
	movq	%rax, -4272(%rbp)
	movq	-4264(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4264(%rbp)
	movq	-4264(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4264(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4272(%rbp), %rdx
	movq	-4264(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2443
.L2442:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_imul
	jmp	.L2383
.L2443:
	leaq	.LC291(%rip), %rax
	movq	%rax, -4288(%rbp)
	movq	-4280(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4280(%rbp)
	movq	-4280(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4280(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4288(%rbp), %rdx
	movq	-4280(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2445
	leaq	.LC292(%rip), %rax
	movq	%rax, -4304(%rbp)
	movq	-4296(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4296(%rbp)
	movq	-4296(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4296(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4304(%rbp), %rdx
	movq	-4296(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2445
	leaq	.LC293(%rip), %rax
	movq	%rax, -4320(%rbp)
	movq	-4312(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4312(%rbp)
	movq	-4312(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4312(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4320(%rbp), %rdx
	movq	-4312(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2445
	leaq	.LC294(%rip), %rax
	movq	%rax, -4336(%rbp)
	movq	-4328(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4328(%rbp)
	movq	-4328(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4328(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4336(%rbp), %rdx
	movq	-4328(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2446
.L2445:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_mul
	jmp	.L2383
.L2446:
	leaq	.LC295(%rip), %rax
	movq	%rax, -4352(%rbp)
	movq	-4344(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4344(%rbp)
	movq	-4344(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4344(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4352(%rbp), %rdx
	movq	-4344(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2448
	leaq	.LC296(%rip), %rax
	movq	%rax, -4368(%rbp)
	movq	-4360(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4360(%rbp)
	movq	-4360(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4360(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4368(%rbp), %rdx
	movq	-4360(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2448
	leaq	.LC297(%rip), %rax
	movq	%rax, -4384(%rbp)
	movq	-4376(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4376(%rbp)
	movq	-4376(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4376(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4384(%rbp), %rdx
	movq	-4376(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2448
	leaq	.LC298(%rip), %rax
	movq	%rax, -4400(%rbp)
	movq	-4392(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4392(%rbp)
	movq	-4392(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4392(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4400(%rbp), %rdx
	movq	-4392(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2449
.L2448:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_mov
	jmp	.L2383
.L2449:
	leaq	.LC299(%rip), %rax
	movq	%rax, -4416(%rbp)
	movq	-4408(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4408(%rbp)
	movq	-4408(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4408(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4416(%rbp), %rdx
	movq	-4408(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2451
	movb	$15, -2746(%rbp)
	movb	$-74, -2745(%rbp)
	leaq	-2592(%rbp), %rax
	leaq	-2746(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2592(%rbp), %rax
	movq	-2584(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2576(%rbp), %rax
	movq	-2568(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$1, %edx
	movl	$0, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2451:
	leaq	.LC300(%rip), %rax
	movq	%rax, -4432(%rbp)
	movq	-4424(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4424(%rbp)
	movq	-4424(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4424(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4432(%rbp), %rdx
	movq	-4424(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2453
	movb	$15, -2748(%rbp)
	movb	$-74, -2747(%rbp)
	leaq	-2560(%rbp), %rax
	leaq	-2748(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2560(%rbp), %rax
	movq	-2552(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2544(%rbp), %rax
	movq	-2536(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$0, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2453:
	leaq	.LC301(%rip), %rax
	movq	%rax, -4448(%rbp)
	movq	-4440(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4440(%rbp)
	movq	-4440(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4440(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4448(%rbp), %rdx
	movq	-4440(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2455
	movb	$15, -2750(%rbp)
	movb	$-74, -2749(%rbp)
	leaq	-2528(%rbp), %rax
	leaq	-2750(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2528(%rbp), %rax
	movq	-2520(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2512(%rbp), %rax
	movq	-2504(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$3, %edx
	movl	$0, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2455:
	leaq	.LC302(%rip), %rax
	movq	%rax, -4464(%rbp)
	movq	-4456(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4456(%rbp)
	movq	-4456(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4456(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4464(%rbp), %rdx
	movq	-4456(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2457
	movb	$15, -2752(%rbp)
	movb	$-73, -2751(%rbp)
	leaq	-2496(%rbp), %rax
	leaq	-2752(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2496(%rbp), %rax
	movq	-2488(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2480(%rbp), %rax
	movq	-2472(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$3, %edx
	movl	$1, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2457:
	leaq	.LC303(%rip), %rax
	movq	%rax, -4480(%rbp)
	movq	-4472(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4472(%rbp)
	movq	-4472(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4472(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4480(%rbp), %rdx
	movq	-4472(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2459
	movb	$15, -2754(%rbp)
	movb	$-73, -2753(%rbp)
	leaq	-2464(%rbp), %rax
	leaq	-2754(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2464(%rbp), %rax
	movq	-2456(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2448(%rbp), %rax
	movq	-2440(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$1, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2459:
	leaq	.LC304(%rip), %rax
	movq	%rax, -4496(%rbp)
	movq	-4488(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4488(%rbp)
	movq	-4488(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4488(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4496(%rbp), %rdx
	movq	-4488(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2461
	movb	$15, -2756(%rbp)
	movb	$-66, -2755(%rbp)
	leaq	-2432(%rbp), %rax
	leaq	-2756(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2432(%rbp), %rax
	movq	-2424(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2416(%rbp), %rax
	movq	-2408(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$0, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2461:
	leaq	.LC305(%rip), %rax
	movq	%rax, -4512(%rbp)
	movq	-4504(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4504(%rbp)
	movq	-4504(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4504(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4512(%rbp), %rdx
	movq	-4504(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2463
	movb	$15, -2758(%rbp)
	movb	$-66, -2757(%rbp)
	leaq	-2400(%rbp), %rax
	leaq	-2758(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2400(%rbp), %rax
	movq	-2392(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2384(%rbp), %rax
	movq	-2376(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$1, %edx
	movl	$0, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2463:
	leaq	.LC306(%rip), %rax
	movq	%rax, -4528(%rbp)
	movq	-4520(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4520(%rbp)
	movq	-4520(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4520(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4528(%rbp), %rdx
	movq	-4520(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2465
	movb	$15, -2760(%rbp)
	movb	$-66, -2759(%rbp)
	leaq	-2368(%rbp), %rax
	leaq	-2760(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2368(%rbp), %rax
	movq	-2360(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2352(%rbp), %rax
	movq	-2344(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$3, %edx
	movl	$0, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2465:
	leaq	.LC307(%rip), %rax
	movq	%rax, -4544(%rbp)
	movq	-4536(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4536(%rbp)
	movq	-4536(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4536(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4544(%rbp), %rdx
	movq	-4536(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2467
	movb	$15, -2762(%rbp)
	movb	$-65, -2761(%rbp)
	leaq	-2336(%rbp), %rax
	leaq	-2762(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2336(%rbp), %rax
	movq	-2328(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2320(%rbp), %rax
	movq	-2312(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$1, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2467:
	leaq	.LC308(%rip), %rax
	movq	%rax, -4560(%rbp)
	movq	-4552(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4552(%rbp)
	movq	-4552(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4552(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4560(%rbp), %rdx
	movq	-4552(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2469
	movb	$15, -2764(%rbp)
	movb	$-65, -2763(%rbp)
	leaq	-2304(%rbp), %rax
	leaq	-2764(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2304(%rbp), %rax
	movq	-2296(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2288(%rbp), %rax
	movq	-2280(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$3, %edx
	movl	$1, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2469:
	leaq	.LC309(%rip), %rax
	movq	%rax, -4576(%rbp)
	movq	-4568(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -4568(%rbp)
	movq	-4568(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4568(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4576(%rbp), %rdx
	movq	-4568(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2471
	movb	$99, -2765(%rbp)
	leaq	-2272(%rbp), %rax
	leaq	-2765(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2272(%rbp), %rax
	movq	-2264(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2256(%rbp), %rax
	movq	-2248(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$3, %edx
	movl	$2, %esi
	call	encoder__Encoder_mov_zero_or_sign_extend
	addq	$32, %rsp
	jmp	.L2383
.L2471:
	leaq	.LC310(%rip), %rax
	movq	%rax, -4592(%rbp)
	movq	-4584(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -4584(%rbp)
	movq	-4584(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4584(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4592(%rbp), %rdx
	movq	-4584(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2473
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_movabsq
	jmp	.L2383
.L2473:
	leaq	.LC311(%rip), %rax
	movq	%rax, -4608(%rbp)
	movq	-4600(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4600(%rbp)
	movq	-4600(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4600(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4608(%rbp), %rdx
	movq	-4600(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2475
	leaq	.LC312(%rip), %rax
	movq	%rax, -4624(%rbp)
	movq	-4616(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4616(%rbp)
	movq	-4616(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4616(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4624(%rbp), %rdx
	movq	-4616(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2475
	leaq	.LC313(%rip), %rax
	movq	%rax, -4640(%rbp)
	movq	-4632(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4632(%rbp)
	movq	-4632(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4632(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4640(%rbp), %rdx
	movq	-4632(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2475
	leaq	.LC314(%rip), %rax
	movq	%rax, -4656(%rbp)
	movq	-4648(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -4648(%rbp)
	movq	-4648(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4648(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4656(%rbp), %rdx
	movq	-4648(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2476
.L2475:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_test
	jmp	.L2383
.L2476:
	leaq	.LC315(%rip), %rax
	movq	%rax, -4672(%rbp)
	movq	-4664(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4664(%rbp)
	movq	-4664(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4664(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4672(%rbp), %rdx
	movq	-4664(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2478
	leaq	.LC316(%rip), %rax
	movq	%rax, -4688(%rbp)
	movq	-4680(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4680(%rbp)
	movq	-4680(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4680(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4688(%rbp), %rdx
	movq	-4680(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2478
	leaq	.LC317(%rip), %rax
	movq	%rax, -4704(%rbp)
	movq	-4696(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4696(%rbp)
	movq	-4696(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4696(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4704(%rbp), %rdx
	movq	-4696(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2478
	leaq	.LC318(%rip), %rax
	movq	%rax, -4720(%rbp)
	movq	-4712(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4712(%rbp)
	movq	-4712(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4712(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4720(%rbp), %rdx
	movq	-4712(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2479
.L2478:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movl	$13, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_arith_instr
	jmp	.L2383
.L2479:
	leaq	.LC319(%rip), %rax
	movq	%rax, -4736(%rbp)
	movq	-4728(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -4728(%rbp)
	movq	-4728(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4728(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4736(%rbp), %rdx
	movq	-4728(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2481
	leaq	.LC320(%rip), %rax
	movq	%rax, -4752(%rbp)
	movq	-4744(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -4744(%rbp)
	movq	-4744(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4744(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4752(%rbp), %rdx
	movq	-4744(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2481
	leaq	.LC321(%rip), %rax
	movq	%rax, -4768(%rbp)
	movq	-4760(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -4760(%rbp)
	movq	-4760(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4760(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4768(%rbp), %rdx
	movq	-4760(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2481
	leaq	.LC322(%rip), %rax
	movq	%rax, -4784(%rbp)
	movq	-4776(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -4776(%rbp)
	movq	-4776(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4776(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4784(%rbp), %rdx
	movq	-4776(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2482
.L2481:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %r8d
	movl	$1, %ecx
	movl	$8, %edx
	movl	$15, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_arith_instr
	jmp	.L2383
.L2482:
	leaq	.LC323(%rip), %rax
	movq	%rax, -4800(%rbp)
	movq	-4792(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4792(%rbp)
	movq	-4792(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4792(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4800(%rbp), %rdx
	movq	-4792(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2484
	leaq	.LC324(%rip), %rax
	movq	%rax, -4816(%rbp)
	movq	-4808(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4808(%rbp)
	movq	-4808(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4808(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4816(%rbp), %rdx
	movq	-4808(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2484
	leaq	.LC325(%rip), %rax
	movq	%rax, -4832(%rbp)
	movq	-4824(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4824(%rbp)
	movq	-4824(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4824(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4832(%rbp), %rdx
	movq	-4824(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2484
	leaq	.LC326(%rip), %rax
	movq	%rax, -4848(%rbp)
	movq	-4840(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4840(%rbp)
	movq	-4840(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4840(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4848(%rbp), %rdx
	movq	-4840(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2485
.L2484:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %r8d
	movl	$2, %ecx
	movl	$16, %edx
	movl	$16, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_arith_instr
	jmp	.L2383
.L2485:
	leaq	.LC327(%rip), %rax
	movq	%rax, -4864(%rbp)
	movq	-4856(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4856(%rbp)
	movq	-4856(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4856(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4864(%rbp), %rdx
	movq	-4856(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2487
	leaq	.LC328(%rip), %rax
	movq	%rax, -4880(%rbp)
	movq	-4872(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4872(%rbp)
	movq	-4872(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4872(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4880(%rbp), %rdx
	movq	-4872(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2487
	leaq	.LC329(%rip), %rax
	movq	%rax, -4896(%rbp)
	movq	-4888(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4888(%rbp)
	movq	-4888(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4888(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4896(%rbp), %rdx
	movq	-4888(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2487
	leaq	.LC330(%rip), %rax
	movq	%rax, -4912(%rbp)
	movq	-4904(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4904(%rbp)
	movq	-4904(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4904(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4912(%rbp), %rdx
	movq	-4904(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2488
.L2487:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %r8d
	movl	$3, %ecx
	movl	$24, %edx
	movl	$17, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_arith_instr
	jmp	.L2383
.L2488:
	leaq	.LC331(%rip), %rax
	movq	%rax, -4928(%rbp)
	movq	-4920(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4920(%rbp)
	movq	-4920(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4920(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4928(%rbp), %rdx
	movq	-4920(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2490
	leaq	.LC332(%rip), %rax
	movq	%rax, -4944(%rbp)
	movq	-4936(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4936(%rbp)
	movq	-4936(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4936(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4944(%rbp), %rdx
	movq	-4936(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2490
	leaq	.LC333(%rip), %rax
	movq	%rax, -4960(%rbp)
	movq	-4952(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4952(%rbp)
	movq	-4952(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4952(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4960(%rbp), %rdx
	movq	-4952(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2490
	leaq	.LC334(%rip), %rax
	movq	%rax, -4976(%rbp)
	movq	-4968(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4968(%rbp)
	movq	-4968(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4968(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4976(%rbp), %rdx
	movq	-4968(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2491
.L2490:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %r8d
	movl	$4, %ecx
	movl	$32, %edx
	movl	$19, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_arith_instr
	jmp	.L2383
.L2491:
	leaq	.LC335(%rip), %rax
	movq	%rax, -4992(%rbp)
	movq	-4984(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -4984(%rbp)
	movq	-4984(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -4984(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-4992(%rbp), %rdx
	movq	-4984(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2493
	leaq	.LC336(%rip), %rax
	movq	%rax, -5008(%rbp)
	movq	-5000(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5000(%rbp)
	movq	-5000(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5000(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5008(%rbp), %rdx
	movq	-5000(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2493
	leaq	.LC337(%rip), %rax
	movq	%rax, -5024(%rbp)
	movq	-5016(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5016(%rbp)
	movq	-5016(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5016(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5024(%rbp), %rdx
	movq	-5016(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2493
	leaq	.LC338(%rip), %rax
	movq	%rax, -5040(%rbp)
	movq	-5032(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5032(%rbp)
	movq	-5032(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5032(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5040(%rbp), %rdx
	movq	-5032(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2494
.L2493:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %r8d
	movl	$5, %ecx
	movl	$40, %edx
	movl	$14, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_arith_instr
	jmp	.L2383
.L2494:
	leaq	.LC339(%rip), %rax
	movq	%rax, -5056(%rbp)
	movq	-5048(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5048(%rbp)
	movq	-5048(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5048(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5056(%rbp), %rdx
	movq	-5048(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2496
	leaq	.LC340(%rip), %rax
	movq	%rax, -5072(%rbp)
	movq	-5064(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5064(%rbp)
	movq	-5064(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5064(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5072(%rbp), %rdx
	movq	-5064(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2496
	leaq	.LC341(%rip), %rax
	movq	%rax, -5088(%rbp)
	movq	-5080(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5080(%rbp)
	movq	-5080(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5080(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5088(%rbp), %rdx
	movq	-5080(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2496
	leaq	.LC342(%rip), %rax
	movq	%rax, -5104(%rbp)
	movq	-5096(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5096(%rbp)
	movq	-5096(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5096(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5104(%rbp), %rdx
	movq	-5096(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2497
.L2496:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %r8d
	movl	$6, %ecx
	movl	$48, %edx
	movl	$18, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_arith_instr
	jmp	.L2383
.L2497:
	leaq	.LC343(%rip), %rax
	movq	%rax, -5120(%rbp)
	movq	-5112(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5112(%rbp)
	movq	-5112(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5112(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5120(%rbp), %rdx
	movq	-5112(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2499
	leaq	.LC344(%rip), %rax
	movq	%rax, -5136(%rbp)
	movq	-5128(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5128(%rbp)
	movq	-5128(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5128(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5136(%rbp), %rdx
	movq	-5128(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2499
	leaq	.LC345(%rip), %rax
	movq	%rax, -5152(%rbp)
	movq	-5144(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5144(%rbp)
	movq	-5144(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5144(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5152(%rbp), %rdx
	movq	-5144(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2499
	leaq	.LC346(%rip), %rax
	movq	%rax, -5168(%rbp)
	movq	-5160(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5160(%rbp)
	movq	-5160(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5160(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5168(%rbp), %rdx
	movq	-5160(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2500
.L2499:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %r8d
	movl	$7, %ecx
	movl	$56, %edx
	movl	$37, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_arith_instr
	jmp	.L2383
.L2500:
	leaq	.LC347(%rip), %rax
	movq	%rax, -5184(%rbp)
	movq	-5176(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5176(%rbp)
	movq	-5176(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5176(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5184(%rbp), %rdx
	movq	-5176(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2502
	leaq	.LC348(%rip), %rax
	movq	%rax, -5200(%rbp)
	movq	-5192(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5192(%rbp)
	movq	-5192(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5192(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5200(%rbp), %rdx
	movq	-5192(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2502
	leaq	.LC349(%rip), %rax
	movq	%rax, -5216(%rbp)
	movq	-5208(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5208(%rbp)
	movq	-5208(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5208(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5216(%rbp), %rdx
	movq	-5208(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2502
	leaq	.LC350(%rip), %rax
	movq	%rax, -5232(%rbp)
	movq	-5224(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5224(%rbp)
	movq	-5224(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5224(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5232(%rbp), %rdx
	movq	-5224(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2503
.L2502:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %ecx
	movl	$4, %edx
	movl	$38, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_shift
	jmp	.L2383
.L2503:
	leaq	.LC351(%rip), %rax
	movq	%rax, -5248(%rbp)
	movq	-5240(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5240(%rbp)
	movq	-5240(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5240(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5248(%rbp), %rdx
	movq	-5240(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2505
	leaq	.LC352(%rip), %rax
	movq	%rax, -5264(%rbp)
	movq	-5256(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5256(%rbp)
	movq	-5256(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5256(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5264(%rbp), %rdx
	movq	-5256(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2505
	leaq	.LC353(%rip), %rax
	movq	%rax, -5280(%rbp)
	movq	-5272(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5272(%rbp)
	movq	-5272(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5272(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5280(%rbp), %rdx
	movq	-5272(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2505
	leaq	.LC354(%rip), %rax
	movq	%rax, -5296(%rbp)
	movq	-5288(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5288(%rbp)
	movq	-5288(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5288(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5296(%rbp), %rdx
	movq	-5288(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2506
.L2505:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %ecx
	movl	$5, %edx
	movl	$39, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_shift
	jmp	.L2383
.L2506:
	leaq	.LC355(%rip), %rax
	movq	%rax, -5312(%rbp)
	movq	-5304(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5304(%rbp)
	movq	-5304(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5304(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5312(%rbp), %rdx
	movq	-5304(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2508
	leaq	.LC356(%rip), %rax
	movq	%rax, -5328(%rbp)
	movq	-5320(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5320(%rbp)
	movq	-5320(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5320(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5328(%rbp), %rdx
	movq	-5320(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2508
	leaq	.LC357(%rip), %rax
	movq	%rax, -5344(%rbp)
	movq	-5336(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5336(%rbp)
	movq	-5336(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5336(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5344(%rbp), %rdx
	movq	-5336(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2508
	leaq	.LC358(%rip), %rax
	movq	%rax, -5360(%rbp)
	movq	-5352(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5352(%rbp)
	movq	-5352(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5352(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5360(%rbp), %rdx
	movq	-5352(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2509
.L2508:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %ecx
	movl	$7, %edx
	movl	$40, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_shift
	jmp	.L2383
.L2509:
	leaq	.LC359(%rip), %rax
	movq	%rax, -5376(%rbp)
	movq	-5368(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5368(%rbp)
	movq	-5368(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5368(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5376(%rbp), %rdx
	movq	-5368(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2511
	leaq	.LC360(%rip), %rax
	movq	%rax, -5392(%rbp)
	movq	-5384(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5384(%rbp)
	movq	-5384(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5384(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5392(%rbp), %rdx
	movq	-5384(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2511
	leaq	.LC361(%rip), %rax
	movq	%rax, -5408(%rbp)
	movq	-5400(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5400(%rbp)
	movq	-5400(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5400(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5408(%rbp), %rdx
	movq	-5400(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2511
	leaq	.LC362(%rip), %rax
	movq	%rax, -5424(%rbp)
	movq	-5416(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5416(%rbp)
	movq	-5416(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5416(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5424(%rbp), %rdx
	movq	-5416(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2512
.L2511:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %edx
	movq	-3496(%rbp), %rax
	movl	%edx, %ecx
	movl	$4, %edx
	movl	$41, %esi
	movq	%rax, %rdi
	call	encoder__Encoder_shift
	jmp	.L2383
.L2512:
	leaq	.LC363(%rip), %rax
	movq	%rax, -5440(%rbp)
	movq	-5432(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5432(%rbp)
	movq	-5432(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5432(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5440(%rbp), %rdx
	movq	-5432(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2514
	movb	$15, -2767(%rbp)
	movb	$-112, -2766(%rbp)
	leaq	-2240(%rbp), %rax
	leaq	-2767(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2240(%rbp), %rax
	movq	-2232(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2224(%rbp), %rax
	movq	-2216(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$45, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2514:
	leaq	.LC364(%rip), %rax
	movq	%rax, -5456(%rbp)
	movq	-5448(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5448(%rbp)
	movq	-5448(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5448(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5456(%rbp), %rdx
	movq	-5448(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2516
	movb	$15, -2769(%rbp)
	movb	$-111, -2768(%rbp)
	leaq	-2208(%rbp), %rax
	leaq	-2769(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2208(%rbp), %rax
	movq	-2200(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2192(%rbp), %rax
	movq	-2184(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$46, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2516:
	leaq	.LC365(%rip), %rax
	movq	%rax, -5472(%rbp)
	movq	-5464(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5464(%rbp)
	movq	-5464(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5464(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5472(%rbp), %rdx
	movq	-5464(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2518
	movb	$15, -2771(%rbp)
	movb	$-110, -2770(%rbp)
	leaq	-2176(%rbp), %rax
	leaq	-2771(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2176(%rbp), %rax
	movq	-2168(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2160(%rbp), %rax
	movq	-2152(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$47, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2518:
	leaq	.LC366(%rip), %rax
	movq	%rax, -5488(%rbp)
	movq	-5480(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5480(%rbp)
	movq	-5480(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5480(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5488(%rbp), %rdx
	movq	-5480(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2520
	movb	$15, -2773(%rbp)
	movb	$-109, -2772(%rbp)
	leaq	-2144(%rbp), %rax
	leaq	-2773(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2144(%rbp), %rax
	movq	-2136(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2128(%rbp), %rax
	movq	-2120(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$49, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2520:
	leaq	.LC367(%rip), %rax
	movq	%rax, -5504(%rbp)
	movq	-5496(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5496(%rbp)
	movq	-5496(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5496(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5504(%rbp), %rdx
	movq	-5496(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2522
	movb	$15, -2775(%rbp)
	movb	$-108, -2774(%rbp)
	leaq	-2112(%rbp), %rax
	leaq	-2775(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2112(%rbp), %rax
	movq	-2104(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2096(%rbp), %rax
	movq	-2088(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$57, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2522:
	leaq	.LC368(%rip), %rax
	movq	%rax, -5520(%rbp)
	movq	-5512(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5512(%rbp)
	movq	-5512(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5512(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5520(%rbp), %rdx
	movq	-5512(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2524
	movb	$15, -2777(%rbp)
	movb	$-107, -2776(%rbp)
	leaq	-2080(%rbp), %rax
	leaq	-2777(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2080(%rbp), %rax
	movq	-2072(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2064(%rbp), %rax
	movq	-2056(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$58, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2524:
	leaq	.LC369(%rip), %rax
	movq	%rax, -5536(%rbp)
	movq	-5528(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5528(%rbp)
	movq	-5528(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5528(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5536(%rbp), %rdx
	movq	-5528(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2526
	movb	$15, -2779(%rbp)
	movb	$-109, -2778(%rbp)
	leaq	-2048(%rbp), %rax
	leaq	-2779(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2048(%rbp), %rax
	movq	-2040(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2032(%rbp), %rax
	movq	-2024(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$48, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2526:
	leaq	.LC370(%rip), %rax
	movq	%rax, -5552(%rbp)
	movq	-5544(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5544(%rbp)
	movq	-5544(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5544(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5552(%rbp), %rdx
	movq	-5544(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2528
	movb	$15, -2781(%rbp)
	movb	$-106, -2780(%rbp)
	leaq	-2016(%rbp), %rax
	leaq	-2781(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-2016(%rbp), %rax
	movq	-2008(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2000(%rbp), %rax
	movq	-1992(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$50, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2528:
	leaq	.LC371(%rip), %rax
	movq	%rax, -5568(%rbp)
	movq	-5560(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5560(%rbp)
	movq	-5560(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5560(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5568(%rbp), %rdx
	movq	-5560(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2530
	movb	$15, -2783(%rbp)
	movb	$-105, -2782(%rbp)
	leaq	-1984(%rbp), %rax
	leaq	-2783(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1984(%rbp), %rax
	movq	-1976(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1968(%rbp), %rax
	movq	-1960(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$51, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2530:
	leaq	.LC372(%rip), %rax
	movq	%rax, -5584(%rbp)
	movq	-5576(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5576(%rbp)
	movq	-5576(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5576(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5584(%rbp), %rdx
	movq	-5576(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2532
	movb	$15, -2785(%rbp)
	movb	$-101, -2784(%rbp)
	leaq	-1952(%rbp), %rax
	leaq	-2785(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1952(%rbp), %rax
	movq	-1944(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1936(%rbp), %rax
	movq	-1928(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$52, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2532:
	leaq	.LC373(%rip), %rax
	movq	%rax, -5600(%rbp)
	movq	-5592(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5592(%rbp)
	movq	-5592(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5592(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5600(%rbp), %rdx
	movq	-5592(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2534
	movb	$15, -2787(%rbp)
	movb	$-100, -2786(%rbp)
	leaq	-1920(%rbp), %rax
	leaq	-2787(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1920(%rbp), %rax
	movq	-1912(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1904(%rbp), %rax
	movq	-1896(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$53, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2534:
	leaq	.LC374(%rip), %rax
	movq	%rax, -5616(%rbp)
	movq	-5608(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5608(%rbp)
	movq	-5608(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5608(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5616(%rbp), %rdx
	movq	-5608(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2536
	movb	$15, -2789(%rbp)
	movb	$-97, -2788(%rbp)
	leaq	-1888(%rbp), %rax
	leaq	-2789(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1888(%rbp), %rax
	movq	-1880(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1872(%rbp), %rax
	movq	-1864(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$54, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2536:
	leaq	.LC375(%rip), %rax
	movq	%rax, -5632(%rbp)
	movq	-5624(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5624(%rbp)
	movq	-5624(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5624(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5632(%rbp), %rdx
	movq	-5624(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2538
	movb	$15, -2791(%rbp)
	movb	$-98, -2790(%rbp)
	leaq	-1856(%rbp), %rax
	leaq	-2791(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1856(%rbp), %rax
	movq	-1848(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1840(%rbp), %rax
	movq	-1832(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$55, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2538:
	leaq	.LC376(%rip), %rax
	movq	%rax, -5648(%rbp)
	movq	-5640(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5640(%rbp)
	movq	-5640(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5640(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5648(%rbp), %rdx
	movq	-5640(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2540
	movb	$15, -2793(%rbp)
	movb	$-99, -2792(%rbp)
	leaq	-1824(%rbp), %rax
	leaq	-2793(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1824(%rbp), %rax
	movq	-1816(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1808(%rbp), %rax
	movq	-1800(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$56, %esi
	call	encoder__Encoder_set
	addq	$32, %rsp
	jmp	.L2383
.L2540:
	leaq	.LC377(%rip), %rax
	movq	%rax, -5664(%rbp)
	movq	-5656(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -5656(%rbp)
	movq	-5656(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5656(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5664(%rbp), %rdx
	movq	-5656(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2542
	movb	$-23, -2798(%rbp)
	movb	$0, -2797(%rbp)
	movb	$0, -2796(%rbp)
	movb	$0, -2795(%rbp)
	movb	$0, -2794(%rbp)
	leaq	-1792(%rbp), %rax
	leaq	-2798(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$5, %edx
	movl	$5, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1792(%rbp), %rax
	movq	-1784(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1776(%rbp), %rax
	movq	-1768(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$1, %edx
	movl	$59, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2542:
	leaq	.LC378(%rip), %rax
	movq	%rax, -5680(%rbp)
	movq	-5672(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -5672(%rbp)
	movq	-5672(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5672(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5680(%rbp), %rdx
	movq	-5672(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2544
	movb	$15, -2804(%rbp)
	movb	$-123, -2803(%rbp)
	movb	$0, -2802(%rbp)
	movb	$0, -2801(%rbp)
	movb	$0, -2800(%rbp)
	movb	$0, -2799(%rbp)
	leaq	-1760(%rbp), %rax
	leaq	-2804(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1760(%rbp), %rax
	movq	-1752(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1744(%rbp), %rax
	movq	-1736(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$60, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2544:
	leaq	.LC379(%rip), %rax
	movq	%rax, -5696(%rbp)
	movq	-5688(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -5688(%rbp)
	movq	-5688(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5688(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5696(%rbp), %rdx
	movq	-5688(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2546
	movb	$15, -2810(%rbp)
	movb	$-124, -2809(%rbp)
	movb	$0, -2808(%rbp)
	movb	$0, -2807(%rbp)
	movb	$0, -2806(%rbp)
	movb	$0, -2805(%rbp)
	leaq	-1728(%rbp), %rax
	leaq	-2810(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1728(%rbp), %rax
	movq	-1720(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1712(%rbp), %rax
	movq	-1704(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$61, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2546:
	leaq	.LC380(%rip), %rax
	movq	%rax, -5712(%rbp)
	movq	-5704(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -5704(%rbp)
	movq	-5704(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5704(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5712(%rbp), %rdx
	movq	-5704(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2548
	movb	$15, -2816(%rbp)
	movb	$-116, -2815(%rbp)
	movb	$0, -2814(%rbp)
	movb	$0, -2813(%rbp)
	movb	$0, -2812(%rbp)
	movb	$0, -2811(%rbp)
	leaq	-1696(%rbp), %rax
	leaq	-2816(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1696(%rbp), %rax
	movq	-1688(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1680(%rbp), %rax
	movq	-1672(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$62, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2548:
	leaq	.LC381(%rip), %rax
	movq	%rax, -5728(%rbp)
	movq	-5720(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -5720(%rbp)
	movq	-5720(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5720(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5728(%rbp), %rdx
	movq	-5720(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2550
	movb	$15, -2822(%rbp)
	movb	$-113, -2821(%rbp)
	movb	$0, -2820(%rbp)
	movb	$0, -2819(%rbp)
	movb	$0, -2818(%rbp)
	movb	$0, -2817(%rbp)
	leaq	-1664(%rbp), %rax
	leaq	-2822(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1664(%rbp), %rax
	movq	-1656(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1648(%rbp), %rax
	movq	-1640(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$63, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2550:
	leaq	.LC382(%rip), %rax
	movq	%rax, -5744(%rbp)
	movq	-5736(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -5736(%rbp)
	movq	-5736(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5736(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5744(%rbp), %rdx
	movq	-5736(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2552
	movb	$15, -2828(%rbp)
	movb	$-114, -2827(%rbp)
	movb	$0, -2826(%rbp)
	movb	$0, -2825(%rbp)
	movb	$0, -2824(%rbp)
	movb	$0, -2823(%rbp)
	leaq	-1632(%rbp), %rax
	leaq	-2828(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1632(%rbp), %rax
	movq	-1624(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1616(%rbp), %rax
	movq	-1608(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$64, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2552:
	leaq	.LC383(%rip), %rax
	movq	%rax, -5760(%rbp)
	movq	-5752(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -5752(%rbp)
	movq	-5752(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5752(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5760(%rbp), %rdx
	movq	-5752(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2554
	movb	$15, -2834(%rbp)
	movb	$-115, -2833(%rbp)
	movb	$0, -2832(%rbp)
	movb	$0, -2831(%rbp)
	movb	$0, -2830(%rbp)
	movb	$0, -2829(%rbp)
	leaq	-1600(%rbp), %rax
	leaq	-2834(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1600(%rbp), %rax
	movq	-1592(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1584(%rbp), %rax
	movq	-1576(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$65, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2554:
	leaq	.LC384(%rip), %rax
	movq	%rax, -5776(%rbp)
	movq	-5768(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -5768(%rbp)
	movq	-5768(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5768(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5776(%rbp), %rdx
	movq	-5768(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2556
	movb	$15, -2840(%rbp)
	movb	$-125, -2839(%rbp)
	movb	$0, -2838(%rbp)
	movb	$0, -2837(%rbp)
	movb	$0, -2836(%rbp)
	movb	$0, -2835(%rbp)
	leaq	-1568(%rbp), %rax
	leaq	-2840(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1568(%rbp), %rax
	movq	-1560(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1552(%rbp), %rax
	movq	-1544(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$67, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2556:
	leaq	.LC385(%rip), %rax
	movq	%rax, -5792(%rbp)
	movq	-5784(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -5784(%rbp)
	movq	-5784(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5784(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5792(%rbp), %rdx
	movq	-5784(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2558
	movb	$15, -2846(%rbp)
	movb	$-122, -2845(%rbp)
	movb	$0, -2844(%rbp)
	movb	$0, -2843(%rbp)
	movb	$0, -2842(%rbp)
	movb	$0, -2841(%rbp)
	leaq	-1536(%rbp), %rax
	leaq	-2846(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1536(%rbp), %rax
	movq	-1528(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1520(%rbp), %rax
	movq	-1512(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$66, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2558:
	leaq	.LC386(%rip), %rax
	movq	%rax, -5808(%rbp)
	movq	-5800(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5800(%rbp)
	movq	-5800(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5800(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5808(%rbp), %rdx
	movq	-5800(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2560
	movb	$15, -2852(%rbp)
	movb	$-121, -2851(%rbp)
	movb	$0, -2850(%rbp)
	movb	$0, -2849(%rbp)
	movb	$0, -2848(%rbp)
	movb	$0, -2847(%rbp)
	leaq	-1504(%rbp), %rax
	leaq	-2852(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1504(%rbp), %rax
	movq	-1496(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1488(%rbp), %rax
	movq	-1480(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$68, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2560:
	leaq	.LC387(%rip), %rax
	movq	%rax, -5824(%rbp)
	movq	-5816(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -5816(%rbp)
	movq	-5816(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5816(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5824(%rbp), %rdx
	movq	-5816(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2562
	movb	$15, -2858(%rbp)
	movb	$-118, -2857(%rbp)
	movb	$0, -2856(%rbp)
	movb	$0, -2855(%rbp)
	movb	$0, -2854(%rbp)
	movb	$0, -2853(%rbp)
	leaq	-1472(%rbp), %rax
	leaq	-2858(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1472(%rbp), %rax
	movq	-1464(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1456(%rbp), %rax
	movq	-1448(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$69, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2562:
	leaq	.LC388(%rip), %rax
	movq	%rax, -5840(%rbp)
	movq	-5832(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -5832(%rbp)
	movq	-5832(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5832(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5840(%rbp), %rdx
	movq	-5832(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2564
	movb	$15, -2864(%rbp)
	movb	$-121, -2863(%rbp)
	movb	$0, -2862(%rbp)
	movb	$0, -2861(%rbp)
	movb	$0, -2860(%rbp)
	movb	$0, -2859(%rbp)
	leaq	-1440(%rbp), %rax
	leaq	-2864(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1440(%rbp), %rax
	movq	-1432(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1424(%rbp), %rax
	movq	-1416(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$70, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2564:
	leaq	.LC389(%rip), %rax
	movq	%rax, -5856(%rbp)
	movq	-5848(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -5848(%rbp)
	movq	-5848(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5848(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5856(%rbp), %rdx
	movq	-5848(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2566
	movb	$15, -2870(%rbp)
	movb	$-126, -2869(%rbp)
	movb	$0, -2868(%rbp)
	movb	$0, -2867(%rbp)
	movb	$0, -2866(%rbp)
	movb	$0, -2865(%rbp)
	leaq	-1408(%rbp), %rax
	leaq	-2870(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1408(%rbp), %rax
	movq	-1400(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1392(%rbp), %rax
	movq	-1384(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$72, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2566:
	leaq	.LC390(%rip), %rax
	movq	%rax, -5872(%rbp)
	movq	-5864(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$2, %rax
	movq	%rax, -5864(%rbp)
	movq	-5864(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5864(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5872(%rbp), %rdx
	movq	-5864(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2568
	movb	$15, -2876(%rbp)
	movb	$-120, -2875(%rbp)
	movb	$0, -2874(%rbp)
	movb	$0, -2873(%rbp)
	movb	$0, -2872(%rbp)
	movb	$0, -2871(%rbp)
	leaq	-1376(%rbp), %rax
	leaq	-2876(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1376(%rbp), %rax
	movq	-1368(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1360(%rbp), %rax
	movq	-1352(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$71, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2568:
	leaq	.LC391(%rip), %rax
	movq	%rax, -5888(%rbp)
	movq	-5880(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -5880(%rbp)
	movq	-5880(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5880(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5888(%rbp), %rdx
	movq	-5880(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2570
	movb	$15, -2882(%rbp)
	movb	$-119, -2881(%rbp)
	movb	$0, -2880(%rbp)
	movb	$0, -2879(%rbp)
	movb	$0, -2878(%rbp)
	movb	$0, -2877(%rbp)
	leaq	-1344(%rbp), %rax
	leaq	-2882(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$6, %edx
	movl	$6, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1344(%rbp), %rax
	movq	-1336(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1328(%rbp), %rax
	movq	-1320(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$2, %edx
	movl	$73, %esi
	call	encoder__Encoder_jmp_instr
	addq	$32, %rsp
	jmp	.L2383
.L2570:
	leaq	.LC392(%rip), %rax
	movq	%rax, -5904(%rbp)
	movq	-5896(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -5896(%rbp)
	movq	-5896(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5896(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5904(%rbp), %rdx
	movq	-5896(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2572
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_rep
	jmp	.L2383
.L2572:
	leaq	.LC393(%rip), %rax
	movq	%rax, -5920(%rbp)
	movq	-5912(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$10, %rax
	movq	%rax, -5912(%rbp)
	movq	-5912(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5912(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5920(%rbp), %rdx
	movq	-5912(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2574
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_cvttss2sil
	jmp	.L2383
.L2574:
	leaq	.LC394(%rip), %rax
	movq	%rax, -5936(%rbp)
	movq	-5928(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$9, %rax
	movq	%rax, -5928(%rbp)
	movq	-5928(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5928(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5936(%rbp), %rdx
	movq	-5928(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2576
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_cvtsi2ssq
	jmp	.L2383
.L2576:
	leaq	.LC395(%rip), %rax
	movq	%rax, -5952(%rbp)
	movq	-5944(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$9, %rax
	movq	%rax, -5944(%rbp)
	movq	-5944(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5944(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5952(%rbp), %rdx
	movq	-5944(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2578
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_cvtsi2sdq
	jmp	.L2383
.L2578:
	leaq	.LC396(%rip), %rax
	movq	%rax, -5968(%rbp)
	movq	-5960(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -5960(%rbp)
	movq	-5960(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5960(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5968(%rbp), %rdx
	movq	-5960(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2580
	movq	-3496(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_movd
	jmp	.L2383
.L2580:
	leaq	.LC397(%rip), %rax
	movq	%rax, -5984(%rbp)
	movq	-5976(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5976(%rbp)
	movq	-5976(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5976(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-5984(%rbp), %rdx
	movq	-5976(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2582
	movl	$1, -2888(%rbp)
	leaq	-1312(%rbp), %rax
	leaq	-2888(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1312(%rbp), %rax
	movq	-1304(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1296(%rbp), %rax
	movq	-1288(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$104, %esi
	call	encoder__Encoder_xorp
	addq	$32, %rsp
	jmp	.L2383
.L2582:
	leaq	.LC398(%rip), %rax
	movq	%rax, -6000(%rbp)
	movq	-5992(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -5992(%rbp)
	movq	-5992(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -5992(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6000(%rbp), %rdx
	movq	-5992(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2584
	leaq	-1280(%rbp), %rax
	movl	$0, %r8d
	movl	$4, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1280(%rbp), %rax
	movq	-1272(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1264(%rbp), %rax
	movq	-1256(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$105, %esi
	call	encoder__Encoder_xorp
	addq	$32, %rsp
	jmp	.L2383
.L2584:
	leaq	.LC399(%rip), %rax
	movq	%rax, -6016(%rbp)
	movq	-6008(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6008(%rbp)
	movq	-6008(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6008(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6016(%rbp), %rdx
	movq	-6008(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2586
	movl	$4, -2892(%rbp)
	leaq	-1248(%rbp), %rax
	leaq	-2892(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1248(%rbp), %rax
	movq	-1240(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1232(%rbp), %rax
	movq	-1224(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$16, %edx
	movl	$87, %esi
	call	encoder__Encoder_sse_data_transfer_instr
	addq	$32, %rsp
	jmp	.L2383
.L2586:
	leaq	.LC400(%rip), %rax
	movq	%rax, -6032(%rbp)
	movq	-6024(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6024(%rbp)
	movq	-6024(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6024(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6032(%rbp), %rdx
	movq	-6024(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2588
	movl	$5, -2896(%rbp)
	leaq	-1216(%rbp), %rax
	leaq	-2896(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1216(%rbp), %rax
	movq	-1208(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1200(%rbp), %rax
	movq	-1192(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$16, %edx
	movl	$87, %esi
	call	encoder__Encoder_sse_data_transfer_instr
	addq	$32, %rsp
	jmp	.L2383
.L2588:
	leaq	.LC401(%rip), %rax
	movq	%rax, -6048(%rbp)
	movq	-6040(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -6040(%rbp)
	movq	-6040(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6040(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6048(%rbp), %rdx
	movq	-6040(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2590
	leaq	-1184(%rbp), %rax
	movl	$0, %r8d
	movl	$4, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1184(%rbp), %rax
	movq	-1176(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1168(%rbp), %rax
	movq	-1160(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$40, %edx
	movl	$102, %esi
	call	encoder__Encoder_sse_data_transfer_instr
	addq	$32, %rsp
	jmp	.L2383
.L2590:
	leaq	.LC402(%rip), %rax
	movq	%rax, -6064(%rbp)
	movq	-6056(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -6056(%rbp)
	movq	-6056(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6056(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6064(%rbp), %rdx
	movq	-6056(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2592
	leaq	-1152(%rbp), %rax
	movl	$0, %r8d
	movl	$4, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1152(%rbp), %rax
	movq	-1144(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1136(%rbp), %rax
	movq	-1128(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$16, %edx
	movl	$103, %esi
	call	encoder__Encoder_sse_data_transfer_instr
	addq	$32, %rsp
	jmp	.L2383
.L2592:
	leaq	.LC403(%rip), %rax
	movq	%rax, -6080(%rbp)
	movq	-6072(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -6072(%rbp)
	movq	-6072(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6072(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6080(%rbp), %rdx
	movq	-6072(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2594
	movl	$1, -2904(%rbp)
	leaq	-1120(%rbp), %rax
	leaq	-2904(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2898(%rbp)
	movb	$-17, -2897(%rbp)
	leaq	-1088(%rbp), %rax
	leaq	-2898(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1120(%rbp), %rax
	movq	-1112(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1104(%rbp), %rax
	movq	-1096(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1088(%rbp), %rax
	movq	-1080(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1072(%rbp), %rax
	movq	-1064(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$106, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2594:
	leaq	.LC404(%rip), %rax
	movq	%rax, -6096(%rbp)
	movq	-6088(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$8, %rax
	movq	%rax, -6088(%rbp)
	movq	-6088(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6088(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6096(%rbp), %rdx
	movq	-6088(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2596
	movl	$5, -2912(%rbp)
	leaq	-1056(%rbp), %rax
	leaq	-2912(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2906(%rbp)
	movb	$90, -2905(%rbp)
	leaq	-1024(%rbp), %rax
	leaq	-2906(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1056(%rbp), %rax
	movq	-1048(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1040(%rbp), %rax
	movq	-1032(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-1024(%rbp), %rax
	movq	-1016(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-1008(%rbp), %rax
	movq	-1000(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$85, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2596:
	leaq	.LC405(%rip), %rax
	movq	%rax, -6112(%rbp)
	movq	-6104(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$8, %rax
	movq	%rax, -6104(%rbp)
	movq	-6104(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6104(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6112(%rbp), %rdx
	movq	-6104(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2598
	movl	$4, -2920(%rbp)
	leaq	-992(%rbp), %rax
	leaq	-2920(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2914(%rbp)
	movb	$90, -2913(%rbp)
	leaq	-960(%rbp), %rax
	leaq	-2914(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-992(%rbp), %rax
	movq	-984(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-976(%rbp), %rax
	movq	-968(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-960(%rbp), %rax
	movq	-952(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-944(%rbp), %rax
	movq	-936(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$86, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2598:
	leaq	.LC406(%rip), %rax
	movq	%rax, -6128(%rbp)
	movq	-6120(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -6120(%rbp)
	movq	-6120(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6120(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6128(%rbp), %rdx
	movq	-6120(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2600
	leaq	-928(%rbp), %rax
	movl	$0, %r8d
	movl	$4, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movb	$15, -2922(%rbp)
	movb	$46, -2921(%rbp)
	leaq	-896(%rbp), %rax
	leaq	-2922(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-928(%rbp), %rax
	movq	-920(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-912(%rbp), %rax
	movq	-904(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-896(%rbp), %rax
	movq	-888(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-880(%rbp), %rax
	movq	-872(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$90, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2600:
	leaq	.LC407(%rip), %rax
	movq	%rax, -6144(%rbp)
	movq	-6136(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -6136(%rbp)
	movq	-6136(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6136(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6144(%rbp), %rdx
	movq	-6136(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2602
	movl	$1, -2928(%rbp)
	leaq	-864(%rbp), %rax
	leaq	-2928(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2924(%rbp)
	movb	$46, -2923(%rbp)
	leaq	-832(%rbp), %rax
	leaq	-2924(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-864(%rbp), %rax
	movq	-856(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-848(%rbp), %rax
	movq	-840(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-832(%rbp), %rax
	movq	-824(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-816(%rbp), %rax
	movq	-808(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$91, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2602:
	leaq	.LC408(%rip), %rax
	movq	%rax, -6160(%rbp)
	movq	-6152(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -6152(%rbp)
	movq	-6152(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6152(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6160(%rbp), %rdx
	movq	-6152(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2604
	leaq	-800(%rbp), %rax
	movl	$0, %r8d
	movl	$4, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	movb	$15, -2930(%rbp)
	movb	$47, -2929(%rbp)
	leaq	-768(%rbp), %rax
	leaq	-2930(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-800(%rbp), %rax
	movq	-792(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-784(%rbp), %rax
	movq	-776(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-768(%rbp), %rax
	movq	-760(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-752(%rbp), %rax
	movq	-744(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$93, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2604:
	leaq	.LC409(%rip), %rax
	movq	%rax, -6176(%rbp)
	movq	-6168(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -6168(%rbp)
	movq	-6168(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6168(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6176(%rbp), %rdx
	movq	-6168(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2606
	movl	$1, -2936(%rbp)
	leaq	-736(%rbp), %rax
	leaq	-2936(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2932(%rbp)
	movb	$47, -2931(%rbp)
	leaq	-704(%rbp), %rax
	leaq	-2932(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-736(%rbp), %rax
	movq	-728(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-720(%rbp), %rax
	movq	-712(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-704(%rbp), %rax
	movq	-696(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-688(%rbp), %rax
	movq	-680(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$91, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2606:
	leaq	.LC410(%rip), %rax
	movq	%rax, -6192(%rbp)
	movq	-6184(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6184(%rbp)
	movq	-6184(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6184(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6192(%rbp), %rdx
	movq	-6184(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2608
	movl	$4, -2944(%rbp)
	leaq	-672(%rbp), %rax
	leaq	-2944(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2938(%rbp)
	movb	$92, -2937(%rbp)
	leaq	-640(%rbp), %rax
	leaq	-2938(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-672(%rbp), %rax
	movq	-664(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-656(%rbp), %rax
	movq	-648(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-640(%rbp), %rax
	movq	-632(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-624(%rbp), %rax
	movq	-616(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$94, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2608:
	leaq	.LC411(%rip), %rax
	movq	%rax, -6208(%rbp)
	movq	-6200(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6200(%rbp)
	movq	-6200(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6200(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6208(%rbp), %rdx
	movq	-6200(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2610
	movl	$5, -2952(%rbp)
	leaq	-608(%rbp), %rax
	leaq	-2952(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2946(%rbp)
	movb	$92, -2945(%rbp)
	leaq	-576(%rbp), %rax
	leaq	-2946(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-608(%rbp), %rax
	movq	-600(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-592(%rbp), %rax
	movq	-584(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-576(%rbp), %rax
	movq	-568(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-560(%rbp), %rax
	movq	-552(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$94, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2610:
	leaq	.LC412(%rip), %rax
	movq	%rax, -6224(%rbp)
	movq	-6216(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6216(%rbp)
	movq	-6216(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6216(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6224(%rbp), %rdx
	movq	-6216(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2612
	movl	$4, -2960(%rbp)
	leaq	-544(%rbp), %rax
	leaq	-2960(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2954(%rbp)
	movb	$88, -2953(%rbp)
	leaq	-512(%rbp), %rax
	leaq	-2954(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-544(%rbp), %rax
	movq	-536(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-528(%rbp), %rax
	movq	-520(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-512(%rbp), %rax
	movq	-504(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-496(%rbp), %rax
	movq	-488(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$96, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2612:
	leaq	.LC413(%rip), %rax
	movq	%rax, -6240(%rbp)
	movq	-6232(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6232(%rbp)
	movq	-6232(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6232(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6240(%rbp), %rdx
	movq	-6232(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2614
	movl	$5, -2968(%rbp)
	leaq	-480(%rbp), %rax
	leaq	-2968(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2962(%rbp)
	movb	$88, -2961(%rbp)
	leaq	-448(%rbp), %rax
	leaq	-2962(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-480(%rbp), %rax
	movq	-472(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-464(%rbp), %rax
	movq	-456(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-448(%rbp), %rax
	movq	-440(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-432(%rbp), %rax
	movq	-424(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$97, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2614:
	leaq	.LC414(%rip), %rax
	movq	%rax, -6256(%rbp)
	movq	-6248(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6248(%rbp)
	movq	-6248(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6248(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6256(%rbp), %rdx
	movq	-6248(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2616
	movl	$4, -2976(%rbp)
	leaq	-416(%rbp), %rax
	leaq	-2976(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2970(%rbp)
	movb	$89, -2969(%rbp)
	leaq	-384(%rbp), %rax
	leaq	-2970(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-416(%rbp), %rax
	movq	-408(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-400(%rbp), %rax
	movq	-392(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-384(%rbp), %rax
	movq	-376(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-368(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$98, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2616:
	leaq	.LC415(%rip), %rax
	movq	%rax, -6272(%rbp)
	movq	-6264(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6264(%rbp)
	movq	-6264(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6264(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6272(%rbp), %rdx
	movq	-6264(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2618
	movl	$5, -2984(%rbp)
	leaq	-352(%rbp), %rax
	leaq	-2984(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2978(%rbp)
	movb	$89, -2977(%rbp)
	leaq	-320(%rbp), %rax
	leaq	-2978(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-352(%rbp), %rax
	movq	-344(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-336(%rbp), %rax
	movq	-328(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-320(%rbp), %rax
	movq	-312(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-304(%rbp), %rax
	movq	-296(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$99, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2618:
	leaq	.LC416(%rip), %rax
	movq	%rax, -6288(%rbp)
	movq	-6280(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6280(%rbp)
	movq	-6280(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6280(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6288(%rbp), %rdx
	movq	-6280(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2620
	movl	$4, -2992(%rbp)
	leaq	-288(%rbp), %rax
	leaq	-2992(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2986(%rbp)
	movb	$94, -2985(%rbp)
	leaq	-256(%rbp), %rax
	leaq	-2986(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-288(%rbp), %rax
	movq	-280(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-272(%rbp), %rax
	movq	-264(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-256(%rbp), %rax
	movq	-248(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$100, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2620:
	leaq	.LC417(%rip), %rax
	movq	%rax, -6304(%rbp)
	movq	-6296(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6296(%rbp)
	movq	-6296(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6296(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6304(%rbp), %rdx
	movq	-6296(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2622
	movl	$5, -3000(%rbp)
	leaq	-224(%rbp), %rax
	leaq	-3000(%rbp), %rdx
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movb	$15, -2994(%rbp)
	movb	$94, -2993(%rbp)
	leaq	-192(%rbp), %rax
	leaq	-2994(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-224(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-208(%rbp), %rax
	movq	-200(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	$101, %esi
	call	encoder__Encoder_sse_arith_instr
	addq	$64, %rsp
	jmp	.L2383
.L2622:
	leaq	.LC418(%rip), %rax
	movq	%rax, -6320(%rbp)
	movq	-6312(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -6312(%rbp)
	movq	-6312(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6312(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6320(%rbp), %rdx
	movq	-6312(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2624
	leaq	.LC419(%rip), %rax
	movq	%rax, -6336(%rbp)
	movq	-6328(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -6328(%rbp)
	movq	-6328(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6328(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6336(%rbp), %rdx
	movq	-6328(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2624
	leaq	.LC420(%rip), %rax
	movq	%rax, -6352(%rbp)
	movq	-6344(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$6, %rax
	movq	%rax, -6344(%rbp)
	movq	-6344(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6344(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6352(%rbp), %rdx
	movq	-6344(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2625
.L2624:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %ebx
	movb	$15, -3002(%rbp)
	movb	$72, -3001(%rbp)
	leaq	-160(%rbp), %rax
	leaq	-3002(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-160(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%ebx, %edx
	movl	$79, %esi
	call	encoder__Encoder_cmov
	addq	$32, %rsp
	jmp	.L2383
.L2625:
	leaq	.LC421(%rip), %rax
	movq	%rax, -6368(%rbp)
	movq	-6360(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -6360(%rbp)
	movq	-6360(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6360(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6368(%rbp), %rdx
	movq	-6360(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2627
	leaq	.LC422(%rip), %rax
	movq	%rax, -6384(%rbp)
	movq	-6376(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -6376(%rbp)
	movq	-6376(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6376(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6384(%rbp), %rdx
	movq	-6376(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2627
	leaq	.LC423(%rip), %rax
	movq	%rax, -6400(%rbp)
	movq	-6392(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -6392(%rbp)
	movq	-6392(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6392(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6400(%rbp), %rdx
	movq	-6392(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2628
.L2627:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %ebx
	movb	$15, -3004(%rbp)
	movb	$73, -3003(%rbp)
	leaq	-128(%rbp), %rax
	leaq	-3004(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%ebx, %edx
	movl	$80, %esi
	call	encoder__Encoder_cmov
	addq	$32, %rsp
	jmp	.L2383
.L2628:
	leaq	.LC424(%rip), %rax
	movq	%rax, -6416(%rbp)
	movq	-6408(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -6408(%rbp)
	movq	-6408(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6408(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6416(%rbp), %rdx
	movq	-6408(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2630
	leaq	.LC425(%rip), %rax
	movq	%rax, -6432(%rbp)
	movq	-6424(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -6424(%rbp)
	movq	-6424(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6424(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6432(%rbp), %rdx
	movq	-6424(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2630
	leaq	.LC426(%rip), %rax
	movq	%rax, -6448(%rbp)
	movq	-6440(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -6440(%rbp)
	movq	-6440(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6440(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6448(%rbp), %rdx
	movq	-6440(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2631
.L2630:
	movq	-2656(%rbp), %rdx
	movq	-2648(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	encoder__get_size_by_suffix
	movl	%eax, %ebx
	movb	$15, -3006(%rbp)
	movb	$77, -3005(%rbp)
	leaq	-96(%rbp), %rax
	leaq	-3006(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	movq	-3496(%rbp), %rdi
	subq	$32, %rsp
	movq	%rsp, %rcx
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-80(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rax, 16(%rcx)
	movq	%rdx, 24(%rcx)
	movl	%ebx, %edx
	movl	$81, %esi
	call	encoder__Encoder_cmov
	addq	$32, %rsp
	jmp	.L2383
.L2631:
	leaq	.LC427(%rip), %rax
	movq	%rax, -6464(%rbp)
	movq	-6456(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -6456(%rbp)
	movq	-6456(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6456(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6464(%rbp), %rdx
	movq	-6456(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2633
	leaq	.LC428(%rip), %rax
	movq	%rax, -6480(%rbp)
	movq	-6472(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -6472(%rbp)
	movq	-6472(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6472(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6480(%rbp), %rdx
	movq	-6472(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2634
.L2633:
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$74, -3280(%rbp)
	movb	$-61, -3007(%rbp)
	leaq	-3272(%rbp), %rax
	leaq	-3007(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -3016(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-3016(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2634:
	leaq	.LC429(%rip), %rax
	movq	%rax, -6496(%rbp)
	movq	-6488(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$7, %rax
	movq	%rax, -6488(%rbp)
	movq	-6488(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6488(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6496(%rbp), %rdx
	movq	-6488(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2636
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$75, -3280(%rbp)
	movb	$15, -3018(%rbp)
	movb	$5, -3017(%rbp)
	leaq	-3272(%rbp), %rax
	leaq	-3018(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -3032(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-3032(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2636:
	leaq	.LC430(%rip), %rax
	movq	%rax, -6512(%rbp)
	movq	-6504(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -6504(%rbp)
	movq	-6504(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6504(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6512(%rbp), %rdx
	movq	-6504(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2638
	leaq	.LC431(%rip), %rax
	movq	%rax, -6528(%rbp)
	movq	-6520(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -6520(%rbp)
	movq	-6520(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6520(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6528(%rbp), %rdx
	movq	-6520(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2639
.L2638:
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$76, -3280(%rbp)
	movb	$-112, -3033(%rbp)
	leaq	-3272(%rbp), %rax
	leaq	-3033(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -3048(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-3048(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2639:
	leaq	.LC432(%rip), %rax
	movq	%rax, -6544(%rbp)
	movq	-6536(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -6536(%rbp)
	movq	-6536(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6536(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6544(%rbp), %rdx
	movq	-6536(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2641
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$77, -3280(%rbp)
	movb	$-12, -3049(%rbp)
	leaq	-3272(%rbp), %rax
	leaq	-3049(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -3064(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-3064(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2641:
	leaq	.LC433(%rip), %rax
	movq	%rax, -6560(%rbp)
	movq	-6552(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$5, %rax
	movq	%rax, -6552(%rbp)
	movq	-6552(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6552(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6560(%rbp), %rdx
	movq	-6552(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2643
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$78, -3280(%rbp)
	movb	$-55, -3065(%rbp)
	leaq	-3272(%rbp), %rax
	leaq	-3065(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -3080(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-3080(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2643:
	leaq	.LC434(%rip), %rax
	movq	%rax, -6576(%rbp)
	movq	-6568(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -6568(%rbp)
	movq	-6568(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6568(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6576(%rbp), %rdx
	movq	-6568(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2645
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$34, -3280(%rbp)
	movb	$72, -3082(%rbp)
	movb	$-104, -3081(%rbp)
	leaq	-3272(%rbp), %rax
	leaq	-3082(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -3096(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-3096(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2645:
	leaq	.LC435(%rip), %rax
	movq	%rax, -6592(%rbp)
	movq	-6584(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -6584(%rbp)
	movq	-6584(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6584(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6592(%rbp), %rdx
	movq	-6584(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2647
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$35, -3280(%rbp)
	movb	$-103, -3097(%rbp)
	leaq	-3272(%rbp), %rax
	leaq	-3097(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -3112(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-3112(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2647:
	leaq	.LC436(%rip), %rax
	movq	%rax, -6608(%rbp)
	movq	-6600(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -6600(%rbp)
	movq	-6600(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6600(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6608(%rbp), %rdx
	movq	-6600(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2649
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$33, -3280(%rbp)
	movb	$72, -3114(%rbp)
	movb	$-103, -3113(%rbp)
	leaq	-3272(%rbp), %rax
	leaq	-3114(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$2, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -3128(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-3128(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2649:
	leaq	.LC437(%rip), %rax
	movq	%rax, -6624(%rbp)
	movq	-6616(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$4, %rax
	movq	%rax, -6616(%rbp)
	movq	-6616(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -6616(%rbp)
	movq	-2656(%rbp), %rsi
	movq	-2648(%rbp), %rax
	movq	-6624(%rbp), %rdx
	movq	-6616(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2651
	leaq	-3280(%rbp), %rdx
	movl	$0, %eax
	movl	$17, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$36, -3280(%rbp)
	movb	$-104, -3129(%rbp)
	leaq	-3272(%rbp), %rax
	leaq	-3129(%rbp), %rdx
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	new_array_from_c_array
	leaq	.LC34(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3228(%rbp)
	leaq	.LC34(%rip), %rax
	movq	%rax, -3224(%rbp)
	movl	$1, -3212(%rbp)
	movq	-3496(%rbp), %rax
	movq	112(%rax), %rdx
	movq	104(%rax), %rax
	movq	%rax, -3192(%rbp)
	movq	%rdx, -3184(%rbp)
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, -3168(%rbp)
	movq	%rdx, -3160(%rbp)
	movq	-2608(%rbp), %rax
	movq	%rax, -3152(%rbp)
	leaq	-3280(%rbp), %rax
	movl	$136, %esi
	movq	%rax, %rdi
	call	memdup
	movq	%rax, -3144(%rbp)
	movq	-3496(%rbp), %rax
	leaq	128(%rax), %rdx
	leaq	-3144(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2383
.L2651:
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -3280(%rbp)
	movaps	%xmm0, -3264(%rbp)
	movaps	%xmm0, -3248(%rbp)
	movaps	%xmm0, -3232(%rbp)
	movaps	%xmm0, -3216(%rbp)
	leaq	.LC438(%rip), %rax
	movq	%rax, -3280(%rbp)
	movl	$21, -3272(%rbp)
	movl	$1, -3268(%rbp)
	movl	$65040, -3264(%rbp)
	movq	-2640(%rbp), %rax
	movq	-2632(%rbp), %rdx
	movq	%rax, -3256(%rbp)
	movq	%rdx, -3248(%rbp)
	leaq	.LC89(%rip), %rax
	movq	%rax, -3240(%rbp)
	movl	$1, -3232(%rbp)
	movl	$1, -3228(%rbp)
	leaq	-3280(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	-2624(%rbp), %rax
	movq	-2616(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-2608(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2383:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.globl	encoder__Encoder_encode
encoder__Encoder_encode:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
.L2655:
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$14, %eax
	je	.L2657
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	encoder__Encoder_encode_instr
	jmp	.L2655
.L2657:
	nop
	nop
	leave
	ret
	.globl	encoder__Encoder_add_segment_override_prefix
	.hidden	encoder__Encoder_add_segment_override_prefix
encoder__Encoder_add_segment_override_prefix:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	56(%rbp), %eax
	cmpl	$2, %eax
	je	.L2659
	movl	104(%rbp), %eax
	cmpl	$2, %eax
	jne	.L2661
.L2659:
	movb	$103, -1(%rbp)
	movq	-24(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-1(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
.L2661:
	nop
	leave
	ret
	.section	.rodata, "a"
.LC439:
	.string	"scale unreachable"
	.text
	.globl	encoder__scale
	.hidden	encoder__scale
encoder__scale:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movl	%edi, %ecx
	movb	%cl, -36(%rbp)
	movzbl	-36(%rbp), %ecx
	cmpl	$8, %ecx
	je	.L2663
	cmpl	$8, %ecx
	jg	.L2664
	cmpl	$4, %ecx
	je	.L2665
	cmpl	$4, %ecx
	jg	.L2664
	cmpl	$1, %ecx
	je	.L2666
	cmpl	$2, %ecx
	je	.L2667
	jmp	.L2664
.L2666:
	movb	$0, -20(%rbp)
	movzbl	-20(%rbp), %eax
	jmp	.L2668
.L2667:
	movb	$1, -19(%rbp)
	movzbl	-19(%rbp), %eax
	jmp	.L2668
.L2665:
	movb	$2, -18(%rbp)
	movzbl	-18(%rbp), %eax
	jmp	.L2668
.L2663:
	movb	$3, -17(%rbp)
	movzbl	-17(%rbp), %eax
	jmp	.L2668
.L2664:
	leaq	.LC439(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$17, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rdx, %rax
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_v_panic
.L2668:
	movq	-8(%rbp), %rbx
	leave
	ret
	.section	.rodata, "a"
.LC440:
	.string	"RIP"
.LC441:
	.string	"EIP"
.LC442:
	.string	"RSP"
.LC443:
	.string	"ESP"
.LC444:
	.string	"RBP"
.LC445:
	.string	"EBP"
	.text
	.globl	encoder__Indirection_check_base_register
	.hidden	encoder__Indirection_check_base_register
encoder__Indirection_check_base_register:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$88, %rsp
	movzbl	184(%rbp), %ecx
	testb	%cl, %cl
	jne	.L2670
	movb	$0, -52(%rbp)
	movb	$0, -51(%rbp)
	movb	$0, -50(%rbp)
	jmp	.L2687
.L2670:
	movb	$1, -49(%rbp)
	movzbl	-49(%rbp), %ebx
	leaq	.LC440(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$3, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	40(%rbp), %rsi
	movq	48(%rbp), %r8
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movq	%rsi, %rdi
	movq	%r8, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2672
	leaq	.LC441(%rip), %r12
	movq	%r13, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, %r13
	movq	%r13, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r13
	movq	40(%rbp), %rsi
	movq	48(%rbp), %rax
	movq	%r12, %rdx
	movq	%r13, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2673
.L2672:
	movl	$1, %eax
	jmp	.L2674
.L2673:
	movl	$0, %eax
.L2674:
	cmpl	%ebx, %eax
	jne	.L2675
	movb	$1, -52(%rbp)
	movb	$0, -51(%rbp)
	movb	$0, -50(%rbp)
	jmp	.L2687
.L2675:
	movzbl	-49(%rbp), %ebx
	leaq	.LC442(%rip), %rax
	movq	%rax, -96(%rbp)
	movq	-88(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -88(%rbp)
	movq	40(%rbp), %rsi
	movq	48(%rbp), %rax
	movq	-96(%rbp), %rdx
	movq	-88(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2677
	leaq	.LC443(%rip), %r14
	movq	%r15, %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, %r15
	movq	%r15, %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, %r15
	movq	40(%rbp), %rsi
	movq	48(%rbp), %rax
	movq	%r14, %rdx
	movq	%r15, %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2678
.L2677:
	movl	$1, %eax
	jmp	.L2679
.L2678:
	movl	$0, %eax
.L2679:
	cmpl	%ebx, %eax
	jne	.L2680
	movb	$0, -52(%rbp)
	movb	$1, -51(%rbp)
	movb	$0, -50(%rbp)
	jmp	.L2687
.L2680:
	movzbl	-49(%rbp), %ebx
	leaq	.LC444(%rip), %rax
	movq	%rax, -112(%rbp)
	movq	-104(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -104(%rbp)
	movq	40(%rbp), %rsi
	movq	48(%rbp), %rax
	movq	-112(%rbp), %rdx
	movq	-104(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	jne	.L2682
	leaq	.LC445(%rip), %rax
	movq	%rax, -128(%rbp)
	movq	-120(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$3, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -120(%rbp)
	movq	40(%rbp), %rsi
	movq	48(%rbp), %rax
	movq	-128(%rbp), %rdx
	movq	-120(%rbp), %rcx
	movq	%rsi, %rdi
	movq	%rax, %rsi
	call	string__eq
	testb	%al, %al
	je	.L2683
.L2682:
	movl	$1, %eax
	jmp	.L2684
.L2683:
	movl	$0, %eax
.L2684:
	cmpl	%ebx, %eax
	jne	.L2685
	movb	$0, -52(%rbp)
	movb	$0, -51(%rbp)
	movb	$1, -50(%rbp)
	jmp	.L2687
.L2685:
	movb	$0, -52(%rbp)
	movb	$0, -51(%rbp)
	movb	$0, -50(%rbp)
.L2687:
	movl	$0, %eax
	movzwl	-52(%rbp), %edx
	movzwl	%dx, %edx
	movw	$0, %ax
	orq	%rdx, %rax
	movzbl	-50(%rbp), %edx
	movzbl	%dl, %edx
	salq	$16, %rdx
	andq	$-16711681, %rax
	orq	%rdx, %rax
	addq	$88, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.section	.rodata, "a"
.LC446:
	.string	"syntax not supported yet. `disp(,,)`"
.LC447:
	.string	" as base register can not have an index register"
.LC448:
	.string	"base register is "
.LC449:
	.string	"-bit, but index register is not"
.LC450:
	.string	"disp out range!"
.LC451:
	.string	"scale factor in address must be 1, 2, 4 or 8"
	.text
	.globl	encoder__Encoder_add_modrm_sib_disp
	.hidden	encoder__Encoder_add_modrm_sib_disp
encoder__Encoder_add_modrm_sib_disp:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$312, %rsp
	movq	%rdi, -312(%rbp)
	movl	%esi, %ecx
	movb	%cl, -316(%rbp)
	movzbl	184(%rbp), %ecx
	testb	%cl, %cl
	jne	.L2689
	movzbl	185(%rbp), %ecx
	testb	%cl, %cl
	jne	.L2689
	leaq	.LC446(%rip), %rax
	movq	%rdx, %rsi
	movabsq	$-4294967296, %rcx
	andq	%rsi, %rcx
	orq	$36, %rcx
	movq	%rcx, %rdx
	movq	%rdx, %rcx
	movl	%ecx, %esi
	movabsq	$4294967296, %rcx
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	160(%rbp), %rax
	movq	168(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	176(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2689:
	subq	$176, %rsp
	movq	%rsp, %rax
	movq	16(%rbp), %rcx
	movq	24(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	32(%rbp), %rcx
	movq	40(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	48(%rbp), %rcx
	movq	56(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	64(%rbp), %rcx
	movq	72(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	80(%rbp), %rcx
	movq	88(%rbp), %rbx
	movq	%rcx, 64(%rax)
	movq	%rbx, 72(%rax)
	movq	96(%rbp), %rcx
	movq	104(%rbp), %rbx
	movq	%rcx, 80(%rax)
	movq	%rbx, 88(%rax)
	movq	112(%rbp), %rcx
	movq	120(%rbp), %rbx
	movq	%rcx, 96(%rax)
	movq	%rbx, 104(%rax)
	movq	128(%rbp), %rcx
	movq	136(%rbp), %rbx
	movq	%rcx, 112(%rax)
	movq	%rbx, 120(%rax)
	movq	144(%rbp), %rcx
	movq	152(%rbp), %rbx
	movq	%rcx, 128(%rax)
	movq	%rbx, 136(%rax)
	movq	160(%rbp), %rcx
	movq	168(%rbp), %rbx
	movq	%rcx, 144(%rax)
	movq	%rbx, 152(%rax)
	movq	176(%rbp), %rcx
	movq	184(%rbp), %rbx
	movq	%rcx, 160(%rax)
	movq	%rbx, 168(%rax)
	call	encoder__Indirection_check_base_register
	addq	$176, %rsp
	cltq
	movb	%al, -75(%rbp)
	movzbl	%ah, %edx
	movb	%dl, -74(%rbp)
	shrq	$16, %rax
	andb	$-1, %ah
	movb	%al, -73(%rbp)
	movzbl	-75(%rbp), %eax
	movb	%al, -49(%rbp)
	movzbl	-74(%rbp), %eax
	movb	%al, -50(%rbp)
	movzbl	-73(%rbp), %eax
	movb	%al, -51(%rbp)
	leaq	-112(%rbp), %rax
	movl	$0, %r8d
	movl	$16, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	__new_array_with_default
	leaq	-112(%rbp), %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	16(%rbp), %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	32(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	%rsi, %rdi
	call	encoder__eval_expr_get_symbol_64
	addq	$32, %rsp
	movl	%eax, -56(%rbp)
	movl	-92(%rbp), %eax
	cmpl	$1, %eax
	jle	.L2690
	leaq	.LC233(%rip), %rax
	movq	%rax, -336(%rbp)
	movq	-328(%rbp), %rdx
	movabsq	$-4294967296, %rax
	andq	%rdx, %rax
	orq	$15, %rax
	movq	%rax, -328(%rbp)
	movq	-328(%rbp), %rax
	movl	%eax, %edx
	movabsq	$4294967296, %rax
	orq	%rdx, %rax
	movq	%rax, -328(%rbp)
	movq	32(%rbp), %rcx
	movq	-336(%rbp), %rax
	movq	-328(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rsi, %rdi
	movq	%rdx, %r8
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rsi
	movq	(%rcx), %rax
	movq	8(%rcx), %rdx
	movq	%rax, (%rsi)
	movq	%rdx, 8(%rsi)
	movq	16(%rcx), %rax
	movq	%rax, 16(%rsi)
	movq	%r8, %rsi
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2690:
	movl	-92(%rbp), %eax
	cmpl	$1, %eax
	sete	%al
	movb	%al, -57(%rbp)
	movzbl	185(%rbp), %eax
	testb	%al, %al
	je	.L2691
	cmpb	$0, -49(%rbp)
	je	.L2692
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -224(%rbp)
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -160(%rbp)
	leaq	.LC211(%rip), %rax
	movq	%rax, -224(%rbp)
	movl	$1, -216(%rbp)
	movl	$1, -212(%rbp)
	movl	$65040, -208(%rbp)
	movq	40(%rbp), %rdx
	movq	48(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	string_to_lower
	movq	%rax, -200(%rbp)
	movq	%rdx, -192(%rbp)
	leaq	.LC447(%rip), %rax
	movq	%rax, -184(%rbp)
	movl	$48, -176(%rbp)
	movl	$1, -172(%rbp)
	leaq	-224(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	112(%rbp), %rax
	movq	120(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	128(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2692:
	movl	56(%rbp), %edx
	movl	104(%rbp), %eax
	cmpl	%eax, %edx
	je	.L2693
	movzbl	184(%rbp), %eax
	testb	%al, %al
	je	.L2693
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -224(%rbp)
	movaps	%xmm0, -208(%rbp)
	movaps	%xmm0, -192(%rbp)
	movaps	%xmm0, -176(%rbp)
	movaps	%xmm0, -160(%rbp)
	leaq	.LC448(%rip), %rax
	movq	%rax, -224(%rbp)
	movl	$17, -216(%rbp)
	movl	$1, -212(%rbp)
	movl	$65040, -208(%rbp)
	movl	56(%rbp), %eax
	movl	%eax, %edi
	call	encoder__DataSize_str
	movq	%rax, -200(%rbp)
	movq	%rdx, -192(%rbp)
	leaq	.LC449(%rip), %rax
	movq	%rax, -184(%rbp)
	movl	$31, -176(%rbp)
	movl	$1, -172(%rbp)
	leaq	-224(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	str_intp
	movq	%rax, %rcx
	movq	%rdx, %rbx
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	subq	$8, %rsp
	subq	$24, %rsp
	movq	%rsp, %rcx
	movq	64(%rbp), %rax
	movq	72(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	80(%rbp), %rax
	movq	%rax, 16(%rcx)
	call	error__print
	addq	$32, %rsp
	movl	$1, %edi
	call	_v_exit
.L2693:
	movzbl	184(%rbp), %eax
	testb	%al, %al
	jne	.L2694
	movzbl	-316(%rbp), %ecx
	movl	$0, %eax
	movzbl	%al, %eax
	movl	$4, %edx
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -113(%rbp)
	movq	-312(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-113(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2700
.L2694:
	cmpb	$0, -57(%rbp)
	je	.L2696
	movzbl	-316(%rbp), %ecx
	movl	$2, %eax
	movzbl	%al, %eax
	movl	$4, %edx
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -114(%rbp)
	movq	-312(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-114(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	array_push
	jmp	.L2700
.L2696:
	cmpl	$0, -56(%rbp)
	jne	.L2697
	cmpb	$0, -51(%rbp)
	jne	.L2697
	movzbl	-316(%rbp), %ecx
	movl	$0, %eax
	movzbl	%al, %eax
	movl	$4, %edx
	movl	%ecx, %esi
	movl	%eax, %edi
	call	encoder__compose_mod_rm
	movb	%al, -115(%rbp)
	movq	-312(%rbp), %rax
	movq	120(%rax), %rax
	leaq	8(%rax), %rdx
	leaq	-115(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	cltq