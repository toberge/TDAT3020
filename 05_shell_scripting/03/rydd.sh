#!/bin/sh

# Denne find-kommandoen kjører `flyttjpg` med *alle* filene som argument
# – siden `flyttjpg` kun bruker argument nr. 1 vil ikke dette fungere
#   (kun én fil vil håndteres om gangen)
# Dessuten bør `-type f` spefisieres så vi ikke flytter _mapper_ som ender i .jpg
# >>> find /home -name "*.jpg" -exec flyttjpg {} \;

# Har noen alternativer:
# - bruke xargs for å gi kun *ett* argument videre
# - skrive om flyttjpg så den benytter seg av hele argumentlista

# Velger det første:
find /home -type f -name "*.jpg" -print0 | xargs -0 -n1 flyttjpg
