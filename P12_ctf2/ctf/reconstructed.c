#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Reconstructed version of the vulnerable binary's source code

void read_all_stdin(char *buffer)
{
  int c;
  int offset;
  
  offset = 0;
  while( 1 ) {
    c = fgetc(stdin);
    if (c == -1) break;
    // performs no check to see if it's within
    // the buffer's limit...
    // - this lets us do a classic buffer overflow
    *(char *)(buffer + offset) = (char)c;
    offset++;
  }
  return;
}

int main()
{
  char buffer [32];
  
  memset(buffer,0,0x20); // does set all 32 bytes to \0
  read_all_stdin(buffer); // this reads an _unknown_ amount of bytes
  if (buffer[0] == '\0') { // suppling an empty string triggers this
    puts("What is your name?");
  } else {
    printf("Hello %s!\n",buffer); // printing the content of the buffer
                                  // as a zero-terminated string
  }
  return 0;
}
