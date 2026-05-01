.global _start
.text
_start:
    # broadcast
    vaddpd (%rsp){1to8}, %zmm1, %zmm2
    vmulps (%rsp){1to16}, %zmm1, %zmm2
    # sae and rounding
    vaddpd %zmm0, %zmm1, %zmm2{rn-sae}
    vaddpd %zmm0, %zmm1, %zmm2{rd-sae}
    vaddpd %zmm0, %zmm1, %zmm2{ru-sae}
    vaddpd %zmm0, %zmm1, %zmm2{rz-sae}
    vcomisd %xmm0, %xmm1{sae}
    # combinations
    vaddpd %zmm0, %zmm1, %zmm2{%k1}{rn-sae}
    ret
