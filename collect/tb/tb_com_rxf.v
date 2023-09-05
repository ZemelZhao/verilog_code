module tb_com_rxf(
    input clk_25,
    input clk_50,
    input clk_100,
    input clk_200,
    input rst
);

    reg [7:0] state; 
    reg [7:0] next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02;
    localparam RAM_TX = 8'h10, RAM_RX = 8'h11;
    localparam PACK = 8'h20, TACK = 8'h21, PNAK = 8'h22, TNAK = 8'h23;
    localparam PSTALL = 8'h24, TSTALL = 8'h25;
    localparam WACK = 8'h28, RACK = 8'h29, WNAK = 8'h2A, RNAK = 8'h2B;
    localparam WSTALL = 8'h2C, RSTALL = 8'h2D;
    localparam PLINK = 8'h30, DLINK = 8'h31, PTYPE = 8'h32, DTYPE = 8'h33;
    localparam PTEMP = 8'h34, DTEMP = 8'h35, PDATA = 8'h36, DATA0 = 8'h37;
    localparam WLINK = 8'h38, RLINK = 8'h39, WTYPE = 8'h3A, RTYPE = 8'h3B;
    localparam WTEMP = 8'h3C, RTEMP = 8'h3D, WDATA = 8'h3E, RDATA = 8'h3F;

    wire ram_txc, ram_rxc;
    wire [11:0] ram_in_txa, ram_in_rxa;
    wire [7:0] ram_in_txd, ram_in_rxd;
    wire ram_in_txen;
    wire [11:0] ram_out_txa, ram_out_rxa;
    wire [7:0] ram_out_txd, ram_out_rxd;
    wire ram_out_txen;

    wire fs_ram_tx, fd_ram_tx;
    wire fs_typec_tx, fd_typec_tx;
    wire fs_com_rx, fd_com_rx;
    wire fs_ram_rx, fd_ram_rx;

    wire [7:0] com_txd, com_rxd;

    reg [3:0] tx_btype;
    wire [3:0] rx_btype;
    wire [7:0] rx_bdata;
    wire [3:0] rx_didx, rx_ddidx;
    wire [3:0] rx_stat;
    wire [11:0] rx_data_len;
    
    wire clk;
    wire fire;
    wire [3:0] pin;


    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STALL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    localparam RAM_ADDR = 12'h21;

    assign fs_ram_tx = (state == RAM_TX);
    assign fs_typec_tx = (state == TACK) || (state == TNAK) || (state == TSTALL) || (state == DLINK) || (state == DTYPE) || (state == DTEMP) || (state == DATA0);
    assign fd_com_rx = (state == RACK) || (state == RNAK) || (state == RSTALL) || (state == RLINK) || (state == RTYPE) || (state == RTEMP) || (state == RDATA);
    assign fs_ram_rx = (state == RAM_RX);
    assign ram_txc = clk_50;
    assign ram_rxc = clk_50;
    assign clk = clk_50;
    
    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= RAM_TX;
            RAM_TX: begin
                if(fd_ram_tx) next_state <= PACK;
                else next_state <= RAM_TX;
            end
            PACK: next_state <= TACK;
            TACK: begin
                if(fd_typec_tx) next_state <= WACK;
                else next_state <= TACK;
            end
            WACK: begin
                if(fs_com_rx) next_state <= RACK;
                else next_state <= WACK;
            end
            RACK: begin
                if(~fs_com_rx) next_state <= PNAK;
                else next_state <= RACK;
            end
            
            PNAK: next_state <= TNAK;
            TNAK: begin
                if(fd_typec_tx) next_state <= WNAK;
                else next_state <= TNAK;
            end
            WNAK: begin
                if(fs_com_rx) next_state <= RNAK;  
                else next_state <= WNAK;
            end
            RNAK: begin
                if(~fs_com_rx) next_state <= PSTALL;
                else next_state <= RNAK;
            end

            PSTALL: next_state <= TSTALL;
            TSTALL: begin
                if(fd_typec_tx) next_state <= WSTALL;
                else next_state <= TSTALL;
            end
            WSTALL: begin
                if(fs_com_rx) next_state <= RSTALL;
                else next_state <= WSTALL;
            end
            RSTALL: begin
                if(~fs_com_rx) next_state <= PLINK;
                else next_state <= RSTALL;
            end
            
            PLINK: next_state <= DLINK;
            DLINK: begin
                if(fd_typec_tx) next_state <= WLINK;
                else next_state <= DLINK;
            end
            WLINK: begin
                if(fs_com_rx) next_state <= RLINK;
                else next_state <= WLINK;
            end
            RLINK: begin
                if(~fs_com_rx) next_state <= PTYPE;
                else next_state <= RLINK;
            end

            PTYPE: next_state <= DTYPE;
            DTYPE: begin
                if(fd_typec_tx) next_state <= WTYPE;
                else next_state <= DTYPE;
            end
            WTYPE: begin
                if(fs_com_rx) next_state <= RTYPE;
                else next_state <= WTYPE;
            end
            RTYPE: begin
                if(~fs_com_rx) next_state <= PTEMP;
                else next_state <= RTYPE;
            end

            PTEMP: next_state <= DTEMP;
            DTEMP: begin
                if(fd_typec_tx) next_state <= WTEMP;
                else next_state <= DTEMP;
            end
            WTEMP: begin
                if(fs_com_rx) next_state <= RTEMP;
                else next_state <= WTEMP;
            end
            RTEMP: begin
                if(~fs_com_rx) next_state <= PDATA;
                else next_state <= RTEMP;
            end

            PDATA: next_state <= DATA0;
            DATA0: begin
                if(fd_typec_tx) next_state <= WDATA;
                else next_state <= DATA0;
            end
            WDATA: begin
                if(fs_com_rx) next_state <= RDATA;
                else next_state <= WDATA;
            end
            RDATA: begin
                if(~fs_com_rx) next_state <= RAM_RX;
                else next_state <= RDATA;
            end
            RAM_RX: begin
                if(fd_ram_rx) next_state <= DONE;
                else next_state <= RAM_RX;
            end

            DONE: next_state <= PACK;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) tx_btype <= BAG_INIT;
        else if(state == PACK) tx_btype <= BAG_ACK;
        else if(state == PNAK) tx_btype <= BAG_NAK;
        else if(state == PSTALL) tx_btype <= BAG_STALL;
        else if(state == PLINK) tx_btype <= BAG_DLINK;
        else if(state == PTYPE) tx_btype <= BAG_DTYPE;
        else if(state == PTEMP) tx_btype <= BAG_DTEMP;
        else if(state == PDATA) tx_btype <= BAG_DATA0;
        else tx_btype <= tx_btype;
    end


    ram_tx
    ram_tx_dut(
        .clk(clk_50),
        .rst(rst),

        .fs(fs_ram_tx),
        .fd(fd_ram_tx),

        .addr_init(12'h000),
        .data_len(12'h100),

        .ram_txa(ram_in_txa),
        .ram_txd(ram_in_txd),
        .ram_txen(ram_in_txen)
    );

    ram_rx
    ram_rx_dut(
        .clk(clk_50),
        .rst(rst),
        .fs(fs_ram_rx),
        .fd(fd_ram_rx),
        .ram_rxa_init(RAM_ADDR),
        .data_len(12'h055),
        .ram_rxa(ram_out_rxa),
        .ram_rxd(ram_out_rxd)
    );    


    typec_tx
    typec_tx_dut(
        .clk(clk_50),
        .rst(rst),

        .fs(fs_typec_tx),
        .fd(fd_typec_tx),

        .ram_addr_init(12'h031),
        .data_len(12'h050),

        .btype(tx_btype),

        .didx(4'h5),
        .type(8'hFF),
        .temp(8'h63),
        .head(8'h4F),

        .ram_rxd(ram_in_rxd),
        .ram_rxa(ram_in_rxa),
        .com_txd(com_txd)
    );

    com_rx
    com_rx_dut(
        .clk(clk_50),
        .rst(rst),

        .fs(fs_com_rx),
        .fd(fd_com_rx),

        .com_rxd(com_rxd),
        .btype(rx_btype),
        .bdata(rx_bdata),
        .device_idx(rx_didx),
        .data_idx(rx_ddidx),
        .device_stat(rx_stat),

        .ram_txa_init(RAM_ADDR),
        .ram_txa(ram_out_txa),
        .ram_txd(ram_out_txd),
        .ram_txen(ram_out_txen),
        .data_len(rx_data_len)

    );

    com_rxf
    com_rxf_dut(
        .clk(clk_100),
        .rst(rst),

        .fire(fire),
        .din(pin),
        .dout(com_rxd)
    );

    typec_txf
    typec_txf_dut(
        .clk(clk_100),
        .rst(rst),

        .fs(fs_typec_tx),

        .din(com_txd),
        .dout(pin),
        .fire(fire)
    );


    ram
    ram_in(
        .clka(ram_txc),
        .addra(ram_in_txa),
        .dina(ram_in_txd),
        .wea(ram_in_txen),

        .clkb(ram_rxc),
        .addrb(ram_in_rxa),
        .doutb(ram_in_rxd)
    );

    ram
    ram_out(
        .clka(ram_txc),
        .addra(ram_out_txa),
        .dina(ram_out_txd),
        .wea(ram_out_txen),

        .clkb(ram_rxc),
        .addrb(ram_out_rxa),
        .doutb(ram_out_rxd)
    );



endmodule