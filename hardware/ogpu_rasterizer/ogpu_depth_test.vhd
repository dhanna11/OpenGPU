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
use ieee.numeric_std.all;

--TODO: implement depth_test algorithm used in software model

entity ogpu_depth_test is
	port(clock: in std_logic;
		  reset: in std_logic;
		  d: in ogpu_depth_test_in_type;
		  q: out ogpu_depth_test_out_type);
end ogpu_depth_test;

architecture depth_test_1 of ogpu_depth_test is
	type reg_type is record
		depth_test: std_logic;
		depth_ready: std_logic;
		depth_quad: ogpu_depth_quad;
	end record;
	signal r,rin	:	reg_type;
begin
comb: process(reset,d,r)
	variable v : reg_type;
	begin
		v := r; --default assignment
		
		v.depth_test := d.depth_test;
		v.depth_ready := d.depth_test;
		v.depth_quad := (others => to_signed(0,32));
				
		if reset = '1' then
			v.depth_ready := '0';
		end if;
		
		rin <= v;		-- drive register inputs
		
		q.depth_ready <= r.depth_ready;  -- drive module outputs
		q.depth_quad <= v.depth_quad;
		
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then r <= rin; end if;
	end process;
end depth_test_1;
