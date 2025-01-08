from lib_carotte import *
from utils import *
from const import *

class ALU:
    def __init__(self):
        ass=42

    """
    input: bits a,b and c
    computes a+b+c
    returns (sum, carry)
    """
    def full_adder(self, a, b, c):
        tmp = a ^ b
        return (tmp ^ c, (tmp & c) | (a & b))

    """
    input: buses a,b and carry c (optionnal)
    computes a+b+c
    returns (sum, carry)
    """
    def n_adder(self, a, b, c = Constant("0")):
        assert(a.bus_size == b.bus_size)

        (s, c) = self.full_adder(a[a.bus_size - 1], b[a.bus_size - 1], c)
        for i in range(a.bus_size - 2, -1, -1):
            (s_i, c) = self.full_adder(a[i], b[i], c)
            s = s_i + s
        return (s, c)

    def carry_lookahead_adder(self, a, b, c=Constant("0")): #plus petite profondeur (probablement ? En théorie c'est O(logn)) mais plus lent à simuler donc juste pour marquer sur le rapport
        assert a.bus_size == b.bus_size
        creeret = [And(a[i], b[i]) for i in range(a.bus_size)]
        propret = [Xor(a[i], b[i]) for i in range(a.bus_size)]
        def propagee(i, j): #il faut j>i, dit si la retenue éventuelle en j a été propagée jusqu'en i-1
            return giga_and(concatlst([propret[i:j]]))
        clst = [] #liste des retenues (sauf celle de la sortie)
        for i in range(a.bus_size-1):
            clst.append(giga_xor(concatlst([And(propagee(i+1, j), creeret[j]) for j in range(i+2, a.bus_size-1)] +[creeret[i+1], And(propagee(i+1, a.bus_size), c)])))
        clst.append(c)
        sortie = Xor(Xor(concatlst(clst), a), b)
        csortie = giga_xor(concatlst([And(propagee(0, j), creeret[j]) for j in range(1, a.bus_size-1)]+[creeret[0], And(propagee(0, a.bus_size), c)])) #pourrait aussi être un or
        return (sortie, csortie)

    def several_adder(self, lst): #profondeur O(logn+logm) pour ajouter m nombres de taille n; ne sort pas, ne prend pas de retenue
        m = len(lst)
        n = lst[0].bus_size
        return self._several_adder([[lst[i][j] for i in range(m)] for j in range(n)])

    def _several_adder(self, lst2):
        if len(lst2[0]) == 2:
            return self.carry_lookahead_adder(concatlst([lst2[i][0] for i in range(len(lst2))]), concatlst([lst2[i][1] for i in range(len(lst2))]))
        nbtruples, reste = divmod(len(lst2[0]), 3)
        suivants = [list() for _ in range(len(lst2))]
        for i in range(nbtruples):
            s, c = self.full_adder(lst2[0][3*i], lst2[0][3*i+1], lst2[0][3*i+2])
            suivants[0].append(s)
        suivants[0] += lst2[0][len(lst2[0])-reste:]
        for j in range(1, len(lst2)):
            for i in range(nbtruples):
                s, c = self.full_adder(lst2[j][3*i], lst2[j][3*i+1], lst2[j][3*i+2])
                suivants[j].append(s)
                suivants[j-1].append(c)
            suivants[j] += lst2[j][len(lst2[0])-reste:]
        suivants[-1] += [Constant("0") for _ in range(nbtruples)]
        return self._several_adder(suivants)

    """
    input: buses a, b
    returns a <- a + b
    """
    def add(self, a, b, nuage = None):
        s, c = self.n_adder(a, b)
        return s

    """
    input: buses a, b
    returns a <- a - b
    """
    def sub(self, a, b, nuage = None):
        s = Not(b)
        s, c = self.n_adder(a, s, Constant("1"))
        return s
    
    def mov(self, a, b, nuage = None):
        return b
    
    def mov_imm(self, a, b, nuage):
        return nuage.imm
    
    def load_rom(self, a, b, nuage):
        reader = ROM(addr_size_rom, word_size_rom, Slice(32 - addr_size_rom, 32, b))
        reader.rename("rom_data")
        return Constant("0" * (32 - word_size_rom)) + reader
        
    def load_store_ram(self, a, b, nuage):
        reader = RAM(addr_size_rom, word_size_rom, b[32 - addr_size_rom:32], nuage.wenable_ram, b[32 - addr_size_rom:32], a[32 - addr_size_rom:32])
        reader.rename("ramus")
        return Constant("0" * (32 - word_size_rom)) + reader
  
    def not_(self, a, b, nuage = None):
        return Not(a)

    def lshift(self, a, b, nuage): #pas trouvé de meilleure façon de faire qu'un gros multiplexeur. Ne marche que sur du 32bits
        return Mux(giga_or(b[:26]), giga_mux(b[26:], [klshift(a, k) for k in range(32)]), Constant("0"*32))
        #derniers 6 bits suffisent à compter jusqu'à 32. Le giga_or détermine si b plus grand que 32.
    
    def rshift(self, a, b, nuage):
        return Mux(giga_or(b[:26]), giga_mux(b[26:], [krshift(a, k) for k in range(32)]), Constant("0"*32))

    def mul(self, a, b, nuage): #profondeur O((logn)^2)
        def giga_adder(lst):
            if len(lst) == 1:
                return lst[0]
            return self.n_adder(giga_adder(lst[:len(lst) // 2]), giga_adder(lst[len(lst) // 2:]))[0]
        return giga_adder([klshift(And(a, b[k]), k) for k in range(32)])
    
    def mul2(self, a, b, nuage): #profondeur O(logn)
        return self.several_adder([klshift(And(a, b[k]), k) for k in range(32)])

    def alu_hub(self, a, b, nuage):
        funs = [self.add, self.sub, self.mov, self.mov_imm, self.not_, self.load_rom]
        vals = [f(a, b, nuage) for f in funs]
        return giga_mux(nuage.op, vals)
