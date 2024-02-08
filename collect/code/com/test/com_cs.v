module com_cs(
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

    input [3:0] btype
);

    localparam NUM_LATENCY = 4'h4;
    localparam TIMEOUT = 12'h400;

    localparam COM_RX00 = 4'h2, COM_RX01 = 4'hD;
    localparam COM_INIT = 4'h0;

    reg [15:0] state, next_state;
    localparam MAIN_IDLE = 16'h0001, MAIN_WAIT = 16'h0002;
    localparam SEND_IDLE = 16'h0010, SEND_WORK = 16'h0020;
    localparam SEND_WAIT = 16'h0040, SEND_DONE = 16'h0080;
    localparam READ_IDLE = 16'h0100, READ_WORK = 16'h0200;
    localparam READ_WAIT = 16'h0400, READ_DONE = 16'h0800;
    localparam WAIT_IDLE = 16'h1000, WAIT_READ = 16'h2000;
    localparam WAIT_TAKE = 16'h4000, WAIT_DONE = 16'h8000;

    reg [11:0] num;

    reg [3:0] btype_d0;

    assign fs_com_send = (state == SEND_WAIT);
    assign fd_com_read = (state == READ_DONE);
    assign fs_read = (state == READ_WAIT);
    assign fd_send = (state == SEND_DONE);

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

            SEND_IDLE: begin
                if(NUM_LATENCY == 4'h0) next_state <= SEND_WAIT;
                else next_state <= SEND_WORK;
            end
            SEND_WORK: begin
                if(num >= NUM_LATENCY) next_state <= SEND_WAIT;
                else next_state <= SEND_WORK;
            end
            SEND_WAIT: begin
                if(fd_com_send) next_state <= WAIT_IDLE;
                else next_state <= SEND_WAIT;
            end
            SEND_DONE: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <= SEND_DONE;
            end

            WAIT_IDLE: begin
                if(num >= TIMEOUT) next_state <= SEND_IDLE;
                else if(fs_com_read) next_state <= WAIT_READ;
                else next_state <= WAIT_IDLE;
            end
            WAIT_READ: begin
                if(~fs_com_read) next_state <= WAIT_TAKE;
                else next_state <= WAIT_READ;
            end
            WAIT_TAKE: begin
                if(btype_d0 == COM_INIT) next_state <= WAIT_DONE; 
                else if(btype_d0 == COM_RX00 && btype == COM_RX01) next_state <= WAIT_DONE; 
                else if(btype_d0 == COM_RX01 && btype == COM_RX00) next_state <= WAIT_DONE;
                else next_state <= SEND_IDLE;
            end
            WAIT_DONE: next_state <= SEND_DONE;

            READ_IDLE: next_state <= READ_WORK;
            READ_WORK: next_state <= SEND_WAIT;
            READ_WAIT: begin
                if(fd_read) next_state <= READ_DONE;
                else next_state <= SEND_WAIT;
            end
            READ_DONE: begin
                if(~fs_com_read) next_state <= MAIN_WAIT;
                else next_state <= READ_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 4'h0;
        else if(state == MAIN_IDLE) num <= 4'h0;
        else if(state == SEND_WORK) num <= num + 1'b1;
        else num <= 4'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) btype_d0 <= COM_INIT;
        else btype_d0 <= btype;
    end

endmodule

