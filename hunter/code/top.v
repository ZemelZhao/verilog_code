module top(
    input clk,
    input rst_n
);

    wire rst;

    assign rst = ~rst_n;

    tb_typec_txf
    tb_typec_txf_dut(
        .clk(clk),
        .rst(rst)
    );


endmodule