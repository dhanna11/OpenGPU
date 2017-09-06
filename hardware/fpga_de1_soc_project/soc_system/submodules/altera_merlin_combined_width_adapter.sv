// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.0/ip/merlin/altera_merlin_combined_width_adapter/altera_merlin_combined_width_adapter.sv#1 $
// $Revision: #1 $
// $Date: 2013/02/11 $
// $Author: swbranch $

// -----------------------------------------------------
// Merlin Combined Width Adapter
// The command Width Adapter (WA) buffers the size for each 
// command, and pops it off to reconstruc the reponse.
// -----------------------------------------------------

`timescale 1 ns / 1 ns

module altera_merlin_combined_width_adapter
#(
    parameter IN_PKT_ADDR_L                 = 0,
    parameter IN_PKT_ADDR_H                 = 31,
    parameter IN_PKT_DATA_L                 = 32,
    parameter IN_PKT_DATA_H                 = 63,
    parameter IN_PKT_BYTEEN_L               = 64,
    parameter IN_PKT_BYTEEN_H               = 67,
    parameter IN_PKT_TRANS_COMPRESSED_READ  = 72,
    parameter IN_PKT_BYTE_CNT_L             = 73,
    parameter IN_PKT_BYTE_CNT_H             = 77,
    parameter IN_PKT_BURSTWRAP_L            = 78,
    parameter IN_PKT_BURSTWRAP_H            = 82,
    parameter IN_PKT_BURST_SIZE_L           = 83,
    parameter IN_PKT_BURST_SIZE_H           = 85,
    parameter IN_PKT_RESPONSE_STATUS_L      = 86,
    parameter IN_PKT_RESPONSE_STATUS_H      = 87,
    parameter IN_PKT_TRANS_EXCLUSIVE        = 88,
    parameter IN_PKT_BURST_TYPE_L           = 89,
    parameter IN_PKT_BURST_TYPE_H           = 90,
    parameter IN_PKT_TRANS_POSTED           = 91,
    parameter IN_ST_DATA_W                  = 110,

    parameter OUT_PKT_ADDR_L                = 0,
    parameter OUT_PKT_ADDR_H                = 31,
    parameter OUT_PKT_DATA_L                = 32,
    parameter OUT_PKT_DATA_H                = 47,
    parameter OUT_PKT_BYTEEN_L              = 48,
    parameter OUT_PKT_BYTEEN_H              = 49,
    parameter OUT_PKT_TRANS_COMPRESSED_READ = 54,
    parameter OUT_PKT_BYTE_CNT_L            = 55,
    parameter OUT_PKT_BYTE_CNT_H            = 59,
    parameter OUT_PKT_BURST_SIZE_L          = 60,
    parameter OUT_PKT_BURST_SIZE_H          = 62,
    parameter OUT_PKT_RESPONSE_STATUS_L     = 63,
    parameter OUT_PKT_RESPONSE_STATUS_H     = 64,
    parameter OUT_PKT_TRANS_EXCLUSIVE       = 65,
    parameter OUT_PKT_BURST_TYPE_L          = 66,
    parameter OUT_PKT_BURST_TYPE_H          = 67,
    parameter OUT_ST_DATA_W                 = 92,
                                            
    parameter ST_CHANNEL_W                  = 32,
    parameter MAX_OUTSTANDING_RESPONSES     = 16
)
( 
    
    input                           clk,
    input                           reset,
    output reg                      cmd_in_ready,
    input                           cmd_in_valid,
    input      [ST_CHANNEL_W-1:0]   cmd_in_channel,
    input      [IN_ST_DATA_W-1:0]   cmd_in_data,
    input                           cmd_in_startofpacket,
    input                           cmd_in_endofpacket,
    input                           cmd_out_ready,
    output reg                      cmd_out_valid,
    output reg [ST_CHANNEL_W-1:0]   cmd_out_channel,
    output reg [OUT_ST_DATA_W-1:0]  cmd_out_data,
    output reg                      cmd_out_startofpacket,
    output reg                      cmd_out_endofpacket,

    output reg                      rsp_in_ready,
    input                           rsp_in_valid,
    input      [ST_CHANNEL_W-1:0]   rsp_in_channel,
    input      [OUT_ST_DATA_W-1:0]  rsp_in_data,
    input                           rsp_in_startofpacket,
    input                           rsp_in_endofpacket,
    input                           rsp_out_ready,
    output reg                      rsp_out_valid,
    output reg [ST_CHANNEL_W-1:0]   rsp_out_channel,
    output reg [IN_ST_DATA_W-1:0]   rsp_out_data,
    output reg                      rsp_out_startofpacket,
    output reg                      rsp_out_endofpacket
);

    // ------------------------------------------------------------
    // Local Parameters
    // ------------------------------------------------------------
    
    localparam IN_BURST_SIZE_W       = IN_PKT_BURST_SIZE_H - IN_PKT_BURST_SIZE_L + 1;

    // ------------------------------------------------------------
    // Signals
    // ------------------------------------------------------------
    reg [IN_BURST_SIZE_W-1:0]   in_command_size_field; 
    reg [IN_BURST_SIZE_W-1:0]   out_command_size_field;
    reg                         pop_in_command_size;   
    wire                        pop_out_command_size;
    wire                        fifo_is_empty;
    wire                        fifo_is_full;
    wire                        command_is_posted;

    assign  in_command_size_field   =   cmd_in_data[IN_PKT_BURST_SIZE_H : IN_PKT_BURST_SIZE_L];
    
    // Write size to fifo when receive one command
    // Detect when incoming transaction is posted (avalon write transaction)
    // then we dont need to stored command size in the FIFO as no response is
    // needed then FIFO will be full and assertion happen
    assign command_is_posted        =   cmd_in_data[IN_PKT_TRANS_POSTED];
    always_comb
    begin
        pop_in_command_size =   1'b0;
        if (command_is_posted)  begin
            pop_in_command_size     =   1'b0;
        end else begin
            pop_in_command_size     =   cmd_in_ready & cmd_in_valid & cmd_in_startofpacket;
        end
    end

    // Pop out command size when receive response
    assign pop_out_command_size     =   rsp_in_ready & rsp_in_valid & rsp_in_endofpacket;

    // Command Width Adapter   
    altera_merlin_width_adapter
    #(
        .IN_PKT_ADDR_H                  (IN_PKT_ADDR_H   ),
        .IN_PKT_ADDR_L                  (IN_PKT_ADDR_L   ),
        .IN_PKT_DATA_H                  (IN_PKT_DATA_H   ),
        .IN_PKT_DATA_L                  (IN_PKT_DATA_L   ),
        .IN_PKT_BYTEEN_H                (IN_PKT_BYTEEN_H ),
        .IN_PKT_BYTEEN_L                (IN_PKT_BYTEEN_L ),
        .IN_PKT_BYTE_CNT_H              (IN_PKT_BYTE_CNT_H ),
        .IN_PKT_BYTE_CNT_L              (IN_PKT_BYTE_CNT_L ),
        .IN_ST_DATA_W                   (IN_ST_DATA_W    ),
        .IN_PKT_TRANS_COMPRESSED_READ   (IN_PKT_TRANS_COMPRESSED_READ ),
        .IN_PKT_BURSTWRAP_H             (IN_PKT_BURSTWRAP_H),
        .IN_PKT_BURSTWRAP_L             (IN_PKT_BURSTWRAP_L),
        .IN_PKT_RESPONSE_STATUS_H       (IN_PKT_RESPONSE_STATUS_H), 
        .IN_PKT_RESPONSE_STATUS_L       (IN_PKT_RESPONSE_STATUS_L),
        .IN_PKT_BURST_SIZE_H            (IN_PKT_BURST_SIZE_H),
        .IN_PKT_BURST_SIZE_L            (IN_PKT_BURST_SIZE_L),
        .IN_PKT_TRANS_EXCLUSIVE         (IN_PKT_TRANS_EXCLUSIVE),
        .IN_PKT_BURST_TYPE_H            (IN_PKT_BURST_TYPE_H),
        .IN_PKT_BURST_TYPE_L            (IN_PKT_BURST_TYPE_L),

        .OUT_PKT_ADDR_H                 (OUT_PKT_ADDR_H  ),
        .OUT_PKT_ADDR_L                 (OUT_PKT_ADDR_L  ),
        .OUT_PKT_DATA_H                 (OUT_PKT_DATA_H  ),
        .OUT_PKT_DATA_L                 (OUT_PKT_DATA_L  ),
        .OUT_PKT_BYTEEN_H               (OUT_PKT_BYTEEN_H),
        .OUT_PKT_BYTEEN_L               (OUT_PKT_BYTEEN_L),
        .OUT_PKT_BYTE_CNT_H             (OUT_PKT_BYTE_CNT_H ),
        .OUT_PKT_BYTE_CNT_L             (OUT_PKT_BYTE_CNT_L ),
        .OUT_ST_DATA_W                  (OUT_ST_DATA_W   ),
        .OUT_PKT_TRANS_COMPRESSED_READ  (OUT_PKT_TRANS_COMPRESSED_READ ),
        .OUT_PKT_RESPONSE_STATUS_H      (OUT_PKT_RESPONSE_STATUS_H), 
        .OUT_PKT_RESPONSE_STATUS_L      (OUT_PKT_RESPONSE_STATUS_L),
        .OUT_PKT_BURST_SIZE_H           (OUT_PKT_BURST_SIZE_H),
        .OUT_PKT_BURST_SIZE_L           (OUT_PKT_BURST_SIZE_L),
        .OUT_PKT_TRANS_EXCLUSIVE        (OUT_PKT_TRANS_EXCLUSIVE),
        .OUT_PKT_BURST_TYPE_H           (OUT_PKT_BURST_TYPE_H),
        .OUT_PKT_BURST_TYPE_L           (OUT_PKT_BURST_TYPE_L),

        .ST_CHANNEL_W                   (ST_CHANNEL_W),
        .OPTIMIZE_FOR_RSP               (0),
        .PACKING                        (0),
        .CONSTANT_BURST_SIZE            (0),
        .RESPONSE_PATH                  (0)
    ) cmd_width_adapter
    (
        .out_valid                      (cmd_out_valid),
        .out_data                       (cmd_out_data),
        .out_channel                    (cmd_out_channel),  
        .out_startofpacket              (cmd_out_startofpacket),        
        .out_endofpacket                (cmd_out_endofpacket),      
        .out_ready                      (cmd_out_ready),
   
        .in_valid                       (cmd_in_valid),
        .in_data                        (cmd_in_data),
        .in_channel                     (cmd_in_channel),  
        .in_startofpacket               (cmd_in_startofpacket),      
        .in_endofpacket                 (cmd_in_endofpacket),    
        .in_ready                       (cmd_in_ready),
        
        // command size input ports; for command WA, dont use
        .in_command_size_data           (),

        .clk (clk),
        .reset(reset)
    );    
    // FIFO to store command SIZE and pop out when response comes back
 altera_avalon_sc_fifo #(
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (IN_BURST_SIZE_W), // base on AXI coding: 001: 2 num_symbols 
        .FIFO_DEPTH          (MAX_OUTSTANDING_RESPONSES), // same outstanding comamnd with master agent
        .CHANNEL_WIDTH       (0),
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (0),
        .USE_FILL_LEVEL      (0),
        .EMPTY_LATENCY       (1),
        .USE_MEMORY_BLOCKS   (0),
        .USE_STORE_FORWARD   (0),
        .USE_ALMOST_FULL_IF  (0),
        .USE_ALMOST_EMPTY_IF (0)
    ) command_size_fifo (
        .clk               (clk),                           // clk.clk
        .reset             (reset),                         // clk_reset.reset
        .in_data           (in_command_size_field),         // The SIZE from command width_adapter 
        .in_valid          (pop_in_command_size),           // 
        .in_ready          (fifo_is_full),                  // 
        .out_data          (out_command_size_field),        // 
        .out_valid         (fifo_is_empty),                 // 
        .out_ready         (pop_out_command_size),                 //  
        .csr_address       (2'b00),                                // (terminated)
        .csr_read          (1'b0),                                 // (terminated)
        .csr_write         (1'b0),                                 // (terminated)
        .csr_readdata      (),                                     // (terminated)
        .csr_writedata     (32'b00000000000000000000000000000000), // (terminated)
        .almost_full_data  (),                                     // (terminated)
        .almost_empty_data (),                                     // (terminated)
        .in_startofpacket  (1'b0),                                 // (terminated)
        .in_endofpacket    (1'b0),                                 // (terminated)
        .out_startofpacket (),                                     // (terminated)
        .out_endofpacket   (),                                     // (terminated)
        .in_empty          (1'b0),                                 // (terminated)
        .out_empty         (),                                     // (terminated)
        .in_error          (1'b0),                                 // (terminated)
        .out_error         (),                                     // (terminated)
        .in_channel        (1'b0),                                 // (terminated)
        .out_channel       ()                                      // (terminated)
    );
 
 
    // Response Width adapter
    altera_merlin_width_adapter
    #(
        .IN_PKT_ADDR_H                  (OUT_PKT_ADDR_H   ),
        .IN_PKT_ADDR_L                  (OUT_PKT_ADDR_L   ),
        .IN_PKT_DATA_H                  (OUT_PKT_DATA_H   ),
        .IN_PKT_DATA_L                  (OUT_PKT_DATA_L   ),
        .IN_PKT_BYTEEN_H                (OUT_PKT_BYTEEN_H ),
        .IN_PKT_BYTEEN_L                (OUT_PKT_BYTEEN_L ),
        .IN_PKT_BYTE_CNT_H              (OUT_PKT_BYTE_CNT_H ),
        .IN_PKT_BYTE_CNT_L              (OUT_PKT_BYTE_CNT_L ),
        .IN_ST_DATA_W                   (OUT_ST_DATA_W    ),
        .IN_PKT_TRANS_COMPRESSED_READ   (OUT_PKT_TRANS_COMPRESSED_READ ),
		// Response adapter, dont care burstwrap value
        .IN_PKT_BURSTWRAP_H             (IN_PKT_BURSTWRAP_H),
        .IN_PKT_BURSTWRAP_L             (IN_PKT_BURSTWRAP_L),
        .IN_PKT_RESPONSE_STATUS_H       (OUT_PKT_RESPONSE_STATUS_H), 
        .IN_PKT_RESPONSE_STATUS_L       (OUT_PKT_RESPONSE_STATUS_L),
        .IN_PKT_BURST_SIZE_H            (OUT_PKT_BURST_SIZE_H),
        .IN_PKT_BURST_SIZE_L            (OUT_PKT_BURST_SIZE_L),
        .IN_PKT_TRANS_EXCLUSIVE         (OUT_PKT_TRANS_EXCLUSIVE),
        .IN_PKT_BURST_TYPE_H            (OUT_PKT_BURST_TYPE_H),
        .IN_PKT_BURST_TYPE_L            (OUT_PKT_BURST_TYPE_L),

        .OUT_PKT_ADDR_H                 (IN_PKT_ADDR_H  ),
        .OUT_PKT_ADDR_L                 (IN_PKT_ADDR_L  ),
        .OUT_PKT_DATA_H                 (IN_PKT_DATA_H  ),
        .OUT_PKT_DATA_L                 (IN_PKT_DATA_L  ),
        .OUT_PKT_BYTEEN_H               (IN_PKT_BYTEEN_H),
        .OUT_PKT_BYTEEN_L               (IN_PKT_BYTEEN_L),
        .OUT_PKT_BYTE_CNT_H             (IN_PKT_BYTE_CNT_H ),
        .OUT_PKT_BYTE_CNT_L             (IN_PKT_BYTE_CNT_L ),
        .OUT_ST_DATA_W                  (IN_ST_DATA_W   ),
        .OUT_PKT_TRANS_COMPRESSED_READ  (IN_PKT_TRANS_COMPRESSED_READ ),
        .OUT_PKT_RESPONSE_STATUS_H      (IN_PKT_RESPONSE_STATUS_H), 
        .OUT_PKT_RESPONSE_STATUS_L      (IN_PKT_RESPONSE_STATUS_L),
        .OUT_PKT_BURST_SIZE_H           (IN_PKT_BURST_SIZE_H),
        .OUT_PKT_BURST_SIZE_L           (IN_PKT_BURST_SIZE_L),
        .OUT_PKT_TRANS_EXCLUSIVE        (IN_PKT_TRANS_EXCLUSIVE),
        .OUT_PKT_BURST_TYPE_H           (IN_PKT_BURST_TYPE_H),
        .OUT_PKT_BURST_TYPE_L           (IN_PKT_BURST_TYPE_L),

        .ST_CHANNEL_W                   (ST_CHANNEL_W),
        .OPTIMIZE_FOR_RSP               (0),
        .PACKING                        (1),
        .CONSTANT_BURST_SIZE            (0),
        .RESPONSE_PATH                  (1)
    ) rsp_width_adapter
    (
        .out_valid                      (rsp_out_valid),
        .out_data                       (rsp_out_data),
        .out_channel                    (rsp_out_channel),  
        .out_startofpacket              (rsp_out_startofpacket),        
        .out_endofpacket                (rsp_out_endofpacket),      
        .out_ready                      (rsp_out_ready),
   
        .in_valid                       (rsp_in_valid),
        .in_data                        (rsp_in_data),
        .in_channel                     (rsp_in_channel),  
        .in_startofpacket               (rsp_in_startofpacket),      
        .in_endofpacket                 (rsp_in_endofpacket),    
        .in_ready                       (rsp_in_ready),
        
        // command size input ports; response WA, read command size
        // The WA just use the command size, handshake and backpresue
        // base on rsp_in_valid/read which are controled by response WA  
        .in_command_size_data           (out_command_size_field),

        .clk (clk),
        .reset(reset)
    );    

    // ------------------------------------------------------------
    // Assertions: Cheking fifo empty/full 
    // ------------------------------------------------------------
    // synthesis translate_off
    // Fifo is full and another command occurs, fifo overflows
    ERROR_fifo_is_overflow:
        assert property (@(posedge clk)
            disable iff (reset) (!fifo_is_full |-> !pop_in_command_size));
    ERROR_fifo_is_empty_but_response_occurs:
        assert property (@(posedge clk)
            disable iff (reset) (!fifo_is_empty |-> !pop_out_command_size));
    // synthesis translate_on

    
 endmodule 
