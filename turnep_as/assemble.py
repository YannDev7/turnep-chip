
import re
import sys
from usize import *

REG = 1
IMM = 2

LABEL = 3
INSTR = 4
DATA = 5

reg_names = [
    "rax",
    "rbx",
    "rcx",
    "rdx",
    "rex",
    "rfx",
    "r1x",
    "r2x",
    "r3x",
    "r4x",
    "r5x",
    "r6x",
    "r7x",
    "r8x",
    "r9x",
]

reg_name_to_id = {name: i for (i, name) in enumerate(reg_names, 1)}




instruction_set = [
    ["ADD", REG, REG, 0x01],
    ["SUB", REG, REG, 0X02],
    ["XOR", REG, REG, 0X03],
    ["OR", REG, REG, 0X04],
    ["AND", REG, REG, 0X05],
    ["ADD", REG, IMM, 0XE5],
    ["NOT", REG, REG, 0X06],
    ["LSHIFT", REG, REG, 0X07],
    ["RSHIFT", REG, REG, 0X08],
    ["LOAD", REG, REG, 0X09],
    ["LOAD", REG, IMM, 0XE9],
    ["STORE", REG, REG, 0X0A],
    ["STORE", REG, IMM, 0XEA],
    ["MOV", REG, REG, 0X0B],
    ["NONZERO", REG, 0X0C],
    ["JMP", REG, 0XF0],
    ["JMP", IMM, 0XF1],

    ["MUL", REG, REG, 0x0D],
    ["EQ", REG, REG, 0X0E],
    ["NEQ", REG, REG, 0X0F],
    ["GTE", REG, REG, 0X10],
    ["LT", REG, REG, 0x11],
    ["POPCOUNT", REG, REG, 0X12],
    ["DIV", REG, REG, 0X13]
]

labels = dict()


def get_name_to_data_dict():
    d = dict()
    for ldata in instruction_set:
        name = ldata[0]
        code = ldata[-1]
        signature = ldata[1:-1]
        if name in d:
            d[name].append((code, signature))
        else:
            d[name] = [(code, signature)]
    return d

links = []


CODE = 6
DATA = 7

def parse_file(file, code_buf, data, instr_set):
    line = file.readline()

    state = CODE

    while line != "":
        t = INSTR
        line = line.split("#")[0]
        if not line:
            line = file.readline()
            continue
        line = line.splitlines()[0]

        if "." in line or state == DATA:
            state = DATA
            if "." in line:
                name = line.split(".")[1]
                data[name] = []
                cur_data_name = name 

            elif line:
                if line.upper().startswith("X"):
                    n = int(line[1:], 16)
                elif line.upper().startswith("B"):
                    n = int(line[1:], 2)
                else:
                    n = int(line)
                data[cur_data_name].append(n)
        elif ":" in line:
            t = LABEL
            name = line.split(":")[0]
            #print(name, file=sys.stderr)
            
            labels[name] = len(code_buf)
        else:
            words = line.split()
            if words:
                instr_name = words[0]
                d_code = 0
                
                for (code, signature) in instr_set[instr_name.upper()]:
                    reg_off = 16
                    add_link = None
                    if len(words) == len(signature) + 1:
                        for i, id in enumerate(signature):
                            if id == REG and words[i + 1] in reg_name_to_id:
                                d_code |= reg_name_to_id[words[i + 1]] << reg_off
                                reg_off -= 8

                            elif id == IMM and "$" in words[i+1]:
                                if words[i+1].upper().startswith("X$"):
                                    n = int(words[i+1][2:], 16)
                                elif words[i+1].upper().startswith("B$"):
                                    n = int(words[i+1][2:], 2)
                                else:
                                    n = int(words[i+1][1:])
                                d_code |= n
                            elif id == IMM and words[i+1].startswith("'"):
                                add_link = words[i+1][1:]
                            else: 
                                d_code = 0
                                add_link = None
                                break
                            if d_code or add_link is not None:
                                if add_link is not None:
                                    links.append((len(code_buf), add_link))
                                d_code |= code << 24
                    if d_code:
                        code_buf.append(d_code)
                        break
                assert (d_code is not None)

        line = file.readline()

def subu16(a, b):
    binv = b ^ 0xffff
    return (a + binv + 1) & 0xffff

assert subu16(34, 33) == 1

def handle_links(code_buf):
    for (i, label) in links:
        code_buf[i] |= u16sub(u16sub(labels[label], i), 1)


        
def separate(s, every, sep=" "):
    l = []
    lsep = list(sep)
    for (i, c) in enumerate(s):
        if i != 0 and i % every == 0:
            l += lsep
        l.append(c)

    return "".join(l)


def phex(n):
    n += 1 << 32
    s = hex(n)[3:]

    return separate(s, 2)
    


def main():
    buf = []
    data = dict()
    instr_set = get_name_to_data_dict()
    with open(sys.argv[1]) as file:
        parse_file(file, buf, data, instr_set)
    handle_links(buf)
    print("[code]")
    print(*[phex(a) for a in buf], sep="\n")
    for (name, dt) in data.items():
        print(f"[{name}]")
        print(*[phex(a) for a in dt], sep="\n")



if __name__ == "__main__":
    main()



