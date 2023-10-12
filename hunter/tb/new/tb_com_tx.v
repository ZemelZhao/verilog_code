module tb_com_tx(
    input clk_25,
    input clk_50,
    input clk_100, 
    input clk_200,
    input rst
);

    wire clk;

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h02, RAM_TX = 8'h03;
    localparam COM_IDLE = 8'h10;
    localparam ACK_IDLE = 8'h20, ACK_WORK = 8'h21, ACK_DONE = 8'h22;
    localparam ACK_WAIT = 8'h23, ACK_READ = 8'h24;
    localparam NAK_IDLE = 8'h30, NAK_WORK = 8'h31, NAK_DONE = 8'h32;
    localparam NAK_WAIT = 8'h33, NAK_READ = 8'h34;
    localparam STL_IDLE = 8'h40, STL_WORK = 8'h41, STL_DONE = 8'h42;
    localparam STL_WAIT = 8'h43, STL_READ = 8'h44;
    localparam DLINK_IDLE = 8'h50, DLINK_WORK = 8'h51, DLINK_DONE = 8'h52;
    localparam DLINK_WAIT = 8'h53, DLINK_READ = 8'h54;
    localparam DTYPE_IDLE = 8'h60, DTYPE_WORK = 8'h61, DTYPE_DONE = 8'h62;
    localparam DTYPE_WAIT = 8'h63, DTYPE_READ = 8'h64;
    localparam DTEMP_IDLE = 8'h70, DTEMP_WORK = 8'h71, DTEMP_DONE = 8'h72;
    localparam DTEMP_WAIT = 8'h73, DTEMP_READ = 8'h74;
    localparam DATA0_IDLE = 8'h80, DATA0_WORK = 8'h81, DATA0_DONE = 8'h82;
    localparam DATA0_WAIT = 8'h83, DATA0_READ = 8'h84;
    localparam DATA1_IDLE = 8'h90, DATA1_WORK = 8'h91, DATA1_DONE = 8'h92;
    localparam DATA1_WAIT = 8'h93, DATA1_READ = 8'h94;

    wire fs_com_tx, fd_com_tx;
    wire fs_usb_rx, fd_usb_rx;
    wire fs_init, fd_init;
    wire fs_type, fd_type;
    wire fs_conf, fd_conf;
    wire fs_conv, fd_conv;
    wire fs_tran, fd_tran;

    reg [3:0] tx_btype;
    wire [11:0] ram_tinit, ram_tlen;
    reg [11:0] ram_rinit, ram_rlen;

    wire [7:0] ram_rxd, ram_txd;
    wire [11:0] ram_rxa, ram_txa;
    wire ram_txen;
    wire [11:0] ram_addr_init;
    wire [7:0] com_txd;
    wire [31:0] com_data_cmd;
    wire [31:0] com_data_stat;

    reg [11:0] ram_dlen; // 

    wire [7:0] usb_rxd;
    wire [3:0] usb_rx_btype;
    wire [31:0] usb_data_stat;
    wire [7:0] usb_ram_txd;
    wire [11:0] usb_ram_txa;
    wire usb_ram_txen;

    wire [7:0] fifo_rxen;
    wire [63:0] fifo_rxd;

    wire fire;
    wire [3:0] pin_txd, pin_rxd;

    assign clk = clk_50;
    assign fs_tran = (state[3:0] == ACK_WORK[3:0]);
    assign fs_com_tx = (state[3:0] == ACK_WORK[3:0]);
    assign fd_usb_rx = (state[3:0] == ACK_READ[3:0]);
    assign fs_type = (state == DTYPE_IDLE);
    assign fs_conf = (state == DTEMP_IDLE);
    assign fs_conv = (state == DATA0_IDLE) || (state == DATA1_IDLE);

    assign ram_addr_init = 12'h100;

    assign ram_tinit = 12'h000;
    assign ram_tlen = 12'h800;
    assign pin_rxd = pin_txd;
    assign com_data_cmd = 32'h7E213000;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= COM_IDLE;

            COM_IDLE: next_state <= ACK_IDLE;

            ACK_IDLE: next_state <= ACK_WORK;
            ACK_WORK: begin
                if(fd_com_tx) next_state <= ACK_WAIT;
                else next_state <= ACK_WORK;
            end
            ACK_WAIT: begin
                if(fs_usb_rx) next_state <= ACK_READ;
                else next_state <= ACK_WAIT;
            end
            ACK_READ: begin
                if(~fs_usb_rx) next_state <= ACK_DONE;
                else next_state <= ACK_READ;
            end
            ACK_DONE: next_state <= NAK_IDLE;

            NAK_IDLE: next_state <= NAK_WORK;
            NAK_WORK: begin
                if(fd_com_tx) next_state <= NAK_WAIT;
                else next_state <= NAK_WORK;
            end
            NAK_WAIT: begin
                if(fs_usb_rx) next_state <= NAK_READ;
                else next_state <= NAK_WAIT;
            end
            NAK_READ: begin
                if(~fs_usb_rx) next_state <= NAK_DONE;
                else next_state <= NAK_READ;
            end
            NAK_DONE: next_state <= STL_IDLE;

            STL_IDLE: next_state <= STL_WORK;
            STL_WORK: begin
                if(fd_com_tx) next_state <= STL_WAIT;
                else next_state <= STL_WORK;
            end
            STL_WAIT: begin
                if(fs_usb_rx) next_state <= STL_READ;
                else next_state <= STL_WAIT;
            end
            STL_READ: begin
                if(~fs_usb_rx) next_state <= STL_DONE;
                else next_state <= STL_READ;
            end
            STL_DONE: next_state <= DLINK_IDLE;

            DLINK_IDLE: next_state <= DLINK_WORK;
            DLINK_WORK: begin
                if(fd_com_tx) next_state <= DLINK_WAIT;
                else next_state <= DLINK_WORK;
            end
            DLINK_WAIT: begin
                if(fs_usb_rx) next_state <= DLINK_READ;
                else next_state <= DLINK_WAIT;
            end
            DLINK_READ: begin
                if(~fs_usb_rx) next_state <= DLINK_DONE;
                else next_state <= DLINK_READ;
            end
            DLINK_DONE: next_state <= DTYPE_IDLE;

            DTYPE_IDLE: begin
                if(fd_type) next_state <= DTYPE_WORK;
                else next_state <= DTYPE_IDLE;
            end
            DTYPE_WORK: begin
                if(fd_com_tx) next_state <= DTYPE_WAIT;
                else next_state <= DTYPE_WORK;
            end
            DTYPE_WAIT: begin
                if(fs_usb_rx) next_state <= DTYPE_READ;
                else next_state <= DTYPE_WAIT;
            end
            DTYPE_READ: begin
                if(~fs_usb_rx) next_state <= DTYPE_DONE;
                else next_state <= DTYPE_READ;
            end
            DTYPE_DONE: next_state <= DTEMP_IDLE;

            DTEMP_IDLE: begin
                if(fd_conf) next_state <= DTEMP_WORK;
                else next_state <= DTEMP_IDLE;
            end
            DTEMP_WORK: begin
                if(fd_com_tx) next_state <= DTEMP_WAIT;
                else next_state <= DTEMP_WORK;
            end
            DTEMP_WAIT: begin
                if(fs_usb_rx) next_state <= DTEMP_READ;
                else next_state <= DTEMP_WAIT;
            end
            DTEMP_READ: begin
                if(~fs_usb_rx) next_state <= DTEMP_DONE;
                else next_state <= DTEMP_READ;
            end
            DTEMP_DONE: next_state <= DATA0_IDLE;

            DATA0_IDLE: begin
                if(fd_conv) next_state <= DATA0_WORK;
                else next_state <= DATA0_IDLE;
            end
            DATA0_WORK: begin
                if(fd_com_tx && fd_tran) next_state <= DATA0_WAIT;
                else next_state <= DATA0_WORK;
            end
            DATA0_WAIT: begin
                if(fs_usb_rx) next_state <= DATA0_READ;
                else next_state <= DATA0_WAIT;
            end
            DATA0_READ: begin
                if(~fs_usb_rx) next_state <= DATA0_DONE;
                else next_state <= DATA0_READ;
            end
            DATA0_DONE: next_state <= DATA1_IDLE;

            DATA1_IDLE: begin
                if(fd_conv) next_state <= DATA1_WORK;
                else next_state <= DATA1_IDLE;
            end
            DATA1_WORK: begin
                if(fd_com_tx && fd_tran) next_state <= DATA1_WAIT;
                else next_state <= DATA1_WORK;
            end
            DATA1_WAIT: begin
                if(fs_usb_rx) next_state <= DATA1_READ;
                else next_state <= DATA1_WAIT;
            end
            DATA1_READ: begin
                if(~fs_usb_rx) next_state <= DATA1_DONE;
                else next_state <= DATA1_READ;
            end
            DATA1_DONE: next_state <= COM_IDLE;
            
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_rinit <= 12'h000;
        else if(state == IDLE) ram_rinit <= 12'h000;
        else if(state == WAIT) ram_rinit <= 12'h000;
        else if(state == COM_IDLE) ram_rinit <= 12'h10;
        else ram_rinit <= ram_rinit;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_rlen <= 12'h000;
        else if(state == IDLE) ram_rlen <= 12'h000;
        else if(state == WAIT) ram_rlen <= 12'h000;
        else if(state == DLINK_IDLE) ram_rlen <= 12'h02;
        else if(state == DTYPE_IDLE) ram_rlen <= 12'h02;
        else if(state == DTEMP_IDLE) ram_rlen <= 12'h02;
        else if(state == DATA0_IDLE) ram_rlen <= 12'h200;
        else if(state == DATA1_IDLE) ram_rlen <= 12'h200;
        else ram_rlen <= ram_rlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) tx_btype <= BAG_INIT;
        else if(state == IDLE) tx_btype <= BAG_INIT;
        else if(state == WAIT) tx_btype <= BAG_INIT;
        else if(state == ACK_IDLE) tx_btype <= BAG_ACK;
        else if(state == NAK_IDLE) tx_btype <= BAG_NAK;
        else if(state == STL_IDLE) tx_btype <= BAG_STL;
        else if(state == DLINK_IDLE) tx_btype <= BAG_DLINK;
        else if(state == DTYPE_IDLE) tx_btype <= BAG_DTYPE;
        else if(state == DTEMP_IDLE) tx_btype <= BAG_DTEMP;
        else if(state == DATA0_IDLE) tx_btype <= BAG_DATA0;
        else if(state == DATA1_IDLE) tx_btype <= BAG_DATA1;
        else tx_btype <= tx_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_dlen <= 12'h000;
        else if(state == IDLE) ram_dlen <= 12'h000;
        else if(state == WAIT) ram_dlen <= 12'h000;
        else if(state == DLINK_IDLE) ram_dlen <= 12'h002;
        else if(state == DTYPE_IDLE) ram_dlen <= 12'h002;
        else if(state == DTEMP_IDLE) ram_dlen <= 12'h002;
        else if(state == DATA0_IDLE) ram_dlen <= 12'h202;
        else if(state == DATA1_IDLE) ram_dlen <= 12'h202;
        else ram_dlen <= ram_dlen;
    end

    com_txf
    com_txf_dut(
        .clk(clk_100),
        .rst(rst),

        .fs(fs_com_tx),

        .din(com_txd),
        .dout(pin_txd),
        .fire(fire)
    );

    usb_rxf
    usb_rxf_dut(
        .clk(clk_100),
        .rst(rst),

        .din(pin_rxd),
        .dout(usb_rxd),
        .fire(fire)
    );


    usb_rx
    usb_rx_dut(
        .clk(clk_50),
        .rst(rst),

        .fs(fs_usb_rx),
        .fd(fd_usb_rx),

        .usb_rxd(usb_rxd),
        .btype(usb_rx_btype),
        .data_stat(usb_data_stat),

        .ram_txa_init(12'h100),

        .ram_txa(usb_ram_txa),
        .ram_txd(usb_ram_txd),
        .ram_txen(usb_ram_txen)
    );


    com_tx
    com_tx_dut(
        .clk(clk_50),
        .rst(rst),

        .fs(fs_com_tx),
        .fd(fd_com_tx),

        .com_txd(com_txd),
        .ram_init(ram_addr_init),
        .ram_rlen(ram_dlen),

        .btype(tx_btype),

        .ram_rxa(ram_rxa),
        .ram_rxd(ram_rxd)
    );
    

    adc_test
    adc_test_dut(
        .clk(clk_50),
        .fifo_txc(clk_50),
        .fifo_rxc(clk_100),

        .rst(rst),

        .fs_init(fs_init),
        .fs_type(fs_type),
        .fs_conf(fs_conf),
        .fs_conv(fs_conv),
        .fd_init(fd_init),
        .fd_type(fd_type),
        .fd_conf(fd_conf),
        .fd_conv(fd_conv),

        .data_cmd(com_data_cmd),
        .data_stat(com_data_stat),

        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd)
    );

    data_make
    data_make_dut(
        .clk(clk_100),
        .rst(rst),

        .fs(fs_tran),
        .fd(fd_tran),

        .btype(tx_btype),
        .ram_data_init(ram_addr_init),

        .data_cmd(com_data_cmd),
        .data_stat(com_data_stat),

        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd),

        .ram_txa(ram_txa),
        .ram_txd(ram_txd),
        .ram_txen(ram_txen)
    );

    ram_data
    ram_data_dut(
        .clka(clk_100),
        .addra(ram_txa),
        .dina(ram_txd),
        .wea(ram_txen),

        .clkb(clk_50),
        .addrb(ram_rxa),
        .doutb(ram_rxd)
    );









endmodule