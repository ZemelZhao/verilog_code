module test_collect(
    input clk_25,
    input clk_50,
    input clk_100,
    input clk_200,
    input clk_400,
    input rst,

    input [3:0] pin_rxd,
    output pin_txd,

    output fire_send,
    input fire_read,
    output reg link
);

    wire fs_send, fd_send;
    wire fs_read, fd_read;
    reg [3:0] send_btype;
    wire [3:0] read_btype;
    wire [31:0] data_cmd, data_stat;
    wire [11:0] read_ram_init;

    wire [7:0] ram_txd, ram_rxd;
    wire [11:0] ram_txa, ram_rxa;
    wire ram_txen;

    wire clk;
    assign clk = clk_50;

    localparam BAG_INIT = 4'b0000;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;


    localparam NUM = 8'h40;

    reg [7:0] state, next_state;

    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_WORK = 8'h07, MAIN_GAP = 8'h08;
    localparam LINK_IDLE = 8'h10;
    localparam TYPE_IDLE = 8'h20, TYPE_WAIT = 8'h21, TYPE_SEND = 8'h22;
    localparam TEMP_IDLE = 8'h30, CONF_WAIT = 8'h31, CONF_SEND = 8'h32;
    localparam DATA_IDLE = 8'h40, DATA_WAIT = 8'h41, DATA_SEND = 8'h42;

    assign fs_send = (state[3:0] == TYPE_SEND[3:0]);
    assign fd_read = (state == MAIN_GAP);
    assign data_cmd = 32'h31243000;

    reg [7:0] num;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_read) next_state <= MAIN_GAP;
                else next_state <= MAIN_WAIT;
            end
            MAIN_GAP: begin
                if(~fs_read) next_state <= MAIN_WORK;
                else next_state <= MAIN_GAP;
            end
            MAIN_WORK: begin
                if(read_btype == BAG_DLINK) next_state <= LINK_IDLE;
                else if(read_btype == BAG_DTYPE) next_state <= TYPE_IDLE;
                else if(read_btype == BAG_DTEMP) next_state <= TEMP_IDLE;
                else if(read_btype == BAG_DATA0) next_state <= DATA_IDLE;
                else if(read_btype == BAG_DATA1) next_state <= DATA_IDLE;
                else next_state <= MAIN_WAIT;
            end

            LINK_IDLE: next_state <= TYPE_WAIT;
            TYPE_WAIT: begin
                if(num >= NUM - 1'b1) next_state <= TYPE_SEND;
                else next_state <= TYPE_WAIT;
            end
            TYPE_SEND: begin
                if(fd_send) next_state <= MAIN_WAIT;
                else next_state <= TYPE_SEND;
            end

            TYPE_IDLE: next_state <= CONF_WAIT;
            CONF_WAIT: begin
                if(num >= NUM - 1'b1) next_state <= CONF_SEND;
                else next_state <= CONF_WAIT;
            end
            CONF_SEND: begin
                if(fd_send) next_state <= MAIN_WAIT;
                else next_state <= CONF_SEND;
            end

            TEMP_IDLE: next_state <= DATA_WAIT;
            DATA_WAIT: begin
                if(num >= NUM - 1'b1) next_state <= DATA_SEND;
                else next_state <= DATA_WAIT;
            end
            DATA_SEND: begin
                if(fd_send) next_state <= MAIN_WAIT;
                else next_state <= DATA_SEND;
            end

            DATA_IDLE: next_state <= DATA_WAIT;

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) link <= 1'b0;
        else if(state == MAIN_IDLE) link <= 1'b0;
        else if(state == LINK_IDLE) link <= 1'b1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) send_btype <= BAG_INIT;
        else if(state == LINK_IDLE) send_btype <= BAG_DIDX;
        else if(state == TYPE_IDLE) send_btype <= BAG_DPARAM;
        else if(state == TEMP_IDLE) send_btype <= BAG_DDIDX;
        else if(state == DATA_IDLE) send_btype <= BAG_DDIDX;
        else send_btype <= send_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state[3:0] == DATA_WAIT[3:0]) num <= num + 1'b1;
        else num <= 8'h00;
    end





    



    usb
    usb_dut(
        .sys_clk(clk_50),
        .usb_txc(clk_25),
        .usb_rxc(clk_50),
        .pin_txc(clk_200),
        .pin_rxc(clk_100),
        .pin_cc(clk_400),

        .rst(rst),

        .pin_rxd(pin_rxd),
        .pin_txd(pin_txd),
        .fire_send(fire_send),
        .fire_read(fire_read),

        .fs_send(fs_send),
        .send_btype(send_btype),
        .fd_send(fd_send),
        .data_cmd(data_cmd),

        .fs_read(fs_read),
        .read_btype(read_btype),
        .read_ram_init(read_ram_init),
        .fd_read(fd_read),
        .data_stat(data_stat),

        .ram_txd(ram_txd),
        .ram_txa(ram_txa),
        .ram_txen(ram_txen)
    );



endmodule