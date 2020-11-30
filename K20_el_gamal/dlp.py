"""
DLP - Discrete Logarithm Problem
"""

from math import sqrt, floor
from itertools import product

def gcd(a,b):
    """Euclid's algorithm for greatest common divisor"""
    q, r = divmod(a,b)
    while r > 0:
        a, b = (b, r)
        q, r = divmod(a,b)
    return b

def inv(b, n):
    """
    Calculates modular inverse of b modulo n using Euclid's extended algorithm
    Slightly modified but functionally identical version of algorithm 5.3
    """
    a = n
    t = 1
    t0 = 0
    q, r = divmod(a, b)
    while r > 0:
        t, t0 = ((t0 - q*t) % n, t)
        a, b = (b, r)
        q, r = divmod(a, b)
    if b != 1:
        raise ArithmeticError("b has no inverse mod a")
    return t

def modpow(x, e, n):
    """Raises x to e modulo n using the square-and-multiply algorithm"""
    z = 1
    for i in reversed(range(0, e.bit_length())):
        z = z*z % n
        if (e >> i) & 1 == 1:
            z = z*x % n
    return z

snd = lambda pair: pair[1]

def shanks(n, a, b):
    m = floor(sqrt(n))
    lhs = sorted(
        ((j, modpow(a, m*j, n)) for j in range(m)),
        key=snd)
    rhs = sorted(
        ((i, (b*inv(modpow(a, i, n), n)) % n) for i in range(m)),
        key=snd)
    j, i = next( # Raises StopIteration if no such pair exists
        (j, i) for ((j, y1), (i, y2)) in product(lhs, rhs) if y1 == y2)

    assert modpow(a, (m*j+i) % n, n) == b
    return (m*j+i) % n

if __name__ == '__main__':
    print('Oppgave 3)')
    print(shanks(41,6,3))
