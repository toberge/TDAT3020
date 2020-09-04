#!/bin/sh

# Slikt skjer når du ikke gjør som oppgaveteksten sier og bare lar være å kjøre skriptet for å teste:

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Helt feil feil:
# Denne find-kommandoen kjører `flyttjpg` med *alle* filene som argument
# – siden `flyttjpg` kun bruker argument nr. 1 vil ikke dette fungere
#   (kun én fil vil håndteres om gangen)
# Dessuten bør `-type f` spefisieres så vi ikke flytter _mapper_ som ender i .jpg
# >>> find /home -name "*.jpg" -exec flyttjpg {} \;

# Har noen alternativer:
# - bruke xargs for å gi kun *ett* argument videre
# - skrive om flyttjpg så den benytter seg av hele argumentlista
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# NEI, dette er helt feil.
# Formen med ; er fundamentalt annerledes enn formen med +
# - Med ; til slutt erstattes {} med én fil om gangen
# - Med + til slutt erstattes {} med _alle_ filene, som argumenter
# Trodde , funket som +

# Den faktiske feilen at det lages stadig nye jpg-mapper hver gang skriptet kjøres.
# En vil sitte igjen med en ubrukelig stor mengde unødvendige undermapper.

# Har igjen noen alternativer
# - få xargs til å ekskludere alle mapper kalt jpg
# - avbryte skriptet om filbana slutter på /jpg/*.jpg

# Tidligere versjon basert på min antagelse om at jeg hadde funnet den _eneste_ feilen:
# find /home -type f -name "*.jpg" -print0 | xargs -0 -n1 flyttjpg

# Tidligere versjon basert på min antagelse om at begge deler var en feil:
# find /home -type f -name "*.jpg" -not -path "*/jpg/*" -print0 \
#     | xargs -0 -n1 flyttjpg

# Så var det bare én feil, her er en _faktisk_ fiks for den
find /home -type f -name "*.jpg" -not -path "*/jpg/*" -exec flyttjpg.sh {} \;
