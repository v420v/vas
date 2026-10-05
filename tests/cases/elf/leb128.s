# #54 / #72: `.uleb128` / `.sleb128` must encode same-section label
# differences (the LSDA / DWARF pattern) instead of 0, and must not truncate
# constants to 32 bits. A symbolic value is written as a fixed 5-byte padded
# LEB128 once the layout is known; constants keep the minimal encoding.

.text
.globl main
main:
.Lfunc_begin:
    nop
.Ltmp0:
    nop
    nop
.Ltmp1:
    ret
.Lfunc_end:

.section .gcc_except_table,"a",@progbits
.p2align 2
GCC_except_table0:
    .byte 255                        # @LPStart omitted
    .byte 3                          # @TType encoding
    .uleb128 .Lttbase0-.Lttbaseref0  # forward difference within this section
.Lttbaseref0:
    .byte 1                          # call-site encoding (uleb128)
    .uleb128 .Lcst_end0-.Lcst_begin0 # call-site table length (forward)
.Lcst_begin0:
    .uleb128 .Ltmp0-.Lfunc_begin     # endpoints in .text, directive here: 1
    .uleb128 .Ltmp1-.Ltmp0           # 2
    .uleb128 .Lfunc_end-.Lfunc_begin # 4
    .sleb128 .Lfunc_begin-.Lfunc_end # -4
    .uleb128 0x100000000             # 33-bit constant, minimal (5 bytes)
    .sleb128 0x80000000              # positive 32-bit constant stays positive
    .sleb128 -129
    .uleb128 127
    .uleb128 128
.Lcst_end0:
    .long 0
.Lttbase0:
