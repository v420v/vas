# Symbol assignment
.set NUM, 42
.equ NUM2, 100
.set HALF, NUM / 2

.text
.globl probe
probe:
    movq $NUM, %rax     # via .set
    movq $NUM2, %rcx    # via .equ
    movq $HALF, %rdx    # via .set with eval
    ret

.section .data, "aw"
val_short:  .short 0xCAFE
val_value:  .value 0x1234, 0xABCD     # list
val_int:    .int   0xDEADBEEF
val_octa:   .octa  0xfedcba9876543210
val_ascii:  .ascii "no nul"
val_skip:   .skip  16
val_space:  .space 8, 0xFF
val_fill:   .fill  4, 1, 0xAA
val_float:  .float 1.5
val_dbl:    .double 3.14
val_single: .single 2.71
val_uleb:   .uleb128 130
val_sleb:   .sleb128 -64
val_byte_list: .byte 1, 2, 3, 4

# Common symbols
.comm   gcom, 32
.lcomm  lcom, 16

# Section stack
.pushsection .rodata, "a"
roval: .long 0xDEADBEEF
.popsection

# .previous toggling
.section .data, "aw"
new_in_data: .quad 1
.previous
back_to_rodata: .long 2

# Mode no-ops
.intel_syntax noprefix
.att_syntax prefix
.code64
.loc 0 1 0

# Weird flags
.section .my_special, "axMS", @progbits
.byte 0xFE
