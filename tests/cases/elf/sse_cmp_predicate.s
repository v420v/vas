# SSE compare-predicate pseudo-ops: `cmp<pred><size>` expands to
# `cmp<size> $imm8, ...` (gcc emits these for floating relational operators).
# All 8 predicates across scalar/packed single/double, register and memory.
.text
.globl probe
probe:
    cmpeqsd    %xmm1, %xmm0
    cmpltsd    %xmm1, %xmm0
    cmplesd    %xmm1, %xmm0
    cmpunordsd %xmm1, %xmm0
    cmpneqsd   %xmm1, %xmm0
    cmpnltsd   %xmm1, %xmm0
    cmpnlesd   %xmm1, %xmm0
    cmpordsd   %xmm1, %xmm0
    cmpnlesd   (%rax), %xmm0
    cmpnlesd   %xmm9, %xmm8
    cmpnless   %xmm3, %xmm2
    cmpeqps    %xmm5, %xmm4
    cmpltpd    %xmm7, %xmm6
    ret
