from lib_carotte import *
from utils import *
from alu import *

def main():
    allow_ribbon_logic_operations(True)
    sub(Constant("00"),Constant("00")).set_as_output("raah")
    #giga_mux(Input(1), [add(Constant("1"),Constant("1")), sub(Constant("1"),Constant("1"))]).set_as_output("ouiii")