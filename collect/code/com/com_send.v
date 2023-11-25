module con_send(
    input clk,
    input rst,

    input fs_send,
    output fd_send,

    output fs_eth_send,
    input fd_eth_send,

    input [3:0] send_btype,

    input [95:0] cache_info,
    input [3:0] data_idx,

    output reg [15:0] ram_rxa_init,
    output reg [15:0] ram_dlen
);

    localparam COM_INIT = 4'h0;
    localparam COM_CONF = 4'h1, COM_READ = 4'h4, COM_STOP = 4'h9;
    localparam COM_DATA = 4'h5, COM_STAT = 4'hA;

    localparam STAT_LEN = 16'h0E, HEAD_LEN = 16'h04;
    localparam DATA_LEN_00 = 16'h0000;
    localparam DATA_LEN_01 = 16'h0080;
    localparam DATA_LEN_10 = 16'h0100;
    localparam DATA_LEN_11 = 16'h0200;

    localparam COM_RAM_ADDR_DATA0 = 16'h0000, COM_RAM_ADDR_DATA1 = 16'h2400;
    localparam COM_RAM_ADDR_DATA2 = 16'h4800, COM_RAM_ADDR_DATA3 = 16'h6C00;
    localparam COM_RAM_ADDR_DATA4 = 16'h9000, COM_RAM_ADDR_DATA5 = 16'hB400;
    localparam COM_RAM_ADDR_STAT = 16'h2300, COM_RAM_ADDR_INIT = 16'hF000;

    wire [0:15] device_type;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h01, WAIT = 8'h02, CAL0 = 8'h04, CAL1 = 8'h08;
    localparam WORK = 8'h10, DONE = 8'h20;

    reg [15:0] dlen0, dlen1, dlen2, dlen3;
    reg [15:0] dlen4, dlen5, dlen6, dlen7;
    
    assign device_type = cache_info[79:64];
    assign fs_eth_send = (state == WORK); 
    assign fd_send = (state == DONE);


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs_send) next_state <= CAL0;
                else next_state <= WAIT;
            end
            CAL0: next_state <= CAL1;
            CAL1: next_state <= WORK;
            WORK: begin
                if(fd_eth_send) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: begin
                if(~fs_send) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_rxa_init <= COM_RAM_ADDR_INIT;
        else if(state == CAL1 && send_btype == COM_STAT) ram_rxa_init <= COM_RAM_ADDR_STAT;
        else if(state == CAL1 && send_btype == COM_DATA && data_idx == 4'h0) ram_rxa_init <= COM_RAM_ADDR_DATA0;
        else if(state == CAL1 && send_btype == COM_DATA && data_idx == 4'h1) ram_rxa_init <= COM_RAM_ADDR_DATA1;
        else if(state == CAL1 && send_btype == COM_DATA && data_idx == 4'h2) ram_rxa_init <= COM_RAM_ADDR_DATA2;
        else if(state == CAL1 && send_btype == COM_DATA && data_idx == 4'h3) ram_rxa_init <= COM_RAM_ADDR_DATA3;
        else if(state == CAL1 && send_btype == COM_DATA && data_idx == 4'h4) ram_rxa_init <= COM_RAM_ADDR_DATA4;
        else if(state == CAL1 && send_btype == COM_DATA && data_idx == 4'h5) ram_rxa_init <= COM_RAM_ADDR_DATA5;
        else if(state == CAL1) ram_rxa_init <= COM_RAM_ADDR_INIT;
        else ram_rxa_init <= ram_rxa_init;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_dlen <= 16'h0000;
        else if(state == IDLE) ram_dlen <= 16'h0000;
        else if(state == CAL1 && send_btype == COM_STAT) ram_dlen <= STAT_LEN;
        else if(state == CAL1 && send_btype == COM_DATA) ram_dlen <= HEAD_LEN + dlen0 + dlen1 + dlen2 + dlen3 + dlen4 + dlen5 + dlen6 + dlen7;
        else ram_dlen <= ram_dlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen0 <= DATA_LEN_00;
        else if(state == IDLE) dlen0 <= DATA_LEN_00;
        else if(state == CAL0 && device_type[0:1] == 2'b00) dlen0 <= DATA_LEN_00; 
        else if(state == CAL0 && device_type[0:1] == 2'b01) dlen0 <= DATA_LEN_01; 
        else if(state == CAL0 && device_type[0:1] == 2'b10) dlen0 <= DATA_LEN_10; 
        else if(state == CAL0 && device_type[0:1] == 2'b11) dlen0 <= DATA_LEN_11; 
        else if(state == CAL0) dlen0 <= DATA_LEN_00;
        else dlen0 <= dlen0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen1 <= DATA_LEN_00;
        else if(state == IDLE) dlen1 <= DATA_LEN_00;
        else if(state == CAL0 && device_type[2:3] == 2'b00) dlen1 <= DATA_LEN_00; 
        else if(state == CAL0 && device_type[2:3] == 2'b01) dlen1 <= DATA_LEN_01; 
        else if(state == CAL0 && device_type[2:3] == 2'b10) dlen1 <= DATA_LEN_10; 
        else if(state == CAL0 && device_type[2:3] == 2'b11) dlen1 <= DATA_LEN_11; 
        else if(state == CAL0) dlen1 <= DATA_LEN_00;
        else dlen1 <= dlen1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen2 <= DATA_LEN_00;
        else if(state == IDLE) dlen2 <= DATA_LEN_00;
        else if(state == CAL0 && device_type[4:5] == 2'b00) dlen2 <= DATA_LEN_00; 
        else if(state == CAL0 && device_type[4:5] == 2'b01) dlen2 <= DATA_LEN_01; 
        else if(state == CAL0 && device_type[4:5] == 2'b10) dlen2 <= DATA_LEN_10; 
        else if(state == CAL0 && device_type[4:5] == 2'b11) dlen2 <= DATA_LEN_11; 
        else if(state == CAL0) dlen2 <= DATA_LEN_00;
        else dlen2 <= dlen2;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen3 <= DATA_LEN_00;
        else if(state == IDLE) dlen3 <= DATA_LEN_00;
        else if(state == CAL0 && device_type[6:7] == 2'b00) dlen3 <= DATA_LEN_00; 
        else if(state == CAL0 && device_type[6:7] == 2'b01) dlen3 <= DATA_LEN_01; 
        else if(state == CAL0 && device_type[6:7] == 2'b10) dlen3 <= DATA_LEN_10; 
        else if(state == CAL0 && device_type[6:7] == 2'b11) dlen3 <= DATA_LEN_11; 
        else if(state == CAL0) dlen3 <= DATA_LEN_00;
        else dlen3 <= dlen3;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen4 <= DATA_LEN_00;
        else if(state == IDLE) dlen4 <= DATA_LEN_00;
        else if(state == CAL0 && device_type[8:9] == 2'b00) dlen4 <= DATA_LEN_00; 
        else if(state == CAL0 && device_type[8:9] == 2'b01) dlen4 <= DATA_LEN_01; 
        else if(state == CAL0 && device_type[8:9] == 2'b10) dlen4 <= DATA_LEN_10; 
        else if(state == CAL0 && device_type[8:9] == 2'b11) dlen4 <= DATA_LEN_11; 
        else if(state == CAL0) dlen4 <= DATA_LEN_00;
        else dlen4 <= dlen4;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen5 <= DATA_LEN_00;
        else if(state == IDLE) dlen5 <= DATA_LEN_00;
        else if(state == CAL0 && device_type[10:11] == 2'b00) dlen5 <= DATA_LEN_00; 
        else if(state == CAL0 && device_type[10:11] == 2'b01) dlen5 <= DATA_LEN_01; 
        else if(state == CAL0 && device_type[10:11] == 2'b10) dlen5 <= DATA_LEN_10; 
        else if(state == CAL0 && device_type[10:11] == 2'b11) dlen5 <= DATA_LEN_11; 
        else if(state == CAL0) dlen5 <= DATA_LEN_00;
        else dlen5 <= dlen5;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen6 <= DATA_LEN_00;
        else if(state == IDLE) dlen6 <= DATA_LEN_00;
        else if(state == CAL0 && device_type[12:13] == 2'b00) dlen6 <= DATA_LEN_00; 
        else if(state == CAL0 && device_type[12:13] == 2'b01) dlen6 <= DATA_LEN_01; 
        else if(state == CAL0 && device_type[12:13] == 2'b10) dlen6 <= DATA_LEN_10; 
        else if(state == CAL0 && device_type[12:13] == 2'b11) dlen6 <= DATA_LEN_11; 
        else if(state == CAL0) dlen6 <= DATA_LEN_00;
        else dlen6 <= dlen6;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen7 <= DATA_LEN_00;
        else if(state == IDLE) dlen7 <= DATA_LEN_00;
        else if(state == CAL0 && device_type[14:15] == 2'b00) dlen7 <= DATA_LEN_00; 
        else if(state == CAL0 && device_type[14:15] == 2'b01) dlen7 <= DATA_LEN_01; 
        else if(state == CAL0 && device_type[14:15] == 2'b10) dlen7 <= DATA_LEN_10; 
        else if(state == CAL0 && device_type[14:15] == 2'b11) dlen7 <= DATA_LEN_11; 
        else if(state == CAL0) dlen7 <= DATA_LEN_00;
        else dlen7 <= dlen7;
    end












endmodule
