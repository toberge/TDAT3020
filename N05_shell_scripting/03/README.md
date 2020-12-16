# En beklagelse

Jeg kjørte ikke kommandoen.
Jeg testet andre deler av øvingen, bare ikke denne.
Jeg trodde jeg visste hvordan find funket.
Jeg trodde jeg hadde funnet en feil, og lette ikke mer.
Skulle bli fort ferdig.
Det viste seg at jeg bare visste hvordan `-exec <cmd> {} +` funket,
_ikke_ hvordan `-exec <cmd> {} \;` funket.
Kan jeg be om tilgivelse? Jeg trodde ikke det var noen forskjell.

Se `rydd.sh` for en beskrivelse av feilen.

# Originalversjonen:

```
.
├── flyttjpg.sh
├── jpg
│   └── i_am_an_image.jpg
├── rydd.sh
└── yes
    ├── eh.jpg
    ├── indeed
    │   └── verymuch.jpg
    └── no.txt
```

Kjører rydd.sh én gang:

```
.
├── flyttjpg.sh
├── jpg
│   └── jpg
│       └── i_am_an_image.jpg
├── rydd.sh
└── yes
    ├── indeed
    │   └── jpg
    │       └── verymuch.jpg
    ├── jpg
    │   └── eh.jpg
    └── no.txt
```

To ganger:

```
.
├── flyttjpg.sh
├── jpg
│   └── jpg
│       └── jpg
│           └── i_am_an_image.jpg
├── rydd.sh
└── yes
    ├── indeed
    │   └── jpg
    │       └── jpg
    │           └── verymuch.jpg
    ├── jpg
    │   └── jpg
    │       └── eh.jpg
    └── no.txt
```

..og feilen er _fullstendig åpenbar_.

# Faktisk fikset versjon:

```
.
├── flyttjpg.sh
├── jpg
│   └── i_am_an_image.jpg
├── rydd.sh
└── yes
    ├── eh.jpg
    ├── indeed
    │   └── verymuch.jpg
    └── no.txt
```

Ren output fra find-kommandoen
`find /tmp/asdf -type f -name "*.jpg" -not -path "*/jpg/*"`:

```
/tmp/asdf/yes/indeed/verymuch.jpg
/tmp/asdf/yes/eh.jpg
```

Første kjøring:

```
.
├── flyttjpg.sh
├── jpg
│   └── i_am_an_image.jpg
├── rydd.sh
└── yes
    ├── indeed
    │   └── jpg
    │       └── verymuch.jpg
    ├── jpg
    │   └── eh.jpg
    └── no.txt
```

Andre kjøring: Akkurat det samme.
