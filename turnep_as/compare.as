


LOAD rax $19
LOAD rbx $20


truc:

LOAD rrt 'lesserRet->here1
JMP 'lesser
here1:
LOAD rax $800

LOAD rrt 'lesserRet->here2
JMP 'lesser
here2:
NONZERO rcx
LOAD rbx $4242

JMP 'end


lesser:
LOAD rac $1
LOAD rbc $31
LSHIFT rac rbc

MOV rcx rax
SUB rcx rbx  # c = a - b
AND rcx rac  # c <> 0 ssi c < 0 ssi a < b
lesserRet:
JMP rrt



end:





