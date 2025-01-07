


# entree:
# n, la taille du tableau
# n entiers (avec un signe)

# realise un quicksort dans l'ordre croissant
# les valeurs sont chargees dans la ram de l'adresse 1 a n (inclus)




LOAD rdx $1  # tout ça juste pour lire le premier element de la rom et le mettre dans rdx
LOAD r1x $31
LSHIFT rdx r1x
LOAD r1x rdx

MOV rbx rdx  # addresse de ROM
LOAD rsp $0  # addresse de RAM

romtoramloop:
ADD rsp $1

MOV rbx rdx
ADD rbx rsp

LOAD rax rbx
STORE rsp rax

MOV r2x r1x
SUB r2x rsp
NONZERO r2x
JMP 'endloop1
JMP 'romtoramloop
endloop1:

MOV rbp rsp

ADD rsp $1 # ajoute [1, n[ au stack
STORE rsp $1
ADD rsp $1
MOV rac rbp
ADD rac $1
STORE rsp rac

JMP 'quicksort




JMP 'end

quicksort:
MOV rac rsp
SUB rac rbp

NONZERO rac
JMP 'end  # la pile d'appel est vide

LOAD r2x rsp
ADD rsp X$ffff
LOAD r1x rsp
ADD rsp X$ffff

# on trie le tableau sur l'intervalle [r1x, r2x[
MOV rac r2x
SUB rac r1x

NONZERO rac  # si l'intervalle est vide, on depile un nouvel appel
JMP 'quicksort

MOV r3x r1x
MOV r4x r2x

LOAD rdx r1x  # pivot
ADD r3x $1

partitionLoop:
MOV rac r4x
SUB rac r3x
NONZERO rac
JMP 'quicksortEnd

MOV rax rdx
LOAD rbx r3x

LOAD rrt 'lesserRet->quicksortHere
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
LOAD rac r4x
STORE r4x rbx
STORE r3x rac
JMP 'partitionLoop


quicksortEnd:

LOAD rac r1x
ADD r3x X$ffff
LOAD rbc r3x
STORE r1x rbc
STORE r3x rac

ADD rsp $1
STORE rsp r1x
ADD rsp $1
STORE rsp r3x

ADD r3x $1
ADD rsp $1
STORE rsp r3x
ADD rsp $1
STORE rsp r2x

JMP 'quicksort


lesser: # compare rax et rbx. Met le resultat dans rcx, puis jump a l'addresse dans rrt
# nonzero rcx -> if a >= b: instr
LOAD rac $1
LOAD rbc $31
LSHIFT rac rbc

MOV rcx rax
SUB rcx rbx  # c = a - b
AND rcx rac  # c <> 0 ssi c < 0 ssi a < b
lesserRet:
JMP rrt


end:


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
