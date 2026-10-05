# #84: EVEX disp8*N. An 8-bit displacement in an EVEX-encoded memory operand
# is scaled by N (tuple type x vector length x element width x broadcast), so
# `64(%rax)` on a 512-bit full-vector op is disp8 = 1, and a displacement
# that is not a multiple of N needs disp32. clang's encoding is the reference.
#
# Only tuple types whose memory operand has the register's width are covered:
# forms with a narrower memory operand (hv, t1s8/t1s16, t2/t4/t8, hvm/qvm/ovm,
# m128 — conversions, broadcasts, vpmovzx) are not matched by the operand
# classifier yet and cannot be assembled at all.

.text
.globl main
main:
    # fv (Full Vector): N = VL, or the element size when broadcasting
    vmovaps 64(%rax), %zmm0                  # N=64 -> disp8 1
    vmovaps -64(%rax), %zmm0                 # disp8 -1
    vmovaps 1(%rax), %zmm0                   # not a multiple -> disp32
    vmovaps 128(%rax,%rbx,2), %zmm0          # SIB, disp8 2
    vmovaps 64(%rax), %zmm0 {%k1} {z}        # masking does not change N
    vmovaps %zmm0, 64(%rax)                  # store form
    vmovaps 32(%rax), %ymm1 {%k1}            # VL=256 -> N=32
    vmovaps 16(%rax), %xmm1 {%k1}            # VL=128 -> N=16
    vaddpd 8(%rax){1to8}, %zmm1, %zmm2       # broadcast, W1 -> N=8
    vaddps 4(%rax){1to16}, %zmm1, %zmm2      # broadcast, W0 -> N=4
    # fvm (Full Vector Mem)
    vpshufb 64(%rax), %zmm1, %zmm2           # N=64
    # t1s (Tuple1 Scalar): N = element size
    vaddss 4(%rax), %xmm1, %xmm2 {%k1}       # N=4
    vaddsd 8(%rax), %xmm1, %xmm2 {%k1}       # N=8
    # t1f32 / t1f64 (Tuple1 Fixed)
    vcvtss2usi 4(%rax), %eax                 # N=4
    vcvtsd2usi 8(%rax), %eax                 # N=8
    # dup (MOVDDUP): N = 8 / 32 / 64 by VL
    vmovddup 64(%rax), %zmm0                 # N=64
    ret
