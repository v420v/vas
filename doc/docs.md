
# VAS Assembler

VAS is a simple assembler that supports x86-64 Linux and uses AT&T assembly syntax. This documentation will explain how to use the VAS assembler to create object files that can be linked with a linker, and how to run the resulting executable.

## Installation

To use VAS, you will need to have the V programming language installed on your system. You can download and install V by following the instructions on the https://github.com/vlang/v.

Once you have V installed, you can download the VAS assembler by cloning the Git repository:

```shell
git clone git@github.com:v420v/vas.git
```

After cloning the repository, navigate to the `vas` directory and run the `make` command to build the `vas` executable:

```shell
cd vas
make
```

The vas executable should now be built and ready to use.

## Usage

To use the VAS assembler, create a new file with the assembly code you wish to assemble. For example, create a file named hello.s with the following code:

```asm
.global _start

.section .text, "ax"
_start:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq $1, %rax
	movq $1, %rdi
	leaq msg(%rip), %rsi
	movq $13, %rdx
	syscall

	movq $60, %rax
	movq $0, %rdi
	syscall

.section .data, "wa"
msg:
	.string "Hello, world!"

```

Once you have your assembly code, you can use the `vas` executable to assemble it into an object file:

```
./vas hello.s
```

This will create an object file named hello.o.

To create an executable from the object file, use a linker. For example, to use the `ld` linker to create an executable named `hello` from `hello.o`, run the following command:

```
ld -o hello hello.o
```

Finally, run the resulting executable:

```
./hello
```

You should see the output:

```
Hello, world!
```

More examples in the examples folder.

## Assembly Syntax

VAS uses AT&T assembly syntax. Some key differences between AT&T syntax and Intel syntax (which is used by some other assemblers) are:

```
    Operand order: in AT&T syntax, the source operand is on the left and the destination operand is on the right.
    Register naming: in AT&T syntax, registers are named with a % character before the name (e.g. %rax, %rbp, %rsp).
    Immediate values: in AT&T syntax, immediate values are prefixed with a $ character (e.g. $1, $13).
```

```

    instr source, destination

```

## Supported instructions

- [X] `movq`
- [x] `movl`
- [x] `movw`
- [x] `movb`
- [x] `movzbw`
- [x] `movzbl`
- [x] `movzbq`
- [x] `movzwq`
- [x] `movzwl`
- [x] `movsbl`
- [x] `movsbw`
- [x] `movsbq`
- [x] `movswl`
- [x] `movswq`
- [x] `movslq`
- [x] `leaq`
- [x] `leal`
- [x] `leaw`  
- [x] `addq`
- [x] `addl`
- [x] `addw`
- [x] `addb`
- [x] `subq`
- [x] `subl`
- [x] `subw`
- [x] `subb`
- [x] `orq`
- [x] `orl`
- [x] `orw`
- [x] `orb`
- [x] `adcq`
- [x] `adcl`
- [x] `adcw`
- [x] `adcb`
- [x] `sbbq`
- [x] `sbbl`
- [x] `sbbw`
- [x] `sbbb`
- [x] `idivq`
- [x] `idivl`
- [x] `idivw`
- [x] `idivb`
- [x] `divq`
- [x] `divl`
- [x] `divw`
- [x] `divb`
- [x] `imulq`
- [x] `imull`
- [x] `imulw`
- [x] `mulq`
- [x] `mull`
- [x] `mulw`
- [x] `mulb`
- [x] `shlq`
- [x] `shll`
- [x] `shlw`
- [x] `shlb`
- [x] `shrq`
- [x] `shrl`
- [x] `shrw`
- [x] `shrb`
- [x] `sarq`
- [x] `sarl`
- [x] `sarw`
- [x] `sarb`
- [x] `salq`
- [x] `sall`
- [x] `salw`
- [x] `salb`
- [x] `negq`
- [x] `negl`
- [x] `negw`
- [x] `negb`
- [x] `xorq`
- [x] `xorl`
- [x] `xorw`
- [x] `xorb`
- [x] `andq`
- [x] `andl`
- [x] `andw`
- [x] `andb`
- [x] `notq`
- [x] `notl`
- [x] `notw`
- [x] `notb`
- [x] `cmpq`	
- [x] `cmpl`	
- [x] `cmpw`	
- [x] `cmpb`	
- [x] `seto`
- [x] `setno`
- [x] `setb`
- [x] `setae`
- [x] `setbe`
- [x] `seta`
- [x] `setpo`
- [x] `setl`
- [x] `setg`
- [x] `setle`
- [x] `setge`
- [x] `sete`
- [x] `setne`
- [x] `setnb`
- [x] `call`
- [x] `jmp`
- [x] `jne`
- [x] `je`
- [x] `jl`
- [x] `jg`
- [x] `jle`
- [x] `jge`
- [x] `jbe`
- [x] `jnb`
- [x] `jnbe`
- [x] `jp`
- [x] `ja`
- [x] `js`
- [x] `jb`
- [x] `jns`
- [x] `push`
- [x] `pop`
- [x] `cqto`
- [x] `cltd`
- [x] `cltq`
- [x] `leave`
- [x] `hlt`
- [x] `nop`
- [x] `syscall`
- [x] `ret`
- [ ] ...

## Local symbols
VAS ignores symbols beginning with `.L`

```asm
.global _start

_start:
    movq $1, %rax
    movq $1, %rdi
    leaq .L1(%rip), %rsi
    movq $15, %rdx
    syscall

    movq $60, %rax
    movq $0, %rdi
    syscall

.section .data, "wa"
.L1:
 .string "Hello, world!\n"
```
```
┌──[~/vas]
└─$ ./vas main.s

┌──[~/vas]
└─$ readelf -s main.o                                  

Symbol table '.symtab' contains 3 entries:
  番号:      値         サイズ タイプ  Bind   Vis      索引名
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 0000000000000000     0 SECTION LOCAL  DEFAULT    2 .data
     2: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT    1 _start
```

## Assembler Directives
`.string`
```asm
.string "Hello, world!"
```

`.byte` `.word` `.long` `.quad`
```asm
.section .data, "aw"

constant_string:
	.string "Hello\n"

.quad constant_string
.quad 0x10
.long 0x10
.word 0x10
.byte 0x10
```
```asm
.byte 0x72
.byte 0x101
.byte 0x108
.byte 0x108
.byte 0x111
.byte 0x44
.byte 0x32
.byte 0x119
.byte 0x111
.byte 0x114
.byte 0x108
.byte 0x100
.byte 0x33
```

`.section`
```asm
.section .text, "ax"
```
section attributes
- `a` alloc
- `w` write
- `x` execute

`.global`
```asm
.global symbol_name
```

`.local`
```asm
.local symbol_name
```

