#!/bin/sh
# Parameteren $1 er filnavn m. katalog

# NB: Ingen *feil* i denne fila, men en del steder der " lønner seg

# Alternativ 2: Gjør om flyttjpg.sh
# Hvis katalognavnet har en /jpg til sist fra før, avbryt
[ "${1%%/jpg/*.jpg}" = "$1" ] || exit

# Beregn katalognavn utfra filnavn
JPGDIR="$(dirname "$1")"/jpg

# Opprett hvis den ikke fins fra før
if [ ! -d "$JPGDIR" ] ; then
    mkdir "$JPGDIR" ;
fi

# Flytt filen
mv "$1" "$JPGDIR"
