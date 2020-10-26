.PHONY: clean pdf

kshift: kshift.hs Stuff.hs
	ghc -dynamic kshift.hs Stuff.hs

vigenere: vigenere.hs Stuff.hs
	ghci vigenere.hs

pdf: README.md
	pandoc README.md -o tallteori_og_chifre.pdf --template eisvogel --listings

clean:
	rm -f *.o *.hi kshift
