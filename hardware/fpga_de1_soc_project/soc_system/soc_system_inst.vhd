	component soc_system is
		port (
			alt_vip_itc_0_clocked_video_vid_clk                               : in    std_logic                     := 'X';             -- vid_clk
			alt_vip_itc_0_clocked_video_vid_data                              : out   std_logic_vector(31 downto 0);                    -- vid_data
			alt_vip_itc_0_clocked_video_underflow                             : out   std_logic;                                        -- underflow
			alt_vip_itc_0_clocked_video_vid_datavalid                         : out   std_logic;                                        -- vid_datavalid
			alt_vip_itc_0_clocked_video_vid_v_sync                            : out   std_logic;                                        -- vid_v_sync
			alt_vip_itc_0_clocked_video_vid_h_sync                            : out   std_logic;                                        -- vid_h_sync
			alt_vip_itc_0_clocked_video_vid_f                                 : out   std_logic;                                        -- vid_f
			alt_vip_itc_0_clocked_video_vid_h                                 : out   std_logic;                                        -- vid_h
			alt_vip_itc_0_clocked_video_vid_v                                 : out   std_logic;                                        -- vid_v
			button_pio_external_connection_export                             : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			clk_clk                                                           : in    std_logic                     := 'X';             -- clk
			dbg_csig_probes_probe                                             : in    std_logic_vector(11 downto 0) := (others => 'X'); -- probe
			dbg_ram_probes_probe                                              : in    std_logic_vector(90 downto 0) := (others => 'X'); -- probe
			dipsw_pio_external_connection_export                              : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			hps_0_h2f_reset_reset_n                                           : out   std_logic;                                        -- reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK                             : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0                               : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1                               : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2                               : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3                               : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0                               : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO                               : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC                                : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL                             : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL                             : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK                             : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1                               : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2                               : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3                               : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_qspi_inst_IO0                                 : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
			hps_0_hps_io_hps_io_qspi_inst_IO1                                 : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
			hps_0_hps_io_hps_io_qspi_inst_IO2                                 : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
			hps_0_hps_io_hps_io_qspi_inst_IO3                                 : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
			hps_0_hps_io_hps_io_qspi_inst_SS0                                 : out   std_logic;                                        -- hps_io_qspi_inst_SS0
			hps_0_hps_io_hps_io_qspi_inst_CLK                                 : out   std_logic;                                        -- hps_io_qspi_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_CMD                                 : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0                                  : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1                                  : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK                                 : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2                                  : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3                                  : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0                                  : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1                                  : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2                                  : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3                                  : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4                                  : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5                                  : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6                                  : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7                                  : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK                                 : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP                                 : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR                                 : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT                                 : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim1_inst_CLK                                : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_0_hps_io_hps_io_spim1_inst_MOSI                               : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_0_hps_io_hps_io_spim1_inst_MISO                               : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_0_hps_io_hps_io_spim1_inst_SS0                                : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX                                 : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX                                 : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA                                 : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL                                 : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_i2c1_inst_SDA                                 : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_0_hps_io_hps_io_i2c1_inst_SCL                                 : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_0_hps_io_hps_io_gpio_inst_GPIO09                              : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35                              : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO40                              : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_0_hps_io_hps_io_gpio_inst_GPIO48                              : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
			hps_0_hps_io_hps_io_gpio_inst_GPIO53                              : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_0_hps_io_hps_io_gpio_inst_GPIO54                              : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_0_hps_io_hps_io_gpio_inst_GPIO61                              : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			led_pio_external_connection_export                                : out   std_logic_vector(9 downto 0);                     -- export
			memory_mem_a                                                      : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                                                     : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                                                     : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                                                   : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                                                    : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                                                   : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                                                  : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                                                  : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                                                   : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                                                : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                                                     : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                                                    : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                                                  : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                                                    : out   std_logic;                                        -- mem_odt
			memory_mem_dm                                                     : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                                                  : in    std_logic                     := 'X';             -- oct_rzqin
			ogpu_quad_store_ack_external_connection_export                    : out   std_logic;                                        -- export
			ogpu_quad_store_data_high_external_connection_export              : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			ogpu_quad_store_data_low_external_connection_export               : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			ogpu_quad_store_req_external_connection_export                    : in    std_logic                     := 'X';             -- export
			ogpu_raster_unit_clip_rect0_external_connection_export            : out   std_logic_vector(31 downto 0);                    -- export
			ogpu_raster_unit_clip_rect1_external_connection_export            : out   std_logic_vector(31 downto 0);                    -- export
			ogpu_raster_unit_command_external_connection_export               : out   std_logic_vector(7 downto 0);                     -- export
			ogpu_raster_unit_depth_coef_a_external_connection_export          : out   std_logic_vector(31 downto 0);                    -- export
			ogpu_raster_unit_depth_coef_b_external_connection_export          : out   std_logic_vector(31 downto 0);                    -- export
			ogpu_raster_unit_depth_coef_c_external_connection_export          : out   std_logic_vector(31 downto 0);                    -- export
			ogpu_raster_unit_quad_buffer_addr_high_external_connection_export : out   std_logic_vector(31 downto 0);                    -- export
			ogpu_raster_unit_quad_buffer_addr_low_external_connection_export  : out   std_logic_vector(31 downto 0);                    -- export
			ogpu_raster_unit_status_external_connection_export                : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			ogpu_raster_unit_tile0_external_connection_export                 : out   std_logic_vector(31 downto 0);                    -- export
			ogpu_raster_unit_tile1_external_connection_export                 : out   std_logic_vector(31 downto 0);                    -- export
			ogpu_raster_unit_v0x_external_connection_export                   : out   std_logic_vector(15 downto 0);                    -- export
			ogpu_raster_unit_v0y_external_connection_export                   : out   std_logic_vector(15 downto 0);                    -- export
			ogpu_raster_unit_v0z_external_connection_export                   : out   std_logic_vector(15 downto 0);                    -- export
			ogpu_raster_unit_v1x_external_connection_export                   : out   std_logic_vector(15 downto 0);                    -- export
			ogpu_raster_unit_v1y_external_connection_export                   : out   std_logic_vector(15 downto 0);                    -- export
			ogpu_raster_unit_v1z_external_connection_export                   : out   std_logic_vector(15 downto 0);                    -- export
			ogpu_raster_unit_v2x_external_connection_export                   : out   std_logic_vector(15 downto 0);                    -- export
			ogpu_raster_unit_v2y_external_connection_export                   : out   std_logic_vector(15 downto 0);                    -- export
			ogpu_raster_unit_v2z_external_connection_export                   : out   std_logic_vector(15 downto 0);                    -- export
			reset_reset_n                                                     : in    std_logic                     := 'X';             -- reset_n
			seven_seg_0_external_connection_export                            : out   std_logic_vector(6 downto 0);                     -- export
			seven_seg_1_external_connection_export                            : out   std_logic_vector(6 downto 0);                     -- export
			seven_seg_2_external_connection_export                            : out   std_logic_vector(6 downto 0);                     -- export
			seven_seg_3_external_connection_export                            : out   std_logic_vector(6 downto 0);                     -- export
			seven_seg_4_external_connection_export                            : out   std_logic_vector(6 downto 0);                     -- export
			seven_seg_5_external_connection_export                            : out   std_logic_vector(6 downto 0);                     -- export
			ogpu_reset_external_connection_export                             : out   std_logic                                         -- export
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			alt_vip_itc_0_clocked_video_vid_clk                               => CONNECTED_TO_alt_vip_itc_0_clocked_video_vid_clk,                               --                                alt_vip_itc_0_clocked_video.vid_clk
			alt_vip_itc_0_clocked_video_vid_data                              => CONNECTED_TO_alt_vip_itc_0_clocked_video_vid_data,                              --                                                           .vid_data
			alt_vip_itc_0_clocked_video_underflow                             => CONNECTED_TO_alt_vip_itc_0_clocked_video_underflow,                             --                                                           .underflow
			alt_vip_itc_0_clocked_video_vid_datavalid                         => CONNECTED_TO_alt_vip_itc_0_clocked_video_vid_datavalid,                         --                                                           .vid_datavalid
			alt_vip_itc_0_clocked_video_vid_v_sync                            => CONNECTED_TO_alt_vip_itc_0_clocked_video_vid_v_sync,                            --                                                           .vid_v_sync
			alt_vip_itc_0_clocked_video_vid_h_sync                            => CONNECTED_TO_alt_vip_itc_0_clocked_video_vid_h_sync,                            --                                                           .vid_h_sync
			alt_vip_itc_0_clocked_video_vid_f                                 => CONNECTED_TO_alt_vip_itc_0_clocked_video_vid_f,                                 --                                                           .vid_f
			alt_vip_itc_0_clocked_video_vid_h                                 => CONNECTED_TO_alt_vip_itc_0_clocked_video_vid_h,                                 --                                                           .vid_h
			alt_vip_itc_0_clocked_video_vid_v                                 => CONNECTED_TO_alt_vip_itc_0_clocked_video_vid_v,                                 --                                                           .vid_v
			button_pio_external_connection_export                             => CONNECTED_TO_button_pio_external_connection_export,                             --                             button_pio_external_connection.export
			clk_clk                                                           => CONNECTED_TO_clk_clk,                                                           --                                                        clk.clk
			dbg_csig_probes_probe                                             => CONNECTED_TO_dbg_csig_probes_probe,                                             --                                            dbg_csig_probes.probe
			dbg_ram_probes_probe                                              => CONNECTED_TO_dbg_ram_probes_probe,                                              --                                             dbg_ram_probes.probe
			dipsw_pio_external_connection_export                              => CONNECTED_TO_dipsw_pio_external_connection_export,                              --                              dipsw_pio_external_connection.export
			hps_0_h2f_reset_reset_n                                           => CONNECTED_TO_hps_0_h2f_reset_reset_n,                                           --                                            hps_0_h2f_reset.reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK                             => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CLK,                             --                                               hps_0_hps_io.hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0                               => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD0,                               --                                                           .hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1                               => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD1,                               --                                                           .hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2                               => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD2,                               --                                                           .hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3                               => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD3,                               --                                                           .hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0                               => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD0,                               --                                                           .hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO                               => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDIO,                               --                                                           .hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC                                => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDC,                                --                                                           .hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL                             => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CTL,                             --                                                           .hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL                             => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CTL,                             --                                                           .hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK                             => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CLK,                             --                                                           .hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1                               => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD1,                               --                                                           .hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2                               => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD2,                               --                                                           .hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3                               => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD3,                               --                                                           .hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_qspi_inst_IO0                                 => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO0,                                 --                                                           .hps_io_qspi_inst_IO0
			hps_0_hps_io_hps_io_qspi_inst_IO1                                 => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO1,                                 --                                                           .hps_io_qspi_inst_IO1
			hps_0_hps_io_hps_io_qspi_inst_IO2                                 => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO2,                                 --                                                           .hps_io_qspi_inst_IO2
			hps_0_hps_io_hps_io_qspi_inst_IO3                                 => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO3,                                 --                                                           .hps_io_qspi_inst_IO3
			hps_0_hps_io_hps_io_qspi_inst_SS0                                 => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_SS0,                                 --                                                           .hps_io_qspi_inst_SS0
			hps_0_hps_io_hps_io_qspi_inst_CLK                                 => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_CLK,                                 --                                                           .hps_io_qspi_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_CMD                                 => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CMD,                                 --                                                           .hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0                                  => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D0,                                  --                                                           .hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1                                  => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D1,                                  --                                                           .hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK                                 => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CLK,                                 --                                                           .hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2                                  => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D2,                                  --                                                           .hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3                                  => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D3,                                  --                                                           .hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0                                  => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D0,                                  --                                                           .hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1                                  => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D1,                                  --                                                           .hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2                                  => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D2,                                  --                                                           .hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3                                  => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D3,                                  --                                                           .hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4                                  => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D4,                                  --                                                           .hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5                                  => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D5,                                  --                                                           .hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6                                  => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D6,                                  --                                                           .hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7                                  => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D7,                                  --                                                           .hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK                                 => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_CLK,                                 --                                                           .hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP                                 => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_STP,                                 --                                                           .hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR                                 => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_DIR,                                 --                                                           .hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT                                 => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_NXT,                                 --                                                           .hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim1_inst_CLK                                => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_CLK,                                --                                                           .hps_io_spim1_inst_CLK
			hps_0_hps_io_hps_io_spim1_inst_MOSI                               => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_MOSI,                               --                                                           .hps_io_spim1_inst_MOSI
			hps_0_hps_io_hps_io_spim1_inst_MISO                               => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_MISO,                               --                                                           .hps_io_spim1_inst_MISO
			hps_0_hps_io_hps_io_spim1_inst_SS0                                => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_SS0,                                --                                                           .hps_io_spim1_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX                                 => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_RX,                                 --                                                           .hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX                                 => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_TX,                                 --                                                           .hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA                                 => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SDA,                                 --                                                           .hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL                                 => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SCL,                                 --                                                           .hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_i2c1_inst_SDA                                 => CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SDA,                                 --                                                           .hps_io_i2c1_inst_SDA
			hps_0_hps_io_hps_io_i2c1_inst_SCL                                 => CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SCL,                                 --                                                           .hps_io_i2c1_inst_SCL
			hps_0_hps_io_hps_io_gpio_inst_GPIO09                              => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO09,                              --                                                           .hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35                              => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO35,                              --                                                           .hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO40                              => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO40,                              --                                                           .hps_io_gpio_inst_GPIO40
			hps_0_hps_io_hps_io_gpio_inst_GPIO48                              => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO48,                              --                                                           .hps_io_gpio_inst_GPIO48
			hps_0_hps_io_hps_io_gpio_inst_GPIO53                              => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO53,                              --                                                           .hps_io_gpio_inst_GPIO53
			hps_0_hps_io_hps_io_gpio_inst_GPIO54                              => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO54,                              --                                                           .hps_io_gpio_inst_GPIO54
			hps_0_hps_io_hps_io_gpio_inst_GPIO61                              => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO61,                              --                                                           .hps_io_gpio_inst_GPIO61
			led_pio_external_connection_export                                => CONNECTED_TO_led_pio_external_connection_export,                                --                                led_pio_external_connection.export
			memory_mem_a                                                      => CONNECTED_TO_memory_mem_a,                                                      --                                                     memory.mem_a
			memory_mem_ba                                                     => CONNECTED_TO_memory_mem_ba,                                                     --                                                           .mem_ba
			memory_mem_ck                                                     => CONNECTED_TO_memory_mem_ck,                                                     --                                                           .mem_ck
			memory_mem_ck_n                                                   => CONNECTED_TO_memory_mem_ck_n,                                                   --                                                           .mem_ck_n
			memory_mem_cke                                                    => CONNECTED_TO_memory_mem_cke,                                                    --                                                           .mem_cke
			memory_mem_cs_n                                                   => CONNECTED_TO_memory_mem_cs_n,                                                   --                                                           .mem_cs_n
			memory_mem_ras_n                                                  => CONNECTED_TO_memory_mem_ras_n,                                                  --                                                           .mem_ras_n
			memory_mem_cas_n                                                  => CONNECTED_TO_memory_mem_cas_n,                                                  --                                                           .mem_cas_n
			memory_mem_we_n                                                   => CONNECTED_TO_memory_mem_we_n,                                                   --                                                           .mem_we_n
			memory_mem_reset_n                                                => CONNECTED_TO_memory_mem_reset_n,                                                --                                                           .mem_reset_n
			memory_mem_dq                                                     => CONNECTED_TO_memory_mem_dq,                                                     --                                                           .mem_dq
			memory_mem_dqs                                                    => CONNECTED_TO_memory_mem_dqs,                                                    --                                                           .mem_dqs
			memory_mem_dqs_n                                                  => CONNECTED_TO_memory_mem_dqs_n,                                                  --                                                           .mem_dqs_n
			memory_mem_odt                                                    => CONNECTED_TO_memory_mem_odt,                                                    --                                                           .mem_odt
			memory_mem_dm                                                     => CONNECTED_TO_memory_mem_dm,                                                     --                                                           .mem_dm
			memory_oct_rzqin                                                  => CONNECTED_TO_memory_oct_rzqin,                                                  --                                                           .oct_rzqin
			ogpu_quad_store_ack_external_connection_export                    => CONNECTED_TO_ogpu_quad_store_ack_external_connection_export,                    --                    ogpu_quad_store_ack_external_connection.export
			ogpu_quad_store_data_high_external_connection_export              => CONNECTED_TO_ogpu_quad_store_data_high_external_connection_export,              --              ogpu_quad_store_data_high_external_connection.export
			ogpu_quad_store_data_low_external_connection_export               => CONNECTED_TO_ogpu_quad_store_data_low_external_connection_export,               --               ogpu_quad_store_data_low_external_connection.export
			ogpu_quad_store_req_external_connection_export                    => CONNECTED_TO_ogpu_quad_store_req_external_connection_export,                    --                    ogpu_quad_store_req_external_connection.export
			ogpu_raster_unit_clip_rect0_external_connection_export            => CONNECTED_TO_ogpu_raster_unit_clip_rect0_external_connection_export,            --            ogpu_raster_unit_clip_rect0_external_connection.export
			ogpu_raster_unit_clip_rect1_external_connection_export            => CONNECTED_TO_ogpu_raster_unit_clip_rect1_external_connection_export,            --            ogpu_raster_unit_clip_rect1_external_connection.export
			ogpu_raster_unit_command_external_connection_export               => CONNECTED_TO_ogpu_raster_unit_command_external_connection_export,               --               ogpu_raster_unit_command_external_connection.export
			ogpu_raster_unit_depth_coef_a_external_connection_export          => CONNECTED_TO_ogpu_raster_unit_depth_coef_a_external_connection_export,          --          ogpu_raster_unit_depth_coef_a_external_connection.export
			ogpu_raster_unit_depth_coef_b_external_connection_export          => CONNECTED_TO_ogpu_raster_unit_depth_coef_b_external_connection_export,          --          ogpu_raster_unit_depth_coef_b_external_connection.export
			ogpu_raster_unit_depth_coef_c_external_connection_export          => CONNECTED_TO_ogpu_raster_unit_depth_coef_c_external_connection_export,          --          ogpu_raster_unit_depth_coef_c_external_connection.export
			ogpu_raster_unit_quad_buffer_addr_high_external_connection_export => CONNECTED_TO_ogpu_raster_unit_quad_buffer_addr_high_external_connection_export, -- ogpu_raster_unit_quad_buffer_addr_high_external_connection.export
			ogpu_raster_unit_quad_buffer_addr_low_external_connection_export  => CONNECTED_TO_ogpu_raster_unit_quad_buffer_addr_low_external_connection_export,  --  ogpu_raster_unit_quad_buffer_addr_low_external_connection.export
			ogpu_raster_unit_status_external_connection_export                => CONNECTED_TO_ogpu_raster_unit_status_external_connection_export,                --                ogpu_raster_unit_status_external_connection.export
			ogpu_raster_unit_tile0_external_connection_export                 => CONNECTED_TO_ogpu_raster_unit_tile0_external_connection_export,                 --                 ogpu_raster_unit_tile0_external_connection.export
			ogpu_raster_unit_tile1_external_connection_export                 => CONNECTED_TO_ogpu_raster_unit_tile1_external_connection_export,                 --                 ogpu_raster_unit_tile1_external_connection.export
			ogpu_raster_unit_v0x_external_connection_export                   => CONNECTED_TO_ogpu_raster_unit_v0x_external_connection_export,                   --                   ogpu_raster_unit_v0x_external_connection.export
			ogpu_raster_unit_v0y_external_connection_export                   => CONNECTED_TO_ogpu_raster_unit_v0y_external_connection_export,                   --                   ogpu_raster_unit_v0y_external_connection.export
			ogpu_raster_unit_v0z_external_connection_export                   => CONNECTED_TO_ogpu_raster_unit_v0z_external_connection_export,                   --                   ogpu_raster_unit_v0z_external_connection.export
			ogpu_raster_unit_v1x_external_connection_export                   => CONNECTED_TO_ogpu_raster_unit_v1x_external_connection_export,                   --                   ogpu_raster_unit_v1x_external_connection.export
			ogpu_raster_unit_v1y_external_connection_export                   => CONNECTED_TO_ogpu_raster_unit_v1y_external_connection_export,                   --                   ogpu_raster_unit_v1y_external_connection.export
			ogpu_raster_unit_v1z_external_connection_export                   => CONNECTED_TO_ogpu_raster_unit_v1z_external_connection_export,                   --                   ogpu_raster_unit_v1z_external_connection.export
			ogpu_raster_unit_v2x_external_connection_export                   => CONNECTED_TO_ogpu_raster_unit_v2x_external_connection_export,                   --                   ogpu_raster_unit_v2x_external_connection.export
			ogpu_raster_unit_v2y_external_connection_export                   => CONNECTED_TO_ogpu_raster_unit_v2y_external_connection_export,                   --                   ogpu_raster_unit_v2y_external_connection.export
			ogpu_raster_unit_v2z_external_connection_export                   => CONNECTED_TO_ogpu_raster_unit_v2z_external_connection_export,                   --                   ogpu_raster_unit_v2z_external_connection.export
			reset_reset_n                                                     => CONNECTED_TO_reset_reset_n,                                                     --                                                      reset.reset_n
			seven_seg_0_external_connection_export                            => CONNECTED_TO_seven_seg_0_external_connection_export,                            --                            seven_seg_0_external_connection.export
			seven_seg_1_external_connection_export                            => CONNECTED_TO_seven_seg_1_external_connection_export,                            --                            seven_seg_1_external_connection.export
			seven_seg_2_external_connection_export                            => CONNECTED_TO_seven_seg_2_external_connection_export,                            --                            seven_seg_2_external_connection.export
			seven_seg_3_external_connection_export                            => CONNECTED_TO_seven_seg_3_external_connection_export,                            --                            seven_seg_3_external_connection.export
			seven_seg_4_external_connection_export                            => CONNECTED_TO_seven_seg_4_external_connection_export,                            --                            seven_seg_4_external_connection.export
			seven_seg_5_external_connection_export                            => CONNECTED_TO_seven_seg_5_external_connection_export,                            --                            seven_seg_5_external_connection.export
			ogpu_reset_external_connection_export                             => CONNECTED_TO_ogpu_reset_external_connection_export                              --                             ogpu_reset_external_connection.export
		);

