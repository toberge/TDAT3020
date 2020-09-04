#include "sanitizer.h"
#include <stddef.h>
#include <stdint.h>

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    // constrain to null-terminated strings
    const char *cstring = (const char*) data;
    if (cstring[size - 1] != '\0')
        return 0;

    sanitize(cstring);
    return 0;
}
