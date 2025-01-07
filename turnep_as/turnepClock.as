



LOAD rac $1
LOAD rbc $31
LSHIFT rac rbc

# rac contient l'offset des addresses pour la rom
LOAD rcc $0
OR rcc rac
LOAD r1x rcc # jour

LOAD rcc $1
OR rcc rac
LOAD r2x rcc # mois

LOAD rcc $2
OR rcc rac
LOAD r3x rcc # annee

LOAD rcc $3
OR rcc rac
LOAD r4x rcc # heure

LOAD rcc $4
OR rcc rac
LOAD r5x rcc # minutes

LOAD rcc $5
OR rcc rac
LOAD r6x rcc # secondes

LOAD rcc $6
OR rcc rac
LOAD r9x rcc # nombre de tours par seconde

LOAD rdx $25


clockCycleLoop:
ADD rdx $1







.data
12 # jour
5 # mois
2024 # annee
8 # heure
26 # minutes
32 # secondes

10000000 # nombre de tours par seconde



