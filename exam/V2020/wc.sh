#!/usr/bin/env bash

lines=0

cat "$1" | {
while read -r stuff
do
    ((lines++))
done
echo "$lines"
}
