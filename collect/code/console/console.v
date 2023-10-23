module console(
    input clk,
    input rst,

    output fs_usb_send,
    input fd_usb_send,
    input fs_usb_read,
    output fd_usb_read,

    output [3:0] usb_tx_btype,
    input [3:0] usb_rx_btype,

    output fs_com_send,
    input fd_com_send,
    input fs_com_read,
    output fd_com_read,

    input fs_data_read,
    output fd_data_read,
    output fs_data_tran,
    input fd_data_tran,

    input [3:0] com_rx_btype,

    output reg [11:0] ram_usb_addr_init,
    output reg [15:0] ram_com_dlen,
    output reg [15:0] ram_com_addr_init,
);


    reg [7:0] state, next_state;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if()
            end
            default: next_state <= IDLE;
        endcase
    end





endmodule