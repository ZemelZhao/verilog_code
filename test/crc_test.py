
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
        show(crc)
    return crc

def crc16_step(data, crc):
    din = int2bin(data, 8)
    cout = int2bin(crc, 16)
    list_res = [0, 0, 0, 0, 0, 0, 0, 0, 
                0, 0, 0, 0, 0, 0, 0, 0]
    
    list_res[0] = cout[8]^cout[9]^cout[10]^cout[11]^cout[12]^cout[13]^cout[14]^cout[15]^din[0]^din[1]^din[2]^din[3]^din[4]^din[5]^din[6]^din[7]; 
    list_res[1] = cout[9]^cout[10]^cout[11]^cout[12]^cout[13]^cout[14]^cout[15]^din[1]^din[2]^din[3]^din[4]^din[5]^din[6]^din[7]; 
    list_res[2] = cout[8]^cout[9]^din[0]^din[1];
    list_res[3] = cout[9]^cout[10]^din[1]^din[2];
    list_res[4] = cout[10]^cout[11]^din[2]^din[3];
    list_res[5] = cout[11]^cout[12]^din[3]^din[4];
    list_res[6] = cout[12]^cout[13]^din[4]^din[5];
    list_res[7] = cout[13]^cout[14]^din[5]^din[6];
    list_res[8] = cout[0]^cout[14]^cout[15]^din[6]^din[7];
    list_res[9] = cout[1]^cout[15]^din[7];
    list_res[10] = cout[2];
    list_res[11] = cout[3];
    list_res[12] = cout[4];
    list_res[13] = cout[5];
    list_res[14] = cout[6];
    list_res[15] = cout[7]^cout[8]^cout[9]^cout[10]^cout[11]^cout[12]^cout[13]^cout[14]^cout[15]^din[0]^din[1]^din[2]^din[3]^din[4]^din[5]^din[6]^din[7];
    return bin2int(list_res)
    
def crc16(data):
    crc = 0xFFFF
    for i in range(len(data)):
        crc = crc16_step(data[i], crc)
    return crc

def main():
    a = [0x95, 0x63]
    crc = crc5(a)
    show(crc)

def show(data):
    print(hex(data)[2:].upper())
    


def int2bin(data, num):
    res = []
    for i in range(num):
        res.append(0)
    tmp = bin(data)[2:]
    for i in range(len(tmp)):
        res[len(tmp)-i-1] = int(tmp[i])
    return res

def bin2int(data):
    res = 0
    for i in range(len(data)):
        res += data[i] * 2**i
    return res

main()