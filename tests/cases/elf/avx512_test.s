.global _start
.text
_start:
    vaddpd %zmm0, %zmm1, %zmm2
    vmulpd %zmm3, %zmm4, %zmm5
    vpaddd %zmm0, %zmm1, %zmm2
    vmovdqu64 %zmm0, %zmm1
    vmovdqu64 (%rsp), %zmm0
    vpxorq %zmm0, %zmm0, %zmm0
    ret
