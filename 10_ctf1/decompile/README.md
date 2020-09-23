# Decompile!

Decompiled `main` function (using Ghidra), with some comments:

```c
undefined8 main(void)

{
  char local_28 [32]; // bufsize: 32 bytes
  
  printf("Enter your name: ");
  fgets(local_28,0x20,stdin); // read 0x20 bytes -> 2*16=32 bytes
  printf("Hello ");
  printf(local_28); // passes USER INPUT into printf's 1st argument
  putchar(10);
  return 0;
}
```

## The vulnerability

The code simply reads 32 chars and passes them to `printf`.
Not in a sane way, the input is passed as the _format string_.
This could lead, at the very least, to a crash if the user types `%` anywhere in their input.

## A fix

Simply merge two of the `printf` calls into this:

```c
printf("Hello %s", local_28);
```

Then `local_28` is handled as a variadic argument and _not_ a format string.

# A look at the source

Actual source code from the implicitly linked repo:

```c
#include <stdio.h>
main() // this explains the "undefined8" type
{
    char name[32]; // name doesn't have a name in assembly
    printf("Enter your name: ");
    fgets(name, 32, stdin);
    printf("Hello ");
    printf(name); // herein lies the problem
    printf("\n"); // this became a putchar call
} // implicit return => explicit in machine code
```

# Fixed source

The fix, applied to the original code:

```c
#include <stdio.h>
main()
{
    char name[32];
    printf("Enter your name: ");
    fgets(name, 32, stdin);
    printf("Hello %s", name);
    printf("\n");
}
```
