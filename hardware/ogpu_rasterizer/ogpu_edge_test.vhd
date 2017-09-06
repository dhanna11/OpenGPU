library ieee;
use ieee.std_logic_1164.all;
use work.ogpu_data_record_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ogpu_quad_edge_test is
	port(clock: in std_logic;
		  reset: in std_logic;
		  d: in ogpu_quad_edge_test_in_type;
		  q: out ogpu_quad_edge_test_out_type);
end ogpu_quad_edge_test;

architecture edge_test_1 of ogpu_quad_edge_test is
	function ogpu_edge_test_func (e: ogpu_edge;
										  x: unsigned(15 downto 0);
										  y: unsigned(15 downto 0))
							return std_logic is
--		variable xt,yt,x0t,y0t,x1t,y1t,r : signed(31 downto 0);
		variable xt,yt,x0t,y0t,x1t,y1t,i : integer;
		variable r : signed(31 downto 0);
	begin
--		xt := to_signed(to_integer(x),32);
--		yt := to_signed(to_integer(y),32);
--		x0t := to_signed(to_integer(e.x0),32);
--		y0t := to_signed(to_integer(e.y0),32);
--		x1t := to_signed(to_integer(e.x1),32);
--		y1t := to_signed(to_integer(e.y1),32);
		xt := to_integer(x);
		yt := to_integer(y);
		x0t := to_integer(e.x0);
		y0t := to_integer(e.y0);
		x1t := to_integer(e.x1);
		y1t := to_integer(e.y1);
		i := ((xt-x0t)*(y1t-y0t) - (x1t-x0t)*(yt-y0t));
		r := to_signed(i,32);
		if r >= 0 then 
			return '1';
		else
			return '0';
		end if;
	end ogpu_edge_test_func;

	type reg_type is record
		edge_test: std_logic;
		edge_ready:  std_logic;
		edge_mask:   std_logic_vector(0 to 3);
	end record;
	signal r,rin	:	reg_type;
begin
comb: process(reset,d,r)
	variable v : reg_type;
	begin
		v := r; --default assignment
		v.edge_test := d.edge_test;
		v.edge_ready := r.edge_test;
		
		v.edge_mask(0) := ogpu_edge_test_func(d.e,d.quad.x0,d.quad.y0);
		v.edge_mask(1) := ogpu_edge_test_func(d.e,d.quad.x1,d.quad.y1);
		v.edge_mask(2) := ogpu_edge_test_func(d.e,d.quad.x2,d.quad.y2);
		v.edge_mask(3) := ogpu_edge_test_func(d.e,d.quad.x3,d.quad.y3);
		
		
		
		if reset = '1' then
			v.edge_ready := '0';
			v.edge_mask := (others => '0');
		end if;
		
		rin <= v;		-- drive register inputs
		
		q.edge_ready <= r.edge_ready;  -- drive module outputs
		q.edge_mask <= v.edge_mask;
		
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then r <= rin; end if;
	end process;
end edge_test_1;

