module top(
    input clk,
    input rst_n
);

    wire rst;

    assign rst = ~rst_n;


    tb_ram2fifo
    tb_ram2fifo_dut(
        .clk(clk),
        .rst(rst)
    );


endmodule