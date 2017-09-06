// wrapper for alt_vipvfr131_common_pulling_width_adapter (CusP FU)
module alt_vipvfr131_common_unpack_data

	(	clock,
		reset,
		
	  // read interface (memory side)
	  data_in,
	  read,
	  stall_in,
		
		// write interface (user side)
	  data_out,
	  write,
	  stall_out,
	  
	  // clear buffer
	  clear);

// DATA_WIDTH_IN must not be smaller than DATA_WIDTH_OUT!	  
parameter DATA_WIDTH_IN = 128;
parameter DATA_WIDTH_OUT = 24;

input		clock;
input		reset;
	  
// read interface
input		[DATA_WIDTH_IN - 1 : 0] data_in;
//output	reg read;
output  read;
input		stall_in;
		
// write interface
input		stall_out;
output	reg write;
output	[DATA_WIDTH_OUT - 1:0] data_out;

input		clear;

wire need_input;
wire ena;

assign ena = ~stall_in;

/*always @(posedge clock or posedge reset)
	if (reset)
		read <= 1'b0;
	else
		read <= need_input;
*/
assign read = need_input;

// Cusp FU instantiation
alt_vipvfr131_common_pulling_width_adapter
	#(.IN_WIDTH (DATA_WIDTH_IN),
    .OUT_WIDTH (DATA_WIDTH_OUT)
	)
fu_inst
  ( .clock (clock),
    .reset (reset),
    .input_data (data_in),
    .need_input (need_input),
    .output_data (data_out),
    .pull (1'b1), // not explicitely needed
    .pull_en (~stall_out),
    .discard (1'b1), // not explicitely needed
    .discard_en (clear),
    .ena (ena)
  );

always @(posedge clock or posedge reset)
	if (reset) begin
		write <= 1'b0;
	end
	else if (~stall_out) begin
		write <= ena;
	end
		
endmodule
		
					
			
