module console_data(
    input clk,
    input rst,

    output fs,
    input fd,
    output reg [3:0] btype,

    input fs_com_send,
    input fs_com_read
);

    reg [5:0] state; 
    reg [5:0] next_state;
    localparam IDLE = 6'h01, WAIT = 6'h02, WORK = 6'h04, DONE = 6'h08;
    localparam DATA = 6'h10, STAT = 6'h20;
    
    localparam BTYPE_INIT = 4'h0, BTYPE_INFO = 4'h1, BTYPE_DATA = 4'hE;

    reg [1:0] fs_send_b, fs_read_b;

    assign fs = (state == WORK);

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

endmodule