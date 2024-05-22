library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ultrasound_dis_cal is
	Port(
	clk		   	: in STD_LOGIC;
	cal_res    	: in STD_LOGIC;
	pulse     	: in STD_LOGIC;
	distance	: out STD_LOGIC_vector(8 downto 0)
	);
end ultrasound_dis_cal;

architecture Behavioral of ultrasound_dis_cal is


component ultrasound_counter is
    generic(n : positive := 22);
	Port(
	clk		   	: in STD_LOGIC;
	enable     	: in STD_LOGIC;
	reset      	: in STD_LOGIC; -- This is an -active low- signal.
	counter_out	: out STD_LOGIC_vector(n-1 downto 0)
	);
end component;
signal pulse_width : STD_LOGIC_VECTOR(21 downto 0);
signal s_cal_res : std_logic;
begin
s_cal_res <= not(cal_res);
counter_pulse : ultrasound_counter

port map(
	clk    => clk,
	enable => pulse,
	reset  => s_cal_res, 
	counter_out => pulse_width
); 


distance_calculation : process(pulse)
	variable Result : integer;
	variable multiplier : STD_LOGIC_VECTOR(23 downto 0);
	
	begin
		if(pulse = '0') then
			multiplier := pulse_width * "11";
			Result := to_integer(unsigned(multiplier(23 downto 13)));
				if(Result > 458) then
					distance <= "111111111";
				else
					distance <= std_logic_vector(to_unsigned(result,9));
									
				end if;
		end if;
    end process;


end Behavioral;