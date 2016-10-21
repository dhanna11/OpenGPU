library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_depth_test is
	port(clock: in std_logic;
		  reset: in std_logic;
		  depth_coef: in ogpu_depth_coefficients;
		  quad: in ogpu_quad;
		  depth_test: in std_logic;
		  depth_ready: out std_logic :='0';
		  depth_quad: out ogpu_depth_quad);
end ogpu_depth_test;

architecture depth_test_1 of ogpu_depth_test is
begin
	process(clock)
	begin
		if clock'event and clock='1' then
			if reset='1' then
				
			else
				
			end if;
		end if;
	end process;
end depth_test_1;
