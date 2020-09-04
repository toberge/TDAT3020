#!/bin/sh
#
# Komprimerer *og fjerner* alle filer som ikke har vært brukt på ei uke
# og er store nok til at det er verdt å komprimere dem (>10KB)
# *og* ikke allerede er komprimerte -> ikke .(zip|gz|bz2)

# + betyr "mer enn" -> her "mer enn 7 dager siden" og "mer enn 10 kilobyte"
# -atime sjekker *aksess*, ikke bare endring (som -ctime og -mtime gjør)
# Bruker argument nr. 1 for å ta imot andre mappebaner,
# jobber mot /home hvis intet argument ble sendt inn.
find "${1:-/home}" -type f -atime +7 -size +10k \
    -not \( -name "*.zip" -name "*.gz" -name "*.bz2" \) -print0 \
    | xargs -0 -I % tar --remove-files -czf %.tar.gz -P %

# testversjon: find "/tmp/tes" -type f -amin +3 -size +10k -print0 | xargs -0 -n1 echo
# mellomrom håndteres fint: 'white lake.jpg' komprimeres til 'white lake.jpg.tar.gz'
