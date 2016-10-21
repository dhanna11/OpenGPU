library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ogpu_data_record_pkg is

constant OGPU_CMD_NOP : unsigned(31 downto 0) := (others=>'0');
constant OGPU_CMD_PREPARE : unsigned(31 downto 0) := X"A5";
constant OGPU_CMD_RASTER : unsigned(31 downto 0) := X"AA";

type ogpu_float is
record
	sig: std_logic;
	exp: std_logic_vector(30 downto 23);
	frac: std_logic_vector(22 downto 0);
end record;

type ogpu_vertex is
record
	x,y,z: ogpu_float;
end record;

type ogpu_box is
record
	x0,y0: ogpu_float;
	x1,y1: ogpu_float;
end record;

type ogpu_tile is
record
	x0,y0: unsigned(31 downto 0);
	x1,y1: unsigned(31 downto 0);
end record;

type ogpu_edge is
record
	x0,y0: unsigned(31 downto 0);
	x1,y1: unsigned(31 downto 0);
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

end package ogpu_data_record_pkg;