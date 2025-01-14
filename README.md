
#  Micro-processeur

###  Choix de l'architecture

  

On choisit une architecture la plus proche possible de celle du cours. La taille d'un mot est de 32 bits.

  
  
  

Lecture d'instructions (depuis la rom) -> Décodage des instuctions -> ALU <-> registres.

  

Les accès et écritures dans la RAM ou dans la ROM se font au même endroit que l'ALU. Ainsi notre classe `Alu` est en réalité plus qu'une ALU.

  

Les fonctions proposées par l'ALU sont toutes de la forme suivante: elles prennent en entrée deux valeurs: a, b, ainsi que le "nuage" (les données issues de la selection et du décodage d'instruction). Elles renvoient une valeur en sortie.

  

Grâce à l'unité de gestion des registres, chaque registre est composé d'un cablage qui prend en entrée le nuage, et dont la sortie est connectée à une bascule D.

  

Le registre compare son adresse avec `raddr1` du nuage (qui est aussi l'adresse d'écriture). Si cette adresse est différente de la sienne ou que `wenable` est desactivé, la nouvelle valeur du registre est celle au cycle précédent. Sinon, c'est la sortie de l'alu.

  

####  Instruction Set

Les instructions supportées sont décrites ci-dessous.

Le registre correspondant au pointeur de la rom, à partir duquel on lit les intructions, s'appelle PC. Les registres sont stockés en sur 8 bits, et les instructions aussi. Pour les instructions qui acceptent des imm, cette valeur est codée sur 16 bits.

  

| Instruction | Encoding | Description |
|------------  |  -------------  |  -----------------------|
| ADD | 01 rs1 rs2 00 | rs1 <- \$rs1 + \$rs2 |
| SUB | 02 rs1 rs2 00 | rs1 <- \$rs1 - \$rs2 |
| XOR | 03 rs1 rs2 00 | rs1 <- \$rs1 ^ \$rs2 |
| OR | 04 rs1 rs2 00 | rs1 <- \$rs1 \| \$rs2 |
| AND | 05 rs1 rs2 00 | rs1 <- \$rs1 & \$rs2 |
| ADDIMM | 45 rs1 imm | rs1 <- imm + \$rs1 |
| NOT | 06 rs1 rs2 00 | rs1 <- ~\$rs2 |
| LSHIFT | 07 rs1 rs2 00 | rs1 <- \$rs1 << \$rs2 |
| RSHIFT | 08 rs1 rs2 00 | rs1 <- \$rs1 >> \$rs2 |
| LOADROM | 09 rs1 rs2 00 | rs1 <- M[\$rs2] |
| LOADRAM | 14 rs1 rs2 00 | rs1 <- M[\$rs2] |
| MOVIMM | 49 rs1 imm | rs1 <- imm |
| STORE | 2A rs1 rs2 00 | M[\$rs2] <- \$rs1 |
| MOV | 0B rs1 rs2 00 | rs1 <- \$rs2 |
| NONZERO | 82 rs1 00 00 | if \$rs1 <> 0 then PC += 1 |
| JMP | 80 rs1 00 00 | PC += \$rs1 |
| JMPIMM | 81 00 imm | PC += imm |
| MUL | 0D rs1 rs2 00 | rs1 <- \$rs1 * \$rs2 |

  

Dans la multiplication, seuls les 8 bits de poids faible de rs2 sont considérés. Cela permet de ne pas trop ralentir le processeur. Ainsi, pour réaliser une multiplication sur 16 bits, on procède en deux fois, et on a donc besoin de 4 cycles (2 mul, un shift et un add).

  

Dans notre version finale, on dispose de 45 registres.

  

Dans le bloc d'exécution d'instruction, LOADRAM et STORE sont les mêmes instructions. Cependant, on change les valeurs `wenable` et `wenable_ram` du nuage:

-  `wenable=1` et `wenable_ram=0` donne un LOADRAM.

-  `wenable=0` et `wenable_ram=1` donne un STORE.

  

###  Modulabilité du code

Le code est découpé en plusieurs fichiers:

  

- utils.py: contient des fonctions utilitaires (typiquement giga_mux, giga_or etc)

- selector.py: contient la définition du nuage (qui encapsule toutes les informations devant être passées en argument à des fonctions de l'ALU).

- registers.py: permet de créer les registres et s'occupe aussi de la sélection de registres (avec un giga_mux)

- alu.py: contient les fonctions relatives à l'ALU. En particulier, la sélection d'instruction est réalisée avec un simple giga_mux sur les fonctions proposées par l'alu.

- jumplapin.py: gère les MUX pour calculer le jump à faire à chaque cycle.

- main.py: connecte tout le circuit et gère le pointeur de code PC.

Remarque: quoi qu'il arrive, le pointeur de pile est incrémenté et NONZERO l'augmente une fois de plus.

  

Le code a été écrit de sorte à ce qu'il soit facilement modulable. Le nombre de registres, la taille des adresses etc peuvent être modifiés facilement.

  

De plus, il est aisé d'ajouter de nouvelles instructions (ajouter une ligne dans alu.py).

  

###  Assembleur

  

On a réalisé un assembleur personnalisé pour compiler un code plus lisible vers les fichiers de rom pris par le simulateur de netlist. Le code de cet assembleur est dans `turnep_as/assemble.py`. Il dispose des fonctionnalités suivantes:

  

- les immédiats peuvent être écrits en décimal, binaire ou hexadécimal.

- les instructions avec un immédiat n'ont pas besoin d'être différenciées par leur nom de leur équivalent sans immédiat, car l'assembleur détecte la signature des instructions.

- on peut étiquetter un emplacement dans le code. Lorsqu'à la place d'un immédiat on écrit `'nom_du_label`, l'assembleur calcul la différence entre la position du label et la position de la ligne actuelle. En particulier, `JMP 'nom_du_label` saute à l'instruction suivant l'étiquette `nom_du_label`.

- l'assembleur peut également faire la différence entre des positions de deux labels avec `'foo->bar`. Cela permet de faire des appels des fonctions facilement, comme le montre l'exemple `turnep_as/showcase.as`.

  

- enfin, on peut donner des noms aux registres, pour plus de lisibilité.

  

L'assembleur a 4 sorties:

- il affiche dans la console un code hexadécimal du programme qui peut être lu par l'interpréteur `turnep_as/as_interpreter.py`.

- il sauvegarde les fichiers `rom_data.db` et `rom_code.db` qui peuvent être lus par le simulateur de netlist.

- il sauvegarde un fichier `interpret.lines` qui permet d'afficher le contenu textuel d'une ligne de code lorsque l'on fait du pas à pas avec l'interpréteur.

  

##  Interpréteur

  

On dispose également d'un interpréteur pour tester les programmes et les débugger. Il a permis de réaliser des tests pour le processeur (on exécutait toujours les programmes avec l'interpréteur avant de les donner au processeur, pour comparer les sorties).

  

De plus, l'interpréteur permet de faire du pas à pas et d'explorer le contenu de la RAM.

  
  

###  Clock

  

La clock supporte les années bissextiles, les changements d'heure et calcule le jour de la semaine à partir de la date.

  

La clock a dans ses entrées (dans son segement de donnée) une valeur qui donne la correspondance entre un nombre de cycles et une seconde. Notre idée était de considérer qu'un cycle prend toujours le même temps, et de compter les secondes à partir de cela.

  

Une difficulté du code est donc de garder en mémoire le nombre d'instructions que l'on a exécuté depuis le début de la seconde. Cette valeur est gardée dans le registre renommé `@compteur`, et est modifiée régulièrement au cours d'une seconde.

  

Le code est construit de manière à garantir le plus souvent possible que le temps d'exécution d'un bloc de code ne dépende pas des conditions. Ce n'est cependant pas toujours le cas, car le code utilise des fonctions récursives terminales, qui ont donc besoin d'un temps d'exécution qui dépend de l'entrée. Dans le code de ces fonctions, on a des instructions qui augmentent au fur et à mesure de l'exécution la valeur de `@compteur`.

  

On découpe une seconde en plusieurs étapes:

- dans un premier temps on veut calculer le nombre de jours dans le mois actuel. Pour cela, on détermine si l'année est bissextile. Dans le calendrier grégorien, une année est bissextile si elle est divisible par 16, ou par 4 mais pas par 25.

- La divisibilité par 16 ou 4 est simple à calculer avec des masques de bits.

- Pour la divisibilité par 25, on a une méthode sans multiplication qui fonctionne avec une fonction récursive terminale. Le temps d'exécution est logarithmique en la valeur de l'année. Elle repose sur un critère de divisibilité. Soit c un bit seul. Si l'année s'écrit sous la forme `2a + c`, alors elle est divisible par 25 ssi `a + 13c` est divisible par 25.

- Cette fonction ajoute également son temps d'exécution à `@compteur`. 
- Cette fonction est plus ancienne que l'implémentation de l'instruction MUL. La méthode employée pour les changements d'heure serait plus efficace, mais cette fonction a le mérite de fonctionner même quand l'année est plus grande que `2**16`. Ainsi, pour des années trop grandes, le jour de la semaine n'est plus correct, et les changements d'heure ne sont plus faits. Cependant, le reste de la clock fonctionne toujours.

  

- Dans un deuxième temps, on calcule la date à la prochaine seconde, sans prendre en compte le changement d'heure.

  

- Puis, on calcule le jour de la semaine pour la nouvelle date. On utilise pour cela la congruence de Zeller, qui répond à la question en utilisant uniquement des additions, des multiplications par 13, des divisions par 5 et 100, et des modulos par 7 et 100. L'opération MUL est implémentée dans notre architecture, mais pas la division. Néanmoins, on doit uniquement réaliser des divisions par des constantes connues à la compilation. Plusieurs algorithmes permettent de les faire efficacement grâce à un précalcul, en utilisant alors uniquement des multiplications et des shift.

  

- On s'est aidé du compilateur gcc pour trouver les opérations à réaliser, car celui-ci optimise les divisions dans ce genre de situation.

  

- Ensuite, une chaîne de comparaisons et de conditions permettent de gérer les changements d'heure. Les changements d'heure se font les derniers dimanches d'octobre et mars. Lors du passage de l'heure d'été à l'heure d'hiver, il est 2h du matin deux fois dans la même journée. On utilise donc un booléen `@chHeure` pour ne changer d'heure qu'une seule fois.

  

- Enfin, on fait de l'attente active jusqu'à ce qu'il nous reste plus qu'une dizaine de cycles. On met à jour la date dans les sorties à la toute fin de la seconde.

  
  

L'interpréteur a permis de confirmer que chaque seconde prend toujours le même nombre de cycles. Par exemple, en réglant le nombre de cycles par seconde à 1000, on peut vérifier que tous les 1000 cycles on se retrouve toujours exactement au même emplacement dans le code (ie, à la fin de la boucle des secondes).

  
  
  

###  Contenu supplémentaire

  

-  `turnep_as/fibo.as` suite de Fibonacci.

-  `turnep_as/compare.as` un exemple de comment on peut implémenter une fonction `lesser` avec cette architecture.

-  `turnep_as/quicksort.as` est une implémentation d'un quicksort. Il permet d'avoir un programme qui teste presque toutes les fonctionnalités du processeur d'un seul coup (y compris la ram, que l'on n'utilise pas dans le code de la clock).

-  `turnep_as/showcase.as` exemple simple.

  

###  Simulateur

  

Le simulateur est un programme qui compile la netlist vers C.

  

Quelques optimisations ont été effectuées (utilisation de pragma) pour compenser la perte de performance due à:

- la modularité du code

- le nombre de registres

- les fonctionnalités étendues de la clock

- carrotte.py

  

Idéalement, nous comptions aussi écrire un compresseur de netlist.

  

###  Fonctionnalités du proceseur

- Il supporte une multiplication efficace (la première entrée est sur 32bits, la deuxième sur 8bits)

- Il supporte un carry look ahead adder
