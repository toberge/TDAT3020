#!/usr/bin/env bash

find ~ -name "*.$1" -exec echo {} \;
echo `whoami` rensket bort "$1" >> script.log
