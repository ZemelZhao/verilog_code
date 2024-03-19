module tb_com_rx(
    input clk_25,
    input clk_50,
    input clk_100, 
    input clk_200,
    input rst
);

    wire clk;
    assign clk = clk_50;

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h07, DONE = 8'h08;
    localparam ACK_IDLE = 8'h10, ACK_WORK = 8'h11, ACK_WAIT = 8'h12;
    localparam ACK_READ = 8'h13, ACK_DONE = 8'h14;
    localparam NAK_IDLE = 8'h20, NAK_WORK = 8'h21, NAK_WAIT = 8'h22;
    localparam NAK_READ = 8'h23, NAK_DONE = 8'h24;
    localparam STL_IDLE = 8'h30, STL_WORK = 8'h31, STL_WAIT = 8'h32;
    localparam STL_READ = 8'h33, STL_DONE = 8'h34;
    localparam DIDX_IDLE = 8'h40, DIDX_WORK = 8'h41, DIDX_WAIT = 8'h42;
    localparam DIDX_READ = 8'h43, DIDX_DONE = 8'h44;
    localparam DDIDX_IDLE = 8'h50, DDIDX_WORK = 8'h51, DDIDX_WAIT = 8'h52;
    localparam DDIDX_READ = 8'h53, DDIDX_DONE = 8'h54;
    localparam DPARAM_IDLE = 8'h60, DPARAM_WORK = 8'h61, DPARAM_WAIT = 8'h62;
    localparam DPARAM_READ = 8'h63, DPARAM_DONE = 8'h64;

    wire [31:0] usb_data_cmd, com_data_cmd;
    wire fs_usb_tx, fd_usb_tx;
    wire fs_com_rx, fd_com_rx;
    wire [7:0] usb_txd, com_rxd;
    reg [3:0] tx_btype;
    wire [3:0] rx_btype;
    wire pin_txd, pin_rxd;
    wire fire;

    assign pin_rxd = pin_txd;
    assign usb_data_cmd = 32'h2E213000;
    assign fs_usb_tx = (state[3:0] == ACK_WORK[3:0]);
    assign fd_com_rx = (state[3:0] == ACK_READ[3:0]);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= ACK_IDLE;
            DONE: next_state <= WAIT;

            ACK_IDLE: next_state <= ACK_WORK;
            ACK_WORK: begin
                if(fd_usb_tx) next_state <= ACK_WAIT;
                else next_state <= ACK_WORK;
            end
            ACK_WAIT: begin
                if(fs_com_rx) next_state <= ACK_READ;
                else next_state <= ACK_WAIT;
            end
            ACK_READ: begin
                if(~fs_com_rx) next_state <= ACK_DONE;
                else next_state <= ACK_READ;
            end
            ACK_DONE: next_state <= NAK_IDLE;

            NAK_IDLE: next_state <= NAK_WORK;
            NAK_WORK: begin
                if(fd_usb_tx) next_state <= NAK_WAIT;
                else next_state <= NAK_WORK;
            end
            NAK_WAIT: begin
                if(fs_com_rx) next_state <= NAK_READ;
                else next_state <= NAK_WAIT;
            end
            NAK_READ: begin
                if(~fs_com_rx) next_state <= NAK_DONE;
                else next_state <= NAK_READ;
            end
            NAK_DONE: next_state <= STL_IDLE;
                
            STL_IDLE: next_state <= STL_WORK;
            STL_WORK: begin
                if(fd_usb_tx) next_state <= STL_WAIT;
                else next_state <= STL_WORK;
            end
            STL_WAIT: begin
                if(fs_com_rx) next_state <= STL_READ;
                else next_state <= STL_WAIT;
            end
            STL_READ: begin
                if(~fs_com_rx) next_state <= STL_DONE;
                else next_state <= STL_READ;
            end
            STL_DONE: next_state <= DIDX_IDLE;
                
            DIDX_IDLE: next_state <= DIDX_WORK;
            DIDX_WORK: begin
                if(fd_usb_tx) next_state <= DIDX_WAIT;
                else next_state <= DIDX_WORK;
            end
            DIDX_WAIT: begin
                if(fs_com_rx) next_state <= DIDX_READ;
                else next_state <= DIDX_WAIT;
            end
            DIDX_READ: begin
                if(~fs_com_rx) next_state <= DIDX_DONE;
                else next_state <= DIDX_READ;
            end
            DIDX_DONE: next_state <= DDIDX_IDLE;
                
            DDIDX_IDLE: next_state <= DDIDX_WORK;
            DDIDX_WORK: begin
                if(fd_usb_tx) next_state <= DDIDX_WAIT;
                else next_state <= DDIDX_WORK;
            end
            DDIDX_WAIT: begin
                if(fs_com_rx) next_state <= DDIDX_READ;
                else next_state <= DDIDX_WAIT;
            end
            DDIDX_READ: begin
                if(~fs_com_rx) next_state <= DDIDX_DONE;
                else next_state <= DDIDX_READ;
            end
            DDIDX_DONE: next_state <= DPARAM_IDLE;
                
            DPARAM_IDLE: next_state <= DPARAM_WORK;
            DPARAM_WORK: begin
                if(fd_usb_tx) next_state <= DPARAM_WAIT;
                else next_state <= DPARAM_WORK;
            end
            DPARAM_WAIT: begin
                if(fs_com_rx) next_state <= DPARAM_READ;
                else next_state <= DPARAM_WAIT;
            end
            DPARAM_READ: begin
                if(~fs_com_rx) next_state <= DPARAM_DONE;
                else next_state <= DPARAM_READ;
            end
            DPARAM_DONE: next_state <= DONE;

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) tx_btype <= BAG_INIT;
        else if(state == IDLE) tx_btype <= BAG_INIT;
        else if(state == WAIT) tx_btype <= BAG_INIT;
        else if(state == DONE) tx_btype <= BAG_INIT;
        else if(state == ACK_IDLE) tx_btype <= BAG_ACK;
        else if(state == NAK_IDLE) tx_btype <= BAG_NAK;
        else if(state == STL_IDLE) tx_btype <= BAG_STL;
        else if(state == DIDX_IDLE) tx_btype <= BAG_DIDX;
        else if(state == DDIDX_IDLE) tx_btype <= BAG_DDIDX;
        else if(state == DPARAM_IDLE) tx_btype <= BAG_DPARAM;
        else tx_btype <= tx_btype;
    end

    usb_txf
    usb_txf_dut(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_usb_tx),

        .fire(fire),
        .din(usb_txd),
        .dout(pin_txd)
    );

    com_rxf
    com_rxf_dut(
        .clk(clk_200),
        .rst(rst),

        .din(pin_rxd),
        .dout(com_rxd),
        .fire(fire)
    );


    usb_tx
    usb_tx_dut(
        .clk(clk_25),
        .rst(rst),

        .fs(fs_usb_tx),
        .fd(fd_usb_tx),

        .btype(tx_btype),
        .data_cmd(usb_data_cmd),

        .usb_txd(usb_txd)
    );



    com_rx
    com_rx_dut(
        .clk(clk_25),
        .rst(rst),

        .fs(fs_com_rx),
        .fd(fd_com_rx),

        .com_rxd(com_rxd),

        .btype(rx_btype),
        .data_cmd(com_data_cmd)
    );






endmodule