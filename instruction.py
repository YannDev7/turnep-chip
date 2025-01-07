"""
Utils functions to parse instructions

parse(inst) -> renvoie la fonction alu
"""
from alu import *

# will call alu
def ADD(rs1, rs2):
    pass

def SUB(rs1, rs2):
    pass

# tree[0][1][1].. = ADD 
tree = [
    [],
    [],
]

def parse(inst):
    return inst[0:22], inst[23, 27]