"""
Just saving this for later.
None of this will work, I suppose.
"""

import numpy as np
from aes import RCON, S_BOX

# To multiply the byte vector with
# SUB_MATRIX = np.array([
#     [1,0,0,0,1,1,1,1],
#     [1,1,0,0,0,1,1,1],
#     [1,1,1,0,0,0,1,1],
#     [1,1,1,1,0,0,0,1],
#     [1,1,1,1,1,0,0,0],
#     [0,1,1,1,1,1,0,0],
#     [0,0,1,1,1,1,1,0],
#     [0,0,0,1,1,1,1,1],
# ])
# not needed, though...

BITS_IN_A_BYTE = 8
NUM_ROUNDS = 10
N = 0x11B # bits 8, 4, 3, 1, 0 are set

def key_expansion_core(k, i):
    """Key expansion for AES, inner core"""
    # use np.roll(k, -1) or sth
    k = np.roll(k, -1) # RotWord
    # and then s-box it
    k = [S_BOX[b] for b in k] # SubWord
    # then look in the rcon table too, for the first one
    k[0] ^= RCON[i] # Round constant
    return k

def create_inverse_table():
    pass

def rotl(b, n):
    return b << n | b >> (BITS_IN_A_BYTE - n)

def mult_inv(a):
    t = 0
    nt = 1
    r = N
    nr = a

    while nr != 0:
        q = r // nr
        t, nt = (nt, (t ^ (- (q * nt) % N)) % N)
        r, nr = (nr, (r ^ (- (q * nr) % N)) % N)

    if r > 1:
        raise Exception('nani the fugg: ' + str(r))
    if t < 0:
        t = t + N
    return t

def s_box(a):
    # mult inv first
    b = mult_inv(a)
    # from https://en.wikipedia.org/wiki/Rijndael_S-box#Forward_S-box
    return b ^ rotl(b,1) ^ rotl(b,2) ^ rotl(b,3) ^ rotl(b,4) ^ 0x63
    # oh, screw it all
