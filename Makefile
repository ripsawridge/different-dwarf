# different-dwarf
# This project shows how clang creates less effective DWARF debugging
# information for assembly.

CLANG=clang
GCC=gcc

different-dwarf: main.cc foo.o bar.o quotes.txt
	$(CLANG) -g main.cc foo.o bar.o -o different-dwarf

foo.o: foo.s
	$(GCC) -g -c -o foo.o foo.s

bar.o: bar.s
	$(CLANG) -g -c bar.s

all: different-dwarf

clean:
	rm different-dwarf *.o

