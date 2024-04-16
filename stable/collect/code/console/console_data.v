module console_data(
    input clk,
    input rst,

    output fs,
    input fd,
    output reg [3:0] btype,

    input [3:0] core_data_idx,
    output [3:0] data_idx,

    input fs_com_send,
    input fs_com_read
);

    reg [5:0] state; 
    reg [5:0] next_state;
    localparam IDLE = 6'h01, WAIT = 6'h02, WORK = 6'h04, DONE = 6'h08;
    localparam DATA = 6'h10, STAT = 6'h20;
    
    localparam BTYPE_INIT = 4'h0, BTYPE_INFO = 4'h1, BTYPE_DATA = 4'hE;

    localparam DATA_IDX_INIT = 4'h0, DATA_IDX_NUM = 4'h6;

    reg [1:0] fs_send_b, fs_read_b;

    reg [3:0] ram_data_idx;

    assign fs = (state == WORK);

    assign data_idx = (ram_data_idx >= DATA_IDX_NUM) ?ram_data_idx - DATA_IDX_NUM :ram_data_idx; 

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs_read_b == 2'b01) next_state <= STAT;
                else if(fs_send_b == 2'b01) next_state <= DATA;
                else next_state <= WAIT;
            end
            DATA: next_state <= WORK;
            STAT: next_state <= WORK;
            WORK: begin
                if(fd) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: next_state <= WAIT; 
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_send_b <= 2'b00;
        else fs_send_b <= {fs_send_b[0], fs_com_send};
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_read_b <= 2'b00;
        else fs_read_b <= {fs_read_b[0], fs_com_read};
    end

    always@(posedge clk or posedge rst) begin
        if(rst) btype <= BTYPE_INIT;
        else if(state == IDLE) btype <= BTYPE_INIT;
        else if(state == WAIT) btype <= BTYPE_INIT;
        else if(state == DATA) btype <= BTYPE_DATA;
        else if(state == STAT) btype <= BTYPE_INFO;
        else btype <= btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_data_idx <= DATA_IDX_INIT;
        else if(state == IDLE) ram_data_idx <= DATA_IDX_INIT;
        else if(state == DATA) ram_data_idx <= core_data_idx + 1'b1;
        else ram_data_idx <= ram_data_idx;
    end


endmodule