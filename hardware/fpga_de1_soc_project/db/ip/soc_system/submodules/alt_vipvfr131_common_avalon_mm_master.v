module alt_vipvfr131_common_avalon_mm_master
	(	clock,
		reset,
		
	  // Avalon-MM master interface
	  av_clock,
	  av_reset,
	  av_address,
	  av_burstcount,
	  av_writedata,
	  av_readdata,
	  av_write,
	  av_read,
	  av_readdatavalid,
	  av_waitrequest,
		
	  // user algorithm interface
	  addr,
	  command,
	  is_burst,
	  is_write_not_read,
	  burst_length,
	  writedata,
	  write,
	  readdata,
	  read,
	  stall);

parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 16;
parameter MAX_BURST_LENGTH_REQUIREDWIDTH = 11;
parameter READ_USED = 1;
parameter WRITE_USED = 1;
parameter READ_FIFO_DEPTH = 8;
parameter WRITE_FIFO_DEPTH = 8;
parameter COMMAND_FIFO_DEPTH = 8;
parameter WRITE_TARGET_BURST_SIZE = 5;
parameter READ_TARGET_BURST_SIZE = 5;
parameter CLOCKS_ARE_SAME = 1;
parameter BURST_WIDTH = 6;

input		clock;
input		reset;
	  
// Avalon-MM master interface
input 	av_clock;
input 	av_reset;
output 	[ADDR_WIDTH-1 : 0] av_address;
output	[BURST_WIDTH-1 : 0] av_burstcount;
output	[DATA_WIDTH-1 : 0] av_writedata;
input		[DATA_WIDTH-1 : 0] av_readdata;
output	av_write;
output	av_read;
input		av_readdatavalid;
input		av_waitrequest;
	  
// user algorithm interface
input		[ADDR_WIDTH-1 : 0] addr;
input		command;
input		is_burst;
input		is_write_not_read;
input   [MAX_BURST_LENGTH_REQUIREDWIDTH-1 : 0] burst_length;
input		[DATA_WIDTH-1 : 0] writedata;
input		write;
output	[DATA_WIDTH-1 : 0] readdata;
input		read;
output	stall;
	


// instantiate FU
alt_vipvfr131_common_avalon_mm_bursting_master_fifo
	#(.ADDR_WIDTH (ADDR_WIDTH),
		.DATA_WIDTH (DATA_WIDTH),
		.READ_USED (READ_USED),
		.WRITE_USED (WRITE_USED),
		.CMD_FIFO_DEPTH (COMMAND_FIFO_DEPTH),
		.RDATA_FIFO_DEPTH (READ_FIFO_DEPTH),
		.WDATA_FIFO_DEPTH (WRITE_FIFO_DEPTH),
		.WDATA_TARGET_BURST_SIZE (WRITE_TARGET_BURST_SIZE),
		.RDATA_TARGET_BURST_SIZE (READ_TARGET_BURST_SIZE),
		.CLOCKS_ARE_SYNC (CLOCKS_ARE_SAME),
		.BYTEENABLE_USED (0),  // not used
		.LEN_BE_WIDTH (MAX_BURST_LENGTH_REQUIREDWIDTH),
		.BURST_WIDTH (BURST_WIDTH),
		.INTERRUPT_USED (0), // not used
		.INTERRUPT_WIDTH (8))
fu_inst
	(	.clock (clock),
		.reset (reset),
		
		// ena must go low when dependencies of this functional unit stall.
		// right now it's only dependent is itself as no other stalls affect it.
		.ena (!stall),
		.ready (),		
		
		.stall (stall), 
		//These stalls dont work with the single ena signal. So they aren't any use right now
		//.stall_read (stall_in), // new FU output
		//.stall_write (stall_out), // new FU output
		//.stall_command (stall_command), // new FU output
		.addr (addr),
		.write (is_write_not_read),
		.burst (is_burst),
		.len_be (burst_length),
		.cenable (1'b1),
		.cenable_en (command),
		.wdata (writedata),
		.wenable (1'b1),
		.wenable_en (write),
		.rdata (readdata),
		.renable (1'b1), 
		.renable_en (read),
		.activeirqs (), // not used
		.av_address (av_address),
		.av_burstcount (av_burstcount),
		.av_writedata (av_writedata),
		.av_byteenable (), // not used
		.av_write (av_write),
		.av_read (av_read),
		.av_clock (av_clock),  // not used if CLOCKS_ARE_SAME = 1
		.av_reset (av_reset), // not used inside FU
		.av_readdata (av_readdata),
		.av_readdatavalid (av_readdatavalid),	
		.av_waitrequest (av_waitrequest),
		.av_interrupt (8'd0)); // not used
		
endmodule		
