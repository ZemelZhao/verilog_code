module frame_rx(
    input clk,
    input rst,

    input rxdv,
    input [7:0] rxd,

    output fs_mac,
    input fd_mac,

    output fs_read,
    input fd_read,

    input [31:0] crc,
    output reg crc_en,

    output reg frame_ok,

    output reg [7:0] mac_rxd
);

    localparam HEAD_DATA = 8'h55, WAKE_DATA = 8'h5D, PART_LEN = 8'h04;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam HEAD = 8'h10, WAKE = 8'h11, PART = 8'h12, CHECK = 8'h13;

    reg [31:0] checksum;

    assign fs_read = (state == DONE);

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(rxdv && rxd == HEAD_DATA) next_state <= HEAD;
                else next_state <= WAIT;
            end
            HEAD: begin
                if(rxdv && rxd == HEAD_DATA && cnt >= HEAD_LEN - 1'b1) next_state <= WAKE;
                else if(rxdv && rxd == HEAD_DATA) next_state <= HEAD;
                else next_state <= WAIT;
            end 
            WAKE: begin
                if(rxdv && rxd == WAKE_DATA) next_state <= WORK;
                else next_state <= IDLE;
            end
            WORK: begin
                if(rxdv && fd_mac) next_state <= PART;
                else if(rxdv) next_state <= WORK;
                else next_state <= IDLE;
            end
            PART: begin
                if(rxdv && cnt >= PART_LEN - 1'b1) next_state <= CHECK;
                else if(rxdv) next_state <= PART;
                else next_state <= IDLE;
            end
            CHECK: next_state <= DONE;
            DONE: begin
                if(fd_read) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;

        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) mac_rxd <= 8'h00;
        else if(state == WORK) mac_rxd <= rxd;
        else mac_rxd <= 8'h00;
    end


    always@(posedge clk or posedge rst) begin
        if(rst) frame_ok <= 1'b0;
        else if(state == IDLE) frame_ok <= 1'b0; 
        else if(state == WAIT) frame_ok <= 1'b0; 
        else if(state == CHECK && checksum == crc) frame_ok <= 1'b1;
        else frame_ok <= frame_ok;
    end




endmodule