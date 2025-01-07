

MOV rdx $10
MOV rax $3
MOV r1x $1

loop:

MOV rbx rax
AND rbx r1x
NONZERO rbx
JMP 'else

# si rax impair, faire *3 +1
MOV rcx rax
ADD rax rcx
ADD rax rcx
ADD rax $1
JMP 'endelse
else:

# sinon, diviser par 2
RSHIFT rax r1x
endelse:

SUB rdx r1x
NONZERO rdx
JMP 'end
JMP 'loop

end:

.data



