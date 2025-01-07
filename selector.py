from lib_carotte import *
from utils import *

class NuageLine:
    def __init__(self, linebus):
        self.linebus = linebus
        self.instr_id = Slice(0, 2, linebus)
        self.raddr1 = Slice(2, 3, linebus)
        self.raddr2 = Slice(3, 4, linebus)
        print([Constant(bin(i)[2:].zfill(2)).value for i in range(4)])
        self.op = giga_mux(self.instr_id, [Constant(bin(i)[2:].zfill(2)) for i in range(4)])


        self.wenable = Constant("1")
        self.immdata = None


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