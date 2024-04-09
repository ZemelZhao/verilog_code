module top(
    input clk_in_p,
    input clk_in_n,

    output [1:0] trgg_out,
    output fan_n,

    output [1:0] trgg_sclk,
    output [1:0] trgg_cs,
    input [1:0] trgg_miso,
    output [1:0] trgg_mosi
);

    wire clk;
    assign fan_n = 1'b0;

    (*MARK_DEBUG = "true"*)wire [15:0] trgg_rxd0, trgg_rxd1;
    
    wire [31:0] trgg_data;

    assign trgg_rxd0 = trgg_data[31:16];
    assign trgg_rxd1 = trgg_data[15:0];


    clk_wiz
    clk_wiz(
        .clk_in1_p(clk_in_p),
        .clk_in1_n(clk_in_n),

        .clk_norm(clk)
    );


    vio
    vio_dut(
        .clk(clk),
        .probe_out0(trgg_out[0]),
        .probe_out1(trgg_out[1])
    );


    trgg
    trgg_dut(
        .clk(clk),

        .pin_miso(trgg_miso),
        .pin_mosi(trgg_mosi),
        .pin_cs(trgg_cs),
        .pin_sclk(trgg_sclk),

        .trgg_data(trgg_data)
    );

endmodule