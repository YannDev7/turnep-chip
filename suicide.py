
from selector import *
from utils import *

class SuicideHub:
    def __init__(self, estcequejaienviedemesuiccider, suicideimmediat, nz, imm, reg_data):
        truc = giga_or(listifier(reg_data))
        truc.set_as_output("truc")
        
        self.jmp = Mux(
            estcequejaienviedemesuiccider,
            Mux(suicideimmediat, imm,
                Mux(nz, Constant("0"*31)+truc, reg_data)
            ),
            Constant("0"*32))

