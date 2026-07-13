# movq $symbol, %reg64 and other REX.W instructions with an imm32 that
# references a symbol. The 32-bit immediate is sign-extended to 64 bits, so
# the relocation must be R_X86_64_32S (sign-extended), not R_X86_64_32.
# The 32-bit (non-REX.W) forms keep R_X86_64_32 for contrast.
.text
.globl probe
probe:
    movq $target, %rax      # C7 /0 id, REX.W -> R_X86_64_32S
    movq $target, %r8       # C7 /0 id, REX.W -> R_X86_64_32S
    addq $target, %rbx      # 81 /0 id, REX.W -> R_X86_64_32S
    subq $target, %rcx      # 81 /5 id, REX.W -> R_X86_64_32S
    cmpq $target, %rdx      # 81 /7 id, REX.W -> R_X86_64_32S
    movl $target, %eax      # C7 /0 id, no REX.W -> R_X86_64_32
    addl $target, %ebx      # 81 /0 id, no REX.W -> R_X86_64_32
    ret

.globl target
target:
    .quad 0
