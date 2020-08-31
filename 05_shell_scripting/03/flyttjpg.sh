#!/bin/sh
# Parameteren $1 er filnavn m. katalog

# NB: Ingen *feil* i denne fila, men en del steder der " lønner seg

# Beregn katalognavn utfra filnavn
JPGDIR="$(dirname "$1")"/jpg

# Opprett hvis den ikke fins fra før
if [ ! -d "$JPGDIR" ] ; then
    mkdir "$JPGDIR" ;
fi

# Flytt filen
mv "$1" "$JPGDIR"
