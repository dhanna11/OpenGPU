library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_raster_control is
	port(clock: in std_logic;
		  reset: in std_logic;
		  command: in unsigned(31 downto 0);
		  setup_done: in std_logic;
		  end_tile: in std_logic;
		  quad_ready: in std_logic;
		  depth_ready: in std_logic;
		  quad_stored: in std_logic;
		  draw_quad: in std_logic;
		  discard_quad: in std_logic;
		  start_raster: out std_logic :='0';
		  next_quad: out std_logic :='0';
		  edge_test: out std_logic :='0';
		  depth_test: out std_logic :='0';
		  store_quad: out std_logic :='0';
		  busy: out std_logic :='0';
		  done: out std_logic :='0');
end ogpu_raster_control;

architecture raster_control_1 of ogpu_raster_control is
begin
	process(clock)
	begin
		if clock'event and clock='1' then
			if reset='1' then
				
			else
				
			end if;
		end if;
	end process;
end raster_control_1;