library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pl_addresser is
--generic(
--	--out_address : std_logic_vector := "1010";
--	c_clkfreq : integer := 20 --Low value for testbench
--	--c_clkfreq : integer := 50_000_000 --Real Design Value
--);
  Port (
  		clk				: in  STD_LOGIC;
		reset   		: in  STD_LOGIC;
		stair			: in std_logic_vector(1 downto 0);	
		car_inside 		: in std_logic;
		car_out 		: in std_logic;
		stair0			: in std_logic_vector(3 downto 0);
		stair1			: in std_logic_vector(5 downto 0);
		stair2			: in std_logic_vector(5 downto 0);
		destination 	: out std_logic_vector(7 downto 0)
  );
end pl_addresser;

architecture Behavioral of pl_addresser is

signal stair_chs_hold   : std_logic_vector(1 downto 0) := "00";
signal destination_reg 	: std_logic_vector(7 downto 0);

begin
stair_chs_hold <= stair;
destination    <= destination_reg;
process(stair_chs_hold,car_inside) begin
	if(car_inside = '1') then

		case stair_chs_hold is
		
			when "00" =>
				if(car_out = '0') then
					if(stair0(2) = '0') then
						destination_reg <= "00000100";
					elsif(stair0(3) = '0') then
						destination_reg <= "00001000";
					elsif(stair0(0) = '0') then
						destination_reg <= "00000001";				
					elsif(stair0(1) = '0') then
						destination_reg <= "00000010";
					else 
						destination_reg <= (others => '0');--no space
					end if;
					
				else
					if(stair0(0) = '0') then
						destination_reg <= "00000001";
					elsif(stair0(1) = '0') then
						destination_reg <= "00000010";
					elsif(stair0(2) = '0') then
						destination_reg <= "00000100";				
					elsif(stair0(3) = '0') then
						destination_reg <= "00001000";
					else 
						destination_reg <= (others => '0');--no space
					end	if;		
				end if;
			
			when "01" =>
			
				if(car_out = '0') then
					if(stair1(3) = '0') then
						destination_reg <= "01001000";
					elsif(stair1(4) = '0') then
						destination_reg <= "01010000";
					elsif(stair1(5) = '0') then
						destination_reg <= "01100000";				
					elsif(stair1(0) = '0') then
						destination_reg <= "01000001";
					elsif(stair1(1) = '0') then
						destination_reg <= "01000010";
					elsif(stair1(2) = '0') then
						destination_reg <= "01000100";				
					else 
						destination_reg <= (others => '0');--no space
					end if;
					
				else
					if(stair1(0) = '0') then
						destination_reg <= "01000001";
					elsif(stair1(1) = '0') then
						destination_reg <= "01000010";
					elsif(stair1(2) = '0') then
						destination_reg <= "01000100";				
					elsif(stair1(3) = '0') then
						destination_reg <= "01001000";
					elsif(stair1(4) = '0') then
						destination_reg <= "01010000";
					elsif(stair1(5) = '0') then
						destination_reg <= "01100000";			
					else 
						destination_reg <= (others => '0');--no space
					end	if;		
				end if;		
			
			when "10" =>
				if(car_out = '0') then
					if(stair1(3) = '0') then
						destination_reg <= "10001000";
					elsif(stair1(4) = '0') then
						destination_reg <= "10010000";
					elsif(stair1(5) = '0') then
						destination_reg <= "10100000";				
					elsif(stair1(0) = '0') then
						destination_reg <= "10000001";
					elsif(stair1(1) = '0') then
						destination_reg <= "10000010";
					elsif(stair1(2) = '0') then
						destination_reg <= "10000100";				
					else 
						destination_reg <= (others => '0');--no space
					end if;
					
				else
					if(stair1(0) = '0') then
						destination_reg <= "10000001";
					elsif(stair1(1) = '0') then
						destination_reg <= "10000010";
					elsif(stair1(2) = '0') then
						destination_reg <= "10000100";				
					elsif(stair1(3) = '0') then
						destination_reg <= "10001000";
					elsif(stair1(4) = '0') then
						destination_reg <= "10010000";
					elsif(stair1(5) = '0') then
						destination_reg <= "10100000";			
					else 
						destination_reg <= (others => '0');--no space
					end	if;		
				end if;				
			
			when others => 
				destination_reg <= (others => '0');--no space
			end case;
	end if;
end process;
end Behavioral;