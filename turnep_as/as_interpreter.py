

import re
from usize import *
from assemble import reg_name_to_id

class Ram:
    def __init__(self):
        self.d = dict()

    def __getitem__(self, item):
        if item not in self.d:
            self.d[item] = 0
        return self.d[item]

    def __setitem__(self, item, value):
        self.d[item] = value

memory = Ram()

def load_rom(fp):
    d = dict()
    cur_lst = None
    cur_name = None
    with open(fp) as file:
        for line in file:
            result = re.match(r"\[([a-zA-Z]*)\]", line)
            if result is not None:
                cur_name = result.groups()[0]
                cur_lst = []
                d[cur_name] = cur_lst
            elif line.replace("\n", ""):
                n = int(line.replace(" ", ""), 16)
                cur_lst.append(n)
    if "data" in d:
        for (i, value) in enumerate(d["data"]):
            memory[0x80000000 | i] = value

    return d


reg1_mask = 0xff << 16
reg2_mask = 0xff << 8
imm_mask = 0xffff
instr_mask = 0xff << 24

regs = [0] * 256
pc = 0

# instruction_set = [
#     ["ADD", REG, REG, 0x01],
#     ["SUB", REG, REG, 0X02],
#     ["XOR", REG, REG, 0X03],
#     ["OR", REG, REG, 0X04],
#     ["AND", REG, REG, 0X05],
#     ["ADD", REG, IMM, 0XE5],
#     ["NOT", REG, REG, 0X06],
#     ["LSHIFT", REG, REG, 0X07],
#     ["RSHIFT", REG, REG, 0X08],
#     ["LOAD", REG, REG, 0X09],
#     ["LOAD", REG, IMM, 0XE9],
#     ["STORE", REG, REG, 0X0A],
#     ["STORE", REG, IMM, 0XEA],
#     ["MOV", REG, REG, 0X0B],
#     ["NONZERO", REG, 0X0C],
#     ["JMP", REG, 0XF0],
#     ["JMP", IMM, 0XF1],

#     ["MUL", REG, REG, 0x0D],
#     ["EQ", REG, REG, 0X0E],
#     ["NEQ", REG, REG, 0X0F],
#     ["GTE", REG, REG, 0X10],
#     ["LT", REG, REG, 0x11],
#     ["POPCOUNT", REG, REG, 0X12],
#     ["DIV", REG, REG, 0X13]
# ]

def reg1f(code):
    return (code & reg1_mask) >> 16

def reg2f(code):
    return (code & reg2_mask) >> 8

def instrf(code):
    return (code & instr_mask) >> 24

def immf(code):
    return code & imm_mask

def add(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    regs[r1] = u32add(regs[r1], regs[r2])

def sub(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    regs[r1] = u32sub(regs[r1], regs[r2])

def xor(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    regs[r1] = regs[r1] ^ regs[r2]

def bor(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    regs[r1] = regs[r1] | regs[r2]

def band(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    regs[r1] = regs[r1] & regs[r2]

def addimm(code):
    r1 = reg1f(code)
    imm = immf(code)
    if imm & 0x8000:
        imm |= 0xffff0000
    regs[r1] = u32add(regs[r1], imm)

def bnot(code):
    r1 = reg1f(code)
    regs[r1] = regs[r1] ^ 0xffffffff

def lshift(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    regs[r1] = (regs[r1] << regs[r2]) & 0xffffffff

def rshift(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    regs[r1] = (regs[r1] >> regs[r2]) & 0xffffffff

def load(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    regs[r1] = memory[regs[r2]]

def loadimm(code):
    r1 = reg1f(code)
    imm = immf(code)
    if imm & 0x8000:
        imm |= 0xffff0000
    regs[r1] = imm

def store(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    memory[regs[r1]] = regs[r2]

def storeimm(code):
    r1 = reg1f(code)
    imm = immf(code)
    if imm & 0x8000:
        imm |= 0xffff0000
    memory[regs[r1]] = imm

def mov(code):
    r1 = reg1f(code)
    r2 = reg2f(code)
    regs[r1] = regs[r2]

def nonzero(code):
    global pc
    r1 = reg1f(code)
    if regs[r1]:
        pc = u32add(pc, 1)

def jmp(code):
    global pc
    r1 = reg1f(code)
    pc = u32add(pc, regs[r1])

def jmpimm(code):
    global pc
    imm = immf(code)
    if imm & 0x8000:
        imm |= 0xffff0000
    pc = u32add(pc, imm)

instr_fun = {
    0x01: add,
    0x02: sub,
    0x03: xor,
    0x04: bor,
    0x05: band,
    0xE5: addimm,
    0X06: bnot,
    0x07: lshift,
    0x08: rshift,
    0x09: load,
    0xE9: loadimm,
    0x0A: store,
    0xEA: storeimm,
    0x0B: mov,
    0x0C: nonzero,
    0xF0: jmp,
    0xF1: jmpimm
}
import time, sys

def main():
    global pc

    lines = []

    stepbystep = "-step" in sys.argv
    d = load_rom("output.hex")

    if "-file" in sys.argv:
        i = sys.argv.index("-file")
        f = sys.argv[i+1]
        with open(f) as file:
            for line in file:
                line = line.replace("\n", "")
                line = line.split("#")[0]
                if line and ":" not in line and "%" not in line:
                    lines.append(line)

    code_rom = d["code"]
    while pc < len(code_rom):

        print(f"\n\n{pc}", ":", end=" ")

        if lines:
            print(lines[pc])
        code = code_rom[pc]
        instr = instrf(code)
        instr_fun[instr](code)
        pc = u32add(pc, 1)

        for (name, id) in reg_name_to_id.items():
            print(f"{name}={regs[id]}", end=" ")

        if stepbystep:
            i = input()
            print(memory.d)

            while i:
                try:
                    print(eval(i))
                except Exception:
                    print("error")
                i = input()

    print(*regs[1:33])

    print(memory.d)

if __name__ == "__main__":
    main()
