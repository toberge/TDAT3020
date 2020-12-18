from itertools import product
from math import floor, sqrt

from cryptools import inv, modpow


def elgamal_encrypt(pub, x, k):
    p, alpha, beta = pub
    return (modpow(alpha, k, p), x * beta * k)  # y1, y2


def elgamal_decrypt(priv, y1, y2):
    p, _, a, _ = priv
    return y2 * inv(modpow(y1, a, p), p)


def elgamal_sign(priv, x, k):
    p, alpha, a, beta = priv
    gamma = modpow(alpha, k, p)
    kinv = inv(k, p - 1)
    print(f"k^-1 = {kinv}")
    return (gamma, (x - a * gamma) * kinv % (p - 1))


def elgamal_verify(pub, x, gamma, delta):
    p, alpha, beta = pub
    return modpow(beta, gamma, p) * modpow(gamma, delta, p) % p == modpow(alpha, x, p)


snd = lambda pair: pair[1]


def shanks(n, a, b):
    """Shanks algorithm for finding log_a(b) mod n"""
    m = floor(sqrt(n))

    lhs = [(j, modpow(a, m * j, n)) for j in range(m)]
    print(lhs)
    lhs = sorted(lhs, key=snd)
    print(lhs)

    rhs = [(i, (b * inv(modpow(a, i, n), n)) % n) for i in range(m)]
    print(rhs)
    rhs = sorted(rhs, key=snd)
    print(lhs)

    j, i = next(  # Raises StopIteration if no such pair exists
        (j, i) for ((j, y1), (i, y2)) in product(lhs, rhs) if y1 == y2
    )

    assert modpow(a, (m * j + i) % n, n) == b
    return (m * j + i) % n


if __name__ == "__main__":
    pub = (37, 13, 29)
    priv = (37, 13, 15, 29)
    print(elgamal_sign(priv, 14, 11))
    print(elgamal_sign(priv, 3, 5))
