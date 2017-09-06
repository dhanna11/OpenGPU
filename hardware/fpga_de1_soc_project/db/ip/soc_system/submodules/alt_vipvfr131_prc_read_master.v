module alt_vipvfr131_prc_read_master
	(	clock,
		reset,
        
    //interface to cusp
    ena,
    stall,
    
    //cmd port
    cmd_addr,
    cmd_write_instead_of_read,  
    cmd_burst_instead_of_single_op,
    cmd_length_of_burst, //len_be is the length of the "berst" (burst)?
    cmd,
    
    
    //wdata port // this is only a read master implementation
    /*wdata,
    wenable,
    wenable_en,*/
    
    //rdata port
    read_data,
    read,
    
    
    //unpacker specific controls
    discard_remaining_data_of_read_word,
    
    //interrupt port //not using
    //activeirqs,    
    
    //interface to avalon
    av_address,
    av_burstcount,
    av_writedata,
    //av_byteenable,
    av_write,
    av_read,
    av_clock,
    av_reset,
    av_readdata,
    av_readdatavalid,
    av_waitrequest,
    //av_interrupt
	  
	  );

parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 16;
parameter MAX_BURST_LENGTH_REQUIREDWIDTH = 11;
parameter READ_USED = 1;
parameter READ_FIFO_DEPTH = 8;
parameter COMMAND_FIFO_DEPTH = 8;
parameter READ_TARGET_BURST_SIZE = 5;
parameter CLOCKS_ARE_SAME = 1;
parameter BURST_WIDTH = 6;
parameter UNPACKED_WIDTH = 16;

input		clock;
input		reset;
	  
//interface to cusp
input ena;
output stall;

//cmd port
input [ADDR_WIDTH-1 : 0]	cmd_addr;
input cmd_write_instead_of_read; 
input cmd_burst_instead_of_single_op;
input [MAX_BURST_LENGTH_REQUIREDWIDTH-1 : 0] cmd_length_of_burst;
input cmd;


//rdata port
output [UNPACKED_WIDTH-1 : 0] 	read_data;
input read;


//unpacker specific
input discard_remaining_data_of_read_word;

        
//avalon 
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

wire read_FROM_width_adaptor_TO_master_fifo;
wire [DATA_WIDTH-1:0] readdata_FROM_master_fifo_TO_width_adaptor;

// instantiate FU
alt_vipvfr131_common_avalon_mm_bursting_master_fifo
	#(.ADDR_WIDTH (ADDR_WIDTH),
		.DATA_WIDTH (DATA_WIDTH),
		.READ_USED (READ_USED),
		.WRITE_USED (0),
		.CMD_FIFO_DEPTH (COMMAND_FIFO_DEPTH),
		.RDATA_FIFO_DEPTH (READ_FIFO_DEPTH),
		.WDATA_FIFO_DEPTH (0),
		.WDATA_TARGET_BURST_SIZE (0),
		.RDATA_TARGET_BURST_SIZE (READ_TARGET_BURST_SIZE),
		.CLOCKS_ARE_SYNC (CLOCKS_ARE_SAME),
		.BYTEENABLE_USED (0),  // not used
		.LEN_BE_WIDTH (MAX_BURST_LENGTH_REQUIREDWIDTH),
		.BURST_WIDTH (BURST_WIDTH),
		.INTERRUPT_USED (0), // not used
		.INTERRUPT_WIDTH (8))
master_fifo
	(	.clock (clock),
		.reset (reset),
		
		.ena (ena),
		.ready (),		
		.stall (stall), 

		//command interface
		.addr (cmd_addr),
		.write (cmd_write_instead_of_read), 
		.burst (cmd_burst_instead_of_single_op), 
		.len_be (cmd_length_of_burst), //len_be is the length of the "berst" (burst)?
		.cenable (1'b1),
		.cenable_en (cmd),
		
		//these are unused
		.wdata (),
		.wenable (),
		.wenable_en(),
		
		//read interface
		.rdata (readdata_FROM_master_fifo_TO_width_adaptor),
		.renable (1'b1), //jam this high as it is anded with renable_en.
		.renable_en (read_FROM_width_adaptor_TO_master_fifo),
		
		//irqs		
		.activeirqs (), // not used
		
		//avalon
		.av_address (av_address),
		.av_burstcount (av_burstcount),
		.av_writedata (av_writedata),
		.av_byteenable (), // not used
		.av_write (av_write),
		.av_read (av_read),
		.av_clock (av_clock),
		.av_reset (av_reset), // POTENTIALLY not used inside FU
		.av_readdata (av_readdata),
		.av_readdatavalid (av_readdatavalid),	
		.av_waitrequest (av_waitrequest),
		.av_interrupt (8'd0)// not used
		); 
		
// Cusp FU instantiation
alt_vipvfr131_common_pulling_width_adapter
	#(.IN_WIDTH (DATA_WIDTH),
    .OUT_WIDTH (UNPACKED_WIDTH)
	)
width_adaptor
  ( .clock (clock),
    .reset (reset),
    
    .input_data (readdata_FROM_master_fifo_TO_width_adaptor),
    .need_input (read_FROM_width_adaptor_TO_master_fifo),
    
    .output_data (read_data),
    .pull (1'b1),
    .pull_en (read),
    
    .discard (1'b1),
    .discard_en (discard_remaining_data_of_read_word),
    
    .ena (ena)
  );

		
endmodule		
