#include "sanitizer.h"
#include <assert.h>
#include <string.h>
#include <stdlib.h>

int main() {
    char *str = "&";
    char *out;
    assert(strcmp((out = sanitize(str)), "&amp;") == 0);
    free(out);
    str = "";
    assert(strcmp((out = sanitize(str)), "") == 0);
    free(out);
    str = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    assert(strcmp((out = sanitize(str)), "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") == 0);
    free(out);
}
