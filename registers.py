from lib_carotte import *
from utils import *

class Registers:
    def __init__(self, n, nuage, wdata, reg_size = 32):
        self.registers = [
            Reg(
                Mux(nuage.wenable, giga_mux(nuage.raddr1,     
                self.get_reg_muxlist(n, nuage, wdata, reg_size, i)), Defer(32, lambda: self.registers[i]))
            ) for i in range(n)]
        
    def get_reg_muxlist(self, n, nuage, wdata, reg_size, i):
        lst = []

        for j in range(n):
            if j == i:
                lst.append(wdata)
            else:
                lst.append(Defer(reg_size, lambda: self.registers[i]))
        return lst

    def select_register(self, id):
        return giga_mux(id, self.registers)

    def register_hub(self, raddr1, raddr2):
        rdata1, rdata2 = self.select_register(raddr1), self.select_register(raddr2)
        return rdata1, rdata2

def snd(a, b):
    return b


