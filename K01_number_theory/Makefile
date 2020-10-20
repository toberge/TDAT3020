.PHONY: clean

kshift: kshift.hs Stuff.hs
	ghc -dynamic kshift.hs Stuff.hs

vigenere: vigenere.hs Stuff.hs
	ghc -dynamic vigenere.hs Stuff.hs

clean:
	rm -f *.o *.hi kshift
