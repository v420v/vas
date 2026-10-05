# #89: a reference to a weak symbol must stay a relocation against the symbol
# itself. The linker may replace a weak definition with a strong one from
# another object, and an undefined weak resolves to 0, so weak references can
# neither be folded to a constant (same section) nor rewritten as
# section-relative (other sections) the way local symbols are.

.text
.globl main
main:
    call wfn                     # same section: R_X86_64_PLT32 wfn-4, not folded
    leaq wfn(%rip), %rax         # R_X86_64_PC32 wfn-4
    movq wdata(%rip), %rax       # R_X86_64_PC32 wdata-4, not .data+N
    movl $wdata, %eax            # R_X86_64_32 wdata
    movq undefw(%rip), %rax      # undefined weak: R_X86_64_PC32 undefw-4, not *ABS*
    ret

.weak wfn
wfn:
    ret

.data
.weak wdata
wdata:
    .quad 1
.weak undefw
    .quad wfn                    # R_X86_64_64 wfn
    .long wdata                  # R_X86_64_32 wdata
    .quad undefw                 # R_X86_64_64 undefw
    .long wfn - .                # R_X86_64_PC32 wfn (label difference with a weak endpoint)
