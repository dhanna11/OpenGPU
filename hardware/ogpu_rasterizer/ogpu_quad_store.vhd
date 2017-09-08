-- Copyright 2017 Fabricio Ribeiro Toloczko 

-- OpenGPU

-- -- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     http://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ogpu_data_record_pkg.all;

entity ogpu_quad_store is
	port(clock: in std_logic;
		  reset: in std_logic;
		  d: in ogpu_quad_store_in_type;
		  q: out ogpu_quad_store_out_type);
end ogpu_quad_store;

architecture quad_store_1 of ogpu_quad_store is
	--first implementation: without passing depth_quad
	-- packet size: 64 bits
	-- 63: X(16) (Big endian) | 47: Y(16) (Big endian) | 31: quad_mask(4) | 27~0: reserved(28)
	type reg_type is record
		start_raster: std_logic;
		store_quad: std_logic;
		buffer_ack: std_logic;
		buffer_ready: std_logic;
		
		quad_stored: std_logic;
		quad_buffer_length: unsigned(23 downto 0);
		buffer_address: std_logic_vector(15 downto 0);
		buffer_byte_enable: std_logic_vector(7 downto 0);
		buffer_write: std_logic;
		buffer_write_data: std_logic_vector(63 downto 0);
		
		buffer_pointer: unsigned(15 downto 0);
	end record;
	signal r,rin	:	reg_type;
begin
comb: process(reset,d,r)
	variable v : reg_type;
	begin
		v := r; --default assignment
		v.start_raster := d.start_raster;
		v.store_quad := d.store_quad;
		v.buffer_ack := d.buffer_ack;
		
		if d.buffer_ack = '1' and r.buffer_ack = '0' then
			v.buffer_write := '0';
		end if;
		
		if d.buffer_ack = '0' and r.buffer_ack = '1' then
			v.quad_stored := '1';
		end if;
		
		if r.quad_stored = '1' then
			v.quad_stored := '0';
		end if;
		
		if d.store_quad = '0' and r.store_quad = '1' then
			v.buffer_ready := '1';
		end if;
		
		if r.store_quad = '1' and r.start_raster = '1' and r.buffer_ready = '1' then
			v.buffer_ready := '0';
			v.buffer_address := std_logic_vector(r.buffer_pointer); -- get anterior to improve speed without calculating +1 in same clock
			v.buffer_write_data(63 downto 48) := std_logic_vector(d.quad.x0);
			v.buffer_write_data(47 downto 32) := std_logic_vector(d.quad.y0);
			v.buffer_write_data(27 downto 4) := (others => '0'); -- reserved = 0
			v.buffer_write_data(3) := d.quad_mask(3);
			v.buffer_write_data(2) := d.quad_mask(2);
			v.buffer_write_data(1) := d.quad_mask(1);
			v.buffer_write_data(0) := d.quad_mask(0);
			v.buffer_write := '1';
			v.buffer_byte_enable := "11111111";
			
			v.quad_buffer_length:=r.quad_buffer_length+1; -- TODO restrict to buffer's limit size
			v.buffer_pointer:=r.buffer_pointer+8; -- 8 bytes for each memory word
		end if;
		
		if r.start_raster = '0' then
			v.buffer_pointer := (others => '0');
			v.buffer_address := (others => '0');  -- drive module outputs
			v.buffer_byte_enable := (others => '0');
			v.buffer_write := '0';
			v.quad_buffer_length := (others => '0');
			v.quad_stored := '0';
			v.buffer_ready := '1';
		end if;
		
		if reset = '1' then
			v.buffer_pointer := (others => '0');
			v.buffer_address := (others => '0');  -- drive module outputs
			v.buffer_byte_enable := (others => '0');
			v.buffer_write := '0';
			v.buffer_write_data := (others => '0');
			v.quad_buffer_length := (others => '0');
			v.start_raster := '0';
			v.store_quad := '0';
			v.quad_stored := '0';
			v.buffer_ack := '0';
			v.buffer_ready := '1';
		end if;
		
		rin <= v;		-- drive register inputs
		q.buffer_address <= v.buffer_address;  -- drive module outputs
		q.buffer_byte_enable <= v.buffer_byte_enable;
		q.buffer_write <= r.buffer_write;
		q.buffer_write_data <= v.buffer_write_data;
		q.quad_buffer_length <= std_logic_vector(v.quad_buffer_length);
		q.quad_stored <= r.quad_stored;
		
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then r <= rin; end if;
	end process;
end quad_store_1;

architecture quad_store_2 of ogpu_quad_store is
	--first implementation: without passing depth_quad
	-- packet size: 64 bits
	-- 63: X(16) (Big endian) | 47: Y(16) (Big endian) | 31: quad_mask(4) | 27~0: reserved(28)
	type reg_type is record
		start_raster: std_logic;
		store_quad: std_logic;
		buffer_ack: std_logic;
		buffer_ready: std_logic;
		
		quad_stored: std_logic;
		quad_buffer_length: unsigned(23 downto 0);
		buffer_address: std_logic_vector(15 downto 0);
		buffer_byte_enable: std_logic_vector(7 downto 0);
		buffer_write: std_logic;
		buffer_write_data: std_logic_vector(63 downto 0);
		
		buffer_pointer: unsigned(15 downto 0);
	end record;
	signal r,rin	:	reg_type;
begin
comb: process(reset,d,r)
	variable v : reg_type;
	begin
		v := r; --default assignment
		v.start_raster := d.start_raster;
		v.store_quad := d.store_quad;
		v.buffer_ack := d.buffer_ack;
		
		if reset = '1' then
			v.buffer_pointer := (others => '0');
			v.buffer_address := (others => '0');  -- drive module outputs
			v.buffer_byte_enable := (others => '0');
			v.buffer_write := '0';
			v.buffer_write_data := (others => '0');
			v.quad_buffer_length := (others => '0');
			v.start_raster := '0';
			v.store_quad := '0';
			v.quad_stored := '0';
			v.buffer_ack := '0';
			v.buffer_ready := '1';
		else
			if r.start_raster = '1' then
				if d.store_quad = '1' and r.store_quad = '0' and v.buffer_ready = '1' then
					v.buffer_ready := '0';
					v.buffer_address := std_logic_vector(r.buffer_pointer); -- get anterior to improve speed without calculating +1 in same clock
					v.buffer_write_data(63 downto 48) := std_logic_vector(d.quad.x0);
					v.buffer_write_data(47 downto 32) := std_logic_vector(d.quad.y0);
					v.buffer_write_data(31) := d.quad_mask(3);
					v.buffer_write_data(30) := d.quad_mask(2);
					v.buffer_write_data(29) := d.quad_mask(1);
					v.buffer_write_data(28) := d.quad_mask(0);
					v.buffer_write_data(27 downto 0) := (others => '1'); -- reserved = 0
					v.buffer_write := '1';
					v.buffer_byte_enable := "11111111";
					
					v.quad_buffer_length:=r.quad_buffer_length+1; -- TODO restrict to buffer's limit size
					v.buffer_pointer:=r.buffer_pointer+8; -- 8 bytes for each memory word
					
					--v.quad_stored := '1'; -- remove comment to bypass external memory control(buffer_ack signal)
				elsif d.store_quad = '0' then
					v.quad_stored := '0';
					v.buffer_write := '0';
				end if;
			else
				if d.start_raster = '1' then
					v.quad_buffer_length := (others=>'0');
					v.buffer_pointer := (others => '0');
				end if;
				v.quad_stored := '0';
				v.buffer_write := '0';
				v.buffer_ready := '1';
			end if;
		end if;
		
		if d.buffer_ack = '1' then
			v.buffer_ready := '1';
			v.buffer_write := '0';
			v.quad_stored := '1';
			v.buffer_byte_enable := "00000000";
		end if;
		
		rin <= v;		-- drive register inputs
		q.buffer_address <= v.buffer_address;  -- drive module outputs
		q.buffer_byte_enable <= v.buffer_byte_enable;
		q.buffer_write <= r.buffer_write;
		q.buffer_write_data <= v.buffer_write_data;
		q.quad_buffer_length <= std_logic_vector(v.quad_buffer_length);
		q.quad_stored <= r.quad_stored;
		
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then r <= rin; end if;
	end process;
end quad_store_2;

architecture test_1 of ogpu_quad_store is
	-- test implementation for writing in external buffer
	type reg_type is record
		start_raster: std_logic;
		store_quad: std_logic;
		buffer_ack: std_logic;
		
		quad_stored: std_logic;
		quad_buffer_length: unsigned(23 downto 0);
		buffer_address: std_logic_vector(15 downto 0);
		buffer_byte_enable: std_logic_vector(7 downto 0);
		buffer_write: std_logic;
		buffer_write_data: std_logic_vector(63 downto 0);
		
		buffer_pointer: unsigned(15 downto 0);
	end record;
	signal r,rin	:	reg_type;
begin
comb: process(reset,d,r)
	variable v : reg_type;
	begin
		v := r; --default assignment
		v.start_raster := d.start_raster;
		v.store_quad := d.store_quad;
		v.buffer_ack := d.buffer_ack;
		
		v.quad_stored := '1';
		
		if reset = '1' then
			v.buffer_pointer := (others => '0');
			v.buffer_address := (others => '0');
			v.buffer_byte_enable := (others => '0');
			v.buffer_write := '0';
			v.buffer_write_data := (others => '0');
			v.quad_buffer_length := (others => '0');
			v.start_raster := '0';
			v.store_quad := '0';
			v.quad_stored := '0';
			v.buffer_ack := '0';
		elsif d.buffer_ack = '0' then
			v.buffer_address := std_logic_vector(r.buffer_pointer); -- get anterior to improve speed without calculating +1 in same clock
			v.buffer_write_data(63 downto 32) := (others => '1');
			v.buffer_write_data(31 downto 16) := (others => '0');
			v.buffer_write_data(15 downto 0) := std_logic_vector(r.buffer_pointer);
			v.buffer_write := '1';
			v.buffer_byte_enable := "11111111";
			
			v.quad_buffer_length:=r.quad_buffer_length+1;
			v.buffer_pointer:=v.buffer_pointer+8; -- 8 bytes for each memory word
			
			v.quad_stored:='1';
		else
			v.buffer_write := '0';
		end if;
		
		if d.buffer_ack = '1' then
			v.buffer_write := '0';
			v.quad_stored := '1';
			v.buffer_byte_enable := "00000000";
		end if;
		
		rin <= v;		-- drive register inputs
		q.buffer_address <= v.buffer_address;  -- drive module outputs
		q.buffer_byte_enable <= v.buffer_byte_enable;
		q.buffer_write <= v.buffer_write;
		q.buffer_write_data <= v.buffer_write_data;
		q.quad_buffer_length <= std_logic_vector(v.quad_buffer_length);
		q.quad_stored <= r.quad_stored;
		
	end process;
	
seq: process(clock)
	begin
		if rising_edge(clock) then r <= rin; end if;
	end process;
end test_1;
