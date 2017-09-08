-- Copyright 2017 Fabricio Ribeiro Toloczko 

-- OpenGPU

-- -- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     http://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


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
	start_raster: std_logic;
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
	
	buffer_ack: std_logic;
	addr: std_logic_vector(63 downto 0);
end record;

type ogpu_quad_store_out_type is
record
	quad_stored: std_logic;

	quad_buffer_length: std_logic_vector(23 downto 0);
	buffer_address: std_logic_vector(15 downto 0);
	buffer_byte_enable: std_logic_vector(7 downto 0);
	buffer_write: std_logic;
	buffer_write_data: std_logic_vector(63 downto 0);
end record;

type ogpu_command is (OGPU_CMD_NOP,OGPU_CMD_PREPARE,OGPU_CMD_RASTER,OGPU_CMD_ERROR);
function ogpu_std_logic_to_command_func (s: std_logic_vector(7 downto 0)) return ogpu_command;
	
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

package body ogpu_data_record_pkg is

function ogpu_std_logic_to_command_func (s: std_logic_vector(7 downto 0)) return ogpu_command is
	variable r : ogpu_command;
begin
	case s is
		when "00000000" => r:=OGPU_CMD_NOP;
		when "10100101" => r:=OGPU_CMD_PREPARE;
		when "10101010" => r:=OGPU_CMD_RASTER;
		when others => r:=OGPU_CMD_ERROR;
	end case;
	return r;
end function;

end package body;