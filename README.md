
# Different Dwarf

Clang doesn't give me the same source line information I get from Gcc.
In V8, I'm working on a project where I embed source line information
in code that is generated then embedded in a binary with inline assembly
code. It works just great with GCC but not with Clang. How come?

## How to build

You need both gcc and clang. Edit their locations in the Makefile if you
need to then run `make`.

## How to run

File `foo.s` is a little function with a debug break in it, and embedded
source information which points (whimsically) to a file of quotes by
C. S. Lewis. `bar.s` is an identical function. I compile `foo.s` like this:

    gcc -g -c -o foo.o foo.s

The `-g` enables debugging information.

Whereas `bar.s` is compiled with clang like so:

    clang -g -c bar.s

In `gdb` you can see the source integration working great for function `foo()`:

    mvstanton@yesod:~/src/different-dwarf$ gdb --args ./different-dwarf
    GNU gdb (GDB) 8.2-gg2
    Copyright (C) 2018 Free Software Foundation, Inc.
    ...
    (gdb) r
    Starting program: different-dwarf
    
    Program received signal SIGTRAP, Trace/breakpoint trap.
    0x0000000000400534 in foo () at quotes.txt:7
    7       "Are the gods not just?"
    (gdb)

If you print the call stack you'll see source line information in the output:

    (gdb) bt
    #0  0x0000000000400534 in foo () at quotes.txt:7
    #1  0x0000000000400518 in main (argc=1, argv=0x7ffc138e2e48) at main.cc:8
    (gdb)

Continue the run and you'll get a breakpoint in function `bar()`, compiled with
clang:

    (gdb) c
    Continuing.
    Hello there foo
    
    Program received signal SIGTRAP, Trace/breakpoint trap.
    0x000000000040055d in bar ()
    (gdb) bt
    #0  0x000000000040055d in bar ()
    #1  0x0000000000400527 in main (argc=1, argv=0x7ffc138e2e48) at main.cc:9
    (gdb)

As you see, no source information here. This despite the fact that the `bar.o` file
does have a DWARF source section in it (`.debug_line`).

The problem seems to be that other necessary DWARF segments aren't present in the
resulting object files. Specifically, `objdump` output reveals that `foo.o` has
the following extra sections that aren't in `bar.o`:

 * .debug_info (0x3d bytes)
 * .debug_abbrev (0x14 bytes)
 * .debug_aranges (0x30 bytes)
 * .debug_str (0x52 bytes)

I'd really like to have this information on the clang side, as we build with the
clang toolchain. Any ideas?


