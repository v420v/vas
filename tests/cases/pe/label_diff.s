# #90: cross-section label differences (PIC jump-table style).
# The table lives in .rodata (.rdata) and its entries point into .text.
# COFF expresses `A - B` as REL32 against A with the inline addend
# `k + 4 + site - B` (B and the site share a section). `.L` targets must be
# emitted as symbols since vas has no COFF section symbols yet.
# (.quad A - B is omitted: COFF has no 64-bit PC-relative relocation.)

.text
.globl main
main:
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
    ret

.L0:
    movl $1, %eax
    ret
.globl gtarget
gtarget:
    movl $3, %eax
    ret

.section .rodata
.LJT:
    .long .L0 - .LJT
    .long gtarget - .LJT + 4
