

MOV  rdx $15
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










