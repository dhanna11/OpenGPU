library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_quad_buffer is
	port(clock: in std_logic;
		  reset: in std_logic;
		  d: in ogpu_quad_buffer_in_type);
		  --q: out ogpu_quad_buffer_out_type);
end ogpu_quad_buffer;

architecture test of ogpu_quad_buffer is
	type reg_type is record
		store: std_logic;
		addr: std_logic_vector(63 downto 0);
		data: ogpu_quad_data;
	end record;
	signal r,rin	:	reg_type;
begin
warn: process
	begin
		report "CAUTION: Using ogpu_quad_buffer TEST architecture implementation" severity warning;
		wait;
	end process;

comb: process(reset,d,r)
	variable v : reg_type;
	begin
		v := r; --default assignment
		
		if reset = '1' then
		end if;
		
		rin <= v;		-- drive register inputs
		
		  -- drive module outputs
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then r <= rin; end if;
	end process;
end test;