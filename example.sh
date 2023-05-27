#!/bin/bash

set -x

./vas -o ./examples/fibonacci.o ./examples/fibonacci.s && gcc -o ./examples/fibonacci.out ./examples/fibonacci.o && ./examples/fibonacci.out

./vas -o ./examples/fizzbuzz.o ./examples/fizzbuzz.s && gcc -o ./examples/fizzbuzz.out ./examples/fizzbuzz.o && ./examples/fizzbuzz.out

./vas -o ./examples/loop.o ./examples/loop.s && gcc -o ./examples/loop.out ./examples/loop.o && ./examples/loop.out

./vas -o ./examples/call.o ./examples/call.s && ld -o ./examples/call.out ./examples/call.o && ./examples/call.out

./vas -o ./examples/mem_ref.o ./examples/mem_ref.s && ld -o ./examples/mem_ref.out ./examples/mem_ref.o && ./examples/mem_ref.out

./vas -o ./examples/puts.o ./examples/puts.s && gcc -o ./examples/puts.out ./examples/puts.o && ./examples/puts.out

./vas -o ./examples/hello.o ./examples/hello.s && ld -o ./examples/hello.out ./examples/hello.o && ./examples/hello.out

./vas -o ./examples/nop.o ./examples/nop.s && ld -o ./examples/nop.out ./examples/nop.o && ./examples/nop.out && echo $?

./vas -o ./examples/print_int.o examples/print_int.s && gcc -o examples/print_int.out examples/print_int.o && ./examples/print_int.out

./vas -o ./examples/rule110.o examples/rule110.s && gcc -o examples/rule110.out examples/rule110.o && ./examples/rule110.out

