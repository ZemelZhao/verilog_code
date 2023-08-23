module tb_typecm_tx(
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
    localparam PACK = 8'h10, TACK = 8'h11;
    localparam PNAK = 8'h20, TNAK = 8'h21;
    localparam PSTALL = 8'h30, TSTALL = 8'h31;
    localparam PDIDX = 8'h40, TDIDX = 8'h41;
    localparam PFREQ = 8'h50, TFREQ = 8'h51;
    localparam PDDIDX = 8'h60, TDDIDX = 8'h61;

    (*MARK_DEBUG = "true"*)wire [7:0] com_txd;
    (*MARK_DEBUG = "true"*)reg [3:0] tx_btype;

    assign fs_tx = (state == TACK) || (state == TNAK) || (state == TSTALL) || (state == TDIDX) || (state == TFREQ) || (state == TDDIDX);

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
                if(fd_tx) next_state <= PNAK;
                else next_state <= TACK;
            end
            PNAK: next_state <= TNAK;
            TNAK: begin
                if(fd_tx) next_state <= PSTALL;
                else next_state <= TNAK;
            end
            PSTALL: next_state <= TSTALL;
            TSTALL: begin
                if(fd_tx) next_state <= PDIDX;
                else next_state <= TSTALL;
            end

            PDIDX: next_state <= TDIDX;
            TDIDX: begin
                if(fd_tx) next_state <= PFREQ; 
                else next_state <= TDIDX;
            end

            PFREQ: next_state <= TFREQ;
            TFREQ: begin
                if(fd_tx) next_state <= PDDIDX;
                else next_state <= TFREQ;
            end

            PDDIDX: next_state <= TDDIDX;
            TDDIDX: begin
                if(fd_tx) next_state <= DONE;
                else next_state <= TDDIDX;
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

    typecm_tx(
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


endmodule