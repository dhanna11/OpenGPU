module alt_vipvfr131_common_stream_output
    #(parameter
        DATA_WIDTH = 10)
    (
    input wire rst,
    input wire clk,
    
    // dout
    input   wire                    dout_ready,
    output  wire                    dout_valid,
    output  reg  [DATA_WIDTH-1:0]   dout_data,
    output  reg                     dout_sop,
    output  reg                     dout_eop,
    
    // internal
    output  wire                    int_ready,
    input   wire                    int_valid,
    input   wire [DATA_WIDTH-1:0]   int_data,
    input   wire                    int_sop,
    input   wire                    int_eop,
    
    // control signals
    input   wire                    enable,
    output  wire                    synced);

// Simple decode to detect the end of image packets. This allows us to
// synch multiple inputs.
reg     image_packet;
reg     synced_int;
reg     enable_synced_reg;
wire    image_packet_nxt;
wire    synced_int_nxt;
wire    enable_synced;
wire    eop;
wire 	sop;

always @ (posedge clk or posedge rst) begin
    if(rst) begin
        image_packet <= 1'b0;
        synced_int <= 1'b1;
        enable_synced_reg <= 1'b0;
    end else begin
        image_packet <= image_packet_nxt;
        synced_int <= synced_int_nxt;
        enable_synced_reg <= enable_synced;
    end
end

assign sop = dout_valid & dout_sop;
assign eop = dout_valid & dout_eop;
assign image_packet_nxt = (sop && dout_data == 0) || (image_packet && ~eop);
assign synced_int_nxt = (image_packet & eop) | (synced_int & ~sop);
assign enable_synced = (synced_int_nxt) ? enable : enable_synced_reg;
assign synced = ~enable_synced;

// Register outputs and ready input
reg int_valid_reg;
reg int_ready_reg;

always @ (posedge clk or posedge rst) begin
    if(rst) begin
        int_valid_reg <= 1'b0;
        dout_data <= {DATA_WIDTH{1'b0}};
        dout_sop <= 1'b0;
        dout_eop <= 1'b0;
        int_ready_reg <= 1'b0;
    end else begin
        if(int_ready_reg) begin
            if(enable_synced) begin
                int_valid_reg <= int_valid;
                dout_data <= int_data;
                dout_sop <= int_sop;
                dout_eop <= int_eop;
            end else begin
                int_valid_reg <= 1'b0;
            end 
        end
        
        int_ready_reg <= dout_ready;
    end
end

assign dout_valid = int_valid_reg & int_ready_reg;
assign int_ready = int_ready_reg & enable_synced;

endmodule
