from lib_carotte import *
from utils import *
from alu import *


"""
Conventions:
a[0] is the MOST significant bit
Mux(c, a, b): if c: a
              else: b
"""

def main():
    allow_ribbon_logic_operations(True)
    #add(Constant("1"),Constant("1")).set_as_output("raah")
    giga_mux(Input(1), [add(Constant("1"),Constant("1")), sub(Constant("1"),Constant("1"))]).set_as_output("ouiii")
