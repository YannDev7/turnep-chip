

LOAD rdx $1  # tout ça juste pour lire le premier element de la rom et le mettre dans rdx
LOAD r1x $31
LSHIFT rdx r1x
LOAD rdx rdx

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
20


