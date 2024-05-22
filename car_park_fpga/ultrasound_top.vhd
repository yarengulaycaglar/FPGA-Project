library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ultrasound_top is port(
	clk 				: in  stD_logic;
	echo00				: in  std_logic;		
	echo01				: in  std_logic;		
	echo02				: in  std_logic;		
	echo03				: in  std_logic;		
	echo10				: in  std_logic;		
	echo11				: in  std_logic;
	echo12				: in  std_logic;
	echo13				: in  std_logic;
	echo14				: in  std_logic;
	echo15				: in  std_logic;
	echo20				: in  std_logic;
	echo21				: in  std_logic;
	echo22				: in  std_logic;
	echo23				: in  std_logic;
	echo24				: in  std_logic;
	echo25				: in  std_logic;
	top_trigger_out00 	: out std_logic;
	top_trigger_out01 	: out std_logic;
	top_trigger_out02 	: out std_logic;
	top_trigger_out03 	: out std_logic;
	top_trigger_out10 	: out std_logic;
	top_trigger_out11 	: out std_logic;
	top_trigger_out12 	: out std_logic;
	top_trigger_out13 	: out std_logic;
	top_trigger_out14 	: out std_logic;
	top_trigger_out15 	: out std_logic;
	top_trigger_out20 	: out std_logic;
	top_trigger_out21 	: out std_logic;
	top_trigger_out22 	: out std_logic;
	top_trigger_out23 	: out std_logic;
	top_trigger_out24 	: out std_logic;
	top_trigger_out25 	: out std_logic;
	total_out00 		: out std_logic_vector(8 downto 0);
	total_out01 		: out std_logic_vector(8 downto 0);
	total_out02 		: out std_logic_vector(8 downto 0);
	total_out03 		: out std_logic_vector(8 downto 0);
	total_out10 		: out std_logic_vector(8 downto 0);
	total_out11 		: out std_logic_vector(8 downto 0);
	total_out12 		: out std_logic_vector(8 downto 0);
	total_out13 		: out std_logic_vector(8 downto 0);
	total_out14 		: out std_logic_vector(8 downto 0);
	total_out15 		: out std_logic_vector(8 downto 0);
	total_out20 		: out std_logic_vector(8 downto 0);
	total_out21 		: out std_logic_vector(8 downto 0);
	total_out22 		: out std_logic_vector(8 downto 0);
	total_out23 		: out std_logic_vector(8 downto 0);
	total_out24 		: out std_logic_vector(8 downto 0);
	total_out25 		: out std_logic_vector(8 downto 0));
	
end entity;

architecture arch of ultrasound_top is 

component distance_top is port(
		clk 			: in std_logic;
		echo 			: in std_logic;
		trigger_out 	: out stD_logic;
		total_out 		: out std_logic_vector(8 downto 0));
		
end component;

signal s_total_out00 : std_logic_vector(8 downto 0);
signal s_total_out01 : std_logic_vector(8 downto 0);
signal s_total_out02 : std_logic_vector(8 downto 0);
signal s_total_out03 : std_logic_vector(8 downto 0);
signal s_total_out10 : std_logic_vector(8 downto 0);
signal s_total_out11 : std_logic_vector(8 downto 0);
signal s_total_out12 : std_logic_vector(8 downto 0);
signal s_total_out13 : std_logic_vector(8 downto 0);
signal s_total_out14 : std_logic_vector(8 downto 0);
signal s_total_out15 : std_logic_vector(8 downto 0);
signal s_total_out20 : std_logic_vector(8 downto 0);
signal s_total_out21 : std_logic_vector(8 downto 0);
signal s_total_out22 : std_logic_vector(8 downto 0);
signal s_total_out23 : std_logic_vector(8 downto 0);
signal s_total_out24 : std_logic_vector(8 downto 0);
signal s_total_out25 : std_logic_vector(8 downto 0);

signal s_top_trigger_out00 : std_logic;
signal s_top_trigger_out01 : std_logic;
signal s_top_trigger_out02 : std_logic;
signal s_top_trigger_out03 : std_logic;
signal s_top_trigger_out10 : std_logic;
signal s_top_trigger_out11 : std_logic;
signal s_top_trigger_out12 : std_logic;
signal s_top_trigger_out13 : std_logic;
signal s_top_trigger_out14 : std_logic;
signal s_top_trigger_out15 : std_logic;
signal s_top_trigger_out20 : std_logic;
signal s_top_trigger_out21 : std_logic;
signal s_top_trigger_out22 : std_logic;
signal s_top_trigger_out23 : std_logic;
signal s_top_trigger_out24 : std_logic;
signal s_top_trigger_out25 : std_logic;




begin 

uut00 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo00,
        trigger_out 	=> s_top_trigger_out00,
        total_out 		=> s_total_out00);
		
uut01 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo01,
        trigger_out 	=> s_top_trigger_out01,
        total_out 		=> s_total_out01);
uut02 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo02,
        trigger_out 	=> s_top_trigger_out02,
        total_out 		=> s_total_out02);
uut03 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo03,
        trigger_out 	=> s_top_trigger_out03,
        total_out 		=> s_total_out03);

uut10 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo10,
        trigger_out 	=> s_top_trigger_out10,
        total_out 		=> s_total_out10);
uut11 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo11,
        trigger_out 	=> s_top_trigger_out11,
        total_out 		=> s_total_out11);	
uut12 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo12,
        trigger_out 	=> s_top_trigger_out12,
        total_out 		=> s_total_out12);
uut13 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo13,
        trigger_out 	=> s_top_trigger_out13,
        total_out 		=> s_total_out13);		
uut14 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo14,
        trigger_out 	=> s_top_trigger_out14,
        total_out 		=> s_total_out14);
uut15 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo15,
        trigger_out 	=> s_top_trigger_out15,
        total_out 		=> s_total_out15);
uut20 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo20,
        trigger_out 	=> s_top_trigger_out20,
        total_out 		=> s_total_out20);
uut21 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo21,
        trigger_out 	=> s_top_trigger_out21,
        total_out 		=> s_total_out21);
uut22 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo22,
        trigger_out 	=> s_top_trigger_out22,
        total_out 		=> s_total_out22);
uut23 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo23,
        trigger_out 	=> s_top_trigger_out23,
        total_out 		=> s_total_out23);
uut24 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo24,
        trigger_out 	=> s_top_trigger_out24,
        total_out 		=> s_total_out24);
uut25 : distance_top port map(
		clk 			=> clk, 		
        echo 			=> echo25,
        trigger_out 	=> s_top_trigger_out25,
        total_out 		=> s_total_out25);
		
total_out00	<= s_total_out00;	
total_out01 <= s_total_out01;
total_out02	<= s_total_out02;	
total_out03	<= s_total_out03;
total_out10	<= s_total_out10;
total_out11 <= s_total_out11;
total_out12 <= s_total_out12;
total_out13 <= s_total_out13;
total_out14 <= s_total_out14;
total_out15 <= s_total_out15;
total_out20 <= s_total_out20;
total_out21 <= s_total_out21;
total_out22 <= s_total_out22;
total_out23 <= s_total_out23;
total_out24 <= s_total_out24;
total_out25 <= s_total_out25;

top_trigger_out00 <= s_top_trigger_out00;
top_trigger_out01 <= s_top_trigger_out01;
top_trigger_out02 <= s_top_trigger_out02;
top_trigger_out03 <= s_top_trigger_out03;
top_trigger_out10 <= s_top_trigger_out10;
top_trigger_out11 <= s_top_trigger_out11;
top_trigger_out12 <= s_top_trigger_out12;
top_trigger_out13 <= s_top_trigger_out13;
top_trigger_out14 <= s_top_trigger_out14;
top_trigger_out15 <= s_top_trigger_out15;
top_trigger_out20 <= s_top_trigger_out20;
top_trigger_out21 <= s_top_trigger_out21;
top_trigger_out22 <= s_top_trigger_out22;
top_trigger_out23 <= s_top_trigger_out23;
top_trigger_out24 <= s_top_trigger_out24;
top_trigger_out25 <= s_top_trigger_out25;

end arch;