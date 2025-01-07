from lib_carotte import *
from utils import *

class Line:
    def __init__(self, linebus):
        self.linebus = linebus
        self.instr_id = Slice(0, 1, linebus)
        self.raddr1 = Slice(1, 2, linebus)
        self.raddr2 = Slice(2, 3, linebus)
        self.op = giga_mux(self.instr_id, [Constant(str(i)) for i in range(2)])

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
        return Line(linebus)