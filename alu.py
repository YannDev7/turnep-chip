from lib_carotte import *
from utils import *

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
    def add(self, a,b):
        s, c = self.n_adder(a, b)
        dbg(s, "Add")
        return s

    """
    input: buses a, b
    returns a <- a - b
    """
    def sub(self, a, b):
        s = Not(b)
        s, c = self.n_adder(a, s, Constant("1"))
        dbg(s, "Sub")
        return s
    
    def alu_hub(self, a, b, op):
        funs = [self.add, self.sub]
        vals = [f(a, b) for f in funs]
        return giga_mux(op, vals)
