# #91: GOT/TLS-relative data relocations are ELF-only; Mach-O (and PE) output
# must reject them instead of emitting a plain absolute relocation.
.data
    .long x@TPOFF
