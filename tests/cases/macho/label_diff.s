# #90: cross-section label differences (PIC jump-table style).
# The table lives in .rodata (__TEXT,__const) and its entries point into .text.
# Mach-O needs a SUBTRACTOR + UNSIGNED pair per entry; the `.L` endpoints must
# be emitted as symbols because the subtrahend has to be an external reference.
# _main returns the sum of (stored - actual) over all entries: 0 when correct.

.text
.globl _main
_main:
    leaq .LJT(%rip), %rcx
    xorl %eax, %eax

    movslq (%rcx), %rdx          # .long .L0 - .LJT
    leaq .L0(%rip), %rsi
    subq %rcx, %rsi
    subq %rsi, %rdx
    addq %rdx, %rax

    movslq 4(%rcx), %rdx         # .long gtarget - .LJT + 4
    leaq gtarget(%rip), %rsi
    subq %rcx, %rsi
    addq $4, %rsi
    subq %rsi, %rdx
    addq %rdx, %rax

    movq 8(%rcx), %rdx           # .quad .L1 - .LJT
    leaq .L1(%rip), %rsi
    subq %rcx, %rsi
    subq %rsi, %rdx
    addq %rdx, %rax
    ret

.L0:
    movl $1, %eax
    ret
.L1:
    movl $2, %eax
    ret
.globl gtarget
gtarget:
    movl $3, %eax
    ret

.section .rodata
.LJT:
    .long .L0 - .LJT
    .long gtarget - .LJT + 4
    .quad .L1 - .LJT
