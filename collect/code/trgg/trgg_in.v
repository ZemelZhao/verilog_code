module trgg_in(
    input clk,
    input rst,

    input [0:1] din,
    output [0:1] dout,
    output [0:1] cs,
    output [0:1] sclk,

    output [0:31] tout
);

    genvar i;
    generate
        for (i=0; i<2; i=i+1) begin : ads_inst
            ads
            ads_dut(
                .clk(clk),
                .rst(rst),

                .din(din[i]),
                .dout(dout[i]),
                .cs(cs[i]),
                .sclk(sclk[i]),

                tout(tout[16*i +: 16])
            );
        end
    endgenerate

endmodule
