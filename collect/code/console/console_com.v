module console_com(
    input clk,
    input rst,

    input fs_com_send,
    output fd_com_send,
    output fs_com_read,
    input fd_com_read,

    input [3:0] com_send_btype,
    output reg [3:0] com_read_btype,

    output fs_send,
    input fd_send,
    input fs_read,
    output fd_read,

    output reg [3:0] send_btype,
    input [3:0] read_btype,

    input [15:0] com_cmd,
    output reg [15:0] device_cmd

);

    localparam COM_INIT = 4'h0;
    localparam COM_CONF = 4'h1, COM_READ = 4'h4, COM_STOP = 4'h9;
    localparam COM_DATA = 4'h5, COM_STAT = 4'hA;

    localparam CMD_INIT = 16'h0000;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01;
    localparam READ_IDLE = 8'h40, READ_WAIT = 8'h41, READ_WORK = 8'h42, READ_DONE = 8'h43;
    localparam SEND_IDLE = 8'h80, SEND_WAIT = 8'h81, SEND_WORK = 8'h82, SEND_DONE = 8'h83;

    assign fd_com_send = (state == SEND_DONE);
    assign fs_com_read = (state == READ_IDLE) || (state == READ_WAIT) || (state == READ_WORK);
    assign fs_send = (state == SEND_IDLE) || (state == SEND_WAIT) || (state == SEND_WORK);
    assign fd_read = (state == READ_DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_read) next_state <= READ_IDLE;
                else if(fs_com_send) next_state <= SEND_IDLE;
                else next_state <= MAIN_WAIT;
            end

            READ_IDLE: next_state <= READ_WAIT;
            READ_WAIT: next_state <= READ_WORK;
            READ_WORK: begin
                if(fd_com_read) next_state <= READ_DONE;
                else next_state <= READ_WORK;
            end
            READ_DONE: begin
                if(~fs_read) next_state <= MAIN_WAIT;
                else next_state <= READ_DONE;
            end

            SEND_IDLE: next_state <= SEND_WAIT;
            SEND_WAIT: next_state <= SEND_WORK;
            SEND_WORK: begin
                if(fd_send) next_state <= SEND_DONE;
                else next_state <= SEND_WORK;
            end
            SEND_DONE: begin
                if(~fs_com_send) next_state <= MAIN_WAIT;
                else next_state <= SEND_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_read_btype <= COM_INIT;
        else if(state == MAIN_IDLE) com_read_btype <= COM_INIT;
        else if(state == READ_WAIT) com_read_btype <= read_btype;
        else com_read_btype <= com_read_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) send_btype <= COM_INIT;
        else if(state == MAIN_IDLE) send_btype <= COM_INIT;
        else if(state == SEND_WAIT) send_btype <= com_send_btype;
        else send_btype <= send_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_cmd <= CMD_INIT;
        else if(state == MAIN_IDLE) device_cmd <= CMD_INIT;
        else if(state == READ_WAIT) device_cmd <= com_cmd;
        else device_cmd <= device_cmd;
    end

endmodule