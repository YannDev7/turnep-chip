# Micro-processeur
### Choix de l'architecture

On choisit une architecture la plus proche possible de celle du cours. La taille d'un mot est de 32 bits.



Lecture d'instructions (depuis la rom) -> Décodage des instuctions -> ALU <-> registres.


#### Instruction Set
Les instructions supportées sont décrites ci-dessous. 
Le registre correspondant au pointeur de la rom, à partir duquel on lit les intructions, s'appelle PC. On dispose, au maximum, de 32 registres et 22 instructions différentes. Les registres sont codés en binaires, mais les instructions sont codées en unaire.

| Instruction | Encoding | Description |
|------------ | -------- | ----|
| ADD         | 1000 0000 0000 0000 0000 00  rs1 rs2 |  rs1 <- \$rs1 + \$rs2 |
| SUB         | 0100 0000 0000 0000 0000 00  rs1 rs2 |  rs1 <- \$rs1 - \$rs2 |
| XOR         | 0010 0000 0000 0000 0000 00  rs1 rs2 |  rs1 <- \$rs1 ^ \$rs2 |
| OR          | 0001 0000 0000 0000 0000 00  rs1 rs2 |  rs1 <- \$rs1 \| \$rs2 |
| AND         | 0000 1000 0000 0000 0000 00  rs1 rs2 |  rs1 <- \$rs1 & \$rs2 |
| NOT         | 0000 0100 0000 0000 0000 00  rs1 rs2 |  rs1 <- ~\$rs1 |
| LSHIFT      | 0000 0010 0000 0000 0000 00  rs1 rs2 |  rs1 <- \$rs1 << \$rs2 |
| RSHIFT      | 0000 0001 0000 0000 0000 00  rs1 rs2 |  rs1 <- \$rs1 >> \$rs2 |
| LOAD        | 0000 0000 1000 0000 0000 00  rs1 rs2 |  rs1 <- M[\$rs2]      |
| STORE       | 0000 0000 0100 0000 0000 00  rs1 rs2 |  M[\$rs1] <- \$rs2     |
| MOV         | 0000 0000 0010 0000 0000 00  rs1 rs2 |  rs1 <- \$rs2         |
| NONZERO     | 0000 0000 0001 0000 0000 00  rs1 rs2 |  if \$rs1 <> 0 then PC += 1  |
| JMP         | 0000 0000 0000 1000 0000 00  rs1 rs2 |  PC += \$rs1 |

Nous prévoyons d'éventuellement ajouter les instructions suivantes (bien qu'elles ne soient pas nécessaires à la réalisation d'une horloge).
| Instruction | Encoding | Description |
|-------------|---------| -- |
| MUL       | 0000 0000 0000 0100 0000 00  rs1 rs2 |  rs1 <- \$rs1 * \$rs2 |
| EQ        | 0000 0000 0000 0010 0000 00  rs1 rs2 |  if \$rs1 = \$rs2 then PC += 1  |
| NEQ       | 0000 0000 0000 0001 0000 00  rs1 rs2 |  if \$rs1 <> \$rs2 then PC += 1  |
| GTE       | 0000 0000 0000 0000 1000 00  rs1 rs2 |  if \$rs1 >= \$rs2 then PC += 1  |
| LT        | 0000 0000 0000 0000 0100 00  rs1 rs2 |  if \$rs1 < \$rs2 then PC += 1  |
| POPCOUNT  | 0000 0000 0000 0000 0010 00  rs1 rs2 |  rs1 <- nombre de bits à 1 de $rs2  |
| DIV       | 0000 0000 0000 0000 0001 00  rs1 rs2 |  rs1 <- \$rs1 / \$rs2; rr <- \$rs1 % \$rs2 |



Cela fait au total 20 instructions, on a donc 2 places disponibles pour en ajouter de nouvelles.

