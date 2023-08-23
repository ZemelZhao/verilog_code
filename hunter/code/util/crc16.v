module crc16(
    input clk,
    input enable,
    input [7:0] din,
    output [15:0] dout
);

    // CRC16 x^16 + x^15 + x^2 + 1
    reg [1:0] state, next_state;
    localparam IDLE = 2'b00, WAIT = 2'b01, WORK = 2'b10, DONE = 2'b11;

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
                else next_state <= DONE;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk) begin
        if(state == IDLE) cout <= 16'hFFFF;
        else if(state == WORK) cout <= ctmp;
        else cout <= cout;
    end

endmodule