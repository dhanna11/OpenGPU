library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_quad_edge_test is
	port(clock: in std_logic;
		  reset: in std_logic;
		  edge_test: in std_logic;
		  quad: in ogpu_quad;
		  edge: in ogpu_edge;
		  edge_ready: out std_logic :='0';
		  edge_mask: out std_logic_vector(0 to 3));
end ogpu_quad_edge_test;

architecture edge_test_1 of ogpu_quad_edge_test is
begin
	process(clock)
	begin
		if clock'event and clock='1' then
			if reset='1' then
				
			else
				
			end if;
		end if;
	end process;
end edge_test_1;