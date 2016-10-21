library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_quad_buffer is
	port(clock: in std_logic;
		  reset: in std_logic;
		  store: in std_logic;
		  addr: in std_logic_vector(63 downto 0);
		  data: in ogpu_quad_data);
end ogpu_quad_buffer;

architecture test of ogpu_quad_buffer is
begin
	process(clock)
	begin
		if clock'event and clock='1' then
			if reset='1' then
				
			else
				
			end if;
		end if;
	end process;
end test;