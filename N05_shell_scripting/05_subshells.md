Disclaimer: Jeg bruker `$()` istedenfor aksenter, se
[shellcheck-wikiens entry](https://github.com/koalaman/shellcheck/wiki/SC2006)
for noen lenker videre til info om edgecases der den ene opptrer mer lettforståelig enn den andre.

I linja ``echo Jeg heter `whoami` `` kjøres først `whoami`,
som finner brukernavnet til nåværende bruker.
Så substitueres resultatet av `whoami` inn i `echo`-kommandoen:
`echo Jeg heter brukernavn`. Dette er den endelige kommandoen som kjøres.

I ``MASKIN=`hostname` `` settes variabelen `MASKIN` til resultatet av `hostname`
(som gir navnet til maskina skriptet kjøres på).

(Neste gang kan du gjerne nevne `$()` i undervisninga, Hafting)
