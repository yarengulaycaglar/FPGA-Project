library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity distance_top is port(
		clk 			: in std_logic;
		echo 			: in std_logic;
		trigger_out 	: out stD_logic;
		total_out 	: out std_logic_vector(8 downto 0));
		
end entity;

architecture arch of distance_top is 
component ultrasound_rangesensor is 
port(
	fpgaclk			: in std_logic;
	pulse 			: in std_logic;
	triggerout 		: out std_logic;
	meters 			: out std_logic_vector(3 downto 0);
	decimeters 		: out std_logic_vector(3 downto 0);
	centimeters 	: out std_logic_vector(3 downto 0);
	total_distance	: out std_logic_vector(8 downto 0)
	);
end component;

signal m  : std_logic_vector(3 downto 0);
signal dm : std_logic_vector(3 downto 0);
signal cm : std_logic_vector(3 downto 0);
signal distance : std_logic_vector(8 downto 0);

begin

uut1: ultrasound_rangesensor port map(
		fpgaclk			=> 	clk,
        pulse 			=> 	echo,
        triggerout 		=> 	trigger_out,
        meters 			=> 	m,
        decimeters 		=> dm,
        centimeters 	=> cm,	
        total_distance	=> distance);
        
total_out <= distance;
end arch;