module top(
    input clk,
    input rst_n
);

    wire rst;

    assign rst = ~rst_n;


    tb_com_rx
    tb_com_rx_dut(
        .clk(clk),
        .rst(rst)
    );


endmodule