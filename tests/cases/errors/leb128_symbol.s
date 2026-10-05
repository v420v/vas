# #54: x86-64 has no LEB128 relocations, so `.uleb128 sym` (or a difference
# across sections) cannot be assembled; it must be a clear error, not 0.
.section .debug_info,"",@progbits
    .uleb128 extern_sym
