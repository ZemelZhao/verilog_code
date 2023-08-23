module top(
    input clk,
    input rst_n
);

    wire rst;

    assign rst = ~rst_n;

    tb_typecm_tx(
        .clk(clk),
        .rst(rst)
    );


endmodule