#include <stdlib.h>
#include <string.h>

#define BUFSIZE 100

// Replaces &, < and > in a string with HTML ampersand codes
char *sanitize(const char *s) {
    char *o = malloc(sizeof(char) * BUFSIZE);
    int i = 0;
    int cur_size = BUFSIZE;

    for (int j = 0; s[j] != '\0'; j++) {
        if (i + 8 > BUFSIZE) {
            cur_size += 20;
            o = realloc(o, sizeof(char) * cur_size);
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

    return o;
}
