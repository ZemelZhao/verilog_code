module eth(
    input clk,
    input rst,

    input fs_send,
    output fd_send,

    output fs_read,
    input fd_read,

    output [31:0] cache_cmd,
    input [15:0] ram_addr_init,
    input [11:0] dlen  
);


endmodule
