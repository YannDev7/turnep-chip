



% jour = r1x
% mois = r2x
% annee = r3x
% heure = r4x
% minutes = r5x
% secondes = r6x
% cycleCount = r9x

% arg1 = rax
% arg2 = rbx

% arg1mul = rax2
% arg2mul = rbx2
% valDeRetour = rcx



MOV @arg1 $8001
MOV rrt 'finDivisiblePar25->ici
JMP 'divisiblePar25

ici:


JMP 'fin

divisiblePar25:

MOV rac x$ffe0
MOV rbc @arg1
AND rbc rac
NONZERO rbc
JMP 'plusPetitQue32


MOV rbc $1

MOV rcc @arg1
AND rcc rbc  # rcc: dernier chiffre de arg1

RSHIFT @arg1 rbc

NONZERO rcc
JMP 'divisiblePar25

ADD @arg1 $13
JMP 'divisiblePar25

plusPetitQue32:

NONZERO @arg1
JMP 'ouiCestDivisiblePar25

MOV rac $25
SUB @arg1 rac
NONZERO @arg1
JMP 'ouiCestDivisiblePar25

MOV @valDeRetour $0
JMP 'finDivisiblePar25

ouiCestDivisiblePar25:
MOV @valDeRetour $1

finDivisiblePar25:
JMP rrt


fin:


