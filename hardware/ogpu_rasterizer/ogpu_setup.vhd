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

entity ogpu_setup is
	port(clock: in std_logic;
		  reset: in std_logic;
		  d:	in ogpu_setup_in_type;
		  q:	out ogpu_setup_out_type);
end ogpu_setup;

architecture setup_1 of ogpu_setup is
	type reg_type is record
		start_raster: std_logic;
		setup_done: std_logic;
		e0: ogpu_edge;
		e1: ogpu_edge;
		e2: ogpu_edge;
	end record;
	signal r,rin	:	reg_type;
begin
comb: process(reset,d,r)
	variable v : reg_type;
	begin
		v := r;
		
		v.start_raster := d.start_raster;
		v.setup_done := '0';
		
		v.e0.x0 := d.vx0.int;
		v.e0.y0 := d.vy0.int;
		v.e0.x1 := d.vx1.int;
		v.e0.y1 := d.vy1.int;
		
		v.e1.x0 := d.vx1.int;
		v.e1.y0 := d.vy1.int;
		v.e1.x1 := d.vx2.int;
		v.e1.y1 := d.vy2.int;
		
		v.e2.x0 := d.vx2.int;
		v.e2.y0 := d.vy2.int;
		v.e2.x1 := d.vx0.int;
		v.e2.y1 := d.vy0.int;
		
		if d.start_raster = '1' then
			v.setup_done := '1';
		end if;
		if reset='1' then v.setup_done := '0'; end if;
		
		rin <= v;		-- drive register inputs
		
		q.setup_done <= r.setup_done;  -- drive module outputs
		q.e0 <= v.e0;
		q.e1 <= v.e1;
		q.e2 <= v.e2;
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then
			r <= rin;
		end if;
	end process;
end setup_1;
