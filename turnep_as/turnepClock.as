

% jour = r1x
% mois = r2x
% annee = r3x
% heure = r4x
% minutes = r5x
% secondes = r6x
% jourDeLaSemaine = r7x
% cycleCount = r9x

% arg1 = rax
% arg2 = rbx

% arg1mul = rg1
% arg2mul = rg2
% arg3mul = rg3
% valDeRetour = rcx

% treize = r8x

% compteur = rdx

% nJourDansMois = r8c




MOV @treize $13


MOV rcc $0
LOADROM @jour rcc # jour

MOV rcc $1
LOADROM @mois rcc # mois

MOV rcc $2
LOADROM @annee rcc # annee

MOV rcc $3
LOADROM @heure rcc # heure

MOV rcc $4
LOADROM @minutes rcc # minutes

MOV rcc $5
LOADROM @secondes rcc # secondes

MOV rcc $6
LOADROM @cycleCount rcc # nombre de tours par seconde

MOV @compteur $17

cycleSeconde:

ADD @compteur $63
# 1: on determine si l'annee est bissextile (on peut faire ca chaque seconde, on a du temps)

MOV rrt 'finAnneeBissextile->finEtape1
JMP 'anneeBissextile
finEtape1:

# 1 bis: on determine si on doit ajouter 1 au mois ou pas
MOV r9c @mois
ADD r9c x$fffe  # retire 2

NONZERO r9c
JMP 'e1b1
JMP 'e1b2

# on veut que ca prenne toujours le meme nombre d'instructions
e1b1:
MOV r9c $1
JMP 'e1b3
e1b2:
MOV r9c $0
JMP 'e1b3
e1b3:

AND r9c rcx 



etape1bisFin:



# 2: on determine le nombre de jours dans le mois actuel
MOV rac @mois
ADD rac rac


JMP rac  # jump de 2 fois la valeur du mois

ADD rcx $0 # padding 0
ADD rcx $0 # padding 1

MOV @nJourDansMois $31  # janvier
JMP 'etape2fin

MOV @nJourDansMois $28  # fevrier
JMP 'etape2fin

MOV @nJourDansMois $31  # mars
JMP 'etape2fin

MOV @nJourDansMois $30  # avril
JMP 'etape2fin

MOV @nJourDansMois $31  # mai
JMP 'etape2fin

MOV @nJourDansMois $30  # juin
JMP 'etape2fin

MOV @nJourDansMois $31  # juillet
JMP 'etape2fin

MOV @nJourDansMois $31  # aout
JMP 'etape2fin

MOV @nJourDansMois $30  # septembre
JMP 'etape2fin

MOV @nJourDansMois $31  # octobre
JMP 'etape2fin

MOV @nJourDansMois $30  # novembre
JMP 'etape2fin

MOV @nJourDansMois $31  # decembre
JMP 'etape2fin

etape2fin:
ADD @nJourDansMois r9c

# etape 3: on va determiner a chaque fois la prochaine valeur pour chaque unite de temps
MOV rac @secondes
ADD rac x$ffc5  # enleve 59

MOV r6c @secondes

NONZERO rac
JMP 'e3if
JMP 'e3else


# on veut que ca prenne toujours le meme nombre d'instructions
e3if:
MOV r6c $0
MOV rdc $1  # valeur a ajouter au prochain
JMP 'e3endif

e3else:
ADD r6c $1
MOV rdc $0  # valeur a ajouter au prochain
JMP 'e3endif
e3endif:

# etape 4: minutes
MOV r5c @minutes
ADD r5c rdc

MOV rac r5c
ADD rac x$ffc4

NONZERO rac
JMP 'e4if
JMP 'e4else

e4if:
MOV r5c $0
MOV rdc $1
JMP 'e4endif
e4else:
ADD r5c $0  # padding
MOV rdc $0
JMP 'e4endif
e4endif:

# etape 5: heure
MOV r4c @heure
ADD r4c rdc

MOV rac r4c
ADD rac x$ffe8

NONZERO rac
JMP 'e5if
JMP 'e5else

e5if:
MOV r4c $0
MOV rdc $1
JMP 'e5endif
e5else:
ADD r4c $0  # padding
MOV rdc $0
JMP 'e5endif
e5endif:

# etape 6: jour
MOV r1c @jour
ADD r1c rdc

MOV rac r1c
SUB rac @nJourDansMois
ADD rac x$ffff # le numero du jour commence a 1 et non a 0

NONZERO rac
JMP 'e6if
JMP 'e6else

e6if:
MOV r1c $1
MOV rdc $1
JMP 'e6endif
e6else:
ADD r1c $0  # padding
MOV rdc $0
JMP 'e6endif
e6endif:


# etape 7: mois
MOV r2c @mois
ADD r2c rdc

MOV rac r2c
ADD rac x$fff3 # le numero du jour commence a 1 et non a 0

NONZERO rac
JMP 'e7if
JMP 'e7else

e7if:
MOV r2c $1
MOV rdc $1
JMP 'e7endif
e7else:
ADD r2c $0  # padding
MOV rdc $0
JMP 'e7endif
e7endif:


# etape 8: annee
MOV r3c @annee
ADD r3c rdc


# nouveau 9 avant l'ancien 9: jour de la semaine

ADD @compteur $13

MOV rac r2c
MOV r2y r2c
MOV r3y r3c

ADD rac $1

MOV rbc x$fffc
AND rac rbc  # rac <> 0 ssi r2c > 2

NONZERO rac
JMP 'e9previf
JMP 'e9prevelse

e9previf:
ADD r2y $13
ADD r3y x$ffff
JMP 'e9prevfin

e9prevelse:
ADD r2y $1
ADD r3y $0
JMP 'e9prevfin

e9prevfin:


% j = r4y
% k = r5y
% mp = r2y

% h = r6y

# terme 1
MOV @h r1c

# calcul de j et k
MOV rg1 r3y
MOV rrt 'finDivision100->e9Pici1
JMP 'division100
e9Pici1:
MOV @k rg3
MOV @j rg2

# terme 2
MOV rg1 @mp
MUL rg1 @treize

MOV rrt 'finDivision5->e9Pici2
JMP 'division5
e9Pici2:
ADD @h rg1

# terme 3
ADD @h @k

# terme 4
MOV rac $2
RSHIFT @k rac
ADD @h @k

# terme 6
MOV rac @j
ADD rac rac
ADD rac rac
ADD rac @j
ADD @h rac

# terme 5
MOV rac $2
RSHIFT @j rac
ADD @h @j

ADD @h $5 # pour date iso

# mod 7
MOV rg1 @h
MOV rrt 'finDivision7->e9Pici3
JMP 'division7
e9Pici3:

ADD rg1 $1
MOV r7c rg1
ADD @compteur $30

# 9: maintenant faut attendre jusqu'a la fin
# on va faire en sorte que le nombre de cycles depuis le debut de la seconde soit un multiple de 4

MOV rfc @compteur

ADD @compteur $1
ADD @compteur $2
ADD @compteur $1
ADD @compteur $1

ADD @compteur $8


MOV rac b$11
MOV rbc @compteur
AND rbc rac  # rbc vaut compteur mod 4

ADD rbc rbc
ADD rbc rbc  # rbc vaut compteur mod 4 * 4
JMP rbc

JMP 'etape9fin # 0
ADD rac $0 # PAD 1
ADD rac $0 # PAD 2
ADD rac $0 # PAD 3

ADD @compteur $3 #4
ADD rac $0 # PAD 5
ADD rac $0 # PAD 6
JMP 'etape9fin # 7

ADD @compteur $2 #8
ADD rac $0 # PAD 9
JMP 'etape9fin # 10
ADD rac $0 # PAD 11

ADD @compteur $1 #12
JMP 'etape9fin # 13
ADD rac $0 # PAD 14
ADD rac $0 # PAD 15

etape9fin:

# ici, compteur (et le nombre de cycles depuis le debut) est un multiple de 4


MOV rac @cycleCount
MOV rbc @compteur
ADD rbc $16
SUB rac rbc

boucleAttente:
ADD rac x$fffc
ADD @compteur $4
NONZERO rac
JMP 'etape10fin
JMP 'boucleAttente

etape10fin:

ADD @compteur $5


MOV @compteur $1

ADD rac $0
ADD rac $0
ADD rac $0
ADD rac $0
ADD rac $0


MOV r1x r1c
MOV r2x r2c
MOV r3x r3c
MOV r4x r4c
MOV r5x r5c
MOV r6x r6c
MOV r7x r7c


JMP 'cycleSeconde


# au final on l'utilise pas
mult:
MOV rac $1
AND rac @arg2mul

NONZERO rac
JMP 'apres

MOV rcc @arg1mul
LSHIFT rcc rg3
ADD rcx rcc

apres:

NONZERO @arg2mul
JMP 'finMult

MOV rac $1
RSHIFT @arg2mul rac
ADD @arg3mul rac

JMP 'mult

finMult:
JMP rrt



# ajoute aussi son temps d'execution a @compteur
divisiblePar25:
MOV rac x$ffe0
MOV rbc @arg1
AND rbc rac
NONZERO rbc
JMP 'plusPetitQue32

ADD @compteur $11
MOV rbc $1

MOV rcc @arg1
AND rcc rbc  # rcc: dernier chiffre de arg1

RSHIFT @arg1 rbc

NONZERO rcc
JMP 'divisiblePar25

ADD @arg1 $13
ADD @compteur $2
JMP 'divisiblePar25

plusPetitQue32:
ADD @compteur $11
NONZERO @arg1
JMP 'ouiCestDivisiblePar25

MOV rac $25
SUB @arg1 rac
ADD @compteur $4
NONZERO @arg1
JMP 'ouiCestDivisiblePar25

ADD @compteur $1
MOV @valDeRetour $0
JMP 'finDivisiblePar25

ouiCestDivisiblePar25:
MOV @valDeRetour $1

finDivisiblePar25:
JMP rrt


# ajoute aussi son temps d'execution a @compteur
anneeBissextile:
# 100 = 2*2*25
# 400 = 2*2*2*2*25
ADD @compteur $10
MOV rac b$1111
MOV rbc b$11

MOV rcc @annee
AND rcc rac

NONZERO rcc
JMP 'ouiCestBissextile  # c'est divisible par 16 donc ok


MOV rcc @annee
AND rcc rbc
ADD @compteur $3

NONZERO rcc
JMP 'peutEtreBissextile

MOV @valDeRetour $0  # non divisible par 4 => non bissextile
ADD @compteur $2
JMP 'finAnneeBissextile

peutEtreBissextile:
ADD @compteur $7
MOV @arg1 @annee
MOV rbp rrt
MOV rrt 'finDivisiblePar25->aBici
JMP 'divisiblePar25
aBici:
MOV rrt rbp
NONZERO rcx
JMP 'ouiCestBissextileMaisFautAjouterDesTrucs # non divisible par 25 => non divisible par 100

ADD @compteur $2
MOV @valDeRetour $0  # divisible par 25 et par 4 => divisible par 100
# mais non divisible par 8 => non divisible par 400
JMP 'finAnneeBissextile


ouiCestBissextile:
MOV @valDeRetour $1
finAnneeBissextile:
JMP rrt

ouiCestBissextileMaisFautAjouterDesTrucs:
ADD @compteur $3
JMP 'ouiCestBissextile


### DIV BY 100

% a = rg1
% c = rcc
% d = rdc


division100:
ADD @compteur $27
MOV rac $2
MOV rbc $123
MOV rec $17
MOV rfc $20
MOV rbp $8

MOV @c @a
RSHIFT @a rac

MOV rsp @a
MUL rsp rbc

MUL @a rfc
LSHIFT @a rbp
ADD @a rsp

RSHIFT @a rec

MOV @d @a
MOV rg2 @d

LSHIFT @d rac
MOV @a @d
RSHIFT @d rac

ADD @a @d

MOV @d @a
LSHIFT @d rac

ADD @a @d

LSHIFT @a rac

SUB @c @a

MOV rg3 @c
finDivision100:
JMP rrt

### DIV BY 5

division5:
ADD @compteur $12
MOV rac $205
MOV rbc $204
MOV rec $18
MOV rdc $8

MOV @c @a

MUL @c rbc
LSHIFT @c rdc

MUL @a rac
ADD @a @c

RSHIFT @a rec

finDivision5:
JMP rrt

### DIV BY 7


division7:
ADD @compteur $28
MOV rac $1
MOV rbc $147
MOV rec $16
MOV rfc $36
MOV rbp $8

MOV @d @a

MOV rsp @d
MUL rsp rbc

MUL @d rfc
LSHIFT @d rbp
ADD @d rsp

MOV @c @d
RSHIFT @c rec
MOV @d @a
SUB @d @c
RSHIFT @d rac

ADD @d @c
MOV @c @d

MOV rac $2
RSHIFT @c rac
MOV @d @c
MOV rac $3
LSHIFT @d rac

SUB @d @c
SUB @a @d
MOV @c @a

finDivision7:
JMP rrt




fin:









.data
13 # jour
1 # mois
2025 # annee
23 # heure
59 # minutes
57 # secondes

1000 # nombre de tours par seconde



