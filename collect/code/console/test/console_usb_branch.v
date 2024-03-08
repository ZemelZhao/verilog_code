module console_usb_branch(
    input clk,
    input rst,

    input fs_cs_send,
    output fd_cs_send,
    output fs_cs_read,
    input fd_cs_read,

    output fs_usb_send,
    input fd_usb_send,
    input fs_usb_read,
    output fd_usb_read,

    output stat,
    input [3:0] device_idx,
    input [3:0] data_idx,
    input [3:0] send_cs_btype,
    input [3:0] read_cs_btype,
    input [15:0] conf_cmd,

    output reg [3:0] send_usb_btype,
    input [3:0] read_usb_btype,

    output reg [31:0] cache_cmd
);

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;
    localparam BAG_ERROR = 4'b1111;

    localparam RAM_ADDR_DATA0 = 12'h000, RAM_ADDR_DATA1 = 12'h240, RAM_ADDR_DATA2 = 12'h480;
    localparam RAM_ADDR_DATA3 = 12'h6C0, RAM_ADDR_DATA4 = 12'h900, RAM_ADDR_DATA5 = 12'hB40;
    localparam RAM_ADDR_INIT = 12'hF00;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_WORK = 8'h02;
    localparam MAIN_READ = 8'h04;
    localparam MAIN_TX_DONE = 8'h08, MAIN_RX_DONE = 8'h09;
    localparam INIT_IDLE = 8'h10, INIT_WAIT = 8'h11, INIT_WORK = 8'h12;
    localparam LINK_DONE = 8'h20;
    localparam TYPE_IDLE = 8'h30, TYPE_WORK = 8'h31, TYPE_DONE = 8'h32;
    localparam CONF_IDLE = 8'h40, CONF_WAIT = 8'h41, CONF_DONE = 8'h42;
    localparam CONF_SEND = 8'h44, CONF_READ = 8'h45;
    localparam CONV_IDLE = 8'h50, CONV_WAIT = 8'h51, CONV_DONE = 8'h52;
    localparam CONV_SEND = 8'h54, CONV_READ = 8'h55;

    reg [1:0] device_stat;
    assign stat = (device_stat == 2'b11);

    assign fd_cs_send = (state == MAIN_TX_DONE);
    assign fs_cs_read = (state == MAIN_RX_DONE);
    assign fs_usb_send = (state == CONF_SEND) || (state == CONV_SEND) || (state == TYPE_WORK);
    assign fd_usb_read = (state == INIT_WAIT) || (state == CONF_WAIT) || (state == CONV_WAIT);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= INIT_IDLE;
            MAIN_WAIT: begin
                if(fs_cs_send) next_state <= MAIN_WORK;
                else if(fs_usb_read) next_state <= MAIN_READ;
                else next_state <= MAIN_WAIT;
            end
            MAIN_WORK: begin
                if(send_cs_btype == BAG_DPARAM) next_state <= CONF_IDLE;
                else if(send_cs_btype == BAG_DIDX) next_state <= CONV_IDLE;
                else next_state <= MAIN_WAIT;
            end
            MAIN_READ: begin
                if(read_cs_btype == BAG_DTEMP) next_state <= CONF_READ;
                else next_state <= CONV_READ;
            end
            MAIN_TX_DONE: begin
                if(~fs_cs_send) next_state <= MAIN_WAIT;
                else next_state <= MAIN_TX_DONE;
            end
            MAIN_RX_DONE: begin
                if(fd_cs_read) next_state <= MAIN_WAIT;
                else next_state <= MAIN_RX_DONE;
            end

            INIT_IDLE: begin
                if(fs_usb_read) next_state <= INIT_WAIT;
                else next_state <= INIT_IDLE;
            end
            INIT_WAIT: begin
                if(~fs_usb_read) next_state <= INIT_WORK;
                else next_state <= INIT_WAIT;
            end
            INIT_WORK: begin
                if(read_usb_btype == BAG_DLINK) next_state <= LINK_DONE;
                else if(read_usb_btype == BAG_DTYPE) next_state <= TYPE_DONE;
                else next_state <= INIT_WORK;
            end

            LINK_DONE: next_state <= TYPE_IDLE;
            TYPE_IDLE: next_state <= TYPE_WORK;
            TYPE_WORK: begin
                if(fd_usb_send) next_state <= INIT_WAIT;
                else next_state <= TYPE_WORK;
            end

            TYPE_DONE: next_state <= MAIN_WAIT;

            CONF_IDLE: next_state <= CONF_SEND;
            CONF_SEND: begin
                if(fd_usb_send) next_state <= MAIN_TX_DONE;
                else next_state <= CONF_SEND;
            end
            CONF_READ: next_state <= CONF_WAIT;
            CONF_WAIT: begin
                if(~fs_usb_read) next_state <= CONF_DONE;
                else next_state <= CONF_WAIT;
            end
            CONF_DONE: next_state <= MAIN_RX_DONE;

            CONV_IDLE: next_state <= CONV_SEND;
            CONV_SEND: begin
                if(fd_usb_send) next_state <= MAIN_TX_DONE;
                else next_state <= CONV_SEND;
            end
            CONV_READ: begin
                if(read_usb_btype == BAG_DATA0) next_state <= CONV_WAIT;
                else if(read_usb_btype == BAG_DATA1) next_state <= CONV_WAIT;
                else next_state <= CONV_READ;
            end
            CONV_WAIT: begin
                if(~fs_usb_read) next_state <= CONV_DONE;
                else next_state <= CONV_WAIT;
            end
            CONV_DONE: next_state <= MAIN_RX_DONE;

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) send_usb_btype <= BAG_INIT;
        else if(state == TYPE_IDLE) send_usb_btype <= BAG_DDIDX;
        else if(state == CONF_IDLE) send_usb_btype <= BAG_DPARAM;
        else if(state == CONV_IDLE) send_usb_btype <= BAG_DIDX;
        else send_usb_btype <= send_usb_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cache_cmd <= 32'h00000000;
        else if(state == TYPE_IDLE) cache_cmd <= {device_idx, 28'h00};
        else if(state == CONF_IDLE) cache_cmd <= {device_idx, 4'h0, conf_cmd, 8'h00};
        else if(state == CONV_IDLE) cache_cmd <= {device_idx, data_idx, conf_cmd, 8'h00};
        else cache_cmd <= cache_cmd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_stat <= 2'b00;
        else if(state == MAIN_IDLE) device_stat <= 2'b00;
        else if(state == LINK_DONE) device_stat[1] <= 1'b1;
        else if(state == TYPE_DONE) device_stat[0] <= 1'b1;
        else device_stat <= device_stat;
    end






endmodule