module crc5(
    input clk,
    input enable,
    input [7:0] din,
    output [7:0] dout
);

    // CRC5 x^5 + x^2 + 1

    reg [1:0] state, next_state;
    localparam IDLE = 2'b00, WAIT = 2'b01, WORK = 2'b10, DONE = 2'b11;

    reg [4:0] cout; 
    wire [4:0] ctmp;

    assign ctmp[0] = cout[0]^cout[2]^cout[3]^din[0]^din[3]^din[5]^din[6]; 
    assign ctmp[1] = cout[1]^cout[3]^cout[4]^din[1]^din[4]^din[6]^din[7];
    assign ctmp[2] = cout[0]^cout[3]^cout[4]^din[0]^din[2]^din[3]^din[6]^din[7];
    assign ctmp[3] = cout[0]^cout[1]^cout[4]^din[1]^din[3]^din[4]^din[7];
    assign ctmp[4] = cout[1]^cout[2]^din[2]^din[4]^din[5];

    assign dout = {3'h0, cout};

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
        if(state == IDLE) cout <= 5'h1F;
        else if(state == WORK) cout <= ctmp;
        else cout <= cout;
    end

endmodule