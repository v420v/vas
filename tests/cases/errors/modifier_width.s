# #91: x86-64 has no 32-bit GOTOFF relocation; `.long sym@GOTOFF` must be
# rejected with a clear error instead of degrading to R_X86_64_32.
.data
    .long sym@GOTOFF
