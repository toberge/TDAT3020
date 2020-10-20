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

# from stackoverflow, I thought python *had* this method
cycle = lambda arr, m: [arr[i:i+m] for i in range(0,len(arr),m)]
trans = lambda s: [char_to_val(c) for c in s]
untrans = lambda s: strify(val_to_char(c) for c in s)

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

def decrypt2(txt, Kinv):
    """With supplied inverse"""
    m = np.size(Kinv, axis=1)
    enc = []
    for block in cycle(trans(txt), m):
        x = np.array(block)
        enc.append(np.matmul(x, Kinv) % 29)
    return untrans(int(f) for f in np.concatenate(enc))

def main():
    K = np.array([[11,8],
                  [ 3,7]])
    print('Eksemplet i folene:')
    K2 = np.array([[1, 2, 3],
                   [2, 5, 3],
                   [1, 0, 8]])

    print(np.linalg.inv(K2) % 29)

    print(np.linalg.det(K))

    print(encrypt('VIVANT', K2))
    print(decrypt(encrypt('VIVANT', K2), K2))

    print(encrypt('PRIM', K))

    Kinv = np.array([[ 7, 21],
                     [26, 11]])
    print(decrypt2('TOYYSN', Kinv))

if __name__ == '__main__':
    main()
