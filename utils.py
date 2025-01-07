#from carotte.lib_carotte import *
from alu import *

"""
Builds a MUX of size n

selec: the input bus we select from
ls is the list of leaves
"""

def giga_mux(selec, ls):
    po = 1
    while po < len(ls):
        po *= 2

    while len(ls) < po:
        ls.append(Constant("0"))

    return giga_mux_aux(selec, 0, ls)

def giga_mux_aux(selec, pos, ls):
    if len(ls) == 1:
        return ls[0]
    
    if0 = giga_mux_aux(selec, pos + 1, ls[0:len(ls) // 2])
    if1 = giga_mux_aux(selec, pos + 1, ls[(len(ls) // 2):])

    return Mux(selec[pos], if1, if0)
