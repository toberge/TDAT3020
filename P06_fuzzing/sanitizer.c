#include <stdlib.h>
#include <string.h>

#define SANITIZER_BUFSIZE 100

// Replaces &, < and > in a string with HTML ampersand codes
// Returns pointer to freeable string
char *sanitize(const char *s) {
    if (!s) return NULL;
    char *o = malloc(sizeof(char) * SANITIZER_BUFSIZE);
    if (!o) return o;
    int i = 0;
    int cur_size = SANITIZER_BUFSIZE;

    for (unsigned long j = 0; s[j] != '\0'; j++) {
        if (i + 8 > cur_size) {
            cur_size += 20;
            o = realloc(o, sizeof(char) * cur_size);
            if (!o) return o;
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
