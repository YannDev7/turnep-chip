from lib_carotte import *

"""
Builds a MUX of size n

selec: the input bus we select from
ls is the list of leaves

Example:
giga_mux(Input(1), [add(Constant("1"),Constant("1")), sub(Constant("1"),Constant("1"))]).set_as_output("ouiii")

if input is 0, it will go to the add
else go to the sub
"""

def giga_mux(selec, ls):
    po = 1
    while po < len(ls):
        po *= 2

    while len(ls) < po:
        ls.append(Constant("0" * ls[0].bus_size))

    for x in ls:
        print(x.bus_size)
    return giga_mux_aux(selec, 0, ls)

def giga_mux_aux(selec, pos, ls):
    if len(ls) == 1:
        return ls[0]
    
    if0 = giga_mux_aux(selec, pos + 1, ls[0:len(ls) // 2])
    if1 = giga_mux_aux(selec, pos + 1, ls[(len(ls) // 2):])

    return Mux(selec[pos], if1, if0)

def giga_op(op): #Prend une opération associative, donne la fonction qui applique cette opération sur tout un bus
    def giga_int(lst):
        if len(lst) == 1:
            return lst[0]
        return op(giga_int(lst[:len(lst) // 2]), giga_int(lst[len(lst) // 2:]))
    return giga_int
giga_or = giga_op(Or)
giga_and = giga_op(And)
giga_xor = giga_op(Xor)

def klshift(a, k):
    if k == 0:
        return a
    return a[k:]+Constant("0"*k)

def krshift(a, k):
    if k == 0:
        return a
    return Constant("0"*k)+a[:32-k]

def concatlst(lst):
    b = lst[0]
    for i in lst[i:]:
        b += i
    return b

def listifier(bus):
    return [bus[i] for i in range(bus.bus_size)]

def dbg(gate, msg):
    tmp = Reg(gate)
    tmp.set_as_output(eval("msg"))