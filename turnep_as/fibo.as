

LOAD  rdx $15
LOAD  rbx $0
LOAD  rcx $1

LOAD  r2x $1

fibo:
MOV   r1x rcx
ADD   rcx rbx
MOV   rbx r1x
MOV   rax rcx
SUB   rdx r2x
NONZERO rdx
JMP   'end
JMP   'fibo

end:

.data



