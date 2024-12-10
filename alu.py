import carotte
from carotte.lib_carotte import *

"""
Convention: a[0] is the lsb
"""

"""
input: bits a,b and c
computes a+b+c
returns (sum, carry)
"""
def full_adder(a, b, c):
    tmp = a ^ b
    return (tmp ^ c, (tmp & c) | (a & b))

"""
input: buses a,b and carry c (optionnal)
computes a+b+c
returns (sum, carry)
"""
def n_adder(a, b, c = Constant("0")):
    assert(a.bus_size == b.bus_size)

    (s, c) = full_adder(a[0], b[0], c)
    for i in range(1, a.bus_size):
        (s_i, c) = full_adder(a[i], b[i], c)
        s = s + s_i
    return (s, c)

"""
input: bus b
returns ~b
"""
def _not(b):
    assert(a.bus_size == b.bus_size)
    if b[0] == 1:
        a = Constant("0")
    else:
        a = Constant("1")
    for i in range(1,b.bus_size):
        if b == 1:
            a = a + Constant("0")
        else:
            a = a + Constant("1")

"""
input: buses a, b
returns a <- a - b
"""
def sub(a,b):
    s = Not(b)
    return  n_adder(a, s, c=Constant("1"))
