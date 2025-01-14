
% arg1 = rax
% valDeRetour = rcx


# rrt qui sert par convention a stocker le point de code
# de retour de la fonction

# pour appeler la fonction foo, on fait les operations 
# suivantes:

MOV @arg1 $31
MOV rrt 'finFoo->ici
JMP 'foo
ici:
MOV rdx @valDeRetour


JMP 'finProgramme

foo:
# code de la fonction
ADD @valDeRetour @arg1
finFoo:
JMP rrt


finProgramme:
ADD rax $0  # padding

.data



78686866
Xffff
B010101010


