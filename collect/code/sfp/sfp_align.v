module sfp_align(
    input clk,
    input rst,

    input [31:0] sfp_rxd,
    input [3:0] sfp_rxctl,

    output reg [31:0] sfp_rxd_align,
    output reg [3:0] sfp_rxctl_align
);

    reg [31:0] sfp_rxd_d0;
    reg [3:0] sfp_rxctl_d0;
    reg [3:0] align_bit;

    always@(posedge clk or posedge rst) begin
        if(rst) align_bit <= 4'h0;
        else if(sfp_rxctl != 4'h0) align_bit <= sfp_rxctl;
        else align_bit <= align_bit;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) sfp_rxd_d0 <= 32'h0000;
        else sfp_rxd_d0 <= sfp_rxd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) sfp_rxctl_d0 <= 4'h0;
        else sfp_rxctl_d0 = sfp_rxctl;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) sfp_rxd_align <= 32'h0000;
        else if(align_bit == 4'h1) sfp_rxd_align <= sfp_rxd;
        else if(align_bit == 4'h4) sfp_rxd_align <= {sfp_rxd[15:0], sfp_rxd_d0[31:16]};
        else sfp_rxd_align <= 32'h0000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) sfp_rxctl_align <= 4'h0;
        else if(align_bit == 4'h1) sfp_rxctl_align <= sfp_rxctl;
        else if(align_bit == 4'h4) sfp_rxctl_align <= {sfp_rxctl[1:0], sfp_rxctl_d0[3:2]};
        else sfp_rxctl_align <= 4'h0;
    end

endmodule