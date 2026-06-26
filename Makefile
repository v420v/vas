
.PHONY: build test clean

build:
	v . -o vas

test:
	v test tests/

clean:
	rm *.o *.out ./vas examples/*.o

