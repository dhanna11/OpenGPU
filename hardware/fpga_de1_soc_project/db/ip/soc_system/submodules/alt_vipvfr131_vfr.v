module alt_vipvfr131_vfr

	(	clock,
		reset,
		
	  // Avalon-MM master interface
	  master_clock,
	  master_reset,
	  master_address,
	  master_burstcount,
	  master_readdata,
	  master_read,
	  master_readdatavalid,
	  master_waitrequest,
		
	  // Avalon-MM slave interface
	  slave_address,
	  slave_write,
	  slave_writedata,
	  slave_read,
	  slave_readdata,
	  slave_irq,
	  
		// Avalon-ST source interface
	  dout_ready,
	  dout_valid,
	  dout_data,
	  dout_startofpacket,
	  dout_endofpacket);

//Though the standard is to specify channels in parallel and sequence, it makes no sense for this core
//As channels in sequence has no effect	  
parameter BITS_PER_PIXEL_PER_COLOR_PLANE = 8;
parameter NUMBER_OF_CHANNELS_IN_PARALLEL = 3; //Possibly change to number of channels in parallel.
parameter NUMBER_OF_CHANNELS_IN_SEQUENCE = 1;
parameter MAX_IMAGE_WIDTH = 1920; // maximum
parameter MAX_IMAGE_HEIGHT = 1080; // maximum
parameter MEM_PORT_WIDTH = 256;
parameter RMASTER_FIFO_DEPTH = 128;
parameter RMASTER_BURST_TARGET = 64;
parameter CLOCKS_ARE_SEPARATE = 1;


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

localparam DATA_WIDTH = BITS_PER_PIXEL_PER_COLOR_PLANE * NUMBER_OF_CHANNELS_IN_PARALLEL;
localparam MM_ADDR_REQUIREDWIDTH = 32; // all VIP cores use 32
localparam MM_MASTER_BURST_REQUIREDWIDTH = alt_vipfunc_required_width(RMASTER_BURST_TARGET);
localparam SLAVE_ADDRESS_REQUIREDWIDTH = 5; // up to 8 PRC control registers
localparam SLAVE_DATA_REQUIREDWIDTH = 32; // 32 bit wide control registers for VFR



input		clock;
input		reset;
	  
// Avalon-MM master interface
input 																				master_clock;
input																					master_reset;
output 	[MM_ADDR_REQUIREDWIDTH-1 : 0] 				master_address;
output	[MM_MASTER_BURST_REQUIREDWIDTH-1 : 0] master_burstcount;
input		[MEM_PORT_WIDTH-1 : 0] 								master_readdata;
output																				master_read;
input																					master_readdatavalid;
input																					master_waitrequest;	
	
// Avalon-MM slave interface	
input [SLAVE_ADDRESS_REQUIREDWIDTH-1:0] 			slave_address;
input 																				slave_read;
output [SLAVE_DATA_REQUIREDWIDTH-1:0]         slave_readdata;
input                               					slave_write;
input [SLAVE_DATA_REQUIREDWIDTH-1:0]          slave_writedata;
output	   																		slave_irq;

// Avalon-ST source interface
input																					dout_ready;
output																				dout_valid;
output																				dout_startofpacket;
output																				dout_endofpacket;
output [DATA_WIDTH-1:0] dout_data;

//instantiate a packet reader

wire ready_FROM_encoder_TO_prc;
wire valid_FROM_prc_TO_encoder;
wire [DATA_WIDTH-1:0] data_FROM_prc_TO_encoder;
wire sop_FROM_prc_TO_encoder;
wire eop_FROM_prc_TO_encoder;

localparam INTERNAL_MASTER_DATA_REQUIREDWIDTH = 32;
localparam INTERNAL_MASTER_ADDRESS_REQUIREDWIDTH = 32;

wire [INTERNAL_MASTER_ADDRESS_REQUIREDWIDTH-1:0] master_address_FROM_controller_TO_prc;
wire master_write_FROM_controller_TO_prc;
wire [INTERNAL_MASTER_DATA_REQUIREDWIDTH-1:0] master_writedata_FROM_controller_TO_prc;
wire slave_irq_FROM_prc_TO_controller;

  alt_vipvfr131_prc #(
    .BPS(BITS_PER_PIXEL_PER_COLOR_PLANE),
    .CHANNELS_IN_PAR(NUMBER_OF_CHANNELS_IN_PARALLEL),
    .CHANNELS_IN_SEQ(NUMBER_OF_CHANNELS_IN_SEQUENCE),
    .MAX_WIDTH(MAX_IMAGE_WIDTH),
    .MAX_HEIGHT(MAX_IMAGE_HEIGHT),
    .MEM_PORT_WIDTH(MEM_PORT_WIDTH),
    .RMASTER_FIFO_DEPTH(RMASTER_FIFO_DEPTH),
    .RMASTER_BURST_TARGET(RMASTER_BURST_TARGET),
    .CLOCKS_ARE_SEPARATE(CLOCKS_ARE_SEPARATE),
    .READY_LATENCY(0))
	prc(
		.clock(clock),
		.reset(reset),
		
		//wire the master straight through, there's nothing to be done to that
		.master_av_clock(master_clock),
		.master_av_reset(master_reset),
		.master_av_address(master_address),
		.master_av_burstcount(master_burstcount),
		.master_av_readdata(master_readdata),
		.master_av_read(master_read),
		.master_av_readdatavalid(master_readdatavalid),
		.master_av_waitrequest(master_waitrequest),
		
		//connect the streaming port straight to the encoder
		.dout_valid(valid_FROM_prc_TO_encoder),
		.dout_ready(ready_FROM_encoder_TO_prc),
		.dout_data(data_FROM_prc_TO_encoder),
		.dout_startofpacket(sop_FROM_prc_TO_encoder),
		.dout_endofpacket(eop_FROM_prc_TO_encoder),
		
		.control_av_address(master_address_FROM_controller_TO_prc),
		.control_av_write(master_write_FROM_controller_TO_prc),
		.control_av_writedata(master_writedata_FROM_controller_TO_prc),
		.control_av_read(),
		.control_av_readdata(),
		.control_av_irq(slave_irq_FROM_prc_TO_controller)
	);

//instantiate a controller

localparam CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH = 16;
localparam CONTROL_PACKET_INTERLACED_REQUIREDWIDTH = 4;

wire [CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1 : 0 ] width_FROM_controller_TO_encoder;
wire [CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1 : 0 ] height_FROM_controller_TO_encoder;
wire [CONTROL_PACKET_INTERLACED_REQUIREDWIDTH-1 : 0 ] interlaced_FROM_controller_TO_encoder;
wire do_control_packet_FROM_controller_TO_encoder;

wire go_bit_FROM_slave_TO_controller;
wire status_bit_zero_FROM_controller_TO_slave;
wire irq_FROM_controller_TO_slave;

//These wires will be used to break up the registers from the slave
wire next_bank_FROM_slave_TO_controller;

wire [CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1 : 0 ] ctrl_packet_width_bank0_bits_FROM_slave_TO_controller;
wire [CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1 : 0 ] ctrl_packet_height_bank0_bits_FROM_slave_TO_controller;
wire [CONTROL_PACKET_INTERLACED_REQUIREDWIDTH-1 : 0 ] ctrl_packet_interlaced_bank0_bits_FROM_slave_TO_controller;

//this is slave_data_requiredwidth as it is going to be the maxmimum, probably want to look into
//deriving some of these constants from eachother as they are not unique.
wire [SLAVE_DATA_REQUIREDWIDTH-1 : 0] vid_packet_base_address_bank0_bits_FROM_slave_TO_controller;
wire [SLAVE_DATA_REQUIREDWIDTH-1 : 0] vid_packet_samples_bank0_bits_FROM_slave_TO_controller;
wire [SLAVE_DATA_REQUIREDWIDTH-1 : 0] vid_packet_words_bank0_bits_FROM_slave_TO_controller;

wire [CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1 : 0 ] ctrl_packet_width_bank1_bits_FROM_slave_TO_controller;
wire [CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1 : 0 ] ctrl_packet_height_bank1_bits_FROM_slave_TO_controller;
wire [CONTROL_PACKET_INTERLACED_REQUIREDWIDTH-1 : 0 ] ctrl_packet_interlaced_bank1_bits_FROM_slave_TO_controller;

wire [SLAVE_DATA_REQUIREDWIDTH-1 : 0] vid_packet_base_address_bank1_bits_FROM_slave_TO_controller;
wire [SLAVE_DATA_REQUIREDWIDTH-1 : 0] vid_packet_samples_bank1_bits_FROM_slave_TO_controller;
wire [SLAVE_DATA_REQUIREDWIDTH-1 : 0] vid_packet_words_bank1_bits_FROM_slave_TO_controller;

alt_vipvfr131_vfr_controller #(
  .CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH(CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH),
  .CONTROL_PACKET_INTERLACED_REQUIREDWIDTH(CONTROL_PACKET_INTERLACED_REQUIREDWIDTH),
  .PACKET_ADDRESS_WIDTH(32),
  .PACKET_SAMPLES_WIDTH(32),
  .PACKET_WORDS_WIDTH(32))
  controller(
		.clock(clock),
		.reset(reset),
    
    .master_address(master_address_FROM_controller_TO_prc),
    .master_write(master_write_FROM_controller_TO_prc),
    .master_writedata(master_writedata_FROM_controller_TO_prc),
		.master_interrupt_recieve(slave_irq_FROM_prc_TO_controller),
    
    .go_bit(go_bit_FROM_slave_TO_controller),
    .running(status_bit_zero_FROM_controller_TO_slave),
    .frame_complete(irq_FROM_controller_TO_slave),    
    .next_bank(next_bank_FROM_slave_TO_controller),
    
    .ctrl_packet_width_bank0(ctrl_packet_width_bank0_bits_FROM_slave_TO_controller),
    .ctrl_packet_height_bank0(ctrl_packet_height_bank0_bits_FROM_slave_TO_controller),
    .ctrl_packet_interlaced_bank0(ctrl_packet_interlaced_bank0_bits_FROM_slave_TO_controller),
    
    .vid_packet_base_address_bank0(vid_packet_base_address_bank0_bits_FROM_slave_TO_controller),
    .vid_packet_samples_bank0(vid_packet_samples_bank0_bits_FROM_slave_TO_controller),
    .vid_packet_words_bank0(vid_packet_words_bank0_bits_FROM_slave_TO_controller),
    
    .ctrl_packet_width_bank1(ctrl_packet_width_bank1_bits_FROM_slave_TO_controller),
    .ctrl_packet_height_bank1(ctrl_packet_height_bank1_bits_FROM_slave_TO_controller),
    .ctrl_packet_interlaced_bank1(ctrl_packet_interlaced_bank1_bits_FROM_slave_TO_controller),
    
    .vid_packet_base_address_bank1(vid_packet_base_address_bank1_bits_FROM_slave_TO_controller),
    .vid_packet_samples_bank1(vid_packet_samples_bank1_bits_FROM_slave_TO_controller),
    .vid_packet_words_bank1(vid_packet_words_bank1_bits_FROM_slave_TO_controller),
    
    .width_of_next_vid_packet(width_FROM_controller_TO_encoder),
    .height_of_next_vid_packet(height_FROM_controller_TO_encoder),
    .interlaced_of_next_vid_packet(interlaced_FROM_controller_TO_encoder),
    .do_control_packet(do_control_packet_FROM_controller_TO_encoder)
  );
 
//instantiate a slave
localparam NO_REGISTERS = 18;
wire stopped;
wire enable;
wire clear_enable;
wire [NO_REGISTERS-1:0] triggers;  // not used here
wire [(SLAVE_DATA_REQUIREDWIDTH * NO_REGISTERS)-1:0] registers;
wire [(SLAVE_DATA_REQUIREDWIDTH * NO_REGISTERS)-1:0] registers_in;  // not used here
assign registers_in = {(SLAVE_DATA_REQUIREDWIDTH * NO_REGISTERS){1'b0}};
wire [NO_REGISTERS-1:0] registers_write; // not used here
assign registers_write = {NO_REGISTERS{1'b0}};
//instantiate an avalon slave
// Avalon-ST slave with control registers
alt_vipvfr131_common_avalon_mm_slave
  #(
    //width of the address, should be static, 32 registers is the smallest fit
    .AV_ADDRESS_WIDTH (SLAVE_ADDRESS_REQUIREDWIDTH),
    //32 bit registers required for addresses (and to match standard)
    .AV_DATA_WIDTH (SLAVE_DATA_REQUIREDWIDTH),
    //this is the number of AvST outputs of the attached core... STC
    .NO_OUTPUTS (1),    
    //one interrupt which goes high after a sequence of frames has been output
    //independent of repeat sequence or stop behaviour
    .NO_INTERRUPTS (1),
    //there are 3 standard registers, go, status, interrupt
    //there is 1 next packet bank register
    //there are 2x7 packet registers
    //totals 18
    .NO_REGISTERS (NO_REGISTERS),
    .ALLOW_INTERNAL_WRITE (0))
slave
  (
  	.rst (reset),
    .clk (clock),
    
    // control these connect straight through
    .av_address (slave_address),
    .av_read (slave_read),
    .av_readdata (slave_readdata),
    .av_write (slave_write),
    .av_writedata (slave_writedata),
    .av_irq (slave_irq),
    
    // internal
    .enable (go_bit_FROM_slave_TO_controller),
    .clear_enable (1'b0), // clear go bit from internally
    .triggers (triggers),
    .registers (registers),
    .registers_in (registers_in),
    .registers_write (registers_write),
    .interrupts (irq_FROM_controller_TO_slave),
    .stopped (status_bit_zero_FROM_controller_TO_slave)
  );   
 
//doing some translation of the slave registers into grouped wires for the controller
assign next_bank_FROM_slave_TO_controller = registers[0];

//this is slave_data_requiredwidth as it is going to be the maxmimum, probably want to look into
//deriving some of these constants from eachother as they are not unique.
assign vid_packet_base_address_bank0_bits_FROM_slave_TO_controller=  registers[(SLAVE_DATA_REQUIREDWIDTH*1)+SLAVE_DATA_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*1];
assign vid_packet_words_bank0_bits_FROM_slave_TO_controller =        registers[(SLAVE_DATA_REQUIREDWIDTH*2)+SLAVE_DATA_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*2];
assign vid_packet_samples_bank0_bits_FROM_slave_TO_controller =      registers[(SLAVE_DATA_REQUIREDWIDTH*3)+SLAVE_DATA_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*3];
assign ctrl_packet_width_bank0_bits_FROM_slave_TO_controller =       registers[(SLAVE_DATA_REQUIREDWIDTH*5)+CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*5];
assign ctrl_packet_height_bank0_bits_FROM_slave_TO_controller =     registers[(SLAVE_DATA_REQUIREDWIDTH*6)+CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*6];
assign ctrl_packet_interlaced_bank0_bits_FROM_slave_TO_controller =  registers[(SLAVE_DATA_REQUIREDWIDTH*7)+CONTROL_PACKET_INTERLACED_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*7];

assign vid_packet_base_address_bank1_bits_FROM_slave_TO_controller=  registers[(SLAVE_DATA_REQUIREDWIDTH*8)+SLAVE_DATA_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*8];
assign vid_packet_words_bank1_bits_FROM_slave_TO_controller =        registers[(SLAVE_DATA_REQUIREDWIDTH*9)+SLAVE_DATA_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*9];
assign vid_packet_samples_bank1_bits_FROM_slave_TO_controller =      registers[(SLAVE_DATA_REQUIREDWIDTH*10)+SLAVE_DATA_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*10];
assign ctrl_packet_width_bank1_bits_FROM_slave_TO_controller =       registers[(SLAVE_DATA_REQUIREDWIDTH*12)+CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*12];
assign ctrl_packet_height_bank1_bits_FROM_slave_TO_controller =     registers[(SLAVE_DATA_REQUIREDWIDTH*13)+CONTROL_PACKET_RESOLUTION_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*13];
assign ctrl_packet_interlaced_bank1_bits_FROM_slave_TO_controller =  registers[(SLAVE_DATA_REQUIREDWIDTH*14)+CONTROL_PACKET_INTERLACED_REQUIREDWIDTH-1:SLAVE_DATA_REQUIREDWIDTH*14];
 
//instantiate a control packet encoder

wire ready_FROM_outputter_TO_encoder;
wire valid_FROM_encoder_TO_outputter;
wire sop_FROM_encoder_TO_outputter;
wire eop_FROM_encoder_TO_outputter;
wire [DATA_WIDTH-1:0] data_FROM_encoder_TO_outputter;

alt_vipvfr131_vfr_control_packet_encoder
	#(
		.BITS_PER_SYMBOL(BITS_PER_PIXEL_PER_COLOR_PLANE),
		.SYMBOLS_PER_BEAT(NUMBER_OF_CHANNELS_IN_PARALLEL))
encoder
	(		
		.clk(clock),
		.rst(reset),
	
		// Avalon-ST sink interface (expect only video packets on this)
		.din_ready(ready_FROM_encoder_TO_prc),
		.din_valid(valid_FROM_prc_TO_encoder),
		.din_data(data_FROM_prc_TO_encoder),
		.din_sop(sop_FROM_prc_TO_encoder),
		.din_eop(eop_FROM_prc_TO_encoder),
		
		// Avalon-ST source interface (external)
		.dout_ready(ready_FROM_outputter_TO_encoder),
		.dout_valid(valid_FROM_encoder_TO_outputter),
		.dout_sop(sop_FROM_encoder_TO_outputter),
		.dout_eop(eop_FROM_encoder_TO_outputter),
		.dout_data(data_FROM_encoder_TO_outputter),
		
		// control signals
		.do_control_packet(do_control_packet_FROM_controller_TO_encoder),		
		.width(width_FROM_controller_TO_encoder),
		.height(height_FROM_controller_TO_encoder),
		.interlaced(interlaced_FROM_controller_TO_encoder)	
	);

//instantiate an avalon output
	alt_vipvfr131_common_stream_output
		#(.DATA_WIDTH (DATA_WIDTH))
		outputter
		(	.clk (clock),
			.rst (reset),
			.dout_ready (dout_ready),
			.dout_valid (dout_valid),
			.dout_data (dout_data),
			.dout_sop (dout_startofpacket),
			.dout_eop (dout_endofpacket),
			.int_ready (ready_FROM_outputter_TO_encoder),
			.int_valid (valid_FROM_encoder_TO_outputter),
			.int_data (data_FROM_encoder_TO_outputter),
			.int_sop (sop_FROM_encoder_TO_outputter),
			.int_eop (eop_FROM_encoder_TO_outputter),
			.enable (1'b1),
			.synced ()
	);


endmodule








