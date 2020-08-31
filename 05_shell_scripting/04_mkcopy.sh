#!/bin/sh
#
# Finner alle .txt-filer og lager kopier av dem

find "$HOME" -type f -% "*.txt" -print0 | xargs -0 -I % cp % %.kopi
