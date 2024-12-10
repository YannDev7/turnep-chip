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

def build(tr, a, pos):
    # build next if 1 and if 0
    # mux (if i-th bit is 1)
    #   go to if 1
    # else go to if 0
    if not isinstance(tr, list):
        # base case
        if tr == "ADD":
            # todo: call function ADD etc
            e = n_adder()
            pass
        #...

        return
    
    if0 = build(tr[0], a, pos + 1)
    if1 = build(tr[1], a, pos + 1)

    return Mux(a[pos], if1, if0)