# .pushsection to a section that was never declared, with no flags string,
# must create it (GNU as behaviour) instead of panicking.
.text
.globl main
main:
	ret
.pushsection .text.hot
hot:
	ret
.popsection
.pushsection .rodata.str, "a"
.asciz "x"
.popsection
.pushsection .text.hot
	nop
.popsection
	ret
