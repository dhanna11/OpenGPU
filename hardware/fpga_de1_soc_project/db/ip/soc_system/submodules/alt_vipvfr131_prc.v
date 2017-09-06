// top-level module of Packet Reader Component (PRC)
module alt_vipvfr131_prc

	(	clock,
		reset,
		
	  // Avalon-MM master interface
	  master_av_clock,
	  master_av_reset,
	  master_av_address,
	  master_av_burstcount,
	  master_av_readdata,
	  master_av_read,
	  master_av_readdatavalid,
	  master_av_waitrequest,
		
	  // Avalon-MM slave interface
	  control_av_address,
	  control_av_write,
	  control_av_writedata,
	  control_av_read,
	  control_av_readdata,
	  control_av_irq,
	  
		// Avalon-ST source interface
	  dout_ready,
	  dout_valid,
	  dout_data,
	  dout_startofpacket,
	  dout_endofpacket);
	  
parameter BPS = 8;
parameter CHANNELS_IN_PAR = 3;
parameter CHANNELS_IN_SEQ = 1;
parameter MAX_WIDTH = 1920; // maximum
parameter MAX_HEIGHT = 1080; // maximum
parameter MEM_PORT_WIDTH = 256;
parameter RMASTER_FIFO_DEPTH = 128;
parameter RMASTER_BURST_TARGET = 64;
parameter CLOCKS_ARE_SEPARATE = 1;
parameter READY_LATENCY = 1; // use 0 if used as part of other IP, e.g. VFR

//This function returns the width in bits required to represent the passed number
//Max size input 512 bit value
function integer alt_vipfunc_required_width;
  input [511:0] value;
  integer i;
  begin
    alt_vipfunc_required_width = 512;
    for (i=512; i>0; i=i-1) begin
      if (2**i>value)
        alt_vipfunc_required_width = i;
    end
  end
endfunction

localparam 	MM_ADDR_REQUIREDWIDTH = 32; // all VIP cores use 32
localparam	MM_MASTER_BURST_REQUIREDWIDTH = alt_vipfunc_required_width(RMASTER_BURST_TARGET);
localparam	SAMPLES_PER_WORD = MEM_PORT_WIDTH/(BPS*CHANNELS_IN_PAR);
localparam	REMAINDER_WORD_REQUIRED = (MAX_WIDTH*MAX_HEIGHT*CHANNELS_IN_SEQ)%SAMPLES_PER_WORD == 0 ? 0 : 1;
localparam  MAX_BURST_LENGTH = ((MAX_WIDTH*MAX_HEIGHT*CHANNELS_IN_SEQ)/SAMPLES_PER_WORD) + REMAINDER_WORD_REQUIRED;
localparam  MAX_BURST_LENGTH_REQUIREDWIDTH = alt_vipfunc_required_width(MAX_BURST_LENGTH);
localparam	PACKET_SAMPLES_REQUIREDWIDTH = alt_vipfunc_required_width(MAX_WIDTH*MAX_HEIGHT*CHANNELS_IN_SEQ);

localparam 	SLAVE_ADDRESS_REQUIREDWIDTH = 3; // up to 8 PRC control registers
localparam	SLAVE_DATA_REQUIREDWIDTH = 32; // 32 bit wide control registers for PRC
localparam	NO_INTERRUPTS = 1; // irq[1] = complete
localparam	NO_REGISTERS = 4; // 4 registers containing packet information

input		clock;
input		reset;
	  
// Avalon-MM master interface
input  master_av_clock;
input  master_av_reset;
output [MM_ADDR_REQUIREDWIDTH-1 : 0] master_av_address;
output [MM_MASTER_BURST_REQUIREDWIDTH-1 : 0] master_av_burstcount;
input  [MEM_PORT_WIDTH-1 : 0] master_av_readdata;
output master_av_read;
input  master_av_readdatavalid;
input  master_av_waitrequest;	
	
// Avalon-MM slave interface	
input  [SLAVE_ADDRESS_REQUIREDWIDTH-1:0] control_av_address;
input  control_av_read;
output [SLAVE_DATA_REQUIREDWIDTH-1:0] control_av_readdata;
input  control_av_write;
input  [SLAVE_DATA_REQUIREDWIDTH-1:0] control_av_writedata;
output control_av_irq;

// Avalon-ST source interface
input  dout_ready;
output dout_valid;
output dout_startofpacket;
output dout_endofpacket;
output [BPS*CHANNELS_IN_PAR-1:0] dout_data;


// multipurpose signals from the read master
wire stall_FROM_read_master_TO_prc_core;

// internal signals between PRC core and read master
wire [MAX_BURST_LENGTH_REQUIREDWIDTH-1:0] cmd_length_of_burst_FROM_prc_core_TO_read_master;
wire [MM_ADDR_REQUIREDWIDTH-1:0] cmd_addr_FROM_prc_core_TO_read_master;
wire cmd_FROM_prc_core_TO_read_master;

// internal signals between PRC core and unpacker
wire read_FROM_prc_core_TO_read_master;
wire [BPS * CHANNELS_IN_PAR - 1:0] pixel_data_FROM_read_master_TO_prc_core;

wire discard_remaining_data_of_read_word_FROM_prc_core_TO_read_master;

// internal signals between unpacker and read master
wire [MEM_PORT_WIDTH-1 : 0] readdata_FROM_avalon_mm_read_master_TO_data_unpacker;
wire unpack_read_FROM_data_unpacker_TO_avalon_mm_read_master;

// internal signals between PRC core and control slave
wire enable; // GO bit
wire clear_enable; // clear GO bit from PRC core
wire stopped; // inverted STATUS bit
wire complete; // completion interrupt = IRQ bit 1
wire [MM_ADDR_REQUIREDWIDTH-1:0] packet_addr;
wire [3:0] packet_type;
wire [PACKET_SAMPLES_REQUIREDWIDTH-1:0] packet_samples;
wire [MAX_BURST_LENGTH_REQUIREDWIDTH-1:0] packet_words;

wire [NO_REGISTERS-1:0] triggers;  // not used here
wire [(SLAVE_DATA_REQUIREDWIDTH * NO_REGISTERS)-1:0] registers;
wire [(SLAVE_DATA_REQUIREDWIDTH * NO_REGISTERS)-1:0] registers_in;  // not used here
assign registers_in = {(SLAVE_DATA_REQUIREDWIDTH * NO_REGISTERS){1'b0}};
wire [NO_REGISTERS-1:0] registers_write; // not used here
assign registers_write = {NO_REGISTERS{1'b0}};
wire [NO_INTERRUPTS-1:0] interrupts;

// register assignments
assign packet_addr = registers[MM_ADDR_REQUIREDWIDTH-1:0];
assign packet_type = registers[SLAVE_DATA_REQUIREDWIDTH+3:SLAVE_DATA_REQUIREDWIDTH];
assign packet_samples = registers[2*SLAVE_DATA_REQUIREDWIDTH+PACKET_SAMPLES_REQUIREDWIDTH-1:2*SLAVE_DATA_REQUIREDWIDTH];
assign packet_words = registers[3*SLAVE_DATA_REQUIREDWIDTH+MAX_BURST_LENGTH_REQUIREDWIDTH-1:3*SLAVE_DATA_REQUIREDWIDTH];

// 2nd clock for (DC?) FIFO of the master interface
assign master_clock = (CLOCKS_ARE_SEPARATE) ? master_av_clock : clock;
assign master_reset = (CLOCKS_ARE_SEPARATE) ? master_av_reset : reset;

// interrupt assignments
assign interrupts[0] = complete;

// internal signals between PRC core and Avalon-ST source
wire	ready_out;
wire	valid_out;
wire	sop_out;
wire	eop_out;
wire	[BPS*CHANNELS_IN_PAR-1:0] data_out;

wire stall_FROM_read_master_TO_WIRE_global_ena;
wire stall_FROM_prc_core_TO_WIRE_global_ena;
wire global_ena = !(stall_FROM_read_master_TO_WIRE_global_ena | stall_FROM_prc_core_TO_WIRE_global_ena);


alt_vipvfr131_prc_read_master 
#(.ADDR_WIDTH (MM_ADDR_REQUIREDWIDTH),
    .DATA_WIDTH (MEM_PORT_WIDTH),
    .READ_USED (1),
    .COMMAND_FIFO_DEPTH (1),  
    .READ_FIFO_DEPTH (RMASTER_FIFO_DEPTH),
    .CLOCKS_ARE_SAME (!CLOCKS_ARE_SEPARATE),
    .MAX_BURST_LENGTH_REQUIREDWIDTH (MAX_BURST_LENGTH_REQUIREDWIDTH),
    .BURST_WIDTH (MM_MASTER_BURST_REQUIREDWIDTH),
    .READ_TARGET_BURST_SIZE (RMASTER_BURST_TARGET),
    .UNPACKED_WIDTH(BPS * CHANNELS_IN_PAR)
    )
read_master
(		.clock (clock),
		.reset (reset),
        
    .ena(global_ena),
    .stall(stall_FROM_read_master_TO_WIRE_global_ena),
    
    .cmd_addr(cmd_addr_FROM_prc_core_TO_read_master),
    .cmd_write_instead_of_read(1'b0),  //command is always a read
    .cmd_burst_instead_of_single_op(1'b1), //always going to be doing burst transfers
    .cmd_length_of_burst(cmd_length_of_burst_FROM_prc_core_TO_read_master),
    .cmd(cmd_FROM_prc_core_TO_read_master),

    .read_data(pixel_data_FROM_read_master_TO_prc_core),
    .read(read_FROM_prc_core_TO_read_master),
    .discard_remaining_data_of_read_word(discard_remaining_data_of_read_word_FROM_prc_core_TO_read_master),

    .av_address (master_av_address),
    .av_read (master_av_read),
    .av_clock (master_clock),
    .av_reset (master_reset),
    .av_readdata (master_av_readdata),
    .av_readdatavalid (master_av_readdatavalid),
    .av_waitrequest (master_av_waitrequest),
    .av_burstcount (master_av_burstcount)
 
); 

// packet reader core
alt_vipvfr131_prc_core
	#(.BITS_PER_SYMBOL (BPS),
		.SYMBOLS_PER_BEAT (CHANNELS_IN_PAR),
		.BURST_LENGTH_REQUIREDWIDTH (MAX_BURST_LENGTH_REQUIREDWIDTH),
		.PACKET_SAMPLES_REQUIREDWIDTH (PACKET_SAMPLES_REQUIREDWIDTH))

prc_core		
	(	.clock (clock),
		.reset (reset),
		
		.stall(stall_FROM_prc_core_TO_WIRE_global_ena),
		.ena(global_ena),
			
		.read (read_FROM_prc_core_TO_read_master),		
		.data (pixel_data_FROM_read_master_TO_prc_core),
		.discard_remaining_data_of_read_word (discard_remaining_data_of_read_word_FROM_prc_core_TO_read_master),
		
		// interface to Avalon-MM Read Master
		.cmd_length_of_burst (cmd_length_of_burst_FROM_prc_core_TO_read_master),
		.cmd (cmd_FROM_prc_core_TO_read_master),
		.cmd_addr (cmd_addr_FROM_prc_core_TO_read_master),		
				
		// interface to Avalon-MM slave
		.enable (enable),
		.clear_enable (clear_enable),
		.stopped (stopped),
		.complete (complete),
		.packet_addr (packet_addr),
		.packet_type (packet_type),
		.packet_words (packet_words),
		.packet_samples (packet_samples),
		
		// interface to Avalon-ST interface
		.ready_out (ready_out),		
		.valid_out (valid_out),
		.data_out (data_out),
		.sop_out (sop_out),
		.eop_out (eop_out));
	
// Avalon-ST slave with control registers
alt_vipvfr131_common_avalon_mm_slave
  #(.AV_ADDRESS_WIDTH (SLAVE_ADDRESS_REQUIREDWIDTH),
    .AV_DATA_WIDTH (SLAVE_DATA_REQUIREDWIDTH),
    .NO_OUTPUTS (1),
    .NO_INTERRUPTS (NO_INTERRUPTS),
    .NO_REGISTERS (NO_REGISTERS),
    .ALLOW_INTERNAL_WRITE (0))
avalon_mm_control_slave
  (
  	.rst (reset),
    .clk (clock),
    
    // control
    .av_address (control_av_address),
    .av_read (control_av_read),
    .av_readdata (control_av_readdata),
    .av_write (control_av_write),
    .av_writedata (control_av_writedata),
    .av_irq (control_av_irq),
    
    // internal
    .enable (enable),
    .clear_enable (clear_enable), // clear go bit from internally
    .triggers (triggers),
    .registers (registers),
    .registers_in (registers_in),
    .registers_write (registers_write),
    .interrupts (interrupts),
    .stopped (stopped));	
				
generate
	if (READY_LATENCY == 1) begin

		// VIP Avalon Stream Output
		alt_vipvfr131_common_stream_output
			#(.DATA_WIDTH (BPS * CHANNELS_IN_PAR))
			avalon_st_output
			(	.clk (clock),
				.rst (reset),
				.dout_ready (dout_ready),
				.dout_valid (dout_valid),
				.dout_data (dout_data),
				.dout_sop (dout_startofpacket),
				.dout_eop (dout_endofpacket),
				.int_ready (ready_out),
				.int_valid (valid_out),
				.int_data (data_out),
				.int_sop (sop_out),
				.int_eop (eop_out),
				.enable (1'b1),
				.synced ());											
	
	end else begin // Ready Latency = 0
		
		assign ready_out = dout_ready;
		assign dout_valid = valid_out;
		assign dout_data = data_out;
		assign dout_startofpacket = sop_out;
		assign dout_endofpacket = eop_out;
		
	end
endgenerate

endmodule
		
					
			
