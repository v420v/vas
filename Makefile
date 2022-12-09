
build:
	v vas.v

o:
	./vas > main.o

link:
	ld main.o

clean:
	rm *.o *.out ./vas

