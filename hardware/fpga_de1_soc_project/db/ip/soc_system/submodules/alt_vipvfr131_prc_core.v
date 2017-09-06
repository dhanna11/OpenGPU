// Packet Reader Component (PRC) core
// this algorithm reads Avalon-ST video packets from external memory via Avalon-MM read master and passes it to Avalon-ST source interface
module alt_vipvfr131_prc_core
	(	
	
	clock,
	reset,
	stall,
	ena,
	
	read,
	data,
	discard_remaining_data_of_read_word,
		
	cmd_length_of_burst,
	cmd,
	cmd_addr,

	ready_out,
	valid_out,
	data_out,
	sop_out,
	eop_out,
	
	enable,
	clear_enable,
	stopped,
	complete,	
	packet_addr,
	packet_type,
	packet_samples,
	packet_words
	);
	
	parameter BITS_PER_SYMBOL = 8;
	parameter SYMBOLS_PER_BEAT = 3;
	parameter BURST_LENGTH_REQUIREDWIDTH = 7;
	parameter PACKET_SAMPLES_REQUIREDWIDTH = 32;
		
	localparam ADDR_WIDTH = 32; // same for all VIP cores, therefore local parameter
	localparam READ_LATENCY = 3;
	
	// I/Os
	input		clock;
	input		reset;
		
	// interface to top level control logic
	output 	stall;
	input		ena;
	
	// interface to master
	output reg	read;
	input		[BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 1:0] data;
	output 	reg discard_remaining_data_of_read_word;
	
	output  reg cmd;		//hold high to issue a command, note complex dependency on read.	
	output  reg [BURST_LENGTH_REQUIREDWIDTH-1:0] cmd_length_of_burst;
	output	reg [ADDR_WIDTH-1:0] cmd_addr;
	
	
				
	// Avalon-ST source interface
	input		ready_out;		
	output	valid_out;
	output 	[BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 1:0] data_out;
	output	sop_out;				
	output  eop_out;
	
	// Avalon-MM slave interface
	input		enable;		// GO bit
	output	reg clear_enable; // clear GO bit
	output	stopped;	// STATUS bit
	output  reg complete;	// IRQ bit 1
	input		[ADDR_WIDTH-1:0] packet_addr;
	input		[3:0] packet_type;
	input		[PACKET_SAMPLES_REQUIREDWIDTH-1:0] packet_samples;
	input		[BURST_LENGTH_REQUIREDWIDTH-1:0] packet_words;
		

// internal flow controlled signals				
reg [READ_LATENCY-1:0] input_valid_shift_reg;
reg [BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 1 : 0] data_out_d1;
reg sop_out_d1;
reg eop_out_d1;
		
/******************************************************************************/
/* Data processing of PRC algorithm starts here                              */
/******************************************************************************/
reg [BITS_PER_SYMBOL * SYMBOLS_PER_BEAT - 1:0] pre_data_out;
reg internal_output_is_valid;
reg pre_sop_out;
reg pre_eop_out;

reg [PACKET_SAMPLES_REQUIREDWIDTH-1:0] packet_samples_reg;
reg [PACKET_SAMPLES_REQUIREDWIDTH-1:0] reads_issued;
wire reads_complete;
//reads complete is a slightly odd wire name, in that once we have number of samples in - read latency
//we are sure we can issue a clear command to the unpacker and the last sample will come back intact
//The read output is actually held high to overread a bit, which doesnt hurt
assign reads_complete = (reads_issued == packet_samples_reg-1);

// simple FSM
localparam IDLE = 0;
localparam WAITING = 1;
localparam RUNNING = 2;
localparam ENDING = 3;

reg [1:0] state;


reg status;
integer i;
always @(posedge clock or posedge reset)
	if (reset) begin		
		state <= IDLE;
		status <= 1'b0;
		clear_enable <= 1'b1;
		cmd <= 1'b0;
		internal_output_is_valid <= 1'b0;
		pre_sop_out <= 1'b0;
		pre_eop_out <= 1'b0;
		complete <= 1'b0;
		input_valid_shift_reg <= {READ_LATENCY{1'b0}};
		discard_remaining_data_of_read_word <= 1'b0;
		read <= 1'b0;
		reads_issued <= {PACKET_SAMPLES_REQUIREDWIDTH{1'b0}};
	end
	else begin
		
		//This logic counts sucessfuly read requrests, the core only reads until required
		reads_issued <= read & ena & ~reads_complete ? reads_issued + 1'b1 : reads_issued;
	
		//input valid shift reg
		// only capture data if input valid (not stalled and reading)					
		if(ena) begin
			input_valid_shift_reg[READ_LATENCY-1] <= (read);
			for(i=0;i<READ_LATENCY-1;i=i+1) begin
				input_valid_shift_reg[i] <= input_valid_shift_reg[i+1];
			end
		end
		
		case (state)			
			//This state is pretty much for holding in while we wait for enable or for putting out the SOP and header
			IDLE :	begin
				
				//reset the reads_issued counter
				reads_issued <= {PACKET_SAMPLES_REQUIREDWIDTH{1'b0}};
			
				//check the discarding happened and if so drop the discard line low.
				if( ena & discard_remaining_data_of_read_word) begin
					discard_remaining_data_of_read_word <= 0;
				end
				
				//Make sure that clear enable is no longer asserted, this should already be the case though.
				clear_enable <= 1'b0;
				
				// keep eop high until ena is high, so we make sure the eop was ack'd/read
				if (pre_eop_out & ena) begin
					pre_eop_out <= 1'b0;			
				end
				
				//complete is the IRQ line which we are dropping low here without an explicit reset, this may be WRONG!
				complete <= 1'b0;
				
				if (enable & !discard_remaining_data_of_read_word) begin	//has the go bit been set on the control interface and have we cleared the extra data?, yes then begin!
				
					//we want to immediately stop the core for the next frame must do this as early as possible so the control port
					//can be programmed within 1 frame.
					clear_enable <= 1'b1;
					
					//set the core as in the status bit 0 high as it is now 'running'
					status <= 1'b1;
					
					//sample the control port and...
					//issue a command, the data's "appear" on the inputs to this module.
					//this will be set low in either of the next states
					cmd <= 1'b1;
					cmd_addr <= packet_addr;
					cmd_length_of_burst <= packet_words;
					//load into the packet_samples_reg the number of samples to check for
					packet_samples_reg <= packet_samples;
					
					//setup the sending of a SOP, the combi flow control will sort out the sending of this data
					internal_output_is_valid <= 1'b1;
					pre_sop_out <= 1'b1;
					pre_data_out <= packet_type;
					
					//ok transition to the waiting state
					state <= WAITING;
					
				//if we're not enabled
				end else begin
					//keep the "status" at stopped (0)
					status <= 1'b0;
					state <= IDLE;
					cmd <= 1'b0;
					internal_output_is_valid <= 1'b0;
					pre_sop_out <= 1'b0;
				end
			end
			
			//This state means the core has been enabled via the go bit, and we are sending the SOP
			WAITING : begin // wait for ready_out to be high			
				 
				//allow the enable value to be set externally again 
				clear_enable <= 1'b0;				
							
				//exiting the idle state would have set command to high
				//so if stall comes in low the command got sent ok
				if (cmd & ena) begin
					cmd <= 1'b0;			
				end
				
				//this means the SOP has been sent ok.
				if(ena) begin
					//it doesnt matter what we leave on the data port as it's not valid
					internal_output_is_valid <= 1'b0;
					pre_sop_out <= 1'b0;
					state <= RUNNING;
				end
			end

			// read until packet complete
			RUNNING : begin
				//the output is valid when the this shift reg position has a 1 in it this is counting when a data request is returned.
				//somewhat complexly when the output is not ready for data it is fed through the stall > ena > global_ena path
				//meaning no new data will be fed, so we dont need to buffer or anything here. 
				//the shift reg is also enabled from the ena.
				if(ena) begin
					internal_output_is_valid <= input_valid_shift_reg[0];
				end
							
				//if the command has sent ok or has already been sent (cmd low) then start issuing reads.
				if ((cmd & ena) | !cmd & !reads_complete) begin
					cmd <= 1'b0;
					read <= 1'b1;					
				end			
							
				// when reads complete, all the necessary reads have been issued
				// anded with ena to make sure the read we're currently on still gets issued
				if (reads_complete & ena) begin
					//dont want to be reading anymore, as this would block the next cmd 
					read <= 1'b0;
				end
				
				//as we're registering the output, we need to keep the value of data 1 cycle back when not ready at the output
				//(have a look at a waveform it makes sense, if the output wasnt registered we could put data straight through.)
				pre_data_out <= ena ? data : pre_data_out;

				//if this is the last sample of the current packet, we need to setup sending the EOP and move on
				//anded with ena to make sure the read were currently doing has been issued.
				if(input_valid_shift_reg==1 & reads_complete & ena) begin
				
					//if we've done all the reads we need to do and got all the data back we need
					//then we can discard the remaining data. This will get set low in the next state
					discard_remaining_data_of_read_word <= 1;
					
					//and we can set the eop bit high, the valid bit is still correctly sent by the input_valid_shift_reg
					pre_eop_out <= 1'b1;
					
					//transistion to ending state
					state <= ENDING;
					
				end else begin
					state <= RUNNING;
					pre_eop_out <= 1'b0;
				end
			end
			
			ENDING : begin // make sure the eop sent properly
				//hold this high
				internal_output_is_valid <= 1'b1;
			
				//check the discarding happened and if so drop the discard line low.
				if( ena & discard_remaining_data_of_read_word) begin
					discard_remaining_data_of_read_word <= 0;
				end
				
				//this means the EOP has been sent, prep to transition to the IDLE state
				if(ena) begin
					//core's not running anymore
					status <= 1'b0;
					
					//this is setting the IRQ high without checking that the IRQ is enabled, is this part of the slave? this may be WRONG!
					complete <= 1'b1;
					pre_eop_out <= 1'b0;
					state <= IDLE;
					internal_output_is_valid <= 1'b0;
				end
				
			end
			
		endcase
	end			




// assign outputs
assign stopped = ~status;


/******************************************************************************/
/* End of PRT algorithm data processing                                      */
/******************************************************************************/

/******************************************************************************/
/* Start of flow control processing                                           */
/******************************************************************************/

// the stall line will stall the data in process to this module on the same cycle,
// so when the output isnt ready the core wont push data
// this connects back up to the global ena signal.
assign stall = !ready_out;
assign valid_out = internal_output_is_valid & ena;

// hold data if not writing or output stalled, this is repeated functionality.
assign data_out = valid_out ? pre_data_out : data_out_d1;
assign eop_out = valid_out ? pre_eop_out : eop_out_d1;
assign sop_out = valid_out ? pre_sop_out : sop_out_d1;

// register internal flow controlled signals	
always @(posedge clock or posedge reset)
	if (reset) begin
		data_out_d1 <= {(BITS_PER_SYMBOL * SYMBOLS_PER_BEAT){1'b0}};
		sop_out_d1 <= 1'b0;
		eop_out_d1 <= 1'b0;
	end
	else begin
		data_out_d1 <= data_out;
		sop_out_d1 <= sop_out;
		eop_out_d1 <= eop_out;
	end
			
/******************************************************************************/
/* End of flow control processing                                             */
/******************************************************************************/		 	 	 	
endmodule
		
					
			
