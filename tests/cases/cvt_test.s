.global _start
.text
_start:
    cvtsi2ssq %rax, %xmm0
    cvtsi2sdq %rax, %xmm0
    cvtsi2ssl %eax, %xmm0
    cvtsi2sdl %eax, %xmm0
    cvttss2sil %xmm0, %eax
    cvttss2siq %xmm0, %rax
    cvttsd2sil %xmm0, %eax
    cvttsd2siq %xmm0, %rax
    ret
