library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity camera_module is
Port(
	clk					: in  STD_LOGIC;
	reset   			: in  STD_LOGIC;
    o_RX_DV     		: in std_logic; --Done Flag
    o_RX_Byte   		: in std_logic_vector(31 downto 0);
	color_ID			: out std_logic_vector(23 downto 0);--8er bitten 24 bit
	stair			    : out std_logic_vector(1 downto 0);
	car_inside			: out  std_logic
);

end camera_module;


architecture Behavioral of camera_module is
  
signal o_RX_Byte_reg  : std_logic_vector(31 downto 0);
signal o_RX_DV_reg    :  std_logic; --Done Flag

begin
process(o_RX_DV,reset) begin

	if(reset = '1') then
		
		o_RX_DV_reg    <= '0';
		o_RX_Byte_reg  <= (others => '0'); 
		car_inside <= '0';
		
	elsif(o_RX_DV = '1') then
		o_RX_Byte_reg <= o_RX_Byte;
		car_inside <= '1';
	else
		car_inside <= '0';
		
	end if;

end process;

color_ID <= o_RX_Byte_reg(31 downto 8);
stair	   <= o_RX_Byte_reg(1 downto 0);


end Behavioral;