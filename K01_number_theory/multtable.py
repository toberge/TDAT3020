import sys

def print_table(n):
    for i in range(1,n):
        print(str(i), end=' & ')
        for j in range(1,n):
            print(str(i * j % n), end=' & ')
        print()

if __name__ == '__main__':
    if len(sys.argv) == 2:
        print_table(int(sys.argv[1]))
    else:
        print_table(12)
