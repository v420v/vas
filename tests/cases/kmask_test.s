.global _start
.text
_start:
    kmovw %k1, %k2
    kmovb %k1, %k2
    kmovd %eax, %k1
    kmovq %rax, %k1
    kmovd %k1, %eax
    kandw %k1, %k2, %k3
    korw %k1, %k2, %k3
    kxorw %k1, %k2, %k3
    knotw %k1, %k2
    kortestw %k1, %k2
    ktestw %k1, %k2
    ret
