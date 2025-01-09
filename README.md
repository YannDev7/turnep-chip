# Micro-processeur
### Choix de l'architecture

On choisit une architecture la plus proche possible de celle du cours. La taille d'un mot est de 32 bits.



Lecture d'instructions (depuis la rom) -> Décodage des instuctions -> ALU <-> registres.


#### Instruction Set
Les instructions supportées sont décrites ci-dessous. 
Le registre correspondant au pointeur de la rom, à partir duquel on lit les intructions, s'appelle PC. Les registres sont stockés en sur 8 bits, et les instructions aussi. Pour les instructions qui acceptent des imm, cette valeur est codée sur 16 bits.

| Instruction | Encoding | Description |
|------------ | -------- | ----|
| ADD         | 01 rs1 rs2 00 |  rs1 <- \$rs1 + \$rs2  |
| SUB         | 02 rs1 rs2 00 |  rs1 <- \$rs1 - \$rs2  |
| XOR         | 03 rs1 rs2 00 |  rs1 <- \$rs1 ^ \$rs2  |
| OR          | 04 rs1 rs2 00 |  rs1 <- \$rs1 \| \$rs2 |
| AND         | 05 rs1 rs2 00 |  rs1 <- \$rs1 & \$rs2  |
| ADDIMM      | 45 rs1 imm    |  rs1 <- imm + \$rs1    |
| NOT         | 06 rs1 rs2 00 |  rs1 <- ~\$rs2         |
| LSHIFT      | 07 rs1 rs2 00 |  rs1 <- \$rs1 << \$rs2 |
| RSHIFT      | 08 rs1 rs2 00 |  rs1 <- \$rs1 >> \$rs2 |
| LOADROM     | 09 rs1 rs2 00 |  rs1 <- M[\$rs2]       |
| LOADRAM     | 14 rs1 rs2 00 |  rs1 <- M[\$rs2]       |
| MOVIMM      | 49 rs1 imm    |  rs1 <- imm            |
| STORE       | 2A rs1 rs2 00 |  M[\$rs2] <- \$rs1     |
| MOV         | 0B rs1 rs2 00 |  rs1 <- \$rs2          |
| NONZERO     | 82 rs1 00  00 |  if \$rs1 <> 0 then PC += 1  |
| JMP         | 80 rs1 00  00 |  PC += \$rs1           |
| JMPIMM      | 81 00  imm    |  PC += imm             |


Nous prévoyons d'éventuellement ajouter les instructions suivantes (bien qu'elles ne soient pas nécessaires à la réalisation d'une horloge).
| Instruction | Encoding      | Description                  | 
|-------------|---------------| ---------------------------- |
| MUL         | 0D rs1 rs2 00 |  rs1 <- \$rs1 * \$rs2 |
| EQ          | 0E rs1 rs2 00 |  if \$rs1 = \$rs2 then PC += 1  |
| NEQ         | 0F rs1 rs2 00 |  if \$rs1 <> \$rs2 then PC += 1  |
| GTE         | 10 rs1 rs2 00 |  if \$rs1 >= \$rs2 then PC += 1  |
| LT          | 11 rs1 rs2 00 |  if \$rs1 < \$rs2 then PC += 1  |
| POPCOUNT    | 12 rs1 rs2 00 |  rs1 <- nombre de bits à 1 de $rs2  |
| DIV         | 13 rs1 rs2 00 |  rs1 <- \$rs1 / \$rs2; rr <- \$rs1 % \$rs2 |



Cela fait au total 20 instructions, on a donc 2 places disponibles pour en ajouter de nouvelles.

