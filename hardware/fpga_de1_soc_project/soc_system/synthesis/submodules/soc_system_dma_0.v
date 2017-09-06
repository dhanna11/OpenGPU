//Legal Notice: (C)2016 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_dma_0_read_data_mux (
                                        // inputs:
                                         byte_access,
                                         clk,
                                         clk_en,
                                         dma_ctl_address,
                                         dma_ctl_chipselect,
                                         dma_ctl_write_n,
                                         dma_ctl_writedata,
                                         hw,
                                         read_readdata,
                                         read_readdatavalid,
                                         readaddress,
                                         readaddress_inc,
                                         reset_n,
                                         word,

                                        // outputs:
                                         fifo_wr_data
                                      )
;

  output  [ 31: 0] fifo_wr_data;
  input            byte_access;
  input            clk;
  input            clk_en;
  input   [  2: 0] dma_ctl_address;
  input            dma_ctl_chipselect;
  input            dma_ctl_write_n;
  input   [ 31: 0] dma_ctl_writedata;
  input            hw;
  input   [ 31: 0] read_readdata;
  input            read_readdatavalid;
  input   [ 14: 0] readaddress;
  input   [  4: 0] readaddress_inc;
  input            reset_n;
  input            word;

  wire             control_write;
  wire    [ 31: 0] fifo_wr_data;
  wire             length_write;
  wire    [  1: 0] read_data_mux_input;
  reg     [  1: 0] readdata_mux_select;
  assign control_write = dma_ctl_chipselect & ~dma_ctl_write_n & ((dma_ctl_address == 6) || (dma_ctl_address == 7));
  assign length_write = dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == 3);
  assign read_data_mux_input = ((control_write && dma_ctl_writedata[3] || length_write))? readaddress[1 : 0] :
    (read_readdatavalid)? (readdata_mux_select + readaddress_inc) :
    readdata_mux_select;

  // Reset value: the transaction size bits of the read address reset value.
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata_mux_select <= 0;
      else if (clk_en)
          readdata_mux_select <= read_data_mux_input[1 : 0];
    end


  assign fifo_wr_data[31 : 16] = read_readdata[31 : 16];
  assign fifo_wr_data[15 : 8] = ({8 {(hw & (readdata_mux_select[1] == 0))}} & read_readdata[15 : 8]) |
    ({8 {(hw & (readdata_mux_select[1] == 1))}} & read_readdata[31 : 24]) |
    ({8 {word}} & read_readdata[15 : 8]);

  assign fifo_wr_data[7 : 0] = ({8 {(byte_access & (readdata_mux_select[1 : 0] == 0))}} & read_readdata[7 : 0]) |
    ({8 {(byte_access & (readdata_mux_select[1 : 0] == 1))}} & read_readdata[15 : 8]) |
    ({8 {(byte_access & (readdata_mux_select[1 : 0] == 2))}} & read_readdata[23 : 16]) |
    ({8 {(byte_access & (readdata_mux_select[1 : 0] == 3))}} & read_readdata[31 : 24]) |
    ({8 {(hw & (readdata_mux_select[1] == 0))}} & read_readdata[7 : 0]) |
    ({8 {(hw & (readdata_mux_select[1] == 1))}} & read_readdata[23 : 16]) |
    ({8 {word}} & read_readdata[7 : 0]);


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_dma_0_byteenables (
                                      // inputs:
                                       byte_access,
                                       hw,
                                       word,
                                       write_address,

                                      // outputs:
                                       write_byteenable
                                    )
;

  output  [  3: 0] write_byteenable;
  input            byte_access;
  input            hw;
  input            word;
  input   [ 31: 0] write_address;

  wire             wa_1_is_0;
  wire             wa_1_is_1;
  wire             wa_1_to_0_is_0;
  wire             wa_1_to_0_is_1;
  wire             wa_1_to_0_is_2;
  wire             wa_1_to_0_is_3;
  wire    [  3: 0] write_byteenable;
  assign wa_1_to_0_is_3 = write_address[1 : 0] == 2'h3;
  assign wa_1_to_0_is_2 = write_address[1 : 0] == 2'h2;
  assign wa_1_to_0_is_1 = write_address[1 : 0] == 2'h1;
  assign wa_1_to_0_is_0 = write_address[1 : 0] == 2'h0;
  assign wa_1_is_1 = write_address[1] == 1'h1;
  assign wa_1_is_0 = write_address[1] == 1'h0;
  assign write_byteenable = ({4 {byte_access}} & {wa_1_to_0_is_3, wa_1_to_0_is_2, wa_1_to_0_is_1, wa_1_to_0_is_0}) |
    ({4 {hw}} & {wa_1_is_1, wa_1_is_1, wa_1_is_0, wa_1_is_0}) |
    ({4 {word}} & 4'b1111);


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_dma_0_fifo_module_fifo_ram_module (
                                                      // inputs:
                                                       clk,
                                                       data,
                                                       rdaddress,
                                                       rdclken,
                                                       reset_n,
                                                       wraddress,
                                                       wrclock,
                                                       wren,

                                                      // outputs:
                                                       q
                                                    )
;

  output  [ 31: 0] q;
  input            clk;
  input   [ 31: 0] data;
  input   [  9: 0] rdaddress;
  input            rdclken;
  input            reset_n;
  input   [  9: 0] wraddress;
  input            wrclock;
  input            wren;

  reg     [ 31: 0] mem_array [1023: 0];
  wire    [ 31: 0] q;
  reg     [  9: 0] read_address;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_address <= 0;
      else if (rdclken)
          read_address <= rdaddress;
    end


  // Data read is synchronized through latent_rdaddress.
  assign q = mem_array[read_address];

  always @(posedge wrclock)
    begin
      // Write data
      if (wren)
          mem_array[wraddress] <= data;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  always @(rdaddress)
//    begin
//      read_address = rdaddress;
//    end
//
//
//  lpm_ram_dp lpm_ram_dp_component
//    (
//      .data (data),
//      .q (q),
//      .rdaddress (read_address),
//      .rdclken (rdclken),
//      .rdclock (clk),
//      .wraddress (wraddress),
//      .wrclock (wrclock),
//      .wren (wren)
//    );
//
//  defparam lpm_ram_dp_component.lpm_file = "UNUSED",
//           lpm_ram_dp_component.lpm_hint = "USE_EAB=ON",
//           lpm_ram_dp_component.lpm_indata = "REGISTERED",
//           lpm_ram_dp_component.lpm_outdata = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_rdaddress_control = "REGISTERED",
//           lpm_ram_dp_component.lpm_width = 32,
//           lpm_ram_dp_component.lpm_widthad = 10,
//           lpm_ram_dp_component.lpm_wraddress_control = "REGISTERED",
//           lpm_ram_dp_component.suppress_memory_conversion_warnings = "ON";
//
//synthesis read_comments_as_HDL off

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_dma_0_fifo_module (
                                      // inputs:
                                       clk,
                                       clk_en,
                                       fifo_read,
                                       fifo_wr_data,
                                       fifo_write,
                                       flush_fifo,
                                       inc_pending_data,
                                       reset_n,

                                      // outputs:
                                       fifo_datavalid,
                                       fifo_empty,
                                       fifo_rd_data,
                                       p1_fifo_full
                                    )
;

  output           fifo_datavalid;
  output           fifo_empty;
  output  [ 31: 0] fifo_rd_data;
  output           p1_fifo_full;
  input            clk;
  input            clk_en;
  input            fifo_read;
  input   [ 31: 0] fifo_wr_data;
  input            fifo_write;
  input            flush_fifo;
  input            inc_pending_data;
  input            reset_n;

  wire    [  9: 0] estimated_rdaddress;
  reg     [  9: 0] estimated_wraddress;
  wire             fifo_datavalid;
  wire             fifo_dec;
  reg              fifo_empty;
  reg              fifo_full;
  wire             fifo_inc;
  wire    [ 31: 0] fifo_ram_q;
  wire    [ 31: 0] fifo_rd_data;
  reg              last_write_collision;
  reg     [ 31: 0] last_write_data;
  wire    [  9: 0] p1_estimated_wraddress;
  wire             p1_fifo_empty;
  wire             p1_fifo_full;
  wire    [  9: 0] p1_wraddress;
  wire    [  9: 0] rdaddress;
  reg     [  9: 0] rdaddress_reg;
  reg     [  9: 0] wraddress;
  wire             write_collision;
  assign p1_wraddress = (fifo_write)? wraddress - 1 :
    wraddress;

  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          wraddress <= 0;
      else if (clk_en)
          if (flush_fifo)
              wraddress <= 0;
          else 
            wraddress <= p1_wraddress;
    end


  assign rdaddress = flush_fifo ? 0 : fifo_read ? (rdaddress_reg - 1) : rdaddress_reg;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          rdaddress_reg <= 0;
      else 
        rdaddress_reg <= rdaddress;
    end


  assign fifo_datavalid = ~fifo_empty;
  assign fifo_inc = fifo_write & ~fifo_read;
  assign fifo_dec = fifo_read & ~fifo_write;
  assign estimated_rdaddress = rdaddress_reg - 1;
  assign p1_estimated_wraddress = (inc_pending_data)? estimated_wraddress - 1 :
    estimated_wraddress;

  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          estimated_wraddress <= {10 {1'b1}};
      else if (clk_en)
          if (flush_fifo)
              estimated_wraddress <= {10 {1'b1}};
          else 
            estimated_wraddress <= p1_estimated_wraddress;
    end


  assign p1_fifo_empty = flush_fifo  | ((~fifo_inc & fifo_empty) | (fifo_dec & (wraddress == estimated_rdaddress)));
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_empty <= 1;
      else if (clk_en)
          fifo_empty <= p1_fifo_empty;
    end


  assign p1_fifo_full = ~flush_fifo & ((~fifo_dec & fifo_full)  | (inc_pending_data & (estimated_wraddress == rdaddress)));
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_full <= 0;
      else if (clk_en)
          fifo_full <= p1_fifo_full;
    end


  assign write_collision = fifo_write && (wraddress == rdaddress);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_write_data <= 0;
      else if (write_collision)
          last_write_data <= fifo_wr_data;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_write_collision <= 0;
      else if (write_collision)
          last_write_collision <= -1;
      else if (fifo_read)
          last_write_collision <= 0;
    end


  assign fifo_rd_data = last_write_collision ? last_write_data : fifo_ram_q;
  //soc_system_dma_0_fifo_module_fifo_ram, which is an e_ram
  soc_system_dma_0_fifo_module_fifo_ram_module soc_system_dma_0_fifo_module_fifo_ram
    (
      .clk       (clk),
      .data      (fifo_wr_data),
      .q         (fifo_ram_q),
      .rdaddress (rdaddress),
      .rdclken   (1'b1),
      .reset_n   (reset_n),
      .wraddress (wraddress),
      .wrclock   (clk),
      .wren      (fifo_write)
    );


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_dma_0_mem_read (
                                   // inputs:
                                    clk,
                                    clk_en,
                                    go,
                                    p1_done_read,
                                    p1_fifo_full,
                                    read_waitrequest,
                                    reset_n,

                                   // outputs:
                                    inc_read,
                                    mem_read_n
                                 )
;

  output           inc_read;
  output           mem_read_n;
  input            clk;
  input            clk_en;
  input            go;
  input            p1_done_read;
  input            p1_fifo_full;
  input            read_waitrequest;
  input            reset_n;

  wire             inc_read;
  wire             mem_read_n;
  wire             p1_read_select;
  reg              read_select;
  reg              soc_system_dma_0_mem_read_access;
  reg              soc_system_dma_0_mem_read_idle;
  assign mem_read_n = ~read_select;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_select <= 0;
      else if (clk_en)
          read_select <= p1_read_select;
    end


  assign inc_read = read_select & ~read_waitrequest;
  // Transitions into state 'idle'.
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          soc_system_dma_0_mem_read_idle <= 1;
      else if (clk_en)
          soc_system_dma_0_mem_read_idle <= ((soc_system_dma_0_mem_read_idle == 1) & (go == 0)) |
                    ((soc_system_dma_0_mem_read_idle == 1) & (p1_done_read == 1)) |
                    ((soc_system_dma_0_mem_read_idle == 1) & (p1_fifo_full == 1)) |
                    ((soc_system_dma_0_mem_read_access == 1) & (p1_fifo_full == 1) & (read_waitrequest == 0)) |
                    ((soc_system_dma_0_mem_read_access == 1) & (p1_done_read == 1) & (read_waitrequest == 0));

    end


  // Transitions into state 'access'.
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          soc_system_dma_0_mem_read_access <= 0;
      else if (clk_en)
          soc_system_dma_0_mem_read_access <= ((soc_system_dma_0_mem_read_idle == 1) & (p1_fifo_full == 0) & (p1_done_read == 0) & (go == 1)) |
                    ((soc_system_dma_0_mem_read_access == 1) & (read_waitrequest == 1)) |
                    ((soc_system_dma_0_mem_read_access == 1) & (p1_fifo_full == 0) & (p1_done_read == 0) & (read_waitrequest == 0));

    end


  assign p1_read_select = ({1 {((soc_system_dma_0_mem_read_access && (read_waitrequest == 1)))}} & 1) |
    ({1 {((soc_system_dma_0_mem_read_access && (p1_done_read == 0) && (p1_fifo_full == 0) && (read_waitrequest == 0)))}} & 1) |
    ({1 {((soc_system_dma_0_mem_read_idle && (go == 1) && (p1_done_read == 0) && (p1_fifo_full == 0)))}} & 1);


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_dma_0_mem_write (
                                    // inputs:
                                     d1_enabled_write_endofpacket,
                                     fifo_datavalid,
                                     write_waitrequest,

                                    // outputs:
                                     fifo_read,
                                     inc_write,
                                     mem_write_n,
                                     write_select
                                  )
;

  output           fifo_read;
  output           inc_write;
  output           mem_write_n;
  output           write_select;
  input            d1_enabled_write_endofpacket;
  input            fifo_datavalid;
  input            write_waitrequest;

  wire             fifo_read;
  wire             inc_write;
  wire             mem_write_n;
  wire             write_select;
  assign write_select = fifo_datavalid & ~d1_enabled_write_endofpacket;
  assign mem_write_n = ~write_select;
  assign fifo_read = write_select & ~write_waitrequest;
  assign inc_write = fifo_read;

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

//DMA peripheral soc_system_dma_0
//Read slaves:
//quad_data_test_ROM.s1; 
//Write slaves:
//hps_0_sysmgr.axi_slave0,hps_0_uart1.axi_slave0,hps_0_dcan0.axi_slave0,hps_0_i2c1.axi_slave0,hps_0_gpio0.axi_slave0,hps_0_clkmgr.axi_slave0,hps_0_l3regs.axi_slave0,hps_0_arm_gic_0.axi_slave0,hps_0_i2c3.axi_slave0,hps_0_gmac1.axi_slave0,hps_0_gpio2.axi_slave0,hps_0_nand0.axi_slave0,hps_0_arm_gic_0.axi_slave1,hps_0_spim1.axi_slave0,hps_0_timer1.axi_slave0,hps_0_nand0.axi_slave1,hps_0_axi_ocram.axi_slave0,hps_0_usb1.axi_slave0,hps_0_timer3.axi_slave0,hps_0_uart0.axi_slave0,hps_0_fpgamgr.axi_slave0,hps_0_fpgamgr.axi_slave1,hps_0_qspi.axi_slave0,hps_0_L2.axi_slave0,hps_0_i2c0.axi_slave0,hps_0_qspi.axi_slave1,hps_0_rstmgr.axi_slave0,hps_0_dcan1.axi_slave0,hps_0_i2c2.axi_slave0,hps_0_axi_sdram.axi_slave0,hps_0_gmac0.axi_slave0,hps_0_gpio1.axi_slave0,hps_0_timer.axi_slave0,hps_0_spim0.axi_slave0,hps_0_timer0.axi_slave0,hps_0_dma.axi_slave0,hps_0_usb0.axi_slave0,hps_0_timer2.axi_slave0,hps_0_sdrctl.axi_slave0,hps_0_sdmmc.axi_slave0; 


module soc_system_dma_0 (
                          // inputs:
                           clk,
                           dma_ctl_address,
                           dma_ctl_chipselect,
                           dma_ctl_write_n,
                           dma_ctl_writedata,
                           read_readdata,
                           read_readdatavalid,
                           read_waitrequest,
                           system_reset_n,
                           write_waitrequest,

                          // outputs:
                           dma_ctl_irq,
                           dma_ctl_readdata,
                           read_address,
                           read_chipselect,
                           read_read_n,
                           write_address,
                           write_byteenable,
                           write_chipselect,
                           write_write_n,
                           write_writedata
                        )
  /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"R101\"" */ ;

  output           dma_ctl_irq;
  output  [ 31: 0] dma_ctl_readdata;
  output  [ 14: 0] read_address;
  output           read_chipselect;
  output           read_read_n;
  output  [ 31: 0] write_address;
  output  [  3: 0] write_byteenable;
  output           write_chipselect;
  output           write_write_n;
  output  [ 31: 0] write_writedata;
  input            clk;
  input   [  2: 0] dma_ctl_address;
  input            dma_ctl_chipselect;
  input            dma_ctl_write_n;
  input   [ 31: 0] dma_ctl_writedata;
  input   [ 31: 0] read_readdata;
  input            read_readdatavalid;
  input            read_waitrequest;
  input            system_reset_n;
  input            write_waitrequest;

  wire             busy;
  wire             byte_access;
  wire             clk_en;
  reg     [ 12: 0] control;
  reg              d1_done_transaction;
  reg              d1_enabled_write_endofpacket;
  reg              d1_read_got_endofpacket;
  reg              d1_softwarereset;
  wire             dma_ctl_irq;
  reg     [ 31: 0] dma_ctl_readdata;
  reg              done;
  wire             done_transaction;
  reg              done_write;
  wire             doubleword;
  wire             enabled_write_endofpacket;
  wire             fifo_datavalid;
  wire             fifo_empty;
  wire    [ 31: 0] fifo_rd_data;
  wire    [ 31: 0] fifo_rd_data_as_byte_access;
  wire    [ 31: 0] fifo_rd_data_as_hw;
  wire    [ 31: 0] fifo_rd_data_as_word;
  wire             fifo_read;
  wire    [ 31: 0] fifo_wr_data;
  wire             fifo_write;
  wire             fifo_write_data_valid;
  wire             flush_fifo;
  wire             go;
  wire             hw;
  wire             i_en;
  wire             inc_read;
  wire             inc_write;
  wire             leen;
  reg              len;
  reg     [ 30: 0] length;
  reg              length_eq_0;
  wire             mem_read_n;
  wire             mem_write_n;
  wire    [ 12: 0] p1_control;
  wire    [ 31: 0] p1_dma_ctl_readdata;
  wire             p1_done_read;
  wire             p1_done_write;
  wire             p1_fifo_full;
  wire    [ 30: 0] p1_length;
  wire             p1_length_eq_0;
  wire             p1_read_got_endofpacket;
  wire    [ 14: 0] p1_readaddress;
  wire             p1_write_got_endofpacket;
  wire    [ 31: 0] p1_writeaddress;
  wire    [ 30: 0] p1_writelength;
  wire             p1_writelength_eq_0;
  wire             quadword;
  wire             rcon;
  wire    [ 14: 0] read_address;
  wire             read_chipselect;
  wire             read_endofpacket;
  reg              read_got_endofpacket;
  wire             read_read_n;
  reg     [ 14: 0] readaddress;
  wire    [  4: 0] readaddress_inc;
  wire             reen;
  reg              reop;
  reg              reset_n;
  wire             set_software_reset_bit;
  reg              software_reset_request;
  wire             softwarereset;
  wire    [  4: 0] status;
  wire             status_register_write;
  wire             wcon;
  wire             ween;
  reg              weop;
  wire             word;
  wire    [ 31: 0] write_address;
  wire    [  3: 0] write_byteenable;
  wire             write_chipselect;
  wire             write_endofpacket;
  reg              write_got_endofpacket;
  wire             write_select;
  wire             write_write_n;
  wire    [ 31: 0] write_writedata;
  reg     [ 31: 0] writeaddress;
  wire    [  4: 0] writeaddress_inc;
  reg     [ 30: 0] writelength;
  reg              writelength_eq_0;
  assign clk_en = 1;
  //control_port_slave, which is an e_avalon_slave
  //read_master, which is an e_avalon_master
  soc_system_dma_0_read_data_mux the_soc_system_dma_0_read_data_mux
    (
      .byte_access        (byte_access),
      .clk                (clk),
      .clk_en             (clk_en),
      .dma_ctl_address    (dma_ctl_address),
      .dma_ctl_chipselect (dma_ctl_chipselect),
      .dma_ctl_write_n    (dma_ctl_write_n),
      .dma_ctl_writedata  (dma_ctl_writedata),
      .fifo_wr_data       (fifo_wr_data),
      .hw                 (hw),
      .read_readdata      (read_readdata),
      .read_readdatavalid (read_readdatavalid),
      .readaddress        (readaddress),
      .readaddress_inc    (readaddress_inc),
      .reset_n            (reset_n),
      .word               (word)
    );

  //write_master, which is an e_avalon_master
  soc_system_dma_0_byteenables the_soc_system_dma_0_byteenables
    (
      .byte_access      (byte_access),
      .hw               (hw),
      .word             (word),
      .write_address    (write_address),
      .write_byteenable (write_byteenable)
    );

  assign read_read_n = mem_read_n;
  assign status_register_write = dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == 0);
  // read address
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readaddress <= 15'h0;
      else if (clk_en)
          readaddress <= p1_readaddress;
    end


  assign p1_readaddress = ((dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == 1)))? dma_ctl_writedata :
    (inc_read)? (readaddress + readaddress_inc) :
    readaddress;

  // write address
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          writeaddress <= 32'h0;
      else if (clk_en)
          writeaddress <= p1_writeaddress;
    end


  assign p1_writeaddress = ((dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == 2)))? dma_ctl_writedata :
    (inc_write)? (writeaddress + writeaddress_inc) :
    writeaddress;

  // length in bytes
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          length <= 31'h0;
      else if (clk_en)
          length <= p1_length;
    end


  assign p1_length = ((dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == 3)))? dma_ctl_writedata :
    ((inc_read && (!length_eq_0)))? length - {1'b0,
    1'b0,
    word,
    hw,
    byte_access} :
    length;

  // control register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          control <= 13'h84;
      else if (clk_en)
          control <= p1_control;
    end


  assign p1_control = ((dma_ctl_chipselect & ~dma_ctl_write_n & ((dma_ctl_address == 6) || (dma_ctl_address == 7))))? dma_ctl_writedata :
    control;

  // write master length
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          writelength <= 31'h0;
      else if (clk_en)
          writelength <= p1_writelength;
    end


  assign p1_writelength = ((dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == 3)))? dma_ctl_writedata :
    ((inc_write && (!writelength_eq_0)))? writelength - {1'b0,
    1'b0,
    word,
    hw,
    byte_access} :
    writelength;

  assign p1_writelength_eq_0 = inc_write && (!writelength_eq_0) && ((writelength  - {1'b0,
    1'b0,
    word,
    hw,
    byte_access}) == 0);

  assign p1_length_eq_0 = inc_read && (!length_eq_0) && ((length  - {1'b0,
    1'b0,
    word,
    hw,
    byte_access}) == 0);

  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          length_eq_0 <= 1;
      else if (clk_en)
          if (dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == 3))
              length_eq_0 <= 0;
          else if (p1_length_eq_0)
              length_eq_0 <= -1;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          writelength_eq_0 <= 1;
      else if (clk_en)
          if (dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == 3))
              writelength_eq_0 <= 0;
          else if (p1_writelength_eq_0)
              writelength_eq_0 <= -1;
    end


  assign writeaddress_inc = (wcon)? 0 :
    {1'b0,
    1'b0,
    word,
    hw,
    byte_access};

  assign readaddress_inc = (rcon)? 0 :
    {1'b0,
    1'b0,
    word,
    hw,
    byte_access};

  assign p1_dma_ctl_readdata = ({32 {(dma_ctl_address == 0)}} & status) |
    ({32 {(dma_ctl_address == 1)}} & readaddress) |
    ({32 {(dma_ctl_address == 2)}} & writeaddress) |
    ({32 {(dma_ctl_address == 3)}} & writelength) |
    ({32 {(dma_ctl_address == 6)}} & control);

  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dma_ctl_readdata <= 0;
      else if (clk_en)
          dma_ctl_readdata <= p1_dma_ctl_readdata;
    end


  assign done_transaction = go & done_write;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          done <= 0;
      else if (clk_en)
          if (status_register_write)
              done <= 0;
          else if (done_transaction & ~d1_done_transaction)
              done <= -1;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_done_transaction <= 0;
      else if (clk_en)
          d1_done_transaction <= done_transaction;
    end


  assign busy = go & ~done_write;
  assign status[0] = done;
  assign status[1] = busy;
  assign status[2] = reop;
  assign status[3] = weop;
  assign status[4] = len;
  assign byte_access = control[0];
  assign hw = control[1];
  assign word = control[2];
  assign go = control[3];
  assign i_en = control[4];
  assign reen = control[5];
  assign ween = control[6];
  assign leen = control[7];
  assign rcon = control[8];
  assign wcon = control[9];
  assign doubleword = control[10];
  assign quadword = control[11];
  assign softwarereset = control[12];
  assign dma_ctl_irq = i_en & done;
  assign p1_read_got_endofpacket = ~status_register_write && (read_got_endofpacket || (read_endofpacket & reen));
  assign p1_write_got_endofpacket = ~status_register_write && (write_got_endofpacket || (inc_write & write_endofpacket & ween));
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_got_endofpacket <= 0;
      else if (clk_en)
          read_got_endofpacket <= p1_read_got_endofpacket;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_got_endofpacket <= 0;
      else if (clk_en)
          write_got_endofpacket <= p1_write_got_endofpacket;
    end


  assign flush_fifo = ~d1_done_transaction & done_transaction;
  soc_system_dma_0_fifo_module the_soc_system_dma_0_fifo_module
    (
      .clk              (clk),
      .clk_en           (clk_en),
      .fifo_datavalid   (fifo_datavalid),
      .fifo_empty       (fifo_empty),
      .fifo_rd_data     (fifo_rd_data),
      .fifo_read        (fifo_read),
      .fifo_wr_data     (fifo_wr_data),
      .fifo_write       (fifo_write),
      .flush_fifo       (flush_fifo),
      .inc_pending_data (inc_read),
      .p1_fifo_full     (p1_fifo_full),
      .reset_n          (reset_n)
    );

  //the_soc_system_dma_0_mem_read, which is an e_instance
  soc_system_dma_0_mem_read the_soc_system_dma_0_mem_read
    (
      .clk              (clk),
      .clk_en           (clk_en),
      .go               (go),
      .inc_read         (inc_read),
      .mem_read_n       (mem_read_n),
      .p1_done_read     (p1_done_read),
      .p1_fifo_full     (p1_fifo_full),
      .read_waitrequest (read_waitrequest),
      .reset_n          (reset_n)
    );

  assign fifo_write = fifo_write_data_valid;
  assign enabled_write_endofpacket = write_endofpacket & ween;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_enabled_write_endofpacket <= 0;
      else if (clk_en)
          d1_enabled_write_endofpacket <= enabled_write_endofpacket;
    end


  soc_system_dma_0_mem_write the_soc_system_dma_0_mem_write
    (
      .d1_enabled_write_endofpacket (d1_enabled_write_endofpacket),
      .fifo_datavalid               (fifo_datavalid),
      .fifo_read                    (fifo_read),
      .inc_write                    (inc_write),
      .mem_write_n                  (mem_write_n),
      .write_select                 (write_select),
      .write_waitrequest            (write_waitrequest)
    );

  assign p1_done_read = (leen && (p1_length_eq_0 || (length_eq_0))) | p1_read_got_endofpacket | p1_done_write;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          len <= 0;
      else if (clk_en)
          if (status_register_write)
              len <= 0;
          else if (~d1_done_transaction & done_transaction && (writelength_eq_0))
              len <= -1;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          reop <= 0;
      else if (clk_en)
          if (status_register_write)
              reop <= 0;
          else if (fifo_empty & read_got_endofpacket & d1_read_got_endofpacket)
              reop <= -1;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          weop <= 0;
      else if (clk_en)
          if (status_register_write)
              weop <= 0;
          else if (write_got_endofpacket)
              weop <= -1;
    end


  assign p1_done_write = (leen && (p1_writelength_eq_0 || writelength_eq_0)) | p1_write_got_endofpacket | fifo_empty & d1_read_got_endofpacket;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_read_got_endofpacket <= 0;
      else if (clk_en)
          d1_read_got_endofpacket <= read_got_endofpacket;
    end


  // Write has completed when the length goes to 0, or
  //the write source said end-of-packet, or
  //the read source said end-of-packet and the fifo has emptied.
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          done_write <= 0;
      else if (clk_en)
          done_write <= p1_done_write;
    end


  assign read_address = readaddress;
  assign write_address = writeaddress;
  assign write_chipselect = write_select;
  assign read_chipselect = ~read_read_n;
  assign write_write_n = mem_write_n;
  assign fifo_rd_data_as_byte_access = {fifo_rd_data[7 : 0],
    fifo_rd_data[7 : 0],
    fifo_rd_data[7 : 0],
    fifo_rd_data[7 : 0]};

  assign fifo_rd_data_as_hw = {fifo_rd_data[15 : 0],
    fifo_rd_data[15 : 0]};

  assign fifo_rd_data_as_word = fifo_rd_data[31 : 0];
  assign write_writedata = ({32 {byte_access}} & fifo_rd_data_as_byte_access) |
    ({32 {hw}} & fifo_rd_data_as_hw) |
    ({32 {word}} & fifo_rd_data_as_word);

  assign fifo_write_data_valid = read_readdatavalid;
  assign set_software_reset_bit = ((dma_ctl_chipselect & ~dma_ctl_write_n & ((dma_ctl_address == 6) || (dma_ctl_address == 7)))) & (dma_ctl_address != 7) & dma_ctl_writedata[12];
  always @(posedge clk or negedge system_reset_n)
    begin
      if (system_reset_n == 0)
          d1_softwarereset <= 0;
      else if (set_software_reset_bit | software_reset_request)
          d1_softwarereset <= softwarereset & ~software_reset_request;
    end


  always @(posedge clk or negedge system_reset_n)
    begin
      if (system_reset_n == 0)
          software_reset_request <= 0;
      else if (set_software_reset_bit | software_reset_request)
          software_reset_request <= d1_softwarereset & ~software_reset_request;
    end


  always @(posedge clk or negedge system_reset_n)
    begin
      if (system_reset_n == 0)
          reset_n <= 0;
      else 
        reset_n <= ~(~system_reset_n | software_reset_request);
    end


  assign read_endofpacket = 0;
  assign write_endofpacket = 0;

endmodule

