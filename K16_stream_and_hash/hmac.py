from collections import Counter

K    = 0b1001
ipad = 0b0011
opad = 0b0101

# midtkvadrat
h = lambda x: ((x*x % (256)) >> 2) & 15

hmac = lambda x: h(
    ((K^opad)<<4) # 4 bits
    +h(((K^ipad)<<4)+x) # 8 bits
)

testmac = lambda x: (
    ((K^opad)<<4) # 4 bits, 4 bits after this pattern
    +h(((K^ipad)<<4)+x) # 4 bits
)

print(f'en test av h: {h(0b1101):b}')
print(f'3a) {hmac(0b0110):04b}')
print(f'3b) {hmac(0b0111):04b}')
print(f'f: {testmac(0b0110):0b}')

print()
print('\n'.join(f'{hmac(i):04b}' for i in range(16)))
print()
print('Fordelingen av bitmønstre denne HMAC mapper til:')
hmacs = Counter(hmac(i) for i in range(16))
print('\n'.join(f'{k:04b}: {v}' for k, v in hmacs.items()))
