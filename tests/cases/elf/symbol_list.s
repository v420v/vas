# .globl/.local/.weak/.hidden/.internal/.protected take comma-separated lists.
.text
.globl a, b
.weak w1,w2
.hidden h1, h2
.protected p1
.internal i1, i2
.local l1, l2
a: ret
b: ret
w1: ret
w2: ret
h1: ret
h2: ret
p1: ret
i1: ret
i2: ret
l1: ret
l2: ret
