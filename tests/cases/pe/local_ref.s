# #86: references to `.L` locals in another section must be section-relative
# (section symbol + inline addend) for REL32, ADDR64 and ADDR32 alike; the
# labels themselves stay out of the symbol table.
.text
.globl main
main:
    leaq .Lstr(%rip), %rcx       # REL32  -> .data + 0
    leaq .Lstr2(%rip), %rdx      # REL32  -> .data + 6
    movq .Ltab(%rip), %rax       # REL32  -> .rdata + 0
    ret

.data
.Lstr:
    .asciz "hello"
.Lstr2:
    .asciz "world"

.section .rodata
.Ltab:
    .quad .Lstr                  # ADDR64 -> .data + 0
    .quad .Lstr2 + 2             # ADDR64 -> .data + 8
    .long .Lstr2                 # ADDR32 -> .data + 6
