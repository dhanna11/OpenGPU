
module soc_system (
	alt_vip_itc_0_clocked_video_vid_clk,
	alt_vip_itc_0_clocked_video_vid_data,
	alt_vip_itc_0_clocked_video_underflow,
	alt_vip_itc_0_clocked_video_vid_datavalid,
	alt_vip_itc_0_clocked_video_vid_v_sync,
	alt_vip_itc_0_clocked_video_vid_h_sync,
	alt_vip_itc_0_clocked_video_vid_f,
	alt_vip_itc_0_clocked_video_vid_h,
	alt_vip_itc_0_clocked_video_vid_v,
	button_pio_external_connection_export,
	clk_clk,
	dbg_csig_probes_probe,
	dbg_ram_probes_probe,
	dipsw_pio_external_connection_export,
	hps_0_h2f_reset_reset_n,
	hps_0_hps_io_hps_io_emac1_inst_TX_CLK,
	hps_0_hps_io_hps_io_emac1_inst_TXD0,
	hps_0_hps_io_hps_io_emac1_inst_TXD1,
	hps_0_hps_io_hps_io_emac1_inst_TXD2,
	hps_0_hps_io_hps_io_emac1_inst_TXD3,
	hps_0_hps_io_hps_io_emac1_inst_RXD0,
	hps_0_hps_io_hps_io_emac1_inst_MDIO,
	hps_0_hps_io_hps_io_emac1_inst_MDC,
	hps_0_hps_io_hps_io_emac1_inst_RX_CTL,
	hps_0_hps_io_hps_io_emac1_inst_TX_CTL,
	hps_0_hps_io_hps_io_emac1_inst_RX_CLK,
	hps_0_hps_io_hps_io_emac1_inst_RXD1,
	hps_0_hps_io_hps_io_emac1_inst_RXD2,
	hps_0_hps_io_hps_io_emac1_inst_RXD3,
	hps_0_hps_io_hps_io_qspi_inst_IO0,
	hps_0_hps_io_hps_io_qspi_inst_IO1,
	hps_0_hps_io_hps_io_qspi_inst_IO2,
	hps_0_hps_io_hps_io_qspi_inst_IO3,
	hps_0_hps_io_hps_io_qspi_inst_SS0,
	hps_0_hps_io_hps_io_qspi_inst_CLK,
	hps_0_hps_io_hps_io_sdio_inst_CMD,
	hps_0_hps_io_hps_io_sdio_inst_D0,
	hps_0_hps_io_hps_io_sdio_inst_D1,
	hps_0_hps_io_hps_io_sdio_inst_CLK,
	hps_0_hps_io_hps_io_sdio_inst_D2,
	hps_0_hps_io_hps_io_sdio_inst_D3,
	hps_0_hps_io_hps_io_usb1_inst_D0,
	hps_0_hps_io_hps_io_usb1_inst_D1,
	hps_0_hps_io_hps_io_usb1_inst_D2,
	hps_0_hps_io_hps_io_usb1_inst_D3,
	hps_0_hps_io_hps_io_usb1_inst_D4,
	hps_0_hps_io_hps_io_usb1_inst_D5,
	hps_0_hps_io_hps_io_usb1_inst_D6,
	hps_0_hps_io_hps_io_usb1_inst_D7,
	hps_0_hps_io_hps_io_usb1_inst_CLK,
	hps_0_hps_io_hps_io_usb1_inst_STP,
	hps_0_hps_io_hps_io_usb1_inst_DIR,
	hps_0_hps_io_hps_io_usb1_inst_NXT,
	hps_0_hps_io_hps_io_spim1_inst_CLK,
	hps_0_hps_io_hps_io_spim1_inst_MOSI,
	hps_0_hps_io_hps_io_spim1_inst_MISO,
	hps_0_hps_io_hps_io_spim1_inst_SS0,
	hps_0_hps_io_hps_io_uart0_inst_RX,
	hps_0_hps_io_hps_io_uart0_inst_TX,
	hps_0_hps_io_hps_io_i2c0_inst_SDA,
	hps_0_hps_io_hps_io_i2c0_inst_SCL,
	hps_0_hps_io_hps_io_i2c1_inst_SDA,
	hps_0_hps_io_hps_io_i2c1_inst_SCL,
	hps_0_hps_io_hps_io_gpio_inst_GPIO09,
	hps_0_hps_io_hps_io_gpio_inst_GPIO35,
	hps_0_hps_io_hps_io_gpio_inst_GPIO40,
	hps_0_hps_io_hps_io_gpio_inst_GPIO48,
	hps_0_hps_io_hps_io_gpio_inst_GPIO53,
	hps_0_hps_io_hps_io_gpio_inst_GPIO54,
	hps_0_hps_io_hps_io_gpio_inst_GPIO61,
	led_pio_external_connection_export,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	ogpu_quad_store_ack_external_connection_export,
	ogpu_quad_store_data_high_external_connection_export,
	ogpu_quad_store_data_low_external_connection_export,
	ogpu_quad_store_req_external_connection_export,
	ogpu_raster_unit_clip_rect0_external_connection_export,
	ogpu_raster_unit_clip_rect1_external_connection_export,
	ogpu_raster_unit_command_external_connection_export,
	ogpu_raster_unit_depth_coef_a_external_connection_export,
	ogpu_raster_unit_depth_coef_b_external_connection_export,
	ogpu_raster_unit_depth_coef_c_external_connection_export,
	ogpu_raster_unit_quad_buffer_addr_high_external_connection_export,
	ogpu_raster_unit_quad_buffer_addr_low_external_connection_export,
	ogpu_raster_unit_status_external_connection_export,
	ogpu_raster_unit_tile0_external_connection_export,
	ogpu_raster_unit_tile1_external_connection_export,
	ogpu_raster_unit_v0x_external_connection_export,
	ogpu_raster_unit_v0y_external_connection_export,
	ogpu_raster_unit_v0z_external_connection_export,
	ogpu_raster_unit_v1x_external_connection_export,
	ogpu_raster_unit_v1y_external_connection_export,
	ogpu_raster_unit_v1z_external_connection_export,
	ogpu_raster_unit_v2x_external_connection_export,
	ogpu_raster_unit_v2y_external_connection_export,
	ogpu_raster_unit_v2z_external_connection_export,
	reset_reset_n,
	seven_seg_0_external_connection_export,
	seven_seg_1_external_connection_export,
	seven_seg_2_external_connection_export,
	seven_seg_3_external_connection_export,
	seven_seg_4_external_connection_export,
	seven_seg_5_external_connection_export,
	ogpu_reset_external_connection_export);	

	input		alt_vip_itc_0_clocked_video_vid_clk;
	output	[31:0]	alt_vip_itc_0_clocked_video_vid_data;
	output		alt_vip_itc_0_clocked_video_underflow;
	output		alt_vip_itc_0_clocked_video_vid_datavalid;
	output		alt_vip_itc_0_clocked_video_vid_v_sync;
	output		alt_vip_itc_0_clocked_video_vid_h_sync;
	output		alt_vip_itc_0_clocked_video_vid_f;
	output		alt_vip_itc_0_clocked_video_vid_h;
	output		alt_vip_itc_0_clocked_video_vid_v;
	input	[1:0]	button_pio_external_connection_export;
	input		clk_clk;
	input	[11:0]	dbg_csig_probes_probe;
	input	[90:0]	dbg_ram_probes_probe;
	input	[9:0]	dipsw_pio_external_connection_export;
	output		hps_0_h2f_reset_reset_n;
	output		hps_0_hps_io_hps_io_emac1_inst_TX_CLK;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD0;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD1;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD2;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD3;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD0;
	inout		hps_0_hps_io_hps_io_emac1_inst_MDIO;
	output		hps_0_hps_io_hps_io_emac1_inst_MDC;
	input		hps_0_hps_io_hps_io_emac1_inst_RX_CTL;
	output		hps_0_hps_io_hps_io_emac1_inst_TX_CTL;
	input		hps_0_hps_io_hps_io_emac1_inst_RX_CLK;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD1;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD2;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD3;
	inout		hps_0_hps_io_hps_io_qspi_inst_IO0;
	inout		hps_0_hps_io_hps_io_qspi_inst_IO1;
	inout		hps_0_hps_io_hps_io_qspi_inst_IO2;
	inout		hps_0_hps_io_hps_io_qspi_inst_IO3;
	output		hps_0_hps_io_hps_io_qspi_inst_SS0;
	output		hps_0_hps_io_hps_io_qspi_inst_CLK;
	inout		hps_0_hps_io_hps_io_sdio_inst_CMD;
	inout		hps_0_hps_io_hps_io_sdio_inst_D0;
	inout		hps_0_hps_io_hps_io_sdio_inst_D1;
	output		hps_0_hps_io_hps_io_sdio_inst_CLK;
	inout		hps_0_hps_io_hps_io_sdio_inst_D2;
	inout		hps_0_hps_io_hps_io_sdio_inst_D3;
	inout		hps_0_hps_io_hps_io_usb1_inst_D0;
	inout		hps_0_hps_io_hps_io_usb1_inst_D1;
	inout		hps_0_hps_io_hps_io_usb1_inst_D2;
	inout		hps_0_hps_io_hps_io_usb1_inst_D3;
	inout		hps_0_hps_io_hps_io_usb1_inst_D4;
	inout		hps_0_hps_io_hps_io_usb1_inst_D5;
	inout		hps_0_hps_io_hps_io_usb1_inst_D6;
	inout		hps_0_hps_io_hps_io_usb1_inst_D7;
	input		hps_0_hps_io_hps_io_usb1_inst_CLK;
	output		hps_0_hps_io_hps_io_usb1_inst_STP;
	input		hps_0_hps_io_hps_io_usb1_inst_DIR;
	input		hps_0_hps_io_hps_io_usb1_inst_NXT;
	output		hps_0_hps_io_hps_io_spim1_inst_CLK;
	output		hps_0_hps_io_hps_io_spim1_inst_MOSI;
	input		hps_0_hps_io_hps_io_spim1_inst_MISO;
	output		hps_0_hps_io_hps_io_spim1_inst_SS0;
	input		hps_0_hps_io_hps_io_uart0_inst_RX;
	output		hps_0_hps_io_hps_io_uart0_inst_TX;
	inout		hps_0_hps_io_hps_io_i2c0_inst_SDA;
	inout		hps_0_hps_io_hps_io_i2c0_inst_SCL;
	inout		hps_0_hps_io_hps_io_i2c1_inst_SDA;
	inout		hps_0_hps_io_hps_io_i2c1_inst_SCL;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO09;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO35;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO40;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO48;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO53;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO54;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO61;
	output	[9:0]	led_pio_external_connection_export;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	output		ogpu_quad_store_ack_external_connection_export;
	input	[31:0]	ogpu_quad_store_data_high_external_connection_export;
	input	[31:0]	ogpu_quad_store_data_low_external_connection_export;
	input		ogpu_quad_store_req_external_connection_export;
	output	[31:0]	ogpu_raster_unit_clip_rect0_external_connection_export;
	output	[31:0]	ogpu_raster_unit_clip_rect1_external_connection_export;
	output	[7:0]	ogpu_raster_unit_command_external_connection_export;
	output	[31:0]	ogpu_raster_unit_depth_coef_a_external_connection_export;
	output	[31:0]	ogpu_raster_unit_depth_coef_b_external_connection_export;
	output	[31:0]	ogpu_raster_unit_depth_coef_c_external_connection_export;
	output	[31:0]	ogpu_raster_unit_quad_buffer_addr_high_external_connection_export;
	output	[31:0]	ogpu_raster_unit_quad_buffer_addr_low_external_connection_export;
	input	[31:0]	ogpu_raster_unit_status_external_connection_export;
	output	[31:0]	ogpu_raster_unit_tile0_external_connection_export;
	output	[31:0]	ogpu_raster_unit_tile1_external_connection_export;
	output	[15:0]	ogpu_raster_unit_v0x_external_connection_export;
	output	[15:0]	ogpu_raster_unit_v0y_external_connection_export;
	output	[15:0]	ogpu_raster_unit_v0z_external_connection_export;
	output	[15:0]	ogpu_raster_unit_v1x_external_connection_export;
	output	[15:0]	ogpu_raster_unit_v1y_external_connection_export;
	output	[15:0]	ogpu_raster_unit_v1z_external_connection_export;
	output	[15:0]	ogpu_raster_unit_v2x_external_connection_export;
	output	[15:0]	ogpu_raster_unit_v2y_external_connection_export;
	output	[15:0]	ogpu_raster_unit_v2z_external_connection_export;
	input		reset_reset_n;
	output	[6:0]	seven_seg_0_external_connection_export;
	output	[6:0]	seven_seg_1_external_connection_export;
	output	[6:0]	seven_seg_2_external_connection_export;
	output	[6:0]	seven_seg_3_external_connection_export;
	output	[6:0]	seven_seg_4_external_connection_export;
	output	[6:0]	seven_seg_5_external_connection_export;
	output		ogpu_reset_external_connection_export;
endmodule
