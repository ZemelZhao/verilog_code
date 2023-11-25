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
    output fd_com_read
);

    localparam COM_INIT = 4'h0;
    localparam COM_CONF = 4'h1, COM_READ = 4'h4, COM_STOP = 4'h9;
    localparam COM_DATA = 4'h5, COM_STAT = 4'hA;

    localparam NUM_LATENCY = 4'h4;

    reg [7:0] state, next_state;

    assign fs_com_tran = (state == SEND_WORK) || (state == SEND_WAIT);
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
                if(fd_com_send) next_state <= SEND_DONE;
                else next_state <= SEND_WAIT;
            end
            SEND_DONE: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <= SEND_DONE;
            end

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

endmodule

