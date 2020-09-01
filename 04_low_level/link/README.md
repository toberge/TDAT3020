# Oppgave 3

Gikk gjennom stegene i READMEen og slo opp options i `gcc`-manualen.

## Biblioteket

```sh
gcc -c -fPIC a_function.c more_functions.c
gcc -shared a_function.o more_functions.o -o libfunctions.so
sudo cp libfunctions.so /usr/lib
```

`-c` compilerer C-kildekode til objektfiler.

Fra manualen til `gcc` ser jeg at `-shared` lager en bibliotekfil (`.so` for _shared object_):

```
-shared
    Produce a shared object which can then be linked with other objects to
    form an executable.  Not all systems support this option.  For
    predictable results, you must also specify the same set of options
    used for compilation (-fpic, -fPIC, or model suboptions) when you
    specify this linker option.[1]
```

`-fPIC` ser også ut til å ha med dynamisk linking å gjøre.

## Dynamisk linking

Neste steg: `-l` spesifiserer biblioteker som skal inkluderes, f.eks. `-lpthread` eller `-lmath`.

```sh
gcc main.c -lfunctions -o c_example
./c_example
```

Med

```sh
ldd c_example
```

ser jeg at `c_example` blant annet krever `libfunctions.so`, som forventet, i tillegg til noen standard C-biblioteker.

```
libfunctions.so => /usr/lib/libfunctions.so (0x00007fc9f6a23000)
```

## Endringen

Rettet opp skrivefeilen i 

```diff
 void another_function() {
-  printf("You have caled another_function\n");
+  printf("You have called another_function\n");
 }
```

og kompilerte biblioteket på nytt.
Da jeg så kjørte fila `c_example`, var skrivefeilen fordunstet – fordi `c_example` bruker biblioteket fra `/usr/lib`, `another_function` er _ikke_ definert i `c_example`.
Hvis `more_functions.o` derimot hadde blitt linket direkte inn i `c_example`, hadde vi måttet kompilere `c_example` på nytt for å se endringen.
