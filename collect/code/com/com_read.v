module com_read(
    input clk,
    input rst,

    output fs_read,
    input fd_read,

    input fs_eth_read,
    output fd_eth_read,

    output reg [3:0] read_btype,
    output reg [15:0] com_cmd,

    output reg [7:0] ram_rxa,
    input [7:0] ram_rxd
);

    localparam DATA_LATENCY = 8'h02;
    localparam RAM_ADDR_INIT = 8'h80;
    localparam RAM_ADDR_TYPE = 8'h85, RAM_ADDR_SAMP = 8'h87;
    localparam RAM_ADDR_LFLT = 8'h89, RAM_ADDR_HFLT = 8'h8B;

    localparam COM_INIT = 4'h0;
    localparam COM_CONF = 4'h1, COM_READ = 4'h4, COM_STOP = 4'h9;
    localparam COM_DATA = 4'h5, COM_STAT = 4'hA;

    localparam NUM = 8'h08;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h01, MAIN_WAIT = 8'h02;
    localparam READ_IDLE = 8'h04, READ_DATA = 8'h08;
    localparam READ_TAKE = 8'h10, READ_WORK = 8'h20;
    localparam READ_DONE = 8'h40;

    reg [7:0] dtype, dsamp, dlflt, dhflt;

    reg [7:0] num;
    
    assign fs_read = (state == READ_DONE);
    assign fd_eth_read = (state == READ_WORK);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_eth_read) next_state <= READ_IDLE;
                else next_state <= MAIN_WAIT;
            end

            READ_IDLE: next_state <= READ_DATA;
            READ_DATA: begin
                if(num >= NUM - 1'b1) next_state <= READ_TAKE;
                else next_state <= READ_DATA;
            end
            READ_TAKE: next_state <= READ_WORK;
            READ_WORK: begin
                if(fd_read) next_state <= READ_DONE;
                else next_state <= READ_WORK;
            end
            READ_DONE: begin
                if(~fs_eth_read) next_state <= MAIN_IDLE;
                else next_state <= READ_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) read_btype <= COM_INIT;
        else if(state == MAIN_IDLE) read_btype <= COM_INIT;
        else if(state == READ_TAKE) read_btype <= ram_rxd[3:0];
        else read_btype <= read_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_cmd <= 16'h0000;
        else if(state == MAIN_IDLE) com_cmd <= 16'h0000;
        else if(state == READ_TAKE) com_cmd <= {dsamp, dlflt, dhflt, 4'h0};
        else com_cmd <= com_cmd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_rxa <= RAM_ADDR_INIT;
        else if(state == MAIN_IDLE) ram_rxa <= RAM_ADDR_INIT;
        else if(state == READ_IDLE) ram_rxa <= RAM_ADDR_INIT;
        else if(state == READ_DATA && num == 8'h00) ram_rxa <= RAM_ADDR_TYPE;
        else if(state == READ_DATA && num == 8'h01) ram_rxa <= RAM_ADDR_SAMP;
        else if(state == READ_DATA && num == 8'h02) ram_rxa <= RAM_ADDR_LFLT;
        else if(state == READ_DATA && num == 8'h03) ram_rxa <= RAM_ADDR_HFLT;
        else ram_rxa <= RAM_ADDR_INIT;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dtype <= {COM_INIT, COM_INIT};
        else if(state == MAIN_IDLE) dtype <= {COM_INIT, COM_INIT};
        else if(state == READ_DATA && num == 8'h01 && DATA_LATENCY == 8'h01) dtype <= ram_rxd;
        else if(state == READ_DATA && num == 8'h02 && DATA_LATENCY == 8'h02) dtype <= ram_rxd;
        else if(state == READ_DATA && num == 8'h03 && DATA_LATENCY == 8'h03) dtype <= ram_rxd;
        else if(state == READ_DATA && num == 8'h04 && DATA_LATENCY == 8'h04) dtype <= ram_rxd;
        else dtype <= dtype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dsamp <= {COM_INIT, COM_INIT};
        else if(state == MAIN_IDLE) dsamp <= {COM_INIT, COM_INIT};
        else if(state == READ_DATA && num == 8'h02 && DATA_LATENCY == 8'h01) dsamp <= ram_rxd;
        else if(state == READ_DATA && num == 8'h03 && DATA_LATENCY == 8'h02) dsamp <= ram_rxd;
        else if(state == READ_DATA && num == 8'h04 && DATA_LATENCY == 8'h03) dsamp <= ram_rxd;
        else if(state == READ_DATA && num == 8'h05 && DATA_LATENCY == 8'h04) dsamp <= ram_rxd;
        else dsamp <= dsamp;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlflt <= {COM_INIT, COM_INIT};
        else if(state == MAIN_IDLE) dlflt <= {COM_INIT, COM_INIT};
        else if(state == READ_DATA && num == 8'h03 && DATA_LATENCY == 8'h01) dlflt <= ram_rxd;
        else if(state == READ_DATA && num == 8'h04 && DATA_LATENCY == 8'h02) dlflt <= ram_rxd;
        else if(state == READ_DATA && num == 8'h05 && DATA_LATENCY == 8'h03) dlflt <= ram_rxd;
        else if(state == READ_DATA && num == 8'h06 && DATA_LATENCY == 8'h04) dlflt <= ram_rxd;
        else dlflt <= dlflt;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dhflt <= {COM_INIT, COM_INIT};
        else if(state == MAIN_IDLE) dhflt <= {COM_INIT, COM_INIT};
        else if(state == READ_DATA && num == 8'h04 && DATA_LATENCY == 8'h01) dhflt <= ram_rxd;
        else if(state == READ_DATA && num == 8'h05 && DATA_LATENCY == 8'h02) dhflt <= ram_rxd;
        else if(state == READ_DATA && num == 8'h06 && DATA_LATENCY == 8'h03) dhflt <= ram_rxd;
        else if(state == READ_DATA && num == 8'h07 && DATA_LATENCY == 8'h04) dhflt <= ram_rxd;
        else dhflt <= dhflt;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == MAIN_IDLE) num <= 8'h00;
        else if(state == READ_DATA) num <= num + 1'b1;
        else num <= 8'h00;
    end




    


endmodule