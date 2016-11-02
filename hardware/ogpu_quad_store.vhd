library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_quad_store is
	port(clock: in std_logic;
		  reset: in std_logic;
		  d: in ogpu_quad_store_in_type;
		  q: out ogpu_quad_store_out_type);
end ogpu_quad_store;

architecture quad_store_1 of ogpu_quad_store is
	type reg_type is record
		start_raster: std_logic;
		store_quad: std_logic;
		store_quad_data: std_logic;
		quad_stored: std_logic;
		quad_data: ogpu_quad_data;
	end record;
	signal r,rin	:	reg_type;
begin
comb: process(reset,d,r)
	variable v : reg_type;
	begin
		v := r; --default assignment
		
		v.start_raster := d.start_raster;
		v.store_quad := d.store_quad;
		
		v.quad_data.x0 := d.quad.x0;
		v.quad_data.y0 := d.quad.y0;
		v.quad_data.mask := d.quad_mask;
		v.quad_data.depth := d.depth_quad;
		
		if v.store_quad = '1' then
			v.store_quad_data := '1';
			v.quad_stored := '1';
		end if;
		
		if reset = '1' then
			v.quad_stored := '0';
			v.store_quad_data := '0';
		end if;
		
		rin <= v;		-- drive register inputs
		
		q.quad_stored <= v.quad_stored;  -- drive module outputs
		q.store_quad_data <= v.store_quad_data;
		q.quad_data <= v.quad_data;
		
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then r <= rin; end if;
	end process;
end quad_store_1;
