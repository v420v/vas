
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
- [x] `idivq`
- [x] `idivl`
- [x] `idivw`
- [x] `idivb`
- [x] `imulq`
- [x] `imull`
- [x] `imulw`
- [x] `xorq`
- [x] `xorl`
- [x] `xorw`
- [x] `xorb`
- [x] `cmpq`	
- [x] `cmpl`	
- [x] `cmpw`	
- [x] `cmpb`	
- [x] `setl`
- [x] `setg`
- [x] `setle`
- [x] `setge`
- [x] `sete`
- [x] `setne`
- [x] `call`
- [x] `jmp`
- [x] `jne`
- [x] `je`
- [x] `push`
- [x] `pop`
- [x] `cqto`
- [x] `leave`
- [x] `hlt`
- [x] `nop`
- [x] `syscall`
- [x] `ret`
- [ ] ...

## Assembler Directives
`.string`
```asm
.string "Hello, world!"
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

