library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pl_timer is
generic(
	--c_clkfreq : integer := 20 --Low value for testbench
	c_clkfreq : integer := 50_000_000 --Real Design Value
);
  Port (
  		clk				: in  std_logic;
		car_inside		: in std_logic;	
		time_spent_s 	: out std_logic_vector(11 downto 0);--saniyesi 1kurus --dakikası 60kr
		time_spent_m 	: out std_logic_vector(5 downto 0);--saati 36tl
		time_spent_h 	: out std_logic_vector(5 downto 0)--günü 864tl
  );
end pl_timer;

architecture Behavioral of pl_timer is

constant  c_timer1seclim : integer := c_clkfreq;
constant  c_timer1mlim 	 : integer := 60;
constant  c_timer1hlim   : integer := 60;

signal timer_s       : integer range 0 to c_timer1seclim := 0;
signal timer_m       : integer range 0 to c_timer1mlim := 0;
signal timer_h       : integer range 0 to c_timer1hlim := 0;

signal timerlim_s    : integer range 0 to c_timer1seclim := 0;
signal timerlim_m    : integer range 0 to c_timer1seclim := 0;
signal timerlim_h    : integer range 0 to c_timer1seclim := 0;

signal counter_int_s : std_logic_vector(11 downto 0) := (others => '0');
signal counter_int_m : std_logic_vector(5 downto 0) := (others => '0');
signal counter_int_h : std_logic_vector(5 downto 0) := (others => '0');


begin

process(clk,car_inside) begin 
if(car_inside = '1') then
	if (rising_edge(clk)) then 
		if(timer_s >= timer_s-1) then
			counter_int_s <= counter_int_s+1;
			timer_s <= 0;
			if(timer_m >= timer_m-1) then 
				counter_int_m <= counter_int_m+1;
				timer_m <= 0;
				if(timer_h >= timer_h-1) then 
					counter_int_h <= counter_int_h+1;
					timer_h <= 0;
				else
					timer_h <= timer_h+1;
				end if;
			else
				timer_m <= timer_m+1;
			end if;
		else
			timer_s <= timer_s+1;
		end if;
	end if;
else 
counter_int_s <= (others => '0');
counter_int_m <= (others => '0');
counter_int_h <= (others => '0');
timer_s		  <= 0;	
timer_m       <= 0;
timer_h       <= 0;

end if;
end process;	

time_spent_s <= counter_int_s;
time_spent_m <= counter_int_m; 
time_spent_h <= counter_int_h;


end Behavioral;