#include "sanitizer.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    char *s;
    if (argc == 2) {
        s = argv[1];
    } else {
        s = "<span class=\"unbelievable\">This is a sentence & so on</span>";
    }
    
    char *sanitized = sanitize(s);
    printf("%s -> %s\n", s, sanitized);
    free(sanitized);
}
