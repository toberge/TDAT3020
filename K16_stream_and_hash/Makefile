.PHONY: all clean

cbcmac: cbcmac.hs
	ghc -dynamic -O2 -o $@ $<

clean:
	rm -rf *.o *.hi cbcmac
