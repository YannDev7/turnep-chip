


# entree:
# n, la taille du tableau
# n entiers (avec un signe)

# realise un quicksort dans l'ordre croissant
# les valeurs sont chargees dans la ram de l'adresse 1 a n (inclus)



MOV rdx $0
LOADROM r1x rdx

MOV rsp $0  # addresse de RAM

romtoramloop:
ADD rsp $1

LOADROM rax rsp
STORE rax rsp

MOV r2x r1x
SUB r2x rsp
NONZERO r2x
JMP 'endloop1
JMP 'romtoramloop
endloop1:

MOV rbp rsp

ADD rsp $1 # ajoute [1, n[ au stack
MOV rdc $1
STORE rdc rsp
ADD rsp $1
MOV rac rbp
ADD rac $1
STORE rac rsp

JMP 'quicksort




JMP 'end

quicksort:
MOV rac rsp
SUB rac rbp

NONZERO rac
JMP 'end  # la pile d'appel est vide

LOADRAM r2x rsp
ADD rsp X$ffff
LOADRAM r1x rsp
ADD rsp X$ffff

# on trie le tableau sur l'intervalle [r1x, r2x[
MOV rac r2x
SUB rac r1x

NONZERO rac  # si l'intervalle est vide, on depile un nouvel appel
JMP 'quicksort

MOV r3x r1x
MOV r4x r2x

LOADRAM rdx r1x  # pivot
ADD r3x $1

partitionLoop:
MOV rac r4x
SUB rac r3x
NONZERO rac
JMP 'quicksortEnd

MOV rax rdx
LOADRAM rbx r3x

MOV rrt 'lesserRet->quicksortHere
JMP 'lesser
quicksortHere:

NONZERO rcx
JMP 'smallerThanPivot
JMP 'greaterThanPivot


smallerThanPivot:
ADD r3x $1
JMP 'partitionLoop

greaterThanPivot:
ADD r4x x$ffff
LOADRAM rac r4x
STORE rbx r4x
STORE rac r3x
JMP 'partitionLoop


quicksortEnd:

LOADRAM rac r1x
ADD r3x X$ffff
LOADRAM rbc r3x
STORE rbc r1x
STORE rac r3x

ADD rsp $1
STORE r1x rsp
ADD rsp $1
STORE r3x rsp

ADD r3x $1
ADD rsp $1
STORE r3x rsp
ADD rsp $1
STORE r2x rsp

JMP 'quicksort


lesser: # compare rax et rbx. Met le resultat dans rcx, puis jump a l'addresse dans rrt
# nonzero rcx -> if a >= b: instr
MOV rac $1
MOV rbc $31
LSHIFT rac rbc

MOV rcx rax
SUB rcx rbx  # c = a - b
AND rcx rac  # c <> 0 ssi c < 0 ssi a < b
lesserRet:
JMP rrt


end:

MOV rac $19
LOADRAM r1x rac
MOV rac $21
LOADRAM r2x rac
MOV rac $22
LOADRAM r3x rac
MOV rac $23
LOADRAM r4x rac
MOV rac $24
LOADRAM r5x rac
MOV rac $25
LOADRAM r6x rac
MOV rac $26
LOADRAM r7x rac




.data
60

13
51
4294967042
4294967052
52
4294967044
51
19
2
52
4294967047
52
9
1
54
54
54
17
5
6
0
7
4294967050
4294967054
4294967058
10
4294967043
4294967049
4294967059
8
50
4294967046
4294967041
53
12
4294967055
53
11
50
50
3
50
18
4294967045
15
4294967057
4
51
51
4294967056
4294967048
4294967053
4294967051
16
4294967040
14
52
54
53
53
