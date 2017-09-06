-- OGPU -- RASTER STRUCTURAL MODEL --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_raster_unit is
	port(clock:					in std_logic;
		  reset:					in std_logic;
		  command:				in std_logic_vector(7 downto 0);
		  v0x,v0y,v0z:				in std_logic_vector(15 downto 0);
		  v1x,v1y,v1z:				in std_logic_vector(15 downto 0);
		  v2x,v2y,v2z:				in std_logic_vector(15 downto 0);
		  clip_rect0:			in std_logic_vector(31 downto 0);
		  clip_rect1:			in std_logic_vector(31 downto 0);
		  tile0:					in std_logic_vector(31 downto 0);
		  tile1:					in std_logic_vector(31 downto 0);
		  depth_coef_a:		in std_logic_vector(31 downto 0);
		  depth_coef_b:		in std_logic_vector(31 downto 0);
		  depth_coef_c:		in std_logic_vector(31 downto 0);
		  quad_buffer_addr:	in std_logic_vector(63 downto 0);
		  done:					out std_logic;
		  busy: 					out std_logic;
		  quad_buffer_length: out std_logic_vector(23 downto 0);
		  --external buffer interface
		  ext_buffer_ack:				in std_logic;
		  ext_buffer_address:		out std_logic_vector(15 downto 0);
		  ext_buffer_byte_enable:	out std_logic_vector(7 downto 0);
		  ext_buffer_write:			out std_logic;
		  ext_buffer_write_data:	out std_logic_vector(63 downto 0);--);
		  --debug interface
			dbg: out std_logic_vector(11 downto 0));
end ogpu_raster_unit;

architecture structure_1 of ogpu_raster_unit is
	--
	signal int_command:				 ogpu_command;
	signal int_v0:						 ogpu_vertex;
	signal int_v1:						 ogpu_vertex;
	signal int_v2:						 ogpu_vertex;
	signal int_clip_rect:			 ogpu_box;
	signal int_tile:					 ogpu_tile;
	signal int_depth_coef:			 ogpu_depth_coefficients;
	--
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
--debug
dbg(0)<=start_raster;
dbg(1)<=next_quad;
dbg(2)<=quad_ready;
dbg(3)<=depth_test;
dbg(4)<=edge_test;
dbg(5)<=store_quad;
dbg(6)<=setup_done;
dbg(7)<=end_tile;
dbg(8)<=draw_quad;
dbg(9)<=discard_quad;
dbg(10)<=depth_ready;
dbg(11)<=quad_stored;
-- input/output packing
	int_command <= ogpu_std_logic_to_command_func(command);
	int_v0.x.int<=unsigned(v0x);		int_v0.y.int<=unsigned(v0y);		int_v0.z.int<=unsigned(v0z);
	int_v1.x.int<=unsigned(v1x);		int_v1.y.int<=unsigned(v1y);		int_v1.z.int<=unsigned(v1z);
	int_v2.x.int<=unsigned(v2x);		int_v2.y.int<=unsigned(v2y);		int_v2.z.int<=unsigned(v2z);
	int_clip_rect.y0<=unsigned(clip_rect0(15 downto 0));
	int_clip_rect.x0<=unsigned(clip_rect0(31 downto 16));
	int_clip_rect.y1<=unsigned(clip_rect1(15 downto 0));
	int_clip_rect.x1<=unsigned(clip_rect1(31 downto 16));
	int_tile.y0<=unsigned(tile0(15 downto 0));
	int_tile.x0<=unsigned(tile0(31 downto 16));
	int_tile.y1<=unsigned(tile1(15 downto 0));
	int_tile.x1<=unsigned(tile1(31 downto 16));
	int_depth_coef.a<=signed(depth_coef_a);
	int_depth_coef.b<=signed(depth_coef_b);
	int_depth_coef.c<=signed(depth_coef_c);

-- CONTROL
RC1:  entity work.ogpu_raster_control(raster_control_1) port map(clock=>clock,reset=>reset,
									-- IN
									d.command=>int_command,
									d.setup_done=>setup_done,
									d.end_tile=>end_tile,
									d.quad_ready=>quad_ready,
									d.depth_ready=>depth_ready,
									d.quad_stored=>quad_stored,
									d.draw_quad=>draw_quad,
									d.discard_quad=>discard_quad,
									-- OUT
									q.start_raster=>start_raster,
									q.next_quad=>next_quad,
									q.edge_test=>edge_test,
									q.depth_test=>depth_test,
									q.store_quad=>store_quad,
									q.busy=>busy,
									q.done=>done);
-- DATAPATH
ST1:  entity work.ogpu_setup(setup_1) port map(-- IN
									clock=>clock,reset=>reset,
									d.vx0=>int_v0.x,d.vy0=>int_v0.y,
									d.vx1=>int_v1.x,d.vy1=>int_v1.y,
									d.vx2=>int_v2.x,d.vy2=>int_v2.y,
									d.start_raster=>start_raster,
									-- OUT
									q.setup_done=>setup_done,
									q.e0=>e0,q.e1=>e1,q.e2=>e2);
QG1:  entity work.ogpu_quad_generator(generator_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									d.clip_rect=>int_clip_rect,d.tile=>int_tile,d.next_quad=>next_quad,
									d.start_raster=>start_raster,
									-- OUT
									q.end_tile=>end_tile,q.quad_ready=>quad_ready,
									q.quad=>quad);
ET1:  entity work.ogpu_quad_edge_test(edge_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									d.edge_test=>edge_test,d.e=>e0,
									d.quad=>quad,
									-- OUT
									q.edge_ready=>edge_ready(0),
									q.edge_mask=>edge_mask0);
ET2:  entity work.ogpu_quad_edge_test(edge_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									d.edge_test=>edge_test,d.e=>e1,
									d.quad=>quad,
									-- OUT
									q.edge_ready=>edge_ready(1),
									q.edge_mask=>edge_mask1);
ET3:  entity work.ogpu_quad_edge_test(edge_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									d.edge_test=>edge_test,d.e=>e2,
									d.quad=>quad,
									-- OUT
									q.edge_ready=>edge_ready(2),
									q.edge_mask=>edge_mask2);
TE1:  entity work.ogpu_triangle_edge_test(triangle_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									d.edge_ready=>edge_ready,
									d.edge_mask0=>edge_mask0,d.edge_mask1=>edge_mask1,d.edge_mask2=>edge_mask2,
									-- OUT
									q.draw_quad=>draw_quad,q.discard_quad=>discard_quad,
									q.quad_mask=>quad_mask);
DT1:  entity work.ogpu_depth_test(depth_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									d.depth_coef=>int_depth_coef,
									d.quad=>quad,
									d.depth_test=>depth_test,
									-- OUT
									q.depth_ready=>depth_ready,
									q.depth_quad=>depth_quad);
QS1:  entity work.ogpu_quad_store(quad_store_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									d.addr=>quad_buffer_addr,
									d.quad_mask=>quad_mask,
									d.quad=>quad,
									d.depth_quad=>depth_quad,
									d.start_raster=>start_raster,
									d.store_quad=>store_quad,
									d.buffer_ack=>ext_buffer_ack,
									-- OUT
									q.quad_stored=>quad_stored,
									q.quad_buffer_length=>quad_buffer_length,
									q.buffer_address=>ext_buffer_address,
									q.buffer_byte_enable=>ext_buffer_byte_enable,
									q.buffer_write=>ext_buffer_write,
									q.buffer_write_data=>ext_buffer_write_data);
end structure_1;
