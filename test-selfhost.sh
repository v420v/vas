
set -x -e

v . -enable-globals

cd selfhost

../vas -o v2.o vas.s
gcc -o v2 v2.o

./v2 -o v3.o vas.s
gcc -o v3 v3.o

./v3 -o v4.o vas.s
gcc -o v4 v4.o

diff -s v2.o v3.o
diff -s v2.o v4.o

cd ..

echo OK

