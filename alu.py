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
        reader = ROM(addr_size_rom, word_size_rom, b[32 - addr_size_rom:32])
        reader.rename("rom_data")
        return Constant("0" * (32 - word_size_rom)) + reader
        
    def load_ram(self, a, b, nuage):
        return RAM(addr_size_rom, word_size_rom, b[32 - addr_size_rom:32])
  
    def not_(self, a, b, nuage = None):
        return Not(a)

    def alu_hub(self, a, b, nuage):
        funs = [self.add, self.sub, self.mov, self.mov_imm, self.not_, self.load_rom]
        vals = [f(a, b, nuage) for f in funs]
        return giga_mux(nuage.op, vals)
