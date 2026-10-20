# Leading-zero integer literals are octal (GNU as): 0777 = 511, 010 = 8.
.text
	movq $010, %rax
	addq $0777, %rax
	movq 010(%rax), %rbx
.data
.long 0777
.byte 010, 0, 00, 07
.quad 01777777777777777777777
.float 0.5
