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

## Utskrift for `statoil.no`:

```
~~~~~~~~~~~~~~~~~~
MX records and IP addresses of those domains:
statoil-no.mail.protection.outlook.com:
  -> 104.47.10.36
  -> 104.47.8.36
~~~~~~~~~~~~~~~~~~
SPF addresses (alternative senders):
104.47.10.36
104.47.8.36
spf.protection.outlook.com gives:
  40.92.0.0/15
  40.107.0.0/16
  52.100.0.0/14
  104.47.0.0/17
  2a01:111:f400::/48
  2a01:111:f403::/48
  spfd.protection.outlook.com gives:
    51.4.72.0/24
    51.5.72.0/24
    51.5.80.0/27
    51.4.80.0/27
    2a01:4180:4051:0800::/64
    2a01:4180:4050:0800::/64
    2a01:4180:4051:0400::/64
    2a01:4180:4050:0400::/64
~~~~~~~~~~~~~~~~~~
Done.
```

## Utskrift for `ibm.com`:

Inneholder eksempler på `a`- og `mx`-mekanismer.

```
~~~~~~~~~~~~~~~~~~
MX records and IP addresses of those domains:
mx0a-001b2d01.pphosted.com:
  -> 148.163.156.1
mx0b-001b2d01.pphosted.com:
  -> 148.163.158.5
~~~~~~~~~~~~~~~~~~
SPF addresses (alternative senders):
148.163.158.5
148.163.156.1
67.231.145.127
67.231.153.87
168.245.101.145
148.163.156.1
148.163.158.5
64.79.155.205
64.79.155.192
64.79.155.206
3.129.120.190
207.218.90.122
18.216.232.154
64.79.155.193
136.179.50.206
_spf.google.com gives:
  _netblocks.google.com gives:
    35.190.247.0/24
    64.233.160.0/19
    66.102.0.0/20
    66.249.80.0/20
    72.14.192.0/18
    74.125.0.0/16
    108.177.8.0/21
    173.194.0.0/16
    209.85.128.0/17
    216.58.192.0/19
    216.239.32.0/19
  _netblocks2.google.com gives:
    2001:4860:4000::/36
    2404:6800:4000::/36
    2607:f8b0:4000::/36
    2800:3f0:4000::/36
    2a00:1450:4000::/36
    2c0f:fb50:4000::/36
  _netblocks3.google.com gives:
    172.217.0.0/19
    172.217.32.0/20
    172.217.128.0/19
    172.217.160.0/20
    172.217.192.0/19
    172.253.56.0/21
    172.253.112.0/20
    108.177.96.0/19
    35.191.0.0/16
    130.211.0.0/22
~~~~~~~~~~~~~~~~~~
Done.
```

## Utskrift for `gmail.com`:

Inneholder eksempel på en redirect.

```
~~~~~~~~~~~~~~~~~~
MX records and IP addresses of those domains:
alt3.gmail-smtp-in.l.google.com:
  -> 173.194.201.27
alt1.gmail-smtp-in.l.google.com:
  -> 108.177.97.27
alt2.gmail-smtp-in.l.google.com:
  -> 74.125.28.27
gmail-smtp-in.l.google.com:
  -> 64.233.162.26
alt4.gmail-smtp-in.l.google.com:
  -> 209.85.146.27
~~~~~~~~~~~~~~~~~~
SPF addresses (alternative senders):
Redirect to _spf.google.com!
_netblocks.google.com gives:
  35.190.247.0/24
  64.233.160.0/19
  66.102.0.0/20
  66.249.80.0/20
  72.14.192.0/18
  74.125.0.0/16
  108.177.8.0/21
  173.194.0.0/16
  209.85.128.0/17
  216.58.192.0/19
  216.239.32.0/19
_netblocks2.google.com gives:
  2001:4860:4000::/36
  2404:6800:4000::/36
  2607:f8b0:4000::/36
  2800:3f0:4000::/36
  2a00:1450:4000::/36
  2c0f:fb50:4000::/36
_netblocks3.google.com gives:
  172.217.0.0/19
  172.217.32.0/20
  172.217.128.0/19
  172.217.160.0/20
  172.217.192.0/19
  172.253.56.0/21
  172.253.112.0/20
  108.177.96.0/19
  35.191.0.0/16
  130.211.0.0/22
~~~~~~~~~~~~~~~~~~
Done.
```
