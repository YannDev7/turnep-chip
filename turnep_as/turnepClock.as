

% jour = r1x
% mois = r2x
% annee = r3x
% heure = r4x
% minutes = r5x
% secondes = r6x
% cycleCount = r9x

% arg1 = rax
% arg2 = rbx
% valDeRetour = rcx

% treize = r8x

% compteur = rdx

MOV @treize $13

MOV rac $1
MOV rbc $31
LSHIFT rac rbc

# rac contient l'offset des addresses pour la rom
MOV rcc $0
OR rcc rac
LOAD @jour rcc # jour

MOV rcc $1
OR rcc rac
LOAD @mois rcc # mois

MOV rcc $2
OR rcc rac
LOAD @annee rcc # annee

MOV rcc $3
OR rcc rac
LOAD @heure rcc # heure

MOV rcc $4
OR rcc rac
LOAD @minutes rcc # minutes

MOV rcc $5
OR rcc rac
LOAD @secondes rcc # secondes

MOV rcc $6
OR rcc rac
LOAD @cycleCount rcc # nombre de tours par seconde

MOV @compteur $25


clockCycleLoop:
ADD @compteur $1




divisiblePar25:
MOV rac x$ffe0
MOV rbc @arg1








.data
12 # jour
5 # mois
2024 # annee
8 # heure
26 # minutes
32 # secondes

10000000 # nombre de tours par seconde



