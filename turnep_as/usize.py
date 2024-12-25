

def u8add(x, y):
    return (x + y) & 0xff

def u16add(x, y):
    return (x + y) & 0xffff

def u32add(x, y):
    return (x + y) & 0xffffffff

def u8sub(x, y):
    yinv = y ^ 0xff
    return (x + yinv + 1) & 0xff

def u16sub(x, y):
    yinv = y ^ 0xffff
    return (x + yinv + 1) & 0xffff

def u32sub(x, y):
    yinv = y ^ 0xffffffff
    return (x + yinv + 1) & 0xffffffff



