library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pl_slot_memory_reg is
generic(
	--c_clkfreq : integer := 20 --Low value for testbench
	c_clkfreq : integer := 50_000_000 --Real Design Value
);
  Port (
  		clk					: in STD_LOGIC;
		reset   			: in STD_LOGIC;
		car_out 			: in std_logic;
		color_ID			: in std_logic_vector(23 downto 0);	
		slot_state			: in std_logic_vector(1 downto 0);
		destination 		: in std_logic_vector(7 downto 0);													    
		--car_place_right 	: in std_logic;
		
		time_spent_s 		: out std_logic_vector(11 downto 0);--saniyesi 1kurus --dakikası 60kr
		time_spent_m 		: out std_logic_vector(5 downto 0);--saati 36tl
		time_spent_h 		: out std_logic_vector(5 downto 0);--günü 864tl
		
		color_ID_out		: out std_logic_vector(23 downto 0);	
		destination_out		: out std_logic_vector(7 downto 0);												    
		--car_place_right_out : out std_logic; --DAHA SONRA ZAMAN OLURSA YAZILABİLİR
		fee					: out std_logic_vector(11 downto 0)			
  );
end pl_slot_memory_reg;

architecture Behavioral of pl_slot_memory_reg is

signal car_out_reg 			: std_logic;
signal slot_state_reg		: std_logic_vector(1 downto 0);
signal color_ID_reg		    : std_logic_vector(23 downto 0);	
signal destination_reg   	: std_logic_vector(7 downto 0);
--signal car_place_right_reg  : std_logic;
signal fee_reg			    : std_logic_vector(11 downto 0);
--signal fee_punishment_reg   : std_logic_vector(11 downto 0);
--signal fee_total_reg		: std_logic_vector(12 downto 0);


component pl_timer is
generic(
	--c_clkfreq : integer := 20 --Low value for testbench
	c_clkfreq : integer := 50_000_000 --Real Design Value
);
  Port (
  		clk				: in  std_logic;
		car_inside		: in  std_logic;	
		time_spent_s 	: out std_logic_vector(11 downto 0);--saniyesi 1kurus --dakikası 60kr
		time_spent_m 	: out std_logic_vector(5 downto 0);--saati 36tl
		time_spent_h 	: out std_logic_vector(5 downto 0)--günü 864tl
  );
end component;

signal car_inside	: std_logic;
signal time_spent_s_reg	: std_logic_vector(11 downto 0);--saniyesi 1kurus --dakikası 60kr

begin

slot_timer: pl_timer
generic map(
c_clkfreq => c_clkfreq
)
port map(
clk			 => clk				 ,	
car_inside	 => car_inside		 ,	
time_spent_s => time_spent_s_reg , 	
time_spent_m => time_spent_m 	 , 	
time_spent_h => time_spent_h 	  	
);


process(clk,reset) begin 

if(reset = '0') then

	slot_state_reg		<= (others => '0');
	color_ID_reg		<= (others => '0'); 
	destination_reg 	<= (others => '0');
	--car_place_right_reg <= '0'; 
	fee_reg			    <= (others => '0');
	--fee_punishment_reg  <= (others => '0'); 
	--fee_total_reg		<= (others => '0');
else
	if (rising_edge(clk)) then 

		slot_state_reg		<= slot_state		;
		color_ID_reg		<= color_ID			;
		destination_reg 	<= destination 		;
		--car_place_right_reg <= car_place_right;
		fee_reg			    <= time_spent_s_reg		;
		if(car_out = '0') then
			car_inside <= '1';
		else 
			car_inside <= '0';
		end if;
	end if;
	
end if;
end process;


color_ID_out		<= color_ID_reg		    ;
destination_out 	<= destination_reg 		;
--car_place_right_out <= car_place_right_reg;
fee					<= fee_reg	;
time_spent_s    <= fee_reg;
end Behavioral;