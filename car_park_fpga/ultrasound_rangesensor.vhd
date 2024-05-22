library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ultrasound_rangesensor is 
port(
	fpgaclk			: in std_logic;
	pulse 			: in std_logic;
	triggerout 		: out std_logic;
	meters 			: out std_logic_vector(3 downto 0);
	decimeters 		: out std_logic_vector(3 downto 0);
	centimeters 	: out std_logic_vector(3 downto 0);
	total_distance	: out std_logic_vector(8 downto 0)
	);
end entity;

architecture arch of ultrasound_rangesensor is 

component ultrasound_dis_cal is
	Port(
	clk		   	: in STD_LOGIC;
	cal_res    	: in STD_LOGIC;
	pulse     	: in STD_LOGIC;
	distance	: out STD_LOGIC_vector(8 downto 0)
	);
end component;

component ultrasound_trig_gen is 
port(
	clk 		: in std_logic;
	trigger 	: out std_logic
	);
		
end component;

component ultrasound_BCDconverter is 	
port(
	distance_input  		: in  std_logic_vector(8 downto 0);
	hundreds				: out std_logic_vector(3 downto 0);
	tens 					: out std_logic_vector(3 downto 0);
	unit 					: out std_logic_vector(3 downto 0));
end component;

signal distanceout	: std_logic_vector(8 downto 0);
signal triggout		: std_logic;

begin 
trigger_gen : ultrasound_trig_gen port map(
	clk 		=> fpgaclk,
	trigger 	=> triggout);
	
pulsewidth : ultrasound_dis_cal port map(
	clk 		=> fpgaclk,
	cal_res		=> triggout,
	pulse 		=> pulse,
	distance	=> distanceout);
	
bcdconv : ultrasound_BCDconverter port map(
	distance_input  	=> distanceout,
	hundreds			=> meters,	
	tens 				=> decimeters,	
	unit 				=> centimeters);

triggerout 		<= triggout;
total_distance  <= distanceout;	

end arch;
