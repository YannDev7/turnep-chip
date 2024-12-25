

LOAD r1x $10
LOAD rax $1

loop:
ADD  rax $1
MOV  rbx r1x
SUB  rbx rax
NONZERO rbx
JMP 'end
JMP 'loop

end:

.data



