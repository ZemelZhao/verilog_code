module trgg(
    input clk,
    input rst,

    input fs,
    output fd,

    input [0:1] din,
    output [0:1] dout,
    output [0:1] cs,
    output [0:1] sclk,

    input [0:39] trgg_cmd,

    output [0:1] pin_out,
    output [0:31] trgg_data
);

    wire [0:7] mod;
    wire [0:31] delay;

    wire [0:1] fd_dev;


    assign mod = trgg_cmd[0:7];
    assign delay = trgg_cmd[8:39];

    assign fd = &fd_dev;

    genvar i;
    generate
        for(i=0; i<2; i=i+1) begin: trgg_out_inst
            trgg_out
            trgg_out_dut(
                .clk(clk),
                .rst(rst),
                .fs(fs),
                .fd(fd_dev[0]),
                .mod(mod[4*i +: 4]),
                .delay(delay[16*i +: 16]),
                .pin(pin_out[i])
            );
        end
    endgenerate

    trgg_in
    trgg_in_dut(
        .clk(clk),
        .rst(rst),

        .din(din),
        .dout(dout),
        .cs(cs),
        .sclk(sclk),

        .tout(trgg_data)
    );

endmodule