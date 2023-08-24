module top(
    input clk,
    input rst_n
);

    wire rst;

    assign rst = ~rst_n;

    tb_typec_rxf
    tb_typec_rxf_dut(
        .clk(clk),
        .rst(rst)
    );


endmodule