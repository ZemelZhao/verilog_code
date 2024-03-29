module crc16(
    input clk,
    input enable,
    input [7:0] din,
    output [15:0] dout
);

    // CRC16 x^16 + x^15 + x^2 + 1
    localparam CRC_INIT = 16'hFFFF;
    reg [3:0] state, next_state;
    localparam IDLE = 4'h0, WAIT = 4'h1, WORK = 4'h2, DONE = 4'h3;
    localparam SH0W = 4'h4, SH1W = 4'h5, SH2W = 4'h6, SH3W = 4'h7;

    reg [15:0] cout; 
    wire [15:0] ctmp;

    assign ctmp[0] = cout[8]^cout[9]^cout[10]^cout[11]^cout[12]^cout[13]^cout[14]^cout[15]^din[0]^din[1]^din[2]^din[3]^din[4]^din[5]^din[6]^din[7]; 
    assign ctmp[1] = cout[9]^cout[10]^cout[11]^cout[12]^cout[13]^cout[14]^cout[15]^din[1]^din[2]^din[3]^din[4]^din[5]^din[6]^din[7]; 
    assign ctmp[2] = cout[8]^cout[9]^din[0]^din[1];
    assign ctmp[3] = cout[9]^cout[10]^din[1]^din[2];
    assign ctmp[4] = cout[10]^cout[11]^din[2]^din[3];
    assign ctmp[5] = cout[11]^cout[12]^din[3]^din[4];
    assign ctmp[6] = cout[12]^cout[13]^din[4]^din[5];
    assign ctmp[7] = cout[13]^cout[14]^din[5]^din[6];
    assign ctmp[8] = cout[0]^cout[14]^cout[15]^din[6]^din[7];
    assign ctmp[9] = cout[1]^cout[15]^din[7];
    assign ctmp[10] = cout[2];
    assign ctmp[11] = cout[3];
    assign ctmp[12] = cout[4];
    assign ctmp[13] = cout[5];
    assign ctmp[14] = cout[6];
    assign ctmp[15] = cout[7]^cout[8]^cout[9]^cout[10]^cout[11]^cout[12]^cout[13]^cout[14]^cout[15]^din[0]^din[1]^din[2]^din[3]^din[4]^din[5]^din[6]^din[7];

    assign dout = cout;

    always@(posedge clk) begin
        state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(enable) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(enable) next_state <= WORK;
                else next_state <= SH0W;
            end
            SH0W: next_state <= SH1W;
            SH1W: next_state <= SH2W;
            SH2W: next_state <= SH3W;
            SH3W: next_state <= DONE;
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk) begin
        if(state == IDLE) cout <= CRC_INIT;
        else if(state == WORK && enable) cout <= ctmp;
        else if(state == WAIT) cout <= CRC_INIT;
        else cout <= cout;
    end

endmodule