.section .rodata
# \xNN hex escapes in .ascii / .asciz / .string directives
hex_bytes:  .ascii "\x41\x42\x43"      # A B C
hex_nul:    .asciz "\x48\x65\x6c\x6c\x6f"  # Hello\0
hex_str:    .string "\x77\x6f\x72\x6c\x64"  # world\0
hex_upper:  .ascii "\x4F\x4B"          # OK  (upper-case hex digits)
