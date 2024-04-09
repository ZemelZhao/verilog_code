module console_com(
    input clk,
    input rst,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output fs_com_send,
    input fd_com_send,
    input fs_com_read,
    output fd_com_read,

    input [3:0] com_btype,
    output reg [1:0] com_state
);

    localparam COM_STATE_IDLE = 2'b00, COM_STATE_CONF = 2'b01;
    localparam COM_STATE_READ = 2'b10, COM_STATE_SAME = 2'b11;

    localparam BTYPE_INIT = 4'h0, BTYPE_CONF = 4'h1, BTYPE_READ = 4'h2; 
    localparam BTYPE_STOP = 4'h3, BTYPE_RXD0 = 4'h4, BTYPE_RXD1 = 4'h5;

    reg [9:0] state; 
    reg [9:0] next_state;
    localparam MAIN_IDLE = 10'h001, MAIN_WAIT = 10'h002;
    localparam READ_IDLE = 10'h004, READ_WAIT = 10'h008, READ_WORK = 10'h010, READ_DONE = 10'h020;
    localparam SEND_IDLE = 10'h040, SEND_WAIT = 10'h080, SEND_WORK = 10'h100, SEND_DONE = 10'h200;

    localparam TIMEOUT = 8'h80;

    reg [7:0] num;

    assign fd_send = (state == SEND_DONE);
    assign fs_read = (state == READ_WAIT);
    assign fs_com_send = (state == SEND_WAIT);
    assign fd_com_read = (state == READ_DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_com_read) next_state <= READ_IDLE;
                else if(fs_send) next_state <= SEND_IDLE;
                else next_state <= MAIN_WAIT;
            end

            READ_IDLE: next_state <= READ_WORK;
            READ_WORK: next_state <= READ_WAIT;
            READ_WAIT: begin
                if(fd_read) next_state <= READ_DONE;
                else if(num+1'b1 >= TIMEOUT) next_state <= READ_DONE;
                else next_state <= READ_WAIT;
            end
            READ_DONE: begin
                if(~fs_com_read) next_state <= MAIN_WAIT;
                else next_state <= READ_DONE;
            end

            SEND_IDLE: next_state <= SEND_WAIT;
            SEND_WAIT: begin
                if(fd_com_send) next_state <= SEND_WORK;
                else next_state <= SEND_WAIT;
            end
            SEND_WORK: next_state <= SEND_DONE;
            SEND_DONE: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <= SEND_DONE;
            end
            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_state <= COM_STATE_IDLE;
        else if(state == READ_WORK && com_btype == BTYPE_INIT) com_state <= COM_STATE_IDLE;
        else if(state == READ_WORK && com_btype == BTYPE_CONF) com_state <= COM_STATE_CONF;
        else if(state == READ_WORK && com_btype == BTYPE_READ) com_state <= COM_STATE_READ;
        else if(state == READ_WORK && com_btype == BTYPE_STOP) com_state <= COM_STATE_IDLE;
        else com_state <= com_state;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == READ_WAIT) num <= num + 1'b1;
        else num <= 8'h00;
    end


endmodule