
from lib_carotte import *

def registre(raddr1: Variable,
    raddr2: Variable, wenable: Variable, wdata: Variable) -> typing.Tuple[Variable, Variable]:

    regs = [Reg()]



def main():
    allow_ribbon_logic_operations(True)
    raddr1 = Constant("0")
    wenable = Constant("1")

    rreg1 = Reg(Defer(32, lambda: reg1))
    rreg2 = Reg(Defer(32, lambda: reg2))

    reg1 = Mux(raddr1, rreg1, Mux(wenable, rreg1, rreg2))
    reg2 = Mux(raddr1, Mux(wenable, rreg1, rreg2), rreg1)

    
    rdata1 = Mux(raddr1, rreg1, rreg2)

