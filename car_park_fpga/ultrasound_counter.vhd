library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ultrasound_counter is
    generic(n : positive := 24);
	Port(
	clk		   	: in STD_LOGIC;
	enable     	: in STD_LOGIC;
	reset      	: in STD_LOGIC;
	counter_out	: out STD_LOGIC_vector(n-1 downto 0)
	);
end ultrasound_counter;

architecture Behavioral of ultrasound_counter is

signal count : STD_LOGIC_VECTOR(n-1 downto 0);

begin

process(clk,reset)
begin
if(reset = '0') then
	count <= (others => '0');
else
	if(rising_edge(clk)) then 
		if(enable = '1') then
			count <= count + 1;
		end if;			
	end if;
end if;
end process;
counter_out <= count;

end Behavioral;