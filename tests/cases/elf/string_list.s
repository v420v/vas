# .string / .asciz accept a comma-separated list; each literal is NUL-terminated.
.data
.string "foo", "bar"
.asciz "a", "", "bc"
.string "x"
