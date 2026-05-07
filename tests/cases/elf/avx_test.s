.global _start
.text
_start:
    vmovaps (%rsp), %xmm0
    vmovaps %xmm0, (%rsp)
    vmovaps (%rsp), %ymm0
    vmovaps %ymm0, (%rsp)
    vaddps %xmm1, %xmm0, %xmm2
    vaddps %ymm1, %ymm0, %ymm2
    vaddss %xmm1, %xmm0, %xmm2
    vpxor %xmm0, %xmm0, %xmm0
    vpxor %ymm0, %ymm0, %ymm0
    vxorps %xmm1, %xmm0, %xmm2
    ret
