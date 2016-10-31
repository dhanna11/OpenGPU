-- OpenGPU Testbench --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_testbench is
end ogpu_testbench;

architecture ogpu_raster_unit_tb1 of ogpu_testbench is
begin
end ogpu_raster_unit_tb1;

architecture ogpu_setup_tb1 of ogpu_testbench is
	constant clock_period : time := 20 ns;
	signal clock,reset	: std_logic :='0';
	--
	signal quad			: ogpu_quad	:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'),x2=>(others=>'0'),y2=>(others=>'0'),x3=>(others=>'0'),y3=>(others=>'0'));
	signal tile			: ogpu_tile	:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'));
	signal clip_rect	: ogpu_box	:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'));
	-- DATAPATH/CONTROL interface signals
	signal next_quad:			std_logic:='0';
	signal quad_ready:		std_logic:='0';
	signal end_tile: 			std_logic:='0';
begin
QG1:  entity work.ogpu_quad_generator(generator_1) port map(
								-- IN
								clock=>clock,reset=>reset,
								d.clip_rect=>clip_rect,d.tile=>tile,d.next_quad=>next_quad,
								-- OUT
								q.end_tile=>end_tile,q.quad_ready=>quad_ready,
								q.quad=>quad);
								

reset_proc: process
	begin
		--reset <= '0';
		--wait for 5*clock_period;
		reset <= '1';
		wait for 5*clock_period;
		reset <= '0';
		wait;
	end process;
	
init_proc: process
	begin
		--wait for 5*clock_period;
		tile.x0 <= to_unsigned(0,16);		tile.y0 <= to_unsigned(0,16);
		tile.x1 <= to_unsigned(62,16);	tile.y1 <= to_unsigned(62,16);
		clip_rect.x0 <= to_unsigned(0,16);		clip_rect.y0 <= to_unsigned(0,16);
		clip_rect.x1 <= to_unsigned(128,16);		clip_rect.y1 <= to_unsigned(128,16);
		wait;
	end process;
	
stim_proc: process
	begin
		next_quad <= '1';
		wait until quad_ready = '1';
		next_quad <= '0';
		wait for clock_period;
	end process;
								
clock_process: process
	begin
		clock <= not clock;
		wait for clock_period/2;
	end process;
end ogpu_setup_tb1;

architecture ogpu_quad_generator_tb1 of ogpu_testbench is
	constant clock_period : time := 20 ns;
	signal clock,reset	: std_logic :='0';
	--
	signal quad			: ogpu_quad	:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'),x2=>(others=>'0'),y2=>(others=>'0'),x3=>(others=>'0'),y3=>(others=>'0'));
	signal tile			: ogpu_tile	:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'));
	signal clip_rect	: ogpu_box	:=(x0=>(others=>'0'),y0=>(others=>'0'),x1=>(others=>'0'),y1=>(others=>'0'));
	-- DATAPATH/CONTROL interface signals
	signal next_quad:			std_logic:='0';
	signal quad_ready:		std_logic:='0';
	signal end_tile: 			std_logic:='0';
begin
QG1:  entity work.ogpu_quad_generator(generator_1) port map(
								-- IN
								clock=>clock,reset=>reset,
								d.clip_rect=>clip_rect,d.tile=>tile,d.next_quad=>next_quad,
								-- OUT
								q.end_tile=>end_tile,q.quad_ready=>quad_ready,
								q.quad=>quad);
								

reset_proc: process
	begin
		--reset <= '0';
		--wait for 5*clock_period;
		reset <= '1';
		wait for 5*clock_period;
		reset <= '0';
		wait;
	end process;
	
init_proc: process
	begin
		--wait for 5*clock_period;
		tile.x0 <= to_unsigned(0,16);		tile.y0 <= to_unsigned(0,16);
		tile.x1 <= to_unsigned(62,16);	tile.y1 <= to_unsigned(62,16);
		clip_rect.x0 <= to_unsigned(0,16);		clip_rect.y0 <= to_unsigned(0,16);
		clip_rect.x1 <= to_unsigned(128,16);		clip_rect.y1 <= to_unsigned(128,16);
		wait;
	end process;
	
stim_proc: process
	begin
		next_quad <= '1';
		wait until quad_ready = '1';
		next_quad <= '0';
		wait for clock_period;
	end process;
								
clock_process: process
	begin
		clock <= not clock;
		wait for clock_period/2;
	end process;
end ogpu_quad_generator_tb1;