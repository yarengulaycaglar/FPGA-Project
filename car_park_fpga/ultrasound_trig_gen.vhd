library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ultrasound_trig_gen is 
port(
	clk 		: in std_logic;
	trigger 	: out std_logic
	);
		
end entity;

architecture arch of ultrasound_trig_gen is 

component ultrasound_counter is
	Port(
	clk		   	: in STD_LOGIC;
	enable     	: in STD_LOGIC;
	reset      	: in STD_LOGIC;
	counter_out	: out STD_LOGIC_vector(23 downto 0)
	);
end component;

signal reset_counter : std_logic;
signal outputCounter : std_logic_vector(23 downto 0);

begin

trigg : ultrasound_counter
port map(
	clk 		=> clk,
	enable 		=> '1',
	reset 		=> reset_counter,
	counter_out => outputCounter
	);
	
process(clk)
constant ms250 : std_logic_vector(23 downto 0) := 			"101111101011110000100000"; --to generate 250ms pulse divide the main FPGA board clock that is 50MHz with 4Hz(or 1/250 x10^-3)
constant ms250and100us : std_logic_vector(23 downto 0) :=   "101111101100111110101000"; --to generate (250ms+100us) pulse divide the main FPGA board clock that is 50MHz with 3.9984HZ(or 1/250x10^-3 + 0.1*10^-3)
begin
    if(rising_edge(clk)) then   
	   if(outputcounter > ms250 and outputcounter < ms250and100us) then 
	   	trigger <= '1';
	   	
	   else 
	   	trigger <= '0';
	   	
	   end if;
	   if(outputCounter = ms250and100us or outputCounter ="XXXXXXXXXXXXXXXXXXXXXXXX") then
	   	reset_counter <= '0';
	   else 
	   	reset_counter <= '1';
	   end if;
	 end if;
end process;	
end arch;
	