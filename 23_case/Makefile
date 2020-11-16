.PHONY: pdf all clean

all: pdf

pdf: case.pdf

case.pdf: README.md
	pandoc README.md -o case.pdf --template eisvogel --listings -V lang=no

clean:
	rm -f case.pdf
