module console_usb_core(
    input clk,
    input rst,

    input fs_conf,
    output fd_conf,
    input fs_conv,
    output fd_conv,

    output fs_send,
    input [0:7] fd_send,
    input [0:7] fs_read,
    output fd_read,

    output reg [3:0] send_btype,
    output reg [3:0] read_btype,

    output reg [3:0] data_idx,
    output [31:0] device_idx
);

    localparam DATA_IDX = 4'h5;
    localparam DEVICE_IDX = 32'h13579BDF;
    localparam LINK_NUM = 32'd7_500_000;

    reg [31:0] num;

    (*MARK_DEBUG = "true"*)reg [19:0] state; 
    reg [19:0] next_state;
    localparam MAIN_IDLE = 20'h00001, MAIN_WAIT = 20'h00002;
    localparam CONF_IDLE = 20'h00010, CONF_WAIT = 20'h00020, CONF_WORK = 20'h00040, CONF_DONE = 20'h00080;
    localparam CONV_IDLE = 20'h00100, CONV_WAIT = 20'h00200, CONV_WORK = 20'h00400, CONV_DONE = 20'h00800;
    localparam READ_IDLE = 20'h01000, READ_WAIT = 20'h02000, READ_WORK = 20'h04000, READ_DONE = 20'h08000;
    localparam LINK_IDLE = 20'h10000, LINK_WAIT = 20'h20000, LINK_WORK = 20'h40000, LINK_DONE = 20'h80000;

    localparam BAG_INIT = 4'b0000;
    localparam BAG_DCONF = 4'b0001, BAG_DCONV = 4'b1001, BAG_CLINK = 4'b1011;
    localparam BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010, BAG_DATA = 4'b0101;

    assign fd_conf = (state == CONF_DONE);
    assign fd_conv = (state == CONV_DONE);
    assign fs_send = (state == CONF_WORK) || (state == CONV_WORK) || (state == LINK_WORK);
    assign fd_read = (state == READ_DONE);
    assign device_idx = DEVICE_IDX;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_conf) next_state <= CONF_IDLE;
                else if(fs_conv) next_state <= CONV_IDLE;
                else if(fs_read == 8'hFF) next_state <= READ_IDLE;
                else if(num == LINK_NUM - 1'b1) next_state <= LINK_IDLE;
                else next_state <= MAIN_WAIT;
            end

            LINK_IDLE: next_state <= LINK_WAIT;
            LINK_WAIT: next_state <= LINK_WORK;
            LINK_WORK: begin
                if(fd_send == 8'hFF) next_state <= LINK_DONE;
                else next_state <= LINK_WORK;
            end
            LINK_DONE: next_state <= MAIN_WAIT;

            CONF_IDLE: next_state <= CONF_WAIT;
            CONF_WAIT: next_state <= CONF_WORK;
            CONF_WORK: begin
                if(fd_send == 8'hFF) next_state <= CONF_DONE;
                else next_state <= CONF_WORK;
            end
            CONF_DONE: begin
                if(~fs_conf) next_state <= MAIN_WAIT;
                else next_state <= CONF_DONE;
            end 

            CONV_IDLE: next_state <= CONV_WAIT;
            CONV_WAIT: next_state <= CONV_WORK;
            CONV_WORK: begin
                if(fd_send == 8'hFF) next_state <= CONV_DONE;
                else next_state <= CONV_WORK;
            end
            CONV_DONE: begin
                if(~fs_conv) next_state <= MAIN_WAIT;
                else next_state <= CONV_DONE;
            end

            READ_IDLE: next_state <= READ_WAIT;
            READ_WAIT: next_state <= READ_WORK;
            READ_WORK: next_state <= READ_DONE;
            READ_DONE: begin
                if(fs_read == 8'h00) next_state <= MAIN_WAIT;
                else next_state <= READ_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_idx <= DATA_IDX;
        else if(state == CONV_WAIT && data_idx == DATA_IDX) data_idx <= 4'h0;
        else if(state == CONV_WAIT) data_idx <= data_idx + 1'b1;
        else data_idx <= data_idx;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) send_btype <= BAG_INIT;
        else if(state == CONF_WAIT) send_btype <= BAG_DCONF;
        else if(state == CONV_WAIT) send_btype <= BAG_DCONV;
        else if(state == LINK_WAIT) send_btype <= BAG_CLINK;
        else send_btype <= send_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) read_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) read_btype <= BAG_DTYPE;
        else if(state == CONF_WAIT) read_btype <= BAG_DTEMP;
        else if(state == CONV_WAIT) read_btype <= BAG_DATA;
        else read_btype <= read_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 32'h0000;
        else if(state == MAIN_WAIT) num <= num + 1'b1;
        else num <= 32'h0000;
    end

endmodule