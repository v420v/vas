# A 64-bit operand sign-extends its imm32, so 0x80000000..0xffffffff must be
# encoded as a full 64-bit immediate (movabsq), not as a negative imm32.
.text
	movq $0xffffffff, %rax
	movq $0x80000000, %rcx
	movq $0x7fffffff, %rdx
	movq $-1, %rbx
	movq $-0x80000000, %rsi
	movl $0xffffffff, %eax
	movq $0x100000000, %rdi
	mov $0xffffffff, %r8
	mov $0x1234, %rax
