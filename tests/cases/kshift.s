.global _start
.text
_start:
    kshiftlb $4, %k1, %k2
    kshiftlw $5, %k1, %k2
    kshiftld $6, %k1, %k2
    kshiftlq $7, %k1, %k2
    kshiftrb $1, %k1, %k2
    kshiftrw $2, %k1, %k2
    kshiftrd $3, %k1, %k2
    kshiftrq $4, %k1, %k2
    ret
