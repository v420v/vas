# Contributing to vas

Thank you for your interest in contributing! This guide covers everything you need to build, test, and submit patches.

## Prerequisites

- [V compiler](https://vlang.io) — `v` must be on your `PATH`
- `gcc` and `ld` — needed by the test suite and the examples
- Alternatively, use the [Docker setup](README.md#docker-setup) which ships all of the above

## Build

```sh
v . -o vas
# or
make build
```

## Run the tests

```sh
v test tests/
# or
make test
```

The runner rebuilds `vas`, assembles every case in `tests/cases/{elf,macho,pe}/`, and asserts that the output bytes match the recorded MD5 checksums.

## Add a test case

Each test case is a pair of files: an assembly source (`<name>.s`) and its expected MD5 (`<name>.expected.md5`).

```sh
# ELF example
$EDITOR tests/cases/elf/my_feature.s
./vas -f elf tests/cases/elf/my_feature.s
md5sum tests/cases/elf/my_feature.o | awk '{print $1}' > tests/cases/elf/my_feature.expected.md5
rm tests/cases/elf/my_feature.o
v test tests/
```

Replace `elf` with `macho` or `pe` for other output formats. On macOS use `md5 -q` instead of `md5sum … | awk`.

## Modify the instruction table

The assembler's instruction set is data-driven. Rows are generated from
`third_party/insns.dat` (bundled from [NASM](https://www.nasm.us/)) and committed to
`encoder/insns_table.gen.v`.

After editing `third_party/insns.dat` or the parser in `tools/gen_insns.v`, regenerate
the table and commit the result:

```sh
v run tools/gen_insns.v
git add encoder/insns_table.gen.v
```

See [LICENSE-NASM](LICENSE-NASM) for the BSD-2-clause notice covering `insns.dat` and
any code derived from it.

## CI checklist

Every pull request must pass all three CI workflows:

| Workflow | Badge |
|----------|-------|
| ELF CI   | [![ELF CI](https://github.com/v420v/vas/actions/workflows/ci-elf.yml/badge.svg)](https://github.com/v420v/vas/actions/workflows/ci-elf.yml) |
| Mach-O CI | [![Mach-O CI](https://github.com/v420v/vas/actions/workflows/ci-macho.yml/badge.svg)](https://github.com/v420v/vas/actions/workflows/ci-macho.yml) |
| PE CI    | [![PE CI](https://github.com/v420v/vas/actions/workflows/ci-pe.yml/badge.svg)](https://github.com/v420v/vas/actions/workflows/ci-pe.yml) |

Run `v test tests/` locally before pushing to catch regressions early.

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).
