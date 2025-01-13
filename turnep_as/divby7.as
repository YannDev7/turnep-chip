% arg1mul = rg1
% arg2mul = rg2
% arg3mul = rg3
% valDeRetour = rcx

% a = rg1
% c = rcc
% d = rdc

MOV @a $7004
MOV rrt 'finDivision7->ici
JMP 'division7

ici:
MOV rdx $232

JMP 'fin


division7:
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
ADD rac $0










