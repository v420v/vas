.global _start
.text
_start:
    movss (%rsp), %xmm0
    movss %xmm0, (%rsp)
    addss %xmm1, %xmm0
    subsd %xmm2, %xmm0
    mulss %xmm3, %xmm0
    movaps (%rsp), %xmm5
    movups %xmm0, (%rsp)
    xorps %xmm0, %xmm0
    xorpd %xmm1, %xmm1
    pxor %xmm2, %xmm3
    ucomiss %xmm0, %xmm1
    movd %eax, %xmm0
    movd %xmm0, %eax
    ret
