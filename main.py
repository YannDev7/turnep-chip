from lib_carotte import *
from utils import *
from alu import *
from registers import *
from alu import *
from selector import *
from const import *
from suicide import *
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

    suicidehub = SuicideHub(
        Defer(1, lambda: nuage.estcequejaienviedemesuiccider),
        Defer(1, lambda: nuage.suicideimmediat),
        Defer(1, lambda: nuage.nz),
        Defer(32, lambda: nuage.imm),

        Defer(32, lambda: registers.select_register(nuage.raddr1))
        )

    inst_ptr = Defer(32, lambda: inst_ptr)
    inst_ptr = Reg(alu.add(inst_ptr, Defer(32, lambda: alu.add(suicidehub.jmp, Constant("0"*31 + "1")))))
    inst_ptr.set_as_output("coucou")

    """
        Note: 
            the ROM is stored in rom.db
            there is only one ROM (could be more)
    """
    reader = ROM(addr_size_rom, word_size_rom, inst_ptr[16:32])
    reader.set_as_output("rom_code")

    nuage = NuageLine(reader)
    #nuageline = selector.select(Constant("1111"))
    #niquetamerejoeinit_reg = [Constant("1" * 32) for i in range(2)]
    registers = None
    nomme_le_ta_mere = alu.alu_hub(
        Defer(32, lambda: registers.select_register(nuage.raddr1)),
        Defer(32, lambda: registers.select_register(nuage.raddr2)),
        nuage
    )

    registers = Registers(32, nuage, nomme_le_ta_mere)

    nuage.raddr1.set_as_output("raddr1")
    nuage.raddr2.set_as_output("raddr2")


    print(nuage)

    [r.set_as_output(f"Register{i}") for (i, r) in enumerate(registers.registers)]

