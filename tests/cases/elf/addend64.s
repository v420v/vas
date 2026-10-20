# Relocation addends are 64-bit: .quad sym + <large> must keep the high bits
# (the Linux kernel's `.quad sym - 0xffffffff80000000` pattern).
.data
.quad a + 0x100000000
.quad a + 0x80000000
.quad a - 0xffffffff80000000
.quad a - 1
.text
	movabsq $a + 0x100000000, %rax
