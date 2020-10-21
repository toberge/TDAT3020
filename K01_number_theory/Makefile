.PHONY: clean

kshift: kshift.hs Stuff.hs
	ghc -dynamic kshift.hs Stuff.hs

vigenere: vigenere.hs Stuff.hs
	ghci vigenere.hs

clean:
	rm -f *.o *.hi kshift
