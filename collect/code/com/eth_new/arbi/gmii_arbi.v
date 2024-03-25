module gmii_arbi(
	input clk,
	input rst_n,
	input [1:0] speed,
	input link,

	output e_rstn,
	output reg [31:0] eth_timeout,

	input gmii_rxdv,
	input [7:0] gmii_rxd,
	output reg e_rxdv,
	output reg [7:0] e_rxd, 

	input e_txen,
	input [7:0] e_txd,
	output reg gmii_txen,
	output reg [7:0] gmii_txd
);

	// Arbi
	wire rst;
	assign rst = ~rst_n;

	localparam SPEED_10M = 2'b00, SPEED_100M = 2'b01, SPEED_1000M = 2'b10;
	localparam TIMEOUT_10M = 32'd2_500_000;
	localparam TIMEOUT_100M = 32'd25_000_000;
	localparam TIMEOUT_1000M = 32'd125_000_000;

	localparam RST_LENGTH = 8'd200;

	reg [1:0] speed_d0, speed_d1, speed_d2;
	reg eth_1000m, eth_100m, eth_10m;

	reg link_d0, link_d1, link_d2;

	reg state, next_state;
	localparam IDLE = 1'b0, WORK = 1'b1;
	reg [7:0] num;

	assign e_rstn = link_d2 && (state == WORK);

	// Speed Section
	always@(posedge clk or posedge rst) begin
		if(rst) speed_d0 <= 2'b00;
		else speed_d0 <= speed;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) speed_d1 <= 2'b00;
		else speed_d1 <= speed_d0;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) speed_d2 <= 2'b00;
		else speed_d2 <= speed_d1;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) eth_1000m <= 1'b0;
		else if(speed_d2 == SPEED_1000M) eth_1000m <= 1'b1;
		else eth_1000m <= eth_1000m;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) eth_100m <= 1'b0;
		else if(speed_d2 == SPEED_100M) eth_100m <= 1'b1;
		else eth_100m <= eth_100m;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) eth_10m <= 1'b0;
		else if(speed_d2 == SPEED_10M) eth_10m <= 1'b1;
		else eth_10m <= eth_10m;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) eth_timeout <= TIMEOUT_10M;
		else if(speed_d2 == SPEED_10M) eth_timeout <= TIMEOUT_10M;
		else if(speed_d2 == SPEED_100M) eth_timeout <= TIMEOUT_100M;
		else if(speed_d2 == SPEED_1000M) eth_timeout <= TIMEOUT_1000M;
		else eth_timeout <= eth_timeout;
	end

	// LINK && RST
	always@(posedge clk or posedge rst) begin
		if(rst) link_d0 <= 1'b0;
		else link_d0 <= link;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) link_d1 <= 1'b0;
		else link_d1 <= link_d0;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) link_d2 <= 1'b0;
		else link_d2 <= link_d1;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) state <= IDLE;
		else state <= next_state;
	end

	always@(*) begin
		case(state)
			IDLE: begin
				if(num == RST_LENGTH) next_state = WORK;
				else next_state <= IDLE;
			end
			WORK: begin
				if(speed_d1 != speed_d2) next_state = IDLE;
				else next_state = WORK;
			end
			default: next_state = IDLE;
		endcase
	end

	always@(posedge clk or posedge rst) begin
		if(rst) num <= 8'h00;
		else if(state == IDLE) num <= num + 1'b1;
		else num <= 8'h00;
	end

	// Data Section
	always@(posedge clk or posedge rst) begin
		if(rst) e_rxdv <= 1'b0;
		else if(eth_10m) e_rxdv <= gmii_100_rxdv;
		else if(eth_100m) e_rxdv <= gmii_100_rxdv;
		else if(eth_1000m) e_rxdv <= gmii_rxdv;
		else e_rxdv <= e_rxdv;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) e_rxd <= 8'h00;
		else if(eth_10m) e_rxd <= gmii_100_rxd;
		else if(eth_100m) e_rxd <= gmii_100_rxd;
		else if(eth_1000m) e_rxd <= gmii_rxd;
		else e_exd <= e_rxd;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) gmii_txen <= 1'b0;
		else if(eth_10m) gmii_txen <= e_100_txen;
		else if(eth_100m) gmii_txen <= e_100_txen;
		else if(eth_1000m) gmii_txen <= e_txen;
		else gmii_txen <= gmii_txen;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) gmii_txd <= 8'h00;
		else if(eth_10m) gmii_txd <= e_100_txd; 
		else if(eth_100m) gmii_txd <= e_100_txd; 
		else if(eth_1000m) gmii_txd <= e_txd; 
		else gmii_txd <= gmii_txd;
	end

	gmii_tx_buffer
	gmii_tx_buffer_dut(

	);





	





	


	







endmodule