library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_triangle_edge_test is
	port(clock: in std_logic;
		  reset: in std_logic;
		  edge_ready: in std_logic_vector(0 to 2);
		  edge_mask0: in std_logic_vector(0 to 3);
		  edge_mask1: in std_logic_vector(0 to 3);
		  edge_mask2: in std_logic_vector(0 to 3);
		  draw_quad: out std_logic :='0';
		  discard_quad: out std_logic :='0';
		  quad_mask: out std_logic_vector(0 to 3));
end ogpu_triangle_edge_test;

architecture triangle_test_1 of ogpu_triangle_edge_test is
begin
	process(clock)
	begin
		if clock'event and clock='1' then
			if reset='1' then
				
			else
				
			end if;
		end if;
	end process;
end triangle_test_1;
