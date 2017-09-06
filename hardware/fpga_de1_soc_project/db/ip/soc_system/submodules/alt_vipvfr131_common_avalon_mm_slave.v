module alt_vipvfr131_common_avalon_mm_slave
  #(parameter
    AV_ADDRESS_WIDTH = 5,
    AV_DATA_WIDTH = 16,
    NO_OUTPUTS = 1,
    NO_INTERRUPTS = 1,  // NO_INTERRUPTS < AV_DATA_WIDTH!!!
    NO_REGISTERS = 4,
    ALLOW_INTERNAL_WRITE = 0) // writing to registers internally allowed or not
  (
  	input   wire                                        rst,
    input   wire                                        clk,
    
    // control
    input   wire [AV_ADDRESS_WIDTH-1:0]                 av_address,
    input   wire                                        av_read,
    output  reg  [AV_DATA_WIDTH-1:0]                    av_readdata,
    input   wire                                        av_write,
    input   wire [AV_DATA_WIDTH-1:0]                    av_writedata,
    output	   																					av_irq,
    
    // internal
    output  reg                                         enable,
    input																								clear_enable, // clear go bit from internally
    output  reg  [NO_REGISTERS-1:0]                     triggers,
    output  wire [(AV_DATA_WIDTH * NO_REGISTERS)-1:0]   registers,
    input   wire [(AV_DATA_WIDTH * NO_REGISTERS)-1:0]   registers_in,
    input   wire [NO_REGISTERS-1:0]                     registers_write,
    input   wire [NO_INTERRUPTS-1:0] 										interrupts,
    input   wire [NO_OUTPUTS-1:0]                       stopped);

	wire global_stopped;
	wire clear_interrupts;
	wire [NO_REGISTERS-1:0] triggers_nxt;
	reg  [AV_DATA_WIDTH-1:0] internal_registers[NO_REGISTERS-1:0];
	reg  [AV_DATA_WIDTH-1:0] interrupt_register;
	reg  [NO_INTERRUPTS-1:0] interrupt_enables;

	assign global_stopped = &stopped;
	assign clear_interrupts = av_write && (av_address == 2);  // clear selected interrupts when writing to interrupt register

	// Interrupt register implemenation
	generate
		genvar j;
		for (j = 0; j < AV_DATA_WIDTH; j = j+1) begin : interrupt_reg_loop
			always @(posedge clk or posedge rst)
				if (rst)
      		interrupt_register[j] <= 1'b0;
				else if (j <= NO_INTERRUPTS & j > 0)	
					interrupt_register[j] <= clear_interrupts ? interrupt_register[j] & ~av_writedata[j] :  // clear selected interrupts
																  	 interrupt_enables[j-1] ? interrupt_register[j] | interrupts[j-1] : 1'b0; // write enabled interrupts
		end
	endgenerate
			
	always @ (posedge clk or posedge rst) begin
    if(rst) begin
      enable <= 1'b0;
      interrupt_enables <= {NO_INTERRUPTS{1'b0}};
      av_readdata <= {AV_DATA_WIDTH{1'b0}};
    end else begin          
      if (clear_enable) begin
      	enable <= 1'b0;
      end
      if(av_write && (av_address == 0)) begin
        enable <= av_writedata[0];
        interrupt_enables <= av_writedata[NO_INTERRUPTS:1];
      end
      
  		if(av_read) begin
    		case(av_address)
   	  		0: av_readdata <= {{(AV_DATA_WIDTH-NO_INTERRUPTS-1){1'b0}}, interrupt_enables, enable};
      		1: av_readdata <= {{AV_DATA_WIDTH-1{1'b0}}, global_stopped};
       	  2: av_readdata <= {{(AV_DATA_WIDTH-NO_INTERRUPTS-1){1'b0}}, interrupt_register[NO_REGISTERS:1], 1'b0}; // bit 0 unused
       	  default: av_readdata <= internal_registers[av_address - 3];
      	endcase
    	end    
  	end
  end
        
	// av_irq is high if any of the individual enabled interrupts are high
	assign av_irq = |interrupt_register[NO_REGISTERS:1]; // bit 0 of Interrupt register unused

	// Register implementation
	generate
    genvar i;
    for(i = 0; i < NO_REGISTERS; i = i+1) begin : register_loop
      assign triggers_nxt[i] = (av_write && av_address == i + 3);
      localparam base_address = i * AV_DATA_WIDTH;
      assign registers[base_address + AV_DATA_WIDTH - 1:base_address] = internal_registers[i];
        
      // registers can be written to from master (av_writedata) or (if ALLOW_INTERNAL_WRITE = 1) from internal side (registers_in)
      always @ (posedge clk or posedge rst) begin
        if(rst) begin
          internal_registers[i] <= {AV_DATA_WIDTH{1'b0}};
          triggers[i] <= 1'b0;
        end else begin
          if(triggers_nxt[i]) begin // master has priority to write into registers
            internal_registers[i] <= av_writedata;
            triggers[i] <= triggers_nxt[i];
          end else if (ALLOW_INTERNAL_WRITE == 1 && registers_write[i]) begin // update from internal side only if master not writing at same time!
        		internal_registers[i] <= registers_in[base_address + AV_DATA_WIDTH - 1:base_address];
        		triggers[i] <= 1'b0; // if triggers[i] is 1 then av_writedata instead of register_in will have been written
          end         
        end
      end
    end
	endgenerate

endmodule
