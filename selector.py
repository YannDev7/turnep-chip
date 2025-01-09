from lib_carotte import *
from utils import *

class NuageLine:
    def __init__(self, linebus):
        self.linebus = linebus
        self.instr_id = Slice(0, 8, linebus)
        self.instr_id.set_as_output("instr_id")
        self.raddr1 = Slice(8, 16, linebus)
        self.raddr2 = Slice(16, 24, linebus)
        imm16 = Slice(16,32, linebus)
        self.imm = Mux(imm16[0], Constant("1"*16), Constant("0"*16)) + imm16
        #self.op = giga_mux(self.instr_id, [Constant(bin(i)[2:].zfill(8)) for i in range(256)])
        self.op = self.instr_id
        self.wenable = Constant("1")
        self.wenable_ram = Constant("0")
        self.waddr = None
        self.estcequejaienviedemesuiccider = self.instr_id[0]
        self.suicideimmediat = self.instr_id[7]
        self.nz = self.instr_id[6]
        self.nz.set_as_output("nz")

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