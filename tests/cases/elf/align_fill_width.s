# .p2alignw/.p2alignl/.balignw/.balignl repeat a 2-/4-byte little-endian fill;
# fill values above INT_MAX and negative fills are taken as bit patterns.
.data
.byte 1, 2, 3, 4
.p2alignl 4, 0x12345678
.byte 1, 2
.p2alignw 3, 0xabcd
.byte 1, 2, 3, 4
.balignl 16, 0xdeadbeef
.byte 1
.p2align 3, -5
.byte 1, 2
.balignw 8, -2
.byte 1, 2, 3, 4
.p2alignl 3, 0x90909090
.byte 1
.p2align 3
.text
	ret
	ret
.p2alignw 3, 0x9090
	ret
.p2align 3, 0x90
	ret
