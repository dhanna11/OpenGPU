library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_quad_generator is
	port(clock: in std_logic;
		  reset: in std_logic;
		  clip_rect: in ogpu_box;
		  tile: in ogpu_tile;
		  next_quad: in std_logic;
		  end_tile: out std_logic :='0';
		  quad_ready: out std_logic :='0';
		  quad: out ogpu_quad);
end ogpu_quad_generator;

architecture generator_1 of ogpu_quad_generator is
begin
	process(clock)
	begin
		if clock'event and clock='1' then
			if reset='1' then
				
			else
				
			end if;
		end if;
	end process;
end generator_1;