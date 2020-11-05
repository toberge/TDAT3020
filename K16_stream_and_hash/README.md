---
title: "TDAT3020 Øving K16"
author: "Tore Bergebakken"
header-includes:
- "\\newcommand{\\Mod}[1]{\\ (\\mathrm{mod}\\ #1)}"
---

# Oppgave 1

## 1a)

$$z_{i+4} = z_{i} + z_{i+1} + z_{i+2} + z_{i+3} \Mod{2}$$

Denne følga er definert ved at hvert tall etter det fjerde er summen modulo 2 av de fire foregående.

### 1a.1)

$$K = 1000$$

Følgen blir:

$${\color{red}10001}100011000$$

Altså en periode på $5$.

### 1a.2)

$$K = 0011$$

Følgen blir:

$${\color{red}00110}0011000$$

Fortsatt en periode på $5$.

### 1a.3)

$$K = 1111$$

Følgen blir:

$${\color{red}11110}11110$$

Atter en gang er perioden $5$.

## 1b)

$$z_{i+4} = z_{i} + z_{i+3} \Mod{2}$$

### 1b.1)

$$K = 1000$$

Følgen blir:

$${\color{red}100011110101100}100011110101100$$

Altså en periode på $15$.

### 1b.2)

$$K = 0011$$

Følgen blir:

$${\color{red}001111010110010}001111\dots$$

Fortsatt en periode på $15$.

### 1a.3)

$$K = 1111$$

Følgen blir:

$${\color{red}111101011001000}11110101\dots$$

Atter en gang er perioden $15$.

**Konklusjon:** Denne følgen gir en periode på $2^n-1 = 15$, som er den _beste_ perioden en LFSR med $n = 4$ kan ha.

# Oppgave 2

$$\mathcal{P} = \mathcal{C} = \mathbb{Z}_{29}$$

Her er $K$ første del av nøkkelstrømmen ($z_1 = K$), og videre er strømmen gitt som $z_{i+1} = x_i$.

**NB:** Når vi dekrypterer, er det den _dekrypterte_ teksten som brukes som input etter første runde.

Kryptering og dekryptering er som i Vigènere gitt ved

$$e_z(x) = (x+z) \Mod{29}$$
og
$$d_z(y) = (y-z) \Mod{29}$$

## 2a)

Skrev et par funksjoner (mye likt Vigènere-implementasjonen) for å utføre dette...

Kunne så kjøre

```haskell
encrypt 17 "GODDAG"
```

og fik `XURGDG` som kryptert tekst.

## 2b)

Skrev litt Haskell-kode -- måtte gjøre dekrypteringen annerledes enn i Vigènere-implementasjonen, siden den skulle bruke forrige krypterte verdi om og om igjen.

En kjøring av

```haskell
bl $ decryptNums 29 5 [23,8,23,12,21,2,4,3,17,13,19]
```

ga tilbake `STEINSPRANG`

Matematisk:

$$x = 23\:08\:23\:12\:21\:02\:04\:03\:17\:13\:19,\:k = 5$$

$$
\begin{aligned}
x_1 &= (y_1 - k) \Mod{29}\\
x_2 &= (y_2 - x_1) \Mod{29}\\
&\vdots\\
x_n &= (y_n - x_{n-1}) \Mod{29}
\end{aligned}
$$

(men å gjøre det for hånd er _altfor_ omstendelig, y'know)

# Oppgave 3 - HMAC

$$
\begin{aligned}
K &= 1001\\
\text{ipad} &= 0011\\
\text{opad} &= 0101
\end{aligned}
$$

Funksjonen $h$ kan enkelt lages med litt bitshifting og maskering.

Selve HMAC krever _flere_ bitshifts til venstre for å konkatenere bitmønstrene.


## 3a)

Tydeligvis `1001`

## 3b)

<!-- Jeg får `hmac(0b0111)` til å bli `0100` – den stemmer ikke med den oppgitte HMAC-en, så det _er_ grunn til å tro at meldingen _ikke_ er autentisk. -->

Jeg får `hmac(0b0111)` til å bli `0100` – den _stemmer faktisk_ med den oppgitte HMAC-en, så det er _ikke_ grunn til å tro at meldingen _ikke_ er autentisk. (Jeg og avsender vet nøkkelen, ingen andre skal vite det → _ren flaks_ kreves for å forfalske HMAC-en.)

# Oppgave 4


# Oppgave 5


# Oppgave 6

