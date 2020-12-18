def gcd(a, b):
    """Euclid's algorithm for greatest common divisor"""
    q, r = divmod(a, b)
    while r > 0:
        a, b = (b, r)
        q, r = divmod(a, b)
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
        t, t0 = ((t0 - q * t) % n, t)
        a, b = (b, r)
        q, r = divmod(a, b)
    if b != 1:
        raise ArithmeticError("b has no inverse mod a")
    return t


def modpow(x, e, n):
    """Raises x to e modulo n using the square-and-multiply algorithm"""
    z = 1
    for i in reversed(range(0, e.bit_length())):
        z = z * z % n
        if (e >> i) & 1 == 1:
            z = z * x % n
    return z
