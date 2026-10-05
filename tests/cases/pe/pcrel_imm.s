# #80: a RIP-relative operand followed by an immediate (`movl $1, g(%rip)`)
# needs a displacement smaller by the immediate's size, because the CPU adds
# the whole instruction length to RIP. COFF REL32 is relative to the end of
# the 4-byte field, so the immediate's size is subtracted from the inline
# addend (clang does the same: `fc ff ff ff` for a trailing imm32).

.text
.globl main
main:
    xorl %eax, %eax

    movl $7, gvar(%rip)              # imm32 after the displacement: inline -4
    movl gvar(%rip), %ecx
    subl $7, %ecx
    addl %ecx, %eax

    movw $9, gvar(%rip)              # imm16: inline -2
    movzwl gvar(%rip), %ecx
    subl $9, %ecx
    addl %ecx, %eax

    movb $5, gvar(%rip)              # imm8: inline -1
    movzbl gvar(%rip), %ecx
    subl $5, %ecx
    addl %ecx, %eax

    addl $3, lvar(%rip)              # local target, sign-extended imm8
    movl lvar(%rip), %ecx
    subl $13, %ecx
    addl %ecx, %eax

    movl $0x11223344, lvar+4(%rip)   # local target with addend and imm32
    movl lvar+4(%rip), %ecx
    subl $0x11223344, %ecx
    addl %ecx, %eax
    ret

.data
pad:
    .long 0, 0, 0, 0
.globl gvar
gvar:
    .long 0
lvar:
    .long 10
    .long 0
