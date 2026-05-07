.global _start
.text
_start:
    cpuid
    rdtsc
    rdtscp
    rdrand %eax
    rdseed %rax
    cli
    sti
    sahf
    lahf
    pause
    lfence
    mfence
    sfence
    int3
    int $0x80
    ud2
    clflush (%rsp)
    prefetcht0 (%rsp)
    prefetchnta (%rsp)
    btl %eax, %ebx
    btsq %rax, %rbx
    btrl $5, %eax
    movbeq (%rsp), %rax
    crc32q %rax, %rbx
    ret
