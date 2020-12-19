#!/bin/sh
#
# Kopierer alle filer med en viss endelse inn i $1.
# $1 er mappenavn, $2 er filendelse

# Avbryt hvis vi mangler noen argumenter
[ "$#" -eq 2 ] || {
    echo "Dette skriptet krever to argumenter:"\
         "<mappenavn> <filendelse>" >&2
    exit 1
}

# Rekursivt filsøk med find, separering med null-byte
# for å unngå problemer med mellomrom og annen whitespace i filnavn.
find . -type f -name "*.$2" -print0 \
    | xargs -0 -n1 -I % cp % "$1"

# Logg filendelse, aktiv lokasjon, destinasjon og ansvarlig bruker
echo "$(whoami) kopierte alle $2-filer i $PWD til $1" >> script.log
