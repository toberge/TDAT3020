---
title: "Øving 11: Mail"
author: Tore Bergebakken
lang: no
---

# Del 1

## Sending

Kjørte først en sending av epost via en adresse jeg har fra ISP-en hjemme.
Fanget pakker og filtrerte med `smtp` som display filter:

![Pakkefangst _fra_ meg](img/pakkefangst1.png)

Riktignok settes flagget `STARTTLS` i en tidlig pakke, men...

Ser at innholdet er tilgjengelig i klartekst:

![Innhold i klartekst](img/innhold.png)

Og det verste av alt: Brukernavn og passord sendes som en base64-kodet streng. Dette lover ikke godt.

```sh
echo 'base64avminecredentials' | base64 -d
>>> <mitt brukernavn><mitt passord>
```

## Mottak

Prøvde så å motta litt epost og fange _de_ pakkene.
Det viste seg å være litt mer krevende, da det ikke bare var så enkelt som å filtrere på SMTP-protokollen.
Endte opp med å bla gjennom pakkefangst filtrert på TLS til jeg fant noe med domenenavnet til eposttjeneren. (et bedre display-filter var `tcp.port == 143` (for IMAP), men det kom jeg først på senere)

![Pakkefangst _til_ meg](img/pakkefangst2.png)

![Innhold som helt klart ikke er i klartekst](img/innhold2.png)

Her er situasjonen ganske annerledes – innholdet _er_ kryptert (det ser iallfall sånn ut når det tolkes som ASCII) og det ser ut til å være passe lite mulig å hente ut noe passord derfra.

## Konklusjon

Svarene på oppgave a og b er de samme for utgående epost:
Et rungende, bekymret **ja**.

Siden svaret på 1a og 1b er diametralt motsatt for innkommende epost, antar jeg det har noe med konfigurasjonen i epostprogrammet mitt å gjøre (som jeg har kopiert med meg gjennom utallige reinstallasjoner).

# Del 2

Se [`mailcheck.sh`](mailcheck.sh) (vedlagt som `mailcheck.sh.txt`)

Brukte bl.a. [dmarcian.com](https://dmarcian.com/spf-syntax-table/)
som kilde for innholdet i et SPF-felt.
Standarden er kanskje ikke fulgt til alle punkt og prikker, men oppgavens krav er tilfredsstillende oppfylt.
