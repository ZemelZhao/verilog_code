module main(
    input clk,
    input rst_n,

    input [3:0] pin_miso,
    output [3:0] pin_cs,
    output [3:0] pin_sclk,
    output [3:0] pin_mosi,

    inout [1:0] sbu,
    input [1:0] cc,

    output [3:0] pinp_txd,
    output [3:0] pinn_txd,

    input [1:0] pinp_rxd,
    input [1:0] pinn_rxd
);

    // Clock Section
    wire sys_clk;
    wire com_txc, com_rxc;
    wire pin_txc, pin_rxc;
    wire spi_clk;
    wire ram_txc, ram_rxc;
    wire fifo_txc, fifo_rxc;

    wire rst;

    // Control Section
    wire fs_adc_init, fd_adc_init;
    wire fs_adc_type, fd_adc_type;
    wire fs_adc_conf, fd_adc_conf;
    wire fs_adc_conv, fd_adc_conv;
    wire fs_adc_send, fd_adc_send;
    wire fs_com_send, fd_com_send;
    wire fs_com_read, fd_com_read;

    // Data Section
    wire [11:0] ram_addr_init;

    wire [7:0] adc_type;
    wire [15:0] adc_temp;
    wire [3:0] adc_stat; 
    wire [3:0] adc_freq;

    wire [7:0] com_type;
    wire [7:0] com_temp;
    wire [3:0] com_stat;
    wire [3:0] com_didx;
    wire [3:0] com_ddidx;

    wire [3:0] send_btype, read_btype;
    wire [3:0] read_bdata;

    wire [11:0] data_len;

    // Pin Section
    wire [3:0] pin_txd;
    wire pin_rxd;
    wire fire_recv;
    wire fire_send;

    wire [63:0] fifo_rxd;
    wire [7:0] fifo_rxen;

    // IP Section
    wire [7:0] ram_txd, ram_rxd;
    wire [11:0] ram_txa, ram_rxa;
    wire ram_txen;

    assign rst = ~rst_n; 
    assign adc_stat = 4'hF;

    console
    console_dut(
        .clk(sys_clk),
        .rst(rst),

        .fs_adc_init(fs_adc_init),
        .fd_adc_init(fd_adc_init),
        .fs_adc_type(fs_adc_type),
        .fd_adc_type(fd_adc_type),
        .fs_dac_conf(fs_adc_conf),
        .fd_adc_conf(fd_adc_conf),
        .fs_adc_conv(fs_adc_conv),
        .fd_adc_conv(fd_adc_conv),

        .fs_adc_send(fs_adc_send),
        .fd_adc_send(fd_adc_send),

        .fs_com_send(fs_com_send),
        .fd_com_send(fd_com_send),
        .fs_com_read(fs_com_read),
        .fd_com_read(fd_com_read),

        .read_btype(read_btype),
        .send_btype(send_btype),
        .read_bdata(send_bdata),

        .ram_addr_init(ram_addr_init),

        .adc_type(adc_type),
        .adc_temp(adc_temp),
        .adc_stat(adc_stat),

        .adc_freq(adc_freq),
        
        .com_type(com_type),
        .com_temp(com_temp),
        .com_stat(com_stat),
    );


    typec
    typec_dut(
        .sys_clk(sys_clk),
        .com_txc(com_txc),
        .com_rxc(com_rxc),
        .pin_txc(pin_txc),
        .pin_rxc(pin_rxc),

        .rst(rst),

        .pin_rxd(pin_rxd),
        .pin_txd(pin_txd),
        .fire_recv(fire_recv),
        .fire_send(fire_send),
        
        .fs_send(fs_com_send),
        .fd_send(fd_com_send),
        .fs_recv(fs_com_read),
        .fd_recv(fd_com_read),

        .read_btype(read_btype),
        .read_bdata(read_bdata),
        .send_btype(send_btype),

        .ram_rxa_init(ram_addr_init),
        .data_len(data_len),
        .ram_rxa(ram_rxa),
        .ram_rxd(ram_rxd),

        .device_type(com_type),
        .device_temp(com_temp),
        .device_stat(com_stat)
    );


    adc
    adc_dut(
        .clk(sys_clk),
        .spi_clk(spi_clk),
        .fifo_txc(fifo_txc),
        .fifo_rxc(fifo_rxc),

        .rst(rst),

        .fs_init(fs_adc_init),
        .fs_type(fs_adc_type),
        .fs_conf(fs_adc_conf),
        .fs_conv(fs_adc_conv),

        .fd_init(fd_adc_init),
        .fd_type(fd_adc_type),
        .fd_conf(fd_adc_conf),
        .fd_conv(fd_adc_conv),

        .freq(adc_freq),
        .type(adc_type),
        .chip_temp(adc_temp),

        .spi_miso(pin_miso),
        .spi_mosi(pin_mosi),
        .spi_sclk(pin_sclk),
        .spi_cs(pin_cs),

        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd)
    );

    adc2ram
    adc2ram_dut(
        .clk(ram_txc),
        .rst(rst),

        .fs(fs_adc_send),
        .fd(fd_adc_send),
        .ram_txa_init(ram_addr_init),
        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd),

        .ram_txen(ram_txen),
        .ram_txd(ram_txd),
        .ram_txa(ram_txa)
    );

    clk_make
    clk_make_dut(
        .clk(clk),
        .sys_clk(sys_clk),
        .com_txc(com_txc),
        .com_rxc(com_rxc),
        .spi_clk(spi_clk),
        .pin_txc(pin_txc),
        .pin_rxc(pin_rxc),
        .ram_txc(ram_txc),
        .ram_rxc(ram_rxc),
        .fifo_txc(fifo_txc),
        .fifo_rxc(fifo_rxc)
    );

    ram 
    ram_dut(
        .clka(ram_txc),
        .addra(ram_txa),
        .dina(ram_txd),
        .wea(ram_txen),

        .clkb(ram_rxc),
        .addrb(ram_rxa),
        .doutb(ram_rxd)
    );








    


endmodule