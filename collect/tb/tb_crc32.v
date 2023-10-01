module tb_crc32(
    input clk,
    input rst
);

    localparam DLEN = 8'h40;

    reg [7:0] cnt;
    reg [7:0] txd;
    reg crc_en;
    wire [31:0] crc_data;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam REST = 8'h04;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= WORK;
            WORK: begin
                if(cnt >= DLEN - 1'b1) next_state <= REST;
                else next_state <= WORK;
            end
            REST: next_state <= DONE;
            DONE: next_state <= IDLE;

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) txd <= 8'h00;
        else if(state == IDLE) txd <= 8'h00;
        else if(state == WAIT) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h00) txd <= 8'h55;
        else if(state == WORK && cnt == 8'h01) txd <= 8'h55;
        else if(state == WORK && cnt == 8'h02) txd <= 8'h55;
        else if(state == WORK && cnt == 8'h03) txd <= 8'h55;
        else if(state == WORK && cnt == 8'h04) txd <= 8'h55;
        else if(state == WORK && cnt == 8'h05) txd <= 8'h55;
        else if(state == WORK && cnt == 8'h06) txd <= 8'h55;
        else if(state == WORK && cnt == 8'h07) txd <= 8'hD5;
        else if(state == WORK && cnt == 8'h08) txd <= 8'hFF;
        else if(state == WORK && cnt == 8'h09) txd <= 8'hFF;
        else if(state == WORK && cnt == 8'h0A) txd <= 8'hFF;
        else if(state == WORK && cnt == 8'h0B) txd <= 8'hFF;
        else if(state == WORK && cnt == 8'h0C) txd <= 8'hFF;
        else if(state == WORK && cnt == 8'h0D) txd <= 8'hFF;
        else if(state == WORK && cnt == 8'h0E) txd <= 8'h3C;
        else if(state == WORK && cnt == 8'h0F) txd <= 8'hEC;
        else if(state == WORK && cnt == 8'h10) txd <= 8'hEF;
        else if(state == WORK && cnt == 8'h11) txd <= 8'hF5;
        else if(state == WORK && cnt == 8'h12) txd <= 8'h75;
        else if(state == WORK && cnt == 8'h13) txd <= 8'h63;
        else if(state == WORK && cnt == 8'h14) txd <= 8'h08;
        else if(state == WORK && cnt == 8'h15) txd <= 8'h06;
        else if(state == WORK && cnt == 8'h16) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h17) txd <= 8'h01;
        else if(state == WORK && cnt == 8'h18) txd <= 8'h08;
        else if(state == WORK && cnt == 8'h19) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h1A) txd <= 8'h06;
        else if(state == WORK && cnt == 8'h1B) txd <= 8'h04;
        else if(state == WORK && cnt == 8'h1C) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h1D) txd <= 8'h01;
        else if(state == WORK && cnt == 8'h1E) txd <= 8'h3C;
        else if(state == WORK && cnt == 8'h1F) txd <= 8'hEC;
        else if(state == WORK && cnt == 8'h20) txd <= 8'hEF;
        else if(state == WORK && cnt == 8'h21) txd <= 8'hF5;
        else if(state == WORK && cnt == 8'h22) txd <= 8'h75;
        else if(state == WORK && cnt == 8'h23) txd <= 8'h63;
        else if(state == WORK && cnt == 8'h24) txd <= 8'hC0;
        else if(state == WORK && cnt == 8'h25) txd <= 8'hA8;
        else if(state == WORK && cnt == 8'h26) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h27) txd <= 8'h03;
        else if(state == WORK && cnt == 8'h28) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h29) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h2A) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h2B) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h2C) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h2D) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h2E) txd <= 8'hC0;
        else if(state == WORK && cnt == 8'h2F) txd <= 8'hA8;
        else if(state == WORK && cnt == 8'h30) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h31) txd <= 8'h02;
        else if(state == WORK && cnt == 8'h32) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h33) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h34) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h35) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h36) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h37) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h38) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h39) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h3A) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h3B) txd <= 8'h00;
        else txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) crc_en <= 1'b0;
        else if(state == IDLE) crc_en <= 1'b0;
        else if(state == WAIT) crc_en <= 1'b0;
        else if(state == WORK && cnt >= 07) crc_en <= 1'b1;
        else if(state == DONE) crc_en <= 1'b1;
        else crc_en <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 8'h00; 
        else if(state == IDLE) cnt <= 8'h00;
        else if(state == WAIT) cnt <= 8'h00;
        else if(state == WORK) cnt <= cnt + 1'b1;
        else cnt <= 8'h00;
    end



    crc32
    crc32_dut(
        .clk(clk),
        .enable(crc_en),
        .din(txd),
        .dout(crc_data)
    );




endmodule