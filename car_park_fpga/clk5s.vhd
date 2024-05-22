library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity clk5S is
generic(
	c_clkfreq : integer := 5000 --Low value for testbench
	--c_clkfreq : integer := 50_000_000 --Real Design Value
);
port(
	clk 	: in std_logic;
	enable   : in  STD_LOGIC;
	out_5s    : out std_logic
);
end clk5s;

architecture Behavioral of clk5S is

constant  c_timer2slim : integer := c_clkfreq*5;
signal timer       	: integer range 0 to c_timer2slim := 0;
signal timerlim    	: integer := c_timer2slim;
signal t_2s_hold	: std_logic := '0';

begin
process(clk) begin 
if (rising_edge(clk)) then 
	if(enable = '0') then
		t_2s_hold <= '0';
	else
		if(timer >= timerlim-1) then
			t_2s_hold <= not(t_2s_hold);
			timer <= 0;
		else
			timer <= timer+1;
	
		end if;
	end if;
	
end if;
end process;

out_5s <= t_2s_hold;

end Behavioral;