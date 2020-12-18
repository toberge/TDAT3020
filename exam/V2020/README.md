# 9 Case-oppgave

Nåværende ordning:

+ Noen få maskiner på nett
+ Internt nettverk med filservere

Nå skal heile skiten på nett

Personalsjefens ønsker:

+ Konfidensiell informasjon (skal også være skjult internt → brukergrupper)

Adm.dir:

+ Vil ikke la sine undersåtter få vite om hens egne goder
+ Papirarbeid hjemmefra
+ Håper det ikke _koster_ mer
  + En VPN-server må være oppe og gå, kan koste _litt_

Lagersjefen:

+ Hvorfor er jeg på dette møtet?
+ Mailer med plukklister på telefonen (impliserer at de _har_ internett der)
  + Er dette konfidensielt? Det bør kanskje være en bedre ordning her...
  + Sett opp en grei mailserver eller noe
    + Med spamfilter osv.
    + Må sjekke at mail fra firmaadresser faktisk kommer derfra (men dette skal skje automagisk)

Salgsjef:

+ Gira på nettbutikk (vs. telefax)
+ Markedsføring
  + Hvor fikk du disse 100 000 epostene fra?
  + Skal du virkelig spamme folk ned såpass heftig?
+ Selgere skal kunne legge bestillinger inn i systemet fra hvorsomhelst
  + VPN methinks
+ Hemmelige kundelister
  + Beskytt dem på filserveren

## Elementer

+ Åpne tjenester
  + DMZ med webtjener iallfall
  + Tobeint eller dobbel brannmur
+ Generell beskyttelse
  + Brannmur
  + IDS – helst både NIDS og HIDS (siste på filserverne)
+ Internt nettverk
+ Markedsføring
  + Kontoer på sosiale medier og epost bør ikke falle i gale hender
