% arg1mul = rg1
% arg2mul = rg2
% arg3mul = rg3
% valDeRetour = rcx

% a = rg1
% c = rcc
% d = rdc

MOV @a $8798
MOV rrt 'finDivision100->ici
JMP 'division100

ici:
MOV rdx $232

JMP 'fin


division100:
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


fin:
ADD rac $0





