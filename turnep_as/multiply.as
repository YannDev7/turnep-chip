% arg1mul = rg1
% arg2mul = rg2
% arg3mul = rg3
% valDeRetour = rcx



MOV @arg1mul x$ffff
MOV @arg2mul $83
MOV @arg3mul $0

MOV rrt 'finMult->coucou
JMP 'mult

coucou:
MOV rdx $41242





JMP 'end


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



end:


