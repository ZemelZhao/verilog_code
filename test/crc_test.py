
def crc5_step(data, crc):
    din = int2bin(data, 8)
    cout = int2bin(crc, 5)
    list_res = [0, 0, 0, 0, 0]
    list_res[0] = cout[0]^cout[2]^cout[3]^din[0]^din[3]^din[5]^din[6]; 
    list_res[1] = cout[1]^cout[3]^cout[4]^din[1]^din[4]^din[6]^din[7];
    list_res[2] = cout[0]^cout[3]^cout[4]^din[0]^din[2]^din[3]^din[6]^din[7];
    list_res[3] = cout[0]^cout[1]^cout[4]^din[1]^din[3]^din[4]^din[7];
    list_res[4] = cout[1]^cout[2]^din[2]^din[4]^din[5];
    return bin2int(list_res)

def crc5(data):
    crc = 0x1F
    for i in range(len(data)):
        crc = crc5_step(data[i], crc)
        print(hex(crc)[2:].upper())
    return crc
    

def main():
    a = [0xFF]
    print(crc5(a))


def int2bin(data, num):
    res = []
    for i in range(num):
        res.append(0)
    tmp = bin(data)[2:]
    for i in range(len(tmp)):
        res[num-i-1] = int(tmp[i])
    return res

def bin2int(data):
    res = 0
    for i in range(len(data)):
        res += data[i] * 2**i
    return res

main()