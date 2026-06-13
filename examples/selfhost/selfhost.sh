#!/usr/bin/env bash
#
# selfhost.sh — bootstrap vas with vas itself.
#
# The loop, one generation at a time:
#
#   V source ──v -o .c──▶  C  ──gcc -S──▶  AT&T asm  ──vas──▶  .o  ──gcc(link)──▶  vas
#        ▲                                                                          │
#        └──────────────────────  use it to assemble the next gen  ◀───────────────┘
#
# vas assembles the very assembly that V+gcc emit for vas's own source, we link
# that object into a new vas, and then that new vas assembles vas again — on and
# on until two generations produce a byte-identical object. That fixpoint is the
# proof of self-hosting: the assembler reproduces itself exactly.
#
# Note: V and gcc (not vas) produce the .s, and they're deterministic, so the .s
# is identical every generation — it's generated once. What actually iterates is
# the assemble+link stage, which is the part vas is responsible for.
#
# Needs `v`, `gcc`, and `ld` on PATH, i.e. run it inside the vasdev container:
#   docker exec -w /work vasdev bash examples/selfhost/selfhost.sh
#
set -euo pipefail

# Self-hosting transpiles the whole vas project (`v ... .`), so the build must
# run from the repo root (two levels up from this script). Generated artifacts
# go in .selfhost/ next to this script, ignored by examples/selfhost/.gitignore.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$here/../.."

# ---- config (override via env) ---------------------------------------------
V=${V:-v}                       # V compiler
CC=${CC:-gcc-12}                # C compiler / linker driver (pinned: see README)
MAXGEN=${MAXGEN:-5}             # safety cap on generations
BUILDDIR=${BUILDDIR:-"$here/.selfhost"} # scratch dir, kept next to this script
SEED=${SEED:-./vas}             # stage-0 vas; built with V if missing
OPT=${OPT:-}                    # extra gcc -S optimization flag, e.g. OPT=-O2
SANITY=${SANITY:-examples/linux/hello.s}  # program each gen must assemble+run
KEEP=${KEEP:-0}                 # KEEP=1 leaves $BUILDDIR around afterward

# -gc none => generated C uses plain malloc, so there's no libgc to link and
# `gcc -S` needs nothing but these three flags.
VGEN_FLAGS=(-gc none)
CFLAGS=(-std=c99 -D_DEFAULT_SOURCE -fwrapv $OPT)
LDLIBS=(-lpthread -lm -ldl)

# ---- helpers ----------------------------------------------------------------
bold=$(tput bold 2>/dev/null || true); dim=$(tput dim 2>/dev/null || true)
red=$(tput setaf 1 2>/dev/null || true); grn=$(tput setaf 2 2>/dev/null || true)
ylw=$(tput setaf 3 2>/dev/null || true); rst=$(tput sgr0 2>/dev/null || true)
say()  { printf '%s\n' "${bold}==>${rst} $*"; }
step() { printf '%s\n' "    ${dim}·${rst} $*"; }
die()  { printf '%s\n' "${red}error:${rst} $*" >&2; exit 1; }

for t in "$V" "$CC" ld md5sum cmp; do
  command -v "$t" >/dev/null 2>&1 || die "missing required tool: $t"
done

mkdir -p "$BUILDDIR"
GEN_C="$BUILDDIR/vas_gen.c"
GEN_S="$BUILDDIR/vas_gen.s"

# ---- stage 0: a seed assembler ---------------------------------------------
if [[ -x "$SEED" ]]; then
  say "stage 0: using existing seed assembler ${bold}$SEED${rst}"
else
  say "stage 0: no seed at $SEED — building one with V"
  "$V" "${VGEN_FLAGS[@]}" -o "$SEED" .
fi

# ---- frontend (run once): V -> C -> assembly --------------------------------
say "frontend: transpiling vas to C, then to assembly"
step "$V ${VGEN_FLAGS[*]} -o vas_gen.c .   (V → C)"
"$V" "${VGEN_FLAGS[@]}" -o "$GEN_C" .
step "$CC -S ${CFLAGS[*]} vas_gen.c        (C → AT&T asm)"
"$CC" -S "${CFLAGS[@]}" "$GEN_C" -o "$GEN_S"
step "asm is $(wc -c <"$GEN_S") bytes — this is what vas will assemble"

# ---- the self-hosting loop --------------------------------------------------
cur=$SEED          # assembler used this generation
prev_o=""          # object produced last generation
fixpoint_gen=0

for ((g = 1; g <= MAXGEN; g++)); do
  obj="$BUILDDIR/gen${g}.o"
  bin="$BUILDDIR/vas${g}"

  say "generation $g: ${bold}$(basename "$cur")${rst} assembles vas, then we link + test it"
  step "$cur vas_gen.s -o gen${g}.o          (vas: asm → object)"
  "$cur" "$GEN_S" -o "$obj"
  step "$CC gen${g}.o -o vas${g}             (link → executable)"
  "$CC" "$obj" -o "$bin" "${LDLIBS[@]}"

  # sanity: the freshly self-built vas must actually work end to end.
  so="$BUILDDIR/sanity${g}.o"; sx="$BUILDDIR/sanity${g}.out"
  "$bin" "$SANITY" -o "$so"
  ld -o "$sx" "$so"
  out=$("$sx" || true)
  step "sanity: ./vas${g} $SANITY → run → ${grn}${out}${rst}"

  md5=$(md5sum "$obj" | cut -d' ' -f1)
  step "object md5 = $md5"

  if [[ -n "$prev_o" ]] && cmp -s "$obj" "$prev_o"; then
    fixpoint_gen=$g
    say "${grn}FIXPOINT${rst} at generation $g: gen${g}.o is byte-identical to gen$((g-1)).o"
    say "vas now reproduces itself exactly — ${bold}self-hosting verified${rst}."
    break
  fi

  prev_o=$obj
  cur=$bin
done

if [[ $fixpoint_gen -eq 0 ]]; then
  say "${ylw}stopped at MAXGEN=$MAXGEN without a fixpoint${rst} (object kept changing)."
  say "inspect $BUILDDIR/gen*.o — successive generations should converge."
fi

# the converged, self-hosted assembler
[[ $fixpoint_gen -gt 0 ]] && cp -f "$BUILDDIR/vas${fixpoint_gen}" "$BUILDDIR/vas-selfhosted"
say "self-hosted binary: ${bold}$BUILDDIR/vas-selfhosted${rst}"

if [[ "$KEEP" != "1" ]]; then
  step "cleaning $BUILDDIR (set KEEP=1 to keep artifacts); self-hosted binary preserved"
  find "$BUILDDIR" -maxdepth 1 -type f ! -name 'vas-selfhosted' -delete
fi
