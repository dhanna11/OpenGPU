// (C) 2001-2017 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



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


// $Id: //acds/rel/17.0std/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2017/01/22 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module soc_system_mm_interconnect_1_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 20,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 3 
   )
  (output [142 - 138 : 0] default_destination_id,
   output [25-1 : 0] default_wr_channel,
   output [25-1 : 0] default_rd_channel,
   output [25-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[142 - 138 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 25'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 25'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 25'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module soc_system_mm_interconnect_1_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [167-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [167-1    : 0] src_data,
    output reg [25-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 101;
    localparam PKT_ADDR_L = 72;
    localparam PKT_DEST_ID_H = 142;
    localparam PKT_DEST_ID_L = 138;
    localparam PKT_PROTECTION_H = 157;
    localparam PKT_PROTECTION_L = 155;
    localparam ST_DATA_W = 167;
    localparam ST_CHANNEL_W = 25;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 104;
    localparam PKT_TRANS_READ  = 105;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h10 - 64'h0); 
    localparam PAD1 = log2ceil(64'h20 - 64'h10); 
    localparam PAD2 = log2ceil(64'h30 - 64'h20); 
    localparam PAD3 = log2ceil(64'h40 - 64'h30); 
    localparam PAD4 = log2ceil(64'h50 - 64'h40); 
    localparam PAD5 = log2ceil(64'h10010 - 64'h10000); 
    localparam PAD6 = log2ceil(64'h10020 - 64'h10010); 
    localparam PAD7 = log2ceil(64'h10030 - 64'h10020); 
    localparam PAD8 = log2ceil(64'h10040 - 64'h10030); 
    localparam PAD9 = log2ceil(64'h10050 - 64'h10040); 
    localparam PAD10 = log2ceil(64'h10060 - 64'h10050); 
    localparam PAD11 = log2ceil(64'h10070 - 64'h10060); 
    localparam PAD12 = log2ceil(64'h10080 - 64'h10070); 
    localparam PAD13 = log2ceil(64'h10090 - 64'h10080); 
    localparam PAD14 = log2ceil(64'h100a0 - 64'h10090); 
    localparam PAD15 = log2ceil(64'h100b0 - 64'h100a0); 
    localparam PAD16 = log2ceil(64'h100c0 - 64'h100b0); 
    localparam PAD17 = log2ceil(64'h100d0 - 64'h100c0); 
    localparam PAD18 = log2ceil(64'h100e0 - 64'h100d0); 
    localparam PAD19 = log2ceil(64'h100f0 - 64'h100e0); 
    localparam PAD20 = log2ceil(64'h10100 - 64'h100f0); 
    localparam PAD21 = log2ceil(64'h10110 - 64'h10100); 
    localparam PAD22 = log2ceil(64'h10120 - 64'h10110); 
    localparam PAD23 = log2ceil(64'h10130 - 64'h10120); 
    localparam PAD24 = log2ceil(64'h10140 - 64'h10130); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h10140;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [25-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    soc_system_mm_interconnect_1_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x10 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 17'h0  && read_transaction  ) begin
            src_channel = 25'b0000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x10 .. 0x20 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 17'h10  && read_transaction  ) begin
            src_channel = 25'b0001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x20 .. 0x30 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 17'h20  && read_transaction  ) begin
            src_channel = 25'b0010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x30 .. 0x40 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 17'h30   ) begin
            src_channel = 25'b0100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x40 .. 0x50 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 17'h40   ) begin
            src_channel = 25'b1000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x10000 .. 0x10010 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 17'h10000   ) begin
            src_channel = 25'b0000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x10010 .. 0x10020 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 17'h10010   ) begin
            src_channel = 25'b0000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x10020 .. 0x10030 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 17'h10020   ) begin
            src_channel = 25'b0000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x10030 .. 0x10040 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 17'h10030   ) begin
            src_channel = 25'b0000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x10040 .. 0x10050 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 17'h10040   ) begin
            src_channel = 25'b0000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x10050 .. 0x10060 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 17'h10050   ) begin
            src_channel = 25'b0000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x10060 .. 0x10070 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 17'h10060   ) begin
            src_channel = 25'b0000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x10070 .. 0x10080 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 17'h10070   ) begin
            src_channel = 25'b0000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x10080 .. 0x10090 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 17'h10080   ) begin
            src_channel = 25'b0000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0x10090 .. 0x100a0 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 17'h10090  && read_transaction  ) begin
            src_channel = 25'b0000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x100a0 .. 0x100b0 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 17'h100a0   ) begin
            src_channel = 25'b0000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x100b0 .. 0x100c0 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 17'h100b0   ) begin
            src_channel = 25'b0000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x100c0 .. 0x100d0 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 17'h100c0   ) begin
            src_channel = 25'b0000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x100d0 .. 0x100e0 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 17'h100d0   ) begin
            src_channel = 25'b0000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x100e0 .. 0x100f0 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 17'h100e0   ) begin
            src_channel = 25'b0000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x100f0 .. 0x10100 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 17'h100f0   ) begin
            src_channel = 25'b0000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x10100 .. 0x10110 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 17'h10100   ) begin
            src_channel = 25'b0000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x10110 .. 0x10120 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 17'h10110   ) begin
            src_channel = 25'b0000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x10120 .. 0x10130 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 17'h10120   ) begin
            src_channel = 25'b0000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x10130 .. 0x10140 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 17'h10130   ) begin
            src_channel = 25'b0000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


