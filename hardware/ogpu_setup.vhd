library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_setup is
	port(clock: in std_logic;
		  reset: in std_logic;
		  vx0: in ogpu_float;
		  vy0: in ogpu_float;
		  vx1: in ogpu_float;
		  vy1: in ogpu_float;
		  vx2: in ogpu_float;
		  vy2: in ogpu_float;
		  start_raster: in std_logic;
		  setup_done: out std_logic :='0';
		  e0: out ogpu_edge;
		  e1: out ogpu_edge;
		  e2: out ogpu_edge);
end ogpu_setup;

architecture setup_1 of ogpu_setup is
begin
	process(clock)
	begin
		if clock'event and clock='1' then
			if reset='1' then
				setup_done<='0';
			else
				
			end if;
		end if;
	end process;
end setup_1;
