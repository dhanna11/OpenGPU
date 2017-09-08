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
use work.ogpu_data_record_pkg.all;

entity ogpu_triangle_edge_test_testbench is
end ogpu_triangle_edge_test_testbench;

architecture ogpu_triangle_edge_test_tb1 of ogpu_triangle_edge_test_testbench is
	constant clock_period : time := 20 ns;
	signal clock,reset	: std_logic :='0';
	--
	signal edge_ready: std_logic_vector(0 to 2):=(others=>'0');
	signal edge_mask0: std_logic_vector(0 to 3);
	signal edge_mask1: std_logic_vector(0 to 3);
	signal edge_mask2: std_logic_vector(0 to 3);
	signal quad_mask: std_logic_vector(0 to 3);
	-- DATAPATH/CONTROL interface signals
	signal draw_quad: std_logic;
	signal discard_quad: std_logic;
begin
TE1:  entity work.ogpu_triangle_edge_test(triangle_test_1) port map(
									-- IN
									clock=>clock,reset=>reset,
									d.edge_ready=>edge_ready,
									d.edge_mask0=>edge_mask0,d.edge_mask1=>edge_mask1,d.edge_mask2=>edge_mask2,
									-- OUT
									q.draw_quad=>draw_quad,q.discard_quad=>discard_quad,
									q.quad_mask=>quad_mask);
								
reset_proc: process
	begin
		--reset <= '0';
		--wait for 5*clock_period;
		reset <= '1';
		wait for 5*clock_period;
		reset <= '0';
		wait;
	end process;
	
stim_proc: process
	begin
		--wait for 5*clock_period;
		edge_mask0 <= "0110";
		edge_mask1 <= "0101";
		edge_mask2 <= "0110";
		-- expects quad_mask="1100", because only (0,0,0) and (1,1,1) mean "inside triangle" situation
		wait for 6*clock_period;
		edge_ready(0)<='1';
		wait for clock_period;
		edge_ready(1)<='1';
		wait for clock_period;
		edge_ready(2)<='1';
		wait for 2*clock_period;
		edge_ready<="000";
		wait for clock_period;
		
		edge_mask0 <= "1111";
		edge_mask1 <= "1111";
		edge_mask2 <= "0000";
		-- expects quad_mask="0000", because only (0,0,0) and (1,1,1) mean "inside triangle" situation
		wait for 1*clock_period;
		edge_ready<="111";
		wait for 2*clock_period;
		edge_ready<="000";
		wait for clock_period;
		
		edge_mask0 <= "1110";
		edge_mask1 <= "0100";
		edge_mask2 <= "0110";
		-- expects quad_mask="0101", because only (0,0,0) and (1,1,1) mean "inside triangle" situation
		wait for 1*clock_period;
		edge_ready<="111";
		wait for 2*clock_period;
		edge_ready<="000";
		wait for clock_period;
		
		edge_mask0 <= "0011";
		edge_mask1 <= "0110";
		edge_mask2 <= "0011";
		-- expects quad_mask="1010", because only (0,0,0) and (1,1,1) mean "inside triangle" situation
		wait for 1*clock_period;
		edge_ready<="111";
		wait for 2*clock_period;
		edge_ready<="000";
		wait for clock_period;
		
		edge_mask0 <= "1001";
		edge_mask1 <= "0011";
		edge_mask2 <= "1001";
		-- expects quad_mask="0101", because only (0,0,0) and (1,1,1) mean "inside triangle" situation
		wait for 1*clock_period;
		edge_ready<="111";
		wait for 2*clock_period;
		edge_ready<="000";
		wait for clock_period;
		
		edge_mask0 <= "1100";
		edge_mask1 <= "1001";
		edge_mask2 <= "1100";
		-- expects quad_mask="1010", because only (0,0,0) and (1,1,1) mean "inside triangle" situation
		wait for 1*clock_period;
		edge_ready<="111";
		wait for 2*clock_period;
		edge_ready<="000";
		wait for clock_period;
		
		wait;
	end process;
								
clock_process: process
	begin
		clock <= not clock;
		wait for clock_period/2;
	end process;
end ogpu_triangle_edge_test_tb1;