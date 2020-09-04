#include "sanitizer.h"
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    // constrain to null-terminated strings
    const char *cstring = (const char*) data;
    if (cstring == NULL || size <= 1 || cstring[size - 1] != '\0')
        return 0;

    char *outstring = sanitize(cstring);
    free(outstring);
    return 0;
}
