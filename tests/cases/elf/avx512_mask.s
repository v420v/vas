.global _start
.text
_start:
    vaddpd %zmm0, %zmm1, %zmm2
    vaddpd %zmm0, %zmm1, %zmm2{%k1}
    vaddpd %zmm0, %zmm1, %zmm2{%k3}{z}
    vmovdqu64 %zmm0, %zmm1{%k7}
    vpaddd %zmm0, %zmm1, %zmm2{%k2}{z}
    ret
