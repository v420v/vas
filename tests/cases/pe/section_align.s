# #75: a section's alignment must follow the largest .p2align/.balign it
# contains (IMAGE_SCN_ALIGN_* in the COFF section characteristics, like
# sh_addralign in ELF) instead of fixed defaults; otherwise a `movaps`
# constant pool or an aligned jump table lands on an unaligned address after
# linking. Expected: .text 32, .data 64, .rdata 16, .bss 32.

.text
.p2align 5
.globl main
main:
    movaps c(%rip), %xmm0        # c must stay on a 16-byte boundary
    xorl %eax, %eax
    ret

.data
.p2align 6
dvar:
    .quad 1

.section .rodata
.p2align 4
c:
    .long 1, 2, 3, 4

.bss
.balign 32
buf:
    .zero 8
