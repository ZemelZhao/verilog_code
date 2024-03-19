module com_test(
    input sys_clk,
    input rst,

    input fs_send,
    output fd_send,
    input [3:0] send_btype,

    output fs_read,
    input fd_read,

    output [31:0] cache_cmd,
    output reg [3:0] read_btype
);

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;
    localparam BAG_ERROR = 4'b1111;

    localparam FS_1KHZ = 3'h1, FS_2KHZ = 3'h2, FS_4KHZ = 3'h3; 
    localparam FS_8KHZ = 3'h4, FS_16KHZ = 3'h5;

    localparam FILTUP_20K = 4'h1, FILTUP_15K = 4'h2, FILTUP_10K = 4'h3, FILTUP_7K5 = 4'h4;
    localparam FILTUP_5K0 = 4'h5, FILTUP_3K0 = 4'h6, FILTUP_2K5 = 4'h7, FILTUP_2K0 = 4'h8;
    localparam FILTUP_1K5 = 4'h9, FILTUP_1K0 = 4'hA, FILTUP_750 = 4'hB, FILTUP_500 = 4'hC;
    localparam FILTUP_300 = 4'hD, FILTUP_200 = 4'hE, FILTUP_100 = 4'hF;

    localparam FILTLOW_100 = 4'h1, FILTLOW_020 = 4'h2, FILTLOW_015 = 4'h3, FILTLOW_010 = 4'h4;
    localparam FILTLOW_7D5 = 4'h5, FILTLOW_5D0 = 4'h6, FILTLOW_3D0 = 4'h7, FILTLOW_2D5 = 4'h8;
    localparam FILTLOW_2D0 = 4'h9, FILTLOW_1D0 = 4'hA, FILTLOW_D75 = 4'hB, FILTLOW_D50 = 4'hC;
    localparam FILTLOW_D30 = 4'hD, FILTLOW_D25 = 4'hE, FILTLOW_D10 = 4'hF;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h04, WAIT = 8'h05, WORK = 8'h06;
    localparam DIDX_IDLE = 8'h10, DIDX_WAIT = 8'h11, DIDX_WORK = 8'h12, DIDX_DONE = 8'h13;
    localparam CONF_IDLE = 8'h20, CONF_WAIT = 8'h21, CONF_WORK = 8'h22, CONF_DONE = 8'h23;
    localparam DATA_IDLE = 8'h30, DATA_WAIT = 8'h31, DATA_WORK = 8'h32, DATA_DONE = 8'h33;

    localparam ANUM = 16'h100, BNUM = 16'h100, CNUM = 16'd6250;

    wire clk;
    reg [15:0] num;
    wire [3:0] freq_samp, filt_up, filt_low;

    assign freq_samp = FS_8KHZ;
    assign filt_up = FILTUP_10K;
    assign filt_low = FILTLOW_020;
    assign device_idx = 4'h2;
    assign data_idx = 4'h3;
    assign cache_cmd = {device_idx, data_idx, freq_samp, filt_up, filt_low, 12'h000};

    assign fd_send = (state[3:0] == DIDX_IDLE[3:0]);
    assign fs_read = (state[3:0] == DIDX_DONE[3:0]);
    assign clk = sys_clk;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs_send) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(send_btype == BAG_DLINK) next_state <= DIDX_IDLE;
                else if(send_btype == BAG_DTYPE) next_state <= CONF_IDLE;
                else if(send_btype == BAG_DTEMP) next_state <= DATA_IDLE;
                else if(send_btype == BAG_DATA0) next_state <= DATA_IDLE;
                else if(send_btype == BAG_DATA1) next_state <= DATA_IDLE;
                else next_state <= DATA_IDLE;
            end

            DIDX_IDLE: begin
                if(~fs_send) next_state <= DIDX_WAIT;
                else next_state <= DIDX_IDLE;
            end
            DIDX_WAIT: begin
                if(num >= ANUM - 1'b1) next_state <= DIDX_WORK;
                else next_state <= DIDX_WAIT;
            end
            DIDX_WORK: next_state <= DIDX_DONE;
            DIDX_DONE: begin
                if(fd_read) next_state <= WAIT;
                else next_state <= DIDX_DONE;
            end

            CONF_IDLE: begin
                if(~fs_send) next_state <= CONF_WAIT;
                else next_state <= CONF_IDLE;
            end
            CONF_WAIT: begin
                if(num >= BNUM - 1'b1) next_state <= CONF_WORK;
                else next_state <= CONF_WAIT;
            end
            CONF_WORK: next_state <= CONF_DONE;
            CONF_DONE: begin
                if(fd_read) next_state <= WAIT;
                else next_state <= CONF_DONE;
            end

            DATA_IDLE: begin
                if(~fs_send) next_state <= DATA_WAIT;
                else next_state <= DATA_IDLE;
            end
            DATA_WAIT: begin
                if(num >= CNUM - 1'b1) next_state <= DATA_WORK;
                else next_state <= DATA_WAIT;
            end
            DATA_WORK: next_state <= DATA_DONE;
            DATA_DONE: begin
                if(fd_read) next_state <= WAIT;
                else next_state <= DATA_DONE;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) read_btype <= BAG_INIT;
        else if(state == IDLE) read_btype <= BAG_INIT;
        else if(state == DIDX_WORK) read_btype <= BAG_DIDX;
        else if(state == CONF_WORK) read_btype <= BAG_DPARAM;
        else if(state == DATA_WORK) read_btype <= BAG_DDIDX;
        else read_btype <= read_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 16'h0000;
        else if(state == IDLE) num <= 16'h0000;
        else if(state == DIDX_WAIT) num <= num + 1'b1;
        else if(state == CONF_WAIT) num <= num + 1'b1;
        else if(state == DATA_WAIT) num <= num + 1'b1;
        else num <= 16'h0000;
    end









endmodule