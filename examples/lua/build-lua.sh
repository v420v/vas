#!/usr/bin/env bash
#
# build-lua.sh — build the Lua interpreter with vas as the assembler.
#
# Pipeline, per translation unit:
#
#   src/*.c ──gcc -S──▶ AT&T .s ──vas──▶ .o ──┐
#                                             ├─gcc(link)──▶ lua
#   (33 core/lib TUs, all of src/ except luac.c)
#
# i.e. gcc is the C front-end, vas replaces GNU `as`, gcc drives the link.
# Lua is a second "real program" showcase alongside SQLite, with a different
# shape: not one amalgamation but ~30k lines of pure C across 33 translation
# units, and with gcc its bytecode VM (lvm.c) compiles to a computed-goto
# dispatch table — so it exercises indirect jumps / jump tables that the
# straight-line SQLite code does not.
#
# Needs `v`/`gcc`/`ld` + `vas` already built (run `v -o vas .` at the repo root).
# Designed to run inside the vasdev container:
#   docker exec -w /work/examples/lua vasdev bash build-lua.sh
#
set -euo pipefail

# Run from this script's own directory so the relative paths below resolve no
# matter where you invoke it from (repo root, examples/lua/, anywhere).
cd "$(dirname "${BASH_SOURCE[0]}")"

VAS=${VAS:-../../vas}                 # the vas binary to test (repo root)
CC=${CC:-gcc}
OPT=${OPT:-O2}                        # gcc -O level for the .s (O0/O2/Os all work)
LUA_VER=${LUA_VER:-5.4.7}             # lua.org/ftp version
LUA_URL=${LUA_URL:-https://www.lua.org/ftp/lua-${LUA_VER}.tar.gz}
WORK=${WORK:-.lua-build}
# Dependency-light POSIX build: no readline, no dlopen — just libm.
DEFS="-DLUA_USE_POSIX"

say() { printf '\n==> %s\n' "$*"; }

VAS=$(cd "$(dirname "$VAS")" && pwd)/$(basename "$VAS")
[[ -x "$VAS" ]] || { echo "error: vas not found/executable at $VAS (build it: v -o vas .)"; exit 1; }
mkdir -p "$WORK"; cd "$WORK"

say "fetch Lua $LUA_VER"
src="lua-${LUA_VER}"
[[ -d "$src" ]] || { curl -fsSL -O "$LUA_URL"; tar xzf "${src}.tar.gz"; }
cd "$src/src"

# The `lua` interpreter is every src/*.c except luac.c (the standalone compiler
# main); lua.c carries the interpreter's own main().
mapfile -t CFILES < <(ls *.c | grep -vx 'luac.c')

say "gcc -S: C -> AT&T assembly  (${#CFILES[@]} translation units)"
lines=0
for c in "${CFILES[@]}"; do
	$CC -S -$OPT $DEFS -I. "$c" -o "${c%.c}.s"
	lines=$(( lines + $(wc -l < "${c%.c}.s") ))
done
printf '   %s .s files, %s lines of assembly total\n' "${#CFILES[@]}" "$lines"

say "vas: assemble each .s (vas replaces GNU as here)"
objs=()
for c in "${CFILES[@]}"; do
	"$VAS" "${c%.c}.s" -o "${c%.c}.o"
	objs+=("${c%.c}.o")
done
printf '   assembled %s objects\n' "${#objs[@]}"

say "link the vas-assembled objects"
$CC "${objs[@]}" -o lua_vas -lm
printf '   ./lua_vas  (%s bytes)\n' "$(wc -c <lua_vas)"

say "smoke test: run real Lua"
./lua_vas - <<'LUA'
print('--- vas-built Lua ---')
local function fib(n) return n < 2 and n or fib(n-1) + fib(n-2) end
local f = {}; for i = 1, 12 do f[i] = fib(i) end
print('fib 1..12 : ' .. table.concat(f, ' '))
local function primes(limit)
  return coroutine.wrap(function()
    local found = {}
    for n = 2, limit do
      local isp = true
      for _, p in ipairs(found) do if n % p == 0 then isp = false; break end end
      if isp then found[#found+1] = n; coroutine.yield(n) end
    end
  end)
end
local ps = {}; for p in primes(40) do ps[#ps+1] = p end
print('primes <40 : ' .. table.concat(ps, ' '))
local function adder(k) return function(x) return x + k end end
print('closure    : add10(5) = ' .. adder(10)(5))
print(string.format('math       : pi~%.6f  sqrt2~%.6f  sin1~%.6f',
      4 * math.atan(1.0), math.sqrt(2), math.sin(1.0)))
local V = {}; V.__index = V
V.__add = function(a, b) return setmetatable({ a[1] + b[1], a[2] + b[2] }, V) end
V.__tostring = function(v) return ('(%g, %g)'):format(v[1], v[2]) end
local function vec(x, y) return setmetatable({ x, y }, V) end
print('metatable  : ' .. tostring(vec(1, 2) + vec(3, 4)))
print(_VERSION .. ' — assembled by vas')
LUA

say "done — vas assembled and ran Lua."
