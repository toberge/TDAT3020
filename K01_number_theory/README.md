---
title: "Øving K14 i Sikkerhet i programvare og nettverk"
author: Tore Bergebakken
header-includes:
- "\\newcommand{\\Mod}[1]{\\ (\\mathrm{mod}\\ #1)}"
---

# Oppgave 1

$$
\begin{aligned}
&232 + 22\cdot77 - 18^2 \Mod{8}\\
&\equiv 0 + 6\cdot5 - 2^2 \equiv 30-4 \equiv 6-4 \equiv 2 \Mod{8}\\
\end{aligned}
$$

# Oppgave 2

## 2a)

Begynte å gjøre det manuelt, skrev så et program for å gjøre det for meg.

$$
\begin{tabular}{ c || c c c c c c c c c c c }
$\cdot$ & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11\\
\hline\hline
1 & {\color{red}\bfseries1} & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11\\
2 & 2 & 4 & 6 & 8 & 10 & 0 & 2 & 4 & 6 & 8 & 10\\
3 & 3 & 6 & 9 & 0 & 3 & 6 & 9 & 0 & 3 & 6 & 9\\
4 & 4 & 8 & 0 & 4 & 8 & 0 & 4 & 8 & 0 & 4 & 8\\
5 & 5 & 10 & 3 & 8 & {\color{red}\bfseries1} & 6 & 11 & 4 & 9 & 2 & 7\\
6 & 6 & 0 & 6 & 0 & 6 & 0 & 6 & 0 & 6 & 0 & 6\\
7 & 7 & 2 & 9 & 4 & 11 & 6 & {\color{red}\bfseries1} & 8 & 3 & 10 & 5\\
8 & 8 & 4 & 0 & 8 & 4 & 0 & 8 & 4 & 0 & 8 & 4\\
9 & 9 & 6 & 3 & 0 & 9 & 6 & 3 & 0 & 9 & 6 & 3\\
10 & 10 & 8 & 6 & 4 & 2 & 0 & 10 & 8 & 6 & 4 & 2\\
11 & 11 & 10 & 9 & 8 & 7 & 6 & 5 & 4 & 3 & 2 & {\color{red}\bfseries1}
\end{tabular}
$$

## 2b)

Som vanlig $1$ og $11$, i tillegg $1$ og $11$. Alle har symmetriske multiplikative inverser.
<!-- Dessuten $5$ og $7$, som er innbyrdes multiplikative inverser modulo 12. -->

## 2c)

Skal bevise følgende:

Ingen 0 eller 1 på samme rad/kolonne, dvs.:
*Hvis $a$ ikke har multiplikativ invers, fins en $b \not\equiv 0 \Mod{12}$ slik at $ab \equiv 0 \Mod{12}$*

Gitt et tall $a \in \mathbb{Z}_{12}$ slik at
$\forall x\in \mathbb{Z}_{12},\: ax \not\equiv 1 \Mod{12}$

**TODO**

Da _må_ det finnes et tall $b \in \mathbb{Z}_{12}$ som gir... eh, okei?


# Oppgave 3

Invers matrise → kun hvis $\det A$ har multiplikativ invers i $\mathbb{Z}_n$

$$
A =
\begin{pmatrix}
2 & -1\\
5 & 8
\end{pmatrix}
$$

## 3a)

Over $\mathbb{Z}_{10}$

$$\det A = 2\cdot8 - 5(-1) = 16 + 5 \equiv 6 + 5 = 11 \equiv 1 \Mod{10}$$

så $A$ har en invers modulo 10:

$$
A^{-1} =
\begin{pmatrix}
8 & 1\\
-5 & 2\\
\end{pmatrix}
\equiv
\begin{pmatrix}
8 & 1\\
5 & 2\\
\end{pmatrix}
\Mod{10}
$$

Sløyfer $\frac{1}{\det A}$ foran, siden denne er lik $1.$

## 3b)

Over $\mathbb{Z}_{9}$

$$\det A = 2\cdot8 - 5(-1) = 16 + 5 \equiv 7 + 5 = 12 \equiv 3 \Mod{10}$$

så $A$ har **ikke** en invers over $\mathbb{Z}_{9}$.

# Oppgave 4

## 4a)

Antall nøkler avhenger av antallet tegn i alfabetet, fra kombinatorikken vet vi at antall permutasjoner der rekkefølgen har betydning, er

$$N! = 29! = 8,841761994\cdot 10^{30}$$

## 4b)

Enkle grep Alice og Bob kan gjøre for å bedre sikkerheten:

+ $\dots$ **TODO**

## 4c)

Som i 4a: $n!$

# Oppgave 5

`YÆVFB VBVFR ÅVBV` er den krypterte meldinga.

Et k-shift-chiffer, men vi kjenner ikke k...

Skrev Haskell-kode for å dekryptere, fikk `HJERNENERALENE` ...  
Etter litt mistanke om feil i koden, kom jeg til at det skal tydes `HJERNEN ER ALENE` (igjen en sang) med $k=17$.

Hvordan: Kjørte programmet, skrev den krypterte meldinga, fant da at det fornuftige var på linje 17 ved å pipe output til `nl` som setter linjenummer på tekst, og se etter `HJERNENERALENE`. Bekreftet dette ved å kjøre  
`map backlate $ decrypt (map translate "YÆVFBVBVFRÅVBV") 29 17`
som ga tilbake `HJERNENERALENE`. (ja, koden er litt rotete, beklager)

Bonus: I foilene var det en annen melding kryptert med k-shift-chiffer:  
`WRTFVYURYYRBUNOVSS` → `JEGVILHELLERHABIFF`

# Oppgave 6

Formell definisjon av et blokkchiffer basert på et k-shift-chiffer:

$N$ tegn og blokkstørrelse $b$...

**TODO** dette blir helt feil

$$
\begin{aligned}
\mathcal{P} &= \mathcal{C} = \mathcal{K} = \{x \mid 0 \le x < N\}\\
e_k(x) &= (x_1 + x_2 + \cdots + x_b + k) \Mod{N}\\
d_k(x) &= (x_1 + x_2 + \cdots + x_b - k) \Mod{N}
\end{aligned}
$$

# Oppgave 7 - Vigénere

## 7a)

Skal kryptere "Nå er det snart helg" med $K = "\text{torsk}"$.

Skrev litt Haskell-kode igjen og det årna sæ:

```haskell
bl $ encryptNums 29 (tl "NÅERDETSNARTHELG") (tl "TORSK")
```

Fikk `DNVGNXEGCKHEYWVZ` som den krypterte teksten, verifiserte at det gikk an å oversette tilbake.

(kjørte det bare i `ghci`-interpreteren, lagde ikke noen `main` for denne)

## 7b)

Skal dekryptere `QZQOBVCAFFKSDC` med nøkkelord `BRUS`

```haskell
decrypt "PIZZAELLERTACO" "BRUS"
```

Får `PIZZAELLERTACO` -- ja takk, begge deler

## 7c)

$m$ er antall tegn nøkkelen (og blokkene) består av. Med $N$ tegn totalt, vil antall mulige nøkler være $N^m$ (rekkefølgen har betydning, med tilbakelegging).
<!-- $^NP_m = \frac{N!}{(N-m)!}$ -->

Eksempelvis for $N=29$ tegn i alfabetet og en blokkstørrelse på $m=4$:
$$N^m = 29^4 = 707281$$

# Oppgave 8

$$
K =
\begin{pmatrix}
11 & 8\\
3 & 7
\end{pmatrix}
$$

## 8a)

Standard metode for invers av $2\times2$-matrise:

Først en test av determinanten:

$$\det K = 11\cdot7 - 3\cdot8 = 53 \equiv 24 \Mod{29}$$

Den er ikke lik $1$, så dette blir litt mer komplisert.

Se [denne videoen](https://youtu.be/kfmNeskzs2o) for fremgangsmåten.

**REGN UT MULTIPLIKATIV INVERS SELV?**

Så: Den multiplikative inverse av $24$ er $23$ modulo $29$.

Vi bruker

$$
K^{-1} =
24 \cdot 23
\begin{pmatrix}
7 & -8\\
-3 & 11
\end{pmatrix}
=
\begin{pmatrix}
3864 & -4416\\
-1656 & 6072
\end{pmatrix}
\equiv
\begin{pmatrix}
7 & 21\\
26 & 11
\end{pmatrix}
\Mod{29}
$$

## 8b)

## 8c)

## 8d)
