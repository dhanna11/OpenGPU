-- Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Altera and sold by Altera or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 16.0.2 Build 222 07/20/2016 SJ Lite Edition"

-- DATE "12/05/2016 10:40:36"

-- 
-- Device: Altera 5CSEMA5F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	ogpu_quad_generator IS
    PORT (
	clock : IN std_logic;
	reset : IN std_logic;
	\d.next_quad\ : IN std_logic;
	\d.tile.y1\ : IN std_logic_vector(15 DOWNTO 0);
	\d.tile.x1\ : IN std_logic_vector(15 DOWNTO 0);
	\d.tile.y0\ : IN std_logic_vector(15 DOWNTO 0);
	\d.tile.x0\ : IN std_logic_vector(15 DOWNTO 0);
	\d.clip_rect.y1\ : IN std_logic_vector(15 DOWNTO 0);
	\d.clip_rect.x1\ : IN std_logic_vector(15 DOWNTO 0);
	\d.clip_rect.y0\ : IN std_logic_vector(15 DOWNTO 0);
	\d.clip_rect.x0\ : IN std_logic_vector(15 DOWNTO 0);
	\q.quad.y3\ : OUT std_logic_vector(15 DOWNTO 0);
	\q.quad.x3\ : OUT std_logic_vector(15 DOWNTO 0);
	\q.quad.y2\ : OUT std_logic_vector(15 DOWNTO 0);
	\q.quad.x2\ : OUT std_logic_vector(15 DOWNTO 0);
	\q.quad.y1\ : OUT std_logic_vector(15 DOWNTO 0);
	\q.quad.x1\ : OUT std_logic_vector(15 DOWNTO 0);
	\q.quad.y0\ : OUT std_logic_vector(15 DOWNTO 0);
	\q.quad.x0\ : OUT std_logic_vector(15 DOWNTO 0);
	\q.quad_ready\ : OUT std_logic;
	\q.end_tile\ : OUT std_logic
	);
END ogpu_quad_generator;

-- Design Ports Information
-- q.quad.y3[0]	=>  Location: PIN_J10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[1]	=>  Location: PIN_AG5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[2]	=>  Location: PIN_E1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[3]	=>  Location: PIN_AH5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[4]	=>  Location: PIN_AH13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[5]	=>  Location: PIN_C4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[6]	=>  Location: PIN_AJ27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[7]	=>  Location: PIN_AJ11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[8]	=>  Location: PIN_AG10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[9]	=>  Location: PIN_AH2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[10]	=>  Location: PIN_C9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[11]	=>  Location: PIN_AF4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[12]	=>  Location: PIN_AK3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[13]	=>  Location: PIN_AA30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[14]	=>  Location: PIN_AG8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y3[15]	=>  Location: PIN_K12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[0]	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[1]	=>  Location: PIN_V25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[2]	=>  Location: PIN_AD7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[3]	=>  Location: PIN_V16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[4]	=>  Location: PIN_AC12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[5]	=>  Location: PIN_AH27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[6]	=>  Location: PIN_E13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[7]	=>  Location: PIN_D2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[8]	=>  Location: PIN_AF15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[9]	=>  Location: PIN_AG27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[10]	=>  Location: PIN_AD21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[11]	=>  Location: PIN_AB21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[12]	=>  Location: PIN_AJ9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[13]	=>  Location: PIN_AA28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[14]	=>  Location: PIN_AC25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x3[15]	=>  Location: PIN_D10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[0]	=>  Location: PIN_A3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[1]	=>  Location: PIN_AJ1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[2]	=>  Location: PIN_K7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[3]	=>  Location: PIN_AA12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[4]	=>  Location: PIN_AE13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[5]	=>  Location: PIN_E11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[6]	=>  Location: PIN_Y19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[7]	=>  Location: PIN_E8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[8]	=>  Location: PIN_AG11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[9]	=>  Location: PIN_AF9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[10]	=>  Location: PIN_C10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[11]	=>  Location: PIN_AF6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[12]	=>  Location: PIN_AK2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[13]	=>  Location: PIN_AH30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[14]	=>  Location: PIN_AG1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y2[15]	=>  Location: PIN_K8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[0]	=>  Location: PIN_AF25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[1]	=>  Location: PIN_A5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[2]	=>  Location: PIN_AH14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[3]	=>  Location: PIN_E7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[4]	=>  Location: PIN_D11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[5]	=>  Location: PIN_B5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[6]	=>  Location: PIN_AJ4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[7]	=>  Location: PIN_J7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[8]	=>  Location: PIN_AD12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[9]	=>  Location: PIN_AJ10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[10]	=>  Location: PIN_C8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[11]	=>  Location: PIN_AJ6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[12]	=>  Location: PIN_AH19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[13]	=>  Location: PIN_Y26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[14]	=>  Location: PIN_AH7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x2[15]	=>  Location: PIN_H15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[0]	=>  Location: PIN_AD11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[1]	=>  Location: PIN_AG6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[2]	=>  Location: PIN_E6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[3]	=>  Location: PIN_AG7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[4]	=>  Location: PIN_AJ7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[5]	=>  Location: PIN_F13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[6]	=>  Location: PIN_AC22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[7]	=>  Location: PIN_D7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[8]	=>  Location: PIN_AD14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[9]	=>  Location: PIN_AE7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[10]	=>  Location: PIN_C5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[11]	=>  Location: PIN_AC9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[12]	=>  Location: PIN_AB13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[13]	=>  Location: PIN_AC29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[14]	=>  Location: PIN_AG2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y1[15]	=>  Location: PIN_C2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[0]	=>  Location: PIN_A4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[1]	=>  Location: PIN_AC28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[2]	=>  Location: PIN_AH4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[3]	=>  Location: PIN_AG17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[4]	=>  Location: PIN_AF11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[5]	=>  Location: PIN_AA21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[6]	=>  Location: PIN_J14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[7]	=>  Location: PIN_H7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[8]	=>  Location: PIN_AA13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[9]	=>  Location: PIN_AH28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[10]	=>  Location: PIN_AA20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[11]	=>  Location: PIN_AE24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[12]	=>  Location: PIN_AK7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[13]	=>  Location: PIN_AB30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[14]	=>  Location: PIN_AD25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x1[15]	=>  Location: PIN_K14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[0]	=>  Location: PIN_J9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[1]	=>  Location: PIN_AK6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[2]	=>  Location: PIN_F6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[3]	=>  Location: PIN_AJ2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[4]	=>  Location: PIN_AG12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[5]	=>  Location: PIN_A6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[6]	=>  Location: PIN_AF26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[7]	=>  Location: PIN_AB15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[8]	=>  Location: PIN_AF13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[9]	=>  Location: PIN_AF8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[10]	=>  Location: PIN_H8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[11]	=>  Location: PIN_AE11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[12]	=>  Location: PIN_AJ5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[13]	=>  Location: PIN_W25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[14]	=>  Location: PIN_AB12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.y0[15]	=>  Location: PIN_H13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[0]	=>  Location: PIN_AC23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[1]	=>  Location: PIN_D5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[2]	=>  Location: PIN_AK9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[3]	=>  Location: PIN_E3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[4]	=>  Location: PIN_B7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[5]	=>  Location: PIN_C3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[6]	=>  Location: PIN_AE14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[7]	=>  Location: PIN_D6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[8]	=>  Location: PIN_AG13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[9]	=>  Location: PIN_AK11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[10]	=>  Location: PIN_Y27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[11]	=>  Location: PIN_AC14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[12]	=>  Location: PIN_AJ17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[13]	=>  Location: PIN_A8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[14]	=>  Location: PIN_AK4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad.x0[15]	=>  Location: PIN_A11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.quad_ready	=>  Location: PIN_AC27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q.end_tile	=>  Location: PIN_AK26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[1]	=>  Location: PIN_AH10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[1]	=>  Location: PIN_AF29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[15]	=>  Location: PIN_AH8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[15]	=>  Location: PIN_W16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[11]	=>  Location: PIN_AF28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[11]	=>  Location: PIN_W24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[14]	=>  Location: PIN_AB28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[14]	=>  Location: PIN_AE12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[13]	=>  Location: PIN_AE26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[13]	=>  Location: PIN_E9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[12]	=>  Location: PIN_AD19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[12]	=>  Location: PIN_G15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[10]	=>  Location: PIN_G13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[10]	=>  Location: PIN_D4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[9]	=>  Location: PIN_AB25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[9]	=>  Location: PIN_B12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[8]	=>  Location: PIN_AA24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[8]	=>  Location: PIN_Y24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[3]	=>  Location: PIN_AH9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[3]	=>  Location: PIN_AF5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[2]	=>  Location: PIN_AK13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[2]	=>  Location: PIN_B1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[0]	=>  Location: PIN_W15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[0]	=>  Location: PIN_H14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[5]	=>  Location: PIN_AE28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[5]	=>  Location: PIN_AK14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[7]	=>  Location: PIN_AA26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[7]	=>  Location: PIN_AJ14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[6]	=>  Location: PIN_AG15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[6]	=>  Location: PIN_AG30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y0[4]	=>  Location: PIN_AJ12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y0[4]	=>  Location: PIN_AA15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[15]	=>  Location: PIN_AA16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[15]	=>  Location: PIN_AG20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[4]	=>  Location: PIN_AK29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[4]	=>  Location: PIN_AH24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[7]	=>  Location: PIN_AC20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[7]	=>  Location: PIN_AH22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[6]	=>  Location: PIN_AH29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[6]	=>  Location: PIN_AD17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[5]	=>  Location: PIN_W22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[5]	=>  Location: PIN_AF20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[1]	=>  Location: PIN_AB23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[1]	=>  Location: PIN_V18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[0]	=>  Location: PIN_W21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[0]	=>  Location: PIN_Y16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[3]	=>  Location: PIN_AJ26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[3]	=>  Location: PIN_AK18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[2]	=>  Location: PIN_AA19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[2]	=>  Location: PIN_AG21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[14]	=>  Location: PIN_B8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[14]	=>  Location: PIN_AH18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[13]	=>  Location: PIN_Y21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[13]	=>  Location: PIN_AJ19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[12]	=>  Location: PIN_AG18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[12]	=>  Location: PIN_AG16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[11]	=>  Location: PIN_AH20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[11]	=>  Location: PIN_W17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[9]	=>  Location: PIN_AK21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[9]	=>  Location: PIN_AG23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[10]	=>  Location: PIN_D9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[10]	=>  Location: PIN_AF19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x1[8]	=>  Location: PIN_AF23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x0[8]	=>  Location: PIN_AC18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[15]	=>  Location: PIN_AJ20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[15]	=>  Location: PIN_Y17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[4]	=>  Location: PIN_AD20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[4]	=>  Location: PIN_C7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[7]	=>  Location: PIN_AJ22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[7]	=>  Location: PIN_AH23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[6]	=>  Location: PIN_AF14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[6]	=>  Location: PIN_AJ24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[5]	=>  Location: PIN_AF21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[5]	=>  Location: PIN_AF24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[1]	=>  Location: PIN_AF16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[1]	=>  Location: PIN_AD27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[0]	=>  Location: PIN_W19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[0]	=>  Location: PIN_W20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[3]	=>  Location: PIN_AE16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[3]	=>  Location: PIN_AK23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[2]	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[2]	=>  Location: PIN_AJ29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[14]	=>  Location: PIN_AB17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[14]	=>  Location: PIN_AK12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[13]	=>  Location: PIN_AE17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[13]	=>  Location: PIN_AE23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[12]	=>  Location: PIN_AH17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[12]	=>  Location: PIN_AK19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[11]	=>  Location: PIN_V17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[11]	=>  Location: PIN_AJ25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[9]	=>  Location: PIN_AJ21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[9]	=>  Location: PIN_AA18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[10]	=>  Location: PIN_AE18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[10]	=>  Location: PIN_AG22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.x0[8]	=>  Location: PIN_AE19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.x1[8]	=>  Location: PIN_AK22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[15]	=>  Location: PIN_AH25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[4]	=>  Location: PIN_AF30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[7]	=>  Location: PIN_C13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[6]	=>  Location: PIN_AE27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[5]	=>  Location: PIN_A10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[1]	=>  Location: PIN_AK16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[0]	=>  Location: PIN_F11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[3]	=>  Location: PIN_AA14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[2]	=>  Location: PIN_AH15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[14]	=>  Location: PIN_AK24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[13]	=>  Location: PIN_AK27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[12]	=>  Location: PIN_B11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[11]	=>  Location: PIN_V23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[9]	=>  Location: PIN_AH12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[10]	=>  Location: PIN_AA25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.tile.y1[8]	=>  Location: PIN_Y23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[15]	=>  Location: PIN_G8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[7]	=>  Location: PIN_F14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[6]	=>  Location: PIN_A9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[5]	=>  Location: PIN_AG26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[4]	=>  Location: PIN_A13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[1]	=>  Location: PIN_AF18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[0]	=>  Location: PIN_AJ16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[3]	=>  Location: PIN_C12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[2]	=>  Location: PIN_AK8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[14]	=>  Location: PIN_AE22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[13]	=>  Location: PIN_AG25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[12]	=>  Location: PIN_Y18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[11]	=>  Location: PIN_AD26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[9]	=>  Location: PIN_F15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[10]	=>  Location: PIN_AB22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.clip_rect.y1[8]	=>  Location: PIN_AG28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset	=>  Location: PIN_AB26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d.next_quad	=>  Location: PIN_AE29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clock	=>  Location: PIN_AB27,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF ogpu_quad_generator IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clock : std_logic;
SIGNAL ww_reset : std_logic;
SIGNAL \ww_d.next_quad\ : std_logic;
SIGNAL \ww_d.tile.y1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_d.tile.x1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_d.tile.y0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_d.tile.x0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_d.clip_rect.y1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_d.clip_rect.x1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_d.clip_rect.y0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_d.clip_rect.x0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_q.quad.y3\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_q.quad.x3\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_q.quad.y2\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_q.quad.x2\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_q.quad.y1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_q.quad.x1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_q.quad.y0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_q.quad.x0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ww_q.quad_ready\ : std_logic;
SIGNAL \ww_q.end_tile\ : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \clock~input_o\ : std_logic;
SIGNAL \clock~inputCLKENA0_outclk\ : std_logic;
SIGNAL \d.next_quad~input_o\ : std_logic;
SIGNAL \r.next_quad~q\ : std_logic;
SIGNAL \d.tile.y0[15]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[9]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[8]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[13]~input_o\ : std_logic;
SIGNAL \d.tile.y0[12]~input_o\ : std_logic;
SIGNAL \d.tile.y0[13]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[14]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[12]~input_o\ : std_logic;
SIGNAL \d.tile.y0[14]~input_o\ : std_logic;
SIGNAL \LessThan4~0_combout\ : std_logic;
SIGNAL \d.clip_rect.y0[10]~input_o\ : std_logic;
SIGNAL \d.tile.y0[10]~input_o\ : std_logic;
SIGNAL \d.tile.y0[11]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[11]~input_o\ : std_logic;
SIGNAL \LessThan4~1_combout\ : std_logic;
SIGNAL \LessThan4~11_combout\ : std_logic;
SIGNAL \LessThan4~12_combout\ : std_logic;
SIGNAL \d.tile.y0[9]~input_o\ : std_logic;
SIGNAL \d.tile.y0[8]~input_o\ : std_logic;
SIGNAL \LessThan4~13_combout\ : std_logic;
SIGNAL \d.clip_rect.y0[4]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[7]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[6]~input_o\ : std_logic;
SIGNAL \d.tile.y0[7]~input_o\ : std_logic;
SIGNAL \d.tile.y0[6]~input_o\ : std_logic;
SIGNAL \LessThan4~6_combout\ : std_logic;
SIGNAL \d.tile.y0[4]~input_o\ : std_logic;
SIGNAL \d.tile.y0[5]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[5]~input_o\ : std_logic;
SIGNAL \LessThan4~7_combout\ : std_logic;
SIGNAL \d.clip_rect.y0[3]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[2]~input_o\ : std_logic;
SIGNAL \d.tile.y0[2]~input_o\ : std_logic;
SIGNAL \d.tile.y0[3]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[0]~input_o\ : std_logic;
SIGNAL \d.tile.y0[0]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y0[1]~input_o\ : std_logic;
SIGNAL \d.tile.y0[1]~input_o\ : std_logic;
SIGNAL \LessThan4~4_combout\ : std_logic;
SIGNAL \LessThan4~5_combout\ : std_logic;
SIGNAL \LessThan4~8_combout\ : std_logic;
SIGNAL \LessThan4~9_combout\ : std_logic;
SIGNAL \LessThan4~2_combout\ : std_logic;
SIGNAL \LessThan4~3_combout\ : std_logic;
SIGNAL \LessThan4~10_combout\ : std_logic;
SIGNAL \d.clip_rect.y0[15]~input_o\ : std_logic;
SIGNAL \LessThan4~14_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[15]~input_o\ : std_logic;
SIGNAL \d.tile.y1[15]~input_o\ : std_logic;
SIGNAL \comb~2_combout\ : std_logic;
SIGNAL \d.tile.x1[4]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[4]~input_o\ : std_logic;
SIGNAL \d.tile.x1[6]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[5]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[7]~input_o\ : std_logic;
SIGNAL \d.tile.x1[7]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[6]~input_o\ : std_logic;
SIGNAL \d.tile.x1[5]~input_o\ : std_logic;
SIGNAL \LessThan0~1_combout\ : std_logic;
SIGNAL \LessThan0~6_combout\ : std_logic;
SIGNAL \LessThan0~7_combout\ : std_logic;
SIGNAL \d.tile.x1[8]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[8]~input_o\ : std_logic;
SIGNAL \LessThan0~15_combout\ : std_logic;
SIGNAL \d.tile.x1[11]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[11]~input_o\ : std_logic;
SIGNAL \LessThan0~9_combout\ : std_logic;
SIGNAL \d.clip_rect.x0[12]~input_o\ : std_logic;
SIGNAL \d.tile.x1[14]~input_o\ : std_logic;
SIGNAL \d.tile.x1[12]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[14]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[13]~input_o\ : std_logic;
SIGNAL \d.tile.x1[13]~input_o\ : std_logic;
SIGNAL \LessThan0~8_combout\ : std_logic;
SIGNAL \d.tile.x1[10]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[10]~input_o\ : std_logic;
SIGNAL \LessThan0~10_combout\ : std_logic;
SIGNAL \d.tile.x1[9]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[9]~input_o\ : std_logic;
SIGNAL \LessThan0~16_combout\ : std_logic;
SIGNAL \d.clip_rect.x0[0]~input_o\ : std_logic;
SIGNAL \d.tile.x1[1]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[1]~input_o\ : std_logic;
SIGNAL \d.tile.x1[0]~input_o\ : std_logic;
SIGNAL \LessThan0~2_combout\ : std_logic;
SIGNAL \d.tile.x1[2]~input_o\ : std_logic;
SIGNAL \d.tile.x1[3]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[2]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[3]~input_o\ : std_logic;
SIGNAL \LessThan0~3_combout\ : std_logic;
SIGNAL \LessThan0~4_combout\ : std_logic;
SIGNAL \LessThan0~5_combout\ : std_logic;
SIGNAL \LessThan0~13_combout\ : std_logic;
SIGNAL \LessThan0~14_combout\ : std_logic;
SIGNAL \d.tile.x1[15]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x0[15]~input_o\ : std_logic;
SIGNAL \LessThan0~0_combout\ : std_logic;
SIGNAL \LessThan0~11_combout\ : std_logic;
SIGNAL \LessThan0~12_combout\ : std_logic;
SIGNAL \LessThan0~17_combout\ : std_logic;
SIGNAL \LessThan3~0_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[14]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y1[12]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y1[13]~input_o\ : std_logic;
SIGNAL \LessThan3~10_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[10]~input_o\ : std_logic;
SIGNAL \LessThan3~12_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[11]~input_o\ : std_logic;
SIGNAL \LessThan3~11_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[8]~input_o\ : std_logic;
SIGNAL \LessThan3~13_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[9]~input_o\ : std_logic;
SIGNAL \LessThan3~14_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[6]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y1[7]~input_o\ : std_logic;
SIGNAL \LessThan3~8_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[5]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y1[4]~input_o\ : std_logic;
SIGNAL \LessThan3~1_combout\ : std_logic;
SIGNAL \LessThan3~9_combout\ : std_logic;
SIGNAL \LessThan3~2_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[0]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y1[1]~input_o\ : std_logic;
SIGNAL \LessThan3~4_combout\ : std_logic;
SIGNAL \LessThan3~3_combout\ : std_logic;
SIGNAL \d.clip_rect.y1[2]~input_o\ : std_logic;
SIGNAL \d.clip_rect.y1[3]~input_o\ : std_logic;
SIGNAL \LessThan3~5_combout\ : std_logic;
SIGNAL \LessThan3~6_combout\ : std_logic;
SIGNAL \LessThan3~7_combout\ : std_logic;
SIGNAL \LessThan3~17_combout\ : std_logic;
SIGNAL \LessThan3~18_combout\ : std_logic;
SIGNAL \LessThan3~15_combout\ : std_logic;
SIGNAL \LessThan3~16_combout\ : std_logic;
SIGNAL \LessThan3~19_combout\ : std_logic;
SIGNAL \LessThan2~0_combout\ : std_logic;
SIGNAL \d.tile.y1[11]~input_o\ : std_logic;
SIGNAL \d.tile.y1[12]~input_o\ : std_logic;
SIGNAL \d.tile.y1[14]~input_o\ : std_logic;
SIGNAL \d.tile.y1[13]~input_o\ : std_logic;
SIGNAL \LessThan2~13_combout\ : std_logic;
SIGNAL \LessThan2~8_combout\ : std_logic;
SIGNAL \d.tile.y1[10]~input_o\ : std_logic;
SIGNAL \LessThan2~14_combout\ : std_logic;
SIGNAL \d.tile.y1[2]~input_o\ : std_logic;
SIGNAL \d.tile.y1[3]~input_o\ : std_logic;
SIGNAL \LessThan2~4_combout\ : std_logic;
SIGNAL \d.tile.y1[0]~input_o\ : std_logic;
SIGNAL \d.tile.y1[1]~input_o\ : std_logic;
SIGNAL \LessThan2~2_combout\ : std_logic;
SIGNAL \LessThan2~3_combout\ : std_logic;
SIGNAL \d.tile.y1[6]~input_o\ : std_logic;
SIGNAL \d.tile.y1[7]~input_o\ : std_logic;
SIGNAL \d.tile.y1[5]~input_o\ : std_logic;
SIGNAL \LessThan2~1_combout\ : std_logic;
SIGNAL \d.tile.y1[4]~input_o\ : std_logic;
SIGNAL \LessThan2~5_combout\ : std_logic;
SIGNAL \LessThan2~6_combout\ : std_logic;
SIGNAL \LessThan2~7_combout\ : std_logic;
SIGNAL \LessThan2~10_combout\ : std_logic;
SIGNAL \d.tile.y1[9]~input_o\ : std_logic;
SIGNAL \d.tile.y1[8]~input_o\ : std_logic;
SIGNAL \LessThan2~15_combout\ : std_logic;
SIGNAL \LessThan2~9_combout\ : std_logic;
SIGNAL \LessThan2~16_combout\ : std_logic;
SIGNAL \LessThan2~11_combout\ : std_logic;
SIGNAL \LessThan2~12_combout\ : std_logic;
SIGNAL \LessThan2~17_combout\ : std_logic;
SIGNAL \d.clip_rect.x1[15]~input_o\ : std_logic;
SIGNAL \d.tile.x0[15]~input_o\ : std_logic;
SIGNAL \comb~1_combout\ : std_logic;
SIGNAL \d.clip_rect.x1[3]~input_o\ : std_logic;
SIGNAL \d.tile.x0[2]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[2]~input_o\ : std_logic;
SIGNAL \d.tile.x0[3]~input_o\ : std_logic;
SIGNAL \LessThan1~3_combout\ : std_logic;
SIGNAL \LessThan1~4_combout\ : std_logic;
SIGNAL \d.clip_rect.x1[4]~input_o\ : std_logic;
SIGNAL \d.tile.x0[0]~input_o\ : std_logic;
SIGNAL \d.tile.x0[1]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[1]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[0]~input_o\ : std_logic;
SIGNAL \LessThan1~2_combout\ : std_logic;
SIGNAL \d.tile.x0[4]~input_o\ : std_logic;
SIGNAL \d.tile.x0[5]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[5]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[7]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[6]~input_o\ : std_logic;
SIGNAL \d.tile.x0[7]~input_o\ : std_logic;
SIGNAL \d.tile.x0[6]~input_o\ : std_logic;
SIGNAL \LessThan1~1_combout\ : std_logic;
SIGNAL \LessThan1~5_combout\ : std_logic;
SIGNAL \d.tile.x0[10]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[10]~input_o\ : std_logic;
SIGNAL \LessThan1~10_combout\ : std_logic;
SIGNAL \d.tile.x0[8]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[8]~input_o\ : std_logic;
SIGNAL \LessThan1~11_combout\ : std_logic;
SIGNAL \d.tile.x0[12]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[14]~input_o\ : std_logic;
SIGNAL \d.tile.x0[13]~input_o\ : std_logic;
SIGNAL \d.tile.x0[14]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[12]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[13]~input_o\ : std_logic;
SIGNAL \LessThan1~8_combout\ : std_logic;
SIGNAL \d.tile.x0[9]~input_o\ : std_logic;
SIGNAL \d.tile.x0[11]~input_o\ : std_logic;
SIGNAL \d.clip_rect.x1[11]~input_o\ : std_logic;
SIGNAL \LessThan1~9_combout\ : std_logic;
SIGNAL \d.clip_rect.x1[9]~input_o\ : std_logic;
SIGNAL \LessThan1~12_combout\ : std_logic;
SIGNAL \LessThan1~0_combout\ : std_logic;
SIGNAL \LessThan1~15_combout\ : std_logic;
SIGNAL \LessThan1~16_combout\ : std_logic;
SIGNAL \LessThan1~13_combout\ : std_logic;
SIGNAL \LessThan1~14_combout\ : std_logic;
SIGNAL \LessThan1~6_combout\ : std_logic;
SIGNAL \LessThan1~7_combout\ : std_logic;
SIGNAL \LessThan1~17_combout\ : std_logic;
SIGNAL \v~0_combout\ : std_logic;
SIGNAL \Add3~45_sumout\ : std_logic;
SIGNAL \reset~input_o\ : std_logic;
SIGNAL \comb~3_combout\ : std_logic;
SIGNAL \comb~4_combout\ : std_logic;
SIGNAL \v~128_combout\ : std_logic;
SIGNAL \LessThan7~0_combout\ : std_logic;
SIGNAL \LessThan7~1_combout\ : std_logic;
SIGNAL \LessThan7~11_combout\ : std_logic;
SIGNAL \LessThan7~12_combout\ : std_logic;
SIGNAL \LessThan7~13_combout\ : std_logic;
SIGNAL \LessThan7~6_combout\ : std_logic;
SIGNAL \LessThan7~7_combout\ : std_logic;
SIGNAL \LessThan7~4_combout\ : std_logic;
SIGNAL \LessThan7~5_combout\ : std_logic;
SIGNAL \LessThan7~3_combout\ : std_logic;
SIGNAL \LessThan7~8_combout\ : std_logic;
SIGNAL \LessThan7~9_combout\ : std_logic;
SIGNAL \LessThan7~2_combout\ : std_logic;
SIGNAL \LessThan7~10_combout\ : std_logic;
SIGNAL \LessThan7~14_combout\ : std_logic;
SIGNAL \r.i[15]~0_combout\ : std_logic;
SIGNAL \v~125_combout\ : std_logic;
SIGNAL \v~124_combout\ : std_logic;
SIGNAL \v~123_combout\ : std_logic;
SIGNAL \v~11_combout\ : std_logic;
SIGNAL \Add3~46\ : std_logic;
SIGNAL \Add3~41_sumout\ : std_logic;
SIGNAL \v~3_combout\ : std_logic;
SIGNAL \Add3~42\ : std_logic;
SIGNAL \Add3~37_sumout\ : std_logic;
SIGNAL \v~5_combout\ : std_logic;
SIGNAL \Add3~38\ : std_logic;
SIGNAL \Add3~33_sumout\ : std_logic;
SIGNAL \v~7_combout\ : std_logic;
SIGNAL \Add3~34\ : std_logic;
SIGNAL \Add3~29_sumout\ : std_logic;
SIGNAL \r.i[5]~feeder_combout\ : std_logic;
SIGNAL \v~9_combout\ : std_logic;
SIGNAL \Add3~30\ : std_logic;
SIGNAL \Add3~57_sumout\ : std_logic;
SIGNAL \v~15_combout\ : std_logic;
SIGNAL \Add3~58\ : std_logic;
SIGNAL \Add3~53_sumout\ : std_logic;
SIGNAL \v~13_combout\ : std_logic;
SIGNAL \Add3~54\ : std_logic;
SIGNAL \Add3~49_sumout\ : std_logic;
SIGNAL \LessThan9~10_combout\ : std_logic;
SIGNAL \v~117_combout\ : std_logic;
SIGNAL \v~17_combout\ : std_logic;
SIGNAL \Add3~50\ : std_logic;
SIGNAL \Add3~25_sumout\ : std_logic;
SIGNAL \LessThan9~6_combout\ : std_logic;
SIGNAL \v~119_combout\ : std_logic;
SIGNAL \v~118_combout\ : std_logic;
SIGNAL \LessThan9~7_combout\ : std_logic;
SIGNAL \v~122_combout\ : std_logic;
SIGNAL \v~121_combout\ : std_logic;
SIGNAL \v~120_combout\ : std_logic;
SIGNAL \LessThan9~8_combout\ : std_logic;
SIGNAL \LessThan9~9_combout\ : std_logic;
SIGNAL \LessThan9~11_combout\ : std_logic;
SIGNAL \LessThan9~17_combout\ : std_logic;
SIGNAL \LessThan9~14_combout\ : std_logic;
SIGNAL \v~116_combout\ : std_logic;
SIGNAL \v~19_combout\ : std_logic;
SIGNAL \Add3~26\ : std_logic;
SIGNAL \Add3~21_sumout\ : std_logic;
SIGNAL \v~115_combout\ : std_logic;
SIGNAL \v~21_combout\ : std_logic;
SIGNAL \Add3~22\ : std_logic;
SIGNAL \Add3~17_sumout\ : std_logic;
SIGNAL \LessThan9~4_combout\ : std_logic;
SIGNAL \v~112_combout\ : std_logic;
SIGNAL \v~23_combout\ : std_logic;
SIGNAL \Add3~18\ : std_logic;
SIGNAL \Add3~1_sumout\ : std_logic;
SIGNAL \LessThan9~3_combout\ : std_logic;
SIGNAL \v~147_combout\ : std_logic;
SIGNAL \v~114_combout\ : std_logic;
SIGNAL \v~25_combout\ : std_logic;
SIGNAL \Add3~2\ : std_logic;
SIGNAL \Add3~13_sumout\ : std_logic;
SIGNAL \v~113_combout\ : std_logic;
SIGNAL \v~27_combout\ : std_logic;
SIGNAL \Add3~14\ : std_logic;
SIGNAL \Add3~9_sumout\ : std_logic;
SIGNAL \r.i[15]~feeder_combout\ : std_logic;
SIGNAL \v~149_combout\ : std_logic;
SIGNAL \Add3~10\ : std_logic;
SIGNAL \Add3~5_sumout\ : std_logic;
SIGNAL \LessThan9~0_combout\ : std_logic;
SIGNAL \LessThan9~15_combout\ : std_logic;
SIGNAL \LessThan9~5_combout\ : std_logic;
SIGNAL \LessThan9~16_combout\ : std_logic;
SIGNAL \LessThan9~1_combout\ : std_logic;
SIGNAL \LessThan9~2_combout\ : std_logic;
SIGNAL \v~129_combout\ : std_logic;
SIGNAL \r.generate_quads~q\ : std_logic;
SIGNAL \v~126_combout\ : std_logic;
SIGNAL \v~95_combout\ : std_logic;
SIGNAL \LessThan9~12_combout\ : std_logic;
SIGNAL \LessThan9~13_combout\ : std_logic;
SIGNAL \v~127_combout\ : std_logic;
SIGNAL \r.end_tile~q\ : std_logic;
SIGNAL \comb~0_combout\ : std_logic;
SIGNAL \v~92_combout\ : std_logic;
SIGNAL \v~146_combout\ : std_logic;
SIGNAL \r.j[15]~feeder_combout\ : std_logic;
SIGNAL \LessThan5~8_combout\ : std_logic;
SIGNAL \LessThan5~9_combout\ : std_logic;
SIGNAL \LessThan5~11_combout\ : std_logic;
SIGNAL \LessThan5~12_combout\ : std_logic;
SIGNAL \LessThan5~13_combout\ : std_logic;
SIGNAL \LessThan5~2_combout\ : std_logic;
SIGNAL \LessThan5~3_combout\ : std_logic;
SIGNAL \LessThan5~6_combout\ : std_logic;
SIGNAL \LessThan5~4_combout\ : std_logic;
SIGNAL \LessThan5~5_combout\ : std_logic;
SIGNAL \LessThan5~0_combout\ : std_logic;
SIGNAL \LessThan5~1_combout\ : std_logic;
SIGNAL \LessThan5~7_combout\ : std_logic;
SIGNAL \LessThan5~10_combout\ : std_logic;
SIGNAL \v~89_combout\ : std_logic;
SIGNAL \v~145_combout\ : std_logic;
SIGNAL \r.j[14]~feeder_combout\ : std_logic;
SIGNAL \v~86_combout\ : std_logic;
SIGNAL \v~144_combout\ : std_logic;
SIGNAL \r.j[13]~feeder_combout\ : std_logic;
SIGNAL \v~83_combout\ : std_logic;
SIGNAL \v~143_combout\ : std_logic;
SIGNAL \r.j[12]~feeder_combout\ : std_logic;
SIGNAL \v~80_combout\ : std_logic;
SIGNAL \v~142_combout\ : std_logic;
SIGNAL \r.j[11]~feeder_combout\ : std_logic;
SIGNAL \v~77_combout\ : std_logic;
SIGNAL \v~141_combout\ : std_logic;
SIGNAL \r.j[10]~feeder_combout\ : std_logic;
SIGNAL \v~74_combout\ : std_logic;
SIGNAL \v~140_combout\ : std_logic;
SIGNAL \r.j[9]~feeder_combout\ : std_logic;
SIGNAL \v~71_combout\ : std_logic;
SIGNAL \v~139_combout\ : std_logic;
SIGNAL \r.j[8]~feeder_combout\ : std_logic;
SIGNAL \v~68_combout\ : std_logic;
SIGNAL \v~138_combout\ : std_logic;
SIGNAL \r.j[7]~feeder_combout\ : std_logic;
SIGNAL \v~65_combout\ : std_logic;
SIGNAL \v~137_combout\ : std_logic;
SIGNAL \r.j[6]~feeder_combout\ : std_logic;
SIGNAL \v~62_combout\ : std_logic;
SIGNAL \v~136_combout\ : std_logic;
SIGNAL \r.j[5]~feeder_combout\ : std_logic;
SIGNAL \v~59_combout\ : std_logic;
SIGNAL \v~135_combout\ : std_logic;
SIGNAL \r.j[4]~feeder_combout\ : std_logic;
SIGNAL \v~56_combout\ : std_logic;
SIGNAL \v~134_combout\ : std_logic;
SIGNAL \r.j[3]~feeder_combout\ : std_logic;
SIGNAL \v~53_combout\ : std_logic;
SIGNAL \v~133_combout\ : std_logic;
SIGNAL \r.j[2]~feeder_combout\ : std_logic;
SIGNAL \v~49_combout\ : std_logic;
SIGNAL \v~50_combout\ : std_logic;
SIGNAL \v~132_combout\ : std_logic;
SIGNAL \r.j[1]~feeder_combout\ : std_logic;
SIGNAL \Add2~57_sumout\ : std_logic;
SIGNAL \Add2~58\ : std_logic;
SIGNAL \Add2~53_sumout\ : std_logic;
SIGNAL \Add2~54\ : std_logic;
SIGNAL \Add2~49_sumout\ : std_logic;
SIGNAL \Add2~50\ : std_logic;
SIGNAL \Add2~33_sumout\ : std_logic;
SIGNAL \Add2~34\ : std_logic;
SIGNAL \Add2~45_sumout\ : std_logic;
SIGNAL \Add2~46\ : std_logic;
SIGNAL \Add2~41_sumout\ : std_logic;
SIGNAL \Add2~42\ : std_logic;
SIGNAL \Add2~37_sumout\ : std_logic;
SIGNAL \Add2~38\ : std_logic;
SIGNAL \Add2~29_sumout\ : std_logic;
SIGNAL \Add2~30\ : std_logic;
SIGNAL \Add2~21_sumout\ : std_logic;
SIGNAL \Add2~22\ : std_logic;
SIGNAL \Add2~25_sumout\ : std_logic;
SIGNAL \Add2~26\ : std_logic;
SIGNAL \Add2~17_sumout\ : std_logic;
SIGNAL \Add2~18\ : std_logic;
SIGNAL \Add2~13_sumout\ : std_logic;
SIGNAL \Add2~14\ : std_logic;
SIGNAL \Add2~9_sumout\ : std_logic;
SIGNAL \Add2~10\ : std_logic;
SIGNAL \Add2~5_sumout\ : std_logic;
SIGNAL \Add2~6\ : std_logic;
SIGNAL \Add2~1_sumout\ : std_logic;
SIGNAL \v~148_combout\ : std_logic;
SIGNAL \LessThan6~0_combout\ : std_logic;
SIGNAL \LessThan6~1_combout\ : std_logic;
SIGNAL \LessThan6~4_combout\ : std_logic;
SIGNAL \LessThan6~5_combout\ : std_logic;
SIGNAL \LessThan6~6_combout\ : std_logic;
SIGNAL \LessThan6~8_combout\ : std_logic;
SIGNAL \LessThan6~9_combout\ : std_logic;
SIGNAL \LessThan6~2_combout\ : std_logic;
SIGNAL \LessThan6~3_combout\ : std_logic;
SIGNAL \LessThan6~7_combout\ : std_logic;
SIGNAL \LessThan6~10_combout\ : std_logic;
SIGNAL \LessThan6~11_combout\ : std_logic;
SIGNAL \LessThan6~12_combout\ : std_logic;
SIGNAL \LessThan6~13_combout\ : std_logic;
SIGNAL \LessThan6~14_combout\ : std_logic;
SIGNAL \v~107_combout\ : std_logic;
SIGNAL \v~108_combout\ : std_logic;
SIGNAL \v~46_combout\ : std_logic;
SIGNAL \v~100_combout\ : std_logic;
SIGNAL \v~101_combout\ : std_logic;
SIGNAL \LessThan8~2_combout\ : std_logic;
SIGNAL \v~99_combout\ : std_logic;
SIGNAL \LessThan8~1_combout\ : std_logic;
SIGNAL \v~102_combout\ : std_logic;
SIGNAL \LessThan8~4_combout\ : std_logic;
SIGNAL \v~98_combout\ : std_logic;
SIGNAL \v~97_combout\ : std_logic;
SIGNAL \v~96_combout\ : std_logic;
SIGNAL \LessThan8~0_combout\ : std_logic;
SIGNAL \LessThan8~5_combout\ : std_logic;
SIGNAL \LessThan8~15_combout\ : std_logic;
SIGNAL \LessThan8~12_combout\ : std_logic;
SIGNAL \LessThan8~13_combout\ : std_logic;
SIGNAL \v~131_combout\ : std_logic;
SIGNAL \v~47_combout\ : std_logic;
SIGNAL \v~109_combout\ : std_logic;
SIGNAL \v~110_combout\ : std_logic;
SIGNAL \v~111_combout\ : std_logic;
SIGNAL \LessThan8~8_combout\ : std_logic;
SIGNAL \LessThan8~9_combout\ : std_logic;
SIGNAL \v~103_combout\ : std_logic;
SIGNAL \LessThan8~6_combout\ : std_logic;
SIGNAL \v~105_combout\ : std_logic;
SIGNAL \v~106_combout\ : std_logic;
SIGNAL \v~104_combout\ : std_logic;
SIGNAL \LessThan8~10_combout\ : std_logic;
SIGNAL \LessThan8~7_combout\ : std_logic;
SIGNAL \LessThan8~11_combout\ : std_logic;
SIGNAL \LessThan8~3_combout\ : std_logic;
SIGNAL \LessThan8~14_combout\ : std_logic;
SIGNAL \v~1_combout\ : std_logic;
SIGNAL \v~2_combout\ : std_logic;
SIGNAL \v~4_combout\ : std_logic;
SIGNAL \v~6_combout\ : std_logic;
SIGNAL \v~8_combout\ : std_logic;
SIGNAL \v~10_combout\ : std_logic;
SIGNAL \v~12_combout\ : std_logic;
SIGNAL \v~14_combout\ : std_logic;
SIGNAL \v~16_combout\ : std_logic;
SIGNAL \v~18_combout\ : std_logic;
SIGNAL \v~20_combout\ : std_logic;
SIGNAL \v~22_combout\ : std_logic;
SIGNAL \v~24_combout\ : std_logic;
SIGNAL \v~26_combout\ : std_logic;
SIGNAL \v~28_combout\ : std_logic;
SIGNAL \v~29_combout\ : std_logic;
SIGNAL \v~130_combout\ : std_logic;
SIGNAL \Add0~1_sumout\ : std_logic;
SIGNAL \v~30_combout\ : std_logic;
SIGNAL \Add0~2\ : std_logic;
SIGNAL \Add0~5_sumout\ : std_logic;
SIGNAL \v~31_combout\ : std_logic;
SIGNAL \Add0~6\ : std_logic;
SIGNAL \Add0~9_sumout\ : std_logic;
SIGNAL \v~32_combout\ : std_logic;
SIGNAL \Add0~10\ : std_logic;
SIGNAL \Add0~13_sumout\ : std_logic;
SIGNAL \v~33_combout\ : std_logic;
SIGNAL \Add0~14\ : std_logic;
SIGNAL \Add0~17_sumout\ : std_logic;
SIGNAL \v~34_combout\ : std_logic;
SIGNAL \Add0~18\ : std_logic;
SIGNAL \Add0~21_sumout\ : std_logic;
SIGNAL \v~35_combout\ : std_logic;
SIGNAL \Add0~22\ : std_logic;
SIGNAL \Add0~25_sumout\ : std_logic;
SIGNAL \v~36_combout\ : std_logic;
SIGNAL \Add0~26\ : std_logic;
SIGNAL \Add0~29_sumout\ : std_logic;
SIGNAL \v~37_combout\ : std_logic;
SIGNAL \Add0~30\ : std_logic;
SIGNAL \Add0~33_sumout\ : std_logic;
SIGNAL \v~38_combout\ : std_logic;
SIGNAL \Add0~34\ : std_logic;
SIGNAL \Add0~37_sumout\ : std_logic;
SIGNAL \v~39_combout\ : std_logic;
SIGNAL \Add0~38\ : std_logic;
SIGNAL \Add0~41_sumout\ : std_logic;
SIGNAL \v~40_combout\ : std_logic;
SIGNAL \Add0~42\ : std_logic;
SIGNAL \Add0~45_sumout\ : std_logic;
SIGNAL \v~41_combout\ : std_logic;
SIGNAL \Add0~46\ : std_logic;
SIGNAL \Add0~49_sumout\ : std_logic;
SIGNAL \v~42_combout\ : std_logic;
SIGNAL \Add0~50\ : std_logic;
SIGNAL \Add0~53_sumout\ : std_logic;
SIGNAL \v~43_combout\ : std_logic;
SIGNAL \Add0~54\ : std_logic;
SIGNAL \Add0~57_sumout\ : std_logic;
SIGNAL \v~44_combout\ : std_logic;
SIGNAL \Add0~58\ : std_logic;
SIGNAL \Add0~61_sumout\ : std_logic;
SIGNAL \v~45_combout\ : std_logic;
SIGNAL \v~48_combout\ : std_logic;
SIGNAL \v~51_combout\ : std_logic;
SIGNAL \v~52_combout\ : std_logic;
SIGNAL \v~54_combout\ : std_logic;
SIGNAL \v~55_combout\ : std_logic;
SIGNAL \v~57_combout\ : std_logic;
SIGNAL \v~58_combout\ : std_logic;
SIGNAL \v~60_combout\ : std_logic;
SIGNAL \v~61_combout\ : std_logic;
SIGNAL \v~63_combout\ : std_logic;
SIGNAL \v~64_combout\ : std_logic;
SIGNAL \v~66_combout\ : std_logic;
SIGNAL \v~67_combout\ : std_logic;
SIGNAL \v~69_combout\ : std_logic;
SIGNAL \v~70_combout\ : std_logic;
SIGNAL \v~72_combout\ : std_logic;
SIGNAL \v~73_combout\ : std_logic;
SIGNAL \v~75_combout\ : std_logic;
SIGNAL \v~76_combout\ : std_logic;
SIGNAL \v~78_combout\ : std_logic;
SIGNAL \v~79_combout\ : std_logic;
SIGNAL \v~81_combout\ : std_logic;
SIGNAL \v~82_combout\ : std_logic;
SIGNAL \v~84_combout\ : std_logic;
SIGNAL \v~85_combout\ : std_logic;
SIGNAL \v~87_combout\ : std_logic;
SIGNAL \v~88_combout\ : std_logic;
SIGNAL \v~90_combout\ : std_logic;
SIGNAL \v~91_combout\ : std_logic;
SIGNAL \v~93_combout\ : std_logic;
SIGNAL \v~94_combout\ : std_logic;
SIGNAL \r.quad_ready~feeder_combout\ : std_logic;
SIGNAL \r.quad_ready~q\ : std_logic;
SIGNAL \r.x0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \r.y1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \r.x1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \r.quad.x0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \r.j\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \r.quad.x1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \r.quad.y0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \r.i\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ALT_INV_d.next_quad~input_o\ : std_logic;
SIGNAL \ALT_INV_reset~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y1[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y1[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x1[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x0[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.x0[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.x1[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.tile.y0[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_d.clip_rect.y0[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_v~149_combout\ : std_logic;
SIGNAL \ALT_INV_v~148_combout\ : std_logic;
SIGNAL \ALT_INV_v~147_combout\ : std_logic;
SIGNAL \ALT_INV_v~146_combout\ : std_logic;
SIGNAL \ALT_INV_v~145_combout\ : std_logic;
SIGNAL \ALT_INV_v~144_combout\ : std_logic;
SIGNAL \ALT_INV_v~143_combout\ : std_logic;
SIGNAL \ALT_INV_v~142_combout\ : std_logic;
SIGNAL \ALT_INV_v~141_combout\ : std_logic;
SIGNAL \ALT_INV_v~140_combout\ : std_logic;
SIGNAL \ALT_INV_v~139_combout\ : std_logic;
SIGNAL \ALT_INV_v~138_combout\ : std_logic;
SIGNAL \ALT_INV_v~137_combout\ : std_logic;
SIGNAL \ALT_INV_v~136_combout\ : std_logic;
SIGNAL \ALT_INV_v~135_combout\ : std_logic;
SIGNAL \ALT_INV_v~134_combout\ : std_logic;
SIGNAL \ALT_INV_v~133_combout\ : std_logic;
SIGNAL \ALT_INV_v~132_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~15_combout\ : std_logic;
SIGNAL \ALT_INV_v~130_combout\ : std_logic;
SIGNAL \ALT_INV_v~128_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~17_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~16_combout\ : std_logic;
SIGNAL \ALT_INV_v~126_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~15_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~14_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~10_combout\ : std_logic;
SIGNAL \ALT_INV_v~125_combout\ : std_logic;
SIGNAL \ALT_INV_v~124_combout\ : std_logic;
SIGNAL \ALT_INV_v~123_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~8_combout\ : std_logic;
SIGNAL \ALT_INV_v~122_combout\ : std_logic;
SIGNAL \ALT_INV_v~121_combout\ : std_logic;
SIGNAL \ALT_INV_v~120_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~7_combout\ : std_logic;
SIGNAL \ALT_INV_v~119_combout\ : std_logic;
SIGNAL \ALT_INV_v~118_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~6_combout\ : std_logic;
SIGNAL \ALT_INV_v~117_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~5_combout\ : std_logic;
SIGNAL \ALT_INV_v~116_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~4_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~2_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~1_combout\ : std_logic;
SIGNAL \ALT_INV_v~115_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan9~0_combout\ : std_logic;
SIGNAL \ALT_INV_v~114_combout\ : std_logic;
SIGNAL \ALT_INV_v~113_combout\ : std_logic;
SIGNAL \ALT_INV_v~112_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~14_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~10_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~8_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~7_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~6_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~5_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~4_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~2_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~1_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan7~0_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~14_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~10_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~8_combout\ : std_logic;
SIGNAL \ALT_INV_v~111_combout\ : std_logic;
SIGNAL \ALT_INV_v~110_combout\ : std_logic;
SIGNAL \ALT_INV_v~109_combout\ : std_logic;
SIGNAL \ALT_INV_v~108_combout\ : std_logic;
SIGNAL \ALT_INV_v~107_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~7_combout\ : std_logic;
SIGNAL \ALT_INV_v~106_combout\ : std_logic;
SIGNAL \ALT_INV_v~105_combout\ : std_logic;
SIGNAL \ALT_INV_v~104_combout\ : std_logic;
SIGNAL \ALT_INV_v~103_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~6_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~5_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~4_combout\ : std_logic;
SIGNAL \ALT_INV_v~102_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~2_combout\ : std_logic;
SIGNAL \ALT_INV_v~101_combout\ : std_logic;
SIGNAL \ALT_INV_v~100_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~1_combout\ : std_logic;
SIGNAL \ALT_INV_v~99_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan8~0_combout\ : std_logic;
SIGNAL \ALT_INV_v~98_combout\ : std_logic;
SIGNAL \ALT_INV_v~97_combout\ : std_logic;
SIGNAL \ALT_INV_v~96_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~14_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~10_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~8_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~7_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~6_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~5_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~4_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~2_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~1_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan6~0_combout\ : std_logic;
SIGNAL \ALT_INV_v~95_combout\ : std_logic;
SIGNAL \ALT_INV_v~93_combout\ : std_logic;
SIGNAL \ALT_INV_v~92_combout\ : std_logic;
SIGNAL \ALT_INV_v~90_combout\ : std_logic;
SIGNAL \ALT_INV_v~89_combout\ : std_logic;
SIGNAL \ALT_INV_v~87_combout\ : std_logic;
SIGNAL \ALT_INV_v~86_combout\ : std_logic;
SIGNAL \ALT_INV_v~84_combout\ : std_logic;
SIGNAL \ALT_INV_v~83_combout\ : std_logic;
SIGNAL \ALT_INV_v~81_combout\ : std_logic;
SIGNAL \ALT_INV_v~80_combout\ : std_logic;
SIGNAL \ALT_INV_v~78_combout\ : std_logic;
SIGNAL \ALT_INV_v~77_combout\ : std_logic;
SIGNAL \ALT_INV_v~75_combout\ : std_logic;
SIGNAL \ALT_INV_v~74_combout\ : std_logic;
SIGNAL \ALT_INV_v~72_combout\ : std_logic;
SIGNAL \ALT_INV_v~71_combout\ : std_logic;
SIGNAL \ALT_INV_v~69_combout\ : std_logic;
SIGNAL \ALT_INV_v~68_combout\ : std_logic;
SIGNAL \ALT_INV_v~66_combout\ : std_logic;
SIGNAL \ALT_INV_v~65_combout\ : std_logic;
SIGNAL \ALT_INV_v~63_combout\ : std_logic;
SIGNAL \ALT_INV_v~62_combout\ : std_logic;
SIGNAL \ALT_INV_v~60_combout\ : std_logic;
SIGNAL \ALT_INV_v~59_combout\ : std_logic;
SIGNAL \ALT_INV_v~57_combout\ : std_logic;
SIGNAL \ALT_INV_v~56_combout\ : std_logic;
SIGNAL \ALT_INV_v~54_combout\ : std_logic;
SIGNAL \ALT_INV_v~53_combout\ : std_logic;
SIGNAL \ALT_INV_v~51_combout\ : std_logic;
SIGNAL \ALT_INV_v~50_combout\ : std_logic;
SIGNAL \ALT_INV_v~49_combout\ : std_logic;
SIGNAL \ALT_INV_v~47_combout\ : std_logic;
SIGNAL \ALT_INV_v~46_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~10_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~8_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~7_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~6_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~5_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~4_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~2_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~1_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan5~0_combout\ : std_logic;
SIGNAL \ALT_INV_comb~4_combout\ : std_logic;
SIGNAL \ALT_INV_comb~3_combout\ : std_logic;
SIGNAL \ALT_INV_v~27_combout\ : std_logic;
SIGNAL \ALT_INV_v~25_combout\ : std_logic;
SIGNAL \ALT_INV_v~23_combout\ : std_logic;
SIGNAL \ALT_INV_v~21_combout\ : std_logic;
SIGNAL \ALT_INV_v~19_combout\ : std_logic;
SIGNAL \ALT_INV_v~17_combout\ : std_logic;
SIGNAL \ALT_INV_v~15_combout\ : std_logic;
SIGNAL \ALT_INV_v~13_combout\ : std_logic;
SIGNAL \ALT_INV_v~11_combout\ : std_logic;
SIGNAL \ALT_INV_v~9_combout\ : std_logic;
SIGNAL \ALT_INV_v~7_combout\ : std_logic;
SIGNAL \ALT_INV_v~5_combout\ : std_logic;
SIGNAL \ALT_INV_v~3_combout\ : std_logic;
SIGNAL \ALT_INV_v~1_combout\ : std_logic;
SIGNAL \ALT_INV_v~0_combout\ : std_logic;
SIGNAL \ALT_INV_comb~2_combout\ : std_logic;
SIGNAL \ALT_INV_comb~1_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~19_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~18_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~17_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~16_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~15_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~14_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~10_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~8_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~7_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~6_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~5_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~4_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~2_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~1_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan3~0_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~17_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~16_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~15_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~14_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~10_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~8_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~7_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~6_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~5_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~4_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~2_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~1_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan2~0_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~17_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~16_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~15_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~14_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~10_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~8_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~7_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~6_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~5_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~4_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~2_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~1_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan1~0_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~17_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~16_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~15_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~14_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~10_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~8_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~7_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~6_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~5_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~4_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~2_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~1_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan0~0_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~14_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~13_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~12_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~11_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~10_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~9_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~8_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~7_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~6_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~5_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~4_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~3_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~2_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~1_combout\ : std_logic;
SIGNAL \ALT_INV_LessThan4~0_combout\ : std_logic;
SIGNAL \ALT_INV_comb~0_combout\ : std_logic;
SIGNAL \ALT_INV_r.end_tile~q\ : std_logic;
SIGNAL \ALT_INV_r.next_quad~q\ : std_logic;
SIGNAL \ALT_INV_r.x0\ : std_logic_vector(15 DOWNTO 1);
SIGNAL \ALT_INV_r.y1\ : std_logic_vector(15 DOWNTO 1);
SIGNAL \ALT_INV_Add3~57_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~53_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~49_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~45_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~41_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~37_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~33_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~29_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~25_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~21_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~17_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~13_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~9_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~5_sumout\ : std_logic;
SIGNAL \ALT_INV_Add3~1_sumout\ : std_logic;
SIGNAL \ALT_INV_r.x1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ALT_INV_Add2~57_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~53_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~49_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~45_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~41_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~37_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~33_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~29_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~25_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~21_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~17_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~13_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~9_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~5_sumout\ : std_logic;
SIGNAL \ALT_INV_Add2~1_sumout\ : std_logic;
SIGNAL \ALT_INV_r.quad.x0\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ALT_INV_r.j\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ALT_INV_r.quad.x1\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \ALT_INV_Add0~61_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~57_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~53_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~49_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~45_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~41_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~37_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~33_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~29_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~25_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~21_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~17_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~13_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~9_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~5_sumout\ : std_logic;
SIGNAL \ALT_INV_Add0~1_sumout\ : std_logic;
SIGNAL \ALT_INV_r.quad.y0\ : std_logic_vector(15 DOWNTO 1);
SIGNAL \ALT_INV_r.i\ : std_logic_vector(15 DOWNTO 1);
SIGNAL \ALT_INV_r.generate_quads~q\ : std_logic;

BEGIN

ww_clock <= clock;
ww_reset <= reset;
\ww_d.next_quad\ <= \d.next_quad\;
\ww_d.tile.y1\ <= \d.tile.y1\;
\ww_d.tile.x1\ <= \d.tile.x1\;
\ww_d.tile.y0\ <= \d.tile.y0\;
\ww_d.tile.x0\ <= \d.tile.x0\;
\ww_d.clip_rect.y1\ <= \d.clip_rect.y1\;
\ww_d.clip_rect.x1\ <= \d.clip_rect.x1\;
\ww_d.clip_rect.y0\ <= \d.clip_rect.y0\;
\ww_d.clip_rect.x0\ <= \d.clip_rect.x0\;
\q.quad.y3\ <= \ww_q.quad.y3\;
\q.quad.x3\ <= \ww_q.quad.x3\;
\q.quad.y2\ <= \ww_q.quad.y2\;
\q.quad.x2\ <= \ww_q.quad.x2\;
\q.quad.y1\ <= \ww_q.quad.y1\;
\q.quad.x1\ <= \ww_q.quad.x1\;
\q.quad.y0\ <= \ww_q.quad.y0\;
\q.quad.x0\ <= \ww_q.quad.x0\;
\q.quad_ready\ <= \ww_q.quad_ready\;
\q.end_tile\ <= \ww_q.end_tile\;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_d.next_quad~input_o\ <= NOT \d.next_quad~input_o\;
\ALT_INV_reset~input_o\ <= NOT \reset~input_o\;
\ALT_INV_d.clip_rect.y1[8]~input_o\ <= NOT \d.clip_rect.y1[8]~input_o\;
\ALT_INV_d.clip_rect.y1[10]~input_o\ <= NOT \d.clip_rect.y1[10]~input_o\;
\ALT_INV_d.clip_rect.y1[9]~input_o\ <= NOT \d.clip_rect.y1[9]~input_o\;
\ALT_INV_d.clip_rect.y1[11]~input_o\ <= NOT \d.clip_rect.y1[11]~input_o\;
\ALT_INV_d.clip_rect.y1[12]~input_o\ <= NOT \d.clip_rect.y1[12]~input_o\;
\ALT_INV_d.clip_rect.y1[13]~input_o\ <= NOT \d.clip_rect.y1[13]~input_o\;
\ALT_INV_d.clip_rect.y1[14]~input_o\ <= NOT \d.clip_rect.y1[14]~input_o\;
\ALT_INV_d.clip_rect.y1[2]~input_o\ <= NOT \d.clip_rect.y1[2]~input_o\;
\ALT_INV_d.clip_rect.y1[3]~input_o\ <= NOT \d.clip_rect.y1[3]~input_o\;
\ALT_INV_d.clip_rect.y1[0]~input_o\ <= NOT \d.clip_rect.y1[0]~input_o\;
\ALT_INV_d.clip_rect.y1[1]~input_o\ <= NOT \d.clip_rect.y1[1]~input_o\;
\ALT_INV_d.clip_rect.y1[4]~input_o\ <= NOT \d.clip_rect.y1[4]~input_o\;
\ALT_INV_d.clip_rect.y1[5]~input_o\ <= NOT \d.clip_rect.y1[5]~input_o\;
\ALT_INV_d.clip_rect.y1[6]~input_o\ <= NOT \d.clip_rect.y1[6]~input_o\;
\ALT_INV_d.clip_rect.y1[7]~input_o\ <= NOT \d.clip_rect.y1[7]~input_o\;
\ALT_INV_d.clip_rect.y1[15]~input_o\ <= NOT \d.clip_rect.y1[15]~input_o\;
\ALT_INV_d.tile.y1[8]~input_o\ <= NOT \d.tile.y1[8]~input_o\;
\ALT_INV_d.tile.y1[10]~input_o\ <= NOT \d.tile.y1[10]~input_o\;
\ALT_INV_d.tile.y1[9]~input_o\ <= NOT \d.tile.y1[9]~input_o\;
\ALT_INV_d.tile.y1[11]~input_o\ <= NOT \d.tile.y1[11]~input_o\;
\ALT_INV_d.tile.y1[12]~input_o\ <= NOT \d.tile.y1[12]~input_o\;
\ALT_INV_d.tile.y1[13]~input_o\ <= NOT \d.tile.y1[13]~input_o\;
\ALT_INV_d.tile.y1[14]~input_o\ <= NOT \d.tile.y1[14]~input_o\;
\ALT_INV_d.tile.y1[2]~input_o\ <= NOT \d.tile.y1[2]~input_o\;
\ALT_INV_d.tile.y1[3]~input_o\ <= NOT \d.tile.y1[3]~input_o\;
\ALT_INV_d.tile.y1[0]~input_o\ <= NOT \d.tile.y1[0]~input_o\;
\ALT_INV_d.tile.y1[1]~input_o\ <= NOT \d.tile.y1[1]~input_o\;
\ALT_INV_d.tile.y1[5]~input_o\ <= NOT \d.tile.y1[5]~input_o\;
\ALT_INV_d.tile.y1[6]~input_o\ <= NOT \d.tile.y1[6]~input_o\;
\ALT_INV_d.tile.y1[7]~input_o\ <= NOT \d.tile.y1[7]~input_o\;
\ALT_INV_d.tile.y1[4]~input_o\ <= NOT \d.tile.y1[4]~input_o\;
\ALT_INV_d.tile.y1[15]~input_o\ <= NOT \d.tile.y1[15]~input_o\;
\ALT_INV_d.clip_rect.x1[8]~input_o\ <= NOT \d.clip_rect.x1[8]~input_o\;
\ALT_INV_d.tile.x0[8]~input_o\ <= NOT \d.tile.x0[8]~input_o\;
\ALT_INV_d.clip_rect.x1[10]~input_o\ <= NOT \d.clip_rect.x1[10]~input_o\;
\ALT_INV_d.tile.x0[10]~input_o\ <= NOT \d.tile.x0[10]~input_o\;
\ALT_INV_d.clip_rect.x1[9]~input_o\ <= NOT \d.clip_rect.x1[9]~input_o\;
\ALT_INV_d.tile.x0[9]~input_o\ <= NOT \d.tile.x0[9]~input_o\;
\ALT_INV_d.clip_rect.x1[11]~input_o\ <= NOT \d.clip_rect.x1[11]~input_o\;
\ALT_INV_d.tile.x0[11]~input_o\ <= NOT \d.tile.x0[11]~input_o\;
\ALT_INV_d.clip_rect.x1[12]~input_o\ <= NOT \d.clip_rect.x1[12]~input_o\;
\ALT_INV_d.tile.x0[12]~input_o\ <= NOT \d.tile.x0[12]~input_o\;
\ALT_INV_d.clip_rect.x1[13]~input_o\ <= NOT \d.clip_rect.x1[13]~input_o\;
\ALT_INV_d.tile.x0[13]~input_o\ <= NOT \d.tile.x0[13]~input_o\;
\ALT_INV_d.clip_rect.x1[14]~input_o\ <= NOT \d.clip_rect.x1[14]~input_o\;
\ALT_INV_d.tile.x0[14]~input_o\ <= NOT \d.tile.x0[14]~input_o\;
\ALT_INV_d.clip_rect.x1[2]~input_o\ <= NOT \d.clip_rect.x1[2]~input_o\;
\ALT_INV_d.tile.x0[2]~input_o\ <= NOT \d.tile.x0[2]~input_o\;
\ALT_INV_d.clip_rect.x1[3]~input_o\ <= NOT \d.clip_rect.x1[3]~input_o\;
\ALT_INV_d.tile.x0[3]~input_o\ <= NOT \d.tile.x0[3]~input_o\;
\ALT_INV_d.clip_rect.x1[0]~input_o\ <= NOT \d.clip_rect.x1[0]~input_o\;
\ALT_INV_d.tile.x0[0]~input_o\ <= NOT \d.tile.x0[0]~input_o\;
\ALT_INV_d.clip_rect.x1[1]~input_o\ <= NOT \d.clip_rect.x1[1]~input_o\;
\ALT_INV_d.tile.x0[1]~input_o\ <= NOT \d.tile.x0[1]~input_o\;
\ALT_INV_d.clip_rect.x1[5]~input_o\ <= NOT \d.clip_rect.x1[5]~input_o\;
\ALT_INV_d.tile.x0[5]~input_o\ <= NOT \d.tile.x0[5]~input_o\;
\ALT_INV_d.clip_rect.x1[6]~input_o\ <= NOT \d.clip_rect.x1[6]~input_o\;
\ALT_INV_d.tile.x0[6]~input_o\ <= NOT \d.tile.x0[6]~input_o\;
\ALT_INV_d.clip_rect.x1[7]~input_o\ <= NOT \d.clip_rect.x1[7]~input_o\;
\ALT_INV_d.tile.x0[7]~input_o\ <= NOT \d.tile.x0[7]~input_o\;
\ALT_INV_d.clip_rect.x1[4]~input_o\ <= NOT \d.clip_rect.x1[4]~input_o\;
\ALT_INV_d.tile.x0[4]~input_o\ <= NOT \d.tile.x0[4]~input_o\;
\ALT_INV_d.clip_rect.x1[15]~input_o\ <= NOT \d.clip_rect.x1[15]~input_o\;
\ALT_INV_d.tile.x0[15]~input_o\ <= NOT \d.tile.x0[15]~input_o\;
\ALT_INV_d.clip_rect.x0[8]~input_o\ <= NOT \d.clip_rect.x0[8]~input_o\;
\ALT_INV_d.tile.x1[8]~input_o\ <= NOT \d.tile.x1[8]~input_o\;
\ALT_INV_d.clip_rect.x0[10]~input_o\ <= NOT \d.clip_rect.x0[10]~input_o\;
\ALT_INV_d.tile.x1[10]~input_o\ <= NOT \d.tile.x1[10]~input_o\;
\ALT_INV_d.clip_rect.x0[9]~input_o\ <= NOT \d.clip_rect.x0[9]~input_o\;
\ALT_INV_d.tile.x1[9]~input_o\ <= NOT \d.tile.x1[9]~input_o\;
\ALT_INV_d.clip_rect.x0[11]~input_o\ <= NOT \d.clip_rect.x0[11]~input_o\;
\ALT_INV_d.tile.x1[11]~input_o\ <= NOT \d.tile.x1[11]~input_o\;
\ALT_INV_d.clip_rect.x0[12]~input_o\ <= NOT \d.clip_rect.x0[12]~input_o\;
\ALT_INV_d.tile.x1[12]~input_o\ <= NOT \d.tile.x1[12]~input_o\;
\ALT_INV_d.clip_rect.x0[13]~input_o\ <= NOT \d.clip_rect.x0[13]~input_o\;
\ALT_INV_d.tile.x1[13]~input_o\ <= NOT \d.tile.x1[13]~input_o\;
\ALT_INV_d.clip_rect.x0[14]~input_o\ <= NOT \d.clip_rect.x0[14]~input_o\;
\ALT_INV_d.tile.x1[14]~input_o\ <= NOT \d.tile.x1[14]~input_o\;
\ALT_INV_d.clip_rect.x0[2]~input_o\ <= NOT \d.clip_rect.x0[2]~input_o\;
\ALT_INV_d.tile.x1[2]~input_o\ <= NOT \d.tile.x1[2]~input_o\;
\ALT_INV_d.clip_rect.x0[3]~input_o\ <= NOT \d.clip_rect.x0[3]~input_o\;
\ALT_INV_d.tile.x1[3]~input_o\ <= NOT \d.tile.x1[3]~input_o\;
\ALT_INV_d.clip_rect.x0[0]~input_o\ <= NOT \d.clip_rect.x0[0]~input_o\;
\ALT_INV_d.tile.x1[0]~input_o\ <= NOT \d.tile.x1[0]~input_o\;
\ALT_INV_d.clip_rect.x0[1]~input_o\ <= NOT \d.clip_rect.x0[1]~input_o\;
\ALT_INV_d.tile.x1[1]~input_o\ <= NOT \d.tile.x1[1]~input_o\;
\ALT_INV_d.clip_rect.x0[5]~input_o\ <= NOT \d.clip_rect.x0[5]~input_o\;
\ALT_INV_d.tile.x1[5]~input_o\ <= NOT \d.tile.x1[5]~input_o\;
\ALT_INV_d.clip_rect.x0[6]~input_o\ <= NOT \d.clip_rect.x0[6]~input_o\;
\ALT_INV_d.tile.x1[6]~input_o\ <= NOT \d.tile.x1[6]~input_o\;
\ALT_INV_d.clip_rect.x0[7]~input_o\ <= NOT \d.clip_rect.x0[7]~input_o\;
\ALT_INV_d.tile.x1[7]~input_o\ <= NOT \d.tile.x1[7]~input_o\;
\ALT_INV_d.clip_rect.x0[4]~input_o\ <= NOT \d.clip_rect.x0[4]~input_o\;
\ALT_INV_d.tile.x1[4]~input_o\ <= NOT \d.tile.x1[4]~input_o\;
\ALT_INV_d.clip_rect.x0[15]~input_o\ <= NOT \d.clip_rect.x0[15]~input_o\;
\ALT_INV_d.tile.x1[15]~input_o\ <= NOT \d.tile.x1[15]~input_o\;
\ALT_INV_d.clip_rect.y0[4]~input_o\ <= NOT \d.clip_rect.y0[4]~input_o\;
\ALT_INV_d.tile.y0[4]~input_o\ <= NOT \d.tile.y0[4]~input_o\;
\ALT_INV_d.clip_rect.y0[6]~input_o\ <= NOT \d.clip_rect.y0[6]~input_o\;
\ALT_INV_d.tile.y0[6]~input_o\ <= NOT \d.tile.y0[6]~input_o\;
\ALT_INV_d.clip_rect.y0[7]~input_o\ <= NOT \d.clip_rect.y0[7]~input_o\;
\ALT_INV_d.tile.y0[7]~input_o\ <= NOT \d.tile.y0[7]~input_o\;
\ALT_INV_d.clip_rect.y0[5]~input_o\ <= NOT \d.clip_rect.y0[5]~input_o\;
\ALT_INV_d.tile.y0[5]~input_o\ <= NOT \d.tile.y0[5]~input_o\;
\ALT_INV_d.clip_rect.y0[0]~input_o\ <= NOT \d.clip_rect.y0[0]~input_o\;
\ALT_INV_d.tile.y0[0]~input_o\ <= NOT \d.tile.y0[0]~input_o\;
\ALT_INV_d.clip_rect.y0[2]~input_o\ <= NOT \d.clip_rect.y0[2]~input_o\;
\ALT_INV_d.tile.y0[2]~input_o\ <= NOT \d.tile.y0[2]~input_o\;
\ALT_INV_d.clip_rect.y0[3]~input_o\ <= NOT \d.clip_rect.y0[3]~input_o\;
\ALT_INV_d.tile.y0[3]~input_o\ <= NOT \d.tile.y0[3]~input_o\;
\ALT_INV_d.clip_rect.y0[8]~input_o\ <= NOT \d.clip_rect.y0[8]~input_o\;
\ALT_INV_d.tile.y0[8]~input_o\ <= NOT \d.tile.y0[8]~input_o\;
\ALT_INV_d.clip_rect.y0[9]~input_o\ <= NOT \d.clip_rect.y0[9]~input_o\;
\ALT_INV_d.tile.y0[9]~input_o\ <= NOT \d.tile.y0[9]~input_o\;
\ALT_INV_d.clip_rect.y0[10]~input_o\ <= NOT \d.clip_rect.y0[10]~input_o\;
\ALT_INV_d.tile.y0[10]~input_o\ <= NOT \d.tile.y0[10]~input_o\;
\ALT_INV_d.clip_rect.y0[12]~input_o\ <= NOT \d.clip_rect.y0[12]~input_o\;
\ALT_INV_d.tile.y0[12]~input_o\ <= NOT \d.tile.y0[12]~input_o\;
\ALT_INV_d.clip_rect.y0[13]~input_o\ <= NOT \d.clip_rect.y0[13]~input_o\;
\ALT_INV_d.tile.y0[13]~input_o\ <= NOT \d.tile.y0[13]~input_o\;
\ALT_INV_d.clip_rect.y0[14]~input_o\ <= NOT \d.clip_rect.y0[14]~input_o\;
\ALT_INV_d.tile.y0[14]~input_o\ <= NOT \d.tile.y0[14]~input_o\;
\ALT_INV_d.clip_rect.y0[11]~input_o\ <= NOT \d.clip_rect.y0[11]~input_o\;
\ALT_INV_d.tile.y0[11]~input_o\ <= NOT \d.tile.y0[11]~input_o\;
\ALT_INV_d.clip_rect.y0[15]~input_o\ <= NOT \d.clip_rect.y0[15]~input_o\;
\ALT_INV_d.tile.y0[15]~input_o\ <= NOT \d.tile.y0[15]~input_o\;
\ALT_INV_d.tile.y0[1]~input_o\ <= NOT \d.tile.y0[1]~input_o\;
\ALT_INV_d.clip_rect.y0[1]~input_o\ <= NOT \d.clip_rect.y0[1]~input_o\;
\ALT_INV_v~149_combout\ <= NOT \v~149_combout\;
\ALT_INV_v~148_combout\ <= NOT \v~148_combout\;
\ALT_INV_v~147_combout\ <= NOT \v~147_combout\;
\ALT_INV_v~146_combout\ <= NOT \v~146_combout\;
\ALT_INV_v~145_combout\ <= NOT \v~145_combout\;
\ALT_INV_v~144_combout\ <= NOT \v~144_combout\;
\ALT_INV_v~143_combout\ <= NOT \v~143_combout\;
\ALT_INV_v~142_combout\ <= NOT \v~142_combout\;
\ALT_INV_v~141_combout\ <= NOT \v~141_combout\;
\ALT_INV_v~140_combout\ <= NOT \v~140_combout\;
\ALT_INV_v~139_combout\ <= NOT \v~139_combout\;
\ALT_INV_v~138_combout\ <= NOT \v~138_combout\;
\ALT_INV_v~137_combout\ <= NOT \v~137_combout\;
\ALT_INV_v~136_combout\ <= NOT \v~136_combout\;
\ALT_INV_v~135_combout\ <= NOT \v~135_combout\;
\ALT_INV_v~134_combout\ <= NOT \v~134_combout\;
\ALT_INV_v~133_combout\ <= NOT \v~133_combout\;
\ALT_INV_v~132_combout\ <= NOT \v~132_combout\;
\ALT_INV_LessThan8~15_combout\ <= NOT \LessThan8~15_combout\;
\ALT_INV_v~130_combout\ <= NOT \v~130_combout\;
\ALT_INV_v~128_combout\ <= NOT \v~128_combout\;
\ALT_INV_LessThan9~17_combout\ <= NOT \LessThan9~17_combout\;
\ALT_INV_LessThan9~16_combout\ <= NOT \LessThan9~16_combout\;
\ALT_INV_v~126_combout\ <= NOT \v~126_combout\;
\ALT_INV_LessThan9~15_combout\ <= NOT \LessThan9~15_combout\;
\ALT_INV_LessThan9~14_combout\ <= NOT \LessThan9~14_combout\;
\ALT_INV_LessThan9~13_combout\ <= NOT \LessThan9~13_combout\;
\ALT_INV_LessThan9~12_combout\ <= NOT \LessThan9~12_combout\;
\ALT_INV_LessThan9~11_combout\ <= NOT \LessThan9~11_combout\;
\ALT_INV_LessThan9~10_combout\ <= NOT \LessThan9~10_combout\;
\ALT_INV_v~125_combout\ <= NOT \v~125_combout\;
\ALT_INV_v~124_combout\ <= NOT \v~124_combout\;
\ALT_INV_v~123_combout\ <= NOT \v~123_combout\;
\ALT_INV_LessThan9~9_combout\ <= NOT \LessThan9~9_combout\;
\ALT_INV_LessThan9~8_combout\ <= NOT \LessThan9~8_combout\;
\ALT_INV_v~122_combout\ <= NOT \v~122_combout\;
\ALT_INV_v~121_combout\ <= NOT \v~121_combout\;
\ALT_INV_v~120_combout\ <= NOT \v~120_combout\;
\ALT_INV_LessThan9~7_combout\ <= NOT \LessThan9~7_combout\;
\ALT_INV_v~119_combout\ <= NOT \v~119_combout\;
\ALT_INV_v~118_combout\ <= NOT \v~118_combout\;
\ALT_INV_LessThan9~6_combout\ <= NOT \LessThan9~6_combout\;
\ALT_INV_v~117_combout\ <= NOT \v~117_combout\;
\ALT_INV_LessThan9~5_combout\ <= NOT \LessThan9~5_combout\;
\ALT_INV_v~116_combout\ <= NOT \v~116_combout\;
\ALT_INV_LessThan9~4_combout\ <= NOT \LessThan9~4_combout\;
\ALT_INV_LessThan9~3_combout\ <= NOT \LessThan9~3_combout\;
\ALT_INV_LessThan9~2_combout\ <= NOT \LessThan9~2_combout\;
\ALT_INV_LessThan9~1_combout\ <= NOT \LessThan9~1_combout\;
\ALT_INV_v~115_combout\ <= NOT \v~115_combout\;
\ALT_INV_LessThan9~0_combout\ <= NOT \LessThan9~0_combout\;
\ALT_INV_v~114_combout\ <= NOT \v~114_combout\;
\ALT_INV_v~113_combout\ <= NOT \v~113_combout\;
\ALT_INV_v~112_combout\ <= NOT \v~112_combout\;
\ALT_INV_LessThan7~14_combout\ <= NOT \LessThan7~14_combout\;
\ALT_INV_LessThan7~13_combout\ <= NOT \LessThan7~13_combout\;
\ALT_INV_LessThan7~12_combout\ <= NOT \LessThan7~12_combout\;
\ALT_INV_LessThan7~11_combout\ <= NOT \LessThan7~11_combout\;
\ALT_INV_LessThan7~10_combout\ <= NOT \LessThan7~10_combout\;
\ALT_INV_LessThan7~9_combout\ <= NOT \LessThan7~9_combout\;
\ALT_INV_LessThan7~8_combout\ <= NOT \LessThan7~8_combout\;
\ALT_INV_LessThan7~7_combout\ <= NOT \LessThan7~7_combout\;
\ALT_INV_LessThan7~6_combout\ <= NOT \LessThan7~6_combout\;
\ALT_INV_LessThan7~5_combout\ <= NOT \LessThan7~5_combout\;
\ALT_INV_LessThan7~4_combout\ <= NOT \LessThan7~4_combout\;
\ALT_INV_LessThan7~3_combout\ <= NOT \LessThan7~3_combout\;
\ALT_INV_LessThan7~2_combout\ <= NOT \LessThan7~2_combout\;
\ALT_INV_LessThan7~1_combout\ <= NOT \LessThan7~1_combout\;
\ALT_INV_LessThan7~0_combout\ <= NOT \LessThan7~0_combout\;
\ALT_INV_LessThan8~14_combout\ <= NOT \LessThan8~14_combout\;
\ALT_INV_LessThan8~13_combout\ <= NOT \LessThan8~13_combout\;
\ALT_INV_LessThan8~12_combout\ <= NOT \LessThan8~12_combout\;
\ALT_INV_LessThan8~11_combout\ <= NOT \LessThan8~11_combout\;
\ALT_INV_LessThan8~10_combout\ <= NOT \LessThan8~10_combout\;
\ALT_INV_LessThan8~9_combout\ <= NOT \LessThan8~9_combout\;
\ALT_INV_LessThan8~8_combout\ <= NOT \LessThan8~8_combout\;
\ALT_INV_v~111_combout\ <= NOT \v~111_combout\;
\ALT_INV_v~110_combout\ <= NOT \v~110_combout\;
\ALT_INV_v~109_combout\ <= NOT \v~109_combout\;
\ALT_INV_v~108_combout\ <= NOT \v~108_combout\;
\ALT_INV_v~107_combout\ <= NOT \v~107_combout\;
\ALT_INV_LessThan8~7_combout\ <= NOT \LessThan8~7_combout\;
\ALT_INV_v~106_combout\ <= NOT \v~106_combout\;
\ALT_INV_v~105_combout\ <= NOT \v~105_combout\;
\ALT_INV_v~104_combout\ <= NOT \v~104_combout\;
\ALT_INV_v~103_combout\ <= NOT \v~103_combout\;
\ALT_INV_LessThan8~6_combout\ <= NOT \LessThan8~6_combout\;
\ALT_INV_LessThan8~5_combout\ <= NOT \LessThan8~5_combout\;
\ALT_INV_LessThan8~4_combout\ <= NOT \LessThan8~4_combout\;
\ALT_INV_v~102_combout\ <= NOT \v~102_combout\;
\ALT_INV_LessThan8~3_combout\ <= NOT \LessThan8~3_combout\;
\ALT_INV_LessThan8~2_combout\ <= NOT \LessThan8~2_combout\;
\ALT_INV_v~101_combout\ <= NOT \v~101_combout\;
\ALT_INV_v~100_combout\ <= NOT \v~100_combout\;
\ALT_INV_LessThan8~1_combout\ <= NOT \LessThan8~1_combout\;
\ALT_INV_v~99_combout\ <= NOT \v~99_combout\;
\ALT_INV_LessThan8~0_combout\ <= NOT \LessThan8~0_combout\;
\ALT_INV_v~98_combout\ <= NOT \v~98_combout\;
\ALT_INV_v~97_combout\ <= NOT \v~97_combout\;
\ALT_INV_v~96_combout\ <= NOT \v~96_combout\;
\ALT_INV_LessThan6~14_combout\ <= NOT \LessThan6~14_combout\;
\ALT_INV_LessThan6~13_combout\ <= NOT \LessThan6~13_combout\;
\ALT_INV_LessThan6~12_combout\ <= NOT \LessThan6~12_combout\;
\ALT_INV_LessThan6~11_combout\ <= NOT \LessThan6~11_combout\;
\ALT_INV_LessThan6~10_combout\ <= NOT \LessThan6~10_combout\;
\ALT_INV_LessThan6~9_combout\ <= NOT \LessThan6~9_combout\;
\ALT_INV_LessThan6~8_combout\ <= NOT \LessThan6~8_combout\;
\ALT_INV_LessThan6~7_combout\ <= NOT \LessThan6~7_combout\;
\ALT_INV_LessThan6~6_combout\ <= NOT \LessThan6~6_combout\;
\ALT_INV_LessThan6~5_combout\ <= NOT \LessThan6~5_combout\;
\ALT_INV_LessThan6~4_combout\ <= NOT \LessThan6~4_combout\;
\ALT_INV_LessThan6~3_combout\ <= NOT \LessThan6~3_combout\;
\ALT_INV_LessThan6~2_combout\ <= NOT \LessThan6~2_combout\;
\ALT_INV_LessThan6~1_combout\ <= NOT \LessThan6~1_combout\;
\ALT_INV_LessThan6~0_combout\ <= NOT \LessThan6~0_combout\;
\ALT_INV_v~95_combout\ <= NOT \v~95_combout\;
\ALT_INV_v~93_combout\ <= NOT \v~93_combout\;
\ALT_INV_v~92_combout\ <= NOT \v~92_combout\;
\ALT_INV_v~90_combout\ <= NOT \v~90_combout\;
\ALT_INV_v~89_combout\ <= NOT \v~89_combout\;
\ALT_INV_v~87_combout\ <= NOT \v~87_combout\;
\ALT_INV_v~86_combout\ <= NOT \v~86_combout\;
\ALT_INV_v~84_combout\ <= NOT \v~84_combout\;
\ALT_INV_v~83_combout\ <= NOT \v~83_combout\;
\ALT_INV_v~81_combout\ <= NOT \v~81_combout\;
\ALT_INV_v~80_combout\ <= NOT \v~80_combout\;
\ALT_INV_v~78_combout\ <= NOT \v~78_combout\;
\ALT_INV_v~77_combout\ <= NOT \v~77_combout\;
\ALT_INV_v~75_combout\ <= NOT \v~75_combout\;
\ALT_INV_v~74_combout\ <= NOT \v~74_combout\;
\ALT_INV_v~72_combout\ <= NOT \v~72_combout\;
\ALT_INV_v~71_combout\ <= NOT \v~71_combout\;
\ALT_INV_v~69_combout\ <= NOT \v~69_combout\;
\ALT_INV_v~68_combout\ <= NOT \v~68_combout\;
\ALT_INV_v~66_combout\ <= NOT \v~66_combout\;
\ALT_INV_v~65_combout\ <= NOT \v~65_combout\;
\ALT_INV_v~63_combout\ <= NOT \v~63_combout\;
\ALT_INV_v~62_combout\ <= NOT \v~62_combout\;
\ALT_INV_v~60_combout\ <= NOT \v~60_combout\;
\ALT_INV_v~59_combout\ <= NOT \v~59_combout\;
\ALT_INV_v~57_combout\ <= NOT \v~57_combout\;
\ALT_INV_v~56_combout\ <= NOT \v~56_combout\;
\ALT_INV_v~54_combout\ <= NOT \v~54_combout\;
\ALT_INV_v~53_combout\ <= NOT \v~53_combout\;
\ALT_INV_v~51_combout\ <= NOT \v~51_combout\;
\ALT_INV_v~50_combout\ <= NOT \v~50_combout\;
\ALT_INV_v~49_combout\ <= NOT \v~49_combout\;
\ALT_INV_v~47_combout\ <= NOT \v~47_combout\;
\ALT_INV_v~46_combout\ <= NOT \v~46_combout\;
\ALT_INV_LessThan5~13_combout\ <= NOT \LessThan5~13_combout\;
\ALT_INV_LessThan5~12_combout\ <= NOT \LessThan5~12_combout\;
\ALT_INV_LessThan5~11_combout\ <= NOT \LessThan5~11_combout\;
\ALT_INV_LessThan5~10_combout\ <= NOT \LessThan5~10_combout\;
\ALT_INV_LessThan5~9_combout\ <= NOT \LessThan5~9_combout\;
\ALT_INV_LessThan5~8_combout\ <= NOT \LessThan5~8_combout\;
\ALT_INV_LessThan5~7_combout\ <= NOT \LessThan5~7_combout\;
\ALT_INV_LessThan5~6_combout\ <= NOT \LessThan5~6_combout\;
\ALT_INV_LessThan5~5_combout\ <= NOT \LessThan5~5_combout\;
\ALT_INV_LessThan5~4_combout\ <= NOT \LessThan5~4_combout\;
\ALT_INV_LessThan5~3_combout\ <= NOT \LessThan5~3_combout\;
\ALT_INV_LessThan5~2_combout\ <= NOT \LessThan5~2_combout\;
\ALT_INV_LessThan5~1_combout\ <= NOT \LessThan5~1_combout\;
\ALT_INV_LessThan5~0_combout\ <= NOT \LessThan5~0_combout\;
\ALT_INV_comb~4_combout\ <= NOT \comb~4_combout\;
\ALT_INV_comb~3_combout\ <= NOT \comb~3_combout\;
\ALT_INV_v~27_combout\ <= NOT \v~27_combout\;
\ALT_INV_v~25_combout\ <= NOT \v~25_combout\;
\ALT_INV_v~23_combout\ <= NOT \v~23_combout\;
\ALT_INV_v~21_combout\ <= NOT \v~21_combout\;
\ALT_INV_v~19_combout\ <= NOT \v~19_combout\;
\ALT_INV_v~17_combout\ <= NOT \v~17_combout\;
\ALT_INV_v~15_combout\ <= NOT \v~15_combout\;
\ALT_INV_v~13_combout\ <= NOT \v~13_combout\;
\ALT_INV_v~11_combout\ <= NOT \v~11_combout\;
\ALT_INV_v~9_combout\ <= NOT \v~9_combout\;
\ALT_INV_v~7_combout\ <= NOT \v~7_combout\;
\ALT_INV_v~5_combout\ <= NOT \v~5_combout\;
\ALT_INV_v~3_combout\ <= NOT \v~3_combout\;
\ALT_INV_v~1_combout\ <= NOT \v~1_combout\;
\ALT_INV_v~0_combout\ <= NOT \v~0_combout\;
\ALT_INV_comb~2_combout\ <= NOT \comb~2_combout\;
\ALT_INV_comb~1_combout\ <= NOT \comb~1_combout\;
\ALT_INV_LessThan3~19_combout\ <= NOT \LessThan3~19_combout\;
\ALT_INV_LessThan3~18_combout\ <= NOT \LessThan3~18_combout\;
\ALT_INV_LessThan3~17_combout\ <= NOT \LessThan3~17_combout\;
\ALT_INV_LessThan3~16_combout\ <= NOT \LessThan3~16_combout\;
\ALT_INV_LessThan3~15_combout\ <= NOT \LessThan3~15_combout\;
\ALT_INV_LessThan3~14_combout\ <= NOT \LessThan3~14_combout\;
\ALT_INV_LessThan3~13_combout\ <= NOT \LessThan3~13_combout\;
\ALT_INV_LessThan3~12_combout\ <= NOT \LessThan3~12_combout\;
\ALT_INV_LessThan3~11_combout\ <= NOT \LessThan3~11_combout\;
\ALT_INV_LessThan3~10_combout\ <= NOT \LessThan3~10_combout\;
\ALT_INV_LessThan3~9_combout\ <= NOT \LessThan3~9_combout\;
\ALT_INV_LessThan3~8_combout\ <= NOT \LessThan3~8_combout\;
\ALT_INV_LessThan3~7_combout\ <= NOT \LessThan3~7_combout\;
\ALT_INV_LessThan3~6_combout\ <= NOT \LessThan3~6_combout\;
\ALT_INV_LessThan3~5_combout\ <= NOT \LessThan3~5_combout\;
\ALT_INV_LessThan3~4_combout\ <= NOT \LessThan3~4_combout\;
\ALT_INV_LessThan3~3_combout\ <= NOT \LessThan3~3_combout\;
\ALT_INV_LessThan3~2_combout\ <= NOT \LessThan3~2_combout\;
\ALT_INV_LessThan3~1_combout\ <= NOT \LessThan3~1_combout\;
\ALT_INV_LessThan3~0_combout\ <= NOT \LessThan3~0_combout\;
\ALT_INV_LessThan2~17_combout\ <= NOT \LessThan2~17_combout\;
\ALT_INV_LessThan2~16_combout\ <= NOT \LessThan2~16_combout\;
\ALT_INV_LessThan2~15_combout\ <= NOT \LessThan2~15_combout\;
\ALT_INV_LessThan2~14_combout\ <= NOT \LessThan2~14_combout\;
\ALT_INV_LessThan2~13_combout\ <= NOT \LessThan2~13_combout\;
\ALT_INV_LessThan2~12_combout\ <= NOT \LessThan2~12_combout\;
\ALT_INV_LessThan2~11_combout\ <= NOT \LessThan2~11_combout\;
\ALT_INV_LessThan2~10_combout\ <= NOT \LessThan2~10_combout\;
\ALT_INV_LessThan2~9_combout\ <= NOT \LessThan2~9_combout\;
\ALT_INV_LessThan2~8_combout\ <= NOT \LessThan2~8_combout\;
\ALT_INV_LessThan2~7_combout\ <= NOT \LessThan2~7_combout\;
\ALT_INV_LessThan2~6_combout\ <= NOT \LessThan2~6_combout\;
\ALT_INV_LessThan2~5_combout\ <= NOT \LessThan2~5_combout\;
\ALT_INV_LessThan2~4_combout\ <= NOT \LessThan2~4_combout\;
\ALT_INV_LessThan2~3_combout\ <= NOT \LessThan2~3_combout\;
\ALT_INV_LessThan2~2_combout\ <= NOT \LessThan2~2_combout\;
\ALT_INV_LessThan2~1_combout\ <= NOT \LessThan2~1_combout\;
\ALT_INV_LessThan2~0_combout\ <= NOT \LessThan2~0_combout\;
\ALT_INV_LessThan1~17_combout\ <= NOT \LessThan1~17_combout\;
\ALT_INV_LessThan1~16_combout\ <= NOT \LessThan1~16_combout\;
\ALT_INV_LessThan1~15_combout\ <= NOT \LessThan1~15_combout\;
\ALT_INV_LessThan1~14_combout\ <= NOT \LessThan1~14_combout\;
\ALT_INV_LessThan1~13_combout\ <= NOT \LessThan1~13_combout\;
\ALT_INV_LessThan1~12_combout\ <= NOT \LessThan1~12_combout\;
\ALT_INV_LessThan1~11_combout\ <= NOT \LessThan1~11_combout\;
\ALT_INV_LessThan1~10_combout\ <= NOT \LessThan1~10_combout\;
\ALT_INV_LessThan1~9_combout\ <= NOT \LessThan1~9_combout\;
\ALT_INV_LessThan1~8_combout\ <= NOT \LessThan1~8_combout\;
\ALT_INV_LessThan1~7_combout\ <= NOT \LessThan1~7_combout\;
\ALT_INV_LessThan1~6_combout\ <= NOT \LessThan1~6_combout\;
\ALT_INV_LessThan1~5_combout\ <= NOT \LessThan1~5_combout\;
\ALT_INV_LessThan1~4_combout\ <= NOT \LessThan1~4_combout\;
\ALT_INV_LessThan1~3_combout\ <= NOT \LessThan1~3_combout\;
\ALT_INV_LessThan1~2_combout\ <= NOT \LessThan1~2_combout\;
\ALT_INV_LessThan1~1_combout\ <= NOT \LessThan1~1_combout\;
\ALT_INV_LessThan1~0_combout\ <= NOT \LessThan1~0_combout\;
\ALT_INV_LessThan0~17_combout\ <= NOT \LessThan0~17_combout\;
\ALT_INV_LessThan0~16_combout\ <= NOT \LessThan0~16_combout\;
\ALT_INV_LessThan0~15_combout\ <= NOT \LessThan0~15_combout\;
\ALT_INV_LessThan0~14_combout\ <= NOT \LessThan0~14_combout\;
\ALT_INV_LessThan0~13_combout\ <= NOT \LessThan0~13_combout\;
\ALT_INV_LessThan0~12_combout\ <= NOT \LessThan0~12_combout\;
\ALT_INV_LessThan0~11_combout\ <= NOT \LessThan0~11_combout\;
\ALT_INV_LessThan0~10_combout\ <= NOT \LessThan0~10_combout\;
\ALT_INV_LessThan0~9_combout\ <= NOT \LessThan0~9_combout\;
\ALT_INV_LessThan0~8_combout\ <= NOT \LessThan0~8_combout\;
\ALT_INV_LessThan0~7_combout\ <= NOT \LessThan0~7_combout\;
\ALT_INV_LessThan0~6_combout\ <= NOT \LessThan0~6_combout\;
\ALT_INV_LessThan0~5_combout\ <= NOT \LessThan0~5_combout\;
\ALT_INV_LessThan0~4_combout\ <= NOT \LessThan0~4_combout\;
\ALT_INV_LessThan0~3_combout\ <= NOT \LessThan0~3_combout\;
\ALT_INV_LessThan0~2_combout\ <= NOT \LessThan0~2_combout\;
\ALT_INV_LessThan0~1_combout\ <= NOT \LessThan0~1_combout\;
\ALT_INV_LessThan0~0_combout\ <= NOT \LessThan0~0_combout\;
\ALT_INV_LessThan4~14_combout\ <= NOT \LessThan4~14_combout\;
\ALT_INV_LessThan4~13_combout\ <= NOT \LessThan4~13_combout\;
\ALT_INV_LessThan4~12_combout\ <= NOT \LessThan4~12_combout\;
\ALT_INV_LessThan4~11_combout\ <= NOT \LessThan4~11_combout\;
\ALT_INV_LessThan4~10_combout\ <= NOT \LessThan4~10_combout\;
\ALT_INV_LessThan4~9_combout\ <= NOT \LessThan4~9_combout\;
\ALT_INV_LessThan4~8_combout\ <= NOT \LessThan4~8_combout\;
\ALT_INV_LessThan4~7_combout\ <= NOT \LessThan4~7_combout\;
\ALT_INV_LessThan4~6_combout\ <= NOT \LessThan4~6_combout\;
\ALT_INV_LessThan4~5_combout\ <= NOT \LessThan4~5_combout\;
\ALT_INV_LessThan4~4_combout\ <= NOT \LessThan4~4_combout\;
\ALT_INV_LessThan4~3_combout\ <= NOT \LessThan4~3_combout\;
\ALT_INV_LessThan4~2_combout\ <= NOT \LessThan4~2_combout\;
\ALT_INV_LessThan4~1_combout\ <= NOT \LessThan4~1_combout\;
\ALT_INV_LessThan4~0_combout\ <= NOT \LessThan4~0_combout\;
\ALT_INV_comb~0_combout\ <= NOT \comb~0_combout\;
\ALT_INV_r.end_tile~q\ <= NOT \r.end_tile~q\;
\ALT_INV_r.next_quad~q\ <= NOT \r.next_quad~q\;
\ALT_INV_r.x0\(15) <= NOT \r.x0\(15);
\ALT_INV_r.x0\(14) <= NOT \r.x0\(14);
\ALT_INV_r.x0\(13) <= NOT \r.x0\(13);
\ALT_INV_r.x0\(12) <= NOT \r.x0\(12);
\ALT_INV_r.x0\(11) <= NOT \r.x0\(11);
\ALT_INV_r.x0\(10) <= NOT \r.x0\(10);
\ALT_INV_r.x0\(9) <= NOT \r.x0\(9);
\ALT_INV_r.x0\(8) <= NOT \r.x0\(8);
\ALT_INV_r.x0\(7) <= NOT \r.x0\(7);
\ALT_INV_r.x0\(6) <= NOT \r.x0\(6);
\ALT_INV_r.x0\(5) <= NOT \r.x0\(5);
\ALT_INV_r.x0\(4) <= NOT \r.x0\(4);
\ALT_INV_r.x0\(3) <= NOT \r.x0\(3);
\ALT_INV_r.x0\(2) <= NOT \r.x0\(2);
\ALT_INV_r.x0\(1) <= NOT \r.x0\(1);
\ALT_INV_r.y1\(6) <= NOT \r.y1\(6);
\ALT_INV_Add3~57_sumout\ <= NOT \Add3~57_sumout\;
\ALT_INV_r.y1\(7) <= NOT \r.y1\(7);
\ALT_INV_Add3~53_sumout\ <= NOT \Add3~53_sumout\;
\ALT_INV_r.y1\(8) <= NOT \r.y1\(8);
\ALT_INV_Add3~49_sumout\ <= NOT \Add3~49_sumout\;
\ALT_INV_r.y1\(1) <= NOT \r.y1\(1);
\ALT_INV_Add3~45_sumout\ <= NOT \Add3~45_sumout\;
\ALT_INV_r.y1\(2) <= NOT \r.y1\(2);
\ALT_INV_Add3~41_sumout\ <= NOT \Add3~41_sumout\;
\ALT_INV_r.y1\(3) <= NOT \r.y1\(3);
\ALT_INV_Add3~37_sumout\ <= NOT \Add3~37_sumout\;
\ALT_INV_r.y1\(4) <= NOT \r.y1\(4);
\ALT_INV_Add3~33_sumout\ <= NOT \Add3~33_sumout\;
\ALT_INV_r.y1\(5) <= NOT \r.y1\(5);
\ALT_INV_Add3~29_sumout\ <= NOT \Add3~29_sumout\;
\ALT_INV_r.y1\(9) <= NOT \r.y1\(9);
\ALT_INV_Add3~25_sumout\ <= NOT \Add3~25_sumout\;
\ALT_INV_r.y1\(10) <= NOT \r.y1\(10);
\ALT_INV_Add3~21_sumout\ <= NOT \Add3~21_sumout\;
\ALT_INV_r.y1\(11) <= NOT \r.y1\(11);
\ALT_INV_Add3~17_sumout\ <= NOT \Add3~17_sumout\;
\ALT_INV_r.y1\(13) <= NOT \r.y1\(13);
\ALT_INV_Add3~13_sumout\ <= NOT \Add3~13_sumout\;
\ALT_INV_r.y1\(14) <= NOT \r.y1\(14);
\ALT_INV_Add3~9_sumout\ <= NOT \Add3~9_sumout\;
\ALT_INV_r.y1\(15) <= NOT \r.y1\(15);
\ALT_INV_Add3~5_sumout\ <= NOT \Add3~5_sumout\;
\ALT_INV_r.y1\(12) <= NOT \r.y1\(12);
\ALT_INV_Add3~1_sumout\ <= NOT \Add3~1_sumout\;
\ALT_INV_r.x1\(0) <= NOT \r.x1\(0);
\ALT_INV_r.x1\(1) <= NOT \r.x1\(1);
\ALT_INV_Add2~57_sumout\ <= NOT \Add2~57_sumout\;
\ALT_INV_r.x1\(2) <= NOT \r.x1\(2);
\ALT_INV_Add2~53_sumout\ <= NOT \Add2~53_sumout\;
\ALT_INV_r.x1\(3) <= NOT \r.x1\(3);
\ALT_INV_Add2~49_sumout\ <= NOT \Add2~49_sumout\;
\ALT_INV_r.x1\(5) <= NOT \r.x1\(5);
\ALT_INV_Add2~45_sumout\ <= NOT \Add2~45_sumout\;
\ALT_INV_r.x1\(6) <= NOT \r.x1\(6);
\ALT_INV_Add2~41_sumout\ <= NOT \Add2~41_sumout\;
\ALT_INV_r.x1\(7) <= NOT \r.x1\(7);
\ALT_INV_Add2~37_sumout\ <= NOT \Add2~37_sumout\;
\ALT_INV_r.x1\(4) <= NOT \r.x1\(4);
\ALT_INV_Add2~33_sumout\ <= NOT \Add2~33_sumout\;
\ALT_INV_r.x1\(8) <= NOT \r.x1\(8);
\ALT_INV_Add2~29_sumout\ <= NOT \Add2~29_sumout\;
\ALT_INV_r.x1\(10) <= NOT \r.x1\(10);
\ALT_INV_Add2~25_sumout\ <= NOT \Add2~25_sumout\;
\ALT_INV_r.x1\(9) <= NOT \r.x1\(9);
\ALT_INV_Add2~21_sumout\ <= NOT \Add2~21_sumout\;
\ALT_INV_r.x1\(11) <= NOT \r.x1\(11);
\ALT_INV_Add2~17_sumout\ <= NOT \Add2~17_sumout\;
\ALT_INV_r.x1\(12) <= NOT \r.x1\(12);
\ALT_INV_Add2~13_sumout\ <= NOT \Add2~13_sumout\;
\ALT_INV_r.x1\(13) <= NOT \r.x1\(13);
\ALT_INV_Add2~9_sumout\ <= NOT \Add2~9_sumout\;
\ALT_INV_r.x1\(14) <= NOT \r.x1\(14);
\ALT_INV_Add2~5_sumout\ <= NOT \Add2~5_sumout\;
\ALT_INV_r.x1\(15) <= NOT \r.x1\(15);
\ALT_INV_Add2~1_sumout\ <= NOT \Add2~1_sumout\;
\ALT_INV_r.quad.x0\(15) <= NOT \r.quad.x0\(15);
\ALT_INV_r.j\(15) <= NOT \r.j\(15);
\ALT_INV_r.quad.x0\(14) <= NOT \r.quad.x0\(14);
\ALT_INV_r.j\(14) <= NOT \r.j\(14);
\ALT_INV_r.quad.x0\(13) <= NOT \r.quad.x0\(13);
\ALT_INV_r.j\(13) <= NOT \r.j\(13);
\ALT_INV_r.quad.x0\(12) <= NOT \r.quad.x0\(12);
\ALT_INV_r.j\(12) <= NOT \r.j\(12);
\ALT_INV_r.quad.x0\(11) <= NOT \r.quad.x0\(11);
\ALT_INV_r.j\(11) <= NOT \r.j\(11);
\ALT_INV_r.quad.x0\(10) <= NOT \r.quad.x0\(10);
\ALT_INV_r.j\(10) <= NOT \r.j\(10);
\ALT_INV_r.quad.x0\(9) <= NOT \r.quad.x0\(9);
\ALT_INV_r.j\(9) <= NOT \r.j\(9);
\ALT_INV_r.quad.x0\(8) <= NOT \r.quad.x0\(8);
\ALT_INV_r.j\(8) <= NOT \r.j\(8);
\ALT_INV_r.quad.x0\(7) <= NOT \r.quad.x0\(7);
\ALT_INV_r.j\(7) <= NOT \r.j\(7);
\ALT_INV_r.quad.x0\(6) <= NOT \r.quad.x0\(6);
\ALT_INV_r.j\(6) <= NOT \r.j\(6);
\ALT_INV_r.quad.x0\(5) <= NOT \r.quad.x0\(5);
\ALT_INV_r.j\(5) <= NOT \r.j\(5);
\ALT_INV_r.quad.x0\(4) <= NOT \r.quad.x0\(4);
\ALT_INV_r.j\(4) <= NOT \r.j\(4);
\ALT_INV_r.quad.x0\(3) <= NOT \r.quad.x0\(3);
\ALT_INV_r.j\(3) <= NOT \r.j\(3);
\ALT_INV_r.quad.x0\(2) <= NOT \r.quad.x0\(2);
\ALT_INV_r.j\(2) <= NOT \r.j\(2);
\ALT_INV_r.quad.x0\(1) <= NOT \r.quad.x0\(1);
\ALT_INV_r.j\(1) <= NOT \r.j\(1);
\ALT_INV_r.quad.x0\(0) <= NOT \r.quad.x0\(0);
\ALT_INV_r.j\(0) <= NOT \r.j\(0);
\ALT_INV_r.quad.x1\(15) <= NOT \r.quad.x1\(15);
\ALT_INV_Add0~61_sumout\ <= NOT \Add0~61_sumout\;
\ALT_INV_r.quad.x1\(14) <= NOT \r.quad.x1\(14);
\ALT_INV_Add0~57_sumout\ <= NOT \Add0~57_sumout\;
\ALT_INV_r.quad.x1\(13) <= NOT \r.quad.x1\(13);
\ALT_INV_Add0~53_sumout\ <= NOT \Add0~53_sumout\;
\ALT_INV_r.quad.x1\(12) <= NOT \r.quad.x1\(12);
\ALT_INV_Add0~49_sumout\ <= NOT \Add0~49_sumout\;
\ALT_INV_r.quad.x1\(11) <= NOT \r.quad.x1\(11);
\ALT_INV_Add0~45_sumout\ <= NOT \Add0~45_sumout\;
\ALT_INV_r.quad.x1\(10) <= NOT \r.quad.x1\(10);
\ALT_INV_Add0~41_sumout\ <= NOT \Add0~41_sumout\;
\ALT_INV_r.quad.x1\(9) <= NOT \r.quad.x1\(9);
\ALT_INV_Add0~37_sumout\ <= NOT \Add0~37_sumout\;
\ALT_INV_r.quad.x1\(8) <= NOT \r.quad.x1\(8);
\ALT_INV_Add0~33_sumout\ <= NOT \Add0~33_sumout\;
\ALT_INV_r.quad.x1\(7) <= NOT \r.quad.x1\(7);
\ALT_INV_Add0~29_sumout\ <= NOT \Add0~29_sumout\;
\ALT_INV_r.quad.x1\(6) <= NOT \r.quad.x1\(6);
\ALT_INV_Add0~25_sumout\ <= NOT \Add0~25_sumout\;
\ALT_INV_r.quad.x1\(5) <= NOT \r.quad.x1\(5);
\ALT_INV_Add0~21_sumout\ <= NOT \Add0~21_sumout\;
\ALT_INV_r.quad.x1\(4) <= NOT \r.quad.x1\(4);
\ALT_INV_Add0~17_sumout\ <= NOT \Add0~17_sumout\;
\ALT_INV_r.quad.x1\(3) <= NOT \r.quad.x1\(3);
\ALT_INV_Add0~13_sumout\ <= NOT \Add0~13_sumout\;
\ALT_INV_r.quad.x1\(2) <= NOT \r.quad.x1\(2);
\ALT_INV_Add0~9_sumout\ <= NOT \Add0~9_sumout\;
\ALT_INV_r.quad.x1\(1) <= NOT \r.quad.x1\(1);
\ALT_INV_Add0~5_sumout\ <= NOT \Add0~5_sumout\;
\ALT_INV_r.quad.x1\(0) <= NOT \r.quad.x1\(0);
\ALT_INV_Add0~1_sumout\ <= NOT \Add0~1_sumout\;
\ALT_INV_r.quad.y0\(15) <= NOT \r.quad.y0\(15);
\ALT_INV_r.i\(15) <= NOT \r.i\(15);
\ALT_INV_r.quad.y0\(14) <= NOT \r.quad.y0\(14);
\ALT_INV_r.i\(14) <= NOT \r.i\(14);
\ALT_INV_r.quad.y0\(13) <= NOT \r.quad.y0\(13);
\ALT_INV_r.i\(13) <= NOT \r.i\(13);
\ALT_INV_r.quad.y0\(12) <= NOT \r.quad.y0\(12);
\ALT_INV_r.i\(12) <= NOT \r.i\(12);
\ALT_INV_r.quad.y0\(11) <= NOT \r.quad.y0\(11);
\ALT_INV_r.i\(11) <= NOT \r.i\(11);
\ALT_INV_r.quad.y0\(10) <= NOT \r.quad.y0\(10);
\ALT_INV_r.i\(10) <= NOT \r.i\(10);
\ALT_INV_r.quad.y0\(9) <= NOT \r.quad.y0\(9);
\ALT_INV_r.i\(9) <= NOT \r.i\(9);
\ALT_INV_r.quad.y0\(8) <= NOT \r.quad.y0\(8);
\ALT_INV_r.i\(8) <= NOT \r.i\(8);
\ALT_INV_r.quad.y0\(7) <= NOT \r.quad.y0\(7);
\ALT_INV_r.i\(7) <= NOT \r.i\(7);
\ALT_INV_r.quad.y0\(6) <= NOT \r.quad.y0\(6);
\ALT_INV_r.i\(6) <= NOT \r.i\(6);
\ALT_INV_r.quad.y0\(5) <= NOT \r.quad.y0\(5);
\ALT_INV_r.i\(5) <= NOT \r.i\(5);
\ALT_INV_r.quad.y0\(4) <= NOT \r.quad.y0\(4);
\ALT_INV_r.i\(4) <= NOT \r.i\(4);
\ALT_INV_r.quad.y0\(3) <= NOT \r.quad.y0\(3);
\ALT_INV_r.i\(3) <= NOT \r.i\(3);
\ALT_INV_r.quad.y0\(2) <= NOT \r.quad.y0\(2);
\ALT_INV_r.i\(2) <= NOT \r.i\(2);
\ALT_INV_r.quad.y0\(1) <= NOT \r.quad.y0\(1);
\ALT_INV_r.i\(1) <= NOT \r.i\(1);
\ALT_INV_r.generate_quads~q\ <= NOT \r.generate_quads~q\;

-- Location: IOOBUF_X4_Y81_N2
\q.quad.y3[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(0));

-- Location: IOOBUF_X14_Y0_N36
\q.quad.y3[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~2_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(1));

-- Location: IOOBUF_X6_Y81_N36
\q.quad.y3[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~4_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(2));

-- Location: IOOBUF_X14_Y0_N53
\q.quad.y3[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~6_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(3));

-- Location: IOOBUF_X30_Y0_N2
\q.quad.y3[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~8_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(4));

-- Location: IOOBUF_X20_Y81_N53
\q.quad.y3[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~10_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(5));

-- Location: IOOBUF_X80_Y0_N36
\q.quad.y3[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~12_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(6));

-- Location: IOOBUF_X34_Y0_N42
\q.quad.y3[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~14_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(7));

-- Location: IOOBUF_X18_Y0_N76
\q.quad.y3[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~16_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(8));

-- Location: IOOBUF_X10_Y0_N59
\q.quad.y3[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~18_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(9));

-- Location: IOOBUF_X28_Y81_N53
\q.quad.y3[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~20_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(10));

-- Location: IOOBUF_X8_Y0_N2
\q.quad.y3[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~22_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(11));

-- Location: IOOBUF_X20_Y0_N53
\q.quad.y3[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~24_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(12));

-- Location: IOOBUF_X89_Y21_N22
\q.quad.y3[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~26_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(13));

-- Location: IOOBUF_X8_Y0_N53
\q.quad.y3[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~28_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(14));

-- Location: IOOBUF_X12_Y81_N2
\q.quad.y3[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~29_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y3\(15));

-- Location: IOOBUF_X22_Y81_N19
\q.quad.x3[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~30_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(0));

-- Location: IOOBUF_X89_Y20_N62
\q.quad.x3[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~31_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(1));

-- Location: IOOBUF_X6_Y0_N2
\q.quad.x3[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~32_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(2));

-- Location: IOOBUF_X52_Y0_N2
\q.quad.x3[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~33_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(3));

-- Location: IOOBUF_X16_Y0_N2
\q.quad.x3[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~34_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(4));

-- Location: IOOBUF_X84_Y0_N53
\q.quad.x3[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~35_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(5));

-- Location: IOOBUF_X26_Y81_N59
\q.quad.x3[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~36_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(6));

-- Location: IOOBUF_X12_Y81_N36
\q.quad.x3[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~37_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(7));

-- Location: IOOBUF_X32_Y0_N19
\q.quad.x3[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~38_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(8));

-- Location: IOOBUF_X89_Y4_N79
\q.quad.x3[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~39_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(9));

-- Location: IOOBUF_X82_Y0_N59
\q.quad.x3[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~40_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(10));

-- Location: IOOBUF_X88_Y0_N20
\q.quad.x3[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~41_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(11));

-- Location: IOOBUF_X30_Y0_N36
\q.quad.x3[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~42_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(12));

-- Location: IOOBUF_X89_Y21_N56
\q.quad.x3[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~43_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(13));

-- Location: IOOBUF_X89_Y4_N62
\q.quad.x3[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~44_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(14));

-- Location: IOOBUF_X34_Y81_N59
\q.quad.x3[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~45_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x3\(15));

-- Location: IOOBUF_X24_Y81_N53
\q.quad.y2[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(0));

-- Location: IOOBUF_X14_Y0_N2
\q.quad.y2[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~2_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(1));

-- Location: IOOBUF_X8_Y81_N2
\q.quad.y2[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~4_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(2));

-- Location: IOOBUF_X12_Y0_N2
\q.quad.y2[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~6_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(3));

-- Location: IOOBUF_X22_Y0_N2
\q.quad.y2[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~8_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(4));

-- Location: IOOBUF_X18_Y81_N59
\q.quad.y2[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~10_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(5));

-- Location: IOOBUF_X84_Y0_N2
\q.quad.y2[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~12_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(6));

-- Location: IOOBUF_X18_Y81_N76
\q.quad.y2[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~14_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(7));

-- Location: IOOBUF_X18_Y0_N59
\q.quad.y2[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~16_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(8));

-- Location: IOOBUF_X8_Y0_N36
\q.quad.y2[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~18_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(9));

-- Location: IOOBUF_X28_Y81_N36
\q.quad.y2[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~20_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(10));

-- Location: IOOBUF_X12_Y0_N36
\q.quad.y2[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~22_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(11));

-- Location: IOOBUF_X20_Y0_N36
\q.quad.y2[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~24_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(12));

-- Location: IOOBUF_X89_Y16_N39
\q.quad.y2[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~26_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(13));

-- Location: IOOBUF_X10_Y0_N42
\q.quad.y2[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~28_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(14));

-- Location: IOOBUF_X8_Y81_N19
\q.quad.y2[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~29_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y2\(15));

-- Location: IOOBUF_X86_Y0_N36
\q.quad.x2[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~48_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(0));

-- Location: IOOBUF_X26_Y81_N93
\q.quad.x2[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~52_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(1));

-- Location: IOOBUF_X30_Y0_N19
\q.quad.x2[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~55_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(2));

-- Location: IOOBUF_X4_Y81_N36
\q.quad.x2[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~58_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(3));

-- Location: IOOBUF_X34_Y81_N42
\q.quad.x2[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~61_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(4));

-- Location: IOOBUF_X14_Y81_N19
\q.quad.x2[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~64_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(5));

-- Location: IOOBUF_X22_Y0_N36
\q.quad.x2[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~67_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(6));

-- Location: IOOBUF_X16_Y81_N2
\q.quad.x2[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~70_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(7));

-- Location: IOOBUF_X16_Y0_N19
\q.quad.x2[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~73_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(8));

-- Location: IOOBUF_X34_Y0_N93
\q.quad.x2[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~76_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(9));

-- Location: IOOBUF_X30_Y81_N36
\q.quad.x2[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~79_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(10));

-- Location: IOOBUF_X26_Y0_N76
\q.quad.x2[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~82_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(11));

-- Location: IOOBUF_X58_Y0_N93
\q.quad.x2[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~85_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(12));

-- Location: IOOBUF_X89_Y25_N5
\q.quad.x2[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~88_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(13));

-- Location: IOOBUF_X32_Y0_N36
\q.quad.x2[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~91_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(14));

-- Location: IOOBUF_X40_Y81_N2
\q.quad.x2[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~94_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x2\(15));

-- Location: IOOBUF_X2_Y0_N42
\q.quad.y1[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(0));

-- Location: IOOBUF_X12_Y0_N53
\q.quad.y1[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~2_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(1));

-- Location: IOOBUF_X4_Y81_N53
\q.quad.y1[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~4_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(2));

-- Location: IOOBUF_X10_Y0_N93
\q.quad.y1[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~6_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(3));

-- Location: IOOBUF_X26_Y0_N93
\q.quad.y1[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~8_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(4));

-- Location: IOOBUF_X26_Y81_N42
\q.quad.y1[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~10_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(5));

-- Location: IOOBUF_X86_Y0_N2
\q.quad.y1[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~12_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(6));

-- Location: IOOBUF_X18_Y81_N93
\q.quad.y1[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~14_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(7));

-- Location: IOOBUF_X24_Y0_N2
\q.quad.y1[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~16_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(8));

-- Location: IOOBUF_X6_Y0_N19
\q.quad.y1[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~18_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(9));

-- Location: IOOBUF_X22_Y81_N53
\q.quad.y1[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~20_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(10));

-- Location: IOOBUF_X4_Y0_N2
\q.quad.y1[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~22_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(11));

-- Location: IOOBUF_X20_Y0_N19
\q.quad.y1[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~24_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(12));

-- Location: IOOBUF_X89_Y20_N96
\q.quad.y1[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~26_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(13));

-- Location: IOOBUF_X16_Y0_N36
\q.quad.y1[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~28_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(14));

-- Location: IOOBUF_X12_Y81_N53
\q.quad.y1[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~29_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y1\(15));

-- Location: IOOBUF_X24_Y81_N36
\q.quad.x1[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~30_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(0));

-- Location: IOOBUF_X89_Y20_N79
\q.quad.x1[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~31_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(1));

-- Location: IOOBUF_X6_Y0_N53
\q.quad.x1[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~32_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(2));

-- Location: IOOBUF_X50_Y0_N93
\q.quad.x1[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~33_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(3));

-- Location: IOOBUF_X18_Y0_N42
\q.quad.x1[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~34_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(4));

-- Location: IOOBUF_X88_Y0_N3
\q.quad.x1[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~35_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(5));

-- Location: IOOBUF_X32_Y81_N19
\q.quad.x1[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~36_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(6));

-- Location: IOOBUF_X16_Y81_N19
\q.quad.x1[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~37_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(7));

-- Location: IOOBUF_X20_Y0_N2
\q.quad.x1[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~38_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(8));

-- Location: IOOBUF_X89_Y4_N96
\q.quad.x1[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~39_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(9));

-- Location: IOOBUF_X84_Y0_N19
\q.quad.x1[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~40_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(10));

-- Location: IOOBUF_X88_Y0_N54
\q.quad.x1[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~41_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(11));

-- Location: IOOBUF_X28_Y0_N36
\q.quad.x1[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~42_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(12));

-- Location: IOOBUF_X89_Y21_N5
\q.quad.x1[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~43_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(13));

-- Location: IOOBUF_X89_Y4_N45
\q.quad.x1[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~44_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(14));

-- Location: IOOBUF_X32_Y81_N2
\q.quad.x1[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~45_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x1\(15));

-- Location: IOOBUF_X4_Y81_N19
\q.quad.y0[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(0));

-- Location: IOOBUF_X24_Y0_N53
\q.quad.y0[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~2_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(1));

-- Location: IOOBUF_X2_Y81_N93
\q.quad.y0[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~4_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(2));

-- Location: IOOBUF_X14_Y0_N19
\q.quad.y0[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~6_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(3));

-- Location: IOOBUF_X26_Y0_N42
\q.quad.y0[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~8_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(4));

-- Location: IOOBUF_X26_Y81_N76
\q.quad.y0[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~10_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(5));

-- Location: IOOBUF_X86_Y0_N53
\q.quad.y0[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~12_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(6));

-- Location: IOOBUF_X28_Y0_N2
\q.quad.y0[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~14_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(7));

-- Location: IOOBUF_X22_Y0_N19
\q.quad.y0[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~16_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(8));

-- Location: IOOBUF_X10_Y0_N76
\q.quad.y0[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~18_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(9));

-- Location: IOOBUF_X24_Y81_N2
\q.quad.y0[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~20_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(10));

-- Location: IOOBUF_X4_Y0_N36
\q.quad.y0[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~22_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(11));

-- Location: IOOBUF_X24_Y0_N36
\q.quad.y0[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~24_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(12));

-- Location: IOOBUF_X89_Y20_N45
\q.quad.y0[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~26_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(13));

-- Location: IOOBUF_X12_Y0_N19
\q.quad.y0[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~28_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(14));

-- Location: IOOBUF_X20_Y81_N2
\q.quad.y0[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~29_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.y0\(15));

-- Location: IOOBUF_X86_Y0_N19
\q.quad.x0[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~48_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(0));

-- Location: IOOBUF_X20_Y81_N36
\q.quad.x0[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~52_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(1));

-- Location: IOOBUF_X30_Y0_N53
\q.quad.x0[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~55_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(2));

-- Location: IOOBUF_X8_Y81_N36
\q.quad.x0[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~58_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(3));

-- Location: IOOBUF_X32_Y81_N53
\q.quad.x0[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~61_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(4));

-- Location: IOOBUF_X14_Y81_N36
\q.quad.x0[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~64_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(5));

-- Location: IOOBUF_X24_Y0_N19
\q.quad.x0[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~67_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(6));

-- Location: IOOBUF_X22_Y81_N36
\q.quad.x0[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~70_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(7));

-- Location: IOOBUF_X26_Y0_N59
\q.quad.x0[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~73_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(8));

-- Location: IOOBUF_X34_Y0_N59
\q.quad.x0[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~76_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(9));

-- Location: IOOBUF_X89_Y25_N22
\q.quad.x0[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~79_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(10));

-- Location: IOOBUF_X28_Y0_N19
\q.quad.x0[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~82_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(11));

-- Location: IOOBUF_X58_Y0_N42
\q.quad.x0[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~85_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(12));

-- Location: IOOBUF_X34_Y81_N93
\q.quad.x0[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~88_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(13));

-- Location: IOOBUF_X22_Y0_N53
\q.quad.x0[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~91_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(14));

-- Location: IOOBUF_X38_Y81_N36
\q.quad.x0[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~94_combout\,
	devoe => ww_devoe,
	o => \ww_q.quad.x0\(15));

-- Location: IOOBUF_X89_Y16_N22
\q.quad_ready~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \r.quad_ready~q\,
	devoe => ww_devoe,
	o => \ww_q.quad_ready\);

-- Location: IOOBUF_X76_Y0_N53
\q.end_tile~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \v~127_combout\,
	devoe => ww_devoe,
	o => \ww_q.end_tile\);

-- Location: IOIBUF_X89_Y23_N21
\clock~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clock,
	o => \clock~input_o\);

-- Location: CLKCTRL_G11
\clock~inputCLKENA0\ : cyclonev_clkena
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	disable_mode => "low",
	ena_register_mode => "always enabled",
	ena_register_power_up => "high",
	test_syn => "high")
-- pragma translate_on
PORT MAP (
	inclk => \clock~input_o\,
	outclk => \clock~inputCLKENA0_outclk\);

-- Location: IOIBUF_X89_Y23_N38
\d.next_quad~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.next_quad\,
	o => \d.next_quad~input_o\);

-- Location: FF_X67_Y11_N44
\r.next_quad\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \d.next_quad~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.next_quad~q\);

-- Location: IOIBUF_X32_Y0_N52
\d.tile.y0[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(15),
	o => \d.tile.y0[15]~input_o\);

-- Location: IOIBUF_X38_Y81_N18
\d.clip_rect.y0[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(9),
	o => \d.clip_rect.y0[9]~input_o\);

-- Location: IOIBUF_X89_Y13_N21
\d.clip_rect.y0[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(8),
	o => \d.clip_rect.y0[8]~input_o\);

-- Location: IOIBUF_X30_Y81_N1
\d.clip_rect.y0[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(13),
	o => \d.clip_rect.y0[13]~input_o\);

-- Location: IOIBUF_X76_Y0_N18
\d.tile.y0[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(12),
	o => \d.tile.y0[12]~input_o\);

-- Location: IOIBUF_X89_Y8_N38
\d.tile.y0[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(13),
	o => \d.tile.y0[13]~input_o\);

-- Location: IOIBUF_X2_Y0_N58
\d.clip_rect.y0[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(14),
	o => \d.clip_rect.y0[14]~input_o\);

-- Location: IOIBUF_X40_Y81_N18
\d.clip_rect.y0[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(12),
	o => \d.clip_rect.y0[12]~input_o\);

-- Location: IOIBUF_X89_Y21_N38
\d.tile.y0[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(14),
	o => \d.tile.y0[14]~input_o\);

-- Location: LABCELL_X64_Y8_N36
\LessThan4~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~0_combout\ = ( \d.clip_rect.y0[12]~input_o\ & ( \d.tile.y0[14]~input_o\ & ( (\d.tile.y0[12]~input_o\ & (\d.clip_rect.y0[14]~input_o\ & (!\d.clip_rect.y0[13]~input_o\ $ (\d.tile.y0[13]~input_o\)))) ) ) ) # ( !\d.clip_rect.y0[12]~input_o\ & ( 
-- \d.tile.y0[14]~input_o\ & ( (!\d.tile.y0[12]~input_o\ & (\d.clip_rect.y0[14]~input_o\ & (!\d.clip_rect.y0[13]~input_o\ $ (\d.tile.y0[13]~input_o\)))) ) ) ) # ( \d.clip_rect.y0[12]~input_o\ & ( !\d.tile.y0[14]~input_o\ & ( (\d.tile.y0[12]~input_o\ & 
-- (!\d.clip_rect.y0[14]~input_o\ & (!\d.clip_rect.y0[13]~input_o\ $ (\d.tile.y0[13]~input_o\)))) ) ) ) # ( !\d.clip_rect.y0[12]~input_o\ & ( !\d.tile.y0[14]~input_o\ & ( (!\d.tile.y0[12]~input_o\ & (!\d.clip_rect.y0[14]~input_o\ & 
-- (!\d.clip_rect.y0[13]~input_o\ $ (\d.tile.y0[13]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000010000000000001000010000000000000000100001000000000000100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[13]~input_o\,
	datab => \ALT_INV_d.tile.y0[12]~input_o\,
	datac => \ALT_INV_d.tile.y0[13]~input_o\,
	datad => \ALT_INV_d.clip_rect.y0[14]~input_o\,
	datae => \ALT_INV_d.clip_rect.y0[12]~input_o\,
	dataf => \ALT_INV_d.tile.y0[14]~input_o\,
	combout => \LessThan4~0_combout\);

-- Location: IOIBUF_X10_Y81_N92
\d.clip_rect.y0[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(10),
	o => \d.clip_rect.y0[10]~input_o\);

-- Location: IOIBUF_X28_Y81_N18
\d.tile.y0[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(10),
	o => \d.tile.y0[10]~input_o\);

-- Location: IOIBUF_X89_Y13_N55
\d.tile.y0[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(11),
	o => \d.tile.y0[11]~input_o\);

-- Location: IOIBUF_X89_Y15_N21
\d.clip_rect.y0[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(11),
	o => \d.clip_rect.y0[11]~input_o\);

-- Location: LABCELL_X62_Y11_N51
\LessThan4~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~1_combout\ = ( \d.tile.y0[11]~input_o\ & ( \d.clip_rect.y0[11]~input_o\ & ( (\LessThan4~0_combout\ & (!\d.clip_rect.y0[10]~input_o\ $ (\d.tile.y0[10]~input_o\))) ) ) ) # ( !\d.tile.y0[11]~input_o\ & ( !\d.clip_rect.y0[11]~input_o\ & ( 
-- (\LessThan4~0_combout\ & (!\d.clip_rect.y0[10]~input_o\ $ (\d.tile.y0[10]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000101000001000000000000000000000000000000000100000101000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan4~0_combout\,
	datab => \ALT_INV_d.clip_rect.y0[10]~input_o\,
	datac => \ALT_INV_d.tile.y0[10]~input_o\,
	datae => \ALT_INV_d.tile.y0[11]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y0[11]~input_o\,
	combout => \LessThan4~1_combout\);

-- Location: LABCELL_X64_Y8_N18
\LessThan4~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~11_combout\ = ( \d.clip_rect.y0[12]~input_o\ & ( \d.tile.y0[14]~input_o\ & ( (!\d.clip_rect.y0[14]~input_o\) # ((!\d.clip_rect.y0[13]~input_o\ & \d.tile.y0[13]~input_o\)) ) ) ) # ( !\d.clip_rect.y0[12]~input_o\ & ( \d.tile.y0[14]~input_o\ & ( 
-- (!\d.clip_rect.y0[14]~input_o\) # ((!\d.clip_rect.y0[13]~input_o\ & ((\d.tile.y0[13]~input_o\) # (\d.tile.y0[12]~input_o\))) # (\d.clip_rect.y0[13]~input_o\ & (\d.tile.y0[12]~input_o\ & \d.tile.y0[13]~input_o\))) ) ) ) # ( \d.clip_rect.y0[12]~input_o\ & ( 
-- !\d.tile.y0[14]~input_o\ & ( (!\d.clip_rect.y0[13]~input_o\ & (\d.tile.y0[13]~input_o\ & !\d.clip_rect.y0[14]~input_o\)) ) ) ) # ( !\d.clip_rect.y0[12]~input_o\ & ( !\d.tile.y0[14]~input_o\ & ( (!\d.clip_rect.y0[14]~input_o\ & 
-- ((!\d.clip_rect.y0[13]~input_o\ & ((\d.tile.y0[13]~input_o\) # (\d.tile.y0[12]~input_o\))) # (\d.clip_rect.y0[13]~input_o\ & (\d.tile.y0[12]~input_o\ & \d.tile.y0[13]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010101100000000000010100000000011111111001010111111111100001010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[13]~input_o\,
	datab => \ALT_INV_d.tile.y0[12]~input_o\,
	datac => \ALT_INV_d.tile.y0[13]~input_o\,
	datad => \ALT_INV_d.clip_rect.y0[14]~input_o\,
	datae => \ALT_INV_d.clip_rect.y0[12]~input_o\,
	dataf => \ALT_INV_d.tile.y0[14]~input_o\,
	combout => \LessThan4~11_combout\);

-- Location: LABCELL_X62_Y11_N57
\LessThan4~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~12_combout\ = ( !\LessThan4~11_combout\ & ( \d.clip_rect.y0[11]~input_o\ & ( (!\LessThan4~0_combout\) # (((!\d.tile.y0[10]~input_o\) # (!\d.tile.y0[11]~input_o\)) # (\d.clip_rect.y0[10]~input_o\)) ) ) ) # ( !\LessThan4~11_combout\ & ( 
-- !\d.clip_rect.y0[11]~input_o\ & ( (!\LessThan4~0_combout\) # ((!\d.tile.y0[11]~input_o\ & ((!\d.tile.y0[10]~input_o\) # (\d.clip_rect.y0[10]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111101110101010000000000000000011111111111110110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan4~0_combout\,
	datab => \ALT_INV_d.clip_rect.y0[10]~input_o\,
	datac => \ALT_INV_d.tile.y0[10]~input_o\,
	datad => \ALT_INV_d.tile.y0[11]~input_o\,
	datae => \ALT_INV_LessThan4~11_combout\,
	dataf => \ALT_INV_d.clip_rect.y0[11]~input_o\,
	combout => \LessThan4~12_combout\);

-- Location: IOIBUF_X89_Y11_N61
\d.tile.y0[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(9),
	o => \d.tile.y0[9]~input_o\);

-- Location: IOIBUF_X89_Y11_N44
\d.tile.y0[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(8),
	o => \d.tile.y0[8]~input_o\);

-- Location: LABCELL_X63_Y11_N12
\LessThan4~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~13_combout\ = ( \d.tile.y0[9]~input_o\ & ( \d.tile.y0[8]~input_o\ & ( (\LessThan4~12_combout\ & ((!\LessThan4~1_combout\) # ((\d.clip_rect.y0[9]~input_o\ & \d.clip_rect.y0[8]~input_o\)))) ) ) ) # ( !\d.tile.y0[9]~input_o\ & ( 
-- \d.tile.y0[8]~input_o\ & ( (\LessThan4~12_combout\ & (((!\LessThan4~1_combout\) # (\d.clip_rect.y0[8]~input_o\)) # (\d.clip_rect.y0[9]~input_o\))) ) ) ) # ( \d.tile.y0[9]~input_o\ & ( !\d.tile.y0[8]~input_o\ & ( (\LessThan4~12_combout\ & 
-- ((!\LessThan4~1_combout\) # (\d.clip_rect.y0[9]~input_o\))) ) ) ) # ( !\d.tile.y0[9]~input_o\ & ( !\d.tile.y0[8]~input_o\ & ( \LessThan4~12_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111010100000000111101110000000011110001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[9]~input_o\,
	datab => \ALT_INV_d.clip_rect.y0[8]~input_o\,
	datac => \ALT_INV_LessThan4~1_combout\,
	datad => \ALT_INV_LessThan4~12_combout\,
	datae => \ALT_INV_d.tile.y0[9]~input_o\,
	dataf => \ALT_INV_d.tile.y0[8]~input_o\,
	combout => \LessThan4~13_combout\);

-- Location: IOIBUF_X36_Y0_N18
\d.clip_rect.y0[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(4),
	o => \d.clip_rect.y0[4]~input_o\);

-- Location: IOIBUF_X40_Y0_N35
\d.clip_rect.y0[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(7),
	o => \d.clip_rect.y0[7]~input_o\);

-- Location: IOIBUF_X89_Y16_N55
\d.clip_rect.y0[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(6),
	o => \d.clip_rect.y0[6]~input_o\);

-- Location: IOIBUF_X89_Y23_N4
\d.tile.y0[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(7),
	o => \d.tile.y0[7]~input_o\);

-- Location: IOIBUF_X38_Y0_N1
\d.tile.y0[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(6),
	o => \d.tile.y0[6]~input_o\);

-- Location: LABCELL_X61_Y11_N39
\LessThan4~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~6_combout\ = ( \d.tile.y0[6]~input_o\ & ( (\d.clip_rect.y0[6]~input_o\ & (!\d.clip_rect.y0[7]~input_o\ $ (\d.tile.y0[7]~input_o\))) ) ) # ( !\d.tile.y0[6]~input_o\ & ( (!\d.clip_rect.y0[6]~input_o\ & (!\d.clip_rect.y0[7]~input_o\ $ 
-- (\d.tile.y0[7]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000010010000100001000010010000110000100100001000010000100100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[7]~input_o\,
	datab => \ALT_INV_d.clip_rect.y0[6]~input_o\,
	datac => \ALT_INV_d.tile.y0[7]~input_o\,
	datae => \ALT_INV_d.tile.y0[6]~input_o\,
	combout => \LessThan4~6_combout\);

-- Location: IOIBUF_X38_Y0_N52
\d.tile.y0[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(4),
	o => \d.tile.y0[4]~input_o\);

-- Location: IOIBUF_X89_Y11_N95
\d.tile.y0[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(5),
	o => \d.tile.y0[5]~input_o\);

-- Location: IOIBUF_X40_Y0_N52
\d.clip_rect.y0[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(5),
	o => \d.clip_rect.y0[5]~input_o\);

-- Location: LABCELL_X63_Y11_N54
\LessThan4~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~7_combout\ = ( \d.clip_rect.y0[5]~input_o\ & ( (\LessThan4~6_combout\ & (\d.tile.y0[5]~input_o\ & (!\d.clip_rect.y0[4]~input_o\ $ (\d.tile.y0[4]~input_o\)))) ) ) # ( !\d.clip_rect.y0[5]~input_o\ & ( (\LessThan4~6_combout\ & 
-- (!\d.tile.y0[5]~input_o\ & (!\d.clip_rect.y0[4]~input_o\ $ (\d.tile.y0[4]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010000100000000001000010000000000000000001000010000000000100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[4]~input_o\,
	datab => \ALT_INV_LessThan4~6_combout\,
	datac => \ALT_INV_d.tile.y0[4]~input_o\,
	datad => \ALT_INV_d.tile.y0[5]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y0[5]~input_o\,
	combout => \LessThan4~7_combout\);

-- Location: IOIBUF_X8_Y0_N18
\d.clip_rect.y0[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(3),
	o => \d.clip_rect.y0[3]~input_o\);

-- Location: IOIBUF_X16_Y81_N52
\d.clip_rect.y0[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(2),
	o => \d.clip_rect.y0[2]~input_o\);

-- Location: IOIBUF_X36_Y0_N52
\d.tile.y0[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(2),
	o => \d.tile.y0[2]~input_o\);

-- Location: IOIBUF_X18_Y0_N92
\d.tile.y0[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(3),
	o => \d.tile.y0[3]~input_o\);

-- Location: IOIBUF_X28_Y81_N1
\d.clip_rect.y0[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(0),
	o => \d.clip_rect.y0[0]~input_o\);

-- Location: IOIBUF_X40_Y0_N1
\d.tile.y0[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(0),
	o => \d.tile.y0[0]~input_o\);

-- Location: IOIBUF_X34_Y0_N75
\d.clip_rect.y0[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(1),
	o => \d.clip_rect.y0[1]~input_o\);

-- Location: IOIBUF_X89_Y15_N38
\d.tile.y0[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y0\(1),
	o => \d.tile.y0[1]~input_o\);

-- Location: MLABCELL_X59_Y11_N51
\LessThan4~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~4_combout\ = ( \d.clip_rect.y0[1]~input_o\ & ( \d.tile.y0[1]~input_o\ & ( (!\d.clip_rect.y0[0]~input_o\ & \d.tile.y0[0]~input_o\) ) ) ) # ( !\d.clip_rect.y0[1]~input_o\ & ( \d.tile.y0[1]~input_o\ ) ) # ( !\d.clip_rect.y0[1]~input_o\ & ( 
-- !\d.tile.y0[1]~input_o\ & ( (!\d.clip_rect.y0[0]~input_o\ & \d.tile.y0[0]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000110000001100000000000000000011111111111111110000110000001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.clip_rect.y0[0]~input_o\,
	datac => \ALT_INV_d.tile.y0[0]~input_o\,
	datae => \ALT_INV_d.clip_rect.y0[1]~input_o\,
	dataf => \ALT_INV_d.tile.y0[1]~input_o\,
	combout => \LessThan4~4_combout\);

-- Location: MLABCELL_X59_Y11_N9
\LessThan4~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~5_combout\ = ( \LessThan4~4_combout\ & ( (!\d.clip_rect.y0[3]~input_o\ & ((!\d.clip_rect.y0[2]~input_o\) # ((\d.tile.y0[3]~input_o\) # (\d.tile.y0[2]~input_o\)))) # (\d.clip_rect.y0[3]~input_o\ & (\d.tile.y0[3]~input_o\ & 
-- ((!\d.clip_rect.y0[2]~input_o\) # (\d.tile.y0[2]~input_o\)))) ) ) # ( !\LessThan4~4_combout\ & ( (!\d.clip_rect.y0[3]~input_o\ & (((!\d.clip_rect.y0[2]~input_o\ & \d.tile.y0[2]~input_o\)) # (\d.tile.y0[3]~input_o\))) # (\d.clip_rect.y0[3]~input_o\ & 
-- (!\d.clip_rect.y0[2]~input_o\ & (\d.tile.y0[2]~input_o\ & \d.tile.y0[3]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100010101110000010001010111010001010111011111000101011101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[3]~input_o\,
	datab => \ALT_INV_d.clip_rect.y0[2]~input_o\,
	datac => \ALT_INV_d.tile.y0[2]~input_o\,
	datad => \ALT_INV_d.tile.y0[3]~input_o\,
	dataf => \ALT_INV_LessThan4~4_combout\,
	combout => \LessThan4~5_combout\);

-- Location: LABCELL_X61_Y11_N30
\LessThan4~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~8_combout\ = (!\d.tile.y0[7]~input_o\ & (\d.tile.y0[6]~input_o\ & (!\d.clip_rect.y0[7]~input_o\ & !\d.clip_rect.y0[6]~input_o\))) # (\d.tile.y0[7]~input_o\ & ((!\d.clip_rect.y0[7]~input_o\) # ((\d.tile.y0[6]~input_o\ & 
-- !\d.clip_rect.y0[6]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111000100110000011100010011000001110001001100000111000100110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y0[6]~input_o\,
	datab => \ALT_INV_d.tile.y0[7]~input_o\,
	datac => \ALT_INV_d.clip_rect.y0[7]~input_o\,
	datad => \ALT_INV_d.clip_rect.y0[6]~input_o\,
	combout => \LessThan4~8_combout\);

-- Location: LABCELL_X63_Y11_N0
\LessThan4~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~9_combout\ = ( \LessThan4~6_combout\ & ( \d.tile.y0[4]~input_o\ & ( (!\LessThan4~8_combout\ & ((!\d.tile.y0[5]~input_o\ & ((\d.clip_rect.y0[5]~input_o\) # (\d.clip_rect.y0[4]~input_o\))) # (\d.tile.y0[5]~input_o\ & (\d.clip_rect.y0[4]~input_o\ 
-- & \d.clip_rect.y0[5]~input_o\)))) ) ) ) # ( !\LessThan4~6_combout\ & ( \d.tile.y0[4]~input_o\ & ( !\LessThan4~8_combout\ ) ) ) # ( \LessThan4~6_combout\ & ( !\d.tile.y0[4]~input_o\ & ( (!\LessThan4~8_combout\ & ((!\d.tile.y0[5]~input_o\) # 
-- (\d.clip_rect.y0[5]~input_o\))) ) ) ) # ( !\LessThan4~6_combout\ & ( !\d.tile.y0[4]~input_o\ & ( !\LessThan4~8_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1100110011001100100010001100110011001100110011000000100010001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y0[5]~input_o\,
	datab => \ALT_INV_LessThan4~8_combout\,
	datac => \ALT_INV_d.clip_rect.y0[4]~input_o\,
	datad => \ALT_INV_d.clip_rect.y0[5]~input_o\,
	datae => \ALT_INV_LessThan4~6_combout\,
	dataf => \ALT_INV_d.tile.y0[4]~input_o\,
	combout => \LessThan4~9_combout\);

-- Location: LABCELL_X63_Y11_N30
\LessThan4~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~2_combout\ = ( \d.clip_rect.y0[9]~input_o\ & ( !\d.tile.y0[9]~input_o\ ) ) # ( !\d.clip_rect.y0[9]~input_o\ & ( \d.tile.y0[9]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001111001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.tile.y0[9]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y0[9]~input_o\,
	combout => \LessThan4~2_combout\);

-- Location: LABCELL_X63_Y11_N57
\LessThan4~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~3_combout\ = ( \d.tile.y0[8]~input_o\ & ( !\d.clip_rect.y0[8]~input_o\ ) ) # ( !\d.tile.y0[8]~input_o\ & ( \d.clip_rect.y0[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_d.clip_rect.y0[8]~input_o\,
	dataf => \ALT_INV_d.tile.y0[8]~input_o\,
	combout => \LessThan4~3_combout\);

-- Location: LABCELL_X63_Y11_N36
\LessThan4~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~10_combout\ = ( !\LessThan4~3_combout\ & ( \LessThan4~1_combout\ & ( (!\LessThan4~2_combout\ & ((!\LessThan4~9_combout\) # ((\LessThan4~7_combout\ & \LessThan4~5_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011110001000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan4~7_combout\,
	datab => \ALT_INV_LessThan4~5_combout\,
	datac => \ALT_INV_LessThan4~9_combout\,
	datad => \ALT_INV_LessThan4~2_combout\,
	datae => \ALT_INV_LessThan4~3_combout\,
	dataf => \ALT_INV_LessThan4~1_combout\,
	combout => \LessThan4~10_combout\);

-- Location: IOIBUF_X52_Y0_N18
\d.clip_rect.y0[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y0\(15),
	o => \d.clip_rect.y0[15]~input_o\);

-- Location: LABCELL_X63_Y11_N33
\LessThan4~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan4~14_combout\ = ( \d.clip_rect.y0[15]~input_o\ & ( (!\d.tile.y0[15]~input_o\) # ((\LessThan4~13_combout\ & !\LessThan4~10_combout\)) ) ) # ( !\d.clip_rect.y0[15]~input_o\ & ( (!\d.tile.y0[15]~input_o\ & (\LessThan4~13_combout\ & 
-- !\LessThan4~10_combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000000000000010100000000010101111101010101010111110101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y0[15]~input_o\,
	datac => \ALT_INV_LessThan4~13_combout\,
	datad => \ALT_INV_LessThan4~10_combout\,
	dataf => \ALT_INV_d.clip_rect.y0[15]~input_o\,
	combout => \LessThan4~14_combout\);

-- Location: IOIBUF_X24_Y81_N18
\d.clip_rect.y1[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(15),
	o => \d.clip_rect.y1[15]~input_o\);

-- Location: IOIBUF_X78_Y0_N52
\d.tile.y1[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(15),
	o => \d.tile.y1[15]~input_o\);

-- Location: LABCELL_X63_Y11_N51
\comb~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \comb~2_combout\ = ( \d.tile.y1[15]~input_o\ & ( \d.clip_rect.y0[15]~input_o\ & ( (!\d.clip_rect.y1[15]~input_o\ & \d.tile.y0[15]~input_o\) ) ) ) # ( !\d.tile.y1[15]~input_o\ & ( \d.clip_rect.y0[15]~input_o\ ) ) # ( \d.tile.y1[15]~input_o\ & ( 
-- !\d.clip_rect.y0[15]~input_o\ & ( (!\d.clip_rect.y1[15]~input_o\ & \d.tile.y0[15]~input_o\) ) ) ) # ( !\d.tile.y1[15]~input_o\ & ( !\d.clip_rect.y0[15]~input_o\ & ( (!\d.clip_rect.y1[15]~input_o\ & \d.tile.y0[15]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010101010000000001010101011111111111111110000000010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[15]~input_o\,
	datad => \ALT_INV_d.tile.y0[15]~input_o\,
	datae => \ALT_INV_d.tile.y1[15]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y0[15]~input_o\,
	combout => \comb~2_combout\);

-- Location: IOIBUF_X82_Y0_N92
\d.tile.x1[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(4),
	o => \d.tile.x1[4]~input_o\);

-- Location: IOIBUF_X64_Y0_N52
\d.clip_rect.x0[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(4),
	o => \d.clip_rect.x0[4]~input_o\);

-- Location: IOIBUF_X89_Y6_N55
\d.tile.x1[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(6),
	o => \d.tile.x1[6]~input_o\);

-- Location: IOIBUF_X70_Y0_N1
\d.clip_rect.x0[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(5),
	o => \d.clip_rect.x0[5]~input_o\);

-- Location: IOIBUF_X66_Y0_N92
\d.clip_rect.x0[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(7),
	o => \d.clip_rect.x0[7]~input_o\);

-- Location: IOIBUF_X76_Y0_N1
\d.tile.x1[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(7),
	o => \d.tile.x1[7]~input_o\);

-- Location: IOIBUF_X64_Y0_N18
\d.clip_rect.x0[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(6),
	o => \d.clip_rect.x0[6]~input_o\);

-- Location: IOIBUF_X89_Y8_N21
\d.tile.x1[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(5),
	o => \d.tile.x1[5]~input_o\);

-- Location: LABCELL_X64_Y7_N0
\LessThan0~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~1_combout\ = ( \d.clip_rect.x0[6]~input_o\ & ( \d.tile.x1[5]~input_o\ & ( (\d.tile.x1[6]~input_o\ & (\d.clip_rect.x0[5]~input_o\ & (!\d.clip_rect.x0[7]~input_o\ $ (\d.tile.x1[7]~input_o\)))) ) ) ) # ( !\d.clip_rect.x0[6]~input_o\ & ( 
-- \d.tile.x1[5]~input_o\ & ( (!\d.tile.x1[6]~input_o\ & (\d.clip_rect.x0[5]~input_o\ & (!\d.clip_rect.x0[7]~input_o\ $ (\d.tile.x1[7]~input_o\)))) ) ) ) # ( \d.clip_rect.x0[6]~input_o\ & ( !\d.tile.x1[5]~input_o\ & ( (\d.tile.x1[6]~input_o\ & 
-- (!\d.clip_rect.x0[5]~input_o\ & (!\d.clip_rect.x0[7]~input_o\ $ (\d.tile.x1[7]~input_o\)))) ) ) ) # ( !\d.clip_rect.x0[6]~input_o\ & ( !\d.tile.x1[5]~input_o\ & ( (!\d.tile.x1[6]~input_o\ & (!\d.clip_rect.x0[5]~input_o\ & (!\d.clip_rect.x0[7]~input_o\ $ 
-- (\d.tile.x1[7]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000000000001000010000000000010000100000000000100001000000000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[6]~input_o\,
	datab => \ALT_INV_d.clip_rect.x0[5]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[7]~input_o\,
	datad => \ALT_INV_d.tile.x1[7]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[6]~input_o\,
	dataf => \ALT_INV_d.tile.x1[5]~input_o\,
	combout => \LessThan0~1_combout\);

-- Location: LABCELL_X64_Y7_N42
\LessThan0~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~6_combout\ = ( \d.clip_rect.x0[6]~input_o\ & ( \d.tile.x1[5]~input_o\ & ( (!\d.tile.x1[6]~input_o\ & ((!\d.tile.x1[7]~input_o\) # (\d.clip_rect.x0[7]~input_o\))) # (\d.tile.x1[6]~input_o\ & (\d.clip_rect.x0[7]~input_o\ & 
-- !\d.tile.x1[7]~input_o\)) ) ) ) # ( !\d.clip_rect.x0[6]~input_o\ & ( \d.tile.x1[5]~input_o\ & ( (\d.clip_rect.x0[7]~input_o\ & !\d.tile.x1[7]~input_o\) ) ) ) # ( \d.clip_rect.x0[6]~input_o\ & ( !\d.tile.x1[5]~input_o\ & ( (!\d.clip_rect.x0[7]~input_o\ & 
-- (!\d.tile.x1[7]~input_o\ & ((!\d.tile.x1[6]~input_o\) # (\d.clip_rect.x0[5]~input_o\)))) # (\d.clip_rect.x0[7]~input_o\ & ((!\d.tile.x1[6]~input_o\) # ((!\d.tile.x1[7]~input_o\) # (\d.clip_rect.x0[5]~input_o\)))) ) ) ) # ( !\d.clip_rect.x0[6]~input_o\ & ( 
-- !\d.tile.x1[5]~input_o\ & ( (!\d.clip_rect.x0[7]~input_o\ & (!\d.tile.x1[6]~input_o\ & (\d.clip_rect.x0[5]~input_o\ & !\d.tile.x1[7]~input_o\))) # (\d.clip_rect.x0[7]~input_o\ & ((!\d.tile.x1[7]~input_o\) # ((!\d.tile.x1[6]~input_o\ & 
-- \d.clip_rect.x0[5]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010111100000010101111110000101100001111000000001010111100001010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[6]~input_o\,
	datab => \ALT_INV_d.clip_rect.x0[5]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[7]~input_o\,
	datad => \ALT_INV_d.tile.x1[7]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[6]~input_o\,
	dataf => \ALT_INV_d.tile.x1[5]~input_o\,
	combout => \LessThan0~6_combout\);

-- Location: LABCELL_X63_Y6_N27
\LessThan0~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~7_combout\ = ( !\LessThan0~6_combout\ & ( ((!\d.clip_rect.x0[4]~input_o\) # (!\LessThan0~1_combout\)) # (\d.tile.x1[4]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111110101111111111111010100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[4]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[4]~input_o\,
	datad => \ALT_INV_LessThan0~1_combout\,
	dataf => \ALT_INV_LessThan0~6_combout\,
	combout => \LessThan0~7_combout\);

-- Location: IOIBUF_X74_Y0_N41
\d.tile.x1[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(8),
	o => \d.tile.x1[8]~input_o\);

-- Location: IOIBUF_X64_Y0_N1
\d.clip_rect.x0[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(8),
	o => \d.clip_rect.x0[8]~input_o\);

-- Location: LABCELL_X63_Y8_N45
\LessThan0~15\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~15_combout\ = ( \d.clip_rect.x0[8]~input_o\ & ( !\d.tile.x1[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.tile.x1[8]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[8]~input_o\,
	combout => \LessThan0~15_combout\);

-- Location: IOIBUF_X54_Y0_N18
\d.tile.x1[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(11),
	o => \d.tile.x1[11]~input_o\);

-- Location: IOIBUF_X60_Y0_N18
\d.clip_rect.x0[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(11),
	o => \d.clip_rect.x0[11]~input_o\);

-- Location: LABCELL_X63_Y6_N6
\LessThan0~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~9_combout\ = ( \d.clip_rect.x0[11]~input_o\ & ( !\d.tile.x1[11]~input_o\ ) ) # ( !\d.clip_rect.x0[11]~input_o\ & ( \d.tile.x1[11]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_d.tile.x1[11]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[11]~input_o\,
	combout => \LessThan0~9_combout\);

-- Location: IOIBUF_X50_Y0_N75
\d.clip_rect.x0[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(12),
	o => \d.clip_rect.x0[12]~input_o\);

-- Location: IOIBUF_X30_Y81_N52
\d.tile.x1[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(14),
	o => \d.tile.x1[14]~input_o\);

-- Location: IOIBUF_X58_Y0_N75
\d.tile.x1[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(12),
	o => \d.tile.x1[12]~input_o\);

-- Location: IOIBUF_X56_Y0_N52
\d.clip_rect.x0[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(14),
	o => \d.clip_rect.x0[14]~input_o\);

-- Location: IOIBUF_X60_Y0_N35
\d.clip_rect.x0[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(13),
	o => \d.clip_rect.x0[13]~input_o\);

-- Location: IOIBUF_X89_Y6_N21
\d.tile.x1[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(13),
	o => \d.tile.x1[13]~input_o\);

-- Location: LABCELL_X62_Y7_N48
\LessThan0~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~8_combout\ = ( \d.clip_rect.x0[13]~input_o\ & ( \d.tile.x1[13]~input_o\ & ( (!\d.clip_rect.x0[12]~input_o\ & (!\d.tile.x1[12]~input_o\ & (!\d.tile.x1[14]~input_o\ $ (\d.clip_rect.x0[14]~input_o\)))) # (\d.clip_rect.x0[12]~input_o\ & 
-- (\d.tile.x1[12]~input_o\ & (!\d.tile.x1[14]~input_o\ $ (\d.clip_rect.x0[14]~input_o\)))) ) ) ) # ( !\d.clip_rect.x0[13]~input_o\ & ( !\d.tile.x1[13]~input_o\ & ( (!\d.clip_rect.x0[12]~input_o\ & (!\d.tile.x1[12]~input_o\ & (!\d.tile.x1[14]~input_o\ $ 
-- (\d.clip_rect.x0[14]~input_o\)))) # (\d.clip_rect.x0[12]~input_o\ & (\d.tile.x1[12]~input_o\ & (!\d.tile.x1[14]~input_o\ $ (\d.clip_rect.x0[14]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000010000100001000000000000000000000000000000001000010000100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[12]~input_o\,
	datab => \ALT_INV_d.tile.x1[14]~input_o\,
	datac => \ALT_INV_d.tile.x1[12]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[14]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[13]~input_o\,
	dataf => \ALT_INV_d.tile.x1[13]~input_o\,
	combout => \LessThan0~8_combout\);

-- Location: IOIBUF_X30_Y81_N18
\d.tile.x1[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(10),
	o => \d.tile.x1[10]~input_o\);

-- Location: IOIBUF_X62_Y0_N1
\d.clip_rect.x0[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(10),
	o => \d.clip_rect.x0[10]~input_o\);

-- Location: LABCELL_X63_Y6_N39
\LessThan0~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~10_combout\ = !\d.tile.x1[10]~input_o\ $ (!\d.clip_rect.x0[10]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010110101010010101011010101001010101101010100101010110101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[10]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[10]~input_o\,
	combout => \LessThan0~10_combout\);

-- Location: IOIBUF_X68_Y0_N35
\d.tile.x1[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(9),
	o => \d.tile.x1[9]~input_o\);

-- Location: IOIBUF_X64_Y0_N35
\d.clip_rect.x0[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(9),
	o => \d.clip_rect.x0[9]~input_o\);

-- Location: LABCELL_X63_Y6_N12
\LessThan0~16\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~16_combout\ = ( \d.tile.x1[9]~input_o\ & ( \d.clip_rect.x0[9]~input_o\ & ( (\LessThan0~15_combout\ & (!\LessThan0~9_combout\ & (\LessThan0~8_combout\ & !\LessThan0~10_combout\))) ) ) ) # ( !\d.tile.x1[9]~input_o\ & ( \d.clip_rect.x0[9]~input_o\ 
-- & ( (!\LessThan0~9_combout\ & (\LessThan0~8_combout\ & !\LessThan0~10_combout\)) ) ) ) # ( !\d.tile.x1[9]~input_o\ & ( !\d.clip_rect.x0[9]~input_o\ & ( (\LessThan0~15_combout\ & (!\LessThan0~9_combout\ & (\LessThan0~8_combout\ & !\LessThan0~10_combout\))) 
-- ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000010000000000000000000000000000001100000000000000010000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan0~15_combout\,
	datab => \ALT_INV_LessThan0~9_combout\,
	datac => \ALT_INV_LessThan0~8_combout\,
	datad => \ALT_INV_LessThan0~10_combout\,
	datae => \ALT_INV_d.tile.x1[9]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[9]~input_o\,
	combout => \LessThan0~16_combout\);

-- Location: IOIBUF_X40_Y0_N18
\d.clip_rect.x0[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(0),
	o => \d.clip_rect.x0[0]~input_o\);

-- Location: IOIBUF_X89_Y9_N21
\d.tile.x1[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(1),
	o => \d.tile.x1[1]~input_o\);

-- Location: IOIBUF_X80_Y0_N1
\d.clip_rect.x0[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(1),
	o => \d.clip_rect.x0[1]~input_o\);

-- Location: IOIBUF_X89_Y8_N4
\d.tile.x1[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(0),
	o => \d.tile.x1[0]~input_o\);

-- Location: LABCELL_X63_Y10_N54
\LessThan0~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~2_combout\ = ( \d.tile.x1[0]~input_o\ & ( (!\d.tile.x1[1]~input_o\ & \d.clip_rect.x0[1]~input_o\) ) ) # ( !\d.tile.x1[0]~input_o\ & ( (!\d.clip_rect.x0[0]~input_o\ & (!\d.tile.x1[1]~input_o\ & \d.clip_rect.x0[1]~input_o\)) # 
-- (\d.clip_rect.x0[0]~input_o\ & ((!\d.tile.x1[1]~input_o\) # (\d.clip_rect.x0[1]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000011110011001100001111001100000000111100000000000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.clip_rect.x0[0]~input_o\,
	datac => \ALT_INV_d.tile.x1[1]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[1]~input_o\,
	dataf => \ALT_INV_d.tile.x1[0]~input_o\,
	combout => \LessThan0~2_combout\);

-- Location: IOIBUF_X72_Y0_N18
\d.tile.x1[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(2),
	o => \d.tile.x1[2]~input_o\);

-- Location: IOIBUF_X76_Y0_N35
\d.tile.x1[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(3),
	o => \d.tile.x1[3]~input_o\);

-- Location: IOIBUF_X54_Y0_N1
\d.clip_rect.x0[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(2),
	o => \d.clip_rect.x0[2]~input_o\);

-- Location: IOIBUF_X58_Y0_N58
\d.clip_rect.x0[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(3),
	o => \d.clip_rect.x0[3]~input_o\);

-- Location: LABCELL_X63_Y6_N9
\LessThan0~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~3_combout\ = ( \d.clip_rect.x0[3]~input_o\ & ( (\d.tile.x1[3]~input_o\ & (!\d.tile.x1[2]~input_o\ $ (\d.clip_rect.x0[2]~input_o\))) ) ) # ( !\d.clip_rect.x0[3]~input_o\ & ( (!\d.tile.x1[3]~input_o\ & (!\d.tile.x1[2]~input_o\ $ 
-- (\d.clip_rect.x0[2]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000010010000100100001001000010000100001001000010010000100100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[2]~input_o\,
	datab => \ALT_INV_d.tile.x1[3]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[2]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[3]~input_o\,
	combout => \LessThan0~3_combout\);

-- Location: LABCELL_X63_Y6_N24
\LessThan0~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~4_combout\ = ( \d.clip_rect.x0[3]~input_o\ & ( (!\d.tile.x1[3]~input_o\) # ((\d.clip_rect.x0[2]~input_o\ & !\d.tile.x1[2]~input_o\)) ) ) # ( !\d.clip_rect.x0[3]~input_o\ & ( (\d.clip_rect.x0[2]~input_o\ & (!\d.tile.x1[2]~input_o\ & 
-- !\d.tile.x1[3]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000000000000001100000000000011111111001100001111111100110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.clip_rect.x0[2]~input_o\,
	datac => \ALT_INV_d.tile.x1[2]~input_o\,
	datad => \ALT_INV_d.tile.x1[3]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[3]~input_o\,
	combout => \LessThan0~4_combout\);

-- Location: LABCELL_X63_Y6_N54
\LessThan0~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~5_combout\ = ( \LessThan0~1_combout\ & ( \LessThan0~4_combout\ & ( !\d.clip_rect.x0[4]~input_o\ $ (\d.tile.x1[4]~input_o\) ) ) ) # ( \LessThan0~1_combout\ & ( !\LessThan0~4_combout\ & ( (\LessThan0~2_combout\ & (\LessThan0~3_combout\ & 
-- (!\d.clip_rect.x0[4]~input_o\ $ (\d.tile.x1[4]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000100000100000000000000001100001111000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan0~2_combout\,
	datab => \ALT_INV_d.clip_rect.x0[4]~input_o\,
	datac => \ALT_INV_d.tile.x1[4]~input_o\,
	datad => \ALT_INV_LessThan0~3_combout\,
	datae => \ALT_INV_LessThan0~1_combout\,
	dataf => \ALT_INV_LessThan0~4_combout\,
	combout => \LessThan0~5_combout\);

-- Location: LABCELL_X62_Y7_N6
\LessThan0~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~13_combout\ = ( \d.clip_rect.x0[12]~input_o\ & ( \d.clip_rect.x0[14]~input_o\ & ( (!\d.tile.x1[14]~input_o\) # ((!\d.tile.x1[12]~input_o\ & ((!\d.tile.x1[13]~input_o\) # (\d.clip_rect.x0[13]~input_o\))) # (\d.tile.x1[12]~input_o\ & 
-- (!\d.tile.x1[13]~input_o\ & \d.clip_rect.x0[13]~input_o\))) ) ) ) # ( !\d.clip_rect.x0[12]~input_o\ & ( \d.clip_rect.x0[14]~input_o\ & ( (!\d.tile.x1[14]~input_o\) # ((!\d.tile.x1[13]~input_o\ & \d.clip_rect.x0[13]~input_o\)) ) ) ) # ( 
-- \d.clip_rect.x0[12]~input_o\ & ( !\d.clip_rect.x0[14]~input_o\ & ( (!\d.tile.x1[14]~input_o\ & ((!\d.tile.x1[12]~input_o\ & ((!\d.tile.x1[13]~input_o\) # (\d.clip_rect.x0[13]~input_o\))) # (\d.tile.x1[12]~input_o\ & (!\d.tile.x1[13]~input_o\ & 
-- \d.clip_rect.x0[13]~input_o\)))) ) ) ) # ( !\d.clip_rect.x0[12]~input_o\ & ( !\d.clip_rect.x0[14]~input_o\ & ( (!\d.tile.x1[14]~input_o\ & (!\d.tile.x1[13]~input_o\ & \d.clip_rect.x0[13]~input_o\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011000000100000001100100011001100111111001110110011111110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[12]~input_o\,
	datab => \ALT_INV_d.tile.x1[14]~input_o\,
	datac => \ALT_INV_d.tile.x1[13]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[13]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[12]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[14]~input_o\,
	combout => \LessThan0~13_combout\);

-- Location: LABCELL_X63_Y6_N42
\LessThan0~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~14_combout\ = ( \d.clip_rect.x0[10]~input_o\ & ( \LessThan0~8_combout\ & ( (!\LessThan0~13_combout\ & ((!\d.tile.x1[11]~input_o\ & (\d.tile.x1[10]~input_o\ & !\d.clip_rect.x0[11]~input_o\)) # (\d.tile.x1[11]~input_o\ & 
-- ((!\d.clip_rect.x0[11]~input_o\) # (\d.tile.x1[10]~input_o\))))) ) ) ) # ( !\d.clip_rect.x0[10]~input_o\ & ( \LessThan0~8_combout\ & ( (!\LessThan0~13_combout\ & ((!\d.clip_rect.x0[11]~input_o\) # (\d.tile.x1[11]~input_o\))) ) ) ) # ( 
-- \d.clip_rect.x0[10]~input_o\ & ( !\LessThan0~8_combout\ & ( !\LessThan0~13_combout\ ) ) ) # ( !\d.clip_rect.x0[10]~input_o\ & ( !\LessThan0~8_combout\ & ( !\LessThan0~13_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111100000000111111110000000011110101000000000111000100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[11]~input_o\,
	datab => \ALT_INV_d.tile.x1[10]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[11]~input_o\,
	datad => \ALT_INV_LessThan0~13_combout\,
	datae => \ALT_INV_d.clip_rect.x0[10]~input_o\,
	dataf => \ALT_INV_LessThan0~8_combout\,
	combout => \LessThan0~14_combout\);

-- Location: IOIBUF_X56_Y0_N1
\d.tile.x1[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x1\(15),
	o => \d.tile.x1[15]~input_o\);

-- Location: IOIBUF_X62_Y0_N18
\d.clip_rect.x0[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x0\(15),
	o => \d.clip_rect.x0[15]~input_o\);

-- Location: LABCELL_X63_Y6_N36
\LessThan0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~0_combout\ = ( \d.clip_rect.x0[15]~input_o\ & ( !\d.tile.x1[15]~input_o\ ) ) # ( !\d.clip_rect.x0[15]~input_o\ & ( \d.tile.x1[15]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_d.tile.x1[15]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	combout => \LessThan0~0_combout\);

-- Location: LABCELL_X63_Y8_N42
\LessThan0~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~11_combout\ = ( \d.clip_rect.x0[8]~input_o\ & ( !\d.tile.x1[8]~input_o\ ) ) # ( !\d.clip_rect.x0[8]~input_o\ & ( \d.tile.x1[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001111001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.tile.x1[8]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[8]~input_o\,
	combout => \LessThan0~11_combout\);

-- Location: LABCELL_X63_Y6_N48
\LessThan0~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~12_combout\ = ( \d.tile.x1[9]~input_o\ & ( \d.clip_rect.x0[9]~input_o\ & ( (!\LessThan0~11_combout\ & (!\LessThan0~9_combout\ & (\LessThan0~8_combout\ & !\LessThan0~10_combout\))) ) ) ) # ( !\d.tile.x1[9]~input_o\ & ( 
-- !\d.clip_rect.x0[9]~input_o\ & ( (!\LessThan0~11_combout\ & (!\LessThan0~9_combout\ & (\LessThan0~8_combout\ & !\LessThan0~10_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000000000000000000000000000000000000000000000100000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan0~11_combout\,
	datab => \ALT_INV_LessThan0~9_combout\,
	datac => \ALT_INV_LessThan0~8_combout\,
	datad => \ALT_INV_LessThan0~10_combout\,
	datae => \ALT_INV_d.tile.x1[9]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[9]~input_o\,
	combout => \LessThan0~12_combout\);

-- Location: LABCELL_X63_Y6_N30
\LessThan0~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan0~17_combout\ = ( !\LessThan0~0_combout\ & ( \LessThan0~12_combout\ & ( (!\LessThan0~7_combout\) # (((!\LessThan0~14_combout\) # (\LessThan0~5_combout\)) # (\LessThan0~16_combout\)) ) ) ) # ( !\LessThan0~0_combout\ & ( !\LessThan0~12_combout\ & ( 
-- (!\LessThan0~14_combout\) # (\LessThan0~16_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111100110011000000000000000011111111101111110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan0~7_combout\,
	datab => \ALT_INV_LessThan0~16_combout\,
	datac => \ALT_INV_LessThan0~5_combout\,
	datad => \ALT_INV_LessThan0~14_combout\,
	datae => \ALT_INV_LessThan0~0_combout\,
	dataf => \ALT_INV_LessThan0~12_combout\,
	combout => \LessThan0~17_combout\);

-- Location: MLABCELL_X59_Y9_N57
\LessThan3~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~0_combout\ = ( \d.tile.y0[15]~input_o\ & ( !\d.clip_rect.y1[15]~input_o\ ) ) # ( !\d.tile.y0[15]~input_o\ & ( \d.clip_rect.y1[15]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010110101010101010101010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[15]~input_o\,
	dataf => \ALT_INV_d.tile.y0[15]~input_o\,
	combout => \LessThan3~0_combout\);

-- Location: IOIBUF_X78_Y0_N1
\d.clip_rect.y1[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(14),
	o => \d.clip_rect.y1[14]~input_o\);

-- Location: IOIBUF_X72_Y0_N1
\d.clip_rect.y1[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(12),
	o => \d.clip_rect.y1[12]~input_o\);

-- Location: IOIBUF_X78_Y0_N35
\d.clip_rect.y1[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(13),
	o => \d.clip_rect.y1[13]~input_o\);

-- Location: LABCELL_X64_Y8_N48
\LessThan3~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~10_combout\ = ( \d.clip_rect.y1[13]~input_o\ & ( \d.tile.y0[14]~input_o\ & ( (\d.clip_rect.y1[14]~input_o\ & (\d.tile.y0[13]~input_o\ & (!\d.tile.y0[12]~input_o\ $ (\d.clip_rect.y1[12]~input_o\)))) ) ) ) # ( !\d.clip_rect.y1[13]~input_o\ & ( 
-- \d.tile.y0[14]~input_o\ & ( (\d.clip_rect.y1[14]~input_o\ & (!\d.tile.y0[13]~input_o\ & (!\d.tile.y0[12]~input_o\ $ (\d.clip_rect.y1[12]~input_o\)))) ) ) ) # ( \d.clip_rect.y1[13]~input_o\ & ( !\d.tile.y0[14]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\ & 
-- (\d.tile.y0[13]~input_o\ & (!\d.tile.y0[12]~input_o\ $ (\d.clip_rect.y1[12]~input_o\)))) ) ) ) # ( !\d.clip_rect.y1[13]~input_o\ & ( !\d.tile.y0[14]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\ & (!\d.tile.y0[13]~input_o\ & (!\d.tile.y0[12]~input_o\ $ 
-- (\d.clip_rect.y1[12]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000000000100000000010000000001001000000000100000000010000000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[14]~input_o\,
	datab => \ALT_INV_d.tile.y0[12]~input_o\,
	datac => \ALT_INV_d.tile.y0[13]~input_o\,
	datad => \ALT_INV_d.clip_rect.y1[12]~input_o\,
	datae => \ALT_INV_d.clip_rect.y1[13]~input_o\,
	dataf => \ALT_INV_d.tile.y0[14]~input_o\,
	combout => \LessThan3~10_combout\);

-- Location: IOIBUF_X89_Y9_N4
\d.clip_rect.y1[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(10),
	o => \d.clip_rect.y1[10]~input_o\);

-- Location: LABCELL_X61_Y11_N54
\LessThan3~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~12_combout\ = ( \d.tile.y0[10]~input_o\ & ( !\d.clip_rect.y1[10]~input_o\ ) ) # ( !\d.tile.y0[10]~input_o\ & ( \d.clip_rect.y1[10]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001111001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.clip_rect.y1[10]~input_o\,
	dataf => \ALT_INV_d.tile.y0[10]~input_o\,
	combout => \LessThan3~12_combout\);

-- Location: IOIBUF_X89_Y16_N4
\d.clip_rect.y1[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(11),
	o => \d.clip_rect.y1[11]~input_o\);

-- Location: LABCELL_X60_Y11_N48
\LessThan3~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~11_combout\ = ( !\d.tile.y0[11]~input_o\ & ( \d.clip_rect.y1[11]~input_o\ ) ) # ( \d.tile.y0[11]~input_o\ & ( !\d.clip_rect.y1[11]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111111111111111111110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datae => \ALT_INV_d.tile.y0[11]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y1[11]~input_o\,
	combout => \LessThan3~11_combout\);

-- Location: IOIBUF_X89_Y13_N38
\d.clip_rect.y1[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(8),
	o => \d.clip_rect.y1[8]~input_o\);

-- Location: LABCELL_X61_Y11_N21
\LessThan3~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~13_combout\ = ( \d.clip_rect.y1[8]~input_o\ & ( !\d.tile.y0[8]~input_o\ ) ) # ( !\d.clip_rect.y1[8]~input_o\ & ( \d.tile.y0[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111111111111000000001111111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_d.tile.y0[8]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y1[8]~input_o\,
	combout => \LessThan3~13_combout\);

-- Location: IOIBUF_X36_Y81_N1
\d.clip_rect.y1[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(9),
	o => \d.clip_rect.y1[9]~input_o\);

-- Location: LABCELL_X61_Y11_N12
\LessThan3~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~14_combout\ = ( !\LessThan3~13_combout\ & ( \d.clip_rect.y1[9]~input_o\ & ( (\LessThan3~10_combout\ & (\d.tile.y0[9]~input_o\ & (!\LessThan3~12_combout\ & !\LessThan3~11_combout\))) ) ) ) # ( !\LessThan3~13_combout\ & ( 
-- !\d.clip_rect.y1[9]~input_o\ & ( (\LessThan3~10_combout\ & (!\d.tile.y0[9]~input_o\ & (!\LessThan3~12_combout\ & !\LessThan3~11_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000000000000000000000000000000010000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan3~10_combout\,
	datab => \ALT_INV_d.tile.y0[9]~input_o\,
	datac => \ALT_INV_LessThan3~12_combout\,
	datad => \ALT_INV_LessThan3~11_combout\,
	datae => \ALT_INV_LessThan3~13_combout\,
	dataf => \ALT_INV_d.clip_rect.y1[9]~input_o\,
	combout => \LessThan3~14_combout\);

-- Location: IOIBUF_X34_Y81_N75
\d.clip_rect.y1[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(6),
	o => \d.clip_rect.y1[6]~input_o\);

-- Location: IOIBUF_X36_Y81_N18
\d.clip_rect.y1[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(7),
	o => \d.clip_rect.y1[7]~input_o\);

-- Location: LABCELL_X61_Y11_N18
\LessThan3~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~8_combout\ = ( \d.clip_rect.y1[7]~input_o\ & ( (!\d.clip_rect.y1[6]~input_o\ & (\d.tile.y0[7]~input_o\ & \d.tile.y0[6]~input_o\)) ) ) # ( !\d.clip_rect.y1[7]~input_o\ & ( ((!\d.clip_rect.y1[6]~input_o\ & \d.tile.y0[6]~input_o\)) # 
-- (\d.tile.y0[7]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011101100111011001110110011101100000010000000100000001000000010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[6]~input_o\,
	datab => \ALT_INV_d.tile.y0[7]~input_o\,
	datac => \ALT_INV_d.tile.y0[6]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y1[7]~input_o\,
	combout => \LessThan3~8_combout\);

-- Location: IOIBUF_X84_Y0_N35
\d.clip_rect.y1[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(5),
	o => \d.clip_rect.y1[5]~input_o\);

-- Location: IOIBUF_X40_Y81_N52
\d.clip_rect.y1[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(4),
	o => \d.clip_rect.y1[4]~input_o\);

-- Location: LABCELL_X61_Y11_N33
\LessThan3~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~1_combout\ = ( \d.clip_rect.y1[7]~input_o\ & ( (\d.tile.y0[7]~input_o\ & (!\d.tile.y0[6]~input_o\ $ (\d.clip_rect.y1[6]~input_o\))) ) ) # ( !\d.clip_rect.y1[7]~input_o\ & ( (!\d.tile.y0[7]~input_o\ & (!\d.tile.y0[6]~input_o\ $ 
-- (\d.clip_rect.y1[6]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000010010000100100001001000010000100001001000010010000100100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y0[6]~input_o\,
	datab => \ALT_INV_d.tile.y0[7]~input_o\,
	datac => \ALT_INV_d.clip_rect.y1[6]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y1[7]~input_o\,
	combout => \LessThan3~1_combout\);

-- Location: LABCELL_X61_Y11_N48
\LessThan3~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~9_combout\ = ( \d.tile.y0[4]~input_o\ & ( \LessThan3~1_combout\ & ( (!\LessThan3~8_combout\ & ((!\d.clip_rect.y1[5]~input_o\ & (!\d.tile.y0[5]~input_o\ & \d.clip_rect.y1[4]~input_o\)) # (\d.clip_rect.y1[5]~input_o\ & ((!\d.tile.y0[5]~input_o\) 
-- # (\d.clip_rect.y1[4]~input_o\))))) ) ) ) # ( !\d.tile.y0[4]~input_o\ & ( \LessThan3~1_combout\ & ( (!\LessThan3~8_combout\ & ((!\d.tile.y0[5]~input_o\) # (\d.clip_rect.y1[5]~input_o\))) ) ) ) # ( \d.tile.y0[4]~input_o\ & ( !\LessThan3~1_combout\ & ( 
-- !\LessThan3~8_combout\ ) ) ) # ( !\d.tile.y0[4]~input_o\ & ( !\LessThan3~1_combout\ & ( !\LessThan3~8_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010101010101010101010101010101010100010101000100010000010100010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan3~8_combout\,
	datab => \ALT_INV_d.clip_rect.y1[5]~input_o\,
	datac => \ALT_INV_d.tile.y0[5]~input_o\,
	datad => \ALT_INV_d.clip_rect.y1[4]~input_o\,
	datae => \ALT_INV_d.tile.y0[4]~input_o\,
	dataf => \ALT_INV_LessThan3~1_combout\,
	combout => \LessThan3~9_combout\);

-- Location: LABCELL_X61_Y11_N27
\LessThan3~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~2_combout\ = !\d.tile.y0[5]~input_o\ $ (!\d.clip_rect.y1[5]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101101001011010010110100101101001011010010110100101101001011010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y0[5]~input_o\,
	datac => \ALT_INV_d.clip_rect.y1[5]~input_o\,
	combout => \LessThan3~2_combout\);

-- Location: IOIBUF_X54_Y0_N35
\d.clip_rect.y1[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(0),
	o => \d.clip_rect.y1[0]~input_o\);

-- Location: IOIBUF_X50_Y0_N58
\d.clip_rect.y1[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(1),
	o => \d.clip_rect.y1[1]~input_o\);

-- Location: MLABCELL_X59_Y11_N57
\LessThan3~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~4_combout\ = ( \d.tile.y0[1]~input_o\ & ( (!\d.clip_rect.y1[1]~input_o\) # ((!\d.clip_rect.y1[0]~input_o\ & \d.tile.y0[0]~input_o\)) ) ) # ( !\d.tile.y0[1]~input_o\ & ( (!\d.clip_rect.y1[0]~input_o\ & (\d.tile.y0[0]~input_o\ & 
-- !\d.clip_rect.y1[1]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000000000000010100000000011111111000010101111111100001010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[0]~input_o\,
	datac => \ALT_INV_d.tile.y0[0]~input_o\,
	datad => \ALT_INV_d.clip_rect.y1[1]~input_o\,
	dataf => \ALT_INV_d.tile.y0[1]~input_o\,
	combout => \LessThan3~4_combout\);

-- Location: LABCELL_X61_Y11_N24
\LessThan3~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~3_combout\ = !\d.tile.y0[4]~input_o\ $ (!\d.clip_rect.y1[4]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001111001100001100111100110000110011110011000011001111001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.tile.y0[4]~input_o\,
	datad => \ALT_INV_d.clip_rect.y1[4]~input_o\,
	combout => \LessThan3~3_combout\);

-- Location: IOIBUF_X28_Y0_N52
\d.clip_rect.y1[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(2),
	o => \d.clip_rect.y1[2]~input_o\);

-- Location: IOIBUF_X36_Y81_N35
\d.clip_rect.y1[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.y1\(3),
	o => \d.clip_rect.y1[3]~input_o\);

-- Location: MLABCELL_X59_Y11_N15
\LessThan3~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~5_combout\ = (!\d.clip_rect.y1[2]~input_o\ & (!\d.tile.y0[2]~input_o\ & (!\d.clip_rect.y1[3]~input_o\ $ (\d.tile.y0[3]~input_o\)))) # (\d.clip_rect.y1[2]~input_o\ & (\d.tile.y0[2]~input_o\ & (!\d.clip_rect.y1[3]~input_o\ $ 
-- (\d.tile.y0[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000010000100001100001000010000110000100001000011000010000100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[2]~input_o\,
	datab => \ALT_INV_d.clip_rect.y1[3]~input_o\,
	datac => \ALT_INV_d.tile.y0[2]~input_o\,
	datad => \ALT_INV_d.tile.y0[3]~input_o\,
	combout => \LessThan3~5_combout\);

-- Location: MLABCELL_X59_Y11_N36
\LessThan3~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~6_combout\ = ( \d.clip_rect.y1[3]~input_o\ & ( (!\d.clip_rect.y1[2]~input_o\ & (\d.tile.y0[3]~input_o\ & \d.tile.y0[2]~input_o\)) ) ) # ( !\d.clip_rect.y1[3]~input_o\ & ( ((!\d.clip_rect.y1[2]~input_o\ & \d.tile.y0[2]~input_o\)) # 
-- (\d.tile.y0[3]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111111001111000011111100111100000000000011000000000000001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.clip_rect.y1[2]~input_o\,
	datac => \ALT_INV_d.tile.y0[3]~input_o\,
	datad => \ALT_INV_d.tile.y0[2]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y1[3]~input_o\,
	combout => \LessThan3~6_combout\);

-- Location: MLABCELL_X59_Y11_N42
\LessThan3~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~7_combout\ = ( \LessThan3~6_combout\ & ( \LessThan3~1_combout\ & ( (!\LessThan3~2_combout\ & !\LessThan3~3_combout\) ) ) ) # ( !\LessThan3~6_combout\ & ( \LessThan3~1_combout\ & ( (!\LessThan3~2_combout\ & (\LessThan3~4_combout\ & 
-- (!\LessThan3~3_combout\ & \LessThan3~5_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000001000001010000010100000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan3~2_combout\,
	datab => \ALT_INV_LessThan3~4_combout\,
	datac => \ALT_INV_LessThan3~3_combout\,
	datad => \ALT_INV_LessThan3~5_combout\,
	datae => \ALT_INV_LessThan3~6_combout\,
	dataf => \ALT_INV_LessThan3~1_combout\,
	combout => \LessThan3~7_combout\);

-- Location: LABCELL_X61_Y11_N57
\LessThan3~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~17_combout\ = ( !\d.clip_rect.y1[8]~input_o\ & ( \d.tile.y0[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y0[8]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y1[8]~input_o\,
	combout => \LessThan3~17_combout\);

-- Location: LABCELL_X61_Y11_N0
\LessThan3~18\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~18_combout\ = ( !\LessThan3~11_combout\ & ( \d.tile.y0[9]~input_o\ & ( (!\LessThan3~12_combout\ & (\LessThan3~10_combout\ & ((!\d.clip_rect.y1[9]~input_o\) # (\LessThan3~17_combout\)))) ) ) ) # ( !\LessThan3~11_combout\ & ( 
-- !\d.tile.y0[9]~input_o\ & ( (!\LessThan3~12_combout\ & (\LessThan3~17_combout\ & (\LessThan3~10_combout\ & !\d.clip_rect.y1[9]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001000000000000000000000000000001010000000100000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan3~12_combout\,
	datab => \ALT_INV_LessThan3~17_combout\,
	datac => \ALT_INV_LessThan3~10_combout\,
	datad => \ALT_INV_d.clip_rect.y1[9]~input_o\,
	datae => \ALT_INV_LessThan3~11_combout\,
	dataf => \ALT_INV_d.tile.y0[9]~input_o\,
	combout => \LessThan3~18_combout\);

-- Location: LABCELL_X64_Y8_N54
\LessThan3~15\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~15_combout\ = ( \d.clip_rect.y1[13]~input_o\ & ( \d.tile.y0[14]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\) # ((\d.tile.y0[12]~input_o\ & (\d.tile.y0[13]~input_o\ & !\d.clip_rect.y1[12]~input_o\))) ) ) ) # ( !\d.clip_rect.y1[13]~input_o\ & ( 
-- \d.tile.y0[14]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\) # (((\d.tile.y0[12]~input_o\ & !\d.clip_rect.y1[12]~input_o\)) # (\d.tile.y0[13]~input_o\)) ) ) ) # ( \d.clip_rect.y1[13]~input_o\ & ( !\d.tile.y0[14]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\ 
-- & (\d.tile.y0[12]~input_o\ & (\d.tile.y0[13]~input_o\ & !\d.clip_rect.y1[12]~input_o\))) ) ) ) # ( !\d.clip_rect.y1[13]~input_o\ & ( !\d.tile.y0[14]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\ & (((\d.tile.y0[12]~input_o\ & !\d.clip_rect.y1[12]~input_o\)) 
-- # (\d.tile.y0[13]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010101000001010000000100000000010111111101011111010101110101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[14]~input_o\,
	datab => \ALT_INV_d.tile.y0[12]~input_o\,
	datac => \ALT_INV_d.tile.y0[13]~input_o\,
	datad => \ALT_INV_d.clip_rect.y1[12]~input_o\,
	datae => \ALT_INV_d.clip_rect.y1[13]~input_o\,
	dataf => \ALT_INV_d.tile.y0[14]~input_o\,
	combout => \LessThan3~15_combout\);

-- Location: LABCELL_X61_Y11_N42
\LessThan3~16\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~16_combout\ = ( \d.clip_rect.y1[10]~input_o\ & ( \d.clip_rect.y1[11]~input_o\ & ( !\LessThan3~15_combout\ ) ) ) # ( !\d.clip_rect.y1[10]~input_o\ & ( \d.clip_rect.y1[11]~input_o\ & ( (!\LessThan3~15_combout\ & ((!\LessThan3~10_combout\) # 
-- ((!\d.tile.y0[11]~input_o\) # (!\d.tile.y0[10]~input_o\)))) ) ) ) # ( \d.clip_rect.y1[10]~input_o\ & ( !\d.clip_rect.y1[11]~input_o\ & ( (!\LessThan3~15_combout\ & ((!\LessThan3~10_combout\) # (!\d.tile.y0[11]~input_o\))) ) ) ) # ( 
-- !\d.clip_rect.y1[10]~input_o\ & ( !\d.clip_rect.y1[11]~input_o\ & ( (!\LessThan3~15_combout\ & ((!\LessThan3~10_combout\) # ((!\d.tile.y0[11]~input_o\ & !\d.tile.y0[10]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1110000010100000111000001110000011110000111000001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan3~10_combout\,
	datab => \ALT_INV_d.tile.y0[11]~input_o\,
	datac => \ALT_INV_LessThan3~15_combout\,
	datad => \ALT_INV_d.tile.y0[10]~input_o\,
	datae => \ALT_INV_d.clip_rect.y1[10]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y1[11]~input_o\,
	combout => \LessThan3~16_combout\);

-- Location: LABCELL_X61_Y11_N6
\LessThan3~19\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan3~19_combout\ = ( \LessThan3~18_combout\ & ( \LessThan3~16_combout\ & ( !\LessThan3~0_combout\ ) ) ) # ( !\LessThan3~18_combout\ & ( \LessThan3~16_combout\ & ( (!\LessThan3~0_combout\ & (\LessThan3~14_combout\ & ((!\LessThan3~9_combout\) # 
-- (\LessThan3~7_combout\)))) ) ) ) # ( \LessThan3~18_combout\ & ( !\LessThan3~16_combout\ & ( !\LessThan3~0_combout\ ) ) ) # ( !\LessThan3~18_combout\ & ( !\LessThan3~16_combout\ & ( !\LessThan3~0_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010101010101010101010101010101000100000001000101010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan3~0_combout\,
	datab => \ALT_INV_LessThan3~14_combout\,
	datac => \ALT_INV_LessThan3~9_combout\,
	datad => \ALT_INV_LessThan3~7_combout\,
	datae => \ALT_INV_LessThan3~18_combout\,
	dataf => \ALT_INV_LessThan3~16_combout\,
	combout => \LessThan3~19_combout\);

-- Location: LABCELL_X63_Y11_N45
\LessThan2~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~0_combout\ = ( \d.clip_rect.y0[15]~input_o\ & ( !\d.tile.y1[15]~input_o\ ) ) # ( !\d.clip_rect.y0[15]~input_o\ & ( \d.tile.y1[15]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010110101010101010101010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y1[15]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y0[15]~input_o\,
	combout => \LessThan2~0_combout\);

-- Location: IOIBUF_X89_Y15_N4
\d.tile.y1[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(11),
	o => \d.tile.y1[11]~input_o\);

-- Location: IOIBUF_X36_Y81_N52
\d.tile.y1[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(12),
	o => \d.tile.y1[12]~input_o\);

-- Location: IOIBUF_X72_Y0_N52
\d.tile.y1[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(14),
	o => \d.tile.y1[14]~input_o\);

-- Location: IOIBUF_X80_Y0_N52
\d.tile.y1[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(13),
	o => \d.tile.y1[13]~input_o\);

-- Location: LABCELL_X64_Y8_N42
\LessThan2~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~13_combout\ = ( \d.clip_rect.y0[12]~input_o\ & ( \d.tile.y1[13]~input_o\ & ( (!\d.tile.y1[14]~input_o\ & (((\d.clip_rect.y0[13]~input_o\ & !\d.tile.y1[12]~input_o\)) # (\d.clip_rect.y0[14]~input_o\))) # (\d.tile.y1[14]~input_o\ & 
-- (\d.clip_rect.y0[13]~input_o\ & (!\d.tile.y1[12]~input_o\ & \d.clip_rect.y0[14]~input_o\))) ) ) ) # ( !\d.clip_rect.y0[12]~input_o\ & ( \d.tile.y1[13]~input_o\ & ( (!\d.tile.y1[14]~input_o\ & \d.clip_rect.y0[14]~input_o\) ) ) ) # ( 
-- \d.clip_rect.y0[12]~input_o\ & ( !\d.tile.y1[13]~input_o\ & ( (!\d.tile.y1[14]~input_o\ & (((!\d.tile.y1[12]~input_o\) # (\d.clip_rect.y0[14]~input_o\)) # (\d.clip_rect.y0[13]~input_o\))) # (\d.tile.y1[14]~input_o\ & (\d.clip_rect.y0[14]~input_o\ & 
-- ((!\d.tile.y1[12]~input_o\) # (\d.clip_rect.y0[13]~input_o\)))) ) ) ) # ( !\d.clip_rect.y0[12]~input_o\ & ( !\d.tile.y1[13]~input_o\ & ( (!\d.clip_rect.y0[13]~input_o\ & (!\d.tile.y1[14]~input_o\ & \d.clip_rect.y0[14]~input_o\)) # 
-- (\d.clip_rect.y0[13]~input_o\ & ((!\d.tile.y1[14]~input_o\) # (\d.clip_rect.y0[14]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000011110101110100001111110100000000111100000100000011110100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[13]~input_o\,
	datab => \ALT_INV_d.tile.y1[12]~input_o\,
	datac => \ALT_INV_d.tile.y1[14]~input_o\,
	datad => \ALT_INV_d.clip_rect.y0[14]~input_o\,
	datae => \ALT_INV_d.clip_rect.y0[12]~input_o\,
	dataf => \ALT_INV_d.tile.y1[13]~input_o\,
	combout => \LessThan2~13_combout\);

-- Location: LABCELL_X64_Y8_N12
\LessThan2~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~8_combout\ = ( \d.clip_rect.y0[12]~input_o\ & ( \d.tile.y1[13]~input_o\ & ( (\d.clip_rect.y0[13]~input_o\ & (\d.tile.y1[12]~input_o\ & (!\d.tile.y1[14]~input_o\ $ (\d.clip_rect.y0[14]~input_o\)))) ) ) ) # ( !\d.clip_rect.y0[12]~input_o\ & ( 
-- \d.tile.y1[13]~input_o\ & ( (\d.clip_rect.y0[13]~input_o\ & (!\d.tile.y1[12]~input_o\ & (!\d.tile.y1[14]~input_o\ $ (\d.clip_rect.y0[14]~input_o\)))) ) ) ) # ( \d.clip_rect.y0[12]~input_o\ & ( !\d.tile.y1[13]~input_o\ & ( (!\d.clip_rect.y0[13]~input_o\ & 
-- (\d.tile.y1[12]~input_o\ & (!\d.tile.y1[14]~input_o\ $ (\d.clip_rect.y0[14]~input_o\)))) ) ) ) # ( !\d.clip_rect.y0[12]~input_o\ & ( !\d.tile.y1[13]~input_o\ & ( (!\d.clip_rect.y0[13]~input_o\ & (!\d.tile.y1[12]~input_o\ & (!\d.tile.y1[14]~input_o\ $ 
-- (\d.clip_rect.y0[14]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000000000001000001000000000001001000000000001000001000000000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[13]~input_o\,
	datab => \ALT_INV_d.tile.y1[12]~input_o\,
	datac => \ALT_INV_d.tile.y1[14]~input_o\,
	datad => \ALT_INV_d.clip_rect.y0[14]~input_o\,
	datae => \ALT_INV_d.clip_rect.y0[12]~input_o\,
	dataf => \ALT_INV_d.tile.y1[13]~input_o\,
	combout => \LessThan2~8_combout\);

-- Location: IOIBUF_X89_Y9_N38
\d.tile.y1[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(10),
	o => \d.tile.y1[10]~input_o\);

-- Location: LABCELL_X62_Y11_N6
\LessThan2~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~14_combout\ = ( \LessThan2~8_combout\ & ( \d.tile.y1[10]~input_o\ & ( (!\LessThan2~13_combout\ & ((!\d.clip_rect.y0[11]~input_o\) # (\d.tile.y1[11]~input_o\))) ) ) ) # ( !\LessThan2~8_combout\ & ( \d.tile.y1[10]~input_o\ & ( 
-- !\LessThan2~13_combout\ ) ) ) # ( \LessThan2~8_combout\ & ( !\d.tile.y1[10]~input_o\ & ( (!\LessThan2~13_combout\ & ((!\d.clip_rect.y0[11]~input_o\ & ((!\d.clip_rect.y0[10]~input_o\) # (\d.tile.y1[11]~input_o\))) # (\d.clip_rect.y0[11]~input_o\ & 
-- (\d.tile.y1[11]~input_o\ & !\d.clip_rect.y0[10]~input_o\)))) ) ) ) # ( !\LessThan2~8_combout\ & ( !\d.tile.y1[10]~input_o\ & ( !\LessThan2~13_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111000011110000101100000010000011110000111100001011000010110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[11]~input_o\,
	datab => \ALT_INV_d.tile.y1[11]~input_o\,
	datac => \ALT_INV_LessThan2~13_combout\,
	datad => \ALT_INV_d.clip_rect.y0[10]~input_o\,
	datae => \ALT_INV_LessThan2~8_combout\,
	dataf => \ALT_INV_d.tile.y1[10]~input_o\,
	combout => \LessThan2~14_combout\);

-- Location: IOIBUF_X38_Y0_N18
\d.tile.y1[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(2),
	o => \d.tile.y1[2]~input_o\);

-- Location: IOIBUF_X36_Y0_N1
\d.tile.y1[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(3),
	o => \d.tile.y1[3]~input_o\);

-- Location: MLABCELL_X59_Y11_N6
\LessThan2~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~4_combout\ = ( \d.tile.y1[3]~input_o\ & ( (\d.clip_rect.y0[3]~input_o\ & (\d.clip_rect.y0[2]~input_o\ & !\d.tile.y1[2]~input_o\)) ) ) # ( !\d.tile.y1[3]~input_o\ & ( ((\d.clip_rect.y0[2]~input_o\ & !\d.tile.y1[2]~input_o\)) # 
-- (\d.clip_rect.y0[3]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111010101110101011101010111010100010000000100000001000000010000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[3]~input_o\,
	datab => \ALT_INV_d.clip_rect.y0[2]~input_o\,
	datac => \ALT_INV_d.tile.y1[2]~input_o\,
	dataf => \ALT_INV_d.tile.y1[3]~input_o\,
	combout => \LessThan2~4_combout\);

-- Location: IOIBUF_X18_Y81_N41
\d.tile.y1[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(0),
	o => \d.tile.y1[0]~input_o\);

-- Location: IOIBUF_X54_Y0_N52
\d.tile.y1[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(1),
	o => \d.tile.y1[1]~input_o\);

-- Location: MLABCELL_X59_Y11_N33
\LessThan2~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~2_combout\ = ( \d.clip_rect.y0[0]~input_o\ & ( (!\d.tile.y1[0]~input_o\ & ((!\d.tile.y1[1]~input_o\) # (\d.clip_rect.y0[1]~input_o\))) # (\d.tile.y1[0]~input_o\ & (!\d.tile.y1[1]~input_o\ & \d.clip_rect.y0[1]~input_o\)) ) ) # ( 
-- !\d.clip_rect.y0[0]~input_o\ & ( (!\d.tile.y1[1]~input_o\ & \d.clip_rect.y0[1]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011110000000000001111000011000000111111001100000011111100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.tile.y1[0]~input_o\,
	datac => \ALT_INV_d.tile.y1[1]~input_o\,
	datad => \ALT_INV_d.clip_rect.y0[1]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y0[0]~input_o\,
	combout => \LessThan2~2_combout\);

-- Location: MLABCELL_X59_Y11_N39
\LessThan2~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~3_combout\ = ( \d.tile.y1[3]~input_o\ & ( (\d.clip_rect.y0[3]~input_o\ & (!\d.clip_rect.y0[2]~input_o\ $ (\d.tile.y1[2]~input_o\))) ) ) # ( !\d.tile.y1[3]~input_o\ & ( (!\d.clip_rect.y0[3]~input_o\ & (!\d.clip_rect.y0[2]~input_o\ $ 
-- (\d.tile.y1[2]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010000000001010101000000000101001010000000001010101000000000101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[3]~input_o\,
	datac => \ALT_INV_d.clip_rect.y0[2]~input_o\,
	datad => \ALT_INV_d.tile.y1[2]~input_o\,
	dataf => \ALT_INV_d.tile.y1[3]~input_o\,
	combout => \LessThan2~3_combout\);

-- Location: IOIBUF_X89_Y11_N78
\d.tile.y1[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(6),
	o => \d.tile.y1[6]~input_o\);

-- Location: IOIBUF_X38_Y81_N1
\d.tile.y1[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(7),
	o => \d.tile.y1[7]~input_o\);

-- Location: IOIBUF_X38_Y81_N52
\d.tile.y1[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(5),
	o => \d.tile.y1[5]~input_o\);

-- Location: MLABCELL_X59_Y11_N0
\LessThan2~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~1_combout\ = ( \d.clip_rect.y0[7]~input_o\ & ( \d.tile.y1[5]~input_o\ & ( (\d.clip_rect.y0[5]~input_o\ & (\d.tile.y1[7]~input_o\ & (!\d.clip_rect.y0[6]~input_o\ $ (\d.tile.y1[6]~input_o\)))) ) ) ) # ( !\d.clip_rect.y0[7]~input_o\ & ( 
-- \d.tile.y1[5]~input_o\ & ( (\d.clip_rect.y0[5]~input_o\ & (!\d.tile.y1[7]~input_o\ & (!\d.clip_rect.y0[6]~input_o\ $ (\d.tile.y1[6]~input_o\)))) ) ) ) # ( \d.clip_rect.y0[7]~input_o\ & ( !\d.tile.y1[5]~input_o\ & ( (!\d.clip_rect.y0[5]~input_o\ & 
-- (\d.tile.y1[7]~input_o\ & (!\d.clip_rect.y0[6]~input_o\ $ (\d.tile.y1[6]~input_o\)))) ) ) ) # ( !\d.clip_rect.y0[7]~input_o\ & ( !\d.tile.y1[5]~input_o\ & ( (!\d.clip_rect.y0[5]~input_o\ & (!\d.tile.y1[7]~input_o\ & (!\d.clip_rect.y0[6]~input_o\ $ 
-- (\d.tile.y1[6]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1001000000000000000000001001000000001001000000000000000000001001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[6]~input_o\,
	datab => \ALT_INV_d.tile.y1[6]~input_o\,
	datac => \ALT_INV_d.clip_rect.y0[5]~input_o\,
	datad => \ALT_INV_d.tile.y1[7]~input_o\,
	datae => \ALT_INV_d.clip_rect.y0[7]~input_o\,
	dataf => \ALT_INV_d.tile.y1[5]~input_o\,
	combout => \LessThan2~1_combout\);

-- Location: IOIBUF_X89_Y15_N55
\d.tile.y1[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(4),
	o => \d.tile.y1[4]~input_o\);

-- Location: MLABCELL_X59_Y11_N18
\LessThan2~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~5_combout\ = ( \LessThan2~1_combout\ & ( \d.tile.y1[4]~input_o\ & ( (\d.clip_rect.y0[4]~input_o\ & (((\LessThan2~2_combout\ & \LessThan2~3_combout\)) # (\LessThan2~4_combout\))) ) ) ) # ( \LessThan2~1_combout\ & ( !\d.tile.y1[4]~input_o\ & ( 
-- (!\d.clip_rect.y0[4]~input_o\ & (((\LessThan2~2_combout\ & \LessThan2~3_combout\)) # (\LessThan2~4_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000001000100010101000000000000000000001000100010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[4]~input_o\,
	datab => \ALT_INV_LessThan2~4_combout\,
	datac => \ALT_INV_LessThan2~2_combout\,
	datad => \ALT_INV_LessThan2~3_combout\,
	datae => \ALT_INV_LessThan2~1_combout\,
	dataf => \ALT_INV_d.tile.y1[4]~input_o\,
	combout => \LessThan2~5_combout\);

-- Location: MLABCELL_X59_Y11_N24
\LessThan2~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~6_combout\ = ( \d.clip_rect.y0[7]~input_o\ & ( \d.tile.y1[5]~input_o\ & ( (!\d.tile.y1[7]~input_o\) # ((\d.clip_rect.y0[6]~input_o\ & !\d.tile.y1[6]~input_o\)) ) ) ) # ( !\d.clip_rect.y0[7]~input_o\ & ( \d.tile.y1[5]~input_o\ & ( 
-- (\d.clip_rect.y0[6]~input_o\ & (!\d.tile.y1[6]~input_o\ & !\d.tile.y1[7]~input_o\)) ) ) ) # ( \d.clip_rect.y0[7]~input_o\ & ( !\d.tile.y1[5]~input_o\ & ( (!\d.tile.y1[7]~input_o\) # ((!\d.clip_rect.y0[6]~input_o\ & (!\d.tile.y1[6]~input_o\ & 
-- \d.clip_rect.y0[5]~input_o\)) # (\d.clip_rect.y0[6]~input_o\ & ((!\d.tile.y1[6]~input_o\) # (\d.clip_rect.y0[5]~input_o\)))) ) ) ) # ( !\d.clip_rect.y0[7]~input_o\ & ( !\d.tile.y1[5]~input_o\ & ( (!\d.tile.y1[7]~input_o\ & ((!\d.clip_rect.y0[6]~input_o\ & 
-- (!\d.tile.y1[6]~input_o\ & \d.clip_rect.y0[5]~input_o\)) # (\d.clip_rect.y0[6]~input_o\ & ((!\d.tile.y1[6]~input_o\) # (\d.clip_rect.y0[5]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100110100000000111111110100110101000100000000001111111101000100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[6]~input_o\,
	datab => \ALT_INV_d.tile.y1[6]~input_o\,
	datac => \ALT_INV_d.clip_rect.y0[5]~input_o\,
	datad => \ALT_INV_d.tile.y1[7]~input_o\,
	datae => \ALT_INV_d.clip_rect.y0[7]~input_o\,
	dataf => \ALT_INV_d.tile.y1[5]~input_o\,
	combout => \LessThan2~6_combout\);

-- Location: MLABCELL_X59_Y11_N30
\LessThan2~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~7_combout\ = ( !\LessThan2~6_combout\ & ( (!\d.clip_rect.y0[4]~input_o\) # ((!\LessThan2~1_combout\) # (\d.tile.y1[4]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111101011111111111110101111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[4]~input_o\,
	datac => \ALT_INV_LessThan2~1_combout\,
	datad => \ALT_INV_d.tile.y1[4]~input_o\,
	dataf => \ALT_INV_LessThan2~6_combout\,
	combout => \LessThan2~7_combout\);

-- Location: LABCELL_X62_Y11_N33
\LessThan2~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~10_combout\ = ( \d.clip_rect.y0[10]~input_o\ & ( !\d.tile.y1[10]~input_o\ ) ) # ( !\d.clip_rect.y0[10]~input_o\ & ( \d.tile.y1[10]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_d.tile.y1[10]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y0[10]~input_o\,
	combout => \LessThan2~10_combout\);

-- Location: IOIBUF_X38_Y0_N35
\d.tile.y1[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(9),
	o => \d.tile.y1[9]~input_o\);

-- Location: IOIBUF_X89_Y13_N4
\d.tile.y1[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.y1\(8),
	o => \d.tile.y1[8]~input_o\);

-- Location: LABCELL_X62_Y11_N27
\LessThan2~15\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~15_combout\ = ( !\d.tile.y1[8]~input_o\ & ( \d.clip_rect.y0[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_d.clip_rect.y0[8]~input_o\,
	dataf => \ALT_INV_d.tile.y1[8]~input_o\,
	combout => \LessThan2~15_combout\);

-- Location: LABCELL_X62_Y11_N24
\LessThan2~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~9_combout\ = ( \d.clip_rect.y0[11]~input_o\ & ( !\d.tile.y1[11]~input_o\ ) ) # ( !\d.clip_rect.y0[11]~input_o\ & ( \d.tile.y1[11]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001111001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.tile.y1[11]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y0[11]~input_o\,
	combout => \LessThan2~9_combout\);

-- Location: LABCELL_X62_Y11_N36
\LessThan2~16\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~16_combout\ = ( \LessThan2~15_combout\ & ( !\LessThan2~9_combout\ & ( (!\LessThan2~10_combout\ & (\LessThan2~8_combout\ & ((!\d.tile.y1[9]~input_o\) # (\d.clip_rect.y0[9]~input_o\)))) ) ) ) # ( !\LessThan2~15_combout\ & ( !\LessThan2~9_combout\ 
-- & ( (!\LessThan2~10_combout\ & (\LessThan2~8_combout\ & (\d.clip_rect.y0[9]~input_o\ & !\d.tile.y1[9]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001000000000001000100000001000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan2~10_combout\,
	datab => \ALT_INV_LessThan2~8_combout\,
	datac => \ALT_INV_d.clip_rect.y0[9]~input_o\,
	datad => \ALT_INV_d.tile.y1[9]~input_o\,
	datae => \ALT_INV_LessThan2~15_combout\,
	dataf => \ALT_INV_LessThan2~9_combout\,
	combout => \LessThan2~16_combout\);

-- Location: LABCELL_X64_Y12_N30
\LessThan2~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~11_combout\ = ( \d.tile.y1[8]~input_o\ & ( !\d.clip_rect.y0[8]~input_o\ ) ) # ( !\d.tile.y1[8]~input_o\ & ( \d.clip_rect.y0[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001111001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.clip_rect.y0[8]~input_o\,
	dataf => \ALT_INV_d.tile.y1[8]~input_o\,
	combout => \LessThan2~11_combout\);

-- Location: LABCELL_X62_Y11_N15
\LessThan2~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~12_combout\ = ( !\LessThan2~11_combout\ & ( !\LessThan2~9_combout\ & ( (!\LessThan2~10_combout\ & (\LessThan2~8_combout\ & (!\d.clip_rect.y0[9]~input_o\ $ (\d.tile.y1[9]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000000010000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan2~10_combout\,
	datab => \ALT_INV_d.clip_rect.y0[9]~input_o\,
	datac => \ALT_INV_LessThan2~8_combout\,
	datad => \ALT_INV_d.tile.y1[9]~input_o\,
	datae => \ALT_INV_LessThan2~11_combout\,
	dataf => \ALT_INV_LessThan2~9_combout\,
	combout => \LessThan2~12_combout\);

-- Location: LABCELL_X62_Y11_N42
\LessThan2~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan2~17_combout\ = ( \LessThan2~16_combout\ & ( \LessThan2~12_combout\ & ( !\LessThan2~0_combout\ ) ) ) # ( !\LessThan2~16_combout\ & ( \LessThan2~12_combout\ & ( (!\LessThan2~0_combout\ & ((!\LessThan2~14_combout\) # ((!\LessThan2~7_combout\) # 
-- (\LessThan2~5_combout\)))) ) ) ) # ( \LessThan2~16_combout\ & ( !\LessThan2~12_combout\ & ( !\LessThan2~0_combout\ ) ) ) # ( !\LessThan2~16_combout\ & ( !\LessThan2~12_combout\ & ( (!\LessThan2~0_combout\ & !\LessThan2~14_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000100010001000101010101010101010101010100010101010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan2~0_combout\,
	datab => \ALT_INV_LessThan2~14_combout\,
	datac => \ALT_INV_LessThan2~5_combout\,
	datad => \ALT_INV_LessThan2~7_combout\,
	datae => \ALT_INV_LessThan2~16_combout\,
	dataf => \ALT_INV_LessThan2~12_combout\,
	combout => \LessThan2~17_combout\);

-- Location: IOIBUF_X68_Y0_N1
\d.clip_rect.x1[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(15),
	o => \d.clip_rect.x1[15]~input_o\);

-- Location: IOIBUF_X62_Y0_N35
\d.tile.x0[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(15),
	o => \d.tile.x0[15]~input_o\);

-- Location: LABCELL_X63_Y10_N57
\comb~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \comb~1_combout\ = ( \d.clip_rect.x0[15]~input_o\ & ( (!\d.tile.x1[15]~input_o\) # ((!\d.clip_rect.x1[15]~input_o\ & \d.tile.x0[15]~input_o\)) ) ) # ( !\d.clip_rect.x0[15]~input_o\ & ( (!\d.clip_rect.x1[15]~input_o\ & \d.tile.x0[15]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010000010100000101011111111000010101111111100001010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[15]~input_o\,
	datac => \ALT_INV_d.tile.x0[15]~input_o\,
	datad => \ALT_INV_d.tile.x1[15]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	combout => \comb~1_combout\);

-- Location: IOIBUF_X72_Y0_N35
\d.clip_rect.x1[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(3),
	o => \d.clip_rect.x1[3]~input_o\);

-- Location: IOIBUF_X40_Y81_N35
\d.tile.x0[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(2),
	o => \d.tile.x0[2]~input_o\);

-- Location: IOIBUF_X89_Y6_N38
\d.clip_rect.x1[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(2),
	o => \d.clip_rect.x1[2]~input_o\);

-- Location: IOIBUF_X52_Y0_N35
\d.tile.x0[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(3),
	o => \d.tile.x0[3]~input_o\);

-- Location: LABCELL_X63_Y7_N27
\LessThan1~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~3_combout\ = ( \d.clip_rect.x1[2]~input_o\ & ( \d.tile.x0[3]~input_o\ & ( (\d.clip_rect.x1[3]~input_o\ & \d.tile.x0[2]~input_o\) ) ) ) # ( !\d.clip_rect.x1[2]~input_o\ & ( \d.tile.x0[3]~input_o\ & ( (\d.clip_rect.x1[3]~input_o\ & 
-- !\d.tile.x0[2]~input_o\) ) ) ) # ( \d.clip_rect.x1[2]~input_o\ & ( !\d.tile.x0[3]~input_o\ & ( (!\d.clip_rect.x1[3]~input_o\ & \d.tile.x0[2]~input_o\) ) ) ) # ( !\d.clip_rect.x1[2]~input_o\ & ( !\d.tile.x0[3]~input_o\ & ( (!\d.clip_rect.x1[3]~input_o\ & 
-- !\d.tile.x0[2]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010000010100000000010100000101001010000010100000000010100000101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[3]~input_o\,
	datac => \ALT_INV_d.tile.x0[2]~input_o\,
	datae => \ALT_INV_d.clip_rect.x1[2]~input_o\,
	dataf => \ALT_INV_d.tile.x0[3]~input_o\,
	combout => \LessThan1~3_combout\);

-- Location: LABCELL_X63_Y7_N42
\LessThan1~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~4_combout\ = ( \d.tile.x0[2]~input_o\ & ( \d.tile.x0[3]~input_o\ & ( (!\d.clip_rect.x1[2]~input_o\) # (!\d.clip_rect.x1[3]~input_o\) ) ) ) # ( !\d.tile.x0[2]~input_o\ & ( \d.tile.x0[3]~input_o\ & ( !\d.clip_rect.x1[3]~input_o\ ) ) ) # ( 
-- \d.tile.x0[2]~input_o\ & ( !\d.tile.x0[3]~input_o\ & ( (!\d.clip_rect.x1[2]~input_o\ & !\d.clip_rect.x1[3]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000101000001010000011110000111100001111101011111010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[2]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[3]~input_o\,
	datae => \ALT_INV_d.tile.x0[2]~input_o\,
	dataf => \ALT_INV_d.tile.x0[3]~input_o\,
	combout => \LessThan1~4_combout\);

-- Location: IOIBUF_X32_Y81_N35
\d.clip_rect.x1[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(4),
	o => \d.clip_rect.x1[4]~input_o\);

-- Location: IOIBUF_X80_Y0_N18
\d.tile.x0[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(0),
	o => \d.tile.x0[0]~input_o\);

-- Location: IOIBUF_X52_Y0_N52
\d.tile.x0[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(1),
	o => \d.tile.x0[1]~input_o\);

-- Location: IOIBUF_X89_Y8_N55
\d.clip_rect.x1[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(1),
	o => \d.clip_rect.x1[1]~input_o\);

-- Location: IOIBUF_X89_Y6_N4
\d.clip_rect.x1[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(0),
	o => \d.clip_rect.x1[0]~input_o\);

-- Location: LABCELL_X63_Y10_N27
\LessThan1~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~2_combout\ = ( \d.clip_rect.x1[0]~input_o\ & ( (\d.tile.x0[1]~input_o\ & !\d.clip_rect.x1[1]~input_o\) ) ) # ( !\d.clip_rect.x1[0]~input_o\ & ( (!\d.tile.x0[0]~input_o\ & (\d.tile.x0[1]~input_o\ & !\d.clip_rect.x1[1]~input_o\)) # 
-- (\d.tile.x0[0]~input_o\ & ((!\d.clip_rect.x1[1]~input_o\) # (\d.tile.x0[1]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111000101110001011100010111000100110000001100000011000000110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x0[0]~input_o\,
	datab => \ALT_INV_d.tile.x0[1]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[1]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[0]~input_o\,
	combout => \LessThan1~2_combout\);

-- Location: IOIBUF_X82_Y0_N41
\d.tile.x0[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(4),
	o => \d.tile.x0[4]~input_o\);

-- Location: IOIBUF_X70_Y0_N18
\d.tile.x0[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(5),
	o => \d.tile.x0[5]~input_o\);

-- Location: IOIBUF_X74_Y0_N58
\d.clip_rect.x1[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(5),
	o => \d.clip_rect.x1[5]~input_o\);

-- Location: IOIBUF_X70_Y0_N35
\d.clip_rect.x1[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(7),
	o => \d.clip_rect.x1[7]~input_o\);

-- Location: IOIBUF_X74_Y0_N75
\d.clip_rect.x1[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(6),
	o => \d.clip_rect.x1[6]~input_o\);

-- Location: IOIBUF_X70_Y0_N52
\d.tile.x0[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(7),
	o => \d.tile.x0[7]~input_o\);

-- Location: IOIBUF_X32_Y0_N1
\d.tile.x0[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(6),
	o => \d.tile.x0[6]~input_o\);

-- Location: LABCELL_X64_Y7_N24
\LessThan1~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~1_combout\ = ( \d.tile.x0[7]~input_o\ & ( \d.tile.x0[6]~input_o\ & ( (\d.clip_rect.x1[7]~input_o\ & (\d.clip_rect.x1[6]~input_o\ & (!\d.tile.x0[5]~input_o\ $ (\d.clip_rect.x1[5]~input_o\)))) ) ) ) # ( !\d.tile.x0[7]~input_o\ & ( 
-- \d.tile.x0[6]~input_o\ & ( (!\d.clip_rect.x1[7]~input_o\ & (\d.clip_rect.x1[6]~input_o\ & (!\d.tile.x0[5]~input_o\ $ (\d.clip_rect.x1[5]~input_o\)))) ) ) ) # ( \d.tile.x0[7]~input_o\ & ( !\d.tile.x0[6]~input_o\ & ( (\d.clip_rect.x1[7]~input_o\ & 
-- (!\d.clip_rect.x1[6]~input_o\ & (!\d.tile.x0[5]~input_o\ $ (\d.clip_rect.x1[5]~input_o\)))) ) ) ) # ( !\d.tile.x0[7]~input_o\ & ( !\d.tile.x0[6]~input_o\ & ( (!\d.clip_rect.x1[7]~input_o\ & (!\d.clip_rect.x1[6]~input_o\ & (!\d.tile.x0[5]~input_o\ $ 
-- (\d.clip_rect.x1[5]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1001000000000000000010010000000000000000100100000000000000001001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x0[5]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[5]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[7]~input_o\,
	datad => \ALT_INV_d.clip_rect.x1[6]~input_o\,
	datae => \ALT_INV_d.tile.x0[7]~input_o\,
	dataf => \ALT_INV_d.tile.x0[6]~input_o\,
	combout => \LessThan1~1_combout\);

-- Location: LABCELL_X64_Y7_N6
\LessThan1~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~5_combout\ = ( \d.tile.x0[4]~input_o\ & ( \LessThan1~1_combout\ & ( (\d.clip_rect.x1[4]~input_o\ & (((\LessThan1~3_combout\ & \LessThan1~2_combout\)) # (\LessThan1~4_combout\))) ) ) ) # ( !\d.tile.x0[4]~input_o\ & ( \LessThan1~1_combout\ & ( 
-- (!\d.clip_rect.x1[4]~input_o\ & (((\LessThan1~3_combout\ & \LessThan1~2_combout\)) # (\LessThan1~4_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000110000011100000000001100000111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan1~3_combout\,
	datab => \ALT_INV_LessThan1~4_combout\,
	datac => \ALT_INV_d.clip_rect.x1[4]~input_o\,
	datad => \ALT_INV_LessThan1~2_combout\,
	datae => \ALT_INV_d.tile.x0[4]~input_o\,
	dataf => \ALT_INV_LessThan1~1_combout\,
	combout => \LessThan1~5_combout\);

-- Location: IOIBUF_X66_Y0_N41
\d.tile.x0[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(10),
	o => \d.tile.x0[10]~input_o\);

-- Location: IOIBUF_X66_Y0_N75
\d.clip_rect.x1[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(10),
	o => \d.clip_rect.x1[10]~input_o\);

-- Location: MLABCELL_X65_Y7_N48
\LessThan1~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~10_combout\ = !\d.tile.x0[10]~input_o\ $ (!\d.clip_rect.x1[10]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001111001100001100111100110000110011110011000011001111001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.tile.x0[10]~input_o\,
	datad => \ALT_INV_d.clip_rect.x1[10]~input_o\,
	combout => \LessThan1~10_combout\);

-- Location: IOIBUF_X66_Y0_N58
\d.tile.x0[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(8),
	o => \d.tile.x0[8]~input_o\);

-- Location: IOIBUF_X68_Y0_N52
\d.clip_rect.x1[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(8),
	o => \d.clip_rect.x1[8]~input_o\);

-- Location: MLABCELL_X65_Y7_N27
\LessThan1~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~11_combout\ = ( \d.clip_rect.x1[8]~input_o\ & ( !\d.tile.x0[8]~input_o\ ) ) # ( !\d.clip_rect.x1[8]~input_o\ & ( \d.tile.x0[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101101010101010101001010101010101011010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x0[8]~input_o\,
	datae => \ALT_INV_d.clip_rect.x1[8]~input_o\,
	combout => \LessThan1~11_combout\);

-- Location: IOIBUF_X56_Y0_N35
\d.tile.x0[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(12),
	o => \d.tile.x0[12]~input_o\);

-- Location: IOIBUF_X36_Y0_N35
\d.clip_rect.x1[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(14),
	o => \d.clip_rect.x1[14]~input_o\);

-- Location: IOIBUF_X50_Y0_N41
\d.tile.x0[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(13),
	o => \d.tile.x0[13]~input_o\);

-- Location: IOIBUF_X56_Y0_N18
\d.tile.x0[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(14),
	o => \d.tile.x0[14]~input_o\);

-- Location: IOIBUF_X60_Y0_N52
\d.clip_rect.x1[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(12),
	o => \d.clip_rect.x1[12]~input_o\);

-- Location: IOIBUF_X78_Y0_N18
\d.clip_rect.x1[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(13),
	o => \d.clip_rect.x1[13]~input_o\);

-- Location: LABCELL_X62_Y7_N36
\LessThan1~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~8_combout\ = ( \d.clip_rect.x1[12]~input_o\ & ( \d.clip_rect.x1[13]~input_o\ & ( (\d.tile.x0[12]~input_o\ & (\d.tile.x0[13]~input_o\ & (!\d.clip_rect.x1[14]~input_o\ $ (\d.tile.x0[14]~input_o\)))) ) ) ) # ( !\d.clip_rect.x1[12]~input_o\ & ( 
-- \d.clip_rect.x1[13]~input_o\ & ( (!\d.tile.x0[12]~input_o\ & (\d.tile.x0[13]~input_o\ & (!\d.clip_rect.x1[14]~input_o\ $ (\d.tile.x0[14]~input_o\)))) ) ) ) # ( \d.clip_rect.x1[12]~input_o\ & ( !\d.clip_rect.x1[13]~input_o\ & ( (\d.tile.x0[12]~input_o\ & 
-- (!\d.tile.x0[13]~input_o\ & (!\d.clip_rect.x1[14]~input_o\ $ (\d.tile.x0[14]~input_o\)))) ) ) ) # ( !\d.clip_rect.x1[12]~input_o\ & ( !\d.clip_rect.x1[13]~input_o\ & ( (!\d.tile.x0[12]~input_o\ & (!\d.tile.x0[13]~input_o\ & (!\d.clip_rect.x1[14]~input_o\ 
-- $ (\d.tile.x0[14]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000000000100000010000000001000000001000000000100000010000000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x0[12]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[14]~input_o\,
	datac => \ALT_INV_d.tile.x0[13]~input_o\,
	datad => \ALT_INV_d.tile.x0[14]~input_o\,
	datae => \ALT_INV_d.clip_rect.x1[12]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[13]~input_o\,
	combout => \LessThan1~8_combout\);

-- Location: IOIBUF_X62_Y0_N52
\d.tile.x0[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(9),
	o => \d.tile.x0[9]~input_o\);

-- Location: IOIBUF_X60_Y0_N1
\d.tile.x0[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.tile.x0\(11),
	o => \d.tile.x0[11]~input_o\);

-- Location: IOIBUF_X74_Y0_N92
\d.clip_rect.x1[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(11),
	o => \d.clip_rect.x1[11]~input_o\);

-- Location: MLABCELL_X65_Y7_N21
\LessThan1~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~9_combout\ = !\d.tile.x0[11]~input_o\ $ (!\d.clip_rect.x1[11]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101101001011010010110100101101001011010010110100101101001011010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x0[11]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[11]~input_o\,
	combout => \LessThan1~9_combout\);

-- Location: IOIBUF_X68_Y0_N18
\d.clip_rect.x1[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => \ww_d.clip_rect.x1\(9),
	o => \d.clip_rect.x1[9]~input_o\);

-- Location: MLABCELL_X65_Y7_N42
\LessThan1~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~12_combout\ = ( !\LessThan1~9_combout\ & ( \d.clip_rect.x1[9]~input_o\ & ( (!\LessThan1~10_combout\ & (!\LessThan1~11_combout\ & (\LessThan1~8_combout\ & \d.tile.x0[9]~input_o\))) ) ) ) # ( !\LessThan1~9_combout\ & ( 
-- !\d.clip_rect.x1[9]~input_o\ & ( (!\LessThan1~10_combout\ & (!\LessThan1~11_combout\ & (\LessThan1~8_combout\ & !\d.tile.x0[9]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000000000000000000000000000000000000010000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan1~10_combout\,
	datab => \ALT_INV_LessThan1~11_combout\,
	datac => \ALT_INV_LessThan1~8_combout\,
	datad => \ALT_INV_d.tile.x0[9]~input_o\,
	datae => \ALT_INV_LessThan1~9_combout\,
	dataf => \ALT_INV_d.clip_rect.x1[9]~input_o\,
	combout => \LessThan1~12_combout\);

-- Location: MLABCELL_X65_Y7_N51
\LessThan1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~0_combout\ = ( \d.clip_rect.x1[15]~input_o\ & ( !\d.tile.x0[15]~input_o\ ) ) # ( !\d.clip_rect.x1[15]~input_o\ & ( \d.tile.x0[15]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_d.tile.x0[15]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[15]~input_o\,
	combout => \LessThan1~0_combout\);

-- Location: MLABCELL_X65_Y7_N18
\LessThan1~15\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~15_combout\ = (!\d.clip_rect.x1[8]~input_o\ & \d.tile.x0[8]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000110000001100000011000000110000001100000011000000110000001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.clip_rect.x1[8]~input_o\,
	datac => \ALT_INV_d.tile.x0[8]~input_o\,
	combout => \LessThan1~15_combout\);

-- Location: MLABCELL_X65_Y7_N30
\LessThan1~16\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~16_combout\ = ( !\LessThan1~9_combout\ & ( \d.clip_rect.x1[9]~input_o\ & ( (\LessThan1~15_combout\ & (\d.tile.x0[9]~input_o\ & (!\LessThan1~10_combout\ & \LessThan1~8_combout\))) ) ) ) # ( !\LessThan1~9_combout\ & ( !\d.clip_rect.x1[9]~input_o\ 
-- & ( (!\LessThan1~10_combout\ & (\LessThan1~8_combout\ & ((\d.tile.x0[9]~input_o\) # (\LessThan1~15_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000001110000000000000000000000000000000100000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan1~15_combout\,
	datab => \ALT_INV_d.tile.x0[9]~input_o\,
	datac => \ALT_INV_LessThan1~10_combout\,
	datad => \ALT_INV_LessThan1~8_combout\,
	datae => \ALT_INV_LessThan1~9_combout\,
	dataf => \ALT_INV_d.clip_rect.x1[9]~input_o\,
	combout => \LessThan1~16_combout\);

-- Location: LABCELL_X62_Y7_N54
\LessThan1~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~13_combout\ = ( \d.clip_rect.x1[12]~input_o\ & ( \d.clip_rect.x1[13]~input_o\ & ( (!\d.clip_rect.x1[14]~input_o\ & \d.tile.x0[14]~input_o\) ) ) ) # ( !\d.clip_rect.x1[12]~input_o\ & ( \d.clip_rect.x1[13]~input_o\ & ( 
-- (!\d.clip_rect.x1[14]~input_o\ & (((\d.tile.x0[12]~input_o\ & \d.tile.x0[13]~input_o\)) # (\d.tile.x0[14]~input_o\))) # (\d.clip_rect.x1[14]~input_o\ & (\d.tile.x0[12]~input_o\ & (\d.tile.x0[13]~input_o\ & \d.tile.x0[14]~input_o\))) ) ) ) # ( 
-- \d.clip_rect.x1[12]~input_o\ & ( !\d.clip_rect.x1[13]~input_o\ & ( (!\d.clip_rect.x1[14]~input_o\ & ((\d.tile.x0[14]~input_o\) # (\d.tile.x0[13]~input_o\))) # (\d.clip_rect.x1[14]~input_o\ & (\d.tile.x0[13]~input_o\ & \d.tile.x0[14]~input_o\)) ) ) ) # ( 
-- !\d.clip_rect.x1[12]~input_o\ & ( !\d.clip_rect.x1[13]~input_o\ & ( (!\d.clip_rect.x1[14]~input_o\ & (((\d.tile.x0[14]~input_o\) # (\d.tile.x0[13]~input_o\)) # (\d.tile.x0[12]~input_o\))) # (\d.clip_rect.x1[14]~input_o\ & (\d.tile.x0[14]~input_o\ & 
-- ((\d.tile.x0[13]~input_o\) # (\d.tile.x0[12]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100110011011111000011001100111100000100110011010000000011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x0[12]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[14]~input_o\,
	datac => \ALT_INV_d.tile.x0[13]~input_o\,
	datad => \ALT_INV_d.tile.x0[14]~input_o\,
	datae => \ALT_INV_d.clip_rect.x1[12]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[13]~input_o\,
	combout => \LessThan1~13_combout\);

-- Location: MLABCELL_X65_Y7_N36
\LessThan1~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~14_combout\ = ( \d.clip_rect.x1[11]~input_o\ & ( \d.tile.x0[11]~input_o\ & ( (!\LessThan1~13_combout\ & ((!\LessThan1~8_combout\) # ((!\d.tile.x0[10]~input_o\) # (\d.clip_rect.x1[10]~input_o\)))) ) ) ) # ( !\d.clip_rect.x1[11]~input_o\ & ( 
-- \d.tile.x0[11]~input_o\ & ( (!\LessThan1~8_combout\ & !\LessThan1~13_combout\) ) ) ) # ( \d.clip_rect.x1[11]~input_o\ & ( !\d.tile.x0[11]~input_o\ & ( !\LessThan1~13_combout\ ) ) ) # ( !\d.clip_rect.x1[11]~input_o\ & ( !\d.tile.x0[11]~input_o\ & ( 
-- (!\LessThan1~13_combout\ & ((!\LessThan1~8_combout\) # ((!\d.tile.x0[10]~input_o\) # (\d.clip_rect.x1[10]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1110000011110000111100001111000010100000101000001110000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan1~8_combout\,
	datab => \ALT_INV_d.tile.x0[10]~input_o\,
	datac => \ALT_INV_LessThan1~13_combout\,
	datad => \ALT_INV_d.clip_rect.x1[10]~input_o\,
	datae => \ALT_INV_d.clip_rect.x1[11]~input_o\,
	dataf => \ALT_INV_d.tile.x0[11]~input_o\,
	combout => \LessThan1~14_combout\);

-- Location: LABCELL_X64_Y7_N36
\LessThan1~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~6_combout\ = ( \d.tile.x0[7]~input_o\ & ( \d.tile.x0[6]~input_o\ & ( (!\d.clip_rect.x1[7]~input_o\) # ((!\d.clip_rect.x1[6]~input_o\) # ((\d.tile.x0[5]~input_o\ & !\d.clip_rect.x1[5]~input_o\))) ) ) ) # ( !\d.tile.x0[7]~input_o\ & ( 
-- \d.tile.x0[6]~input_o\ & ( (!\d.clip_rect.x1[7]~input_o\ & ((!\d.clip_rect.x1[6]~input_o\) # ((\d.tile.x0[5]~input_o\ & !\d.clip_rect.x1[5]~input_o\)))) ) ) ) # ( \d.tile.x0[7]~input_o\ & ( !\d.tile.x0[6]~input_o\ & ( (!\d.clip_rect.x1[7]~input_o\) # 
-- ((\d.tile.x0[5]~input_o\ & (!\d.clip_rect.x1[5]~input_o\ & !\d.clip_rect.x1[6]~input_o\))) ) ) ) # ( !\d.tile.x0[7]~input_o\ & ( !\d.tile.x0[6]~input_o\ & ( (\d.tile.x0[5]~input_o\ & (!\d.clip_rect.x1[5]~input_o\ & (!\d.clip_rect.x1[7]~input_o\ & 
-- !\d.clip_rect.x1[6]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000000000000111101001111000011110000010000001111111111110100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x0[5]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[5]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[7]~input_o\,
	datad => \ALT_INV_d.clip_rect.x1[6]~input_o\,
	datae => \ALT_INV_d.tile.x0[7]~input_o\,
	dataf => \ALT_INV_d.tile.x0[6]~input_o\,
	combout => \LessThan1~6_combout\);

-- Location: LABCELL_X64_Y7_N30
\LessThan1~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~7_combout\ = ( \LessThan1~1_combout\ & ( (!\LessThan1~6_combout\ & ((!\d.tile.x0[4]~input_o\) # (\d.clip_rect.x1[4]~input_o\))) ) ) # ( !\LessThan1~1_combout\ & ( !\LessThan1~6_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111100000000111111110000000011001111000000001100111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.tile.x0[4]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[4]~input_o\,
	datad => \ALT_INV_LessThan1~6_combout\,
	dataf => \ALT_INV_LessThan1~1_combout\,
	combout => \LessThan1~7_combout\);

-- Location: MLABCELL_X65_Y7_N12
\LessThan1~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan1~17_combout\ = ( \LessThan1~14_combout\ & ( \LessThan1~7_combout\ & ( (!\LessThan1~0_combout\ & (((\LessThan1~5_combout\ & \LessThan1~12_combout\)) # (\LessThan1~16_combout\))) ) ) ) # ( !\LessThan1~14_combout\ & ( \LessThan1~7_combout\ & ( 
-- !\LessThan1~0_combout\ ) ) ) # ( \LessThan1~14_combout\ & ( !\LessThan1~7_combout\ & ( (!\LessThan1~0_combout\ & ((\LessThan1~16_combout\) # (\LessThan1~12_combout\))) ) ) ) # ( !\LessThan1~14_combout\ & ( !\LessThan1~7_combout\ & ( !\LessThan1~0_combout\ 
-- ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111000011110000001100001111000011110000111100000001000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan1~5_combout\,
	datab => \ALT_INV_LessThan1~12_combout\,
	datac => \ALT_INV_LessThan1~0_combout\,
	datad => \ALT_INV_LessThan1~16_combout\,
	datae => \ALT_INV_LessThan1~14_combout\,
	dataf => \ALT_INV_LessThan1~7_combout\,
	combout => \LessThan1~17_combout\);

-- Location: LABCELL_X63_Y10_N30
\v~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~0_combout\ = ( \comb~1_combout\ & ( \LessThan1~17_combout\ ) ) # ( !\comb~1_combout\ & ( \LessThan1~17_combout\ ) ) # ( \comb~1_combout\ & ( !\LessThan1~17_combout\ ) ) # ( !\comb~1_combout\ & ( !\LessThan1~17_combout\ & ( (((\LessThan2~17_combout\) # 
-- (\LessThan3~19_combout\)) # (\LessThan0~17_combout\)) # (\comb~2_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111111111111111111111111111111111111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~2_combout\,
	datab => \ALT_INV_LessThan0~17_combout\,
	datac => \ALT_INV_LessThan3~19_combout\,
	datad => \ALT_INV_LessThan2~17_combout\,
	datae => \ALT_INV_comb~1_combout\,
	dataf => \ALT_INV_LessThan1~17_combout\,
	combout => \v~0_combout\);

-- Location: MLABCELL_X65_Y11_N0
\Add3~45\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~45_sumout\ = SUM(( \v~1_combout\ ) + ( VCC ) + ( !VCC ))
-- \Add3~46\ = CARRY(( \v~1_combout\ ) + ( VCC ) + ( !VCC ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~1_combout\,
	cin => GND,
	sumout => \Add3~45_sumout\,
	cout => \Add3~46\);

-- Location: IOIBUF_X89_Y9_N55
\reset~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset,
	o => \reset~input_o\);

-- Location: LABCELL_X63_Y10_N12
\comb~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \comb~3_combout\ = ( \LessThan1~17_combout\ ) # ( !\LessThan1~17_combout\ & ( (\comb~1_combout\) # (\LessThan0~17_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111111111111000011111111111111111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_LessThan0~17_combout\,
	datad => \ALT_INV_comb~1_combout\,
	dataf => \ALT_INV_LessThan1~17_combout\,
	combout => \comb~3_combout\);

-- Location: LABCELL_X63_Y10_N15
\comb~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \comb~4_combout\ = (!\LessThan3~19_combout\ & (!\LessThan2~17_combout\ & !\comb~2_combout\))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010000000000000101000000000000010100000000000001010000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan3~19_combout\,
	datac => \ALT_INV_LessThan2~17_combout\,
	datad => \ALT_INV_comb~2_combout\,
	combout => \comb~4_combout\);

-- Location: LABCELL_X63_Y10_N45
\v~128\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~128_combout\ = ( \comb~4_combout\ & ( (!\r.generate_quads~q\ & ((\r.end_tile~q\) # (\comb~3_combout\))) ) ) # ( !\comb~4_combout\ & ( !\r.generate_quads~q\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010101010101010101010101010101000001010101010100000101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.generate_quads~q\,
	datac => \ALT_INV_comb~3_combout\,
	datad => \ALT_INV_r.end_tile~q\,
	dataf => \ALT_INV_comb~4_combout\,
	combout => \v~128_combout\);

-- Location: LABCELL_X64_Y8_N24
\LessThan7~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~0_combout\ = ( \d.clip_rect.y1[13]~input_o\ & ( \d.tile.y1[13]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\ & (!\d.tile.y1[14]~input_o\ & (!\d.tile.y1[12]~input_o\ $ (\d.clip_rect.y1[12]~input_o\)))) # (\d.clip_rect.y1[14]~input_o\ & 
-- (\d.tile.y1[14]~input_o\ & (!\d.tile.y1[12]~input_o\ $ (\d.clip_rect.y1[12]~input_o\)))) ) ) ) # ( !\d.clip_rect.y1[13]~input_o\ & ( !\d.tile.y1[13]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\ & (!\d.tile.y1[14]~input_o\ & (!\d.tile.y1[12]~input_o\ $ 
-- (\d.clip_rect.y1[12]~input_o\)))) # (\d.clip_rect.y1[14]~input_o\ & (\d.tile.y1[14]~input_o\ & (!\d.tile.y1[12]~input_o\ $ (\d.clip_rect.y1[12]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000010000100001000000000000000000000000000000001000010000100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[14]~input_o\,
	datab => \ALT_INV_d.tile.y1[12]~input_o\,
	datac => \ALT_INV_d.tile.y1[14]~input_o\,
	datad => \ALT_INV_d.clip_rect.y1[12]~input_o\,
	datae => \ALT_INV_d.clip_rect.y1[13]~input_o\,
	dataf => \ALT_INV_d.tile.y1[13]~input_o\,
	combout => \LessThan7~0_combout\);

-- Location: LABCELL_X64_Y12_N48
\LessThan7~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~1_combout\ = ( \d.tile.y1[10]~input_o\ & ( (\LessThan7~0_combout\ & (\d.clip_rect.y1[10]~input_o\ & (!\d.clip_rect.y1[11]~input_o\ $ (\d.tile.y1[11]~input_o\)))) ) ) # ( !\d.tile.y1[10]~input_o\ & ( (\LessThan7~0_combout\ & 
-- (!\d.clip_rect.y1[10]~input_o\ & (!\d.clip_rect.y1[11]~input_o\ $ (\d.tile.y1[11]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000000010000010000000001000000000100000000010000010000000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan7~0_combout\,
	datab => \ALT_INV_d.clip_rect.y1[11]~input_o\,
	datac => \ALT_INV_d.clip_rect.y1[10]~input_o\,
	datad => \ALT_INV_d.tile.y1[11]~input_o\,
	dataf => \ALT_INV_d.tile.y1[10]~input_o\,
	combout => \LessThan7~1_combout\);

-- Location: LABCELL_X64_Y8_N30
\LessThan7~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~11_combout\ = ( \d.clip_rect.y1[13]~input_o\ & ( \d.tile.y1[13]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\ & (!\d.tile.y1[12]~input_o\ & (!\d.tile.y1[14]~input_o\ & \d.clip_rect.y1[12]~input_o\))) # (\d.clip_rect.y1[14]~input_o\ & 
-- ((!\d.tile.y1[14]~input_o\) # ((!\d.tile.y1[12]~input_o\ & \d.clip_rect.y1[12]~input_o\)))) ) ) ) # ( !\d.clip_rect.y1[13]~input_o\ & ( \d.tile.y1[13]~input_o\ & ( (\d.clip_rect.y1[14]~input_o\ & !\d.tile.y1[14]~input_o\) ) ) ) # ( 
-- \d.clip_rect.y1[13]~input_o\ & ( !\d.tile.y1[13]~input_o\ & ( (!\d.tile.y1[14]~input_o\) # (\d.clip_rect.y1[14]~input_o\) ) ) ) # ( !\d.clip_rect.y1[13]~input_o\ & ( !\d.tile.y1[13]~input_o\ & ( (!\d.clip_rect.y1[14]~input_o\ & (!\d.tile.y1[12]~input_o\ & 
-- (!\d.tile.y1[14]~input_o\ & \d.clip_rect.y1[12]~input_o\))) # (\d.clip_rect.y1[14]~input_o\ & ((!\d.tile.y1[14]~input_o\) # ((!\d.tile.y1[12]~input_o\ & \d.clip_rect.y1[12]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000011010100111101011111010101010000010100000101000011010100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[14]~input_o\,
	datab => \ALT_INV_d.tile.y1[12]~input_o\,
	datac => \ALT_INV_d.tile.y1[14]~input_o\,
	datad => \ALT_INV_d.clip_rect.y1[12]~input_o\,
	datae => \ALT_INV_d.clip_rect.y1[13]~input_o\,
	dataf => \ALT_INV_d.tile.y1[13]~input_o\,
	combout => \LessThan7~11_combout\);

-- Location: LABCELL_X64_Y12_N24
\LessThan7~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~12_combout\ = ( \d.clip_rect.y1[10]~input_o\ & ( !\LessThan7~11_combout\ & ( (!\LessThan7~0_combout\) # ((!\d.tile.y1[11]~input_o\ & (\d.tile.y1[10]~input_o\ & !\d.clip_rect.y1[11]~input_o\)) # (\d.tile.y1[11]~input_o\ & 
-- ((!\d.clip_rect.y1[11]~input_o\) # (\d.tile.y1[10]~input_o\)))) ) ) ) # ( !\d.clip_rect.y1[10]~input_o\ & ( !\LessThan7~11_combout\ & ( (!\LessThan7~0_combout\) # ((!\d.clip_rect.y1[11]~input_o\) # (\d.tile.y1[11]~input_o\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111110111011101111111010101100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan7~0_combout\,
	datab => \ALT_INV_d.tile.y1[11]~input_o\,
	datac => \ALT_INV_d.tile.y1[10]~input_o\,
	datad => \ALT_INV_d.clip_rect.y1[11]~input_o\,
	datae => \ALT_INV_d.clip_rect.y1[10]~input_o\,
	dataf => \ALT_INV_LessThan7~11_combout\,
	combout => \LessThan7~12_combout\);

-- Location: LABCELL_X64_Y12_N6
\LessThan7~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~13_combout\ = ( \d.clip_rect.y1[9]~input_o\ & ( \d.tile.y1[8]~input_o\ & ( (\LessThan7~12_combout\ & ((!\LessThan7~1_combout\) # (\d.tile.y1[9]~input_o\))) ) ) ) # ( !\d.clip_rect.y1[9]~input_o\ & ( \d.tile.y1[8]~input_o\ & ( 
-- \LessThan7~12_combout\ ) ) ) # ( \d.clip_rect.y1[9]~input_o\ & ( !\d.tile.y1[8]~input_o\ & ( (\LessThan7~12_combout\ & ((!\LessThan7~1_combout\) # ((\d.tile.y1[9]~input_o\ & !\d.clip_rect.y1[8]~input_o\)))) ) ) ) # ( !\d.clip_rect.y1[9]~input_o\ & ( 
-- !\d.tile.y1[8]~input_o\ & ( (\LessThan7~12_combout\ & ((!\LessThan7~1_combout\) # ((!\d.clip_rect.y1[8]~input_o\) # (\d.tile.y1[9]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001011000010110000101000001111000011110000101100001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan7~1_combout\,
	datab => \ALT_INV_d.tile.y1[9]~input_o\,
	datac => \ALT_INV_LessThan7~12_combout\,
	datad => \ALT_INV_d.clip_rect.y1[8]~input_o\,
	datae => \ALT_INV_d.clip_rect.y1[9]~input_o\,
	dataf => \ALT_INV_d.tile.y1[8]~input_o\,
	combout => \LessThan7~13_combout\);

-- Location: LABCELL_X66_Y11_N18
\LessThan7~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~6_combout\ = ( \d.clip_rect.y1[7]~input_o\ & ( (\d.tile.y1[7]~input_o\ & (!\d.tile.y1[6]~input_o\ $ (\d.clip_rect.y1[6]~input_o\))) ) ) # ( !\d.clip_rect.y1[7]~input_o\ & ( (!\d.tile.y1[7]~input_o\ & (!\d.tile.y1[6]~input_o\ $ 
-- (\d.clip_rect.y1[6]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000001010000010100000101000001001000001010000010100000101000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y1[7]~input_o\,
	datab => \ALT_INV_d.tile.y1[6]~input_o\,
	datac => \ALT_INV_d.clip_rect.y1[6]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y1[7]~input_o\,
	combout => \LessThan7~6_combout\);

-- Location: LABCELL_X66_Y11_N48
\LessThan7~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~7_combout\ = ( \d.clip_rect.y1[5]~input_o\ & ( \LessThan7~6_combout\ & ( (\d.tile.y1[5]~input_o\ & (!\d.tile.y1[4]~input_o\ $ (\d.clip_rect.y1[4]~input_o\))) ) ) ) # ( !\d.clip_rect.y1[5]~input_o\ & ( \LessThan7~6_combout\ & ( 
-- (!\d.tile.y1[5]~input_o\ & (!\d.tile.y1[4]~input_o\ $ (\d.clip_rect.y1[4]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000010000100100001000010000100100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y1[4]~input_o\,
	datab => \ALT_INV_d.tile.y1[5]~input_o\,
	datac => \ALT_INV_d.clip_rect.y1[4]~input_o\,
	datae => \ALT_INV_d.clip_rect.y1[5]~input_o\,
	dataf => \ALT_INV_LessThan7~6_combout\,
	combout => \LessThan7~7_combout\);

-- Location: MLABCELL_X59_Y11_N54
\LessThan7~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~4_combout\ = ( \d.tile.y1[0]~input_o\ & ( (\d.clip_rect.y1[1]~input_o\ & !\d.tile.y1[1]~input_o\) ) ) # ( !\d.tile.y1[0]~input_o\ & ( (!\d.clip_rect.y1[0]~input_o\ & (\d.clip_rect.y1[1]~input_o\ & !\d.tile.y1[1]~input_o\)) # 
-- (\d.clip_rect.y1[0]~input_o\ & ((!\d.tile.y1[1]~input_o\) # (\d.clip_rect.y1[1]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111011100010001011101110001000100110011000000000011001100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[0]~input_o\,
	datab => \ALT_INV_d.clip_rect.y1[1]~input_o\,
	datad => \ALT_INV_d.tile.y1[1]~input_o\,
	dataf => \ALT_INV_d.tile.y1[0]~input_o\,
	combout => \LessThan7~4_combout\);

-- Location: MLABCELL_X59_Y11_N12
\LessThan7~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~5_combout\ = ( \d.tile.y1[3]~input_o\ & ( (\d.clip_rect.y1[3]~input_o\ & ((!\d.clip_rect.y1[2]~input_o\ & (!\d.tile.y1[2]~input_o\ & \LessThan7~4_combout\)) # (\d.clip_rect.y1[2]~input_o\ & ((!\d.tile.y1[2]~input_o\) # 
-- (\LessThan7~4_combout\))))) ) ) # ( !\d.tile.y1[3]~input_o\ & ( ((!\d.clip_rect.y1[2]~input_o\ & (!\d.tile.y1[2]~input_o\ & \LessThan7~4_combout\)) # (\d.clip_rect.y1[2]~input_o\ & ((!\d.tile.y1[2]~input_o\) # (\LessThan7~4_combout\)))) # 
-- (\d.clip_rect.y1[3]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111001111110111011100111111011100010000001100010001000000110001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[2]~input_o\,
	datab => \ALT_INV_d.clip_rect.y1[3]~input_o\,
	datac => \ALT_INV_d.tile.y1[2]~input_o\,
	datad => \ALT_INV_LessThan7~4_combout\,
	dataf => \ALT_INV_d.tile.y1[3]~input_o\,
	combout => \LessThan7~5_combout\);

-- Location: LABCELL_X61_Y12_N6
\LessThan7~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~3_combout\ = ( !\d.clip_rect.y1[8]~input_o\ & ( \d.tile.y1[8]~input_o\ ) ) # ( \d.clip_rect.y1[8]~input_o\ & ( !\d.tile.y1[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111111111111111111110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datae => \ALT_INV_d.clip_rect.y1[8]~input_o\,
	dataf => \ALT_INV_d.tile.y1[8]~input_o\,
	combout => \LessThan7~3_combout\);

-- Location: LABCELL_X66_Y11_N21
\LessThan7~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~8_combout\ = ( \d.clip_rect.y1[6]~input_o\ & ( (!\d.tile.y1[7]~input_o\ & ((!\d.tile.y1[6]~input_o\) # (\d.clip_rect.y1[7]~input_o\))) # (\d.tile.y1[7]~input_o\ & (!\d.tile.y1[6]~input_o\ & \d.clip_rect.y1[7]~input_o\)) ) ) # ( 
-- !\d.clip_rect.y1[6]~input_o\ & ( (!\d.tile.y1[7]~input_o\ & \d.clip_rect.y1[7]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010000010100000101010001110100011101000111010001110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y1[7]~input_o\,
	datab => \ALT_INV_d.tile.y1[6]~input_o\,
	datac => \ALT_INV_d.clip_rect.y1[7]~input_o\,
	dataf => \ALT_INV_d.clip_rect.y1[6]~input_o\,
	combout => \LessThan7~8_combout\);

-- Location: LABCELL_X66_Y11_N54
\LessThan7~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~9_combout\ = ( \d.tile.y1[4]~input_o\ & ( \LessThan7~6_combout\ & ( (!\LessThan7~8_combout\ & ((!\d.clip_rect.y1[5]~input_o\) # (\d.tile.y1[5]~input_o\))) ) ) ) # ( !\d.tile.y1[4]~input_o\ & ( \LessThan7~6_combout\ & ( (!\LessThan7~8_combout\ & 
-- ((!\d.clip_rect.y1[5]~input_o\ & ((!\d.clip_rect.y1[4]~input_o\) # (\d.tile.y1[5]~input_o\))) # (\d.clip_rect.y1[5]~input_o\ & (!\d.clip_rect.y1[4]~input_o\ & \d.tile.y1[5]~input_o\)))) ) ) ) # ( \d.tile.y1[4]~input_o\ & ( !\LessThan7~6_combout\ & ( 
-- !\LessThan7~8_combout\ ) ) ) # ( !\d.tile.y1[4]~input_o\ & ( !\LessThan7~6_combout\ & ( !\LessThan7~8_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010101010101010101010101010101010000000101010001000100010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan7~8_combout\,
	datab => \ALT_INV_d.clip_rect.y1[5]~input_o\,
	datac => \ALT_INV_d.clip_rect.y1[4]~input_o\,
	datad => \ALT_INV_d.tile.y1[5]~input_o\,
	datae => \ALT_INV_d.tile.y1[4]~input_o\,
	dataf => \ALT_INV_LessThan7~6_combout\,
	combout => \LessThan7~9_combout\);

-- Location: LABCELL_X64_Y12_N51
\LessThan7~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~2_combout\ = ( \d.tile.y1[9]~input_o\ & ( !\d.clip_rect.y1[9]~input_o\ ) ) # ( !\d.tile.y1[9]~input_o\ & ( \d.clip_rect.y1[9]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111111111111000000001111111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_d.clip_rect.y1[9]~input_o\,
	dataf => \ALT_INV_d.tile.y1[9]~input_o\,
	combout => \LessThan7~2_combout\);

-- Location: LABCELL_X64_Y12_N18
\LessThan7~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~10_combout\ = ( \LessThan7~9_combout\ & ( !\LessThan7~2_combout\ & ( (\LessThan7~7_combout\ & (\LessThan7~5_combout\ & (\LessThan7~1_combout\ & !\LessThan7~3_combout\))) ) ) ) # ( !\LessThan7~9_combout\ & ( !\LessThan7~2_combout\ & ( 
-- (\LessThan7~1_combout\ & !\LessThan7~3_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100000000000000010000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan7~7_combout\,
	datab => \ALT_INV_LessThan7~5_combout\,
	datac => \ALT_INV_LessThan7~1_combout\,
	datad => \ALT_INV_LessThan7~3_combout\,
	datae => \ALT_INV_LessThan7~9_combout\,
	dataf => \ALT_INV_LessThan7~2_combout\,
	combout => \LessThan7~10_combout\);

-- Location: LABCELL_X64_Y12_N3
\LessThan7~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan7~14_combout\ = ( \d.clip_rect.y1[15]~input_o\ & ( (\d.tile.y1[15]~input_o\ & (\LessThan7~13_combout\ & !\LessThan7~10_combout\)) ) ) # ( !\d.clip_rect.y1[15]~input_o\ & ( ((\LessThan7~13_combout\ & !\LessThan7~10_combout\)) # 
-- (\d.tile.y1[15]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101111101010101000001010000000001011111010101010000010100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y1[15]~input_o\,
	datac => \ALT_INV_LessThan7~13_combout\,
	datad => \ALT_INV_LessThan7~10_combout\,
	datae => \ALT_INV_d.clip_rect.y1[15]~input_o\,
	combout => \LessThan7~14_combout\);

-- Location: LABCELL_X61_Y9_N57
\r.i[15]~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.i[15]~0_combout\ = ( \reset~input_o\ ) # ( !\reset~input_o\ & ( \r.next_quad~q\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010111111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_reset~input_o\,
	combout => \r.i[15]~0_combout\);

-- Location: FF_X66_Y11_N38
\r.y1[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~125_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(6));

-- Location: LABCELL_X66_Y11_N36
\v~125\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~125_combout\ = ( \r.y1\(6) & ( \comb~0_combout\ ) ) # ( \r.y1\(6) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[6]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[6]~input_o\)))) ) ) ) # ( !\r.y1\(6) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[6]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[6]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011010100000000001101010000000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[6]~input_o\,
	datab => \ALT_INV_d.tile.y1[6]~input_o\,
	datac => \ALT_INV_LessThan7~14_combout\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.y1\(6),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~125_combout\);

-- Location: FF_X66_Y11_N14
\r.y1[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~124_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(7));

-- Location: LABCELL_X66_Y11_N12
\v~124\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~124_combout\ = ( \r.y1\(7) & ( \comb~0_combout\ ) ) # ( \r.y1\(7) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & (\d.tile.y1[7]~input_o\)) # (\LessThan7~14_combout\ & ((\d.clip_rect.y1[7]~input_o\))))) ) ) ) # ( !\r.y1\(7) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & (\d.tile.y1[7]~input_o\)) # (\LessThan7~14_combout\ & ((\d.clip_rect.y1[7]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000001001100010000000100110000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y1[7]~input_o\,
	datab => \ALT_INV_v~0_combout\,
	datac => \ALT_INV_LessThan7~14_combout\,
	datad => \ALT_INV_d.clip_rect.y1[7]~input_o\,
	datae => \ALT_INV_r.y1\(7),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~124_combout\);

-- Location: FF_X61_Y12_N41
\r.y1[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~123_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(8));

-- Location: LABCELL_X61_Y12_N39
\v~123\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~123_combout\ = ( \r.y1\(8) & ( \comb~0_combout\ ) ) # ( \r.y1\(8) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[8]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[8]~input_o\)))) ) ) ) # ( !\r.y1\(8) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[8]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[8]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000011010000000100001101000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[8]~input_o\,
	datab => \ALT_INV_LessThan7~14_combout\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_d.tile.y1[8]~input_o\,
	datae => \ALT_INV_r.y1\(8),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~123_combout\);

-- Location: FF_X65_Y11_N17
\r.i[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~57_sumout\,
	asdata => \v~11_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(6));

-- Location: LABCELL_X66_Y11_N27
\v~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~11_combout\ = ( \r.i\(6) & ( \comb~0_combout\ ) ) # ( \r.i\(6) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[6]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[6]~input_o\)))) ) ) ) # ( !\r.i\(6) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[6]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[6]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001101100000000000110110000000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan4~14_combout\,
	datab => \ALT_INV_d.clip_rect.y0[6]~input_o\,
	datac => \ALT_INV_d.tile.y0[6]~input_o\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.i\(6),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~11_combout\);

-- Location: MLABCELL_X65_Y11_N3
\Add3~41\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~41_sumout\ = SUM(( \v~3_combout\ ) + ( GND ) + ( \Add3~46\ ))
-- \Add3~42\ = CARRY(( \v~3_combout\ ) + ( GND ) + ( \Add3~46\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~3_combout\,
	cin => \Add3~46\,
	sumout => \Add3~41_sumout\,
	cout => \Add3~42\);

-- Location: FF_X65_Y11_N5
\r.i[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~41_sumout\,
	asdata => \v~3_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(2));

-- Location: MLABCELL_X65_Y11_N48
\v~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~3_combout\ = ( \r.i\(2) & ( \comb~0_combout\ ) ) # ( \r.i\(2) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & (\d.tile.y0[2]~input_o\)) # (\LessThan4~14_combout\ & ((\d.clip_rect.y0[2]~input_o\))))) ) ) ) # ( !\r.i\(2) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & (\d.tile.y0[2]~input_o\)) # (\LessThan4~14_combout\ & ((\d.clip_rect.y0[2]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010000001110000001000000111000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan4~14_combout\,
	datab => \ALT_INV_d.tile.y0[2]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_d.clip_rect.y0[2]~input_o\,
	datae => \ALT_INV_r.i\(2),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~3_combout\);

-- Location: MLABCELL_X65_Y11_N6
\Add3~37\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~37_sumout\ = SUM(( \v~5_combout\ ) + ( GND ) + ( \Add3~42\ ))
-- \Add3~38\ = CARRY(( \v~5_combout\ ) + ( GND ) + ( \Add3~42\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~5_combout\,
	cin => \Add3~42\,
	sumout => \Add3~37_sumout\,
	cout => \Add3~38\);

-- Location: FF_X65_Y11_N8
\r.i[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~37_sumout\,
	asdata => \v~5_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(3));

-- Location: LABCELL_X64_Y11_N57
\v~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~5_combout\ = ( \r.i\(3) & ( \comb~0_combout\ ) ) # ( \r.i\(3) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[3]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[3]~input_o\)))) ) ) ) # ( !\r.i\(3) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[3]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[3]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001010001010000000101000101000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_LessThan4~14_combout\,
	datac => \ALT_INV_d.clip_rect.y0[3]~input_o\,
	datad => \ALT_INV_d.tile.y0[3]~input_o\,
	datae => \ALT_INV_r.i\(3),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~5_combout\);

-- Location: MLABCELL_X65_Y11_N9
\Add3~33\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~33_sumout\ = SUM(( \v~7_combout\ ) + ( GND ) + ( \Add3~38\ ))
-- \Add3~34\ = CARRY(( \v~7_combout\ ) + ( GND ) + ( \Add3~38\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~7_combout\,
	cin => \Add3~38\,
	sumout => \Add3~33_sumout\,
	cout => \Add3~34\);

-- Location: FF_X65_Y11_N11
\r.i[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~33_sumout\,
	asdata => \v~7_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(4));

-- Location: LABCELL_X64_Y11_N27
\v~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~7_combout\ = ( \r.i\(4) & ( \comb~0_combout\ ) ) # ( \r.i\(4) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[4]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[4]~input_o\)))) ) ) ) # ( !\r.i\(4) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[4]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[4]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001010001010000000101000101000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_LessThan4~14_combout\,
	datac => \ALT_INV_d.clip_rect.y0[4]~input_o\,
	datad => \ALT_INV_d.tile.y0[4]~input_o\,
	datae => \ALT_INV_r.i\(4),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~7_combout\);

-- Location: MLABCELL_X65_Y11_N12
\Add3~29\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~29_sumout\ = SUM(( \v~9_combout\ ) + ( GND ) + ( \Add3~34\ ))
-- \Add3~30\ = CARRY(( \v~9_combout\ ) + ( GND ) + ( \Add3~34\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~9_combout\,
	cin => \Add3~34\,
	sumout => \Add3~29_sumout\,
	cout => \Add3~30\);

-- Location: MLABCELL_X65_Y9_N27
\r.i[5]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.i[5]~feeder_combout\ = \Add3~29_sumout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111100000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_Add3~29_sumout\,
	combout => \r.i[5]~feeder_combout\);

-- Location: FF_X65_Y9_N29
\r.i[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.i[5]~feeder_combout\,
	asdata => \v~9_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(5));

-- Location: LABCELL_X64_Y11_N42
\v~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~9_combout\ = ( \r.i\(5) & ( \comb~0_combout\ ) ) # ( \r.i\(5) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[5]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[5]~input_o\)))) ) ) ) # ( !\r.i\(5) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[5]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[5]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000100010000010100010001000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.clip_rect.y0[5]~input_o\,
	datac => \ALT_INV_d.tile.y0[5]~input_o\,
	datad => \ALT_INV_LessThan4~14_combout\,
	datae => \ALT_INV_r.i\(5),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~9_combout\);

-- Location: MLABCELL_X65_Y11_N15
\Add3~57\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~57_sumout\ = SUM(( \v~11_combout\ ) + ( GND ) + ( \Add3~30\ ))
-- \Add3~58\ = CARRY(( \v~11_combout\ ) + ( GND ) + ( \Add3~30\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~11_combout\,
	cin => \Add3~30\,
	sumout => \Add3~57_sumout\,
	cout => \Add3~58\);

-- Location: FF_X65_Y11_N23
\r.i[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~49_sumout\,
	asdata => \v~15_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(8));

-- Location: LABCELL_X64_Y11_N48
\v~15\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~15_combout\ = ( \r.i\(8) & ( \comb~0_combout\ ) ) # ( \r.i\(8) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[8]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[8]~input_o\)))) ) ) ) # ( !\r.i\(8) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[8]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[8]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000001010000001100000101000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[8]~input_o\,
	datab => \ALT_INV_d.tile.y0[8]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_LessThan4~14_combout\,
	datae => \ALT_INV_r.i\(8),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~15_combout\);

-- Location: MLABCELL_X65_Y11_N18
\Add3~53\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~53_sumout\ = SUM(( \v~13_combout\ ) + ( GND ) + ( \Add3~58\ ))
-- \Add3~54\ = CARRY(( \v~13_combout\ ) + ( GND ) + ( \Add3~58\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~13_combout\,
	cin => \Add3~58\,
	sumout => \Add3~53_sumout\,
	cout => \Add3~54\);

-- Location: FF_X65_Y11_N20
\r.i[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~53_sumout\,
	asdata => \v~13_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(7));

-- Location: LABCELL_X64_Y11_N12
\v~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~13_combout\ = ( \LessThan4~14_combout\ & ( \comb~0_combout\ & ( \r.i\(7) ) ) ) # ( !\LessThan4~14_combout\ & ( \comb~0_combout\ & ( \r.i\(7) ) ) ) # ( \LessThan4~14_combout\ & ( !\comb~0_combout\ & ( (\d.clip_rect.y0[7]~input_o\ & !\v~0_combout\) ) ) ) 
-- # ( !\LessThan4~14_combout\ & ( !\comb~0_combout\ & ( (\d.tile.y0[7]~input_o\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000001010000001100000011000000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y0[7]~input_o\,
	datab => \ALT_INV_d.clip_rect.y0[7]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_r.i\(7),
	datae => \ALT_INV_LessThan4~14_combout\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~13_combout\);

-- Location: MLABCELL_X65_Y11_N21
\Add3~49\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~49_sumout\ = SUM(( \v~15_combout\ ) + ( GND ) + ( \Add3~54\ ))
-- \Add3~50\ = CARRY(( \v~15_combout\ ) + ( GND ) + ( \Add3~54\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~15_combout\,
	cin => \Add3~54\,
	sumout => \Add3~49_sumout\,
	cout => \Add3~50\);

-- Location: LABCELL_X66_Y11_N0
\LessThan9~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~10_combout\ = ( \Add3~49_sumout\ & ( \Add3~53_sumout\ & ( (\v~124_combout\ & (\v~123_combout\ & (!\v~125_combout\ $ (\Add3~57_sumout\)))) ) ) ) # ( !\Add3~49_sumout\ & ( \Add3~53_sumout\ & ( (\v~124_combout\ & (!\v~123_combout\ & 
-- (!\v~125_combout\ $ (\Add3~57_sumout\)))) ) ) ) # ( \Add3~49_sumout\ & ( !\Add3~53_sumout\ & ( (!\v~124_combout\ & (\v~123_combout\ & (!\v~125_combout\ $ (\Add3~57_sumout\)))) ) ) ) # ( !\Add3~49_sumout\ & ( !\Add3~53_sumout\ & ( (!\v~124_combout\ & 
-- (!\v~123_combout\ & (!\v~125_combout\ $ (\Add3~57_sumout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000000001000000000010000000010000100000000100000000001000000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~125_combout\,
	datab => \ALT_INV_v~124_combout\,
	datac => \ALT_INV_v~123_combout\,
	datad => \ALT_INV_Add3~57_sumout\,
	datae => \ALT_INV_Add3~49_sumout\,
	dataf => \ALT_INV_Add3~53_sumout\,
	combout => \LessThan9~10_combout\);

-- Location: FF_X64_Y12_N56
\r.y1[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~117_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(9));

-- Location: LABCELL_X64_Y12_N54
\v~117\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~117_combout\ = ( \r.y1\(9) & ( \comb~0_combout\ ) ) # ( \r.y1\(9) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[9]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[9]~input_o\)))) ) ) ) # ( !\r.y1\(9) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[9]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[9]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011010100000000001101010000000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[9]~input_o\,
	datab => \ALT_INV_d.tile.y1[9]~input_o\,
	datac => \ALT_INV_LessThan7~14_combout\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.y1\(9),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~117_combout\);

-- Location: FF_X65_Y11_N25
\r.i[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~25_sumout\,
	asdata => \v~17_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(9));

-- Location: LABCELL_X63_Y11_N18
\v~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~17_combout\ = ( \r.i\(9) & ( \comb~0_combout\ ) ) # ( \r.i\(9) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[9]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[9]~input_o\)))) ) ) ) # ( !\r.i\(9) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[9]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[9]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011010100000000001101010000000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[9]~input_o\,
	datab => \ALT_INV_d.tile.y0[9]~input_o\,
	datac => \ALT_INV_LessThan4~14_combout\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.i\(9),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~17_combout\);

-- Location: MLABCELL_X65_Y11_N24
\Add3~25\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~25_sumout\ = SUM(( \v~17_combout\ ) + ( GND ) + ( \Add3~50\ ))
-- \Add3~26\ = CARRY(( \v~17_combout\ ) + ( GND ) + ( \Add3~50\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~17_combout\,
	cin => \Add3~50\,
	sumout => \Add3~25_sumout\,
	cout => \Add3~26\);

-- Location: MLABCELL_X65_Y10_N57
\LessThan9~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~6_combout\ = ( \Add3~25_sumout\ & ( !\v~117_combout\ ) ) # ( !\Add3~25_sumout\ & ( \v~117_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~117_combout\,
	dataf => \ALT_INV_Add3~25_sumout\,
	combout => \LessThan9~6_combout\);

-- Location: FF_X66_Y11_N8
\r.y1[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~119_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(4));

-- Location: LABCELL_X66_Y11_N6
\v~119\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~119_combout\ = ( \r.y1\(4) & ( \d.clip_rect.y1[4]~input_o\ & ( ((!\v~0_combout\ & ((\d.tile.y1[4]~input_o\) # (\LessThan7~14_combout\)))) # (\comb~0_combout\) ) ) ) # ( !\r.y1\(4) & ( \d.clip_rect.y1[4]~input_o\ & ( (!\comb~0_combout\ & (!\v~0_combout\ 
-- & ((\d.tile.y1[4]~input_o\) # (\LessThan7~14_combout\)))) ) ) ) # ( \r.y1\(4) & ( !\d.clip_rect.y1[4]~input_o\ & ( ((!\LessThan7~14_combout\ & (\d.tile.y1[4]~input_o\ & !\v~0_combout\))) # (\comb~0_combout\) ) ) ) # ( !\r.y1\(4) & ( 
-- !\d.clip_rect.y1[4]~input_o\ & ( (!\LessThan7~14_combout\ & (!\comb~0_combout\ & (\d.tile.y1[4]~input_o\ & !\v~0_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000000000001110110011001101001100000000000111111100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan7~14_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_d.tile.y1[4]~input_o\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.y1\(4),
	dataf => \ALT_INV_d.clip_rect.y1[4]~input_o\,
	combout => \v~119_combout\);

-- Location: FF_X64_Y12_N1
\r.y1[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~118_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(5));

-- Location: MLABCELL_X65_Y12_N51
\v~118\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~118_combout\ = ( \d.clip_rect.y1[5]~input_o\ & ( \comb~0_combout\ & ( \r.y1\(5) ) ) ) # ( !\d.clip_rect.y1[5]~input_o\ & ( \comb~0_combout\ & ( \r.y1\(5) ) ) ) # ( \d.clip_rect.y1[5]~input_o\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & 
-- ((\d.tile.y1[5]~input_o\) # (\LessThan7~14_combout\))) ) ) ) # ( !\d.clip_rect.y1[5]~input_o\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & (!\LessThan7~14_combout\ & \d.tile.y1[5]~input_o\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010001000001000101010101000001111000011110000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_LessThan7~14_combout\,
	datac => \ALT_INV_r.y1\(5),
	datad => \ALT_INV_d.tile.y1[5]~input_o\,
	datae => \ALT_INV_d.clip_rect.y1[5]~input_o\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~118_combout\);

-- Location: LABCELL_X66_Y10_N30
\LessThan9~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~7_combout\ = ( \Add3~33_sumout\ & ( \Add3~29_sumout\ & ( (\v~119_combout\ & \v~118_combout\) ) ) ) # ( !\Add3~33_sumout\ & ( \Add3~29_sumout\ & ( (!\v~119_combout\ & \v~118_combout\) ) ) ) # ( \Add3~33_sumout\ & ( !\Add3~29_sumout\ & ( 
-- (\v~119_combout\ & !\v~118_combout\) ) ) ) # ( !\Add3~33_sumout\ & ( !\Add3~29_sumout\ & ( (!\v~119_combout\ & !\v~118_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000100010001000010001000100010000100010001000100001000100010001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~119_combout\,
	datab => \ALT_INV_v~118_combout\,
	datae => \ALT_INV_Add3~33_sumout\,
	dataf => \ALT_INV_Add3~29_sumout\,
	combout => \LessThan9~7_combout\);

-- Location: FF_X62_Y10_N20
\r.y1[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~122_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(1));

-- Location: LABCELL_X62_Y10_N18
\v~122\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~122_combout\ = ( \r.y1\(1) & ( \comb~0_combout\ ) ) # ( \r.y1\(1) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & (\d.tile.y1[1]~input_o\)) # (\LessThan7~14_combout\ & ((\d.clip_rect.y1[1]~input_o\))))) ) ) ) # ( !\r.y1\(1) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & (\d.tile.y1[1]~input_o\)) # (\LessThan7~14_combout\ & ((\d.clip_rect.y1[1]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010000001110000001000000111000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan7~14_combout\,
	datab => \ALT_INV_d.tile.y1[1]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_d.clip_rect.y1[1]~input_o\,
	datae => \ALT_INV_r.y1\(1),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~122_combout\);

-- Location: FF_X66_Y10_N44
\r.y1[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~121_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(2));

-- Location: LABCELL_X66_Y10_N42
\v~121\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~121_combout\ = ( \r.y1\(2) & ( \comb~0_combout\ ) ) # ( \r.y1\(2) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & (\d.tile.y1[2]~input_o\)) # (\LessThan7~14_combout\ & ((\d.clip_rect.y1[2]~input_o\))))) ) ) ) # ( !\r.y1\(2) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & (\d.tile.y1[2]~input_o\)) # (\LessThan7~14_combout\ & ((\d.clip_rect.y1[2]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000101010000010000010101000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_LessThan7~14_combout\,
	datac => \ALT_INV_d.tile.y1[2]~input_o\,
	datad => \ALT_INV_d.clip_rect.y1[2]~input_o\,
	datae => \ALT_INV_r.y1\(2),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~121_combout\);

-- Location: FF_X66_Y10_N26
\r.y1[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~120_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(3));

-- Location: LABCELL_X66_Y10_N24
\v~120\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~120_combout\ = ( \r.y1\(3) & ( \d.tile.y1[3]~input_o\ & ( ((!\v~0_combout\ & ((!\LessThan7~14_combout\) # (\d.clip_rect.y1[3]~input_o\)))) # (\comb~0_combout\) ) ) ) # ( !\r.y1\(3) & ( \d.tile.y1[3]~input_o\ & ( (!\v~0_combout\ & (!\comb~0_combout\ & 
-- ((!\LessThan7~14_combout\) # (\d.clip_rect.y1[3]~input_o\)))) ) ) ) # ( \r.y1\(3) & ( !\d.tile.y1[3]~input_o\ & ( ((!\v~0_combout\ & (\d.clip_rect.y1[3]~input_o\ & \LessThan7~14_combout\))) # (\comb~0_combout\) ) ) ) # ( !\r.y1\(3) & ( 
-- !\d.tile.y1[3]~input_o\ & ( (!\v~0_combout\ & (\d.clip_rect.y1[3]~input_o\ & (!\comb~0_combout\ & \LessThan7~14_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000100000000011110010111110100000001000001010111100101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.clip_rect.y1[3]~input_o\,
	datac => \ALT_INV_comb~0_combout\,
	datad => \ALT_INV_LessThan7~14_combout\,
	datae => \ALT_INV_r.y1\(3),
	dataf => \ALT_INV_d.tile.y1[3]~input_o\,
	combout => \v~120_combout\);

-- Location: LABCELL_X66_Y10_N12
\LessThan9~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~8_combout\ = ( \Add3~41_sumout\ & ( \Add3~37_sumout\ & ( (\v~120_combout\ & ((!\v~121_combout\) # ((!\v~122_combout\ & \Add3~45_sumout\)))) ) ) ) # ( !\Add3~41_sumout\ & ( \Add3~37_sumout\ & ( (!\v~122_combout\ & (!\v~121_combout\ & 
-- (\v~120_combout\ & \Add3~45_sumout\))) ) ) ) # ( \Add3~41_sumout\ & ( !\Add3~37_sumout\ & ( (!\v~120_combout\ & ((!\v~121_combout\) # ((!\v~122_combout\ & \Add3~45_sumout\)))) ) ) ) # ( !\Add3~41_sumout\ & ( !\Add3~37_sumout\ & ( (!\v~122_combout\ & 
-- (!\v~121_combout\ & (!\v~120_combout\ & \Add3~45_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010000000110000001110000000000000000010000000110000001110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~122_combout\,
	datab => \ALT_INV_v~121_combout\,
	datac => \ALT_INV_v~120_combout\,
	datad => \ALT_INV_Add3~45_sumout\,
	datae => \ALT_INV_Add3~41_sumout\,
	dataf => \ALT_INV_Add3~37_sumout\,
	combout => \LessThan9~8_combout\);

-- Location: LABCELL_X66_Y10_N54
\LessThan9~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~9_combout\ = ( \Add3~33_sumout\ & ( \Add3~29_sumout\ & ( (!\v~119_combout\) # ((!\v~118_combout\) # ((\Add3~37_sumout\ & !\v~120_combout\))) ) ) ) # ( !\Add3~33_sumout\ & ( \Add3~29_sumout\ & ( (!\v~118_combout\) # ((!\v~119_combout\ & 
-- (\Add3~37_sumout\ & !\v~120_combout\))) ) ) ) # ( \Add3~33_sumout\ & ( !\Add3~29_sumout\ & ( (!\v~118_combout\ & ((!\v~119_combout\) # ((\Add3~37_sumout\ & !\v~120_combout\)))) ) ) ) # ( !\Add3~33_sumout\ & ( !\Add3~29_sumout\ & ( (!\v~119_combout\ & 
-- (!\v~118_combout\ & (\Add3~37_sumout\ & !\v~120_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000000000100011001000100011001110110011001110111111101110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~119_combout\,
	datab => \ALT_INV_v~118_combout\,
	datac => \ALT_INV_Add3~37_sumout\,
	datad => \ALT_INV_v~120_combout\,
	datae => \ALT_INV_Add3~33_sumout\,
	dataf => \ALT_INV_Add3~29_sumout\,
	combout => \LessThan9~9_combout\);

-- Location: LABCELL_X66_Y11_N30
\LessThan9~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~11_combout\ = ( \Add3~49_sumout\ & ( \Add3~53_sumout\ & ( (!\v~124_combout\) # ((!\v~123_combout\) # ((!\v~125_combout\ & \Add3~57_sumout\))) ) ) ) # ( !\Add3~49_sumout\ & ( \Add3~53_sumout\ & ( (!\v~123_combout\ & ((!\v~124_combout\) # 
-- ((!\v~125_combout\ & \Add3~57_sumout\)))) ) ) ) # ( \Add3~49_sumout\ & ( !\Add3~53_sumout\ & ( (!\v~123_combout\) # ((!\v~125_combout\ & (!\v~124_combout\ & \Add3~57_sumout\))) ) ) ) # ( !\Add3~49_sumout\ & ( !\Add3~53_sumout\ & ( (!\v~125_combout\ & 
-- (!\v~124_combout\ & (!\v~123_combout\ & \Add3~57_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010000000111100001111100011000000111000001111110011111110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~125_combout\,
	datab => \ALT_INV_v~124_combout\,
	datac => \ALT_INV_v~123_combout\,
	datad => \ALT_INV_Add3~57_sumout\,
	datae => \ALT_INV_Add3~49_sumout\,
	dataf => \ALT_INV_Add3~53_sumout\,
	combout => \LessThan9~11_combout\);

-- Location: MLABCELL_X65_Y10_N6
\LessThan9~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~17_combout\ = ( \LessThan9~9_combout\ & ( \LessThan9~11_combout\ & ( !\LessThan9~6_combout\ ) ) ) # ( !\LessThan9~9_combout\ & ( \LessThan9~11_combout\ & ( !\LessThan9~6_combout\ ) ) ) # ( \LessThan9~9_combout\ & ( !\LessThan9~11_combout\ & ( 
-- (\LessThan9~10_combout\ & !\LessThan9~6_combout\) ) ) ) # ( !\LessThan9~9_combout\ & ( !\LessThan9~11_combout\ & ( (\LessThan9~10_combout\ & (!\LessThan9~6_combout\ & (\LessThan9~7_combout\ & \LessThan9~8_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000100010001000100010011001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan9~10_combout\,
	datab => \ALT_INV_LessThan9~6_combout\,
	datac => \ALT_INV_LessThan9~7_combout\,
	datad => \ALT_INV_LessThan9~8_combout\,
	datae => \ALT_INV_LessThan9~9_combout\,
	dataf => \ALT_INV_LessThan9~11_combout\,
	combout => \LessThan9~17_combout\);

-- Location: MLABCELL_X65_Y10_N33
\LessThan9~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~14_combout\ = ( \Add3~25_sumout\ & ( !\v~117_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~117_combout\,
	dataf => \ALT_INV_Add3~25_sumout\,
	combout => \LessThan9~14_combout\);

-- Location: FF_X66_Y10_N8
\r.y1[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~116_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(10));

-- Location: LABCELL_X66_Y10_N6
\v~116\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~116_combout\ = ( \r.y1\(10) & ( \comb~0_combout\ ) ) # ( \r.y1\(10) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & (\d.tile.y1[10]~input_o\)) # (\LessThan7~14_combout\ & ((\d.clip_rect.y1[10]~input_o\))))) ) ) ) # ( !\r.y1\(10) 
-- & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & (\d.tile.y1[10]~input_o\)) # (\LessThan7~14_combout\ & ((\d.clip_rect.y1[10]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000001110000010000000111000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y1[10]~input_o\,
	datab => \ALT_INV_LessThan7~14_combout\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_d.clip_rect.y1[10]~input_o\,
	datae => \ALT_INV_r.y1\(10),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~116_combout\);

-- Location: FF_X65_Y11_N29
\r.i[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~21_sumout\,
	asdata => \v~19_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(10));

-- Location: LABCELL_X64_Y11_N21
\v~19\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~19_combout\ = ( \r.i\(10) & ( \comb~0_combout\ ) ) # ( \r.i\(10) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & (\d.tile.y0[10]~input_o\)) # (\LessThan4~14_combout\ & ((\d.clip_rect.y0[10]~input_o\))))) ) ) ) # ( !\r.i\(10) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & (\d.tile.y0[10]~input_o\)) # (\LessThan4~14_combout\ & ((\d.clip_rect.y0[10]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010000000101010001000000010101000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.tile.y0[10]~input_o\,
	datac => \ALT_INV_LessThan4~14_combout\,
	datad => \ALT_INV_d.clip_rect.y0[10]~input_o\,
	datae => \ALT_INV_r.i\(10),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~19_combout\);

-- Location: MLABCELL_X65_Y11_N27
\Add3~21\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~21_sumout\ = SUM(( \v~19_combout\ ) + ( GND ) + ( \Add3~26\ ))
-- \Add3~22\ = CARRY(( \v~19_combout\ ) + ( GND ) + ( \Add3~26\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~19_combout\,
	cin => \Add3~26\,
	sumout => \Add3~21_sumout\,
	cout => \Add3~22\);

-- Location: FF_X64_Y12_N14
\r.y1[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~115_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(11));

-- Location: LABCELL_X64_Y12_N12
\v~115\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~115_combout\ = ( \r.y1\(11) & ( \comb~0_combout\ ) ) # ( \r.y1\(11) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[11]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[11]~input_o\)))) ) ) ) # ( !\r.y1\(11) 
-- & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[11]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[11]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001010100010000000101010001000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.clip_rect.y1[11]~input_o\,
	datac => \ALT_INV_LessThan7~14_combout\,
	datad => \ALT_INV_d.tile.y1[11]~input_o\,
	datae => \ALT_INV_r.y1\(11),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~115_combout\);

-- Location: FF_X65_Y11_N32
\r.i[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~17_sumout\,
	asdata => \v~21_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(11));

-- Location: LABCELL_X64_Y11_N39
\v~21\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~21_combout\ = ( \d.tile.y0[11]~input_o\ & ( \comb~0_combout\ & ( \r.i\(11) ) ) ) # ( !\d.tile.y0[11]~input_o\ & ( \comb~0_combout\ & ( \r.i\(11) ) ) ) # ( \d.tile.y0[11]~input_o\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\) # 
-- (\d.clip_rect.y0[11]~input_o\))) ) ) ) # ( !\d.tile.y0[11]~input_o\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & (\d.clip_rect.y0[11]~input_o\ & \LessThan4~14_combout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001000000010101000101010001000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.clip_rect.y0[11]~input_o\,
	datac => \ALT_INV_LessThan4~14_combout\,
	datad => \ALT_INV_r.i\(11),
	datae => \ALT_INV_d.tile.y0[11]~input_o\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~21_combout\);

-- Location: MLABCELL_X65_Y11_N30
\Add3~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~17_sumout\ = SUM(( \v~21_combout\ ) + ( GND ) + ( \Add3~22\ ))
-- \Add3~18\ = CARRY(( \v~21_combout\ ) + ( GND ) + ( \Add3~22\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~21_combout\,
	cin => \Add3~22\,
	sumout => \Add3~17_sumout\,
	cout => \Add3~18\);

-- Location: MLABCELL_X65_Y10_N27
\LessThan9~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~4_combout\ = ( \Add3~17_sumout\ & ( !\v~115_combout\ ) ) # ( !\Add3~17_sumout\ & ( \v~115_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111111111111000000001111111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~115_combout\,
	dataf => \ALT_INV_Add3~17_sumout\,
	combout => \LessThan9~4_combout\);

-- Location: FF_X65_Y12_N32
\r.y1[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~112_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(12));

-- Location: MLABCELL_X65_Y12_N30
\v~112\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~112_combout\ = ( \r.y1\(12) & ( \comb~0_combout\ ) ) # ( \r.y1\(12) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[12]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[12]~input_o\)))) ) ) ) # ( !\r.y1\(12) 
-- & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[12]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[12]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001010001010000000101000101000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_LessThan7~14_combout\,
	datac => \ALT_INV_d.clip_rect.y1[12]~input_o\,
	datad => \ALT_INV_d.tile.y1[12]~input_o\,
	datae => \ALT_INV_r.y1\(12),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~112_combout\);

-- Location: FF_X65_Y11_N34
\r.i[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~1_sumout\,
	asdata => \v~23_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(12));

-- Location: LABCELL_X63_Y11_N27
\v~23\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~23_combout\ = ( \r.i\(12) & ( \comb~0_combout\ ) ) # ( \r.i\(12) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[12]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[12]~input_o\)))) ) ) ) # ( !\r.i\(12) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[12]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[12]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000001010000001100000101000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[12]~input_o\,
	datab => \ALT_INV_d.tile.y0[12]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_LessThan4~14_combout\,
	datae => \ALT_INV_r.i\(12),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~23_combout\);

-- Location: MLABCELL_X65_Y11_N33
\Add3~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~1_sumout\ = SUM(( \v~23_combout\ ) + ( GND ) + ( \Add3~18\ ))
-- \Add3~2\ = CARRY(( \v~23_combout\ ) + ( GND ) + ( \Add3~18\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~23_combout\,
	cin => \Add3~18\,
	sumout => \Add3~1_sumout\,
	cout => \Add3~2\);

-- Location: MLABCELL_X65_Y10_N45
\LessThan9~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~3_combout\ = ( \Add3~1_sumout\ & ( !\v~112_combout\ ) ) # ( !\Add3~1_sumout\ & ( \v~112_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~112_combout\,
	dataf => \ALT_INV_Add3~1_sumout\,
	combout => \LessThan9~3_combout\);

-- Location: FF_X63_Y11_N44
\r.y1[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~147_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(15));

-- Location: LABCELL_X63_Y11_N42
\v~147\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~147_combout\ = ( \comb~0_combout\ & ( \r.y1\(15) ) ) # ( !\comb~0_combout\ & ( (\d.tile.y1[15]~input_o\ & (!\v~0_combout\ & \d.clip_rect.y1[15]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000010000000100000001000000010000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.y1[15]~input_o\,
	datab => \ALT_INV_v~0_combout\,
	datac => \ALT_INV_d.clip_rect.y1[15]~input_o\,
	datad => \ALT_INV_r.y1\(15),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~147_combout\);

-- Location: FF_X65_Y12_N44
\r.y1[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~114_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(13));

-- Location: MLABCELL_X65_Y12_N42
\v~114\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~114_combout\ = ( \r.y1\(13) & ( \comb~0_combout\ ) ) # ( \r.y1\(13) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[13]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[13]~input_o\)))) ) ) ) # ( !\r.y1\(13) 
-- & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[13]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[13]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000001010000001100000101000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[13]~input_o\,
	datab => \ALT_INV_d.tile.y1[13]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_LessThan7~14_combout\,
	datae => \ALT_INV_r.y1\(13),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~114_combout\);

-- Location: FF_X65_Y11_N38
\r.i[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~13_sumout\,
	asdata => \v~25_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(13));

-- Location: LABCELL_X66_Y11_N42
\v~25\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~25_combout\ = ( \r.i\(13) & ( \comb~0_combout\ ) ) # ( \r.i\(13) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[13]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[13]~input_o\)))) ) ) ) # ( !\r.i\(13) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & ((\d.tile.y0[13]~input_o\))) # (\LessThan4~14_combout\ & (\d.clip_rect.y0[13]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001010100010000000101010001000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.clip_rect.y0[13]~input_o\,
	datac => \ALT_INV_LessThan4~14_combout\,
	datad => \ALT_INV_d.tile.y0[13]~input_o\,
	datae => \ALT_INV_r.i\(13),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~25_combout\);

-- Location: MLABCELL_X65_Y11_N36
\Add3~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~13_sumout\ = SUM(( \v~25_combout\ ) + ( GND ) + ( \Add3~2\ ))
-- \Add3~14\ = CARRY(( \v~25_combout\ ) + ( GND ) + ( \Add3~2\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~25_combout\,
	cin => \Add3~2\,
	sumout => \Add3~13_sumout\,
	cout => \Add3~14\);

-- Location: FF_X64_Y12_N44
\r.y1[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~113_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.y1\(14));

-- Location: LABCELL_X64_Y12_N42
\v~113\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~113_combout\ = ( \r.y1\(14) & ( \comb~0_combout\ ) ) # ( \r.y1\(14) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[14]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[14]~input_o\)))) ) ) ) # ( !\r.y1\(14) 
-- & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan7~14_combout\ & ((\d.tile.y1[14]~input_o\))) # (\LessThan7~14_combout\ & (\d.clip_rect.y1[14]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011010100000000001101010000000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y1[14]~input_o\,
	datab => \ALT_INV_d.tile.y1[14]~input_o\,
	datac => \ALT_INV_LessThan7~14_combout\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.y1\(14),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~113_combout\);

-- Location: FF_X65_Y11_N40
\r.i[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~9_sumout\,
	asdata => \v~27_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(14));

-- Location: LABCELL_X64_Y11_N6
\v~27\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~27_combout\ = ( \r.i\(14) & ( \comb~0_combout\ ) ) # ( \r.i\(14) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & (\d.tile.y0[14]~input_o\)) # (\LessThan4~14_combout\ & ((\d.clip_rect.y0[14]~input_o\))))) ) ) ) # ( !\r.i\(14) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & (\d.tile.y0[14]~input_o\)) # (\LessThan4~14_combout\ & ((\d.clip_rect.y0[14]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010001000001010001000100000101000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.tile.y0[14]~input_o\,
	datac => \ALT_INV_d.clip_rect.y0[14]~input_o\,
	datad => \ALT_INV_LessThan4~14_combout\,
	datae => \ALT_INV_r.i\(14),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~27_combout\);

-- Location: MLABCELL_X65_Y11_N39
\Add3~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~9_sumout\ = SUM(( \v~27_combout\ ) + ( GND ) + ( \Add3~14\ ))
-- \Add3~10\ = CARRY(( \v~27_combout\ ) + ( GND ) + ( \Add3~14\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~27_combout\,
	cin => \Add3~14\,
	sumout => \Add3~9_sumout\,
	cout => \Add3~10\);

-- Location: MLABCELL_X65_Y9_N30
\r.i[15]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.i[15]~feeder_combout\ = \Add3~5_sumout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111100000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_Add3~5_sumout\,
	combout => \r.i[15]~feeder_combout\);

-- Location: FF_X65_Y9_N31
\r.i[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.i[15]~feeder_combout\,
	asdata => \v~149_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(15));

-- Location: LABCELL_X64_Y11_N30
\v~149\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~149_combout\ = ( \comb~0_combout\ & ( \r.i\(15) ) ) # ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((\d.tile.y0[15]~input_o\) # (\d.clip_rect.y0[15]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111000001110000011100000111000000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.y0[15]~input_o\,
	datab => \ALT_INV_d.tile.y0[15]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_r.i\(15),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~149_combout\);

-- Location: MLABCELL_X65_Y11_N42
\Add3~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add3~5_sumout\ = SUM(( \v~149_combout\ ) + ( GND ) + ( \Add3~10\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~149_combout\,
	cin => \Add3~10\,
	sumout => \Add3~5_sumout\);

-- Location: MLABCELL_X65_Y10_N36
\LessThan9~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~0_combout\ = ( \Add3~9_sumout\ & ( \Add3~5_sumout\ & ( (\v~147_combout\ & (\v~113_combout\ & (!\v~114_combout\ $ (\Add3~13_sumout\)))) ) ) ) # ( !\Add3~9_sumout\ & ( \Add3~5_sumout\ & ( (\v~147_combout\ & (!\v~113_combout\ & (!\v~114_combout\ $ 
-- (\Add3~13_sumout\)))) ) ) ) # ( \Add3~9_sumout\ & ( !\Add3~5_sumout\ & ( (!\v~147_combout\ & (\v~113_combout\ & (!\v~114_combout\ $ (\Add3~13_sumout\)))) ) ) ) # ( !\Add3~9_sumout\ & ( !\Add3~5_sumout\ & ( (!\v~147_combout\ & (!\v~113_combout\ & 
-- (!\v~114_combout\ $ (\Add3~13_sumout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000001000000000000000001000001001000001000000000000000001000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~147_combout\,
	datab => \ALT_INV_v~114_combout\,
	datac => \ALT_INV_Add3~13_sumout\,
	datad => \ALT_INV_v~113_combout\,
	datae => \ALT_INV_Add3~9_sumout\,
	dataf => \ALT_INV_Add3~5_sumout\,
	combout => \LessThan9~0_combout\);

-- Location: MLABCELL_X65_Y10_N48
\LessThan9~15\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~15_combout\ = ( !\LessThan9~3_combout\ & ( \LessThan9~0_combout\ & ( (!\LessThan9~4_combout\ & ((!\LessThan9~14_combout\ & (!\v~116_combout\ & \Add3~21_sumout\)) # (\LessThan9~14_combout\ & ((!\v~116_combout\) # (\Add3~21_sumout\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000001001101000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan9~14_combout\,
	datab => \ALT_INV_v~116_combout\,
	datac => \ALT_INV_Add3~21_sumout\,
	datad => \ALT_INV_LessThan9~4_combout\,
	datae => \ALT_INV_LessThan9~3_combout\,
	dataf => \ALT_INV_LessThan9~0_combout\,
	combout => \LessThan9~15_combout\);

-- Location: MLABCELL_X65_Y10_N30
\LessThan9~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~5_combout\ = !\v~116_combout\ $ (!\Add3~21_sumout\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111111110000000011111111000000001111111100000000111111110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~116_combout\,
	datad => \ALT_INV_Add3~21_sumout\,
	combout => \LessThan9~5_combout\);

-- Location: MLABCELL_X65_Y10_N15
\LessThan9~16\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~16_combout\ = ( !\LessThan9~3_combout\ & ( \LessThan9~0_combout\ & ( (!\LessThan9~5_combout\ & !\LessThan9~4_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011001100000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_LessThan9~5_combout\,
	datad => \ALT_INV_LessThan9~4_combout\,
	datae => \ALT_INV_LessThan9~3_combout\,
	dataf => \ALT_INV_LessThan9~0_combout\,
	combout => \LessThan9~16_combout\);

-- Location: MLABCELL_X65_Y12_N54
\LessThan9~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~1_combout\ = ( \Add3~9_sumout\ & ( \Add3~5_sumout\ & ( (!\v~147_combout\) # ((!\v~113_combout\) # ((!\v~114_combout\ & \Add3~13_sumout\))) ) ) ) # ( !\Add3~9_sumout\ & ( \Add3~5_sumout\ & ( (!\v~147_combout\) # ((!\v~114_combout\ & 
-- (\Add3~13_sumout\ & !\v~113_combout\))) ) ) ) # ( \Add3~9_sumout\ & ( !\Add3~5_sumout\ & ( (!\v~147_combout\ & ((!\v~113_combout\) # ((!\v~114_combout\ & \Add3~13_sumout\)))) ) ) ) # ( !\Add3~9_sumout\ & ( !\Add3~5_sumout\ & ( (!\v~147_combout\ & 
-- (!\v~114_combout\ & (\Add3~13_sumout\ & !\v~113_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000000000101010100000100010101110101010101111111110101110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~147_combout\,
	datab => \ALT_INV_v~114_combout\,
	datac => \ALT_INV_Add3~13_sumout\,
	datad => \ALT_INV_v~113_combout\,
	datae => \ALT_INV_Add3~9_sumout\,
	dataf => \ALT_INV_Add3~5_sumout\,
	combout => \LessThan9~1_combout\);

-- Location: MLABCELL_X65_Y12_N36
\LessThan9~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~2_combout\ = ( !\LessThan9~1_combout\ & ( \LessThan9~0_combout\ & ( (!\v~112_combout\ & (!\Add3~1_sumout\ & ((!\Add3~17_sumout\) # (\v~115_combout\)))) # (\v~112_combout\ & (((!\Add3~17_sumout\) # (!\Add3~1_sumout\)) # (\v~115_combout\))) ) ) ) 
-- # ( !\LessThan9~1_combout\ & ( !\LessThan9~0_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111000000000000000011110111001100010000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~115_combout\,
	datab => \ALT_INV_v~112_combout\,
	datac => \ALT_INV_Add3~17_sumout\,
	datad => \ALT_INV_Add3~1_sumout\,
	datae => \ALT_INV_LessThan9~1_combout\,
	dataf => \ALT_INV_LessThan9~0_combout\,
	combout => \LessThan9~2_combout\);

-- Location: MLABCELL_X65_Y10_N18
\v~129\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~129_combout\ = ( \LessThan8~14_combout\ & ( \LessThan9~2_combout\ & ( !\v~128_combout\ ) ) ) # ( !\LessThan8~14_combout\ & ( \LessThan9~2_combout\ & ( (!\v~128_combout\ & (!\LessThan9~15_combout\ & ((!\LessThan9~17_combout\) # 
-- (!\LessThan9~16_combout\)))) ) ) ) # ( \LessThan8~14_combout\ & ( !\LessThan9~2_combout\ & ( !\v~128_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000101010101010101010100000100000001010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~128_combout\,
	datab => \ALT_INV_LessThan9~17_combout\,
	datac => \ALT_INV_LessThan9~15_combout\,
	datad => \ALT_INV_LessThan9~16_combout\,
	datae => \ALT_INV_LessThan8~14_combout\,
	dataf => \ALT_INV_LessThan9~2_combout\,
	combout => \v~129_combout\);

-- Location: FF_X65_Y10_N20
\r.generate_quads\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~129_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.generate_quads~q\);

-- Location: LABCELL_X63_Y10_N0
\v~126\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~126_combout\ = ( !\reset~input_o\ & ( \r.next_quad~q\ & ( ((\v~0_combout\ & !\r.generate_quads~q\)) # (\r.end_tile~q\) ) ) ) # ( !\reset~input_o\ & ( !\r.next_quad~q\ & ( (!\d.next_quad~input_o\ & \r.end_tile~q\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010101010000000000000000000110000111111110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.next_quad~input_o\,
	datab => \ALT_INV_v~0_combout\,
	datac => \ALT_INV_r.generate_quads~q\,
	datad => \ALT_INV_r.end_tile~q\,
	datae => \ALT_INV_reset~input_o\,
	dataf => \ALT_INV_r.next_quad~q\,
	combout => \v~126_combout\);

-- Location: MLABCELL_X65_Y12_N0
\v~95\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~95_combout\ = ( \r.next_quad~q\ & ( !\reset~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_reset~input_o\,
	dataf => \ALT_INV_r.next_quad~q\,
	combout => \v~95_combout\);

-- Location: MLABCELL_X65_Y10_N24
\LessThan9~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~12_combout\ = ( !\LessThan9~11_combout\ & ( (!\LessThan9~10_combout\) # ((!\LessThan9~9_combout\ & ((!\LessThan9~7_combout\) # (!\LessThan9~8_combout\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111001000111111111100100000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan9~7_combout\,
	datab => \ALT_INV_LessThan9~9_combout\,
	datac => \ALT_INV_LessThan9~8_combout\,
	datad => \ALT_INV_LessThan9~10_combout\,
	dataf => \ALT_INV_LessThan9~11_combout\,
	combout => \LessThan9~12_combout\);

-- Location: MLABCELL_X65_Y10_N0
\LessThan9~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan9~13_combout\ = ( !\LessThan9~3_combout\ & ( !\LessThan9~12_combout\ & ( (!\LessThan9~4_combout\ & (!\LessThan9~6_combout\ & (\LessThan9~0_combout\ & !\LessThan9~5_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan9~4_combout\,
	datab => \ALT_INV_LessThan9~6_combout\,
	datac => \ALT_INV_LessThan9~0_combout\,
	datad => \ALT_INV_LessThan9~5_combout\,
	datae => \ALT_INV_LessThan9~3_combout\,
	dataf => \ALT_INV_LessThan9~12_combout\,
	combout => \LessThan9~13_combout\);

-- Location: LABCELL_X64_Y10_N51
\v~127\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~127_combout\ = ( \LessThan8~14_combout\ & ( \LessThan9~2_combout\ & ( \v~126_combout\ ) ) ) # ( !\LessThan8~14_combout\ & ( \LessThan9~2_combout\ & ( ((\v~95_combout\ & ((\LessThan9~13_combout\) # (\LessThan9~15_combout\)))) # (\v~126_combout\) ) ) ) # 
-- ( \LessThan8~14_combout\ & ( !\LessThan9~2_combout\ & ( \v~126_combout\ ) ) ) # ( !\LessThan8~14_combout\ & ( !\LessThan9~2_combout\ & ( (\v~95_combout\) # (\v~126_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111011101110111010101010101010101010111011101110101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~126_combout\,
	datab => \ALT_INV_v~95_combout\,
	datac => \ALT_INV_LessThan9~15_combout\,
	datad => \ALT_INV_LessThan9~13_combout\,
	datae => \ALT_INV_LessThan8~14_combout\,
	dataf => \ALT_INV_LessThan9~2_combout\,
	combout => \v~127_combout\);

-- Location: FF_X64_Y10_N56
\r.end_tile\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~127_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.end_tile~q\);

-- Location: LABCELL_X64_Y10_N57
\comb~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \comb~0_combout\ = ( \r.generate_quads~q\ ) # ( !\r.generate_quads~q\ & ( \r.end_tile~q\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111111111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_r.end_tile~q\,
	dataf => \ALT_INV_r.generate_quads~q\,
	combout => \comb~0_combout\);

-- Location: LABCELL_X63_Y10_N51
\v~92\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~92_combout\ = (\d.clip_rect.x0[15]~input_o\) # (\d.tile.x0[15]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111111111111000011111111111100001111111111110000111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_d.tile.x0[15]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	combout => \v~92_combout\);

-- Location: FF_X61_Y9_N14
\r.x0[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~146_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(15));

-- Location: LABCELL_X61_Y9_N12
\v~146\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~146_combout\ = ( \comb~0_combout\ & ( \r.x0\(15) ) ) # ( !\comb~0_combout\ & ( (!\v~0_combout\ & \v~92_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010000010100000101000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datac => \ALT_INV_v~92_combout\,
	datad => \ALT_INV_r.x0\(15),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~146_combout\);

-- Location: MLABCELL_X65_Y9_N57
\r.j[15]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[15]~feeder_combout\ = \v~146_combout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010101010101010101010101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~146_combout\,
	combout => \r.j[15]~feeder_combout\);

-- Location: FF_X65_Y9_N59
\r.j[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[15]~feeder_combout\,
	asdata => \Add2~1_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(15));

-- Location: LABCELL_X62_Y7_N0
\LessThan5~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~8_combout\ = ( \d.clip_rect.x0[13]~input_o\ & ( \d.tile.x0[13]~input_o\ & ( (!\d.clip_rect.x0[12]~input_o\ & (!\d.tile.x0[12]~input_o\ & (!\d.tile.x0[14]~input_o\ $ (\d.clip_rect.x0[14]~input_o\)))) # (\d.clip_rect.x0[12]~input_o\ & 
-- (\d.tile.x0[12]~input_o\ & (!\d.tile.x0[14]~input_o\ $ (\d.clip_rect.x0[14]~input_o\)))) ) ) ) # ( !\d.clip_rect.x0[13]~input_o\ & ( !\d.tile.x0[13]~input_o\ & ( (!\d.clip_rect.x0[12]~input_o\ & (!\d.tile.x0[12]~input_o\ & (!\d.tile.x0[14]~input_o\ $ 
-- (\d.clip_rect.x0[14]~input_o\)))) # (\d.clip_rect.x0[12]~input_o\ & (\d.tile.x0[12]~input_o\ & (!\d.tile.x0[14]~input_o\ $ (\d.clip_rect.x0[14]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000010000100001000000000000000000000000000000001000010000100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[12]~input_o\,
	datab => \ALT_INV_d.tile.x0[14]~input_o\,
	datac => \ALT_INV_d.tile.x0[12]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[14]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[13]~input_o\,
	dataf => \ALT_INV_d.tile.x0[13]~input_o\,
	combout => \LessThan5~8_combout\);

-- Location: LABCELL_X63_Y7_N6
\LessThan5~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~9_combout\ = ( \LessThan5~8_combout\ & ( (!\d.tile.x0[11]~input_o\ & (!\d.clip_rect.x0[11]~input_o\ & (!\d.tile.x0[10]~input_o\ $ (\d.clip_rect.x0[10]~input_o\)))) # (\d.tile.x0[11]~input_o\ & (\d.clip_rect.x0[11]~input_o\ & 
-- (!\d.tile.x0[10]~input_o\ $ (\d.clip_rect.x0[10]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000010010000000010011001000000001001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x0[11]~input_o\,
	datab => \ALT_INV_d.clip_rect.x0[11]~input_o\,
	datac => \ALT_INV_d.tile.x0[10]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[10]~input_o\,
	dataf => \ALT_INV_LessThan5~8_combout\,
	combout => \LessThan5~9_combout\);

-- Location: LABCELL_X62_Y7_N18
\LessThan5~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~11_combout\ = ( \d.clip_rect.x0[13]~input_o\ & ( \d.tile.x0[13]~input_o\ & ( (!\d.tile.x0[14]~input_o\ & (!\d.clip_rect.x0[12]~input_o\ & (\d.tile.x0[12]~input_o\ & !\d.clip_rect.x0[14]~input_o\))) # (\d.tile.x0[14]~input_o\ & 
-- ((!\d.clip_rect.x0[14]~input_o\) # ((!\d.clip_rect.x0[12]~input_o\ & \d.tile.x0[12]~input_o\)))) ) ) ) # ( !\d.clip_rect.x0[13]~input_o\ & ( \d.tile.x0[13]~input_o\ & ( (!\d.clip_rect.x0[14]~input_o\) # (\d.tile.x0[14]~input_o\) ) ) ) # ( 
-- \d.clip_rect.x0[13]~input_o\ & ( !\d.tile.x0[13]~input_o\ & ( (\d.tile.x0[14]~input_o\ & !\d.clip_rect.x0[14]~input_o\) ) ) ) # ( !\d.clip_rect.x0[13]~input_o\ & ( !\d.tile.x0[13]~input_o\ & ( (!\d.tile.x0[14]~input_o\ & (!\d.clip_rect.x0[12]~input_o\ & 
-- (\d.tile.x0[12]~input_o\ & !\d.clip_rect.x0[14]~input_o\))) # (\d.tile.x0[14]~input_o\ & ((!\d.clip_rect.x0[14]~input_o\) # ((!\d.clip_rect.x0[12]~input_o\ & \d.tile.x0[12]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011101100000010001100110000000011111111001100110011101100000010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[12]~input_o\,
	datab => \ALT_INV_d.tile.x0[14]~input_o\,
	datac => \ALT_INV_d.tile.x0[12]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[14]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[13]~input_o\,
	dataf => \ALT_INV_d.tile.x0[13]~input_o\,
	combout => \LessThan5~11_combout\);

-- Location: LABCELL_X63_Y7_N18
\LessThan5~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~12_combout\ = ( \d.clip_rect.x0[11]~input_o\ & ( \d.tile.x0[10]~input_o\ & ( (!\LessThan5~11_combout\ & (((!\d.tile.x0[11]~input_o\) # (!\LessThan5~8_combout\)) # (\d.clip_rect.x0[10]~input_o\))) ) ) ) # ( !\d.clip_rect.x0[11]~input_o\ & ( 
-- \d.tile.x0[10]~input_o\ & ( (!\LessThan5~11_combout\ & ((!\LessThan5~8_combout\) # ((\d.clip_rect.x0[10]~input_o\ & !\d.tile.x0[11]~input_o\)))) ) ) ) # ( \d.clip_rect.x0[11]~input_o\ & ( !\d.tile.x0[10]~input_o\ & ( !\LessThan5~11_combout\ ) ) ) # ( 
-- !\d.clip_rect.x0[11]~input_o\ & ( !\d.tile.x0[10]~input_o\ & ( (!\LessThan5~11_combout\ & ((!\d.tile.x0[11]~input_o\) # (!\LessThan5~8_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1100110011000000110011001100110011001100010000001100110011000100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[10]~input_o\,
	datab => \ALT_INV_LessThan5~11_combout\,
	datac => \ALT_INV_d.tile.x0[11]~input_o\,
	datad => \ALT_INV_LessThan5~8_combout\,
	datae => \ALT_INV_d.clip_rect.x0[11]~input_o\,
	dataf => \ALT_INV_d.tile.x0[10]~input_o\,
	combout => \LessThan5~12_combout\);

-- Location: LABCELL_X63_Y7_N0
\LessThan5~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~13_combout\ = ( \d.clip_rect.x0[9]~input_o\ & ( \LessThan5~12_combout\ & ( ((!\d.tile.x0[9]~input_o\) # ((!\d.tile.x0[8]~input_o\) # (!\LessThan5~9_combout\))) # (\d.clip_rect.x0[8]~input_o\) ) ) ) # ( !\d.clip_rect.x0[9]~input_o\ & ( 
-- \LessThan5~12_combout\ & ( (!\LessThan5~9_combout\) # ((!\d.tile.x0[9]~input_o\ & ((!\d.tile.x0[8]~input_o\) # (\d.clip_rect.x0[8]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111110001001111111111111101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[8]~input_o\,
	datab => \ALT_INV_d.tile.x0[9]~input_o\,
	datac => \ALT_INV_d.tile.x0[8]~input_o\,
	datad => \ALT_INV_LessThan5~9_combout\,
	datae => \ALT_INV_d.clip_rect.x0[9]~input_o\,
	dataf => \ALT_INV_LessThan5~12_combout\,
	combout => \LessThan5~13_combout\);

-- Location: LABCELL_X64_Y7_N48
\LessThan5~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~2_combout\ = ( \d.tile.x0[6]~input_o\ & ( (\d.clip_rect.x0[6]~input_o\ & (!\d.clip_rect.x0[7]~input_o\ $ (\d.tile.x0[7]~input_o\))) ) ) # ( !\d.tile.x0[6]~input_o\ & ( (!\d.clip_rect.x0[6]~input_o\ & (!\d.clip_rect.x0[7]~input_o\ $ 
-- (\d.tile.x0[7]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010010100000000101001010000000000000000101001010000000010100101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[7]~input_o\,
	datac => \ALT_INV_d.tile.x0[7]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[6]~input_o\,
	dataf => \ALT_INV_d.tile.x0[6]~input_o\,
	combout => \LessThan5~2_combout\);

-- Location: LABCELL_X64_Y7_N33
\LessThan5~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~3_combout\ = ( \d.tile.x0[5]~input_o\ & ( (\LessThan5~2_combout\ & (\d.clip_rect.x0[5]~input_o\ & (!\d.tile.x0[4]~input_o\ $ (\d.clip_rect.x0[4]~input_o\)))) ) ) # ( !\d.tile.x0[5]~input_o\ & ( (\LessThan5~2_combout\ & 
-- (!\d.clip_rect.x0[5]~input_o\ & (!\d.tile.x0[4]~input_o\ $ (\d.clip_rect.x0[4]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000100000000010000010000000000000000010000010000000001000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~2_combout\,
	datab => \ALT_INV_d.tile.x0[4]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[4]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[5]~input_o\,
	dataf => \ALT_INV_d.tile.x0[5]~input_o\,
	combout => \LessThan5~3_combout\);

-- Location: MLABCELL_X65_Y7_N54
\LessThan5~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~6_combout\ = ( !\d.clip_rect.x0[8]~input_o\ & ( \d.tile.x0[8]~input_o\ ) ) # ( \d.clip_rect.x0[8]~input_o\ & ( !\d.tile.x0[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111111111111111111110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datae => \ALT_INV_d.clip_rect.x0[8]~input_o\,
	dataf => \ALT_INV_d.tile.x0[8]~input_o\,
	combout => \LessThan5~6_combout\);

-- Location: LABCELL_X64_Y7_N51
\LessThan5~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~4_combout\ = ( \d.tile.x0[6]~input_o\ & ( (!\d.clip_rect.x0[7]~input_o\ & ((!\d.clip_rect.x0[6]~input_o\) # (\d.tile.x0[7]~input_o\))) # (\d.clip_rect.x0[7]~input_o\ & (\d.tile.x0[7]~input_o\ & !\d.clip_rect.x0[6]~input_o\)) ) ) # ( 
-- !\d.tile.x0[6]~input_o\ & ( (!\d.clip_rect.x0[7]~input_o\ & \d.tile.x0[7]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010000010100000101010101111000010101010111100001010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[7]~input_o\,
	datac => \ALT_INV_d.tile.x0[7]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[6]~input_o\,
	dataf => \ALT_INV_d.tile.x0[6]~input_o\,
	combout => \LessThan5~4_combout\);

-- Location: LABCELL_X64_Y7_N54
\LessThan5~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~5_combout\ = ( \d.tile.x0[4]~input_o\ & ( \d.tile.x0[5]~input_o\ & ( (!\LessThan5~4_combout\ & ((!\LessThan5~2_combout\) # ((\d.clip_rect.x0[4]~input_o\ & \d.clip_rect.x0[5]~input_o\)))) ) ) ) # ( !\d.tile.x0[4]~input_o\ & ( 
-- \d.tile.x0[5]~input_o\ & ( (!\LessThan5~4_combout\ & ((!\LessThan5~2_combout\) # (\d.clip_rect.x0[5]~input_o\))) ) ) ) # ( \d.tile.x0[4]~input_o\ & ( !\d.tile.x0[5]~input_o\ & ( (!\LessThan5~4_combout\ & ((!\LessThan5~2_combout\) # 
-- ((\d.clip_rect.x0[5]~input_o\) # (\d.clip_rect.x0[4]~input_o\)))) ) ) ) # ( !\d.tile.x0[4]~input_o\ & ( !\d.tile.x0[5]~input_o\ & ( !\LessThan5~4_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111000011110000101100001111000010100000111100001010000010110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~2_combout\,
	datab => \ALT_INV_d.clip_rect.x0[4]~input_o\,
	datac => \ALT_INV_LessThan5~4_combout\,
	datad => \ALT_INV_d.clip_rect.x0[5]~input_o\,
	datae => \ALT_INV_d.tile.x0[4]~input_o\,
	dataf => \ALT_INV_d.tile.x0[5]~input_o\,
	combout => \LessThan5~5_combout\);

-- Location: LABCELL_X63_Y10_N24
\LessThan5~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~0_combout\ = ( \d.tile.x0[0]~input_o\ & ( (!\d.tile.x0[1]~input_o\ & (!\d.clip_rect.x0[0]~input_o\ & !\d.clip_rect.x0[1]~input_o\)) # (\d.tile.x0[1]~input_o\ & ((!\d.clip_rect.x0[0]~input_o\) # (!\d.clip_rect.x0[1]~input_o\))) ) ) # ( 
-- !\d.tile.x0[0]~input_o\ & ( (\d.tile.x0[1]~input_o\ & !\d.clip_rect.x0[1]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100000000001100110000000011110011001100001111001100110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.tile.x0[1]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[0]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[1]~input_o\,
	dataf => \ALT_INV_d.tile.x0[0]~input_o\,
	combout => \LessThan5~0_combout\);

-- Location: LABCELL_X63_Y7_N36
\LessThan5~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~1_combout\ = ( \d.clip_rect.x0[3]~input_o\ & ( \d.tile.x0[2]~input_o\ & ( (\d.tile.x0[3]~input_o\ & ((!\d.clip_rect.x0[2]~input_o\) # (\LessThan5~0_combout\))) ) ) ) # ( !\d.clip_rect.x0[3]~input_o\ & ( \d.tile.x0[2]~input_o\ & ( 
-- ((!\d.clip_rect.x0[2]~input_o\) # (\LessThan5~0_combout\)) # (\d.tile.x0[3]~input_o\) ) ) ) # ( \d.clip_rect.x0[3]~input_o\ & ( !\d.tile.x0[2]~input_o\ & ( (\d.tile.x0[3]~input_o\ & (!\d.clip_rect.x0[2]~input_o\ & \LessThan5~0_combout\)) ) ) ) # ( 
-- !\d.clip_rect.x0[3]~input_o\ & ( !\d.tile.x0[2]~input_o\ & ( ((!\d.clip_rect.x0[2]~input_o\ & \LessThan5~0_combout\)) # (\d.tile.x0[3]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101110101011101000001000000010011011111110111110100010101000101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x0[3]~input_o\,
	datab => \ALT_INV_d.clip_rect.x0[2]~input_o\,
	datac => \ALT_INV_LessThan5~0_combout\,
	datae => \ALT_INV_d.clip_rect.x0[3]~input_o\,
	dataf => \ALT_INV_d.tile.x0[2]~input_o\,
	combout => \LessThan5~1_combout\);

-- Location: LABCELL_X63_Y7_N9
\LessThan5~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~7_combout\ = !\d.tile.x0[9]~input_o\ $ (!\d.clip_rect.x0[9]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111111110000000011111111000000001111111100000000111111110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_d.tile.x0[9]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[9]~input_o\,
	combout => \LessThan5~7_combout\);

-- Location: LABCELL_X63_Y7_N12
\LessThan5~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan5~10_combout\ = ( \LessThan5~1_combout\ & ( !\LessThan5~7_combout\ & ( (\LessThan5~9_combout\ & (!\LessThan5~6_combout\ & ((!\LessThan5~5_combout\) # (\LessThan5~3_combout\)))) ) ) ) # ( !\LessThan5~1_combout\ & ( !\LessThan5~7_combout\ & ( 
-- (\LessThan5~9_combout\ & (!\LessThan5~6_combout\ & !\LessThan5~5_combout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000000000000001100000001000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~3_combout\,
	datab => \ALT_INV_LessThan5~9_combout\,
	datac => \ALT_INV_LessThan5~6_combout\,
	datad => \ALT_INV_LessThan5~5_combout\,
	datae => \ALT_INV_LessThan5~1_combout\,
	dataf => \ALT_INV_LessThan5~7_combout\,
	combout => \LessThan5~10_combout\);

-- Location: LABCELL_X62_Y7_N33
\v~89\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~89_combout\ = ( \d.clip_rect.x0[14]~input_o\ & ( \d.tile.x0[14]~input_o\ ) ) # ( !\d.clip_rect.x0[14]~input_o\ & ( \d.tile.x0[14]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & (!\d.clip_rect.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # 
-- (\LessThan5~10_combout\)))) # (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # ((!\d.clip_rect.x0[15]~input_o\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[14]~input_o\ & ( !\d.tile.x0[14]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & 
-- (((\LessThan5~13_combout\ & !\LessThan5~10_combout\)) # (\d.clip_rect.x0[15]~input_o\))) # (\d.tile.x0[15]~input_o\ & (\LessThan5~13_combout\ & (!\LessThan5~10_combout\ & \d.clip_rect.x0[15]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010000001101110010111111001000111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~13_combout\,
	datab => \ALT_INV_d.tile.x0[15]~input_o\,
	datac => \ALT_INV_LessThan5~10_combout\,
	datad => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[14]~input_o\,
	dataf => \ALT_INV_d.tile.x0[14]~input_o\,
	combout => \v~89_combout\);

-- Location: FF_X62_Y8_N2
\r.x0[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~145_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(14));

-- Location: LABCELL_X62_Y8_N0
\v~145\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~145_combout\ = ( \r.x0\(14) & ( \comb~0_combout\ ) ) # ( \r.x0\(14) & ( !\comb~0_combout\ & ( (\v~89_combout\ & !\v~0_combout\) ) ) ) # ( !\r.x0\(14) & ( !\comb~0_combout\ & ( (\v~89_combout\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000001010000010100000101000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~89_combout\,
	datac => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.x0\(14),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~145_combout\);

-- Location: LABCELL_X63_Y9_N3
\r.j[14]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[14]~feeder_combout\ = ( \v~145_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~145_combout\,
	combout => \r.j[14]~feeder_combout\);

-- Location: LABCELL_X62_Y7_N30
\v~86\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~86_combout\ = ( \d.clip_rect.x0[13]~input_o\ & ( \d.tile.x0[13]~input_o\ ) ) # ( !\d.clip_rect.x0[13]~input_o\ & ( \d.tile.x0[13]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & (!\d.clip_rect.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # 
-- (\LessThan5~10_combout\)))) # (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # ((!\d.clip_rect.x0[15]~input_o\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[13]~input_o\ & ( !\d.tile.x0[13]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & 
-- (((\LessThan5~13_combout\ & !\LessThan5~10_combout\)) # (\d.clip_rect.x0[15]~input_o\))) # (\d.tile.x0[15]~input_o\ & (\LessThan5~13_combout\ & (\d.clip_rect.x0[15]~input_o\ & !\LessThan5~10_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010011010000110010110010111100111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~13_combout\,
	datab => \ALT_INV_d.tile.x0[15]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datad => \ALT_INV_LessThan5~10_combout\,
	datae => \ALT_INV_d.clip_rect.x0[13]~input_o\,
	dataf => \ALT_INV_d.tile.x0[13]~input_o\,
	combout => \v~86_combout\);

-- Location: FF_X60_Y9_N29
\r.x0[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~144_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(13));

-- Location: LABCELL_X60_Y9_N27
\v~144\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~144_combout\ = ( \r.x0\(13) & ( ((\v~86_combout\ & !\v~0_combout\)) # (\comb~0_combout\) ) ) # ( !\r.x0\(13) & ( (!\comb~0_combout\ & (\v~86_combout\ & !\v~0_combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010000000100000011101010111010100100000001000000111010101110101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~0_combout\,
	datab => \ALT_INV_v~86_combout\,
	datac => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.x0\(13),
	combout => \v~144_combout\);

-- Location: MLABCELL_X65_Y9_N54
\r.j[13]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[13]~feeder_combout\ = ( \v~144_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~144_combout\,
	combout => \r.j[13]~feeder_combout\);

-- Location: LABCELL_X62_Y7_N12
\v~83\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~83_combout\ = ( \d.clip_rect.x0[12]~input_o\ & ( \d.clip_rect.x0[15]~input_o\ & ( ((!\d.tile.x0[15]~input_o\) # ((\LessThan5~13_combout\ & !\LessThan5~10_combout\))) # (\d.tile.x0[12]~input_o\) ) ) ) # ( !\d.clip_rect.x0[12]~input_o\ & ( 
-- \d.clip_rect.x0[15]~input_o\ & ( (\d.tile.x0[12]~input_o\ & (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[12]~input_o\ & ( !\d.clip_rect.x0[15]~input_o\ & ( ((\LessThan5~13_combout\ & 
-- (!\LessThan5~10_combout\ & !\d.tile.x0[15]~input_o\))) # (\d.tile.x0[12]~input_o\) ) ) ) # ( !\d.clip_rect.x0[12]~input_o\ & ( !\d.clip_rect.x0[15]~input_o\ & ( (\d.tile.x0[12]~input_o\ & ((!\LessThan5~13_combout\) # ((\d.tile.x0[15]~input_o\) # 
-- (\LessThan5~10_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101100001111010011110000111100000000000010111111111101001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~13_combout\,
	datab => \ALT_INV_LessThan5~10_combout\,
	datac => \ALT_INV_d.tile.x0[12]~input_o\,
	datad => \ALT_INV_d.tile.x0[15]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[12]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	combout => \v~83_combout\);

-- Location: FF_X63_Y10_N41
\r.x0[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~143_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(12));

-- Location: LABCELL_X63_Y10_N39
\v~143\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~143_combout\ = ( \r.x0\(12) & ( \comb~0_combout\ ) ) # ( \r.x0\(12) & ( !\comb~0_combout\ & ( (\v~83_combout\ & !\v~0_combout\) ) ) ) # ( !\r.x0\(12) & ( !\comb~0_combout\ & ( (\v~83_combout\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000001010000010100000101000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~83_combout\,
	datac => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.x0\(12),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~143_combout\);

-- Location: LABCELL_X63_Y9_N36
\r.j[12]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[12]~feeder_combout\ = \v~143_combout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111100000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~143_combout\,
	combout => \r.j[12]~feeder_combout\);

-- Location: LABCELL_X63_Y7_N33
\v~80\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~80_combout\ = ( \d.clip_rect.x0[11]~input_o\ & ( \d.tile.x0[11]~input_o\ ) ) # ( !\d.clip_rect.x0[11]~input_o\ & ( \d.tile.x0[11]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & (((!\LessThan5~13_combout\) # (\d.tile.x0[15]~input_o\)) # 
-- (\LessThan5~10_combout\))) # (\d.clip_rect.x0[15]~input_o\ & (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[11]~input_o\ & ( !\d.tile.x0[11]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & 
-- (!\LessThan5~10_combout\ & (!\d.tile.x0[15]~input_o\ & \LessThan5~13_combout\))) # (\d.clip_rect.x0[15]~input_o\ & ((!\d.tile.x0[15]~input_o\) # ((!\LessThan5~10_combout\ & \LessThan5~13_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010100001101010010101111001010111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datab => \ALT_INV_LessThan5~10_combout\,
	datac => \ALT_INV_d.tile.x0[15]~input_o\,
	datad => \ALT_INV_LessThan5~13_combout\,
	datae => \ALT_INV_d.clip_rect.x0[11]~input_o\,
	dataf => \ALT_INV_d.tile.x0[11]~input_o\,
	combout => \v~80_combout\);

-- Location: FF_X62_Y10_N8
\r.x0[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~142_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(11));

-- Location: LABCELL_X62_Y10_N6
\v~142\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~142_combout\ = ( \r.x0\(11) & ( \comb~0_combout\ ) ) # ( \r.x0\(11) & ( !\comb~0_combout\ & ( (\v~80_combout\ & !\v~0_combout\) ) ) ) # ( !\r.x0\(11) & ( !\comb~0_combout\ & ( (\v~80_combout\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000000110000001100000011000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_v~80_combout\,
	datac => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.x0\(11),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~142_combout\);

-- Location: LABCELL_X63_Y9_N6
\r.j[11]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[11]~feeder_combout\ = ( \v~142_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~142_combout\,
	combout => \r.j[11]~feeder_combout\);

-- Location: LABCELL_X63_Y7_N30
\v~77\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~77_combout\ = ( \d.clip_rect.x0[10]~input_o\ & ( \d.tile.x0[10]~input_o\ ) ) # ( !\d.clip_rect.x0[10]~input_o\ & ( \d.tile.x0[10]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & (((!\LessThan5~13_combout\) # (\d.tile.x0[15]~input_o\)) # 
-- (\LessThan5~10_combout\))) # (\d.clip_rect.x0[15]~input_o\ & (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[10]~input_o\ & ( !\d.tile.x0[10]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & 
-- (!\LessThan5~10_combout\ & (\LessThan5~13_combout\ & !\d.tile.x0[15]~input_o\))) # (\d.clip_rect.x0[15]~input_o\ & ((!\d.tile.x0[15]~input_o\) # ((!\LessThan5~10_combout\ & \LessThan5~13_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010111010000010010100010111110111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datab => \ALT_INV_LessThan5~10_combout\,
	datac => \ALT_INV_LessThan5~13_combout\,
	datad => \ALT_INV_d.tile.x0[15]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[10]~input_o\,
	dataf => \ALT_INV_d.tile.x0[10]~input_o\,
	combout => \v~77_combout\);

-- Location: FF_X61_Y9_N20
\r.x0[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~141_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(10));

-- Location: LABCELL_X61_Y9_N18
\v~141\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~141_combout\ = ( \r.x0\(10) & ( \comb~0_combout\ ) ) # ( \r.x0\(10) & ( !\comb~0_combout\ & ( (\v~77_combout\ & !\v~0_combout\) ) ) ) # ( !\r.x0\(10) & ( !\comb~0_combout\ & ( (\v~77_combout\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000001010000010100000101000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~77_combout\,
	datac => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.x0\(10),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~141_combout\);

-- Location: LABCELL_X63_Y9_N42
\r.j[10]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[10]~feeder_combout\ = ( \v~141_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~141_combout\,
	combout => \r.j[10]~feeder_combout\);

-- Location: LABCELL_X63_Y7_N48
\v~74\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~74_combout\ = ( \d.clip_rect.x0[9]~input_o\ & ( \d.tile.x0[9]~input_o\ ) ) # ( !\d.clip_rect.x0[9]~input_o\ & ( \d.tile.x0[9]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & (!\d.clip_rect.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # 
-- (\LessThan5~10_combout\)))) # (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # ((!\d.clip_rect.x0[15]~input_o\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[9]~input_o\ & ( !\d.tile.x0[9]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & 
-- (((\LessThan5~13_combout\ & !\LessThan5~10_combout\)) # (\d.clip_rect.x0[15]~input_o\))) # (\d.tile.x0[15]~input_o\ & (\LessThan5~13_combout\ & (\d.clip_rect.x0[15]~input_o\ & !\LessThan5~10_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010011010000110010110010111100111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~13_combout\,
	datab => \ALT_INV_d.tile.x0[15]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datad => \ALT_INV_LessThan5~10_combout\,
	datae => \ALT_INV_d.clip_rect.x0[9]~input_o\,
	dataf => \ALT_INV_d.tile.x0[9]~input_o\,
	combout => \v~74_combout\);

-- Location: FF_X60_Y9_N47
\r.x0[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~140_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(9));

-- Location: LABCELL_X60_Y9_N45
\v~140\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~140_combout\ = ( \r.x0\(9) & ( ((\v~74_combout\ & !\v~0_combout\)) # (\comb~0_combout\) ) ) # ( !\r.x0\(9) & ( (\v~74_combout\ & (!\v~0_combout\ & !\comb~0_combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100010000000000010001001111111101000100000000000100010011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~74_combout\,
	datab => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_comb~0_combout\,
	datae => \ALT_INV_r.x0\(9),
	combout => \v~140_combout\);

-- Location: LABCELL_X63_Y9_N21
\r.j[9]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[9]~feeder_combout\ = ( \v~140_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~140_combout\,
	combout => \r.j[9]~feeder_combout\);

-- Location: FF_X60_Y9_N35
\r.x0[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~139_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(8));

-- Location: LABCELL_X63_Y7_N51
\v~71\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~71_combout\ = ( \d.clip_rect.x0[8]~input_o\ & ( \d.tile.x0[8]~input_o\ ) ) # ( !\d.clip_rect.x0[8]~input_o\ & ( \d.tile.x0[8]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & (!\d.clip_rect.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # 
-- (\LessThan5~10_combout\)))) # (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # ((!\d.clip_rect.x0[15]~input_o\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[8]~input_o\ & ( !\d.tile.x0[8]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & 
-- (((\LessThan5~13_combout\ & !\LessThan5~10_combout\)) # (\d.clip_rect.x0[15]~input_o\))) # (\d.tile.x0[15]~input_o\ & (\LessThan5~13_combout\ & (!\LessThan5~10_combout\ & \d.clip_rect.x0[15]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010000001101110010111111001000111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~13_combout\,
	datab => \ALT_INV_d.tile.x0[15]~input_o\,
	datac => \ALT_INV_LessThan5~10_combout\,
	datad => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[8]~input_o\,
	dataf => \ALT_INV_d.tile.x0[8]~input_o\,
	combout => \v~71_combout\);

-- Location: LABCELL_X60_Y9_N33
\v~139\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~139_combout\ = ( \v~71_combout\ & ( (!\comb~0_combout\ & (!\v~0_combout\)) # (\comb~0_combout\ & ((\r.x0\(8)))) ) ) # ( !\v~71_combout\ & ( (\comb~0_combout\ & \r.x0\(8)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000001010101000000000101010110001000110111011000100011011101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~0_combout\,
	datab => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_r.x0\(8),
	dataf => \ALT_INV_v~71_combout\,
	combout => \v~139_combout\);

-- Location: LABCELL_X63_Y9_N24
\r.j[8]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[8]~feeder_combout\ = ( \v~139_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~139_combout\,
	combout => \r.j[8]~feeder_combout\);

-- Location: LABCELL_X64_Y7_N18
\v~68\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~68_combout\ = ( \d.clip_rect.x0[7]~input_o\ & ( \d.tile.x0[7]~input_o\ ) ) # ( !\d.clip_rect.x0[7]~input_o\ & ( \d.tile.x0[7]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & (!\d.clip_rect.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # 
-- (\LessThan5~10_combout\)))) # (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # ((!\d.clip_rect.x0[15]~input_o\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[7]~input_o\ & ( !\d.tile.x0[7]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & 
-- (((\LessThan5~13_combout\ & !\LessThan5~10_combout\)) # (\d.clip_rect.x0[15]~input_o\))) # (\d.tile.x0[15]~input_o\ & (\LessThan5~13_combout\ & (\d.clip_rect.x0[15]~input_o\ & !\LessThan5~10_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010011010000110010110010111100111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~13_combout\,
	datab => \ALT_INV_d.tile.x0[15]~input_o\,
	datac => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datad => \ALT_INV_LessThan5~10_combout\,
	datae => \ALT_INV_d.clip_rect.x0[7]~input_o\,
	dataf => \ALT_INV_d.tile.x0[7]~input_o\,
	combout => \v~68_combout\);

-- Location: FF_X60_Y9_N5
\r.x0[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~138_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(7));

-- Location: LABCELL_X60_Y9_N3
\v~138\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~138_combout\ = ( \r.x0\(7) & ( ((\v~68_combout\ & !\v~0_combout\)) # (\comb~0_combout\) ) ) # ( !\r.x0\(7) & ( (\v~68_combout\ & (!\v~0_combout\ & !\comb~0_combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000000000000010100001111111101010000000000000101000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~68_combout\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_comb~0_combout\,
	datae => \ALT_INV_r.x0\(7),
	combout => \v~138_combout\);

-- Location: MLABCELL_X65_Y9_N12
\r.j[7]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[7]~feeder_combout\ = ( \v~138_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~138_combout\,
	combout => \r.j[7]~feeder_combout\);

-- Location: LABCELL_X64_Y7_N21
\v~65\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~65_combout\ = ( \d.clip_rect.x0[6]~input_o\ & ( \d.tile.x0[6]~input_o\ ) ) # ( !\d.clip_rect.x0[6]~input_o\ & ( \d.tile.x0[6]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & (!\d.clip_rect.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # 
-- (\LessThan5~10_combout\)))) # (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # ((!\d.clip_rect.x0[15]~input_o\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[6]~input_o\ & ( !\d.tile.x0[6]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & 
-- (((\LessThan5~13_combout\ & !\LessThan5~10_combout\)) # (\d.clip_rect.x0[15]~input_o\))) # (\d.tile.x0[15]~input_o\ & (\LessThan5~13_combout\ & (!\LessThan5~10_combout\ & \d.clip_rect.x0[15]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010000001101110010111111001000111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~13_combout\,
	datab => \ALT_INV_d.tile.x0[15]~input_o\,
	datac => \ALT_INV_LessThan5~10_combout\,
	datad => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[6]~input_o\,
	dataf => \ALT_INV_d.tile.x0[6]~input_o\,
	combout => \v~65_combout\);

-- Location: FF_X62_Y10_N29
\r.x0[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~137_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(6));

-- Location: LABCELL_X62_Y10_N27
\v~137\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~137_combout\ = ( \r.x0\(6) & ( \comb~0_combout\ ) ) # ( \r.x0\(6) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \v~65_combout\) ) ) ) # ( !\r.x0\(6) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \v~65_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010101010000000001010101000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_v~65_combout\,
	datae => \ALT_INV_r.x0\(6),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~137_combout\);

-- Location: MLABCELL_X65_Y9_N33
\r.j[6]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[6]~feeder_combout\ = \v~137_combout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111100001111000011110000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~137_combout\,
	combout => \r.j[6]~feeder_combout\);

-- Location: LABCELL_X64_Y7_N15
\v~62\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~62_combout\ = ( \d.clip_rect.x0[5]~input_o\ & ( \d.tile.x0[5]~input_o\ ) ) # ( !\d.clip_rect.x0[5]~input_o\ & ( \d.tile.x0[5]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & (!\d.clip_rect.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # 
-- (\LessThan5~10_combout\)))) # (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # ((!\d.clip_rect.x0[15]~input_o\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[5]~input_o\ & ( !\d.tile.x0[5]~input_o\ & ( (!\d.tile.x0[15]~input_o\ & 
-- (((\LessThan5~13_combout\ & !\LessThan5~10_combout\)) # (\d.clip_rect.x0[15]~input_o\))) # (\d.tile.x0[15]~input_o\ & (\LessThan5~13_combout\ & (!\LessThan5~10_combout\ & \d.clip_rect.x0[15]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010000001111010010111111000010111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~13_combout\,
	datab => \ALT_INV_LessThan5~10_combout\,
	datac => \ALT_INV_d.tile.x0[15]~input_o\,
	datad => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[5]~input_o\,
	dataf => \ALT_INV_d.tile.x0[5]~input_o\,
	combout => \v~62_combout\);

-- Location: FF_X62_Y8_N11
\r.x0[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~136_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(5));

-- Location: LABCELL_X62_Y8_N9
\v~136\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~136_combout\ = ( \r.x0\(5) & ( \comb~0_combout\ ) ) # ( \r.x0\(5) & ( !\comb~0_combout\ & ( (\v~62_combout\ & !\v~0_combout\) ) ) ) # ( !\r.x0\(5) & ( !\comb~0_combout\ & ( (\v~62_combout\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010100000000010101010000000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~62_combout\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.x0\(5),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~136_combout\);

-- Location: MLABCELL_X65_Y9_N42
\r.j[5]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[5]~feeder_combout\ = ( \v~136_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~136_combout\,
	combout => \r.j[5]~feeder_combout\);

-- Location: LABCELL_X64_Y7_N12
\v~59\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~59_combout\ = ( \d.clip_rect.x0[4]~input_o\ & ( \d.tile.x0[4]~input_o\ ) ) # ( !\d.clip_rect.x0[4]~input_o\ & ( \d.tile.x0[4]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # ((\d.tile.x0[15]~input_o\) # 
-- (\LessThan5~10_combout\)))) # (\d.clip_rect.x0[15]~input_o\ & (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[4]~input_o\ & ( !\d.tile.x0[4]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & 
-- (\LessThan5~13_combout\ & (!\LessThan5~10_combout\ & !\d.tile.x0[15]~input_o\))) # (\d.clip_rect.x0[15]~input_o\ & ((!\d.tile.x0[15]~input_o\) # ((\LessThan5~13_combout\ & !\LessThan5~10_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010011110000010010110000111110111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan5~13_combout\,
	datab => \ALT_INV_LessThan5~10_combout\,
	datac => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datad => \ALT_INV_d.tile.x0[15]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[4]~input_o\,
	dataf => \ALT_INV_d.tile.x0[4]~input_o\,
	combout => \v~59_combout\);

-- Location: FF_X60_Y9_N32
\r.x0[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~135_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(4));

-- Location: LABCELL_X60_Y9_N30
\v~135\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~135_combout\ = (!\comb~0_combout\ & (!\v~0_combout\ & (\v~59_combout\))) # (\comb~0_combout\ & (((\r.x0\(4)))))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100001011101000010000101110100001000010111010000100001011101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~0_combout\,
	datab => \ALT_INV_v~0_combout\,
	datac => \ALT_INV_v~59_combout\,
	datad => \ALT_INV_r.x0\(4),
	combout => \v~135_combout\);

-- Location: MLABCELL_X65_Y9_N51
\r.j[4]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[4]~feeder_combout\ = ( \v~135_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~135_combout\,
	combout => \r.j[4]~feeder_combout\);

-- Location: LABCELL_X63_Y7_N54
\v~56\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~56_combout\ = ( \d.clip_rect.x0[3]~input_o\ & ( \d.tile.x0[3]~input_o\ ) ) # ( !\d.clip_rect.x0[3]~input_o\ & ( \d.tile.x0[3]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & (((!\LessThan5~13_combout\) # (\d.tile.x0[15]~input_o\)) # 
-- (\LessThan5~10_combout\))) # (\d.clip_rect.x0[15]~input_o\ & (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[3]~input_o\ & ( !\d.tile.x0[3]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & 
-- (!\LessThan5~10_combout\ & (\LessThan5~13_combout\ & !\d.tile.x0[15]~input_o\))) # (\d.clip_rect.x0[15]~input_o\ & ((!\d.tile.x0[15]~input_o\) # ((!\LessThan5~10_combout\ & \LessThan5~13_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010111010000010010100010111110111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datab => \ALT_INV_LessThan5~10_combout\,
	datac => \ALT_INV_LessThan5~13_combout\,
	datad => \ALT_INV_d.tile.x0[15]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[3]~input_o\,
	dataf => \ALT_INV_d.tile.x0[3]~input_o\,
	combout => \v~56_combout\);

-- Location: FF_X62_Y8_N26
\r.x0[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~134_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(3));

-- Location: LABCELL_X62_Y8_N24
\v~134\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~134_combout\ = ( \r.x0\(3) & ( \comb~0_combout\ ) ) # ( \r.x0\(3) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \v~56_combout\) ) ) ) # ( !\r.x0\(3) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \v~56_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010001000100010001000100010001000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_v~56_combout\,
	datae => \ALT_INV_r.x0\(3),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~134_combout\);

-- Location: LABCELL_X63_Y9_N33
\r.j[3]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[3]~feeder_combout\ = ( \v~134_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~134_combout\,
	combout => \r.j[3]~feeder_combout\);

-- Location: LABCELL_X63_Y7_N57
\v~53\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~53_combout\ = ( \d.clip_rect.x0[2]~input_o\ & ( \d.tile.x0[2]~input_o\ ) ) # ( !\d.clip_rect.x0[2]~input_o\ & ( \d.tile.x0[2]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & (((!\LessThan5~13_combout\) # (\d.tile.x0[15]~input_o\)) # 
-- (\LessThan5~10_combout\))) # (\d.clip_rect.x0[15]~input_o\ & (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[2]~input_o\ & ( !\d.tile.x0[2]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & 
-- (!\LessThan5~10_combout\ & (!\d.tile.x0[15]~input_o\ & \LessThan5~13_combout\))) # (\d.clip_rect.x0[15]~input_o\ & ((!\d.tile.x0[15]~input_o\) # ((!\LessThan5~10_combout\ & \LessThan5~13_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010100001101010010101111001010111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datab => \ALT_INV_LessThan5~10_combout\,
	datac => \ALT_INV_d.tile.x0[15]~input_o\,
	datad => \ALT_INV_LessThan5~13_combout\,
	datae => \ALT_INV_d.clip_rect.x0[2]~input_o\,
	dataf => \ALT_INV_d.tile.x0[2]~input_o\,
	combout => \v~53_combout\);

-- Location: FF_X61_Y9_N53
\r.x0[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~133_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(2));

-- Location: LABCELL_X61_Y9_N51
\v~133\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~133_combout\ = ( \comb~0_combout\ & ( \r.x0\(2) ) ) # ( !\comb~0_combout\ & ( (!\v~0_combout\ & \v~53_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010001000100010001000100010001000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_v~53_combout\,
	datad => \ALT_INV_r.x0\(2),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~133_combout\);

-- Location: LABCELL_X63_Y9_N51
\r.j[2]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[2]~feeder_combout\ = ( \v~133_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~133_combout\,
	combout => \r.j[2]~feeder_combout\);

-- Location: LABCELL_X63_Y10_N9
\v~49\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~49_combout\ = ( \d.clip_rect.x0[1]~input_o\ & ( \d.tile.x0[1]~input_o\ ) ) # ( !\d.clip_rect.x0[1]~input_o\ & ( \d.tile.x0[1]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & (((!\LessThan5~13_combout\) # (\d.tile.x0[15]~input_o\)) # 
-- (\LessThan5~10_combout\))) # (\d.clip_rect.x0[15]~input_o\ & (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[1]~input_o\ & ( !\d.tile.x0[1]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & 
-- (!\LessThan5~10_combout\ & (!\d.tile.x0[15]~input_o\ & \LessThan5~13_combout\))) # (\d.clip_rect.x0[15]~input_o\ & ((!\d.tile.x0[15]~input_o\) # ((!\LessThan5~10_combout\ & \LessThan5~13_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010100001101010010101111001010111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datab => \ALT_INV_LessThan5~10_combout\,
	datac => \ALT_INV_d.tile.x0[15]~input_o\,
	datad => \ALT_INV_LessThan5~13_combout\,
	datae => \ALT_INV_d.clip_rect.x0[1]~input_o\,
	dataf => \ALT_INV_d.tile.x0[1]~input_o\,
	combout => \v~49_combout\);

-- Location: LABCELL_X60_Y10_N27
\v~50\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~50_combout\ = ( \v~49_combout\ & ( !\v~0_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000010101010101010101010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	dataf => \ALT_INV_v~49_combout\,
	combout => \v~50_combout\);

-- Location: FF_X63_Y8_N41
\r.x0[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~132_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x0\(1));

-- Location: LABCELL_X63_Y8_N39
\v~132\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~132_combout\ = ( \comb~0_combout\ & ( \r.x0\(1) ) ) # ( !\comb~0_combout\ & ( \v~50_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111100000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~50_combout\,
	datad => \ALT_INV_r.x0\(1),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~132_combout\);

-- Location: LABCELL_X63_Y9_N57
\r.j[1]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.j[1]~feeder_combout\ = ( \v~132_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_v~132_combout\,
	combout => \r.j[1]~feeder_combout\);

-- Location: LABCELL_X64_Y10_N0
\Add2~57\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~57_sumout\ = SUM(( VCC ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~49_combout\)))) # (\comb~0_combout\ & (((\r.j\(1))))) ) + ( !VCC ))
-- \Add2~58\ = CARRY(( VCC ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~49_combout\)))) # (\comb~0_combout\ & (((\r.j\(1))))) ) + ( !VCC ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(1),
	dataf => \ALT_INV_v~49_combout\,
	cin => GND,
	sumout => \Add2~57_sumout\,
	cout => \Add2~58\);

-- Location: FF_X63_Y9_N59
\r.j[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[1]~feeder_combout\,
	asdata => \Add2~57_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(1));

-- Location: LABCELL_X64_Y10_N3
\Add2~53\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~53_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~53_combout\)))) # (\comb~0_combout\ & (((\r.j\(2))))) ) + ( \Add2~58\ ))
-- \Add2~54\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~53_combout\)))) # (\comb~0_combout\ & (((\r.j\(2))))) ) + ( \Add2~58\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(2),
	dataf => \ALT_INV_v~53_combout\,
	cin => \Add2~58\,
	sumout => \Add2~53_sumout\,
	cout => \Add2~54\);

-- Location: FF_X63_Y9_N53
\r.j[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[2]~feeder_combout\,
	asdata => \Add2~53_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(2));

-- Location: LABCELL_X64_Y10_N6
\Add2~49\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~49_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~56_combout\)))) # (\comb~0_combout\ & (((\r.j\(3))))) ) + ( \Add2~54\ ))
-- \Add2~50\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~56_combout\)))) # (\comb~0_combout\ & (((\r.j\(3))))) ) + ( \Add2~54\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(3),
	dataf => \ALT_INV_v~56_combout\,
	cin => \Add2~54\,
	sumout => \Add2~49_sumout\,
	cout => \Add2~50\);

-- Location: FF_X63_Y9_N35
\r.j[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[3]~feeder_combout\,
	asdata => \Add2~49_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(3));

-- Location: LABCELL_X64_Y10_N9
\Add2~33\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~33_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~59_combout\)))) # (\comb~0_combout\ & (((\r.j\(4))))) ) + ( GND ) + ( \Add2~50\ ))
-- \Add2~34\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~59_combout\)))) # (\comb~0_combout\ & (((\r.j\(4))))) ) + ( GND ) + ( \Add2~50\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(4),
	datad => \ALT_INV_v~59_combout\,
	cin => \Add2~50\,
	sumout => \Add2~33_sumout\,
	cout => \Add2~34\);

-- Location: FF_X65_Y9_N53
\r.j[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[4]~feeder_combout\,
	asdata => \Add2~33_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(4));

-- Location: LABCELL_X64_Y10_N12
\Add2~45\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~45_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~62_combout\)))) # (\comb~0_combout\ & (((\r.j\(5))))) ) + ( \Add2~34\ ))
-- \Add2~46\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~62_combout\)))) # (\comb~0_combout\ & (((\r.j\(5))))) ) + ( \Add2~34\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(5),
	dataf => \ALT_INV_v~62_combout\,
	cin => \Add2~34\,
	sumout => \Add2~45_sumout\,
	cout => \Add2~46\);

-- Location: FF_X65_Y9_N44
\r.j[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[5]~feeder_combout\,
	asdata => \Add2~45_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(5));

-- Location: LABCELL_X64_Y10_N15
\Add2~41\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~41_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~65_combout\)))) # (\comb~0_combout\ & (((\r.j\(6))))) ) + ( \Add2~46\ ))
-- \Add2~42\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~65_combout\)))) # (\comb~0_combout\ & (((\r.j\(6))))) ) + ( \Add2~46\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(6),
	dataf => \ALT_INV_v~65_combout\,
	cin => \Add2~46\,
	sumout => \Add2~41_sumout\,
	cout => \Add2~42\);

-- Location: FF_X65_Y9_N35
\r.j[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[6]~feeder_combout\,
	asdata => \Add2~41_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(6));

-- Location: LABCELL_X64_Y10_N18
\Add2~37\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~37_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~68_combout\)))) # (\comb~0_combout\ & (((\r.j\(7))))) ) + ( GND ) + ( \Add2~42\ ))
-- \Add2~38\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~68_combout\)))) # (\comb~0_combout\ & (((\r.j\(7))))) ) + ( GND ) + ( \Add2~42\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(7),
	datad => \ALT_INV_v~68_combout\,
	cin => \Add2~42\,
	sumout => \Add2~37_sumout\,
	cout => \Add2~38\);

-- Location: FF_X65_Y9_N14
\r.j[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[7]~feeder_combout\,
	asdata => \Add2~37_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(7));

-- Location: LABCELL_X64_Y10_N21
\Add2~29\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~29_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~71_combout\)))) # (\comb~0_combout\ & (((\r.j\(8))))) ) + ( \Add2~38\ ))
-- \Add2~30\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~71_combout\)))) # (\comb~0_combout\ & (((\r.j\(8))))) ) + ( \Add2~38\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(8),
	dataf => \ALT_INV_v~71_combout\,
	cin => \Add2~38\,
	sumout => \Add2~29_sumout\,
	cout => \Add2~30\);

-- Location: FF_X63_Y9_N26
\r.j[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[8]~feeder_combout\,
	asdata => \Add2~29_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(8));

-- Location: LABCELL_X64_Y10_N24
\Add2~21\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~21_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~74_combout\)))) # (\comb~0_combout\ & (((\r.j\(9))))) ) + ( \Add2~30\ ))
-- \Add2~22\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~74_combout\)))) # (\comb~0_combout\ & (((\r.j\(9))))) ) + ( \Add2~30\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(9),
	dataf => \ALT_INV_v~74_combout\,
	cin => \Add2~30\,
	sumout => \Add2~21_sumout\,
	cout => \Add2~22\);

-- Location: FF_X63_Y9_N23
\r.j[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[9]~feeder_combout\,
	asdata => \Add2~21_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(9));

-- Location: LABCELL_X64_Y10_N27
\Add2~25\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~25_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~77_combout\)))) # (\comb~0_combout\ & (((\r.j\(10))))) ) + ( \Add2~22\ ))
-- \Add2~26\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~77_combout\)))) # (\comb~0_combout\ & (((\r.j\(10))))) ) + ( \Add2~22\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(10),
	dataf => \ALT_INV_v~77_combout\,
	cin => \Add2~22\,
	sumout => \Add2~25_sumout\,
	cout => \Add2~26\);

-- Location: FF_X63_Y9_N44
\r.j[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[10]~feeder_combout\,
	asdata => \Add2~25_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(10));

-- Location: LABCELL_X64_Y10_N30
\Add2~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~17_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~80_combout\)))) # (\comb~0_combout\ & (((\r.j\(11))))) ) + ( GND ) + ( \Add2~26\ ))
-- \Add2~18\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~80_combout\)))) # (\comb~0_combout\ & (((\r.j\(11))))) ) + ( GND ) + ( \Add2~26\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(11),
	datad => \ALT_INV_v~80_combout\,
	cin => \Add2~26\,
	sumout => \Add2~17_sumout\,
	cout => \Add2~18\);

-- Location: FF_X63_Y9_N8
\r.j[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[11]~feeder_combout\,
	asdata => \Add2~17_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(11));

-- Location: LABCELL_X64_Y10_N33
\Add2~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~13_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~83_combout\)))) # (\comb~0_combout\ & (((\r.j\(12))))) ) + ( \Add2~18\ ))
-- \Add2~14\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~83_combout\)))) # (\comb~0_combout\ & (((\r.j\(12))))) ) + ( \Add2~18\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(12),
	dataf => \ALT_INV_v~83_combout\,
	cin => \Add2~18\,
	sumout => \Add2~13_sumout\,
	cout => \Add2~14\);

-- Location: FF_X63_Y9_N38
\r.j[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[12]~feeder_combout\,
	asdata => \Add2~13_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(12));

-- Location: LABCELL_X64_Y10_N36
\Add2~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~9_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~86_combout\)))) # (\comb~0_combout\ & (((\r.j\(13))))) ) + ( \Add2~14\ ))
-- \Add2~10\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~86_combout\)))) # (\comb~0_combout\ & (((\r.j\(13))))) ) + ( \Add2~14\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(13),
	dataf => \ALT_INV_v~86_combout\,
	cin => \Add2~14\,
	sumout => \Add2~9_sumout\,
	cout => \Add2~10\);

-- Location: FF_X65_Y9_N56
\r.j[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[13]~feeder_combout\,
	asdata => \Add2~9_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(13));

-- Location: LABCELL_X64_Y10_N39
\Add2~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~5_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~89_combout\)))) # (\comb~0_combout\ & (((\r.j\(14))))) ) + ( \Add2~10\ ))
-- \Add2~6\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~89_combout\)))) # (\comb~0_combout\ & (((\r.j\(14))))) ) + ( \Add2~10\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(14),
	dataf => \ALT_INV_v~89_combout\,
	cin => \Add2~10\,
	sumout => \Add2~5_sumout\,
	cout => \Add2~6\);

-- Location: FF_X63_Y9_N5
\r.j[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.j[14]~feeder_combout\,
	asdata => \Add2~5_sumout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(14));

-- Location: LABCELL_X64_Y10_N42
\Add2~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~1_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~92_combout\)))) # (\comb~0_combout\ & (((\r.j\(15))))) ) + ( \Add2~6\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(15),
	dataf => \ALT_INV_v~92_combout\,
	cin => \Add2~6\,
	sumout => \Add2~1_sumout\);

-- Location: FF_X63_Y10_N50
\r.x1[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~148_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(15));

-- Location: LABCELL_X63_Y10_N48
\v~148\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~148_combout\ = ( \v~0_combout\ & ( (\comb~0_combout\ & \r.x1\(15)) ) ) # ( !\v~0_combout\ & ( (!\comb~0_combout\ & (\d.tile.x1[15]~input_o\ & (\d.clip_rect.x1[15]~input_o\))) # (\comb~0_combout\ & (((\r.x1\(15))))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001001010111000000100101011100000000010101010000000001010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~0_combout\,
	datab => \ALT_INV_d.tile.x1[15]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[15]~input_o\,
	datad => \ALT_INV_r.x1\(15),
	dataf => \ALT_INV_v~0_combout\,
	combout => \v~148_combout\);

-- Location: LABCELL_X62_Y7_N24
\LessThan6~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~0_combout\ = ( \d.tile.x1[12]~input_o\ & ( \d.clip_rect.x1[13]~input_o\ & ( (\d.clip_rect.x1[12]~input_o\ & (\d.tile.x1[13]~input_o\ & (!\d.clip_rect.x1[14]~input_o\ $ (\d.tile.x1[14]~input_o\)))) ) ) ) # ( !\d.tile.x1[12]~input_o\ & ( 
-- \d.clip_rect.x1[13]~input_o\ & ( (!\d.clip_rect.x1[12]~input_o\ & (\d.tile.x1[13]~input_o\ & (!\d.clip_rect.x1[14]~input_o\ $ (\d.tile.x1[14]~input_o\)))) ) ) ) # ( \d.tile.x1[12]~input_o\ & ( !\d.clip_rect.x1[13]~input_o\ & ( 
-- (\d.clip_rect.x1[12]~input_o\ & (!\d.tile.x1[13]~input_o\ & (!\d.clip_rect.x1[14]~input_o\ $ (\d.tile.x1[14]~input_o\)))) ) ) ) # ( !\d.tile.x1[12]~input_o\ & ( !\d.clip_rect.x1[13]~input_o\ & ( (!\d.clip_rect.x1[12]~input_o\ & (!\d.tile.x1[13]~input_o\ & 
-- (!\d.clip_rect.x1[14]~input_o\ $ (\d.tile.x1[14]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000000000100000010000000001000000001000000000100000010000000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[12]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[14]~input_o\,
	datac => \ALT_INV_d.tile.x1[13]~input_o\,
	datad => \ALT_INV_d.tile.x1[14]~input_o\,
	datae => \ALT_INV_d.tile.x1[12]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[13]~input_o\,
	combout => \LessThan6~0_combout\);

-- Location: LABCELL_X63_Y8_N36
\LessThan6~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~1_combout\ = ( \d.clip_rect.x1[11]~input_o\ & ( (\LessThan6~0_combout\ & (\d.tile.x1[11]~input_o\ & (!\d.tile.x1[10]~input_o\ $ (\d.clip_rect.x1[10]~input_o\)))) ) ) # ( !\d.clip_rect.x1[11]~input_o\ & ( (\LessThan6~0_combout\ & 
-- (!\d.tile.x1[11]~input_o\ & (!\d.tile.x1[10]~input_o\ $ (\d.clip_rect.x1[10]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100100000000000010010000000000000000000010010000000000001001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[10]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[10]~input_o\,
	datac => \ALT_INV_LessThan6~0_combout\,
	datad => \ALT_INV_d.tile.x1[11]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[11]~input_o\,
	combout => \LessThan6~1_combout\);

-- Location: LABCELL_X63_Y8_N3
\LessThan6~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~4_combout\ = ( \d.clip_rect.x1[1]~input_o\ & ( (!\d.tile.x1[1]~input_o\) # ((\d.clip_rect.x1[0]~input_o\ & !\d.tile.x1[0]~input_o\)) ) ) # ( !\d.clip_rect.x1[1]~input_o\ & ( (\d.clip_rect.x1[0]~input_o\ & (!\d.tile.x1[1]~input_o\ & 
-- !\d.tile.x1[0]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000000000000010100000000000011110101111100001111010111110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[0]~input_o\,
	datac => \ALT_INV_d.tile.x1[1]~input_o\,
	datad => \ALT_INV_d.tile.x1[0]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[1]~input_o\,
	combout => \LessThan6~4_combout\);

-- Location: LABCELL_X66_Y9_N42
\LessThan6~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~5_combout\ = ( \LessThan6~4_combout\ & ( (!\d.tile.x1[3]~input_o\ & ((!\d.tile.x1[2]~input_o\) # ((\d.clip_rect.x1[2]~input_o\) # (\d.clip_rect.x1[3]~input_o\)))) # (\d.tile.x1[3]~input_o\ & (\d.clip_rect.x1[3]~input_o\ & 
-- ((!\d.tile.x1[2]~input_o\) # (\d.clip_rect.x1[2]~input_o\)))) ) ) # ( !\LessThan6~4_combout\ & ( (!\d.tile.x1[3]~input_o\ & (((!\d.tile.x1[2]~input_o\ & \d.clip_rect.x1[2]~input_o\)) # (\d.clip_rect.x1[3]~input_o\))) # (\d.tile.x1[3]~input_o\ & 
-- (!\d.tile.x1[2]~input_o\ & (\d.clip_rect.x1[3]~input_o\ & \d.clip_rect.x1[2]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000110010001110000011001000111010001110110011111000111011001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[2]~input_o\,
	datab => \ALT_INV_d.tile.x1[3]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[3]~input_o\,
	datad => \ALT_INV_d.clip_rect.x1[2]~input_o\,
	dataf => \ALT_INV_LessThan6~4_combout\,
	combout => \LessThan6~5_combout\);

-- Location: LABCELL_X66_Y9_N48
\LessThan6~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~6_combout\ = ( \d.tile.x1[7]~input_o\ & ( (\d.clip_rect.x1[7]~input_o\ & (!\d.tile.x1[6]~input_o\ $ (\d.clip_rect.x1[6]~input_o\))) ) ) # ( !\d.tile.x1[7]~input_o\ & ( (!\d.clip_rect.x1[7]~input_o\ & (!\d.tile.x1[6]~input_o\ $ 
-- (\d.clip_rect.x1[6]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000010010000100100001001000010000100001001000010010000100100001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[6]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[7]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[6]~input_o\,
	dataf => \ALT_INV_d.tile.x1[7]~input_o\,
	combout => \LessThan6~6_combout\);

-- Location: LABCELL_X66_Y9_N51
\LessThan6~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~8_combout\ = ( \d.tile.x1[7]~input_o\ & ( (!\d.tile.x1[6]~input_o\ & (\d.clip_rect.x1[7]~input_o\ & \d.clip_rect.x1[6]~input_o\)) ) ) # ( !\d.tile.x1[7]~input_o\ & ( ((!\d.tile.x1[6]~input_o\ & \d.clip_rect.x1[6]~input_o\)) # 
-- (\d.clip_rect.x1[7]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001110111011001100111011101100000000001000100000000000100010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[6]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[7]~input_o\,
	datad => \ALT_INV_d.clip_rect.x1[6]~input_o\,
	dataf => \ALT_INV_d.tile.x1[7]~input_o\,
	combout => \LessThan6~8_combout\);

-- Location: LABCELL_X66_Y9_N0
\LessThan6~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~9_combout\ = ( \d.tile.x1[5]~input_o\ & ( \d.clip_rect.x1[5]~input_o\ & ( (!\LessThan6~8_combout\ & ((!\LessThan6~6_combout\) # ((!\d.clip_rect.x1[4]~input_o\) # (\d.tile.x1[4]~input_o\)))) ) ) ) # ( !\d.tile.x1[5]~input_o\ & ( 
-- \d.clip_rect.x1[5]~input_o\ & ( (!\LessThan6~6_combout\ & !\LessThan6~8_combout\) ) ) ) # ( \d.tile.x1[5]~input_o\ & ( !\d.clip_rect.x1[5]~input_o\ & ( !\LessThan6~8_combout\ ) ) ) # ( !\d.tile.x1[5]~input_o\ & ( !\d.clip_rect.x1[5]~input_o\ & ( 
-- (!\LessThan6~8_combout\ & ((!\LessThan6~6_combout\) # ((!\d.clip_rect.x1[4]~input_o\) # (\d.tile.x1[4]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111000010110000111100001111000010100000101000001111000010110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan6~6_combout\,
	datab => \ALT_INV_d.tile.x1[4]~input_o\,
	datac => \ALT_INV_LessThan6~8_combout\,
	datad => \ALT_INV_d.clip_rect.x1[4]~input_o\,
	datae => \ALT_INV_d.tile.x1[5]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[5]~input_o\,
	combout => \LessThan6~9_combout\);

-- Location: LABCELL_X66_Y9_N45
\LessThan6~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~2_combout\ = ( \d.clip_rect.x1[9]~input_o\ & ( !\d.tile.x1[9]~input_o\ ) ) # ( !\d.clip_rect.x1[9]~input_o\ & ( \d.tile.x1[9]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_d.tile.x1[9]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[9]~input_o\,
	combout => \LessThan6~2_combout\);

-- Location: LABCELL_X66_Y7_N51
\LessThan6~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~3_combout\ = ( \d.tile.x1[8]~input_o\ & ( !\d.clip_rect.x1[8]~input_o\ ) ) # ( !\d.tile.x1[8]~input_o\ & ( \d.clip_rect.x1[8]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010110101010101010101010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[8]~input_o\,
	dataf => \ALT_INV_d.tile.x1[8]~input_o\,
	combout => \LessThan6~3_combout\);

-- Location: LABCELL_X66_Y9_N18
\LessThan6~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~7_combout\ = ( \d.clip_rect.x1[4]~input_o\ & ( \d.clip_rect.x1[5]~input_o\ & ( (\LessThan6~6_combout\ & (\d.tile.x1[4]~input_o\ & \d.tile.x1[5]~input_o\)) ) ) ) # ( !\d.clip_rect.x1[4]~input_o\ & ( \d.clip_rect.x1[5]~input_o\ & ( 
-- (\LessThan6~6_combout\ & (!\d.tile.x1[4]~input_o\ & \d.tile.x1[5]~input_o\)) ) ) ) # ( \d.clip_rect.x1[4]~input_o\ & ( !\d.clip_rect.x1[5]~input_o\ & ( (\LessThan6~6_combout\ & (\d.tile.x1[4]~input_o\ & !\d.tile.x1[5]~input_o\)) ) ) ) # ( 
-- !\d.clip_rect.x1[4]~input_o\ & ( !\d.clip_rect.x1[5]~input_o\ & ( (\LessThan6~6_combout\ & (!\d.tile.x1[4]~input_o\ & !\d.tile.x1[5]~input_o\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000001000000000100000001000000000100000001000000000100000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan6~6_combout\,
	datab => \ALT_INV_d.tile.x1[4]~input_o\,
	datac => \ALT_INV_d.tile.x1[5]~input_o\,
	datae => \ALT_INV_d.clip_rect.x1[4]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[5]~input_o\,
	combout => \LessThan6~7_combout\);

-- Location: LABCELL_X66_Y9_N30
\LessThan6~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~10_combout\ = ( !\LessThan6~3_combout\ & ( \LessThan6~7_combout\ & ( (\LessThan6~1_combout\ & (!\LessThan6~2_combout\ & ((!\LessThan6~9_combout\) # (\LessThan6~5_combout\)))) ) ) ) # ( !\LessThan6~3_combout\ & ( !\LessThan6~7_combout\ & ( 
-- (\LessThan6~1_combout\ & (!\LessThan6~9_combout\ & !\LessThan6~2_combout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000000000000000000000000000001010001000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan6~1_combout\,
	datab => \ALT_INV_LessThan6~5_combout\,
	datac => \ALT_INV_LessThan6~9_combout\,
	datad => \ALT_INV_LessThan6~2_combout\,
	datae => \ALT_INV_LessThan6~3_combout\,
	dataf => \ALT_INV_LessThan6~7_combout\,
	combout => \LessThan6~10_combout\);

-- Location: LABCELL_X62_Y7_N42
\LessThan6~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~11_combout\ = ( \d.tile.x1[12]~input_o\ & ( \d.clip_rect.x1[13]~input_o\ & ( (!\d.clip_rect.x1[14]~input_o\ & (!\d.tile.x1[13]~input_o\ & !\d.tile.x1[14]~input_o\)) # (\d.clip_rect.x1[14]~input_o\ & ((!\d.tile.x1[13]~input_o\) # 
-- (!\d.tile.x1[14]~input_o\))) ) ) ) # ( !\d.tile.x1[12]~input_o\ & ( \d.clip_rect.x1[13]~input_o\ & ( (!\d.clip_rect.x1[14]~input_o\ & (!\d.tile.x1[14]~input_o\ & ((!\d.tile.x1[13]~input_o\) # (\d.clip_rect.x1[12]~input_o\)))) # 
-- (\d.clip_rect.x1[14]~input_o\ & (((!\d.tile.x1[13]~input_o\) # (!\d.tile.x1[14]~input_o\)) # (\d.clip_rect.x1[12]~input_o\))) ) ) ) # ( \d.tile.x1[12]~input_o\ & ( !\d.clip_rect.x1[13]~input_o\ & ( (\d.clip_rect.x1[14]~input_o\ & !\d.tile.x1[14]~input_o\) 
-- ) ) ) # ( !\d.tile.x1[12]~input_o\ & ( !\d.clip_rect.x1[13]~input_o\ & ( (!\d.clip_rect.x1[14]~input_o\ & (\d.clip_rect.x1[12]~input_o\ & (!\d.tile.x1[13]~input_o\ & !\d.tile.x1[14]~input_o\))) # (\d.clip_rect.x1[14]~input_o\ & ((!\d.tile.x1[14]~input_o\) 
-- # ((\d.clip_rect.x1[12]~input_o\ & !\d.tile.x1[13]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111001100010000001100110000000011110111001100011111001100110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[12]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[14]~input_o\,
	datac => \ALT_INV_d.tile.x1[13]~input_o\,
	datad => \ALT_INV_d.tile.x1[14]~input_o\,
	datae => \ALT_INV_d.tile.x1[12]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[13]~input_o\,
	combout => \LessThan6~11_combout\);

-- Location: LABCELL_X63_Y8_N30
\LessThan6~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~12_combout\ = ( \d.tile.x1[11]~input_o\ & ( \d.tile.x1[10]~input_o\ & ( !\LessThan6~11_combout\ ) ) ) # ( !\d.tile.x1[11]~input_o\ & ( \d.tile.x1[10]~input_o\ & ( (!\LessThan6~11_combout\ & ((!\LessThan6~0_combout\) # 
-- (!\d.clip_rect.x1[11]~input_o\))) ) ) ) # ( \d.tile.x1[11]~input_o\ & ( !\d.tile.x1[10]~input_o\ & ( (!\LessThan6~11_combout\ & ((!\d.clip_rect.x1[10]~input_o\) # ((!\LessThan6~0_combout\) # (!\d.clip_rect.x1[11]~input_o\)))) ) ) ) # ( 
-- !\d.tile.x1[11]~input_o\ & ( !\d.tile.x1[10]~input_o\ & ( (!\LessThan6~11_combout\ & ((!\LessThan6~0_combout\) # ((!\d.clip_rect.x1[10]~input_o\ & !\d.clip_rect.x1[11]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010100010100000101010101010100010101010101000001010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan6~11_combout\,
	datab => \ALT_INV_d.clip_rect.x1[10]~input_o\,
	datac => \ALT_INV_LessThan6~0_combout\,
	datad => \ALT_INV_d.clip_rect.x1[11]~input_o\,
	datae => \ALT_INV_d.tile.x1[11]~input_o\,
	dataf => \ALT_INV_d.tile.x1[10]~input_o\,
	combout => \LessThan6~12_combout\);

-- Location: LABCELL_X63_Y8_N18
\LessThan6~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~13_combout\ = ( \d.tile.x1[8]~input_o\ & ( \d.clip_rect.x1[8]~input_o\ & ( (\LessThan6~12_combout\ & ((!\LessThan6~1_combout\) # ((!\d.clip_rect.x1[9]~input_o\) # (\d.tile.x1[9]~input_o\)))) ) ) ) # ( !\d.tile.x1[8]~input_o\ & ( 
-- \d.clip_rect.x1[8]~input_o\ & ( (\LessThan6~12_combout\ & ((!\LessThan6~1_combout\) # ((\d.tile.x1[9]~input_o\ & !\d.clip_rect.x1[9]~input_o\)))) ) ) ) # ( \d.tile.x1[8]~input_o\ & ( !\d.clip_rect.x1[8]~input_o\ & ( (\LessThan6~12_combout\ & 
-- ((!\LessThan6~1_combout\) # ((!\d.clip_rect.x1[9]~input_o\) # (\d.tile.x1[9]~input_o\)))) ) ) ) # ( !\d.tile.x1[8]~input_o\ & ( !\d.clip_rect.x1[8]~input_o\ & ( (\LessThan6~12_combout\ & ((!\LessThan6~1_combout\) # ((!\d.clip_rect.x1[9]~input_o\) # 
-- (\d.tile.x1[9]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111011000000001111101100000000101110100000000011111011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan6~1_combout\,
	datab => \ALT_INV_d.tile.x1[9]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[9]~input_o\,
	datad => \ALT_INV_LessThan6~12_combout\,
	datae => \ALT_INV_d.tile.x1[8]~input_o\,
	dataf => \ALT_INV_d.clip_rect.x1[8]~input_o\,
	combout => \LessThan6~13_combout\);

-- Location: LABCELL_X63_Y8_N0
\LessThan6~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan6~14_combout\ = ( \LessThan6~13_combout\ & ( (!\d.clip_rect.x1[15]~input_o\ & ((!\LessThan6~10_combout\) # (\d.tile.x1[15]~input_o\))) # (\d.clip_rect.x1[15]~input_o\ & (!\LessThan6~10_combout\ & \d.tile.x1[15]~input_o\)) ) ) # ( 
-- !\LessThan6~13_combout\ & ( (!\d.clip_rect.x1[15]~input_o\ & \d.tile.x1[15]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011001100000000001100110011000000111111001100000011111100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_d.clip_rect.x1[15]~input_o\,
	datac => \ALT_INV_LessThan6~10_combout\,
	datad => \ALT_INV_d.tile.x1[15]~input_o\,
	dataf => \ALT_INV_LessThan6~13_combout\,
	combout => \LessThan6~14_combout\);

-- Location: FF_X66_Y10_N2
\r.x1[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~107_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(3));

-- Location: LABCELL_X66_Y10_N0
\v~107\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~107_combout\ = ( \r.x1\(3) & ( \comb~0_combout\ ) ) # ( \r.x1\(3) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan6~14_combout\ & ((\d.tile.x1[3]~input_o\))) # (\LessThan6~14_combout\ & (\d.clip_rect.x1[3]~input_o\)))) ) ) ) # ( !\r.x1\(3) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan6~14_combout\ & ((\d.tile.x1[3]~input_o\))) # (\LessThan6~14_combout\ & (\d.clip_rect.x1[3]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001010001010000000101000101000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_LessThan6~14_combout\,
	datac => \ALT_INV_d.clip_rect.x1[3]~input_o\,
	datad => \ALT_INV_d.tile.x1[3]~input_o\,
	datae => \ALT_INV_r.x1\(3),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~107_combout\);

-- Location: FF_X66_Y10_N20
\r.x1[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~108_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(2));

-- Location: LABCELL_X66_Y10_N18
\v~108\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~108_combout\ = ( \r.x1\(2) & ( \comb~0_combout\ ) ) # ( \r.x1\(2) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan6~14_combout\ & (\d.tile.x1[2]~input_o\)) # (\LessThan6~14_combout\ & ((\d.clip_rect.x1[2]~input_o\))))) ) ) ) # ( !\r.x1\(2) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan6~14_combout\ & (\d.tile.x1[2]~input_o\)) # (\LessThan6~14_combout\ & ((\d.clip_rect.x1[2]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000000110000010100000011000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[2]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[2]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_LessThan6~14_combout\,
	datae => \ALT_INV_r.x1\(2),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~108_combout\);

-- Location: LABCELL_X63_Y10_N6
\v~46\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~46_combout\ = ( \d.clip_rect.x0[0]~input_o\ & ( \d.tile.x0[0]~input_o\ ) ) # ( !\d.clip_rect.x0[0]~input_o\ & ( \d.tile.x0[0]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & (((!\LessThan5~13_combout\) # (\d.tile.x0[15]~input_o\)) # 
-- (\LessThan5~10_combout\))) # (\d.clip_rect.x0[15]~input_o\ & (\d.tile.x0[15]~input_o\ & ((!\LessThan5~13_combout\) # (\LessThan5~10_combout\)))) ) ) ) # ( \d.clip_rect.x0[0]~input_o\ & ( !\d.tile.x0[0]~input_o\ & ( (!\d.clip_rect.x0[15]~input_o\ & 
-- (!\LessThan5~10_combout\ & (\LessThan5~13_combout\ & !\d.tile.x0[15]~input_o\))) # (\d.clip_rect.x0[15]~input_o\ & ((!\d.tile.x0[15]~input_o\) # ((!\LessThan5~10_combout\ & \LessThan5~13_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010111010000010010100010111110111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x0[15]~input_o\,
	datab => \ALT_INV_LessThan5~10_combout\,
	datac => \ALT_INV_LessThan5~13_combout\,
	datad => \ALT_INV_d.tile.x0[15]~input_o\,
	datae => \ALT_INV_d.clip_rect.x0[0]~input_o\,
	dataf => \ALT_INV_d.tile.x0[0]~input_o\,
	combout => \v~46_combout\);

-- Location: FF_X63_Y8_N25
\r.x1[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~100_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(9));

-- Location: LABCELL_X63_Y8_N9
\v~100\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~100_combout\ = ( \LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(9) ) ) ) # ( !\LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(9) ) ) ) # ( \LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (\d.clip_rect.x1[9]~input_o\ & !\v~0_combout\) ) 
-- ) ) # ( !\LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (\d.tile.x1[9]~input_o\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100000000010101010000000000110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[9]~input_o\,
	datab => \ALT_INV_r.x1\(9),
	datac => \ALT_INV_d.tile.x1[9]~input_o\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_LessThan6~14_combout\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~100_combout\);

-- Location: FF_X64_Y9_N49
\r.x1[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~101_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(10));

-- Location: LABCELL_X64_Y9_N51
\v~101\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~101_combout\ = ( \LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(10) ) ) ) # ( !\LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(10) ) ) ) # ( \LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \d.clip_rect.x1[10]~input_o\) 
-- ) ) ) # ( !\LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \d.tile.x1[10]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010000000001010101000110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_r.x1\(10),
	datac => \ALT_INV_d.tile.x1[10]~input_o\,
	datad => \ALT_INV_d.clip_rect.x1[10]~input_o\,
	datae => \ALT_INV_LessThan6~14_combout\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~101_combout\);

-- Location: LABCELL_X64_Y9_N30
\LessThan8~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~2_combout\ = ( \Add2~25_sumout\ & ( !\v~101_combout\ ) ) # ( !\Add2~25_sumout\ & ( \v~101_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~101_combout\,
	dataf => \ALT_INV_Add2~25_sumout\,
	combout => \LessThan8~2_combout\);

-- Location: FF_X63_Y8_N35
\r.x1[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~99_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(11));

-- Location: LABCELL_X63_Y8_N51
\v~99\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~99_combout\ = ( \LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(11) ) ) ) # ( !\LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(11) ) ) ) # ( \LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \d.clip_rect.x1[11]~input_o\) 
-- ) ) ) # ( !\LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \d.tile.x1[11]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010001000100010001000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.clip_rect.x1[11]~input_o\,
	datac => \ALT_INV_d.tile.x1[11]~input_o\,
	datad => \ALT_INV_r.x1\(11),
	datae => \ALT_INV_LessThan6~14_combout\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~99_combout\);

-- Location: LABCELL_X64_Y9_N33
\LessThan8~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~1_combout\ = ( \Add2~17_sumout\ & ( !\v~99_combout\ ) ) # ( !\Add2~17_sumout\ & ( \v~99_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111111111111000000001111111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~99_combout\,
	dataf => \ALT_INV_Add2~17_sumout\,
	combout => \LessThan8~1_combout\);

-- Location: FF_X63_Y8_N22
\r.x1[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~102_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(8));

-- Location: LABCELL_X63_Y8_N24
\v~102\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~102_combout\ = ( \LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(8) ) ) ) # ( !\LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(8) ) ) ) # ( \LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (\d.clip_rect.x1[8]~input_o\ & !\v~0_combout\) ) 
-- ) ) # ( !\LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (\d.tile.x1[8]~input_o\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000000110000010100000101000000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[8]~input_o\,
	datab => \ALT_INV_d.tile.x1[8]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_r.x1\(8),
	datae => \ALT_INV_LessThan6~14_combout\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~102_combout\);

-- Location: LABCELL_X64_Y9_N3
\LessThan8~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~4_combout\ = ( \Add2~29_sumout\ & ( !\v~102_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111000000001111111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_v~102_combout\,
	dataf => \ALT_INV_Add2~29_sumout\,
	combout => \LessThan8~4_combout\);

-- Location: FF_X63_Y8_N17
\r.x1[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~98_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(12));

-- Location: LABCELL_X63_Y8_N57
\v~98\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~98_combout\ = ( \LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(12) ) ) ) # ( !\LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(12) ) ) ) # ( \LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \d.clip_rect.x1[12]~input_o\) 
-- ) ) ) # ( !\LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & \d.tile.x1[12]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010101010000010100000101000110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_r.x1\(12),
	datac => \ALT_INV_d.clip_rect.x1[12]~input_o\,
	datad => \ALT_INV_d.tile.x1[12]~input_o\,
	datae => \ALT_INV_LessThan6~14_combout\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~98_combout\);

-- Location: FF_X66_Y9_N14
\r.x1[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~97_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(13));

-- Location: MLABCELL_X65_Y9_N0
\v~97\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~97_combout\ = ( \LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(13) ) ) ) # ( !\LessThan6~14_combout\ & ( \comb~0_combout\ & ( \r.x1\(13) ) ) ) # ( \LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (\d.clip_rect.x1[13]~input_o\ & !\v~0_combout\) 
-- ) ) ) # ( !\LessThan6~14_combout\ & ( !\comb~0_combout\ & ( (\d.tile.x1[13]~input_o\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010100000000000011110000000000110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[13]~input_o\,
	datab => \ALT_INV_r.x1\(13),
	datac => \ALT_INV_d.clip_rect.x1[13]~input_o\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_LessThan6~14_combout\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~97_combout\);

-- Location: FF_X64_Y9_N22
\r.x1[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~96_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(14));

-- Location: LABCELL_X66_Y9_N15
\v~96\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~96_combout\ = ( \d.clip_rect.x1[14]~input_o\ & ( \r.x1\(14) & ( ((!\v~0_combout\ & ((\LessThan6~14_combout\) # (\d.tile.x1[14]~input_o\)))) # (\comb~0_combout\) ) ) ) # ( !\d.clip_rect.x1[14]~input_o\ & ( \r.x1\(14) & ( ((!\v~0_combout\ & 
-- (\d.tile.x1[14]~input_o\ & !\LessThan6~14_combout\))) # (\comb~0_combout\) ) ) ) # ( \d.clip_rect.x1[14]~input_o\ & ( !\r.x1\(14) & ( (!\v~0_combout\ & (!\comb~0_combout\ & ((\LessThan6~14_combout\) # (\d.tile.x1[14]~input_o\)))) ) ) ) # ( 
-- !\d.clip_rect.x1[14]~input_o\ & ( !\r.x1\(14) & ( (!\v~0_combout\ & (\d.tile.x1[14]~input_o\ & (!\LessThan6~14_combout\ & !\comb~0_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010000000000000001010100000000000100000111111110010101011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.tile.x1[14]~input_o\,
	datac => \ALT_INV_LessThan6~14_combout\,
	datad => \ALT_INV_comb~0_combout\,
	datae => \ALT_INV_d.clip_rect.x1[14]~input_o\,
	dataf => \ALT_INV_r.x1\(14),
	combout => \v~96_combout\);

-- Location: LABCELL_X64_Y9_N42
\LessThan8~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~0_combout\ = ( \Add2~5_sumout\ & ( \Add2~9_sumout\ & ( (\v~97_combout\ & (\v~96_combout\ & (!\v~98_combout\ $ (\Add2~13_sumout\)))) ) ) ) # ( !\Add2~5_sumout\ & ( \Add2~9_sumout\ & ( (\v~97_combout\ & (!\v~96_combout\ & (!\v~98_combout\ $ 
-- (\Add2~13_sumout\)))) ) ) ) # ( \Add2~5_sumout\ & ( !\Add2~9_sumout\ & ( (!\v~97_combout\ & (\v~96_combout\ & (!\v~98_combout\ $ (\Add2~13_sumout\)))) ) ) ) # ( !\Add2~5_sumout\ & ( !\Add2~9_sumout\ & ( (!\v~97_combout\ & (!\v~96_combout\ & 
-- (!\v~98_combout\ $ (\Add2~13_sumout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000000001000000000010000000010000100000000100000000001000000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~98_combout\,
	datab => \ALT_INV_v~97_combout\,
	datac => \ALT_INV_v~96_combout\,
	datad => \ALT_INV_Add2~13_sumout\,
	datae => \ALT_INV_Add2~5_sumout\,
	dataf => \ALT_INV_Add2~9_sumout\,
	combout => \LessThan8~0_combout\);

-- Location: LABCELL_X64_Y9_N6
\LessThan8~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~5_combout\ = ( \LessThan8~4_combout\ & ( \LessThan8~0_combout\ & ( (!\LessThan8~2_combout\ & (!\LessThan8~1_combout\ & ((!\v~100_combout\) # (\Add2~21_sumout\)))) ) ) ) # ( !\LessThan8~4_combout\ & ( \LessThan8~0_combout\ & ( (!\v~100_combout\ 
-- & (!\LessThan8~2_combout\ & (!\LessThan8~1_combout\ & \Add2~21_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000100000001000000011000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~100_combout\,
	datab => \ALT_INV_LessThan8~2_combout\,
	datac => \ALT_INV_LessThan8~1_combout\,
	datad => \ALT_INV_Add2~21_sumout\,
	datae => \ALT_INV_LessThan8~4_combout\,
	dataf => \ALT_INV_LessThan8~0_combout\,
	combout => \LessThan8~5_combout\);

-- Location: LABCELL_X64_Y9_N27
\LessThan8~15\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~15_combout\ = ( \LessThan8~11_combout\ & ( \LessThan8~0_combout\ & ( (!\LessThan8~2_combout\ & (!\LessThan8~1_combout\ & (!\v~100_combout\ $ (\Add2~21_sumout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000001001000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~100_combout\,
	datab => \ALT_INV_Add2~21_sumout\,
	datac => \ALT_INV_LessThan8~2_combout\,
	datad => \ALT_INV_LessThan8~1_combout\,
	datae => \ALT_INV_LessThan8~11_combout\,
	dataf => \ALT_INV_LessThan8~0_combout\,
	combout => \LessThan8~15_combout\);

-- Location: LABCELL_X64_Y9_N54
\LessThan8~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~12_combout\ = ( \Add2~5_sumout\ & ( \Add2~9_sumout\ & ( (!\v~97_combout\) # ((!\v~96_combout\) # ((!\v~98_combout\ & \Add2~13_sumout\))) ) ) ) # ( !\Add2~5_sumout\ & ( \Add2~9_sumout\ & ( (!\v~96_combout\ & ((!\v~97_combout\) # 
-- ((!\v~98_combout\ & \Add2~13_sumout\)))) ) ) ) # ( \Add2~5_sumout\ & ( !\Add2~9_sumout\ & ( (!\v~96_combout\) # ((!\v~98_combout\ & (!\v~97_combout\ & \Add2~13_sumout\))) ) ) ) # ( !\Add2~5_sumout\ & ( !\Add2~9_sumout\ & ( (!\v~98_combout\ & 
-- (!\v~97_combout\ & (!\v~96_combout\ & \Add2~13_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010000000111100001111100011000000111000001111110011111110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~98_combout\,
	datab => \ALT_INV_v~97_combout\,
	datac => \ALT_INV_v~96_combout\,
	datad => \ALT_INV_Add2~13_sumout\,
	datae => \ALT_INV_Add2~5_sumout\,
	dataf => \ALT_INV_Add2~9_sumout\,
	combout => \LessThan8~12_combout\);

-- Location: LABCELL_X64_Y9_N12
\LessThan8~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~13_combout\ = ( !\LessThan8~12_combout\ & ( \LessThan8~0_combout\ & ( (!\Add2~17_sumout\ & (((!\Add2~25_sumout\) # (\v~99_combout\)) # (\v~101_combout\))) # (\Add2~17_sumout\ & (\v~99_combout\ & ((!\Add2~25_sumout\) # (\v~101_combout\)))) ) ) ) 
-- # ( !\LessThan8~12_combout\ & ( !\LessThan8~0_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111000000000000000011001111010011010000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~101_combout\,
	datab => \ALT_INV_Add2~17_sumout\,
	datac => \ALT_INV_v~99_combout\,
	datad => \ALT_INV_Add2~25_sumout\,
	datae => \ALT_INV_LessThan8~12_combout\,
	dataf => \ALT_INV_LessThan8~0_combout\,
	combout => \LessThan8~13_combout\);

-- Location: LABCELL_X64_Y9_N18
\v~131\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~131_combout\ = ( \LessThan8~15_combout\ & ( \LessThan8~13_combout\ & ( (\v~47_combout\ & (\v~148_combout\ & !\Add2~1_sumout\)) ) ) ) # ( !\LessThan8~15_combout\ & ( \LessThan8~13_combout\ & ( (\v~47_combout\ & ((!\v~148_combout\ & (!\Add2~1_sumout\ & 
-- !\LessThan8~5_combout\)) # (\v~148_combout\ & ((!\Add2~1_sumout\) # (!\LessThan8~5_combout\))))) ) ) ) # ( \LessThan8~15_combout\ & ( !\LessThan8~13_combout\ & ( (\v~47_combout\ & (\v~148_combout\ & !\Add2~1_sumout\)) ) ) ) # ( !\LessThan8~15_combout\ & ( 
-- !\LessThan8~13_combout\ & ( (\v~47_combout\ & (\v~148_combout\ & !\Add2~1_sumout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000000010000000100000001000001010001000100000001000000010000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~47_combout\,
	datab => \ALT_INV_v~148_combout\,
	datac => \ALT_INV_Add2~1_sumout\,
	datad => \ALT_INV_LessThan8~5_combout\,
	datae => \ALT_INV_LessThan8~15_combout\,
	dataf => \ALT_INV_LessThan8~13_combout\,
	combout => \v~131_combout\);

-- Location: FF_X64_Y9_N20
\r.j[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~131_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.j\(0));

-- Location: LABCELL_X66_Y10_N51
\v~47\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~47_combout\ = ( \r.j\(0) & ( \r.end_tile~q\ ) ) # ( \r.j\(0) & ( !\r.end_tile~q\ & ( ((!\comb~3_combout\ & (\v~46_combout\ & \comb~4_combout\))) # (\r.generate_quads~q\) ) ) ) # ( !\r.j\(0) & ( !\r.end_tile~q\ & ( (!\comb~3_combout\ & 
-- (!\r.generate_quads~q\ & (\v~46_combout\ & \comb~4_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000001000001100110011101100000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~3_combout\,
	datab => \ALT_INV_r.generate_quads~q\,
	datac => \ALT_INV_v~46_combout\,
	datad => \ALT_INV_comb~4_combout\,
	datae => \ALT_INV_r.j\(0),
	dataf => \ALT_INV_r.end_tile~q\,
	combout => \v~47_combout\);

-- Location: FF_X66_Y10_N38
\r.x1[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~109_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(1));

-- Location: LABCELL_X66_Y10_N39
\v~109\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~109_combout\ = ( \d.clip_rect.x1[1]~input_o\ & ( \comb~0_combout\ & ( \r.x1\(1) ) ) ) # ( !\d.clip_rect.x1[1]~input_o\ & ( \comb~0_combout\ & ( \r.x1\(1) ) ) ) # ( \d.clip_rect.x1[1]~input_o\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & 
-- ((\LessThan6~14_combout\) # (\d.tile.x1[1]~input_o\))) ) ) ) # ( !\d.clip_rect.x1[1]~input_o\ & ( !\comb~0_combout\ & ( (!\v~0_combout\ & (\d.tile.x1[1]~input_o\ & !\LessThan6~14_combout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010000000100000001010100010101000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.tile.x1[1]~input_o\,
	datac => \ALT_INV_LessThan6~14_combout\,
	datad => \ALT_INV_r.x1\(1),
	datae => \ALT_INV_d.clip_rect.x1[1]~input_o\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~109_combout\);

-- Location: LABCELL_X63_Y8_N12
\v~110\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~110_combout\ = ( \d.tile.x1[0]~input_o\ & ( \LessThan6~10_combout\ & ( ((!\d.tile.x1[15]~input_o\) # (\d.clip_rect.x1[0]~input_o\)) # (\d.clip_rect.x1[15]~input_o\) ) ) ) # ( !\d.tile.x1[0]~input_o\ & ( \LessThan6~10_combout\ & ( 
-- (!\d.clip_rect.x1[15]~input_o\ & (\d.clip_rect.x1[0]~input_o\ & \d.tile.x1[15]~input_o\)) ) ) ) # ( \d.tile.x1[0]~input_o\ & ( !\LessThan6~10_combout\ & ( ((!\LessThan6~13_combout\ & ((!\d.tile.x1[15]~input_o\) # (\d.clip_rect.x1[15]~input_o\))) # 
-- (\LessThan6~13_combout\ & (\d.clip_rect.x1[15]~input_o\ & !\d.tile.x1[15]~input_o\))) # (\d.clip_rect.x1[0]~input_o\) ) ) ) # ( !\d.tile.x1[0]~input_o\ & ( !\LessThan6~10_combout\ & ( (\d.clip_rect.x1[0]~input_o\ & ((!\LessThan6~13_combout\ & 
-- (!\d.clip_rect.x1[15]~input_o\ & \d.tile.x1[15]~input_o\)) # (\LessThan6~13_combout\ & ((!\d.clip_rect.x1[15]~input_o\) # (\d.tile.x1[15]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000010000001101101111110010111100000000000011001111111100111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan6~13_combout\,
	datab => \ALT_INV_d.clip_rect.x1[15]~input_o\,
	datac => \ALT_INV_d.clip_rect.x1[0]~input_o\,
	datad => \ALT_INV_d.tile.x1[15]~input_o\,
	datae => \ALT_INV_d.tile.x1[0]~input_o\,
	dataf => \ALT_INV_LessThan6~10_combout\,
	combout => \v~110_combout\);

-- Location: FF_X63_Y10_N20
\r.x1[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~111_combout\,
	sclr => \reset~input_o\,
	sload => VCC,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(0));

-- Location: LABCELL_X63_Y10_N21
\v~111\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~111_combout\ = ( \r.end_tile~q\ & ( \r.x1\(0) ) ) # ( !\r.end_tile~q\ & ( \r.x1\(0) & ( ((\v~110_combout\ & (\comb~4_combout\ & !\comb~3_combout\))) # (\r.generate_quads~q\) ) ) ) # ( !\r.end_tile~q\ & ( !\r.x1\(0) & ( (\v~110_combout\ & 
-- (\comb~4_combout\ & (!\comb~3_combout\ & !\r.generate_quads~q\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000000000000000000000000000000010000111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~110_combout\,
	datab => \ALT_INV_comb~4_combout\,
	datac => \ALT_INV_comb~3_combout\,
	datad => \ALT_INV_r.generate_quads~q\,
	datae => \ALT_INV_r.end_tile~q\,
	dataf => \ALT_INV_r.x1\(0),
	combout => \v~111_combout\);

-- Location: MLABCELL_X65_Y10_N54
\LessThan8~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~8_combout\ = ( \Add2~57_sumout\ & ( (!\v~109_combout\) # ((\v~47_combout\ & !\v~111_combout\)) ) ) # ( !\Add2~57_sumout\ & ( (\v~47_combout\ & (!\v~109_combout\ & !\v~111_combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000000000000010100000000000011110101111100001111010111110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~47_combout\,
	datac => \ALT_INV_v~109_combout\,
	datad => \ALT_INV_v~111_combout\,
	dataf => \ALT_INV_Add2~57_sumout\,
	combout => \LessThan8~8_combout\);

-- Location: MLABCELL_X65_Y10_N42
\LessThan8~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~9_combout\ = ( \Add2~53_sumout\ & ( (!\v~107_combout\ & ((!\v~108_combout\) # ((\LessThan8~8_combout\) # (\Add2~49_sumout\)))) # (\v~107_combout\ & (\Add2~49_sumout\ & ((!\v~108_combout\) # (\LessThan8~8_combout\)))) ) ) # ( !\Add2~53_sumout\ & 
-- ( (!\v~107_combout\ & (((!\v~108_combout\ & \LessThan8~8_combout\)) # (\Add2~49_sumout\))) # (\v~107_combout\ & (!\v~108_combout\ & (\Add2~49_sumout\ & \LessThan8~8_combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101010001110000010101000111010001110101011111000111010101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~107_combout\,
	datab => \ALT_INV_v~108_combout\,
	datac => \ALT_INV_Add2~49_sumout\,
	datad => \ALT_INV_LessThan8~8_combout\,
	dataf => \ALT_INV_Add2~53_sumout\,
	combout => \LessThan8~9_combout\);

-- Location: FF_X66_Y9_N56
\r.x1[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~103_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(4));

-- Location: LABCELL_X66_Y9_N54
\v~103\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~103_combout\ = ( \r.x1\(4) & ( \LessThan6~14_combout\ & ( ((!\v~0_combout\ & \d.clip_rect.x1[4]~input_o\)) # (\comb~0_combout\) ) ) ) # ( !\r.x1\(4) & ( \LessThan6~14_combout\ & ( (!\v~0_combout\ & (!\comb~0_combout\ & \d.clip_rect.x1[4]~input_o\)) ) ) 
-- ) # ( \r.x1\(4) & ( !\LessThan6~14_combout\ & ( ((!\v~0_combout\ & \d.tile.x1[4]~input_o\)) # (\comb~0_combout\) ) ) ) # ( !\r.x1\(4) & ( !\LessThan6~14_combout\ & ( (!\v~0_combout\ & (\d.tile.x1[4]~input_o\ & !\comb~0_combout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010000000100000001011110010111100000000101000000000111110101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_d.tile.x1[4]~input_o\,
	datac => \ALT_INV_comb~0_combout\,
	datad => \ALT_INV_d.clip_rect.x1[4]~input_o\,
	datae => \ALT_INV_r.x1\(4),
	dataf => \ALT_INV_LessThan6~14_combout\,
	combout => \v~103_combout\);

-- Location: LABCELL_X64_Y10_N54
\LessThan8~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~6_combout\ = ( \v~102_combout\ & ( !\Add2~29_sumout\ ) ) # ( !\v~102_combout\ & ( \Add2~29_sumout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_Add2~29_sumout\,
	dataf => \ALT_INV_v~102_combout\,
	combout => \LessThan8~6_combout\);

-- Location: FF_X66_Y9_N8
\r.x1[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~105_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(6));

-- Location: LABCELL_X66_Y9_N6
\v~105\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~105_combout\ = ( \r.x1\(6) & ( \d.tile.x1[6]~input_o\ & ( ((!\v~0_combout\ & ((!\LessThan6~14_combout\) # (\d.clip_rect.x1[6]~input_o\)))) # (\comb~0_combout\) ) ) ) # ( !\r.x1\(6) & ( \d.tile.x1[6]~input_o\ & ( (!\comb~0_combout\ & (!\v~0_combout\ & 
-- ((!\LessThan6~14_combout\) # (\d.clip_rect.x1[6]~input_o\)))) ) ) ) # ( \r.x1\(6) & ( !\d.tile.x1[6]~input_o\ & ( ((\d.clip_rect.x1[6]~input_o\ & (\LessThan6~14_combout\ & !\v~0_combout\))) # (\comb~0_combout\) ) ) ) # ( !\r.x1\(6) & ( 
-- !\d.tile.x1[6]~input_o\ & ( (\d.clip_rect.x1[6]~input_o\ & (\LessThan6~14_combout\ & (!\comb~0_combout\ & !\v~0_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000000000000000111110000111111010000000000001101111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.clip_rect.x1[6]~input_o\,
	datab => \ALT_INV_LessThan6~14_combout\,
	datac => \ALT_INV_comb~0_combout\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.x1\(6),
	dataf => \ALT_INV_d.tile.x1[6]~input_o\,
	combout => \v~105_combout\);

-- Location: FF_X66_Y9_N26
\r.x1[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~106_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(5));

-- Location: LABCELL_X66_Y9_N24
\v~106\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~106_combout\ = ( \r.x1\(5) & ( \d.clip_rect.x1[5]~input_o\ & ( ((!\v~0_combout\ & ((\LessThan6~14_combout\) # (\d.tile.x1[5]~input_o\)))) # (\comb~0_combout\) ) ) ) # ( !\r.x1\(5) & ( \d.clip_rect.x1[5]~input_o\ & ( (!\comb~0_combout\ & (!\v~0_combout\ 
-- & ((\LessThan6~14_combout\) # (\d.tile.x1[5]~input_o\)))) ) ) ) # ( \r.x1\(5) & ( !\d.clip_rect.x1[5]~input_o\ & ( ((\d.tile.x1[5]~input_o\ & (!\LessThan6~14_combout\ & !\v~0_combout\))) # (\comb~0_combout\) ) ) ) # ( !\r.x1\(5) & ( 
-- !\d.clip_rect.x1[5]~input_o\ & ( (\d.tile.x1[5]~input_o\ & (!\LessThan6~14_combout\ & (!\comb~0_combout\ & !\v~0_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000000000000010011110000111101110000000000000111111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[5]~input_o\,
	datab => \ALT_INV_LessThan6~14_combout\,
	datac => \ALT_INV_comb~0_combout\,
	datad => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_r.x1\(5),
	dataf => \ALT_INV_d.clip_rect.x1[5]~input_o\,
	combout => \v~106_combout\);

-- Location: FF_X66_Y9_N38
\r.x1[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~104_combout\,
	sclr => \reset~input_o\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.x1\(7));

-- Location: LABCELL_X66_Y9_N36
\v~104\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~104_combout\ = ( \r.x1\(7) & ( \comb~0_combout\ ) ) # ( \r.x1\(7) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan6~14_combout\ & (\d.tile.x1[7]~input_o\)) # (\LessThan6~14_combout\ & ((\d.clip_rect.x1[7]~input_o\))))) ) ) ) # ( !\r.x1\(7) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan6~14_combout\ & (\d.tile.x1[7]~input_o\)) # (\LessThan6~14_combout\ & ((\d.clip_rect.x1[7]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000000110000010100000011000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_d.tile.x1[7]~input_o\,
	datab => \ALT_INV_d.clip_rect.x1[7]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_LessThan6~14_combout\,
	datae => \ALT_INV_r.x1\(7),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~104_combout\);

-- Location: MLABCELL_X65_Y9_N36
\LessThan8~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~10_combout\ = ( \Add2~37_sumout\ & ( \Add2~41_sumout\ & ( (!\v~105_combout\) # ((!\v~104_combout\) # ((!\v~106_combout\ & \Add2~45_sumout\))) ) ) ) # ( !\Add2~37_sumout\ & ( \Add2~41_sumout\ & ( (!\v~104_combout\ & ((!\v~105_combout\) # 
-- ((!\v~106_combout\ & \Add2~45_sumout\)))) ) ) ) # ( \Add2~37_sumout\ & ( !\Add2~41_sumout\ & ( (!\v~104_combout\) # ((!\v~105_combout\ & (!\v~106_combout\ & \Add2~45_sumout\))) ) ) ) # ( !\Add2~37_sumout\ & ( !\Add2~41_sumout\ & ( (!\v~105_combout\ & 
-- (!\v~106_combout\ & (\Add2~45_sumout\ & !\v~104_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000000000111111110000100010101110000000001111111110101110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~105_combout\,
	datab => \ALT_INV_v~106_combout\,
	datac => \ALT_INV_Add2~45_sumout\,
	datad => \ALT_INV_v~104_combout\,
	datae => \ALT_INV_Add2~37_sumout\,
	dataf => \ALT_INV_Add2~41_sumout\,
	combout => \LessThan8~10_combout\);

-- Location: MLABCELL_X65_Y9_N18
\LessThan8~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~7_combout\ = ( \Add2~37_sumout\ & ( \Add2~41_sumout\ & ( (\v~105_combout\ & (\v~104_combout\ & (!\v~106_combout\ $ (\Add2~45_sumout\)))) ) ) ) # ( !\Add2~37_sumout\ & ( \Add2~41_sumout\ & ( (\v~105_combout\ & (!\v~104_combout\ & 
-- (!\v~106_combout\ $ (\Add2~45_sumout\)))) ) ) ) # ( \Add2~37_sumout\ & ( !\Add2~41_sumout\ & ( (!\v~105_combout\ & (\v~104_combout\ & (!\v~106_combout\ $ (\Add2~45_sumout\)))) ) ) ) # ( !\Add2~37_sumout\ & ( !\Add2~41_sumout\ & ( (!\v~105_combout\ & 
-- (!\v~104_combout\ & (!\v~106_combout\ $ (\Add2~45_sumout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000001000000000000000001000001001000001000000000000000001000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~105_combout\,
	datab => \ALT_INV_v~106_combout\,
	datac => \ALT_INV_Add2~45_sumout\,
	datad => \ALT_INV_v~104_combout\,
	datae => \ALT_INV_Add2~37_sumout\,
	dataf => \ALT_INV_Add2~41_sumout\,
	combout => \LessThan8~7_combout\);

-- Location: MLABCELL_X65_Y9_N6
\LessThan8~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~11_combout\ = ( \LessThan8~10_combout\ & ( \LessThan8~7_combout\ & ( !\LessThan8~6_combout\ ) ) ) # ( !\LessThan8~10_combout\ & ( \LessThan8~7_combout\ & ( (!\LessThan8~6_combout\ & ((!\LessThan8~9_combout\ & (!\v~103_combout\ & 
-- \Add2~33_sumout\)) # (\LessThan8~9_combout\ & ((!\v~103_combout\) # (\Add2~33_sumout\))))) ) ) ) # ( \LessThan8~10_combout\ & ( !\LessThan8~7_combout\ & ( !\LessThan8~6_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111110000000001001101000000001111111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan8~9_combout\,
	datab => \ALT_INV_v~103_combout\,
	datac => \ALT_INV_Add2~33_sumout\,
	datad => \ALT_INV_LessThan8~6_combout\,
	datae => \ALT_INV_LessThan8~10_combout\,
	dataf => \ALT_INV_LessThan8~7_combout\,
	combout => \LessThan8~11_combout\);

-- Location: LABCELL_X64_Y9_N0
\LessThan8~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~3_combout\ = ( \LessThan8~0_combout\ & ( (!\LessThan8~2_combout\ & (!\LessThan8~1_combout\ & (!\Add2~21_sumout\ $ (\v~100_combout\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000010000000010000001000000001000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Add2~21_sumout\,
	datab => \ALT_INV_LessThan8~2_combout\,
	datac => \ALT_INV_LessThan8~1_combout\,
	datad => \ALT_INV_v~100_combout\,
	dataf => \ALT_INV_LessThan8~0_combout\,
	combout => \LessThan8~3_combout\);

-- Location: LABCELL_X64_Y9_N36
\LessThan8~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \LessThan8~14_combout\ = ( \LessThan8~3_combout\ & ( \LessThan8~5_combout\ & ( (!\Add2~1_sumout\ & \v~148_combout\) ) ) ) # ( !\LessThan8~3_combout\ & ( \LessThan8~5_combout\ & ( (!\Add2~1_sumout\ & \v~148_combout\) ) ) ) # ( \LessThan8~3_combout\ & ( 
-- !\LessThan8~5_combout\ & ( (!\Add2~1_sumout\ & (((!\LessThan8~11_combout\ & \LessThan8~13_combout\)) # (\v~148_combout\))) # (\Add2~1_sumout\ & (\v~148_combout\ & (!\LessThan8~11_combout\ & \LessThan8~13_combout\))) ) ) ) # ( !\LessThan8~3_combout\ & ( 
-- !\LessThan8~5_combout\ & ( (!\Add2~1_sumout\ & ((\LessThan8~13_combout\) # (\v~148_combout\))) # (\Add2~1_sumout\ & (\v~148_combout\ & \LessThan8~13_combout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010001010111011001000101011001000100010001000100010001000100010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Add2~1_sumout\,
	datab => \ALT_INV_v~148_combout\,
	datac => \ALT_INV_LessThan8~11_combout\,
	datad => \ALT_INV_LessThan8~13_combout\,
	datae => \ALT_INV_LessThan8~3_combout\,
	dataf => \ALT_INV_LessThan8~5_combout\,
	combout => \LessThan8~14_combout\);

-- Location: FF_X65_Y11_N2
\r.i[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add3~45_sumout\,
	asdata => \v~1_combout\,
	sclr => \reset~input_o\,
	sload => \LessThan8~14_combout\,
	ena => \r.i[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.i\(1));

-- Location: MLABCELL_X65_Y11_N54
\v~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~1_combout\ = ( \r.i\(1) & ( \comb~0_combout\ ) ) # ( \r.i\(1) & ( !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & (\d.tile.y0[1]~input_o\)) # (\LessThan4~14_combout\ & ((\d.clip_rect.y0[1]~input_o\))))) ) ) ) # ( !\r.i\(1) & ( 
-- !\comb~0_combout\ & ( (!\v~0_combout\ & ((!\LessThan4~14_combout\ & (\d.tile.y0[1]~input_o\)) # (\LessThan4~14_combout\ & ((\d.clip_rect.y0[1]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010000001110000001000000111000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_LessThan4~14_combout\,
	datab => \ALT_INV_d.tile.y0[1]~input_o\,
	datac => \ALT_INV_v~0_combout\,
	datad => \ALT_INV_d.clip_rect.y0[1]~input_o\,
	datae => \ALT_INV_r.i\(1),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~1_combout\);

-- Location: FF_X64_Y11_N20
\r.quad.y0[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~1_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(1));

-- Location: LABCELL_X64_Y11_N0
\v~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~2_combout\ = ( \r.quad.y0\(1) & ( (!\r.next_quad~q\) # (\v~1_combout\) ) ) # ( !\r.quad.y0\(1) & ( (\r.next_quad~q\ & \v~1_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000001010101000000000101010110101010111111111010101011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_v~1_combout\,
	dataf => \ALT_INV_r.quad.y0\(1),
	combout => \v~2_combout\);

-- Location: FF_X64_Y11_N53
\r.quad.y0[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~3_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(2));

-- Location: LABCELL_X64_Y11_N33
\v~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~4_combout\ = ( \r.quad.y0\(2) & ( (!\r.next_quad~q\) # (\v~3_combout\) ) ) # ( !\r.quad.y0\(2) & ( (\v~3_combout\ & \r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000001111000000000000111111111111000011111111111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~3_combout\,
	datad => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_r.quad.y0\(2),
	combout => \v~4_combout\);

-- Location: FF_X63_Y11_N8
\r.quad.y0[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~5_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(3));

-- Location: LABCELL_X63_Y11_N6
\v~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~6_combout\ = ( \v~5_combout\ & ( \r.quad.y0\(3) ) ) # ( !\v~5_combout\ & ( \r.quad.y0\(3) & ( !\r.next_quad~q\ ) ) ) # ( \v~5_combout\ & ( !\r.quad.y0\(3) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000011110000111111110000111100001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_v~5_combout\,
	dataf => \ALT_INV_r.quad.y0\(3),
	combout => \v~6_combout\);

-- Location: FF_X64_Y11_N17
\r.quad.y0[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~7_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(4));

-- Location: LABCELL_X64_Y11_N3
\v~8\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~8_combout\ = ( \r.quad.y0\(4) & ( (!\r.next_quad~q\) # (\v~7_combout\) ) ) # ( !\r.quad.y0\(4) & ( (\r.next_quad~q\ & \v~7_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000001010101000000000101010110101010111111111010101011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_v~7_combout\,
	dataf => \ALT_INV_r.quad.y0\(4),
	combout => \v~8_combout\);

-- Location: FF_X51_Y11_N41
\r.quad.y0[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~9_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(5));

-- Location: LABCELL_X51_Y11_N39
\v~10\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~10_combout\ = ( \r.quad.y0\(5) & ( (!\r.next_quad~q\) # (\v~9_combout\) ) ) # ( !\r.quad.y0\(5) & ( (\r.next_quad~q\ & \v~9_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000001010101000000000101010110101010111111111010101011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_v~9_combout\,
	dataf => \ALT_INV_r.quad.y0\(5),
	combout => \v~10_combout\);

-- Location: FF_X68_Y9_N17
\r.quad.y0[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~11_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(6));

-- Location: LABCELL_X68_Y9_N15
\v~12\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~12_combout\ = ( \v~11_combout\ & ( \r.quad.y0\(6) ) ) # ( !\v~11_combout\ & ( \r.quad.y0\(6) & ( !\r.next_quad~q\ ) ) ) # ( \v~11_combout\ & ( !\r.quad.y0\(6) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010101010101010110101010101010101111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_v~11_combout\,
	dataf => \ALT_INV_r.quad.y0\(6),
	combout => \v~12_combout\);

-- Location: FF_X51_Y11_N35
\r.quad.y0[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~13_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(7));

-- Location: LABCELL_X51_Y11_N33
\v~14\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~14_combout\ = ( \v~13_combout\ & ( \r.quad.y0\(7) ) ) # ( !\v~13_combout\ & ( \r.quad.y0\(7) & ( !\r.next_quad~q\ ) ) ) # ( \v~13_combout\ & ( !\r.quad.y0\(7) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010101010101010110101010101010101111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_v~13_combout\,
	dataf => \ALT_INV_r.quad.y0\(7),
	combout => \v~14_combout\);

-- Location: FF_X51_Y11_N26
\r.quad.y0[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~15_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(8));

-- Location: LABCELL_X51_Y11_N24
\v~16\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~16_combout\ = ( \v~15_combout\ & ( \r.quad.y0\(8) ) ) # ( !\v~15_combout\ & ( \r.quad.y0\(8) & ( !\r.next_quad~q\ ) ) ) # ( \v~15_combout\ & ( !\r.quad.y0\(8) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000011110000111111110000111100001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_v~15_combout\,
	dataf => \ALT_INV_r.quad.y0\(8),
	combout => \v~16_combout\);

-- Location: FF_X61_Y9_N2
\r.quad.y0[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~17_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(9));

-- Location: LABCELL_X61_Y9_N54
\v~18\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~18_combout\ = (!\r.next_quad~q\ & ((\r.quad.y0\(9)))) # (\r.next_quad~q\ & (\v~17_combout\))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000010110101111000001011010111100000101101011110000010110101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datac => \ALT_INV_v~17_combout\,
	datad => \ALT_INV_r.quad.y0\(9),
	combout => \v~18_combout\);

-- Location: FF_X51_Y11_N11
\r.quad.y0[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~19_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(10));

-- Location: LABCELL_X51_Y11_N9
\v~20\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~20_combout\ = ( \v~19_combout\ & ( (\r.quad.y0\(10)) # (\r.next_quad~q\) ) ) # ( !\v~19_combout\ & ( (!\r.next_quad~q\ & \r.quad.y0\(10)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010010111110101111100001010000010100101111101011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datac => \ALT_INV_r.quad.y0\(10),
	datae => \ALT_INV_v~19_combout\,
	combout => \v~20_combout\);

-- Location: FF_X53_Y11_N53
\r.quad.y0[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~21_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(11));

-- Location: LABCELL_X53_Y11_N51
\v~22\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~22_combout\ = ( \r.quad.y0\(11) & ( (!\r.next_quad~q\) # (\v~21_combout\) ) ) # ( !\r.quad.y0\(11) & ( (\r.next_quad~q\ & \v~21_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000001010101000000000101010110101010111111111010101011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_v~21_combout\,
	dataf => \ALT_INV_r.quad.y0\(11),
	combout => \v~22_combout\);

-- Location: FF_X53_Y8_N17
\r.quad.y0[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~23_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(12));

-- Location: LABCELL_X53_Y8_N15
\v~24\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~24_combout\ = ( \v~23_combout\ & ( \r.quad.y0\(12) ) ) # ( !\v~23_combout\ & ( \r.quad.y0\(12) & ( !\r.next_quad~q\ ) ) ) # ( \v~23_combout\ & ( !\r.quad.y0\(12) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010101010101010110101010101010101111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_v~23_combout\,
	dataf => \ALT_INV_r.quad.y0\(12),
	combout => \v~24_combout\);

-- Location: FF_X67_Y11_N4
\r.quad.y0[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~25_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(13));

-- Location: LABCELL_X68_Y11_N15
\v~26\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~26_combout\ = ( \r.next_quad~q\ & ( \r.quad.y0\(13) & ( \v~25_combout\ ) ) ) # ( !\r.next_quad~q\ & ( \r.quad.y0\(13) ) ) # ( \r.next_quad~q\ & ( !\r.quad.y0\(13) & ( \v~25_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010101010101010111111111111111110101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~25_combout\,
	datae => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_r.quad.y0\(13),
	combout => \v~26_combout\);

-- Location: FF_X53_Y11_N56
\r.quad.y0[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~27_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(14));

-- Location: LABCELL_X53_Y11_N54
\v~28\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~28_combout\ = ( \v~27_combout\ & ( (\r.next_quad~q\) # (\r.quad.y0\(14)) ) ) # ( !\v~27_combout\ & ( (\r.quad.y0\(14) & !\r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000001010000010111110101111101010000010100000101111101011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.quad.y0\(14),
	datac => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_v~27_combout\,
	combout => \v~28_combout\);

-- Location: FF_X57_Y12_N17
\r.quad.y0[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~149_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.y0\(15));

-- Location: LABCELL_X57_Y12_N15
\v~29\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~29_combout\ = ( \v~149_combout\ & ( \r.quad.y0\(15) ) ) # ( !\v~149_combout\ & ( \r.quad.y0\(15) & ( !\r.next_quad~q\ ) ) ) # ( \v~149_combout\ & ( !\r.quad.y0\(15) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010101010101010110101010101010101111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_v~149_combout\,
	dataf => \ALT_INV_r.quad.y0\(15),
	combout => \v~29_combout\);

-- Location: LABCELL_X63_Y10_N42
\v~130\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~130_combout\ = ( \r.j\(0) & ( (((\comb~4_combout\ & \v~46_combout\)) # (\r.end_tile~q\)) # (\r.generate_quads~q\) ) ) # ( !\r.j\(0) & ( (!\r.generate_quads~q\ & (\comb~4_combout\ & (\v~46_combout\ & !\r.end_tile~q\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001000000000000000100000000001010111111111110101011111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.generate_quads~q\,
	datab => \ALT_INV_comb~4_combout\,
	datac => \ALT_INV_v~46_combout\,
	datad => \ALT_INV_r.end_tile~q\,
	dataf => \ALT_INV_r.j\(0),
	combout => \v~130_combout\);

-- Location: LABCELL_X62_Y9_N0
\Add0~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~1_sumout\ = SUM(( (\v~130_combout\ & (((!\comb~3_combout\) # (\r.generate_quads~q\)) # (\r.end_tile~q\))) ) + ( VCC ) + ( !VCC ))
-- \Add0~2\ = CARRY(( (\v~130_combout\ & (((!\comb~3_combout\) # (\r.generate_quads~q\)) # (\r.end_tile~q\))) ) + ( VCC ) + ( !VCC ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000011110111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.end_tile~q\,
	datab => \ALT_INV_r.generate_quads~q\,
	datac => \ALT_INV_comb~3_combout\,
	datad => \ALT_INV_v~130_combout\,
	cin => GND,
	sumout => \Add0~1_sumout\,
	cout => \Add0~2\);

-- Location: FF_X62_Y9_N1
\r.quad.x1[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~1_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(0));

-- Location: LABCELL_X61_Y9_N15
\v~30\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~30_combout\ = ( \r.next_quad~q\ & ( \Add0~1_sumout\ ) ) # ( !\r.next_quad~q\ & ( \r.quad.x1\(0) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111100000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.quad.x1\(0),
	datad => \ALT_INV_Add0~1_sumout\,
	dataf => \ALT_INV_r.next_quad~q\,
	combout => \v~30_combout\);

-- Location: LABCELL_X62_Y9_N3
\Add0~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~5_sumout\ = SUM(( GND ) + ( (!\r.end_tile~q\ & ((!\r.generate_quads~q\ & (\v~50_combout\)) # (\r.generate_quads~q\ & ((\r.j\(1)))))) # (\r.end_tile~q\ & (((\r.j\(1))))) ) + ( \Add0~2\ ))
-- \Add0~6\ = CARRY(( GND ) + ( (!\r.end_tile~q\ & ((!\r.generate_quads~q\ & (\v~50_combout\)) # (\r.generate_quads~q\ & ((\r.j\(1)))))) # (\r.end_tile~q\ & (((\r.j\(1))))) ) + ( \Add0~2\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111101111000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.end_tile~q\,
	datab => \ALT_INV_r.generate_quads~q\,
	datac => \ALT_INV_v~50_combout\,
	dataf => \ALT_INV_r.j\(1),
	cin => \Add0~2\,
	sumout => \Add0~5_sumout\,
	cout => \Add0~6\);

-- Location: FF_X62_Y9_N4
\r.quad.x1[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~5_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(1));

-- Location: LABCELL_X61_Y9_N39
\v~31\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~31_combout\ = ( \r.quad.x1\(1) & ( (!\r.next_quad~q\) # (\Add0~5_sumout\) ) ) # ( !\r.quad.x1\(1) & ( (\r.next_quad~q\ & \Add0~5_sumout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000001010101000000000101010110101010111111111010101011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_Add0~5_sumout\,
	dataf => \ALT_INV_r.quad.x1\(1),
	combout => \v~31_combout\);

-- Location: LABCELL_X62_Y9_N6
\Add0~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~9_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~53_combout\)))) # (\comb~0_combout\ & (((\r.j\(2))))) ) + ( GND ) + ( \Add0~6\ ))
-- \Add0~10\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~53_combout\)))) # (\comb~0_combout\ & (((\r.j\(2))))) ) + ( GND ) + ( \Add0~6\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(2),
	datad => \ALT_INV_v~53_combout\,
	cin => \Add0~6\,
	sumout => \Add0~9_sumout\,
	cout => \Add0~10\);

-- Location: FF_X62_Y9_N8
\r.quad.x1[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~9_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(2));

-- Location: LABCELL_X63_Y9_N27
\v~32\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~32_combout\ = (!\r.next_quad~q\ & (\r.quad.x1\(2))) # (\r.next_quad~q\ & ((\Add0~9_sumout\)))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000001011111010100000101111101010000010111110101000001011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.quad.x1\(2),
	datac => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_Add0~9_sumout\,
	combout => \v~32_combout\);

-- Location: LABCELL_X62_Y9_N9
\Add0~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~13_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~56_combout\)))) # (\comb~0_combout\ & (((\r.j\(3))))) ) + ( \Add0~10\ ))
-- \Add0~14\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~56_combout\)))) # (\comb~0_combout\ & (((\r.j\(3))))) ) + ( \Add0~10\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(3),
	dataf => \ALT_INV_v~56_combout\,
	cin => \Add0~10\,
	sumout => \Add0~13_sumout\,
	cout => \Add0~14\);

-- Location: FF_X62_Y9_N10
\r.quad.x1[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~13_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(3));

-- Location: MLABCELL_X59_Y9_N54
\v~33\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~33_combout\ = ( \Add0~13_sumout\ & ( (\r.next_quad~q\) # (\r.quad.x1\(3)) ) ) # ( !\Add0~13_sumout\ & ( (\r.quad.x1\(3) & !\r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000000110000001100000011000000111111001111110011111100111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_r.quad.x1\(3),
	datac => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_Add0~13_sumout\,
	combout => \v~33_combout\);

-- Location: LABCELL_X62_Y9_N12
\Add0~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~17_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~59_combout\)))) # (\comb~0_combout\ & (((\r.j\(4))))) ) + ( \Add0~14\ ))
-- \Add0~18\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~59_combout\)))) # (\comb~0_combout\ & (((\r.j\(4))))) ) + ( \Add0~14\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(4),
	dataf => \ALT_INV_v~59_combout\,
	cin => \Add0~14\,
	sumout => \Add0~17_sumout\,
	cout => \Add0~18\);

-- Location: FF_X62_Y9_N13
\r.quad.x1[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~17_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(4));

-- Location: LABCELL_X61_Y9_N48
\v~34\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~34_combout\ = ( \Add0~17_sumout\ & ( (\r.quad.x1\(4)) # (\r.next_quad~q\) ) ) # ( !\Add0~17_sumout\ & ( (!\r.next_quad~q\ & \r.quad.x1\(4)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011110000000000001111000000001111111111110000111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_r.quad.x1\(4),
	dataf => \ALT_INV_Add0~17_sumout\,
	combout => \v~34_combout\);

-- Location: LABCELL_X62_Y9_N15
\Add0~21\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~21_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~62_combout\)))) # (\comb~0_combout\ & (((\r.j\(5))))) ) + ( GND ) + ( \Add0~18\ ))
-- \Add0~22\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~62_combout\)))) # (\comb~0_combout\ & (((\r.j\(5))))) ) + ( GND ) + ( \Add0~18\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(5),
	datad => \ALT_INV_v~62_combout\,
	cin => \Add0~18\,
	sumout => \Add0~21_sumout\,
	cout => \Add0~22\);

-- Location: FF_X62_Y9_N17
\r.quad.x1[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~21_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(5));

-- Location: LABCELL_X63_Y9_N30
\v~35\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~35_combout\ = ( \Add0~21_sumout\ & ( (\r.quad.x1\(5)) # (\r.next_quad~q\) ) ) # ( !\Add0~21_sumout\ & ( (!\r.next_quad~q\ & \r.quad.x1\(5)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000110000001100000011000000110000111111001111110011111100111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_r.next_quad~q\,
	datac => \ALT_INV_r.quad.x1\(5),
	dataf => \ALT_INV_Add0~21_sumout\,
	combout => \v~35_combout\);

-- Location: LABCELL_X62_Y9_N18
\Add0~25\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~25_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~65_combout\)))) # (\comb~0_combout\ & (((\r.j\(6))))) ) + ( GND ) + ( \Add0~22\ ))
-- \Add0~26\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~65_combout\)))) # (\comb~0_combout\ & (((\r.j\(6))))) ) + ( GND ) + ( \Add0~22\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(6),
	datad => \ALT_INV_v~65_combout\,
	cin => \Add0~22\,
	sumout => \Add0~25_sumout\,
	cout => \Add0~26\);

-- Location: FF_X62_Y9_N20
\r.quad.x1[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~25_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(6));

-- Location: LABCELL_X61_Y9_N9
\v~36\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~36_combout\ = ( \Add0~25_sumout\ & ( \r.quad.x1\(6) ) ) # ( !\Add0~25_sumout\ & ( \r.quad.x1\(6) & ( !\r.next_quad~q\ ) ) ) # ( \Add0~25_sumout\ & ( !\r.quad.x1\(6) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010101010101010110101010101010101111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_Add0~25_sumout\,
	dataf => \ALT_INV_r.quad.x1\(6),
	combout => \v~36_combout\);

-- Location: LABCELL_X62_Y9_N21
\Add0~29\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~29_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~68_combout\)))) # (\comb~0_combout\ & (((\r.j\(7))))) ) + ( \Add0~26\ ))
-- \Add0~30\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~68_combout\)))) # (\comb~0_combout\ & (((\r.j\(7))))) ) + ( \Add0~26\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(7),
	dataf => \ALT_INV_v~68_combout\,
	cin => \Add0~26\,
	sumout => \Add0~29_sumout\,
	cout => \Add0~30\);

-- Location: FF_X62_Y9_N22
\r.quad.x1[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~29_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(7));

-- Location: LABCELL_X62_Y9_N54
\v~37\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~37_combout\ = ( \Add0~29_sumout\ & ( (\r.next_quad~q\) # (\r.quad.x1\(7)) ) ) # ( !\Add0~29_sumout\ & ( (\r.quad.x1\(7) & !\r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000000110000001111110011111100110000001100000011111100111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_r.quad.x1\(7),
	datac => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_Add0~29_sumout\,
	combout => \v~37_combout\);

-- Location: LABCELL_X62_Y9_N24
\Add0~33\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~33_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~71_combout\)))) # (\comb~0_combout\ & (((\r.j\(8))))) ) + ( GND ) + ( \Add0~30\ ))
-- \Add0~34\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~71_combout\)))) # (\comb~0_combout\ & (((\r.j\(8))))) ) + ( GND ) + ( \Add0~30\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(8),
	datad => \ALT_INV_v~71_combout\,
	cin => \Add0~30\,
	sumout => \Add0~33_sumout\,
	cout => \Add0~34\);

-- Location: FF_X62_Y9_N25
\r.quad.x1[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~33_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(8));

-- Location: LABCELL_X61_Y9_N24
\v~38\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~38_combout\ = ( \Add0~33_sumout\ & ( (\r.next_quad~q\) # (\r.quad.x1\(8)) ) ) # ( !\Add0~33_sumout\ & ( (\r.quad.x1\(8) & !\r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000000110000001111110011111100110000001100000011111100111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_r.quad.x1\(8),
	datac => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_Add0~33_sumout\,
	combout => \v~38_combout\);

-- Location: LABCELL_X62_Y9_N27
\Add0~37\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~37_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~74_combout\)))) # (\comb~0_combout\ & (((\r.j\(9))))) ) + ( GND ) + ( \Add0~34\ ))
-- \Add0~38\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~74_combout\)))) # (\comb~0_combout\ & (((\r.j\(9))))) ) + ( GND ) + ( \Add0~34\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(9),
	datad => \ALT_INV_v~74_combout\,
	cin => \Add0~34\,
	sumout => \Add0~37_sumout\,
	cout => \Add0~38\);

-- Location: FF_X62_Y9_N28
\r.quad.x1[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~37_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(9));

-- Location: LABCELL_X63_Y9_N48
\v~39\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~39_combout\ = ( \Add0~37_sumout\ & ( (\r.next_quad~q\) # (\r.quad.x1\(9)) ) ) # ( !\Add0~37_sumout\ & ( (\r.quad.x1\(9) & !\r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100010001000100010001000100010001110111011101110111011101110111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.quad.x1\(9),
	datab => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_Add0~37_sumout\,
	combout => \v~39_combout\);

-- Location: LABCELL_X62_Y9_N30
\Add0~41\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~41_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~77_combout\)))) # (\comb~0_combout\ & (((\r.j\(10))))) ) + ( GND ) + ( \Add0~38\ ))
-- \Add0~42\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~77_combout\)))) # (\comb~0_combout\ & (((\r.j\(10))))) ) + ( GND ) + ( \Add0~38\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(10),
	datad => \ALT_INV_v~77_combout\,
	cin => \Add0~38\,
	sumout => \Add0~41_sumout\,
	cout => \Add0~42\);

-- Location: FF_X62_Y9_N31
\r.quad.x1[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~41_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(10));

-- Location: LABCELL_X61_Y9_N36
\v~40\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~40_combout\ = ( \Add0~41_sumout\ & ( (\r.quad.x1\(10)) # (\r.next_quad~q\) ) ) # ( !\Add0~41_sumout\ & ( (!\r.next_quad~q\ & \r.quad.x1\(10)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010000010100000101001011111010111110101111101011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datac => \ALT_INV_r.quad.x1\(10),
	dataf => \ALT_INV_Add0~41_sumout\,
	combout => \v~40_combout\);

-- Location: LABCELL_X62_Y9_N33
\Add0~45\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~45_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~80_combout\)))) # (\comb~0_combout\ & (((\r.j\(11))))) ) + ( \Add0~42\ ))
-- \Add0~46\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~80_combout\)))) # (\comb~0_combout\ & (((\r.j\(11))))) ) + ( \Add0~42\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(11),
	dataf => \ALT_INV_v~80_combout\,
	cin => \Add0~42\,
	sumout => \Add0~45_sumout\,
	cout => \Add0~46\);

-- Location: FF_X62_Y9_N34
\r.quad.x1[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~45_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(11));

-- Location: LABCELL_X63_Y9_N9
\v~41\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~41_combout\ = ( \r.next_quad~q\ & ( \Add0~45_sumout\ ) ) # ( !\r.next_quad~q\ & ( \r.quad.x1\(11) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010100001111000011110000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.quad.x1\(11),
	datac => \ALT_INV_Add0~45_sumout\,
	dataf => \ALT_INV_r.next_quad~q\,
	combout => \v~41_combout\);

-- Location: LABCELL_X62_Y9_N36
\Add0~49\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~49_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~83_combout\)))) # (\comb~0_combout\ & (((\r.j\(12))))) ) + ( GND ) + ( \Add0~46\ ))
-- \Add0~50\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~83_combout\)))) # (\comb~0_combout\ & (((\r.j\(12))))) ) + ( GND ) + ( \Add0~46\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(12),
	datad => \ALT_INV_v~83_combout\,
	cin => \Add0~46\,
	sumout => \Add0~49_sumout\,
	cout => \Add0~50\);

-- Location: FF_X62_Y9_N37
\r.quad.x1[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~49_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(12));

-- Location: LABCELL_X61_Y9_N3
\v~42\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~42_combout\ = ( \Add0~49_sumout\ & ( \r.quad.x1\(12) ) ) # ( !\Add0~49_sumout\ & ( \r.quad.x1\(12) & ( !\r.next_quad~q\ ) ) ) # ( \Add0~49_sumout\ & ( !\r.quad.x1\(12) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000010101010101010110101010101010101111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_Add0~49_sumout\,
	dataf => \ALT_INV_r.quad.x1\(12),
	combout => \v~42_combout\);

-- Location: LABCELL_X62_Y9_N39
\Add0~53\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~53_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~86_combout\)))) # (\comb~0_combout\ & (((\r.j\(13))))) ) + ( GND ) + ( \Add0~50\ ))
-- \Add0~54\ = CARRY(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~86_combout\)))) # (\comb~0_combout\ & (((\r.j\(13))))) ) + ( GND ) + ( \Add0~50\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(13),
	datad => \ALT_INV_v~86_combout\,
	cin => \Add0~50\,
	sumout => \Add0~53_sumout\,
	cout => \Add0~54\);

-- Location: FF_X62_Y9_N40
\r.quad.x1[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~53_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(13));

-- Location: LABCELL_X63_Y9_N39
\v~43\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~43_combout\ = (!\r.next_quad~q\ & (\r.quad.x1\(13))) # (\r.next_quad~q\ & ((\Add0~53_sumout\)))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101001101010011010100110101001101010011010100110101001101010011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.quad.x1\(13),
	datab => \ALT_INV_Add0~53_sumout\,
	datac => \ALT_INV_r.next_quad~q\,
	combout => \v~43_combout\);

-- Location: LABCELL_X62_Y9_N42
\Add0~57\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~57_sumout\ = SUM(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~89_combout\)))) # (\comb~0_combout\ & (((\r.j\(14))))) ) + ( \Add0~54\ ))
-- \Add0~58\ = CARRY(( GND ) + ( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~89_combout\)))) # (\comb~0_combout\ & (((\r.j\(14))))) ) + ( \Add0~54\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111000111010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(14),
	dataf => \ALT_INV_v~89_combout\,
	cin => \Add0~54\,
	sumout => \Add0~57_sumout\,
	cout => \Add0~58\);

-- Location: FF_X62_Y9_N43
\r.quad.x1[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~57_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(14));

-- Location: LABCELL_X63_Y9_N15
\v~44\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~44_combout\ = ( \Add0~57_sumout\ & ( \r.quad.x1\(14) ) ) # ( !\Add0~57_sumout\ & ( \r.quad.x1\(14) & ( !\r.next_quad~q\ ) ) ) # ( \Add0~57_sumout\ & ( !\r.quad.x1\(14) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000011110000111111110000111100001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_Add0~57_sumout\,
	dataf => \ALT_INV_r.quad.x1\(14),
	combout => \v~44_combout\);

-- Location: LABCELL_X62_Y9_N45
\Add0~61\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add0~61_sumout\ = SUM(( (!\comb~0_combout\ & (!\v~0_combout\ & ((\v~92_combout\)))) # (\comb~0_combout\ & (((\r.j\(15))))) ) + ( GND ) + ( \Add0~58\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000001110001011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(15),
	datad => \ALT_INV_v~92_combout\,
	cin => \Add0~58\,
	sumout => \Add0~61_sumout\);

-- Location: FF_X62_Y9_N46
\r.quad.x1[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \Add0~61_sumout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x1\(15));

-- Location: LABCELL_X61_Y9_N30
\v~45\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~45_combout\ = ( \Add0~61_sumout\ & ( (\r.next_quad~q\) # (\r.quad.x1\(15)) ) ) # ( !\Add0~61_sumout\ & ( (\r.quad.x1\(15) & !\r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000001010000010100000101000001011111010111110101111101011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.quad.x1\(15),
	datac => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_Add0~61_sumout\,
	combout => \v~45_combout\);

-- Location: FF_X67_Y9_N26
\r.quad.x0[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~47_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(0));

-- Location: LABCELL_X67_Y9_N24
\v~48\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~48_combout\ = ( \r.quad.x0\(0) & ( (!\r.next_quad~q\) # (\v~47_combout\) ) ) # ( !\r.quad.x0\(0) & ( (\v~47_combout\ & \r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001100000011000000110000001111110011111100111111001111110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_v~47_combout\,
	datac => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_r.quad.x0\(0),
	combout => \v~48_combout\);

-- Location: LABCELL_X62_Y8_N36
\v~51\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~51_combout\ = ( \v~50_combout\ & ( (!\comb~0_combout\) # (\r.j\(1)) ) ) # ( !\v~50_combout\ & ( (\r.j\(1) & \comb~0_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001100000011000000110000001111110011111100111111001111110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_r.j\(1),
	datac => \ALT_INV_comb~0_combout\,
	dataf => \ALT_INV_v~50_combout\,
	combout => \v~51_combout\);

-- Location: FF_X62_Y8_N37
\r.quad.x0[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~51_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(1));

-- Location: LABCELL_X62_Y8_N39
\v~52\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~52_combout\ = (!\r.next_quad~q\ & (\r.quad.x0\(1))) # (\r.next_quad~q\ & ((\v~51_combout\)))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101001011111000010100101111100001010010111110000101001011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datac => \ALT_INV_r.quad.x0\(1),
	datad => \ALT_INV_v~51_combout\,
	combout => \v~52_combout\);

-- Location: LABCELL_X62_Y8_N45
\v~54\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~54_combout\ = ( \v~0_combout\ & ( (\comb~0_combout\ & \r.j\(2)) ) ) # ( !\v~0_combout\ & ( (!\comb~0_combout\ & ((\v~53_combout\))) # (\comb~0_combout\ & (\r.j\(2))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000110111011000100011011101100010001000100010001000100010001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~0_combout\,
	datab => \ALT_INV_r.j\(2),
	datad => \ALT_INV_v~53_combout\,
	dataf => \ALT_INV_v~0_combout\,
	combout => \v~54_combout\);

-- Location: FF_X62_Y8_N46
\r.quad.x0[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~54_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(2));

-- Location: LABCELL_X62_Y8_N42
\v~55\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~55_combout\ = ( \r.quad.x0\(2) & ( (!\r.next_quad~q\) # (\v~54_combout\) ) ) # ( !\r.quad.x0\(2) & ( (\r.next_quad~q\ & \v~54_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000001111000000000000111111110000111111111111000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_v~54_combout\,
	dataf => \ALT_INV_r.quad.x0\(2),
	combout => \v~55_combout\);

-- Location: LABCELL_X62_Y8_N51
\v~57\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~57_combout\ = ( \comb~0_combout\ & ( \r.j\(3) ) ) # ( !\comb~0_combout\ & ( (!\v~0_combout\ & \v~56_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010001000100010001000100010001000001111000011110000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_v~56_combout\,
	datac => \ALT_INV_r.j\(3),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~57_combout\);

-- Location: FF_X62_Y8_N52
\r.quad.x0[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~57_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(3));

-- Location: LABCELL_X62_Y8_N48
\v~58\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~58_combout\ = ( \v~57_combout\ & ( (\r.quad.x0\(3)) # (\r.next_quad~q\) ) ) # ( !\v~57_combout\ & ( (!\r.next_quad~q\ & \r.quad.x0\(3)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011110000000000001111000000001111111111110000111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_r.quad.x0\(3),
	dataf => \ALT_INV_v~57_combout\,
	combout => \v~58_combout\);

-- Location: LABCELL_X60_Y9_N36
\v~60\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~60_combout\ = ( \v~0_combout\ & ( (\comb~0_combout\ & \r.j\(4)) ) ) # ( !\v~0_combout\ & ( (!\comb~0_combout\ & (\v~59_combout\)) # (\comb~0_combout\ & ((\r.j\(4)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000110000111111000011000011111100000000001100110000000000110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_v~59_combout\,
	datad => \ALT_INV_r.j\(4),
	dataf => \ALT_INV_v~0_combout\,
	combout => \v~60_combout\);

-- Location: FF_X60_Y9_N37
\r.quad.x0[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~60_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(4));

-- Location: LABCELL_X60_Y9_N39
\v~61\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~61_combout\ = (!\r.next_quad~q\ & (\r.quad.x0\(4))) # (\r.next_quad~q\ & ((\v~60_combout\)))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101001011111000010100101111100001010010111110000101001011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datac => \ALT_INV_r.quad.x0\(4),
	datad => \ALT_INV_v~60_combout\,
	combout => \v~61_combout\);

-- Location: LABCELL_X61_Y9_N45
\v~63\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~63_combout\ = ( \comb~0_combout\ & ( \r.j\(5) ) ) # ( !\comb~0_combout\ & ( (\v~62_combout\ & !\v~0_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100000000000011110000000001010101010101010101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.j\(5),
	datac => \ALT_INV_v~62_combout\,
	datad => \ALT_INV_v~0_combout\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~63_combout\);

-- Location: FF_X61_Y9_N46
\r.quad.x0[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~63_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(5));

-- Location: LABCELL_X61_Y9_N42
\v~64\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~64_combout\ = ( \r.quad.x0\(5) & ( (!\r.next_quad~q\) # (\v~63_combout\) ) ) # ( !\r.quad.x0\(5) & ( (\v~63_combout\ & \r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001100000011000000110000001111110011111100111111001111110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_v~63_combout\,
	datac => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_r.quad.x0\(5),
	combout => \v~64_combout\);

-- Location: LABCELL_X60_Y9_N9
\v~66\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~66_combout\ = ( \v~0_combout\ & ( (\r.j\(6) & \comb~0_combout\) ) ) # ( !\v~0_combout\ & ( (!\comb~0_combout\ & ((\v~65_combout\))) # (\comb~0_combout\ & (\r.j\(6))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000010111110101000001011111010100000101000001010000010100000101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.j\(6),
	datac => \ALT_INV_comb~0_combout\,
	datad => \ALT_INV_v~65_combout\,
	dataf => \ALT_INV_v~0_combout\,
	combout => \v~66_combout\);

-- Location: FF_X60_Y9_N10
\r.quad.x0[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~66_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(6));

-- Location: LABCELL_X60_Y9_N6
\v~67\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~67_combout\ = ( \v~66_combout\ & ( (\r.quad.x0\(6)) # (\r.next_quad~q\) ) ) # ( !\v~66_combout\ & ( (!\r.next_quad~q\ & \r.quad.x0\(6)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011110000000000001111000000001111111111110000111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_r.quad.x0\(6),
	dataf => \ALT_INV_v~66_combout\,
	combout => \v~67_combout\);

-- Location: LABCELL_X60_Y9_N48
\v~69\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~69_combout\ = ( \v~0_combout\ & ( (\comb~0_combout\ & \r.j\(7)) ) ) # ( !\v~0_combout\ & ( (!\comb~0_combout\ & ((\v~68_combout\))) # (\comb~0_combout\ & (\r.j\(7))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001111001111000000111100111100000011000000110000001100000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_comb~0_combout\,
	datac => \ALT_INV_r.j\(7),
	datad => \ALT_INV_v~68_combout\,
	dataf => \ALT_INV_v~0_combout\,
	combout => \v~69_combout\);

-- Location: FF_X60_Y9_N49
\r.quad.x0[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~69_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(7));

-- Location: LABCELL_X60_Y9_N51
\v~70\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~70_combout\ = ( \v~69_combout\ & ( (\r.quad.x0\(7)) # (\r.next_quad~q\) ) ) # ( !\v~69_combout\ & ( (!\r.next_quad~q\ & \r.quad.x0\(7)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010000010100000101001011111010111110101111101011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datac => \ALT_INV_r.quad.x0\(7),
	dataf => \ALT_INV_v~69_combout\,
	combout => \v~70_combout\);

-- Location: LABCELL_X60_Y9_N57
\v~72\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~72_combout\ = ( \v~71_combout\ & ( (!\comb~0_combout\ & ((!\v~0_combout\))) # (\comb~0_combout\ & (\r.j\(8))) ) ) # ( !\v~71_combout\ & ( (\comb~0_combout\ & \r.j\(8)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000100010001000100010001000110110001101100011011000110110001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~0_combout\,
	datab => \ALT_INV_r.j\(8),
	datac => \ALT_INV_v~0_combout\,
	dataf => \ALT_INV_v~71_combout\,
	combout => \v~72_combout\);

-- Location: FF_X60_Y9_N58
\r.quad.x0[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~72_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(8));

-- Location: LABCELL_X60_Y9_N54
\v~73\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~73_combout\ = ( \r.quad.x0\(8) & ( (!\r.next_quad~q\) # (\v~72_combout\) ) ) # ( !\r.quad.x0\(8) & ( (\r.next_quad~q\ & \v~72_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000001111000000000000111111110000111111111111000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_v~72_combout\,
	dataf => \ALT_INV_r.quad.x0\(8),
	combout => \v~73_combout\);

-- Location: LABCELL_X62_Y9_N48
\v~75\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~75_combout\ = ( \comb~0_combout\ & ( \r.j\(9) ) ) # ( !\comb~0_combout\ & ( (\v~74_combout\ & !\v~0_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100000000000011110000000001010101010101010101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.j\(9),
	datac => \ALT_INV_v~74_combout\,
	datad => \ALT_INV_v~0_combout\,
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~75_combout\);

-- Location: FF_X62_Y9_N49
\r.quad.x0[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~75_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(9));

-- Location: LABCELL_X62_Y9_N51
\v~76\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~76_combout\ = ( \v~75_combout\ & ( (\r.next_quad~q\) # (\r.quad.x0\(9)) ) ) # ( !\v~75_combout\ & ( (\r.quad.x0\(9) & !\r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100000000000011110000000000001111111111110000111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.quad.x0\(9),
	datad => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_v~75_combout\,
	combout => \v~76_combout\);

-- Location: LABCELL_X62_Y10_N36
\v~78\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~78_combout\ = ( \comb~0_combout\ & ( \r.j\(10) ) ) # ( !\comb~0_combout\ & ( (!\v~0_combout\ & \v~77_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010001000100010001000100010001000001111000011110000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datab => \ALT_INV_v~77_combout\,
	datac => \ALT_INV_r.j\(10),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~78_combout\);

-- Location: FF_X62_Y10_N37
\r.quad.x0[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~78_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(10));

-- Location: LABCELL_X62_Y10_N39
\v~79\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~79_combout\ = ( \r.next_quad~q\ & ( \v~78_combout\ ) ) # ( !\r.next_quad~q\ & ( \r.quad.x0\(10) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111100000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.quad.x0\(10),
	datad => \ALT_INV_v~78_combout\,
	dataf => \ALT_INV_r.next_quad~q\,
	combout => \v~79_combout\);

-- Location: LABCELL_X60_Y9_N21
\v~81\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~81_combout\ = ( \comb~0_combout\ & ( \r.j\(11) ) ) # ( !\comb~0_combout\ & ( \r.j\(11) & ( (\v~80_combout\ & !\v~0_combout\) ) ) ) # ( !\comb~0_combout\ & ( !\r.j\(11) & ( (\v~80_combout\ & !\v~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100010001000100000000000000000001000100010001001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~80_combout\,
	datab => \ALT_INV_v~0_combout\,
	datae => \ALT_INV_comb~0_combout\,
	dataf => \ALT_INV_r.j\(11),
	combout => \v~81_combout\);

-- Location: FF_X59_Y9_N26
\r.quad.x0[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	asdata => \v~81_combout\,
	sload => VCC,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(11));

-- Location: MLABCELL_X59_Y9_N24
\v~82\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~82_combout\ = ( \v~81_combout\ & ( \r.quad.x0\(11) ) ) # ( !\v~81_combout\ & ( \r.quad.x0\(11) & ( !\r.next_quad~q\ ) ) ) # ( \v~81_combout\ & ( !\r.quad.x0\(11) & ( \r.next_quad~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000011110000111111110000111100001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datae => \ALT_INV_v~81_combout\,
	dataf => \ALT_INV_r.quad.x0\(11),
	combout => \v~82_combout\);

-- Location: LABCELL_X62_Y8_N57
\v~84\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~84_combout\ = ( \v~0_combout\ & ( (\comb~0_combout\ & \r.j\(12)) ) ) # ( !\v~0_combout\ & ( (!\comb~0_combout\ & ((\v~83_combout\))) # (\comb~0_combout\ & (\r.j\(12))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001101100011011000110110001101100010001000100010001000100010001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~0_combout\,
	datab => \ALT_INV_r.j\(12),
	datac => \ALT_INV_v~83_combout\,
	dataf => \ALT_INV_v~0_combout\,
	combout => \v~84_combout\);

-- Location: FF_X62_Y8_N58
\r.quad.x0[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~84_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(12));

-- Location: LABCELL_X62_Y8_N54
\v~85\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~85_combout\ = ( \r.quad.x0\(12) & ( (!\r.next_quad~q\) # (\v~84_combout\) ) ) # ( !\r.quad.x0\(12) & ( (\r.next_quad~q\ & \v~84_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000001111000000000000111111110000111111111111000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_v~84_combout\,
	dataf => \ALT_INV_r.quad.x0\(12),
	combout => \v~85_combout\);

-- Location: LABCELL_X60_Y9_N12
\v~87\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~87_combout\ = ( \v~0_combout\ & ( (\comb~0_combout\ & \r.j\(13)) ) ) # ( !\v~0_combout\ & ( (!\comb~0_combout\ & (\v~86_combout\)) # (\comb~0_combout\ & ((\r.j\(13)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000000111111001100000011111100000000000011110000000000001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_v~86_combout\,
	datac => \ALT_INV_comb~0_combout\,
	datad => \ALT_INV_r.j\(13),
	dataf => \ALT_INV_v~0_combout\,
	combout => \v~87_combout\);

-- Location: FF_X60_Y9_N13
\r.quad.x0[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~87_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(13));

-- Location: LABCELL_X60_Y9_N15
\v~88\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~88_combout\ = ( \r.quad.x0\(13) & ( (!\r.next_quad~q\) # (\v~87_combout\) ) ) # ( !\r.quad.x0\(13) & ( (\r.next_quad~q\ & \v~87_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000010100000101000001010000010110101111101011111010111110101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_r.next_quad~q\,
	datac => \ALT_INV_v~87_combout\,
	dataf => \ALT_INV_r.quad.x0\(13),
	combout => \v~88_combout\);

-- Location: LABCELL_X62_Y8_N12
\v~90\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~90_combout\ = ( \v~0_combout\ & ( (\comb~0_combout\ & \r.j\(14)) ) ) # ( !\v~0_combout\ & ( (!\comb~0_combout\ & ((\v~89_combout\))) # (\comb~0_combout\ & (\r.j\(14))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001101100011011000110110001101100010001000100010001000100010001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_comb~0_combout\,
	datab => \ALT_INV_r.j\(14),
	datac => \ALT_INV_v~89_combout\,
	dataf => \ALT_INV_v~0_combout\,
	combout => \v~90_combout\);

-- Location: FF_X62_Y8_N13
\r.quad.x0[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~90_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(14));

-- Location: LABCELL_X62_Y8_N15
\v~91\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~91_combout\ = ( \r.quad.x0\(14) & ( (!\r.next_quad~q\) # (\v~90_combout\) ) ) # ( !\r.quad.x0\(14) & ( (\v~90_combout\ & \r.next_quad~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000001111000000000000111111111111000011111111111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_v~90_combout\,
	datad => \ALT_INV_r.next_quad~q\,
	dataf => \ALT_INV_r.quad.x0\(14),
	combout => \v~91_combout\);

-- Location: LABCELL_X62_Y8_N33
\v~93\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~93_combout\ = ( \comb~0_combout\ & ( \r.j\(15) ) ) # ( !\comb~0_combout\ & ( (!\v~0_combout\ & \v~92_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000001010000010100000101000000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_v~0_combout\,
	datac => \ALT_INV_v~92_combout\,
	datad => \ALT_INV_r.j\(15),
	dataf => \ALT_INV_comb~0_combout\,
	combout => \v~93_combout\);

-- Location: FF_X62_Y8_N34
\r.quad.x0[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \v~93_combout\,
	ena => \r.next_quad~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad.x0\(15));

-- Location: LABCELL_X62_Y8_N30
\v~94\ : cyclonev_lcell_comb
-- Equation(s):
-- \v~94_combout\ = ( \v~93_combout\ & ( (\r.quad.x0\(15)) # (\r.next_quad~q\) ) ) # ( !\v~93_combout\ & ( (!\r.next_quad~q\ & \r.quad.x0\(15)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011110000000000001111000000001111111111110000111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_r.next_quad~q\,
	datad => \ALT_INV_r.quad.x0\(15),
	dataf => \ALT_INV_v~93_combout\,
	combout => \v~94_combout\);

-- Location: LABCELL_X64_Y12_N39
\r.quad_ready~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \r.quad_ready~feeder_combout\ = ( \r.next_quad~q\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_r.next_quad~q\,
	combout => \r.quad_ready~feeder_combout\);

-- Location: FF_X64_Y12_N40
\r.quad_ready\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputCLKENA0_outclk\,
	d => \r.quad_ready~feeder_combout\,
	sclr => \reset~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \r.quad_ready~q\);

-- Location: LABCELL_X10_Y44_N3
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


