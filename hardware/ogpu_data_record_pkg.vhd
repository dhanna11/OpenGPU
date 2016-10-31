library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ogpu_data_record_pkg is

constant OGPU_CMD_NOP : unsigned(31 downto 0) := (others=>'0');
constant OGPU_CMD_PREPARE : unsigned(31 downto 0) := X"000000A5";
constant OGPU_CMD_RASTER : unsigned(31 downto 0) := X"000000AA";

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

end package ogpu_data_record_pkg;