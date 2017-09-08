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
use work.ogpu_data_record_pkg.all;

entity ogpu_triangle_edge_test is
	port(clock: in std_logic;
		  reset: in std_logic;
		  d: in ogpu_triangle_edge_test_in_type;
		  q: out ogpu_triangle_edge_test_out_type);
end ogpu_triangle_edge_test;

architecture triangle_test_1 of ogpu_triangle_edge_test is
	type reg_type is record
		edge_ready: std_logic_vector(0 to 2);
		draw_quad: std_logic;
		discard_quad: std_logic;
		quad_mask: std_logic_vector(0 to 3);
	end record;
	
	signal r,rin	:	reg_type;
begin
comb: process(reset,d,r)
	variable et0,et1,et2,et3 : std_logic;
	variable ot0,ot1,ot2,ot3 : std_logic;
	variable v : reg_type;
	begin
		v := r; --default assignment
		
		v.edge_ready := d.edge_ready;
		
		if (v.edge_ready(0) and v.edge_ready(1) and v.edge_ready(2))='1' then
		-- this logic comes from algorithm to check need of drawing quad fragment
			et0 := d.edge_mask0(0) and d.edge_mask1(0) and d.edge_mask2(0);
			et1 := d.edge_mask0(1) and d.edge_mask1(1) and d.edge_mask2(1);
			et2 := d.edge_mask0(2) and d.edge_mask1(2) and d.edge_mask2(2);
			et3 := d.edge_mask0(3) and d.edge_mask1(3) and d.edge_mask2(3);
			ot0 := d.edge_mask0(0) or d.edge_mask1(0) or d.edge_mask2(0);
			ot1 := d.edge_mask0(1) or d.edge_mask1(1) or d.edge_mask2(1);
			ot2 := d.edge_mask0(2) or d.edge_mask1(2) or d.edge_mask2(2);
			ot3 := d.edge_mask0(3) or d.edge_mask1(3) or d.edge_mask2(3);
			v.quad_mask(0):=(et0) or (not(ot0)); -- if >all< edge tests are (1,1,1) or (0,0,0) then draw fragment
			v.quad_mask(1):=(et1) or (not(ot1));
			v.quad_mask(2):=(et2) or (not(ot2));
			v.quad_mask(3):=(et3) or (not(ot3));
			v.draw_quad := v.quad_mask(0) or v.quad_mask(1) or v.quad_mask(2) or v.quad_mask(3);
			v.discard_quad := not v.draw_quad;
		else
			v.draw_quad := '0';
			v.discard_quad := '0';
		end if;
				
		if reset = '1' then
			v.draw_quad := '0';
			v.discard_quad := '0';
		end if;
		
		rin <= v;		-- drive register inputs
		
		q.draw_quad <= r.draw_quad;  -- drive module outputs
		q.discard_quad <= r.discard_quad; 
		q.quad_mask <= v.quad_mask; 
		
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then r <= rin; end if;
	end process;
end triangle_test_1;
