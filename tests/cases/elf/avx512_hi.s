.global _start
.text
_start:
    vaddpd %zmm0, %zmm16, %zmm17
    vaddpd %zmm16, %zmm17, %zmm0
    vmulps %zmm15, %zmm16, %zmm17
    ret
