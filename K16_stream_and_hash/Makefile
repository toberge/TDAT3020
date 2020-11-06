.PHONY: all clean pdf

cbcmac: cbcmac.hs
	ghc -dynamic -O2 -o $@ $<

pdf: README.md
	pandoc README.md -o hashogsånt.pdf --template eisvogel --listings --pdf-engine=xelatex

clean:
	rm -rf *.o *.hi cbcmac
