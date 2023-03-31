# ../vas nop.s && ld -o nop nop.o && ./nop
# echo $?
# > 0

.global _start

_start:
    nopq
    nopq
    nopq
    movq $60, %rax
    movq $0, %rdi
    syscall

