# AT&T sign-extension convert family. gcc emits cbtw at -O0 for char->short
# widening; the rest appear across opt levels. (cwtd/CWD is not yet supported.)
.text
.globl probe
probe:
    cbtw            # CBW   : AL  -> AX     (66 98)
    cwtl            # CWDE  : AX  -> EAX    (98)
    cltq            # CDQE  : EAX -> RAX    (48 98)
    cltd            # CDQ   : EAX -> EDX:EAX (99)
    cqto            # CQO   : RAX -> RDX:RAX (48 99)
    ret
