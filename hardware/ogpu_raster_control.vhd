library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_raster_control is
	port(clock: in std_logic;
		  reset: in std_logic;
		  d: in ogpu_raster_control_in_type;
		  q: out ogpu_raster_control_out_type);
end ogpu_raster_control;

architecture raster_control_1 of ogpu_raster_control is
	type state_type is (
			OGPU_RASTER_CONTROL_IDLE,
			OGPU_RASTER_CONTROL_DONE,
			OGPU_RASTER_CONTROL_SETUP,
			OGPU_RASTER_CONTROL_QUAD_GEN,
			OGPU_RASTER_CONTROL_QUAD_TEST,
			OGPU_RASTER_CONTROL_STORE_QUAD);

	type reg_type is record
		setup_done: std_logic;
		end_tile: std_logic;
		quad_ready: std_logic;
		depth_ready: std_logic;
		quad_stored: std_logic;
		draw_quad: std_logic;
		discard_quad: std_logic;
		start_raster: std_logic;
		next_quad: std_logic;
		edge_test: std_logic;
		depth_test: std_logic;
		store_quad: std_logic;
		busy: std_logic;
		done: std_logic;
		
		state : state_type;
	end record;
	signal r,rin	:	reg_type;
begin
comb: process(reset,d,r)
	variable v : reg_type;
	begin
		v := r; --default assignment
		
		v.setup_done := d.setup_done;
		v.end_tile := d.end_tile;
		v.quad_ready := d.quad_ready;
		v.depth_ready := d.depth_ready;
		v.quad_stored := d.quad_stored;
		v.draw_quad := d.draw_quad;
		v.discard_quad := d.discard_quad;
		
		case r.state is
			when OGPU_RASTER_CONTROL_DONE =>
				if d.command = OGPU_CMD_PREPARE then
					v.state := OGPU_RASTER_CONTROL_IDLE;
					v.done := '0';
					v.busy := '0';
					v.start_raster := '0';
					v.next_quad := '0';
					v.edge_test := '0';
					v.depth_test := '0';
					v.store_quad := '0';
				end if;
				
			when OGPU_RASTER_CONTROL_SETUP =>
				if v.setup_done = '1' then
					v.state := OGPU_RASTER_CONTROL_QUAD_GEN;
					v.next_quad := '1';
					v.store_quad := '0';
					v.edge_test := '0';
					v.depth_test := '0';
				end if;
				
			when OGPU_RASTER_CONTROL_QUAD_GEN =>
				if v.quad_ready = '1' then
					v.state := OGPU_RASTER_CONTROL_QUAD_TEST;
					v.next_quad := '0';
					v.edge_test := '1';
					v.depth_test := '1';
				end if;
				if v.end_tile = '1' then
					v.state := OGPU_RASTER_CONTROL_DONE;
					v.done := '1';
					v.busy := '0';
					v.start_raster := '0';
					v.next_quad := '0';
					v.edge_test := '0';
					v.depth_test := '0';
					v.store_quad := '0';
				end if;
				
			when OGPU_RASTER_CONTROL_QUAD_TEST =>
				if (v.draw_quad and v.depth_ready) = '1' then
					v.state := OGPU_RASTER_CONTROL_STORE_QUAD;
					v.store_quad := '1';
				end if;
				if v.end_tile = '1' then
					v.state := OGPU_RASTER_CONTROL_DONE;
					v.done := '1';
					v.busy := '0';
					v.start_raster := '0';
					v.next_quad := '0';
					v.edge_test := '0';
					v.depth_test := '0';
					v.store_quad := '0';
				end if;
				if v.discard_quad = '1' then
					v.state := OGPU_RASTER_CONTROL_QUAD_GEN;
					v.next_quad := '1';
					v.store_quad := '0';
					v.edge_test := '0';
					v.depth_test := '0';
				end if;
				
			when OGPU_RASTER_CONTROL_STORE_QUAD =>
				if v.end_tile = '1' then
					v.state := OGPU_RASTER_CONTROL_DONE;
					v.done := '1';
					v.busy := '0';
					v.start_raster := '0';
					v.next_quad := '0';
					v.edge_test := '0';
					v.depth_test := '0';
					v.store_quad := '0';
				end if;
				if v.quad_stored = '1' then
					v.state := OGPU_RASTER_CONTROL_QUAD_GEN;
					v.next_quad := '1';
					v.store_quad := '0';
					v.edge_test := '0';
					v.depth_test := '0';
				end if;
				
			when others => -- including OGPU_RASTER_CONTROL_IDLE
				if d.command = OGPU_CMD_RASTER then
					v.state := OGPU_RASTER_CONTROL_SETUP;
					v.busy := '1';
					v.done := '0';
					v.start_raster := '1';
				end if;
		end case;

		if reset = '1' then
			v.start_raster := '0';
			v.next_quad := '0';
			v.edge_test := '0';
			v.depth_test := '0';
			v.store_quad := '0';
			v.busy := '0';
			v.done := '0';
			
			v.state := OGPU_RASTER_CONTROL_IDLE;
		end if;
		
		rin <= v;		-- drive register inputs
		
		-- drive module outputs
		q.start_raster <= v.start_raster;
		q.next_quad 	<= v.next_quad;
		q.edge_test 	<= v.edge_test;
		q.depth_test 	<= v.depth_test;
		q.store_quad 	<= v.store_quad;
		q.busy 			<= v.busy;
		q.done 			<= v.done;
		
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then r <= rin; end if;
	end process;
end raster_control_1;