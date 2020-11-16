"""
RSA
"""

def gcd(a,b):
    """Euclid's algorithm for greatest common divisor"""
    q, r = divmod(a,b)
    while r > 0:
        a, b = (b, r)
        q, r = divmod(a,b)
    return b

def extended_euclid(a,b):
    """
    Calculates modular inverse of b modulo a using Euclid's extended algorithm
    Slightly modified but functionally identical version of algorithm 5.3
    """
    n = a
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

def square_and_multiply(x, e, n):
    """Raises x to e modulo n"""
    z = 1
    for i in reversed(range(0, e.bit_length())):
        z = z*z % n
        if (e >> i) & 1 == 1:
            z = z*x % n
    return z

def pollard_p_minus_one(n, B):
    """Uses Pollard p-1 to find a factor of n (breaking RSA)"""
    a = 2
    for i in range(2, B+1): # a becomes raised to the factorial of B
        a = square_and_multiply(a, i, n)
    d = gcd(n, a-1) # p | gcd(a^u - 1, n) => the gcd probably is p
    if 1 < d < n:   # it definitely *is* p if it's lower than n
        return d
    raise ArithmeticError(f'Pollard p-1 failure: d={d}')

def try_some_bees(n, start, stop):
    """Brute-forces a B that works"""
    for B in range(start, stop+1):
        try:
            print(f'With B={B}: {pollard_p_minus_one(n, B)} ＼(^▽^＠)ノ')
            break
        except ArithmeticError:
            pass
    else:
        print(f'No suitable B in this interval (T＿T)')

def pollard_rho(n, x, f):
    """Uses Pollard rho to find a factor of n"""
    xs = [x]
    d = 1
    i = 2
    while d == 1:
        xs.append(f(xs[i-2]))
        if i % 2 == 0:
            d = gcd(xs[i-1] - xs[(i//2)-1], n)
        if d == n:
            raise ArithmeticError(f'Found no factor in {i} iterations.')
        elif d != 1:
            return i-1, d # x_1 is initial value
        i += 1

if __name__ == '__main__':
    # This wasn't written for any other purpose than submitting something *convenient*.
    # All tasks have been solved using the interpreter.
    print('Oppgave 2b)')
    print(42, end=' -> ')
    print(square_and_multiply(42,7,60491), end=' -> ')
    print(square_and_multiply(26454,17143,60491))

    print('\nOppgave 3a)')
    print(pollard_p_minus_one(1829, 5))

    print('\nOppgave 3b)')
    print(18779, '->', pollard_p_minus_one(18779, 7))
    print(42583, '->', pollard_p_minus_one(42583, 32))

    print('\nOppgave 3c)')
    try_some_bees(6319,5,11)

    print('\nOppgave 4)')
    for n in [851, 1517, 31861]:
        print(f'n={n:5d}:  (i, p) = {pollard_rho(n, 1, lambda x: x*x+1)}')
