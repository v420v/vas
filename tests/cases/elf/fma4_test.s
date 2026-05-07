.global _start
.text
_start:
    # 4-op rvmi: VBLENDPS reg,reg,r/m,imm
    vblendps $0x5, %xmm2, %xmm1, %xmm3
    vblendps $0xa, %ymm2, %ymm1, %ymm3
    vcmppd   $0x4, %xmm2, %xmm1, %xmm3
    vcmpps   $0x0, %ymm2, %ymm1, %ymm3
    # FMA3 (rvm) — already worked; sanity check
    vfmadd132pd %xmm2, %xmm1, %xmm3
    vfmadd213ps %ymm2, %ymm1, %ymm3
    ret
