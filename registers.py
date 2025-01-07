from lib_carotte import *
from utils import *

class Registers:
    def __init__(self, n, init_val, reg_size = 32):
        self.registers = [Reg(init_val[i]) for i in range(n)]

    def select_register(self, id):
        return giga_mux(id, self.registers)

    def register_hub(self, raddr1, raddr2, wenable, wdata):
        return self.select_register(raddr1), self.select_register(raddr2)
