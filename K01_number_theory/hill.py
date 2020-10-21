import numpy as np

def strify(arr):
    string = ''
    for c in arr:
        string += c
    return string

def val_to_char(x):
    if 0 <= x < 26:
        return chr(x+ord('A'))
    elif x == 26:
        return 'Æ'
    elif x == 27:
        return 'Ø'
    elif x == 28:
        return 'Å'

def char_to_val(c):
    if '@' < c < 'a':
        return ord(c) - 65
    elif c == 'Æ':
        return 26
    elif c == 'Ø':
        return 27
    elif c == 'Å':
        return 28

# Translating char <-> int
trans = lambda s: [char_to_val(c) for c in s]
untrans = lambda s: strify(val_to_char(c) for c in s)

# from stackoverflow, I thought python *had* this method
cycle = lambda arr, m: [arr[i:i+m] for i in range(0,len(arr),m)]

def encrypt(txt, K):
    m = np.size(K, axis=1)
    enc = []
    for block in cycle(trans(txt), m):
        x = np.array(block)
        enc.append(np.matmul(x, K) % 29)
    return untrans(np.concatenate(enc))

def decrypt(txt, K):
    """This does NOT work unless det K = 1 (do parts by hand)"""
    m = np.size(K, axis=1)
    Kinv = np.linalg.inv(K) % 29
    enc = []
    for block in cycle(trans(txt), m):
        x = np.array(block)
        enc.append(np.matmul(x, Kinv) % 29)
    return untrans(int(f) for f in np.concatenate(enc))

def decrypt_with_inv(txt, Kinv):
    """With supplied inverse"""
    m = np.size(Kinv, axis=1)
    enc = []
    for block in cycle(trans(txt), m):
        x = np.array(block)
        enc.append(np.matmul(x, Kinv) % 29)
    return untrans(int(f) for f in np.concatenate(enc))

def main():
    print('Eksemplet i folene:')
    K2 = np.array([[1, 2, 3],
                   [2, 5, 3],
                   [1, 0, 8]])
    print(np.linalg.inv(K2) % 29)
    print(encrypt('VIVANT', K2))
    print(decrypt(encrypt('VIVANT', K2), K2))

    print()
    print('Vårt tilfelle:')
    K = np.array([[11,8],
                  [ 3,7]])
    Kinv = np.array([[16, 19],
                     [18, 21]])

    print(encrypt('PRIM', K))
    print('...som skal bli PRIM igjen:')
    print(decrypt_with_inv(encrypt('PRIM', K), Kinv))

    # This works! Yay!
    print('Så, hva er TOYYSN?')
    print(decrypt_with_inv('TOYYSN', Kinv))

    print()
    print('Til oppgave 8c:')
    print(trans('EASY'))
    print(trans('IØÅY'))
    K3 = np.array([[ 2,14],
                   [19, 5]])
    print(encrypt('EASY', K3))

if __name__ == '__main__':
    main()
