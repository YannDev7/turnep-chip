from lib_carotte import *
from utils import *
from alu import *

def main():
    giga_mux(Input(1), [add(Constant("1"),Constant("1")), sub(Constant("1"),Constant("1"))]).set_as_output("ouiii")