#include <stdlib.h>
#include <stdio.h>

extern "C" void foo(const char *);
extern "C" void bar(const char *);

int main(int argc, char *argv[]) {
  foo("foo");
  bar("bar");
  return 0;
}
