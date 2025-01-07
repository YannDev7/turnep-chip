from lib_carotte import *
from utils import *
from alu import *
from registers import *
from alu import *
from selector import *

"""
Conventions:
a[0] is the MOST significant bit
Mux(c, a, b): if c: a
              else: b
"""


def main():
    allow_ribbon_logic_operations(True)
    #add(Constant("1"),Constant("1")).set_as_output("raah")
    #giga_mux(Input(1), [add(Constant("01"),Constant("01")), sub(Constant("01"),Constant("01"))]).set_as_output("ouiii")
    alu = ALU()

    selector = Selector()

    nuageline = selector.select(Constant("1100"))

    #niquetamerejoeinit_reg = [Constant("1" * 32) for i in range(2)]
    registers = Registers(2, nuageline, alu.alu_hub(
        Defer(32, lambda: registers.select_register(nuageline.raddr1)),
        Defer(32, lambda: registers.select_register(nuageline.raddr2)),
        nuageline.op
        ))

    alu.alu_hub(*registers.register_hub(nuageline.raddr1, nuageline.raddr2), nuageline.op)

    [r.set_as_output(f"Register{i}") for (i, r) in enumerate(registers.registers)]

