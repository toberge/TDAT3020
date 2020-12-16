#include <stdio.h>

int show_flag = 0;

void print_flag()
{
    printf("This function is never called.\n");
    if(show_flag)
    {
        printf("You got the flag!\n");
    }
}

int main()
{
    char buff[64];
    printf("print_flag at address 0x%016x\n", &print_flag);
    gets(buff);
}
