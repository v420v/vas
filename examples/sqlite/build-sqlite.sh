#!/usr/bin/env bash
#
# build-sqlite.sh — build the SQLite CLI with vas as the assembler.
#
# Pipeline, per translation unit:
#
#   sqlite3.c / shell.c ──gcc -S──▶ AT&T .s ──vas──▶ .o ──gcc(link)──▶ sqlite3
#
# i.e. gcc is the C front-end, vas replaces GNU `as`, gcc drives the link.
# SQLite is the canonical "real program" showcase (also one of chibicc's
# targets): a ~270k-line single-file C amalgamation, pure C, double (not x87
# long double) floats — it exercises a huge slice of the instruction set.
#
# Needs `v`/`gcc`/`ld` + `vas` already built (run `v -o vas .` at the repo root).
# Designed to run inside the vasdev container:
#   docker exec -w /work/examples/sqlite vasdev bash build-sqlite.sh
#
set -euo pipefail

# Run from this script's own directory so the relative paths below resolve no
# matter where you invoke it from (repo root, examples/sqlite/, anywhere).
cd "$(dirname "${BASH_SOURCE[0]}")"

VAS=${VAS:-../../vas}                 # the vas binary to test (repo root)
CC=${CC:-gcc}
OPT=${OPT:-O2}                        # gcc -O level for the .s (O0/O2/Os all work)
SQLITE_VER=${SQLITE_VER:-3530200}     # amalgamation version (sqlite.org/2026/...)
SQLITE_URL=${SQLITE_URL:-https://www.sqlite.org/2026/sqlite-autoconf-${SQLITE_VER}.tar.gz}
WORK=${WORK:-.sqlite-build}
# Keep it dependency-light: no threads, no dlopen; built-in math funcs + -lm.
DEFS="-DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_ENABLE_MATH_FUNCTIONS"

say() { printf '\n==> %s\n' "$*"; }

VAS=$(cd "$(dirname "$VAS")" && pwd)/$(basename "$VAS")
[[ -x "$VAS" ]] || { echo "error: vas not found/executable at $VAS (build it: v -o vas .)"; exit 1; }
mkdir -p "$WORK"; cd "$WORK"

say "fetch SQLite $SQLITE_VER"
src="sqlite-autoconf-${SQLITE_VER}"
[[ -d "$src" ]] || { curl -fsSL -O "$SQLITE_URL"; tar xzf "${src}.tar.gz"; }
cd "$src"

say "gcc -S: C -> AT&T assembly"
$CC -S -$OPT $DEFS sqlite3.c -o sqlite3.s
$CC -S -$OPT $DEFS shell.c   -o shell.s
printf '   sqlite3.s %s lines, shell.s %s lines\n' "$(wc -l <sqlite3.s)" "$(wc -l <shell.s)"

say "vas: assemble each .s (vas replaces GNU as here)"
"$VAS" sqlite3.s -o sqlite3.o
"$VAS" shell.s   -o shell.o
printf '   sqlite3.o %s bytes, shell.o %s bytes\n' "$(wc -c <sqlite3.o)" "$(wc -c <shell.o)"

say "link the vas-assembled objects"
$CC sqlite3.o shell.o -o sqlite3_vas -lm
printf '   ./sqlite3_vas  (%s bytes)\n' "$(wc -c <sqlite3_vas)"

say "smoke test: run real SQL"
./sqlite3_vas :memory: <<'SQL'
.print --- vas-built SQLite ---
create table t(id integer primary key, name text, score real);
insert into t(name,score) values ('alice',9.5),('bob',3.2),('carol',7.8);
select name, score from t where score > 5 order by score desc;
select count(*) n, round(avg(score),3) avg, max(score) hi from t;
with recursive c(n) as (select 1 union all select n+1 from c where n<20) select sum(n*n) from c;
select 'SQLite ' || sqlite_version() || ' built by vas';
SQL

say "done — vas assembled and ran SQLite."
