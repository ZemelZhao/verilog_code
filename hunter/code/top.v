module top(
    input clk,
    input rst_n
);

    wire rst;

    assign rst = ~rst_n;

    tb_adc2ram
    tb_adc2ram_dut(
        .clk(clk),
        .rst(rst)
    );


endmodule