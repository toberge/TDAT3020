#include "sanitizer.h"
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    // constrain to null-terminated strings
    char *instring = malloc(sizeof(char) * (size + 1));
    memcpy(instring, data, size); // copy memory chunk
    instring[size] = '\0'; // null-terminate

    char *outstring = sanitize(instring);
    free(outstring);
    free(instring);
    return 0;
}
