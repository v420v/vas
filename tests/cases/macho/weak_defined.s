# #89: references to a defined weak symbol must be external relocations
# against the symbol (the linker may pick another definition), not folded
# constants or section-relative relocations like local symbols get.
# _main returns 0 (every value comes from this object's own weak definitions).

.text
.globl _main
_main:
    xorl %eax, %eax
    call wfn                     # X86_64_RELOC_BRANCH wfn (external), not folded
    subl $5, %eax
    movl wdata(%rip), %ecx       # X86_64_RELOC_SIGNED wdata (external)
    subl $7, %ecx
    addl %ecx, %eax
    movq tab(%rip), %rdx         # .quad wdata → X86_64_RELOC_UNSIGNED wdata (external)
    movl (%rdx), %ecx
    subl $7, %ecx
    addl %ecx, %eax
    ret

.weak wfn
wfn:
    movl $5, %eax
    ret

.data
.weak wdata
wdata:
    .long 7
tab:
    .quad wdata
