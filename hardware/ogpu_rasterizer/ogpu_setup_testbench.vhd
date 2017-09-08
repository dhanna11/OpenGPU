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

-- OpenGPU Testbench --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_setup_testbench is
end ogpu_setup_testbench;

architecture ogpu_setup_tb1 of ogpu_setup_testbench is
	constant clock_period : time := 20 ns;
	signal clock,reset	: std_logic :='0';
	--
	signal vx0: ogpu_float;
	signal vy0: ogpu_float;
	signal vx1: ogpu_float;
	signal vy1: ogpu_float;
	signal vx2: ogpu_float;
	signal vy2: ogpu_float;
	signal e0: ogpu_edge;
	signal e1: ogpu_edge;
	signal e2: ogpu_edge;
	-- DATAPATH/CONTROL interface signals
	signal start_raster: std_logic;
	signal setup_done: std_logic;
begin
ST1:  entity work.ogpu_setup(setup_1) port map(
								-- IN
								clock=>clock,reset=>reset,
								d.vx0=>vx0,d.vy0=>vy0,
								d.vx1=>vx1,d.vy1=>vy1,
								d.vx2=>vx2,d.vy2=>vy2,
								d.start_raster=>start_raster,
								-- OUT
								q.setup_done=>setup_done,
								q.e0=>e0,q.e1=>e1,q.e2=>e2);

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
		start_raster <= '1';
		wait for 4*clock_period;
		start_raster <= '0';
		wait for 4*clock_period;
	end process;
	
stim_proc2: process
	variable i:integer:=1;
	begin
		vx0.int <= to_unsigned(1*i,16); vy0.int <= to_unsigned(1*i,16);
		vx1.int <= to_unsigned(6*i,16); vy1.int <= to_unsigned(2*i,16);
		vx2.int <= to_unsigned(2*i,16); vy2.int <= to_unsigned(5*i,16);
		wait for 6*clock_period;
		i:=i+1;
		if i>10 then i:=0; end if;
	end process;
	
clock_process: process
	begin
		clock <= not clock;
		wait for clock_period/2;
	end process;
end ogpu_setup_tb1;