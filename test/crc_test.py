
def main():
    file_path = 'D:/Downloads/sendCmd(1)/sendCmd/test.dat'

    with open(file_path, 'rb') as f:
        data = f.read()

    length = len(data)
    
    num = 0
    for i in range(len(data) - 1):
        if data[i] == 0x55 and data[i+1] == 0xaa:
            num = num + 1

    print(num)

            


        
main()

