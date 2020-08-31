#!/bin/sh
#
# Directing stderr to /dev/null should hide all output
# if it really prints to stderr.

./hello 2>/dev/null
