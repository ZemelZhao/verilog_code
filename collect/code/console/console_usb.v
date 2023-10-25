module console_usb(
    input clk,
    input rst,

    output [0:7] fs_send,
    input [0:7] fd_send,
    input [0:7] fs_read,
    output [0:7] fd_read,
    output [0:31] send_btype,
    input [0:31] read_btype,
    output [0:255] cache_cmd,
    input [0:255] cache_stat,
);

    localparam DEVICE_IDX0 = 4'h1, DEVICE_IDX1 = 4'h3, DEVICE_IDX2 = 4'h5, DEVICE_IDX3 = 4'h7;
    localparam DEVICE_IDX4 = 4'h9, DEVICE_IDX5 = 4'hB, DEVICE_IDX6 = 4'hD, DEVICE_IDX7 = 4'hF;

    wire [3:0] data_idx;
    wire [15:0] device_cmd;
    wire [0:127] device_stat;
    wire [3:0] dlv_send_btype;
    wire [0:31] rly_read_btype; 
    wire fs_send_dlv, fd_read_rly;
    wire [0:7] fd_send_dlv, fs_read_rly;

    console_usb_sub
    console_usb_sub_dut0(
        .clk(clk),
        .rst(rst),

        .fs_send_dlv(fs_send_dlv),
        .fd_send_dlv(fd_send_dlv[0]),
        .fs_read_rly(fs_read_rly[0]),
        .fd_read_rly(fd_read_rly),

        .dlv_send_btype(dlv_send_btype),
        .rly_read_btype(rly_read_btype[0:3]),

        .fs_send(fs_send[0]),
        .fd_send(fd_send[0]),
        .send_btype(send_btype[0:3]),

        .fs_read(fs_read[0]),
        .fd_read(fd_read[0]),
        .read_btype(read_btype[0:3]),

        .device_idx(DEVICE_IDX0),
        .data_idx(data_idx),
        .device_cmd(device_cmd),
        .cache_cmd(cache_cmd[0:31]),

        .cache_stat(cache_stat[0:31]),
        .device_stat(deivce_stat[0:15])
    );

    console_usb_sub
    console_usb_sub_dut1(
        .clk(clk),
        .rst(rst),

        .fs_send_dlv(fs_send_dlv),
        .fd_send_dlv(fd_send_dlv[1]),
        .fs_read_rly(fs_read_rly[1]),
        .fd_read_rly(fd_read_rly),

        .dlv_send_btype(dlv_send_btype),
        .rly_read_btype(rly_read_btype[4:7]),

        .fs_send(fs_send[1]),
        .fd_send(fd_send[1]),
        .send_btype(send_btype[4:7]),

        .fs_read(fs_read[1]),
        .fd_read(fd_read[1]),
        .read_btype(read_btype[4:7]),

        .device_idx(DEVICE_IDX1),
        .data_idx(data_idx),
        .device_cmd(device_cmd),
        .cache_cmd(cache_cmd[32:63]),

        .cache_stat(cache_stat[32:63]),
        .device_stat(deivce_stat[16:31])
    );

    console_usb_sub
    console_usb_sub_dut2(
        .clk(clk),
        .rst(rst),

        .fs_send_dlv(fs_send_dlv),
        .fd_send_dlv(fd_send_dlv[2]),
        .fs_read_rly(fs_read_rly[2]),
        .fd_read_rly(fd_read_rly),

        .dlv_send_btype(dlv_send_btype),
        .rly_read_btype(rly_read_btype[8:11]),

        .fs_send(fs_send[2]),
        .fd_send(fd_send[2]),
        .send_btype(send_btype[8:11]),

        .fs_read(fs_read[2]),
        .fd_read(fd_read[2]),
        .read_btype(read_btype[8:11]),

        .device_idx(DEVICE_IDX2),
        .data_idx(data_idx),
        .device_cmd(device_cmd),
        .cache_cmd(cache_cmd[64:95]),

        .cache_stat(cache_stat[64:95]),
        .device_stat(deivce_stat[32:47])
    );

    console_usb_sub
    console_usb_sub_dut3(
        .clk(clk),
        .rst(rst),

        .fs_send_dlv(fs_send_dlv),
        .fd_send_dlv(fd_send_dlv[3]),
        .fs_read_rly(fs_read_rly[3]),
        .fd_read_rly(fd_read_rly),

        .dlv_send_btype(dlv_send_btype),
        .rly_read_btype(rly_read_btype[12:15]),

        .fs_send(fs_send[3]),
        .fd_send(fd_send[3]),
        .send_btype(send_btype[12:15]),

        .fs_read(fs_read[3]),
        .fd_read(fd_read[3]),
        .read_btype(read_btype[12:15]),

        .device_idx(DEVICE_IDX3),
        .data_idx(data_idx),
        .device_cmd(device_cmd),
        .cache_cmd(cache_cmd[96:127]),

        .cache_stat(cache_stat[96:127]),
        .device_stat(deivce_stat[48:63])
    );

    console_usb_sub
    console_usb_sub_dut0(
        .clk(clk),
        .rst(rst),

        .fs_send_dlv(fs_send_dlv),
        .fd_send_dlv(fd_send_dlv[4]),
        .fs_read_rly(fs_read_rly[4]),
        .fd_read_rly(fd_read_rly),

        .dlv_send_btype(dlv_send_btype),
        .rly_read_btype(rly_read_btype[16:19]),

        .fs_send(fs_send[4]),
        .fd_send(fd_send[4]),
        .send_btype(send_btype[16:19]),

        .fs_read(fs_read[4]),
        .fd_read(fd_read[4]),
        .read_btype(read_btype[16:19]),

        .device_idx(DEVICE_IDX4),
        .data_idx(data_idx),
        .device_cmd(device_cmd),
        .cache_cmd(cache_cmd[128:159]),

        .cache_stat(cache_stat[128:159]),
        .device_stat(deivce_stat[64:79])
    );

    console_usb_sub
    console_usb_sub_dut5(
        .clk(clk),
        .rst(rst),

        .fs_send_dlv(fs_send_dlv),
        .fd_send_dlv(fd_send_dlv[5]),
        .fs_read_rly(fs_read_rly[5]),
        .fd_read_rly(fd_read_rly),

        .dlv_send_btype(dlv_send_btype),
        .rly_read_btype(rly_read_btype[20:23]),

        .fs_send(fs_send[5]),
        .fd_send(fd_send[5]),
        .send_btype(send_btype[20:23]),

        .fs_read(fs_read[5]),
        .fd_read(fd_read[5]),
        .read_btype(read_btype[20:23]),

        .device_idx(DEVICE_IDX5),
        .data_idx(data_idx),
        .device_cmd(device_cmd),
        .cache_cmd(cache_cmd[160:191]),

        .cache_stat(cache_stat[160:191]),
        .device_stat(deivce_stat[80:95])
    );

    console_usb_sub
    console_usb_sub_dut6(
        .clk(clk),
        .rst(rst),

        .fs_send_dlv(fs_send_dlv),
        .fd_send_dlv(fd_send_dlv[6]),
        .fs_read_rly(fs_read_rly[6]),
        .fd_read_rly(fd_read_rly),

        .dlv_send_btype(dlv_send_btype),
        .rly_read_btype(rly_read_btype[24:27]),

        .fs_send(fs_send[6]),
        .fd_send(fd_send[6]),
        .send_btype(send_btype[24:27]),

        .fs_read(fs_read[6]),
        .fd_read(fd_read[6]),
        .read_btype(read_btype[24:27]),

        .device_idx(DEVICE_IDX6),
        .data_idx(data_idx),
        .device_cmd(device_cmd),
        .cache_cmd(cache_cmd[192:223]),

        .cache_stat(cache_stat[192:223]),
        .device_stat(deivce_stat[96:111])
    );

    console_usb_sub
    console_usb_sub_dut7(
        .clk(clk),
        .rst(rst),

        .fs_send_dlv(fs_send_dlv),
        .fd_send_dlv(fd_send_dlv[7]),
        .fs_read_rly(fs_read_rly[7]),
        .fd_read_rly(fd_read_rly),

        .dlv_send_btype(dlv_send_btype),
        .rly_read_btype(rly_read_btype[28:31]),

        .fs_send(fs_send[7]),
        .fd_send(fd_send[7]),
        .send_btype(send_btype[28:31]),

        .fs_read(fs_read[7]),
        .fd_read(fd_read[7]),
        .read_btype(read_btype[28:31]),

        .device_idx(DEVICE_IDX7),
        .data_idx(data_idx),
        .device_cmd(device_cmd),
        .cache_cmd(cache_cmd[224:255]),

        .cache_stat(cache_stat[224:255]),
        .device_stat(deivce_stat[112:127])
    );


endmodule