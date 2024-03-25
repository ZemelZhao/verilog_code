module eth(
    input clk,
    input rst,

    output e_mdc,
    inout e_mdio,
    output reg e_rstn,

    input gmii_txc,
    output gmii_txen,
    output [7:0] gmii_txd,
    output gmii_txer,

    input gmii_rxc,
    input gmii_rxdv,
    input [7:0] gmii_rxd,
    input gmii_rxer,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    input [15:0] ram_send_rxa_init,
    output [15:0] ram_send_rxa,
    input [15:0] ram_send_dlen,
    input [7:0] ram_send_rxd,

    input [15:0] ram_read_txa_init,
    output [15:0] ram_read_txa,
    output [7:0] ram_read_txd,
    output ram_read_txen,
    output [15:0] ram_read_dlen
); 

    


endmodule