.global _start
.text
_start:
    fadd %st(1), %st     # r-: ST(0) <- ST(0) + ST(1)
    fadd %st, %st(1)     # -r: ST(1) <- ST(1) + ST(0)
    fmul %st(2), %st     # r-
    fdiv %st, %st(2)     # -r
    fldt (%rsp)          # 80-bit load (mem80 → wildcard)
    fstpt (%rsp)
    ret
