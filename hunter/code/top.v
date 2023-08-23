module top(
    input clk,
    input rst_n
);

    wire rst;

    assign rst = ~rst_n;

    tb_typec_rx(
        .clk(clk),
        .rst(rst)
    );


endmodule