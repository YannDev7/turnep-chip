from lib_carotte import *
from utils import *

class NuageLine:
    def __init__(self, linebus):
        self.linebus = linebus
        self.instr_id = Slice(0, 3, linebus)
        self.raddr1 = Slice(3, 4, linebus)
        self.raddr2 = Slice(4, 5, linebus)
        self.imm = Constant("0" * 30) + Slice(4, 6, linebus)
        
        print([Constant(bin(i)[2:].zfill(3)).value for i in range(8)])
        self.op = giga_mux(self.instr_id, [Constant(bin(i)[2:].zfill(3)) for i in range(8)])

        self.wenable = Constant("1")


class Selector:
    def __init__(self):
        pass

    """
        Note: Slice is end excluded

        Temporarly:

        instructions supported:
            ADD (0)
            SUB (1)

        (instr id) (raddr1) (raddr2)
    """
    def select(self, linebus: Variable):
        return NuageLine(linebus)