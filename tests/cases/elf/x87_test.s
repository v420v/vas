.global _start
.text
_start:
    fadd %st(1)
    fmul %st(2)
    fsubp %st(3)
    fadds (%rsp)
    faddl (%rsp)
    fchs
    fabs
    fsqrt
    fnop
    fwait
    ret
