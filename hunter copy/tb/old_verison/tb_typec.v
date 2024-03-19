module tb_typec(
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
    localparam RAM_TX = 8'h04;
    localparam PSDLINK = 8'h10, TSDLINK = 8'h11, WMDLINK = 8'h12, RMDLINK = 8'h13;
    localparam PMDIDX = 8'h20, TMDIDX = 8'h21, WSDIDX = 8'h22, RSDIDX = 8'h23; 
    localparam PSDTYPE = 8'h30, TSDTYPE = 8'h31, WMDTYPE = 8'h32, RMDTYPE = 8'h33; 
    localparam PMDPARAM = 8'h40, TMDPARAM = 8'h41, WSDPARAM = 8'h42, RSDPARAM = 8'h43;
    localparam PSDTEMP = 8'h50, TSDTEMP = 8'h51, WMDTEMP = 8'h52, RMDTEMP = 8'h53;
    localparam PMDDIDX = 8'h60, TMDDIDX = 8'h61, WSDDIDX = 8'h62, RSDDIDX = 8'h63;
    localparam PSDATA0 = 8'h70, TSDATA0 = 8'h71, WMDATA0 = 8'h72, RMDATA0 = 8'h73;

    wire ram_txc, ram_rxc;
    wire clk_25, clk_50, clk_100, clk_200;

    wire [7:0] ram_txd, ram_rxd;
    wire [11:0] ram_txa, ram_rxa;
    wire ram_txen;

    wire fs_ram_tx, fd_ram_tx;

    (*MARK_DEBUG = "true"*)wire fsm_send, fdm_send;
    (*MARK_DEBUG = "true"*)wire fsm_read, fdm_read;
    (*MARK_DEBUG = "true"*)wire fss_send, fds_send;
    (*MARK_DEBUG = "true"*)wire fss_read, fds_read;

    (*MARK_DEBUG = "true"*)wire fm_send, fm_recv;
    (*MARK_DEBUG = "true"*)wire pm_txd;
    (*MARK_DEBUG = "true"*)wire [3:0] pm_rxd;

    (*MARK_DEBUG = "true"*)wire fs_send, fs_recv;
    (*MARK_DEBUG = "true"*)wire ps_rxd;
    (*MARK_DEBUG = "true"*)wire [3:0] ps_txd;

    (*MARK_DEBUG = "true"*)wire [3:0] m_read_btype;
    (*MARK_DEBUG = "true"*)wire [7:0] m_read_bdata;

    (*MARK_DEBUG = "true"*)wire [3:0] s_read_btype;
    (*MARK_DEBUG = "true"*)wire [3:0] s_read_bdata;

    (*MARK_DEBUG = "true"*)reg [3:0] m_send_btype;
    (*MARK_DEBUG = "true"*)reg [3:0] s_send_btype;

    assign ram_txc = clk_50;
    assign ram_rxc = clk_50;
    assign clk_50 = clk;

    assign fsm_send = (state == TMDIDX) || (state == TMDPARAM) || (state == TMDDIDX);
    assign fdm_read = (state == RMDLINK) || (state == RMDTYPE) || (state == RMDTEMP) || (state == RMDATA0);
    assign fss_send = (state == TSDLINK) || (state == TSDTYPE) || (state == TSDTEMP) || (state == TSDATA0);
    assign fds_read = (state == RSDIDX) || (state == RSDPARAM) || (state == RSDDIDX);
    assign fs_ram_tx = (state == RAM_TX);

    assign fm_recv = fs_send;
    assign fs_recv = fm_send;
    assign ps_rxd = pm_txd;
    assign pm_rxd = ps_txd;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= RAM_TX;
            RAM_TX: begin
                if(fd_ram_tx) next_state <= PSDLINK;
                else next_state <= RAM_TX;
            end

            PSDLINK: next_state <= TSDLINK;
            TSDLINK: begin
                if(fds_send) next_state <= WMDLINK;
                else next_state <= TSDLINK;
            end
            WMDLINK: begin
                if(fsm_read) next_state <= RMDLINK;
                else next_state <= WMDLINK;
            end
            RMDLINK: begin
                if(~fsm_read) next_state <= PMDIDX; 
                else next_state <= RMDLINK;
            end

            PMDIDX: next_state <= TMDIDX;
            TMDIDX: begin
                if(fdm_send) next_state <= WSDIDX; 
                else next_state <= TMDIDX;
            end
            WSDIDX: begin
                if(fss_read) next_state <= RSDIDX;
                else next_state <= WSDIDX;
            end
            RSDIDX: begin
                if(~fss_read) next_state <= PSDTYPE;
                else next_state <= RSDIDX;
            end

            PSDTYPE: next_state <= TSDTYPE;
            TSDTYPE: begin
                if(fds_send) next_state <= WMDTYPE;
                else next_state <= TSDTYPE;
            end
            WMDTYPE: begin
                if(fsm_read) next_state <= RMDTYPE;
                else next_state <= WMDTYPE;
            end
            RMDTYPE: begin
                if(~fsm_read) next_state <= PMDPARAM; 
                else next_state <= RMDTYPE;
            end
            
            
            PMDPARAM: next_state <= TMDPARAM;
            TMDPARAM: begin
                if(fdm_send) next_state <= WSDPARAM; 
                else next_state <= TMDPARAM;
            end
            WSDPARAM: begin
                if(fss_read) next_state <= RSDPARAM;
                else next_state <= WSDPARAM;
            end
            RSDPARAM: begin
                if(~fss_read) next_state <= PSDTEMP;
                else next_state <= RSDPARAM;
            end

            PSDTEMP: next_state <= TSDTEMP;
            TSDTEMP: begin
                if(fds_send) next_state <= WMDTEMP;
                else next_state <= TSDTEMP;
            end
            WMDTEMP: begin
                if(fsm_read) next_state <= RMDTEMP;
                else next_state <= WMDTEMP;
            end
            RMDTEMP: begin
                if(~fsm_read) next_state <= PMDDIDX; 
                else next_state <= RMDTEMP;
            end

            PMDDIDX: next_state <= TMDDIDX;
            TMDDIDX: begin
                if(fdm_send) next_state <= WSDDIDX; 
                else next_state <= TMDDIDX;
            end
            WSDDIDX: begin
                if(fss_read) next_state <= RSDDIDX;
                else next_state <= WSDDIDX;
            end
            RSDDIDX: begin
                if(~fss_read) next_state <= PSDATA0;
                else next_state <= RSDDIDX;
            end

            PSDATA0: next_state <= TSDATA0;
            TSDATA0: begin
                if(fds_send) next_state <= WMDATA0;
                else next_state <= TSDATA0;
            end
            WMDATA0: begin
                if(fsm_read) next_state <= RMDATA0;
                else next_state <= WMDLINK;
            end
            RMDATA0: begin
                if(~fsm_read) next_state <= PSDLINK; 
                else next_state <= RMDATA0;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) m_send_btype <= BAG_INIT;
        else if(state == IDLE) m_send_btype <= BAG_INIT;
        else if(state == PMDIDX) m_send_btype <= BAG_DIDX;
        else if(state == PMDPARAM) m_send_btype <= BAG_DPARAM;
        else if(state == PMDDIDX) m_send_btype <= BAG_DDIDX;
        else m_send_btype <= m_send_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) s_send_btype <= BAG_INIT;
        else if(state == IDLE) s_send_btype <= BAG_INIT;
        else if(state == PSDLINK) s_send_btype <= BAG_DLINK; 
        else if(state == PSDTYPE) s_send_btype <= BAG_DTYPE; 
        else if(state == PSDTEMP) s_send_btype <= BAG_DTEMP; 
        else if(state == PSDATA0) s_send_btype <= BAG_DATA0; 
        else s_send_btype <= s_send_btype;
    end


    mmcm
    mmcm_dut(
        .clk_in(clk),
        .clk_out1(clk_25),
        .clk_out2(clk_100),
        .clk_out3(clk_200)
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


    ram_tx
    ram_tx_dut(
        .clk(ram_txc),
        .rst(rst),

        .fs(fs_ram_tx),
        .fd(fd_ram_tx),

        .addr_init(12'h000),
        .data_len(12'h800),

        .ram_txa(ram_txa),
        .ram_txd(ram_txd),
        .ram_txen(ram_txen)
    );


    typecm
    typecm_dut(
        .sys_clk(clk_50),
        .com_txc(clk_25),
        .com_rxc(clk_50),
        .pin_txc(clk_200),
        .pin_rxc(clk_100),
        .rst(rst),

        .fs_send(fsm_send),
        .fd_send(fdm_send),
        .fs_read(fsm_read),
        .fd_read(fdm_read),

        .fire_send(fm_send),
        .fire_recv(fm_recv),
        .pin_txd(pm_txd),
        .pin_rxd(pm_rxd),

        .read_btype(m_read_btype),
        .send_btype(m_send_btype),
        .device_idx(4'h3),
        .device_freq(4'h5),
        .data_idx(4'h7)
    );

    typec
    typec_dut(
        .sys_clk(clk_50),
        .com_txc(clk_50),
        .com_rxc(clk_25),
        .pin_txc(clk_100),
        .pin_rxc(clk_200),
        .rst(rst),

        .fs_send(fss_send),
        .fd_send(fds_send),
        .fs_read(fss_read),
        .fd_read(fds_read),

        .fire_send(fs_send),
        .fire_recv(fs_recv),
        .pin_txd(ps_txd),
        .pin_rxd(ps_rxd),

        .read_btype(s_read_btype),
        .read_bdata(s_read_bdata),

        .send_btype(s_send_btype),
        .device_type(8'hFF),
        .device_temp(8'h63),
        .device_stat(4'hF),

        .ram_rxa_init(12'h31),
        .data_len(12'h50),
        .ram_rxa(ram_rxa),
        .ram_rxd(ram_rxd)
    );




endmodule