# Micro-processeur
### Choix de l'architecture

On choisit une architecture la plus proche possible de celle du cours. La taille d'un mot est de 32 bits.



Lecture d'instructions (depuis la rom) -> Décodage des instuctions -> ALU <-> registres.


#### Instruction Set
Les instructions supportées sont décrites ci-dessous. 
Le registre correspondant au pointeur de la rom, à partir duquel on lit les intructions, s'appelle PC. Les registres sont stockés en sur 8 bits, et les instructions aussi. Pour les instructions qui acceptent des imm, cette valeur est codée sur 16 bits.

| Instruction | Encoding | Description |
|------------ | -------- | ----|
| ADD         | 01 00 rs1 rs2 |  rs1 <- \$rs1 + \$rs2  |
| SUB         | 02 00 rs1 rs2 |  rs1 <- \$rs1 - \$rs2  |
| XOR         | 03 00 rs1 rs2 |  rs1 <- \$rs1 ^ \$rs2  |
| OR          | 04 00 rs1 rs2 |  rs1 <- \$rs1 \| \$rs2 |
| AND         | 05 00 rs1 rs2 |  rs1 <- \$rs1 & \$rs2  |
| ANDIMM      | E5 00 rs1 rs2 |  rs1 <- \$rs1 & \$rs2  |
| NOT         | 06 00 rs1 00  |  rs1 <- ~\$rs2         |
| LSHIFT      | 07 00 rs1 rs2 |  rs1 <- \$rs1 << \$rs2 |
| RSHIFT      | 08 00 rs1 rs2 |  rs1 <- \$rs1 >> \$rs2 |
| LOAD        | 09 00 rs1 rs2 |  rs1 <- M[\$rs2]       |
| LOADIMM     | E9 imm rs1    |  rs1 <- imm            |
| STORE       | 0A 00 rs1 rs2 |  M[\$rs1] <- \$rs2     |
| STOREIMM    | EA imm rs1    |  M[\$rs1] <- imm       |
| MOV         | 0B 00 rs1 rs2 |  rs1 <- \$rs2          |
| NONZERO     | 0C 00 rs1 00  |  if \$rs1 <> 0 then PC += 1  |
| JMP         | F0 00 rs1 00  |  PC += \$rs1           |
| JMPIMM      | F1 imm rs1    |  PC += \$rs1           |


Nous prévoyons d'éventuellement ajouter les instructions suivantes (bien qu'elles ne soient pas nécessaires à la réalisation d'une horloge).
| Instruction | Encoding      | Description                  | 
|-------------|---------------| ---------------------------- |
| MUL         | 0D 00 rs1 rs2 |  rs1 <- \$rs1 * \$rs2 |
| EQ          | 0E 00 rs1 rs2 |  if \$rs1 = \$rs2 then PC += 1  |
| NEQ         | 0F 00 rs1 rs2 |  if \$rs1 <> \$rs2 then PC += 1  |
| GTE         | 10 00 rs1 rs2 |  if \$rs1 >= \$rs2 then PC += 1  |
| LT          | 11 00 rs1 rs2 |  if \$rs1 < \$rs2 then PC += 1  |
| POPCOUNT    | 12 00 rs1 rs2 |  rs1 <- nombre de bits à 1 de $rs2  |
| DIV         | 13 00 rs1 rs2 |  rs1 <- \$rs1 / \$rs2; rr <- \$rs1 % \$rs2 |



Cela fait au total 20 instructions, on a donc 2 places disponibles pour en ajouter de nouvelles.

