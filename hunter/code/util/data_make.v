module data_make(
    input clk,
    input rst,

    input fs,
    output fd,

    input [3:0] btype,
    input [11:0] ram_data_init,

    output reg [7:0] fifo_rxen,
    input [63:0] fifo_rxd,

    output reg [7:0] ram_cmd_rxa,
    input [7:0] ram_cmd_rxd,

    output reg [11:0] ram_dat_txa,
    output reg [7:0] ram_data_txd,
    output reg ram_txen
);

    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;



endmodule