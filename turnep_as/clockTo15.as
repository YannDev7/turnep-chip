

LOAD r1x $15
LOAD rax $0
ADD  rax $0
ADD  rax $0
ADD  rax $5


loop:
ADD  rax $5
MOV  rbx r1x
SUB  rbx rax
NONZERO rbx
JMP 'end
JMP 'loop

end:


.data



