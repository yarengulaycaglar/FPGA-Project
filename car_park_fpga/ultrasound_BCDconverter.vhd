library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ultrasound_BCDconverter is 	
port(
	distance_input  		: in  std_logic_vector(8 downto 0);
	hundreds				: out std_logic_vector(3 downto 0);
	tens 					: out std_logic_vector(3 downto 0);
	unit 					: out std_logic_vector(3 downto 0));
end entity;

architecture arch of ultrasound_BCDconverter is 

begin
process(distance_input)
variable i : integer := 0;
variable bcd : std_logic_vector(20 downto 0); 

begin 

bcd := (others => '0');
bcd(8 downto 0) := distance_input;

for i in 0 to 8 loop 
	bcd(19 downto 0 ) := bcd(18 downto 0) & '0';
	
	if(i < 8 and bcd(12 downto 9) > "0100") then 
		bcd(12 downto 9) := bcd(12 downto 9) + "0011";
	end if;
	
	if(i < 8 and bcd(16 downto 13) > "0100") then  
		bcd(16 downto 13) := bcd(16 downto 13) + "0011";
	end if;
	
	if(i<8 and bcd(20 downto 17) > "0100") then 
		bcd(20 downto 17) := bcd(20 downto 17) + "0011";
	end if;
	
	end loop;
	
hundreds <= bcd(20 downto 17);
tens <= bcd(16 downto 13);
unit <= bcd(12 downto 9);

end process;
end arch;