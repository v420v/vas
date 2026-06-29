# movabsq $symbol, %reg — 10-byte encoding with R_X86_64_64 relocation.
# Validates the fix for the bug where the symbol case emitted only 4 bytes
# with R_X86_64_32S instead of 8 bytes with R_X86_64_64.
.text
.globl probe
probe:
    movabsq $target, %rax
    movabsq $target, %rcx
    movabsq $target, %r8
    ret

.globl target
target:
    .quad 0
