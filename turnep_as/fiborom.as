

MOV rdx $1  # tout ça juste pour lire le premier element de la rom et le mettre dans rdx
MOV r1x $31
LSHIFT rdx r1x
LOAD rdx rdx

MOV  rbx $0
MOV  rcx $1

MOV  r2x $1

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


