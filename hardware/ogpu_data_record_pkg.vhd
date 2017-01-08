library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ogpu_data_record_pkg is

type ogpu_float is
record
-- TODO: implement float point conversion to fix notation
--	sig: std_logic;
--	exp: std_logic_vector(30 downto 23);
--	frac: std_logic_vector(22 downto 0);
	int: unsigned(15 downto 0); -- fixed notation for initial implementation
end record;

type ogpu_vertex is
record
	x,y,z: ogpu_float;
end record;

type ogpu_box is
record
	--x0,y0: ogpu_float;
	--x1,y1: ogpu_float;
	x0,y0: unsigned(15 downto 0);
	x1,y1: unsigned(15 downto 0);
end record;

type ogpu_tile is
record
	x0,y0: unsigned(15 downto 0);
	x1,y1: unsigned(15 downto 0);
end record;

type ogpu_edge is
record
	x0,y0: unsigned(15 downto 0);
	x1,y1: unsigned(15 downto 0);
end record;

type ogpu_quad is
record
	x0,y0,x1,y1: unsigned(15 downto 0);
	x2,y2,x3,y3: unsigned(15 downto 0);
end record;

type ogpu_depth_coefficients is
record
	a,b,c: signed(31 downto 0);
end record;

type ogpu_depth_quad is array(0 to 3) of signed(31 downto 0);

type ogpu_quad_data is
record
	x0,y0: unsigned(15 downto 0);
	mask: std_logic_vector(0 to 3);
	depth: ogpu_depth_quad;
end record;

type ogpu_setup_in_type is
record
	vx0: ogpu_float;
	vy0: ogpu_float;
	vx1: ogpu_float;
	vy1: ogpu_float;
	vx2: ogpu_float;
	vy2: ogpu_float;
	start_raster: std_logic;
end record;

type ogpu_setup_out_type is
record
	setup_done: std_logic;
	e0: ogpu_edge;
	e1: ogpu_edge;
	e2: ogpu_edge;
end record;

type ogpu_quad_generator_in_type is
record
	clip_rect: ogpu_box;
	tile: ogpu_tile;
	next_quad: std_logic;
end record;

type ogpu_quad_generator_out_type is
record
	end_tile: std_logic;
	quad_ready: std_logic;
	quad: ogpu_quad;
end record;

type ogpu_quad_edge_test_in_type is
record
	edge_test: std_logic;
	quad:  ogpu_quad;
	e:  ogpu_edge;
end record;

type ogpu_quad_edge_test_out_type is
record
	edge_ready:  std_logic;
	edge_mask:   std_logic_vector(0 to 3);
end record;

type ogpu_triangle_edge_test_in_type is
record
	edge_ready: std_logic_vector(0 to 2);
	edge_mask0: std_logic_vector(0 to 3);
	edge_mask1: std_logic_vector(0 to 3);
	edge_mask2: std_logic_vector(0 to 3);
end record;

type ogpu_triangle_edge_test_out_type is
record
	draw_quad: std_logic;
	discard_quad: std_logic;
	quad_mask: std_logic_vector(0 to 3);
end record;

type ogpu_depth_test_in_type is
record
	depth_coef: ogpu_depth_coefficients;
	quad: ogpu_quad;
	depth_test: std_logic;
end record;

type ogpu_depth_test_out_type is
record
	depth_ready: std_logic;
	depth_quad: ogpu_depth_quad;
end record;

type ogpu_quad_store_in_type is
record
	quad_mask: std_logic_vector(0 to 3);
	quad: ogpu_quad;
	depth_quad: ogpu_depth_quad;
	start_raster: std_logic;
	store_quad: std_logic;
end record;

type ogpu_quad_store_out_type is
record
	store_quad_data: std_logic;
	quad_stored: std_logic;
	quad_data: ogpu_quad_data;
end record;

type ogpu_quad_buffer_in_type is
record
	store: std_logic;
	addr: std_logic_vector(63 downto 0);
	data: ogpu_quad_data;
end record;

type ogpu_command is
	(OGPU_CMD_NOP,OGPU_CMD_PREPARE,OGPU_CMD_RASTER);
attribute OGPU_CMD_ENUM_ENCODING: string;
attribute OGPU_CMD_ENUM_ENCODING of ogpu_command : type is
	"00 A5 AA";
	--"00000000 10100101 10101010";

type ogpu_raster_control_in_type is
record
	command: ogpu_command;
	setup_done: std_logic;
	end_tile: std_logic;
	quad_ready: std_logic;
	depth_ready: std_logic;
	quad_stored: std_logic;
	draw_quad: std_logic;
	discard_quad: std_logic;
end record;

type ogpu_raster_control_out_type is
record
	start_raster: std_logic;
	next_quad: std_logic;
	edge_test: std_logic;
	depth_test: std_logic;
	store_quad: std_logic;
	busy: std_logic;
	done: std_logic;
end record;

end package ogpu_data_record_pkg;