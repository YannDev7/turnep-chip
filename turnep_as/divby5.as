% arg1mul = rg1
% arg2mul = rg2
% arg3mul = rg3
% valDeRetour = rcx

% a = rg1
% c = rcc
% d = rdc

MOV @a $7504
MOV rrt 'finDivision5->ici

JMP 'division5
ici:
JMP 'fin

division5:
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


fin:

