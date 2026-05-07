.global _start
.text
_start:
    movzbl %al, %eax
    movsbl %al, %eax
    movzwl %ax, %eax
    movswl %ax, %eax
    movzbq %al, %rax
    movsbq %al, %rax
    movslq %eax, %rax
    movabsq $0x1122334455667788, %rax
    ret
