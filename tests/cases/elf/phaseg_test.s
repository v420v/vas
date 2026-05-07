.global _start
.text
_start:
    # mri: SHLD imm
    shldw $5, %ax, %bx
    shldl $7, %eax, %ebx
    shldq $3, %rax, %rbx
    # mri: PEXTRB / EXTRACTPS
    pextrb $0, %xmm0, %eax
    extractps $1, %xmm0, %eax
    # rmv: BEXTR / BZHI (BMI1, AT&T uses L/Q suffix)
    bextrl %eax, %ebx, %ecx
    bextrq %rax, %rbx, %rcx
    bzhil  %eax, %ebx, %ecx
    # vmi: VPSLLW imm shift
    vpsllw $5, %xmm1, %xmm2
    vpsrld $2, %xmm1, %xmm2
    vpslld $3, %ymm1, %ymm2
    ret
