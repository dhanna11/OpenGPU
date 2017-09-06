module alt_vipvfr131_vfr_control_packet_encoder

	#(parameter BITS_PER_SYMBOL = 8,
		parameter SYMBOLS_PER_BEAT = 3)
		
	(	input		clk,
		input		rst,
	
		// Avalon-ST sink interface (expect only video packets on this)
		output	din_ready,
		input		din_valid,
		input		[BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 1:0] din_data,
		input		din_sop,
		input		din_eop,
		
		// Avalon-ST source interface (external)
		input		dout_ready,
		output	dout_valid,
		output	dout_sop,
		output	dout_eop,
		output	[BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 1:0] dout_data,
		
		// control signals
		input 	do_control_packet,		
		input		[15:0] width,
		input		[15:0] height,
		input		[3:0] interlaced);
		
// FSM states
localparam [3:0] IDLE            = 4'd15;
localparam [3:0] WAITING         = 4'd14;
localparam [3:0] WIDTH_3         = 4'd0;
localparam [3:0] WIDTH_2         = 4'd1;
localparam [3:0] WIDTH_1         = 4'd2;
localparam [3:0] WIDTH_0         = 4'd3;
localparam [3:0] HEIGHT_3        = 4'd4;
localparam [3:0] HEIGHT_2        = 4'd5;
localparam [3:0] HEIGHT_1        = 4'd6;
localparam [3:0] HEIGHT_0        = 4'd7;
localparam [3:0] INTERLACING     = 4'd8;
localparam [3:0] DUMMY_STATE     = 4'd9;
localparam [3:0] DUMMY_STATE2    = 4'd10;
localparam [3:0] DUMMY_STATE3    = 4'd12;
localparam [3:0] WAIT_FOR_END    = 4'd11;

localparam PACKET_LENGTH = 10;

// internal signals
reg [3:0] state;

wire sop;
wire eop;
wire [BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 1:0] data;
wire control_valid;
reg writing_control;

reg [BITS_PER_SYMBOL * SYMBOLS_PER_BEAT * (PACKET_LENGTH - 1) - 1 : 0] control_data;
wire [3:0] control_header_state [PACKET_LENGTH - 2: 0];
wire [BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 1:0] control_header_data [(PACKET_LENGTH-2) : 0];

// register control data when do_control_packet is high
always @(posedge clk or posedge rst)
	if (rst) begin
		control_data <= {(BITS_PER_SYMBOL * SYMBOLS_PER_BEAT * (PACKET_LENGTH - 1)){1'b0}};
	end
	else if (do_control_packet) begin
		control_data [3: 0] <= width [15:12]; // w3
		control_data [BITS_PER_SYMBOL + 3: BITS_PER_SYMBOL] <= width [11:8]; // w2
		control_data [2 * BITS_PER_SYMBOL + 3: 2 * BITS_PER_SYMBOL] <= width [7:4]; // w1
		control_data [3 * BITS_PER_SYMBOL + 3: 3 * BITS_PER_SYMBOL] <= width [3:0]; // w0
		control_data [4 * BITS_PER_SYMBOL + 3: 4 * BITS_PER_SYMBOL] <= height[15:12]; // h3
		control_data [5 * BITS_PER_SYMBOL + 3: 5 * BITS_PER_SYMBOL] <= height [11:8]; // h2
		control_data [6 * BITS_PER_SYMBOL + 3: 6 * BITS_PER_SYMBOL] <= height [7:4]; // h1
		control_data [7 * BITS_PER_SYMBOL + 3: 7 * BITS_PER_SYMBOL] <= height [3:0]; // h0
		control_data [8 * BITS_PER_SYMBOL + 3: 8 * BITS_PER_SYMBOL] <= interlaced; // int
	end	

generate
	begin : generate_control_header
  	genvar symbol;
    for(symbol = 0; symbol < PACKET_LENGTH - 1; symbol = symbol + SYMBOLS_PER_BEAT) begin : control_header_states
			assign control_header_state [symbol] = symbol + SYMBOLS_PER_BEAT;
			assign control_header_data [symbol] = control_data [((symbol + SYMBOLS_PER_BEAT) * BITS_PER_SYMBOL - 1) : (symbol * BITS_PER_SYMBOL)];
		end
	end
endgenerate

// Finite State Machine to insert encoded VIP control packets into data stream
always @(posedge clk or posedge rst)
	if (rst) begin
		state <= IDLE;
		writing_control <= 1'b1;
	end
	else begin
		
		case (state)
			
			//waiting to be told to write control packet, at this point there will be no other packets coming through
			//so we can begin as soon as we are told
			IDLE :	begin
				state <= do_control_packet ? (~dout_ready) ? WAITING : WIDTH_3 : IDLE;
				writing_control <= do_control_packet | writing_control;
			end
			
			//waiting for the output to become ready
			WAITING :	begin
				state 			<= (dout_ready) ? WIDTH_3 : WAITING;
				writing_control <= 1'b1;
			end
			
			WIDTH_3				: begin 
				state				<= dout_ready ? control_header_state [0] : WIDTH_3;
				writing_control <= 1'b1;
			end
			
			WIDTH_2				: begin 
				state				<= dout_ready ? control_header_state [1] : WIDTH_2;
				writing_control <= 1'b1;
			end
			
			WIDTH_1				: begin 
				state				<= dout_ready ? control_header_state [2] : WIDTH_1;
				writing_control <= 1'b1;
			end
			
			WIDTH_0				: begin 
				state				<= dout_ready ? control_header_state [3] : WIDTH_0;
				writing_control <= 1'b1;
			end
			
			HEIGHT_3			: begin 
				state				<= dout_ready ? control_header_state [4] : HEIGHT_3;
				writing_control <= 1'b1;
			end
			
			HEIGHT_2			: begin 
				state				<= dout_ready ? control_header_state [5] : HEIGHT_2;
				writing_control <= 1'b1;
			end
			
			HEIGHT_1			: begin 
				state				<= dout_ready ? control_header_state [6] : HEIGHT_1;
				writing_control <= 1'b1;
			end
			
			HEIGHT_0			: begin 
				state				<= dout_ready ? control_header_state [7] : HEIGHT_0;
				writing_control <= 1'b1;
			end
			
			INTERLACING		: begin 
				state				<= dout_ready ? control_header_state [8] : INTERLACING;
				writing_control <= 1'b1;
			end
			
			DUMMY_STATE		: begin 
				state 			<= dout_ready ? WAIT_FOR_END : DUMMY_STATE;
				writing_control <= 1'b1;
			end
			
			DUMMY_STATE2	: begin 
				state 			<= dout_ready ? WAIT_FOR_END : DUMMY_STATE2;
				writing_control <= 1'b1;
			end
			
			DUMMY_STATE3	: begin 
				state 			<= dout_ready ? WAIT_FOR_END : DUMMY_STATE3;
				writing_control <= 1'b1;
			end
			
			WAIT_FOR_END	: begin // wait for current video packet to end before accepting another do_control_packet
				state <= (din_valid & din_ready & din_eop) ? IDLE : WAIT_FOR_END;
				writing_control <= 1'b0;
			end
		endcase
	end	
	
assign control_valid = (state == IDLE) ? (do_control_packet & dout_ready) :
											 (state == WAIT_FOR_END | state == DUMMY_STATE | state == DUMMY_STATE2 | state == DUMMY_STATE3) ? 1'b0 : dout_ready;
assign data = (state == IDLE) ? {{(BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 4) {1'b0}}, 4'hf} :
							(state == WAITING) ? {{(BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 4) {1'b0}}, 4'hf} :
							(state == WIDTH_3) ? control_header_data [0] :
							(state == WIDTH_2) ? control_header_data [1] :
							(state == WIDTH_1) ? control_header_data [2] :
							(state == WIDTH_0) ? control_header_data [3] :
							(state == HEIGHT_3) ? control_header_data [4] :
							(state == HEIGHT_2) ? control_header_data [5] :
							(state == HEIGHT_1) ? control_header_data [6] :
							(state == HEIGHT_0) ? control_header_data [7] :
							(state == INTERLACING) ? control_header_data [8] :
							(state == DUMMY_STATE) ? {{(BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 4) {1'b0}}, 4'h0} :
							(state == DUMMY_STATE2) ? {{(BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 4) {1'b0}}, 4'h0} :
							(state == DUMMY_STATE3) ? {{(BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 4) {1'b0}}, 4'h0} : din_data;
assign sop = ((state == IDLE) || (state == WAITING)) ? 1'b1 : 1'b0;
assign eop = (state <= INTERLACING) ? (state == ((PACKET_LENGTH-2)/SYMBOLS_PER_BEAT * SYMBOLS_PER_BEAT)) : 1'b0;						
				
// combinatorial assignments of Avalon-ST signals	

//ready will have to be low if we are writing a control packet
assign din_ready = ~(do_control_packet | writing_control) & dout_ready;

//this connection through is a RL 0 one with flow control so need to look at the readyin and validin
assign dout_valid = control_valid ? 1'b1 : din_valid & din_ready;

//we can pass the data straight through as it's RL0
assign dout_data = control_valid ? data : din_data;
assign dout_sop = control_valid ? sop : din_sop;
assign dout_eop = control_valid ? eop : din_eop;
	
endmodule
		
					
			
