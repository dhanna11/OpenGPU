-- OGPU -- RASTER STRUCTURAL MODEL --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_raster_unit is
	port(clock:					in std_logic;
		  reset:					in std_logic;
		  command:				in unsigned(31 downto 0);
		  v0,v1,v2:				in ogpu_vertex;
		  clip_rect:			in ogpu_box;
		  tile:					in ogpu_tile;
		  depth_coef:			in ogpu_depth_coefficients;
		  quad_buffer_addr:	in unsigned(63 downto 0);
		  done:					out std_logic;
		  busy: 					out std_logic);
end ogpu_raster_unit;

architecture structure_1 of ogpu_raster_unit is
	signal buffer_pointer 	: std_logic_vector(63 downto 0) 			:=(others=>'0');
	signal quad_data 			: ogpu_quad_data 		:=(x0=>(others=>'0'),y0=>(others=>'0'),mask=>(others=>'0'),
																	depth=>(others=>(others=>'0')));
	signal e0					: ogpu_edge			 		:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'));
	signal e1					: ogpu_edge			 		:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'));
	signal e2					: ogpu_edge			 		:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'));
	signal quad					: ogpu_quad			 		:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'),x2=>(others=>'0'),y2=>(others=>'0'),x3=>(others=>'0'),y3=>(others=>'0'));
	signal edge_mask0			: std_logic_vector(0 to 3)		:=(others=>'0');
	signal edge_mask1			: std_logic_vector(0 to 3)		:=(others=>'0');
	signal edge_mask2			: std_logic_vector(0 to 3)		:=(others=>'0');
	signal edge_ready			: std_logic_vector(0 to 2)		:=(others=>'0');
	signal quad_mask			: std_logic_vector(0 to 3)		:=(others=>'0');
	signal depth_quad			: ogpu_depth_quad			:=(others=>(others=>'0'));
	signal store_quad_data	: std_logic			:='0';
	-- DATAPATH/CONTROL interface signals
	signal start_raster:		std_logic:='0';
	signal next_quad:			std_logic:='0';
	signal quad_ready:		std_logic:='0';
	signal depth_test:		std_logic:='0';
	signal edge_test:			std_logic:='0';
	signal store_quad:		std_logic:='0';
	signal setup_done:				std_logic:='0';
	signal end_tile: 					std_logic:='0';
	signal draw_quad: 				std_logic:='0';
	signal discard_quad:				std_logic:='0';
	signal depth_ready:				std_logic:='0';
	signal quad_stored:				std_logic:='0';
begin
-- CONTROL
RC1:  entity work.ogpu_raster_control(raster_control_1) port map(clock=>clock,reset=>reset,
									-- IN
									command=>command,
									setup_done=>setup_done,
									end_tile=>end_tile,
									quad_ready=>quad_ready,
									depth_ready=>depth_ready,
									quad_stored=>quad_stored,
									draw_quad=>draw_quad,
									discard_quad=>discard_quad,
									-- OUT
									start_raster=>start_raster,
									next_quad=>next_quad,
									edge_test=>edge_test,
									depth_test=>depth_test,
									store_quad=>store_quad,
									busy=>busy,
									done=>done);
-- DATAPATH
QB1:  entity work.ogpu_quad_buffer(test) port map(clock=>clock,reset=>reset,store=>store_quad_data,addr=>buffer_pointer,data=>quad_data); --IN
ST1:  entity work.ogpu_setup(setup_1) port map(-- IN
															  clock=>clock,reset=>reset,
															  vx0=>v0.x,vy0=>v0.y,
															  vx1=>v1.x,vy1=>v1.y,
															  vx2=>v2.x,vy2=>v2.y,
															  start_raster=>start_raster,
															  -- OUT
															  setup_done=>setup_done,
															  e0=>e0,e1=>e1,e2=>e2);
QG1:  entity work.ogpu_quad_generator(generator_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									clip_rect=>clip_rect,tile=>tile,next_quad=>next_quad,
									-- OUT
									end_tile=>end_tile,quad_ready=>quad_ready,
									quad=>quad);
ET1:  entity work.ogpu_quad_edge_test(edge_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									edge_test=>edge_test,edge=>e0,
									quad=>quad,
									-- OUT
									edge_ready=>edge_ready(0),
									edge_mask=>edge_mask0);
ET2:  entity work.ogpu_quad_edge_test(edge_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									edge_test=>edge_test,edge=>e1,
									quad=>quad,
									-- OUT
									edge_ready=>edge_ready(1),
									edge_mask=>edge_mask1);
ET3:  entity work.ogpu_quad_edge_test(edge_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									edge_test=>edge_test,edge=>e2,
									quad=>quad,
									-- OUT
									edge_ready=>edge_ready(2),
									edge_mask=>edge_mask2);
TE1:  entity work.ogpu_triangle_edge_test(triangle_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									edge_ready=>edge_ready,
									edge_mask0=>edge_mask0,edge_mask1=>edge_mask1,edge_mask2=>edge_mask2,
									-- OUT
									draw_quad=>draw_quad,discard_quad=>discard_quad,
									quad_mask=>quad_mask);
DT1:  entity work.ogpu_depth_test(depth_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									depth_coef=>depth_coef,
									quad=>quad,
									depth_test=>depth_test,
									-- OUT
									depth_ready=>depth_ready,
									depth_quad=>depth_quad);
QS1:  entity work.ogpu_quad_store(quad_store_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									quad_mask=>quad_mask,quad=>quad,
									depth_quad=>depth_quad,
									start_raster=>start_raster,
									store_quad=>store_quad,
									-- OUT
									store_quad_data=>store_quad_data,
									quad_data=>quad_data,
									quad_stored=>quad_stored);
end structure_1;
