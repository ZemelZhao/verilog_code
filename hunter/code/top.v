module top(
    input clk,
    input rst_n
);

    wire rst;

    assign rst = ~rst_n;

    tb_typec
    tb_typec_dut(
        .clk(clk),
        .rst(rst)
    );


endmodule