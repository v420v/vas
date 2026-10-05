# #48: Mach-O uses implicit addends, so `sym + const` references to global or
# external symbols must carry the constant inline in the section data, for
# pc-relative instruction operands (SIGNED) and absolute data (UNSIGNED) alike.
# _main returns the sum of (read back - expected) over all loads: 0 when correct.

.text
.globl _main
_main:
    xorl %eax, %eax

    movl garr+4(%rip), %ecx      # pc-relative load with addend: garr[1] = 2
    subl $2, %ecx
    addl %ecx, %eax

    leaq garr+12(%rip), %rdx     # lea with addend: &garr[3]
    movl (%rdx), %ecx            # 4
    subl $4, %ecx
    addl %ecx, %eax

    movq tab(%rip), %rdx         # .quad garr + 8: &garr[2]
    movl (%rdx), %ecx            # 3
    subl $3, %ecx
    addl %ecx, %eax
    ret

.data
.globl garr
garr:
    .long 1, 2, 3, 4
tab:
    .quad garr + 8
