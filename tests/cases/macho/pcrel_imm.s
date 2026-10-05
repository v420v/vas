# #80: a RIP-relative operand followed by an immediate (`movl $1, g(%rip)`)
# needs a displacement smaller by the immediate's size, because the CPU adds
# the whole instruction length to RIP. ELF encodes that in the addend; Mach-O
# needs X86_64_RELOC_SIGNED_1/2/4 (addend reduced by 1/2/4) and PE folds it
# into the REL32 inline addend.
# _main returns the sum of (read back - expected) over all stores: 0 when correct.

.text
.globl _main
_main:
    xorl %eax, %eax

    movl $7, gvar(%rip)              # imm32 after the displacement (SIGNED_4)
    movl gvar(%rip), %ecx
    subl $7, %ecx
    addl %ecx, %eax

    movw $9, gvar(%rip)              # imm16 (SIGNED_2)
    movzwl gvar(%rip), %ecx
    subl $9, %ecx
    addl %ecx, %eax

    movb $5, gvar(%rip)              # imm8 (SIGNED_1)
    movzbl gvar(%rip), %ecx
    subl $5, %ecx
    addl %ecx, %eax

    addl $3, lvar(%rip)              # local target, sign-extended imm8 (SIGNED_1)
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
    .long 0, 0, 0, 0                 # keeps a mis-relocated store inside .data
.globl gvar
gvar:
    .long 0
lvar:
    .long 10
    .long 0
