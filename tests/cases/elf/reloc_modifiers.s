# #91: `sym@MODIFIER` in immediates and data directives must select the
# GOT/TLS/PLT-relative relocation for the field width instead of the plain
# absolute one (R_X86_64_32/32S/64). Expected types are clang's / GNU as's.

.text
.globl main
main:
    movq $x@TPOFF, %rax          # R_X86_64_TPOFF32   (imm32, REX.W)
    addq $st@DTPOFF, %rax        # R_X86_64_DTPOFF32
    movabsq $sym@GOT, %rax       # R_X86_64_GOT64     (large code model)
    movabsq $x@DTPOFF, %rax      # R_X86_64_DTPOFF64
    movabsq $x@TPOFF, %rax       # R_X86_64_TPOFF64
    movabsq $sym@GOTOFF, %rax    # R_X86_64_GOTOFF64
    movabsq $sym@PLTOFF, %rax    # R_X86_64_PLTOFF64
    pushq $sym@GOT               # R_X86_64_GOT32
    movl $sym@GOT, %eax          # R_X86_64_GOT32
    ret

.data
    .quad sym@GOTOFF             # R_X86_64_GOTOFF64
    .quad sym@GOT                # R_X86_64_GOT64
    .long sym@GOT                # R_X86_64_GOT32
    .long x@TPOFF                # R_X86_64_TPOFF32
    .quad x@TPOFF                # R_X86_64_TPOFF64
    .long x@DTPOFF               # R_X86_64_DTPOFF32
    .quad x@DTPOFF               # R_X86_64_DTPOFF64
    .long sym@PLT                # R_X86_64_PLT32   (addend 0: no PC adjustment for data)
    .long sym@GOTPCREL           # R_X86_64_GOTPCREL
    .long sym@GOTTPOFF           # R_X86_64_GOTTPOFF
    .long sym@TLSGD              # R_X86_64_TLSGD
    .long sym@TLSLD              # R_X86_64_TLSLD
    .quad sym@PLTOFF             # R_X86_64_PLTOFF64
    .quad sym@GOT + 8            # R_X86_64_GOT64 sym+8
