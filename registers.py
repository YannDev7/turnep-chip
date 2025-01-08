from lib_carotte import *
from utils import *

class Registers:
    def __init__(self, n, nuage, wdata, reg_size = 32):
        wdata.set_as_output("wdata")
        self.registers = [
            Reg(
                Mux(nuage.wenable, self.get_reg_mux(nuage, wdata, reg_size, i), Defer(32, lambda: self.registers[i]))
            ) for i in range(n)]
    
    def get_reg_mux(self, nuage, wdata, reg_size, i):
        var = bin(i)[2:].zfill(8)
        print(var)

        gigor = giga_or(listifier(Xor(Constant(var), nuage.raddr1)))
        print(gigor.bus_size)
        return Mux(gigor, Defer(32, lambda: self.registers[i]), wdata)

    def get_reg_muxlist(self, n, nuage, wdata, reg_size, i):
        assert False
        lst = []

        for j in range(n):
            if j == i:
                lst.append(wdata)
            else:
                lst.append(Defer(reg_size, lambda: self.registers[i]))
        return lst
    count = 1
    def select_register(self, id):
        v = giga_mux(id, self.registers)
        v.set_as_output(f"reg{self.count}")
        self.count += 1
        return v
    def register_hub(self, raddr1, raddr2):
        rdata1, rdata2 = self.select_register(raddr1), self.select_register(raddr2)
        return rdata1, rdata2

def snd(a, b):
    return b


