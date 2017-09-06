library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_raster_unit_testbench is
end ogpu_raster_unit_testbench;

architecture ogpu_raster_unit_testbench_tb1 of ogpu_raster_unit_testbench is
	constant clock_period : time := 20 ns;
	signal clock,reset	: std_logic :='0';
	--
	signal command:	std_logic_vector(7 downto 0):=(others =>'0');
	signal v0x,v0y,v0z:		std_logic_vector(15 downto 0);
	signal v1x,v1y,v1z:		std_logic_vector(15 downto 0);
	signal v2x,v2y,v2z:		std_logic_vector(15 downto 0);
	signal clip_rect0:			std_logic_vector(31 downto 0);
	signal clip_rect1:			std_logic_vector(31 downto 0);
	signal tile0:				std_logic_vector(31 downto 0);
	signal tile1:				std_logic_vector(31 downto 0);
	signal depth_coef_a:		std_logic_vector(31 downto 0);
	signal depth_coef_b:		std_logic_vector(31 downto 0);
	signal depth_coef_c:		std_logic_vector(31 downto 0);
	signal quad_buffer_addr:	std_logic_vector(63 downto 0);
	signal done:					std_logic := '0';
	signal busy: 				std_logic := '0';
	signal quad_buffer_length:			std_logic_vector(23 downto 0);
	--external buffer interface
	signal ext_buffer_ack:				std_logic := '0';
	signal ext_buffer_address:			std_logic_vector(15 downto 0);
	signal ext_buffer_byte_enable:		std_logic_vector(7 downto 0);
	signal ext_buffer_write:				std_logic := '0';
	signal ext_buffer_write_data:		std_logic_vector(63 downto 0);
	--
	signal dbg: std_logic_vector(11 downto 0);

begin

RU1:  entity work.ogpu_raster_unit(structure_1) port map(clock=>clock,
		  reset=>reset,
		  command=>command,
		  v0x=>v0x,v0y=>v0y,v0z=>v0z,
		  v1x=>v1x,v1y=>v1y,v1z=>v1z,
		  v2x=>v2x,v2y=>v2y,v2z=>v2z,
		  clip_rect0=>clip_rect0,
		  clip_rect1=>clip_rect1,
		  tile0=>tile0,
		  tile1=>tile1,
		  depth_coef_a=>depth_coef_a,
		  depth_coef_b=>depth_coef_b,
		  depth_coef_c=>depth_coef_c,
		  quad_buffer_addr=>quad_buffer_addr,
		  done=>done,
		  busy=>busy,
		  quad_buffer_length=>quad_buffer_length,
		  --external buffer interface
		  ext_buffer_ack=>ext_buffer_ack,
		  ext_buffer_address=>ext_buffer_address,
		  ext_buffer_byte_enable=>ext_buffer_byte_enable,
		  ext_buffer_write=>ext_buffer_write,
		  ext_buffer_write_data=>ext_buffer_write_data,
		  --debug interface
			dbg=>dbg);				

reset_proc: process
	begin
		reset <= '1';
		
		v0x<=std_logic_vector(to_unsigned(0,16));
		v0y<=std_logic_vector(to_unsigned(0,16));
		v0z<=std_logic_vector(to_unsigned(1,16));
		
		v1x<=std_logic_vector(to_unsigned(1000,16));
		v1y<=std_logic_vector(to_unsigned(0,16));
		v1z<=std_logic_vector(to_unsigned(1,16));
		
		v2x<=std_logic_vector(to_unsigned(0,16));
		v2y<=std_logic_vector(to_unsigned(1000,16));
		v2z<=std_logic_vector(to_unsigned(1,16));
		
		depth_coef_a<=(others => '0');
		depth_coef_b<=(others => '0');
		depth_coef_c<=(others => '0');
		quad_buffer_addr<=(others => '0');
		
		wait for 5*clock_period;
		reset <= '0';
		wait;
	end process;
	
ext_memory_proc: process
	begin
		wait until ext_buffer_write = '1';
		wait until falling_edge(clock);
		wait for 3*clock_period;
		ext_buffer_ack <= '1';
		wait for clock_period;
		ext_buffer_ack <= '0';
	end process;
	
stim_proc: process
	variable i:integer:=0;
	variable j:integer:=0;
	begin
		if reset = '1' then
			wait until reset = '0';
			wait for 1*clock_period;
		end if;
		
		clip_rect0(31 downto 16)<=std_logic_vector(to_unsigned(0,16)); -- x0
		clip_rect0(15 downto 0 )<=std_logic_vector(to_unsigned(0,16)); -- y0
		clip_rect1(31 downto 16)<=std_logic_vector(to_unsigned(10000,16)); -- x1
		clip_rect1(15 downto 0 )<=std_logic_vector(to_unsigned(10000,16)); -- y1
		
		tile0(31 downto 16)<=std_logic_vector(to_unsigned(0,16)); -- x0
		tile0(15 downto 0 )<=std_logic_vector(to_unsigned(0,16)); -- y0
		tile1(31 downto 16)<=std_logic_vector(to_unsigned(63,16)); -- x1
		tile1(15 downto 0 )<=std_logic_vector(to_unsigned(63,16)); -- y1
		
		command<=std_logic_vector(to_unsigned(16#AA#,8));
		
		wait until busy = '1';
		wait until done = '1';
		
		command<=std_logic_vector(to_unsigned(16#A5#,8));
		wait until done = '0';
		
		wait for 5*clock_period;
		
	end process;
								
clock_process: process
	begin
		clock <= not clock;
		wait for clock_period/2;
	end process;
end ogpu_raster_unit_testbench_tb1;