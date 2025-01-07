


MOV rax $19
MOV rbx $20


truc:

MOV rrt 'lesserRet->here1
JMP 'lesser
here1:
MOV rax $800

MOV rrt 'lesserRet->here2
JMP 'lesser
here2:
NONZERO rcx
MOV rbx $4242

JMP 'end


lesser:
MOV rac $1
MOV rbc $31
LSHIFT rac rbc

MOV rcx rax
SUB rcx rbx  # c = a - b
AND rcx rac  # c <> 0 ssi c < 0 ssi a < b
lesserRet:
JMP rrt



end:





