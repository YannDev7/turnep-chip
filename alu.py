import carotte
from carotte.lib_carotte import *

def full_adder(a: Variable, b: Variable, c: Variable) -> typing.Tuple[Variable, Variable]:
    tmp = a ^ b
    return (tmp ^ c, (tmp & c) | (a & b))