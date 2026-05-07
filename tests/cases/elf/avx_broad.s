.global _start
.text
_start:
    # AVX1 basics
    vmovaps %xmm0, %xmm1
    vmovups %ymm0, %ymm1
    vaddps  %xmm1, %xmm2, %xmm3
    vsubpd  %ymm1, %ymm2, %ymm3
    vmulss  %xmm0, %xmm1, %xmm2
    vdivsd  %xmm0, %xmm1, %xmm2
    vxorps  %xmm0, %xmm0, %xmm0
    # AVX2 integer
    vpaddq  %ymm0, %ymm1, %ymm2
    vpsubd  %xmm0, %xmm1, %xmm2
    vpmullw %ymm0, %ymm1, %ymm2
    vpand   %xmm0, %xmm1, %xmm2
    # Memory operands
    vmovaps (%rsp), %xmm0
    vaddps  (%rsp), %xmm0, %xmm1
    vaddps  (%rsp), %ymm0, %ymm1
    # High registers
    vmovaps %xmm15, %xmm14
    vaddps  %ymm15, %ymm14, %ymm13
    ret
