# Encoding fixes exercised by real gcc output (validated vs GNU as):
#  - %bp/%sp/%si/%di are 16-bit registers (movw), not 8-bit
#  - a bare numeric operand is an absolute-memory reference (`movq 16,%rax`)
#  - pushq selects imm8/imm32 (never the 2-byte imm16 `pushw` form)
#  - movabs keeps the full 64-bit immediate (INT64_MIN / high-bit values)
#  - 64-bit data constants are not saturated at i64-max
.text
.globl probe
probe:
    movw    %bp, 18(%r10,%r11)
    movw    %bp, (%r10)
    movw    %sp, %bp
    movw    %si, %di
    movq    16, %rax
    movl    16, %eax
    movq    %rax, 32
    pushq   $1
    pushq   $0x1234
    pushq   $2048
    pushq   $-14
    push    $0x40000000
    movabsq $-9223372036854775808, %rax
    movabsq $0x8000000000000000, %rcx
    movabsq $0xFFFFFFFFFFFFFFFF, %rdx
    ret

.section .data, "aw"
    .quad 0x8000000000000000
    .quad 0xFFFFFFFFFFFFFFFF
    .octa 0xfedcba9876543210
