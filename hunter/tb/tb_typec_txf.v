module tb_typec_txf(
    input clk,
    input rst
);

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STALL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    (*MARK_DEBUG = "true"*)reg [7:0] state; 
    reg [7:0] next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02;
    localparam RAM_TX = 8'h10;
    localparam PACK = 8'h20, TACK = 8'h21, PNAK = 8'h22, TNAK = 8'h23;
    localparam PSTALL = 8'h24, TSTALL = 8'h25;
    localparam WACK = 8'h28, RACK = 8'h29, WNAK = 8'h2A, RNAK = 8'h2B;
    localparam WSTALL = 8'h2C, RSTALL = 8'h2D;
    localparam PLINK = 8'h30, DLINK = 8'h31, PTYPE = 8'h32, DTYPE = 8'h33;
    localparam PTEMP = 8'h34, DTEMP = 8'h35, PDATA = 8'h36, DATA0 = 8'h37;
    localparam WLINK = 8'h38, RLINK = 8'h39, WTYPE = 8'h3A, RTYPE = 8'h3B;
    localparam WTEMP = 8'h3C, RTEMP = 8'h3D, WDATA = 8'h3E, RDATA = 8'h3F;

    wire clk_25, clk_100, clk_200;

    wire ram_txc, ram_rxc;
    (*MARK_DEBUG = "true"*)wire [11:0] ram_txa, ram_rxa;
    (*MARK_DEBUG = "true"*)wire [7:0] ram_txd, ram_rxd;
    (*MARK_DEBUG = "true"*)wire ram_txen;

    (*MARK_DEBUG = "true"*)wire fs_ram_tx, fd_ram_tx;
    (*MARK_DEBUG = "true"*)wire fs_typec_tx, fd_typec_tx;
    (*MARK_DEBUG = "true"*)wire fs_rx, fd_rx;
    (*MARK_DEBUG = "true"*)wire [7:0] com_rxd;
    (*MARK_DEBUG = "true"*)wire [3:0] rx_btype, rx_didx;
    (*MARK_DEBUG = "true"*)wire [7:0] rx_bdata;
    (*MARK_DEBUG = "true"*)wire [7:0] rx_ram_txd;

    (*MARK_DEBUG = "true"*)wire [7:0] com_txd;

    (*MARK_DEBUG = "true"*)reg [3:0] btype;
    (*MARK_DEBUG = "true"*)wire [3:0] pin;
    (*MARK_DEBUG = "true"*)wire fire;


    assign fs_ram_tx = (state == RAM_TX);
    assign fs_typec_tx = (state == TACK) || (state == TNAK) || (state == TSTALL) || (state == DLINK) || (state == DTYPE) || (state == DTEMP) || (state == DATA0);
    assign fd_rx = (state == RACK) || (state == RNAK) || (state == RSTALL) || (state == RLINK) || (state == RTYPE) || (state == RTEMP) || (state == RDATA);
    assign ram_txc = clk;
    assign ram_rxc = clk;
    
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
                if(fs_rx) next_state <= RACK;
                else next_state <= WACK;
            end
            RACK: begin
                if(~fs_rx) next_state <= PNAK;
                else next_state <= RACK;
            end
            
            PNAK: next_state <= TNAK;
            TNAK: begin
                if(fd_typec_tx) next_state <= WNAK;
                else next_state <= TNAK;
            end
            WNAK: begin
                if(fs_rx) next_state <= RNAK;  
                else next_state <= WNAK;
            end
            RNAK: begin
                if(~fs_rx) next_state <= PSTALL;
                else next_state <= RNAK;
            end

            PSTALL: next_state <= TSTALL;
            TSTALL: begin
                if(fd_typec_tx) next_state <= WSTALL;
                else next_state <= TSTALL;
            end
            WSTALL: begin
                if(fs_rx) next_state <= RSTALL;
                else next_state <= WSTALL;
            end
            RSTALL: begin
                if(~fs_rx) next_state <= PLINK;
                else next_state <= RSTALL;
            end
            
            PLINK: next_state <= DLINK;
            DLINK: begin
                if(fd_typec_tx) next_state <= WLINK;
                else next_state <= DLINK;
            end
            WLINK: begin
                if(fs_rx) next_state <= RLINK;
                else next_state <= WLINK;
            end
            RLINK: begin
                if(~fs_rx) next_state <= PTYPE;
                else next_state <= RLINK;
            end

            PTYPE: next_state <= DTYPE;
            DTYPE: begin
                if(fd_typec_tx) next_state <= WTYPE;
                else next_state <= DTYPE;
            end
            WTYPE: begin
                if(fs_rx) next_state <= RTYPE;
                else next_state <= WTYPE;
            end
            RTYPE: begin
                if(~fs_rx) next_state <= PTEMP;
                else next_state <= RTYPE;
            end

            PTEMP: next_state <= DTEMP;
            DTEMP: begin
                if(fd_typec_tx) next_state <= WTEMP;
                else next_state <= DTEMP;
            end
            WTEMP: begin
                if(fs_rx) next_state <= RTEMP;
                else next_state <= WTEMP;
            end
            RTEMP: begin
                if(~fs_rx) next_state <= PDATA;
                else next_state <= RTEMP;
            end

            PDATA: next_state <= DATA0;
            DATA0: begin
                if(fd_typec_tx) next_state <= WDATA;
                else next_state <= DATA0;
            end
            WDATA: begin
                if(fs_rx) next_state <= RDATA;
                else next_state <= WDATA;
            end
            RDATA: begin
                if(~fs_rx) next_state <= DONE;
                else next_state <= RDATA;
            end

            DONE: next_state <= PACK;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) btype <= BAG_INIT;
        else if(state == PACK) btype <= BAG_ACK;
        else if(state == PNAK) btype <= BAG_NAK;
        else if(state == PSTALL) btype <= BAG_STALL;
        else if(state == PLINK) btype <= BAG_DLINK;
        else if(state == PTYPE) btype <= BAG_DTYPE;
        else if(state == PTEMP) btype <= BAG_DTEMP;
        else if(state == PDATA) btype <= BAG_DATA0;
        else btype <= btype;
    end

    mmcm
    mmcm_dut(
        .clk_in(clk),
        .clk_out1(clk_25),
        .clk_out2(clk_100),
        .clk_out3(clk_200)
    );

    typecm_rx
    typecm_rx_dut(
        .clk(clk),
        .rst(rst),
        .fs(fs_rx),
        .fd(fd_rx),

        .com_rxd(com_rxd),
        .btype(rx_btype),
        .bdata(rx_bdata),
        .didx(rx_didx),
        .ram_txd(rx_ram_txd)
    );

    typecm_rxf
    typecm_rxf_dut(
        .clk(clk_100),
        .rst(rst),

        .din(pin),
        .dout(com_rxd),
        .fire(fire)
    );

    ram_tx
    ram_tx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_ram_tx),
        .fd(fd_ram_tx),

        .addr_init(12'h000),
        .data_len(12'h800),

        .ram_txa(ram_txa),
        .ram_txd(ram_txd),
        .ram_txen(ram_txen)
    );


    typec_tx
    typec_tx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_typec_tx),
        .fd(fd_typec_tx),

        .ram_addr_init(12'h031),
        .data_len(12'h050),

        .btype(btype),

        .didx(4'h5),
        .type(8'hFF),
        .temp(8'h63),
        .head(8'h4F),

        .ram_rxd(ram_rxd),
        .ram_rxa(ram_rxa),
        .com_txd(com_txd)
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
    ram_dut(
        .clka(ram_txc),
        .addra(ram_txa),
        .dina(ram_txd),
        .wea(ram_txen),

        .clkb(ram_rxc),
        .addrb(ram_rxa),
        .doutb(ram_rxd)
    );


endmodule