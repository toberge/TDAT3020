#!/bin/sh

# Feil nr. 1:
# Denne find-kommandoen kjører `flyttjpg` med *alle* filene som argument
# – siden `flyttjpg` kun bruker argument nr. 1 vil ikke dette fungere
#   (kun én fil vil håndteres om gangen)
# Dessuten bør `-type f` spefisieres så vi ikke flytter _mapper_ som ender i .jpg
# >>> find /home -name "*.jpg" -exec flyttjpg {} \;

# Har noen alternativer:
# - bruke xargs for å gi kun *ett* argument videre
# - skrive om flyttjpg så den benytter seg av hele argumentlista

# Feil nr. 2:
# Den faktiske feilen at det lages stadig nye jpg-mapper hver gang skriptet kjøres.
# En vil sitte igjen med en ubrukelig stor mengde unødvendige undermapper.

# Har igjen noen alternativer
# - få xargs til å ekskludere alle mapper kalt jpg
# - avbryte skriptet om filbana slutter på /jpg/*.jpg

# Velger å håndtere begge deler i xargs:
find /home -type f -name "*.jpg" -not -path "*/jpg/*" -print0 \
    | xargs -0 -n1 flyttjpg
