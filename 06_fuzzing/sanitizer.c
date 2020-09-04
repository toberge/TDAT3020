#include <stdlib.h>
#include <string.h>

#define SANITIZER_BUFSIZE 100

// Replaces &, < and > in a string with HTML ampersand codes
char *sanitize(const char *s) {
    char *o = malloc(sizeof(char) * SANITIZER_BUFSIZE);
    if (o == NULL)
        return o;
    int i = 0;
    int cur_size = SANITIZER_BUFSIZE;

    for (int j = 0; s[j] != '\0'; j++) {
        if (i + 8 > SANITIZER_BUFSIZE) {
            cur_size += 20;
            o = realloc(o, sizeof(char) * cur_size);
            if (o == NULL)
                return o;
        }
        switch (s[j]) {
            case '&':
                strcpy(&o[i], "&amp;");
                i += 5;
                break;
            case '<':
                strcpy(&o[i], "&lt;");
                i += 4;
                break;
            case '>':
                strcpy(&o[i], "&gt;");
                i += 4;
                break;
            default:
                o[i] = s[j];
                i++;
        }
    }
    o[i] = '\0';

    return realloc(o, sizeof(char) * (i+1));
}
