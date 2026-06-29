# Regression test for .weak / .global / .hidden applied to a symbol that is
# only referenced (never defined) in this translation unit.
#
# Before the fix, change_symbol_binding / change_symbol_visibility returned
# early (or { return }) when the symbol was absent from user_defined_symbols,
# silently discarding the directive.  The linker then saw a plain STB_GLOBAL
# undefined instead of STB_WEAK, changing link-time semantics.

.text
.weak   optional_fn
.globl  main_fn
.hidden hidden_ref

main_fn:
    call optional_fn    # STB_WEAK  undefined reference
    call hidden_ref     # STB_GLOBAL hidden visibility undefined reference
    ret
