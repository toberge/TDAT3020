.PHONY: clean run

hello: hello.o
	ld $< -o $@

%.o: %.s
	nasm -f elf64 $<

run: hello
	./hello

clean:
	rm -f *.o hello
