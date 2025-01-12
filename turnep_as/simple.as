MOV rdx $9
fibo:
MOV rax $0
ADD rdx $1
NONZERO rax
JMP   'end
JMP   'fibo
MOV rax $72
end:

.data






