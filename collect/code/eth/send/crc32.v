module crc32(
    input clk,
    input enable,
    input [0:7] din,
    output reg [31:0] dout
);

    localparam CRC_INIT = 32'hFFFFFFFF;
    reg [3:0] state, next_state;

    localparam IDLE = 4'h0, WAIT = 4'h1, WORK = 4'h2, DONE = 4'h3;
    localparam SH0W = 4'h4, SH1W = 4'h5, SH2W = 4'h6, SH3W = 4'h7;
    localparam SH4W = 4'h8, SH5W = 4'h9, SH6W = 4'hA, SH7W = 4'hB;

    reg [31:0] cout;
    wire [31:0] ctmp;

    assign ctmp[0] = cout[24]^cout[30]^din[0]^din[6];
    assign ctmp[1] = cout[24]^cout[25]^cout[30]^cout[31]^din[0]^din[1]^din[6]^din[7];
    assign ctmp[2] = cout[24]^cout[25]^cout[26]^cout[30]^cout[31]^din[0]^din[1]^din[2]^din[6]^din[7];
    assign ctmp[3] = cout[25]^cout[26]^cout[27]^cout[31]^din[1]^din[2]^din[3]^din[7];
    assign ctmp[4] = cout[24]^cout[26]^cout[27]^cout[28]^cout[30]^din[0]^din[2]^din[3]^din[4]^din[6];
    assign ctmp[5] = cout[24]^cout[25]^cout[27]^cout[28]^cout[29]^cout[30]^cout[31]^din[0]^din[1]^din[3]^din[4]^din[5]^din[6]^din[7];
    assign ctmp[6] = cout[25]^cout[26]^cout[28]^cout[29]^cout[30]^cout[31]^din[1]^din[2]^din[4]^din[5]^din[6]^din[7];
    assign ctmp[7] = cout[24]^cout[26]^cout[27]^cout[29]^cout[31]^din[0]^din[2]^din[3]^din[5]^din[7];
    assign ctmp[8] = cout[0]^cout[24]^cout[25]^cout[27]^cout[28]^din[0]^din[1]^din[3]^din[4];
    assign ctmp[9] = cout[1]^cout[25]^cout[26]^cout[28]^cout[29]^din[1]^din[2]^din[4]^din[5];
    assign ctmp[10] = cout[2]^cout[24]^cout[26]^cout[27]^cout[29]^din[0]^din[2]^din[3]^din[5];
    assign ctmp[11] = cout[3]^cout[24]^cout[25]^cout[27]^cout[28]^din[0]^din[1]^din[3]^din[4];
    assign ctmp[12] = cout[4]^cout[24]^cout[25]^cout[26]^cout[28]^cout[29]^cout[30]^din[0]^din[1]^din[2]^din[4]^din[5]^din[6];
    assign ctmp[13] = cout[5]^cout[25]^cout[26]^cout[27]^cout[29]^cout[30]^cout[31]^din[1]^din[2]^din[3]^din[5]^din[6]^din[7];
    assign ctmp[14] = cout[6]^cout[26]^cout[27]^cout[28]^cout[30]^cout[31]^din[2]^din[3]^din[4]^din[6]^din[7];
    assign ctmp[15] = cout[7]^cout[27]^cout[28]^cout[29]^cout[31]^din[3]^din[4]^din[5]^din[7];
    assign ctmp[16] = cout[8]^cout[24]^cout[28]^cout[29]^din[0]^din[4]^din[5];
    assign ctmp[17] = cout[9]^cout[25]^cout[29]^cout[30]^din[1]^din[5]^din[6];
    assign ctmp[18] = cout[10]^cout[26]^cout[30]^cout[31]^din[2]^din[6]^din[7];
    assign ctmp[19] = cout[11]^cout[27]^cout[31]^din[3]^din[7];
    assign ctmp[20] = cout[12]^cout[28]^din[4];
    assign ctmp[21] = cout[13]^cout[29]^din[5];
    assign ctmp[22] = cout[14]^cout[24]^din[0];
    assign ctmp[23] = cout[15]^cout[24]^cout[25]^cout[30]^din[0]^din[1]^din[6];
    assign ctmp[24] = cout[16]^cout[25]^cout[26]^cout[31]^din[1]^din[2]^din[7];
    assign ctmp[25] = cout[17]^cout[26]^cout[27]^din[2]^din[3];
    assign ctmp[26] = cout[18]^cout[24]^cout[27]^cout[28]^cout[30]^din[0]^din[3]^din[4]^din[6];
    assign ctmp[27] = cout[19]^cout[25]^cout[28]^cout[29]^cout[31]^din[1]^din[4]^din[5]^din[7];
    assign ctmp[28] = cout[20]^cout[26]^cout[29]^cout[30]^din[2]^din[5]^din[6];
    assign ctmp[29] = cout[21]^cout[27]^cout[30]^cout[31]^din[3]^din[6]^din[7];
    assign ctmp[30] = cout[22]^cout[28]^cout[31]^din[4]^din[7];
    assign ctmp[31] = cout[23]^cout[29]^din[5];

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
            SH3W: next_state <= SH4W;
            SH4W: next_state <= SH5W;
            SH5W: next_state <= SH6W;
            SH6W: next_state <= SH7W;
            SH7W: next_state <= DONE;
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