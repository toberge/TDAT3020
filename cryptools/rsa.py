from cryptools import gcd, modpow


def pollard_p_minus_one(n, B):
    """Uses Pollard p-1 to find a factor of n (breaking RSA)"""
    a = 2
    for i in range(2, B + 1):  # a becomes raised to the factorial of B
        print(f"{a}^{i} mod {n} = ", end="")
        a = modpow(a, i, n)
        print(a)
    d = gcd(n, a - 1)  # p | gcd(a^u - 1, n) => the gcd probably is p
    print(f"a^B! = {a} -> gcd({n}, {a-1}) = {d}")
    if 1 < d < n:  # it definitely *is* p if it's lower than n
        return d
    raise ArithmeticError(f"Pollard p-1 failure: d={d}")


def try_some_bees(n, start, stop):
    """Brute-forces a B that works"""
    for B in range(start, stop + 1):
        try:
            print(f"With B={B}: {pollard_p_minus_one(n, B)} ＼(^▽^＠)ノ")
            break
        except ArithmeticError:
            pass
    else:
        print(f"No suitable B in this interval (T＿T)")


def pollard_rho(n, x, f):
    """Uses Pollard rho to find a factor of n"""
    xs = [x]
    d = 1
    i = 2
    while d == 1:
        xi = f(xs[i - 2])
        print(f"x_{i} = {xi}")
        xs.append(xi)
        if i % 2 == 0:
            d = gcd(xs[i - 1] - xs[(i // 2) - 1], n)
            print(f"gcd(x_{i-1} - x_{i // 2} - 1, {n}) = {d}")
        if d == n:
            raise ArithmeticError(f"Found no factor in {i} iterations.")
        elif d != 1:
            return i - 1, d  # x_1 is initial value
        i += 1


if __name__ == "__main__":
    print("\nOppgave 3a)")
    print(pollard_p_minus_one(1829, 5))

    print("\nOppgave 3b)")
    print(18779, "\n", pollard_p_minus_one(18779, 7))
    print(42583, "\n", pollard_p_minus_one(42583, 32))

    print("\nOppgave 3c)")
    try_some_bees(6319, 5, 11)

    print("\nOppgave 4)")
    for n in [851, 1517, 31861]:
        print(f"n={n:5d}:  (i, p) = {pollard_rho(n, 1, lambda x: x*x+1)}")
