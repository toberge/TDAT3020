#!/bin/sh
#
# Directing stderr to /dev/null should hide all output
# if it really prints to stderr.

make

echo Redirecting stderr to /dev/null:
./hello 2>/dev/null

echo Redirecting stdout to /dev/null:
./hello  >/dev/null
