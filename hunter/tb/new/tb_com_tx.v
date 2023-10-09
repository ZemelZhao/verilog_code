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
    localparam NAK_IDLE = 8'h30, NAK_WORK = 8'h31, NAK_DONE = 8'h32;
    localparam STL_IDLE = 8'h40, STL_WORK = 8'h41, STL_DONE = 8'h42;
    localparam DLINK_IDLE = 8'h50, DLINK_WORK = 8'h51, DLINK_DONE = 8'h52;
    localparam DTYPE_IDLE = 8'h60, DTYPE_WORK = 8'h61, DTYPE_DONE = 8'h62;
    localparam DTEMP_IDLE = 8'h70, DTEMP_WORK = 8'h71, DTEMP_DONE = 8'h72;
    localparam DATA0_IDLE = 8'h80, DATA0_WORK = 8'h81, DATA0_DONE = 8'h82;
    localparam DATA1_IDLE = 8'h90, DATA1_WORK = 8'h91, DATA1_DONE = 8'h92;

    wire fs_com_tx, fd_com_tx;
    wire fs_ram, fd_ram;

    reg [3:0] tx_btype;
    wire [11:0] ram_tinit, ram_tlen;
    reg [11:0] ram_rinit, ram_rlen;

    wire [7:0] ram_rxd, ram_txd;
    wire [11:0] ram_rxa, ram_txa;
    wire ram_txen;

    wire [7:0] com_txd;

    assign clk = clk_50;
    assign fs_ram = (state == RAM_TX);
    assign fs_com_tx = (state[3:0] == ACK_WORK[3:0]);

    assign ram_tinit = 12'h000;
    assign ram_tlen = 12'h800;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= RAM_TX;

            RAM_TX: begin
                if(fd_ram) next_state <= COM_IDLE;
                else next_state <= RAM_TX;
            end

            COM_IDLE: next_state <= ACK_IDLE;

            ACK_IDLE: next_state <= ACK_WORK;
            ACK_WORK: begin
                if(fd_com_tx) next_state <= ACK_DONE;
                else next_state <= ACK_WORK;
            end
            ACK_DONE: next_state <= NAK_IDLE;

            NAK_IDLE: next_state <= NAK_WORK;
            NAK_WORK: begin
                if(fd_com_tx) next_state <= NAK_DONE;
                else next_state <= NAK_WORK;
            end
            NAK_DONE: next_state <= STL_IDLE;

            STL_IDLE: next_state <= STL_WORK;
            STL_WORK: begin
                if(fd_com_tx) next_state <= STL_DONE;
                else next_state <= STL_WORK;
            end
            STL_DONE: next_state <= DLINK_IDLE;

            DLINK_IDLE: next_state <= DLINK_WORK;
            DLINK_WORK: begin
                if(fd_com_tx) next_state <= DLINK_DONE;
                else next_state <= DLINK_WORK;
            end
            DLINK_DONE: next_state <= DTYPE_IDLE;

            DTYPE_IDLE: next_state <= DTYPE_WORK;
            DTYPE_WORK: begin
                if(fd_com_tx) next_state <= DTYPE_DONE;
                else next_state <= DTYPE_WORK;
            end
            DTYPE_DONE: next_state <= DTEMP_IDLE;

            DTEMP_IDLE: next_state <= DTEMP_WORK;
            DTEMP_WORK: begin
                if(fd_com_tx) next_state <= DTEMP_DONE;
                else next_state <= DTEMP_WORK;
            end
            DTEMP_DONE: next_state <= DATA0_IDLE;

            DATA0_IDLE: next_state <= DATA0_WORK;
            DATA0_WORK: begin
                if(fd_com_tx) next_state <= DATA0_DONE;
                else next_state <= DATA0_WORK;
            end
            DATA0_DONE: next_state <= DATA1_IDLE;

            DATA1_IDLE: next_state <= DATA1_WORK;
            DATA1_WORK: begin
                if(fd_com_tx) next_state <= DATA1_DONE;
                else next_state <= DATA1_WORK;
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




    com_tx
    com_tx_dut(
        .clk(clk_50),
        .rst(rst),

        .fs(fs_com_tx),
        .fd(fd_com_tx),

        .com_txd(com_txd),
        .ram_init(ram_rinit),
        .ram_rlen(ram_rlen),

        .btype(tx_btype),

        .ram_rxa(ram_rxa),
        .ram_rxd(ram_rxd)
    );
    

    ram_tx
    ram_tx_dut(
        .clk(clk_100),
        .rst(rst),

        .fs(fs_ram),
        .fd(fd_ram),

        .bias(8'h01),
        .addr_init(ram_tinit),
        .data_len(ram_tlen),

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