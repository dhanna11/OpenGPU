library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_quad_store is
	port(clock: in std_logic;
		  reset: in std_logic;
		  quad_mask: in std_logic_vector(0 to 3);
		  quad: in ogpu_quad;
		  depth_quad: in ogpu_depth_quad;
		  start_raster: in std_logic;
		  store_quad: in std_logic;
		  store_quad_data: out std_logic :='0';
		  quad_stored: out std_logic :='0';
		  quad_data: out ogpu_quad_data);
end ogpu_quad_store;

architecture quad_store_1 of ogpu_quad_store is
begin
	process(clock)
	begin
		if clock'event and clock='1' then
			if reset='1' then
				
			else
				
			end if;
		end if;
	end process;
end quad_store_1;
