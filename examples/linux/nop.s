# ./vas examples/linux/nop.s && ld -o nop.out examples/linux/nop.o && ./nop.out
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

