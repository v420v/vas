# Test: operator precedence and left-associativity in expressions
.text
.globl _start
_start:
    # 10 - 3 + 2 = 9  (left-associative, not 10-(3+2)=5)
    movq $10-3+2, %rax

    # 100 / 10 / 2 = 5  (left-associative, not 100/(10/2)=40)
    movq $100/10/2, %rbx

    # 2 * 3 + 1 = 7  (mul before add, not 2*(3+1)=8)
    movq $2*3+1, %rcx

    # 1 + 2 * 3 = 7  (mul before add)
    movq $1+2*3, %rdx

.section .data, "aw"
# Same expressions in data directives
val1: .long 10-3+2      # = 9
val2: .long 100/10/2    # = 5
val3: .long 2*3+1       # = 7
val4: .long 1+2*3       # = 7
