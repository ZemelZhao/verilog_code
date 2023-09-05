module tb_com_tx_err(
    input clk,
    input rst
);

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STALL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    reg [7:0] state; 
    reg [7:0] next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02;
    localparam PACK = 8'h10, TACK = 8'h11, WACK = 8'h12, RACK = 8'h13;
    localparam PNAK = 8'h20, TNAK = 8'h21, WNAK = 8'h22, RNAK = 8'h23;
    localparam PSTALL = 8'h30, TSTALL = 8'h31, WSTALL = 8'h32, RSTALL = 8'h33;
    localparam PDIDX = 8'h40, TDIDX = 8'h41, WDIDX = 8'h42, RDIDX = 8'h43;
    localparam PFREQ = 8'h50, TFREQ = 8'h51, WFREQ = 8'h52, RFREQ = 8'h53;
    localparam PDDIDX = 8'h60, TDDIDX = 8'h61, WDDIDX = 8'h62, RDDIDX = 8'h63;

    wire [7:0] com_txd;
    reg [3:0] tx_btype;
    wire fs_tx, fd_tx;
    wire fs_rx, fd_rx;

    wire [3:0] rx_btype, rx_bdata;
    wire [7:0] com_rxd;

    assign fs_tx = (state == TACK) || (state == TNAK) || (state == TSTALL) || (state == TDIDX) || (state == TFREQ) || (state == TDDIDX);
    assign fd_rx = (state == RACK) || (state == RNAK) || (state == RSTALL) || (state == RDIDX) || (state == RFREQ) || (state == RDDIDX);
    assign com_rxd = com_txd;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= PACK;

            PACK: next_state <= TACK;
            TACK: begin
                if(fd_tx) next_state <= WACK;
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
                if(fd_tx) next_state <= WNAK;
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
                if(fd_tx) next_state <= WSTALL;
                else next_state <= TSTALL;
            end
            WSTALL: begin
                if(fs_rx) next_state <= RSTALL; 
                else next_state <= WSTALL;
            end
            RSTALL: begin
                if(~fs_rx) next_state <= PDIDX;
                else next_state <= RSTALL;
            end

            PDIDX: next_state <= TDIDX;
            TDIDX: begin
                if(fd_tx) next_state <= WDIDX; 
                else next_state <= TDIDX;
            end
            WDIDX: begin
                if(fs_rx) next_state <= RDIDX;
                else next_state <= WDIDX;
            end
            RDIDX: begin
                if(~fs_rx) next_state <= PFREQ;
                else next_state <= RDIDX;
            end

            PFREQ: next_state <= TFREQ;
            TFREQ: begin
                if(fd_tx) next_state <= WFREQ;
                else next_state <= TFREQ;
            end
            WFREQ: begin
                if(fs_rx) next_state <= RFREQ;
                else next_state <= WFREQ;
            end
            RFREQ: begin
                if(~fs_rx) next_state <= PDDIDX;
                else next_state <= RFREQ;
            end

            PDDIDX: next_state <= TDDIDX;
            TDDIDX: begin
                if(fd_tx) next_state <= WDDIDX;
                else next_state <= TDDIDX;
            end
            WDDIDX: begin
                if(fs_rx) next_state <= RDDIDX;
                else next_state <= WDDIDX;
            end
            RDDIDX: begin
                if(~fs_rx) next_state <= DONE;
                else next_state <= RDDIDX;
            end

            DONE: next_state <= WAIT;

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) tx_btype <= BAG_INIT;
        else if(state == IDLE) tx_btype <= BAG_INIT;
        else if(state == WAIT) tx_btype <= BAG_INIT;
        else if(state == PACK) tx_btype <= BAG_ACK;
        else if(state == PNAK) tx_btype <= BAG_NAK;
        else if(state == PSTALL) tx_btype <= BAG_STALL;
        else if(state == PDIDX) tx_btype <= BAG_DIDX;
        else if(state == PFREQ) tx_btype <= BAG_DPARAM;
        else if(state == PDDIDX) tx_btype <= BAG_DDIDX;
        else tx_btype <= tx_btype;
    end

    com_tx_err
    com_tx_err_dut(
        .clk(clk),
        .rst(rst),
        .fs(fs_tx),
        .fd(fd_tx),

        .btype(tx_btype),
        .didx(4'h5),
        .freq(4'h3),
        .ddidx(4'hA),
        
        .com_txd(com_txd)
    );

    typec_rx
    typec_rx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_rx),
        .fd(fd_rx),

        .btype(rx_btype),
        .bdata(rx_bdata),

        .com_rxd(com_rxd)
    );

endmodule