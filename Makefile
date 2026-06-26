
build:
	v . -prod -o vas

debug:
	v . -cg -o vas

clean:
	rm -f *.o *.out ./vas examples/*.o

