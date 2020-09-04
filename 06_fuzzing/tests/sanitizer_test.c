#include "sanitizer.h"
#include <assert.h>
#include <string.h>

int main() {
    char *str = "&";
    assert(strcmp(sanitize(str), "&amp;") == 0);
}

