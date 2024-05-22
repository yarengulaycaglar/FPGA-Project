library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD_out is
Port (  fee  	: in STD_LOGIC_VECTOR(11 downto 0);
		LED_0 	: out STD_LOGIC_VECTOR (6 downto 0);
		LED_1 	: out STD_LOGIC_VECTOR (6 downto 0);
		LED_2 	: out STD_LOGIC_VECTOR (6 downto 0)
		);
end BCD_out;

architecture Behavioral of BCD_out is

signal fee_lower   : STD_LOGIC_VECTOR(3 downto 0);
signal fee_middle  : STD_LOGIC_VECTOR(3 downto 0);
signal fee_upper   : STD_LOGIC_VECTOR(3 downto 0);




BEGIN

fee_lower  <= fee(3 downto 0);
fee_middle <= fee(7 downto 4);
fee_upper  <= fee(11 downto 8);


WITH fee_lower SELECT
	LED_0 <= "1000000" WHEN "0000", --0
			 "1111001" WHEN "0001", --1
			 "0100100" WHEN "0010", --2
			 "0110000" WHEN "0011", --3
			 "0011001" WHEN "0100", --4
			 "0010010" WHEN "0101", --5
			 "0000010" WHEN "0110", --6
			 "1111000" WHEN "0111", --7
			 "0000000" WHEN "1000", --8
			 "0010000" WHEN "1001", --9
			 "1000000" WHEN "1010", --10
			 "1111001" WHEN "1011", --11
			 "0100100" WHEN "1100", --12
			 "0110000" WHEN "1101", --13
			 "0011001" WHEN "1110", --14
			 "0010010" WHEN "1111", --15
			 "0110110" WHEN OTHERS; -- UNDEFINED
WITH fee_middle SELECT
	LED_1 <= "1000000" WHEN "0000", --0
			 "1000000" WHEN "0001", --1
			 "1000000" WHEN "0010", --2
			 "1000000" WHEN "0011", --3
			 "1000000" WHEN "0100", --4
			 "1000000" WHEN "0101", --5
			 "1000000" WHEN "0110", --6
			 "1000000" WHEN "0111", --7
			 "1000000" WHEN "1000", --8
			 "1000000" WHEN "1001", --9
			 "1111001" WHEN "1010", --10
			 "1111001" WHEN "1011", --11
			 "1111001" WHEN "1100", --12
			 "1111001" WHEN "1101", --13
			 "1111001" WHEN "1110", --14
			 "1111001" WHEN "1111", --15
			 "0110110" WHEN OTHERS; -- UNDEFINED

WITH fee_upper SELECT
	LED_2 <= "1000000" WHEN "0000", --0
			 "1111001" WHEN "0001", --1
			 "0100100" WHEN "0010", --2
			 "0110000" WHEN "0011", --3
			 "0011001" WHEN "0100", --4
			 "0010010" WHEN "0101", --5
			 "0000010" WHEN "0110", --6
			 "1111000" WHEN "0111", --7
			 "0000000" WHEN "1000", --8
			 "0010000" WHEN "1001", --9
			 "1000000" WHEN "1010", --10
			 "1111001" WHEN "1011", --11
			 "0100100" WHEN "1100", --12
			 "0110000" WHEN "1101", --13
			 "0011001" WHEN "1110", --14
			 "0010010" WHEN "1111", --15
			 "0110110" WHEN OTHERS; -- UNDEFINED
		
end Behavioral;
