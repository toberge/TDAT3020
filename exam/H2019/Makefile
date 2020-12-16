.PHONY: all clean

all: std

std: print_flag.c
	gcc -O2 -fno-stack-protector print_flag.c -o print_flag

pie: print_flag.c
	gcc -O2 -fno-stack-protector -no-pie print_flag.c -o print_flag

clean:
	rm -rf print_flag
