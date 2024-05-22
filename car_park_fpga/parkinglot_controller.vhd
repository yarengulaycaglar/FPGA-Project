library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity parkinglot_controller is
generic(
	total_park_space_lim : integer := 16;
	g_CLKS_PER_BIT : integer := 434;
	--c_clkfreq : integer := 20; --Low value for testbench
	c_clkfreq : integer := 50_000_000; --Real Design Value
	T0H     : real    := 0.00000035;
	T1H     : real    := 0.0000009;
	T0L     : real    := 0.0000009;
	T1L     : real    := 0.00000035;
	DEL     : real    := 0.0000001;  -- Must be bigger than others
	RES     : real    := 0.0000050
);
  Port (
  		clk					: in  STD_LOGIC;
		reset   			: in  STD_LOGIC;
		i_RX_Serial 		: in  std_logic;
		
		top_echo00			: in std_logic;
		top_echo01			: in std_logic;
		top_echo02          : in std_logic;
		top_echo03          : in std_logic;
		top_echo10          : in std_logic;
		top_echo11          : in std_logic;
		top_echo12          : in std_logic;
		top_echo13          : in std_logic;
		top_echo14          : in std_logic;
		top_echo15          : in std_logic;
		top_echo20          : in std_logic;
		top_echo21          : in std_logic;
		top_echo22          : in std_logic;
		top_echo23          : in std_logic;
		top_echo24          : in std_logic;
		top_echo25          : in std_logic;
		
		module_top_trigger_out00 	: out std_logic; 
		module_top_trigger_out01 	: out std_logic;
		module_top_trigger_out02 	: out std_logic;
		module_top_trigger_out03 	: out std_logic;
		module_top_trigger_out10 	: out std_logic;
		module_top_trigger_out11 	: out std_logic;
		module_top_trigger_out12 	: out std_logic;
		module_top_trigger_out13 	: out std_logic;
		module_top_trigger_out14 	: out std_logic;
		module_top_trigger_out15 	: out std_logic;
		module_top_trigger_out20 	: out std_logic;
		module_top_trigger_out21 	: out std_logic;
		module_top_trigger_out22 	: out std_logic;
		module_top_trigger_out23 	: out std_logic;
		module_top_trigger_out24 	: out std_logic;
		module_top_trigger_out25 	: out std_logic;		
		
		enter_LED 			: out std_logic; --on or off determined by total_park_space
		fee					: out std_logic_vector(11 downto 0);
		so     				: out std_logic;
		
		LED_0 				: out STD_LOGIC_VECTOR (6 downto 0);
		LED_1 				: out STD_LOGIC_VECTOR (6 downto 0);
		LED_2 				: out STD_LOGIC_VECTOR (6 downto 0)
  );
end parkinglot_controller;

architecture Behavioral of parkinglot_controller is

signal total_park_space : integer := total_park_space_lim;
-----------------------------------------------------------------------------
component ultrasound_module is
generic(
	total_park_space_lim : integer := 16
);
port(
	clk							: in STD_LOGIC;
	reset 						: in std_logic;
	top_echo00					: in std_logic;
	top_echo01					: in std_logic;
	top_echo02          		: in std_logic;
	top_echo03          		: in std_logic;
	top_echo10          		: in std_logic;
	top_echo11          		: in std_logic;
	top_echo12          		: in std_logic;
	top_echo13          		: in std_logic;
	top_echo14          		: in std_logic;
	top_echo15          		: in std_logic;
	top_echo20          		: in std_logic;
	top_echo21          		: in std_logic;
	top_echo22          		: in std_logic;
	top_echo23          		: in std_logic;
	top_echo24          		: in std_logic;
	top_echo25          		: in std_logic;
	module_top_trigger_out00 	: out std_logic; 
	module_top_trigger_out01 	: out std_logic;
	module_top_trigger_out02 	: out std_logic;
	module_top_trigger_out03 	: out std_logic;
	module_top_trigger_out10 	: out std_logic;
	module_top_trigger_out11 	: out std_logic;
	module_top_trigger_out12 	: out std_logic;
	module_top_trigger_out13 	: out std_logic;
	module_top_trigger_out14 	: out std_logic;
	module_top_trigger_out15 	: out std_logic;
	module_top_trigger_out20 	: out std_logic;
	module_top_trigger_out21 	: out std_logic;
	module_top_trigger_out22 	: out std_logic;
	module_top_trigger_out23 	: out std_logic;
	module_top_trigger_out24 	: out std_logic;
	module_top_trigger_out25 	: out std_logic;
	slot00_state				: out std_logic_vector(1 downto 0);--00 => empty
	slot01_state				: out std_logic_vector(1 downto 0);--01 => occupied
	slot02_state				: out std_logic_vector(1 downto 0);--10 => car entered
	slot03_state				: out std_logic_vector(1 downto 0);--11 => car left
	slot10_state				: out std_logic_vector(1 downto 0);
	slot11_state				: out std_logic_vector(1 downto 0);
	slot12_state				: out std_logic_vector(1 downto 0);
	slot13_state				: out std_logic_vector(1 downto 0);
	slot14_state				: out std_logic_vector(1 downto 0);
	slot15_state				: out std_logic_vector(1 downto 0);
	slot20_state				: out std_logic_vector(1 downto 0);
	slot21_state				: out std_logic_vector(1 downto 0);
	slot22_state				: out std_logic_vector(1 downto 0);
	slot23_state				: out std_logic_vector(1 downto 0);
	slot24_state				: out std_logic_vector(1 downto 0);
	slot25_state				: out std_logic_vector(1 downto 0);
	slot_states_total			: out std_logic_vector(15 downto 0);
	stair0			    		: out std_logic_vector(3 downto 0);
	stair1			    		: out std_logic_vector(5 downto 0);
	stair2			    		: out std_logic_vector(5 downto 0)
);

end component;
-----------------------------------------------------------------------------

--signal ultra00	: std_logic_vector(3 downto 0);--00 => kat 0 ultra 0
--signal ultra01	: std_logic_vector(3 downto 0);--01 => kat 0 ultra 1
--signal ultra02	: std_logic_vector(3 downto 0);
--signal ultra03	: std_logic_vector(3 downto 0);
--signal ultra10	: std_logic_vector(3 downto 0);
--signal ultra11	: std_logic_vector(3 downto 0);
--signal ultra12	: std_logic_vector(3 downto 0);
--signal ultra13	: std_logic_vector(3 downto 0);
--signal ultra14	: std_logic_vector(3 downto 0);
--signal ultra15	: std_logic_vector(3 downto 0);--15 => kat 1 ultra 5
--signal ultra20	: std_logic_vector(3 downto 0);
--signal ultra21	: std_logic_vector(3 downto 0);
--signal ultra22	: std_logic_vector(3 downto 0);
--signal ultra23	: std_logic_vector(3 downto 0);
--signal ultra24	: std_logic_vector(3 downto 0);
--signal ultra25	: std_logic_vector(3 downto 0);


signal slot00_state		  : std_logic_vector(1 downto 0);--00 => empty
signal slot01_state		  : std_logic_vector(1 downto 0);--01 => occupied
signal slot02_state		  : std_logic_vector(1 downto 0);--10 => car entered
signal slot03_state		  : std_logic_vector(1 downto 0);--11 => car left
signal slot10_state		  : std_logic_vector(1 downto 0);
signal slot11_state		  : std_logic_vector(1 downto 0);
signal slot12_state		  : std_logic_vector(1 downto 0);
signal slot13_state		  : std_logic_vector(1 downto 0);
signal slot14_state		  : std_logic_vector(1 downto 0);
signal slot15_state		  : std_logic_vector(1 downto 0);
signal slot20_state		  : std_logic_vector(1 downto 0);
signal slot21_state		  : std_logic_vector(1 downto 0);
signal slot22_state		  : std_logic_vector(1 downto 0);
signal slot23_state		  : std_logic_vector(1 downto 0);
signal slot24_state		  : std_logic_vector(1 downto 0);
signal slot25_state		  : std_logic_vector(1 downto 0);

signal slot_states_total  : std_logic_vector(15 downto 0);

signal stair0			  : std_logic_vector(3 downto 0);
signal stair1			  : std_logic_vector(5 downto 0);
signal stair2			  : std_logic_vector(5 downto 0);
-----------------------------------------------------------------------------
component camera_module is
Port(
	clk					: in  STD_LOGIC;
	reset   			: in  STD_LOGIC;
    o_RX_DV     		: in std_logic; --Done Flag
    o_RX_Byte   		: in std_logic_vector(31 downto 0);
	color_ID			: out std_logic_vector(23 downto 0);--8er bitten 24 bit
	stair			    : out std_logic_vector(1 downto 0);
	car_inside			: out  std_logic
);

end component;
-----------------------------------------------------------------------------
signal color_ID		: std_logic_vector(23 downto 0);--8er bitten 24 bit
signal stair		: std_logic_vector(1 downto 0);	
signal car_inside   :  std_logic;
-----------------------------------------------------------------------------
component uart_rx is --OUTPUT bir if içinde color_ID signalina atanacak
  generic (
    g_CLKS_PER_BIT : integer := 434     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic; --Done Flag
    o_RX_Byte   : out std_logic_vector(31 downto 0)
    );
end component;

signal o_RX_DV     : std_logic; --Done Flag
signal o_RX_Byte   : std_logic_vector(31 downto 0);
-----------------------------------------------------------------------------

component pl_addresser is
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
end component;

signal 	destination 	: std_logic_vector(7 downto 0);





-----------------------------------------------------------------------------

component pl_slot_chsr is
generic(
	--c_clkfreq : integer := 20 --Low value for testbench
	c_clkfreq : integer := 50_000_000 --Real Design Value
);
  Port (
  		clk					: in std_logic;
		reset 				: in std_logic;
		color_ID			: in std_logic_vector(23 downto 0);	
		destination 		: in std_logic_vector(7 downto 0);											    

		slot_states_total	: in std_logic_vector(15 downto 0);
		slot00_state		: in std_logic_vector(1 downto 0);--00 => empty
		slot01_state		: in std_logic_vector(1 downto 0);--01 => occupied
		slot02_state		: in std_logic_vector(1 downto 0);--10 => car entered
		slot03_state		: in std_logic_vector(1 downto 0);--11 => car left
		slot10_state		: in std_logic_vector(1 downto 0);
		slot11_state		: in std_logic_vector(1 downto 0);
		slot12_state		: in std_logic_vector(1 downto 0);
		slot13_state		: in std_logic_vector(1 downto 0);
		slot14_state		: in std_logic_vector(1 downto 0);
		slot15_state		: in std_logic_vector(1 downto 0);
		slot20_state		: in std_logic_vector(1 downto 0);
		slot21_state		: in std_logic_vector(1 downto 0);
		slot22_state		: in std_logic_vector(1 downto 0);
		slot23_state		: in std_logic_vector(1 downto 0);
		slot24_state		: in std_logic_vector(1 downto 0);
		slot25_state		: in std_logic_vector(1 downto 0);
		
		time_spent_s 		: out std_logic_vector(11 downto 0);--saniyesi 1kurus --dakikası 60kr
		time_spent_m 		: out std_logic_vector(5 downto 0);--saati 36tl
		time_spent_h 		: out std_logic_vector(5 downto 0);--günü 864tl
		
		car_out 			: out std_logic;
		
		last_active_slot	: out std_logic_vector(7 downto 0);
		color_ID_out		: out std_logic_vector(23 downto 0);
		slot_state_out		: out std_logic_vector(1 downto 0);
		destination_out		: out std_logic_vector(7 downto 0);
		fee_out				: out std_logic_vector(11 downto 0)
		
  );
  
end component;

signal time_spent_s 		: std_logic_vector(11 downto 0);
signal time_spent_m 		: std_logic_vector(5 downto 0);
signal time_spent_h 		: std_logic_vector(5 downto 0);
signal last_active_slot	    : std_logic_vector(7 downto 0);
signal color_ID_out		    : std_logic_vector(23 downto 0);
signal slot_state_out		: std_logic_vector(1 downto 0);
signal destination_out		: std_logic_vector(7 downto 0);
signal fee_out				: std_logic_vector(11 downto 0);
signal car_out 			    : std_logic;

------------------------------------------------

component WS2812B_SRAM is
	generic(
		-- f_clk : natural := 5000;		-- for TB
		f_clk : natural := 50000000;	-- for real
		T0H     : real    := 0.00000035;
		T1H     : real    := 0.0000009;
		T0L     : real    := 0.0000009;
		T1L     : real    := 0.00000035;
		DEL     : real    := 0.0000001;  -- Must be bigger than others
		RES     : real    := 0.0000050
	);
	port(
		clk    		: in  std_logic;
		rst_hw 		: in  std_logic;
		--btn_n  		: in  std_logic;
		slot   		: in  std_logic_vector (7 downto 0);
		color_ID	: in std_logic_vector(23 downto 0);
		so     		: out std_logic
		
	);
end component;

-------------------------------------------------

component BCD_out is
Port (  fee  	: in STD_LOGIC_VECTOR(11 downto 0);
		LED_0 	: out STD_LOGIC_VECTOR (6 downto 0);
		LED_1 	: out STD_LOGIC_VECTOR (6 downto 0);
		LED_2 	: out STD_LOGIC_VECTOR (6 downto 0)
		);
end component;


-------------------------------------------------
begin
uart_com : uart_rx 
generic map(
g_CLKS_PER_BIT => g_CLKS_PER_BIT
)
port map(
i_Clk       => clk         ,
i_RX_Serial => i_RX_Serial ,
o_RX_DV     => o_RX_DV     ,
o_RX_Byte   => o_RX_Byte   
);


camera_data : camera_module 
port map(
clk			=> clk		,		
reset   	=> reset   	,		
o_RX_DV     => o_RX_DV  ,		
o_RX_Byte   => o_RX_Byte,		
color_ID	=> color_ID	,		
stair		=> stair	,	    
car_inside	=> car_inside	
);

adresser : pl_addresser 
port map(
clk			=> 	clk			,
reset   	=> 	reset   	,
stair		=> 	stair		,
car_inside 	=> 	car_inside 	,
car_out 	=> 	car_out 	,
stair0		=> 	stair0		,
stair1		=> 	stair1		,
stair2		=> 	stair2		,
destination => 	destination 
);

memory_arrangement : pl_slot_chsr
port map(
clk					=> clk				,
reset 				=> reset 			,
color_ID			=> color_ID			,
destination 		=> destination 		,
					
slot_states_total	=> slot_states_total,
slot00_state		=> slot00_state		,
slot01_state		=> slot01_state		,
slot02_state		=> slot02_state		,
slot03_state		=> slot03_state		,
slot10_state		=> slot10_state		,
slot11_state		=> slot11_state		,
slot12_state		=> slot12_state		,
slot13_state		=> slot13_state		,
slot14_state		=> slot14_state		,
slot15_state		=> slot15_state		,
slot20_state		=> slot20_state		,
slot21_state		=> slot21_state		,
slot22_state		=> slot22_state		,
slot23_state		=> slot23_state		,
slot24_state		=> slot24_state		,
slot25_state		=> slot25_state		,
					
time_spent_s 		=> time_spent_s 	,
time_spent_m 		=> time_spent_m 	,
time_spent_h 		=> time_spent_h 	,
					
car_out 			=> car_out 			,
					
last_active_slot	=> last_active_slot	,
color_ID_out		=> color_ID_out		,
slot_state_out		=> slot_state_out	,
destination_out		=> destination_out	,
fee_out				=> fee_out			
);



led_cont : WS2812B_SRAM
generic map(
f_clk =>  c_clkfreq,
T0H   => T0H ,
T1H   => T1H ,
T0L   => T0L ,
T1L   => T1L ,
DEL   => DEL ,
RES   => RES 
)
port map(
clk    	 => clk,
rst_hw 	 => reset,
--btn_n  	 => ,
slot   	 => destination,
color_ID => color_ID,
so     	 => so
);


ultrasound_data : ultrasound_module 
generic map(
	total_park_space_lim => total_park_space_lim
)
port map(
	clk					=> clk				,
	reset 				=> reset 			,
	top_echo00			=> top_echo00		,
	top_echo01			=> top_echo01		,
	top_echo02          => top_echo02       ,
	top_echo03          => top_echo03       ,
	top_echo10          => top_echo10       ,
	top_echo11          => top_echo11       ,
	top_echo12          => top_echo12       ,
	top_echo13          => top_echo13       ,
	top_echo14          => top_echo14       ,
	top_echo15          => top_echo15       ,
	top_echo20          => top_echo20       ,
	top_echo21          => top_echo21       ,
	top_echo22          => top_echo22       ,
	top_echo23          => top_echo23       ,
	top_echo24          => top_echo24       ,
	top_echo25          => top_echo25       ,
	slot00_state		=> slot00_state		,
	slot01_state		=> slot01_state		,
	slot02_state		=> slot02_state		,
	slot03_state		=> slot03_state		,
	slot10_state		=> slot10_state		,
	slot11_state		=> slot11_state		,
	slot12_state		=> slot12_state		,
	slot13_state		=> slot13_state		,
	slot14_state		=> slot14_state		,
	slot15_state		=> slot15_state		,
	slot20_state		=> slot20_state		,
	slot21_state		=> slot21_state		,
	slot22_state		=> slot22_state		,
	slot23_state		=> slot23_state		,
	slot24_state		=> slot24_state		,
	slot25_state		=> slot25_state		,
	slot_states_total	=> slot_states_total,
	stair0			    => stair0			,
	stair1			    => stair1			,
	stair2			    => stair2			
);


seven_seg_out : BCD_out
port map(  
	fee  	=> fee_out  ,
	LED_0 	=> LED_0,
	LED_1 	=> LED_1,
	LED_2 	=> LED_2
);






process(slot_states_total)
begin
	if(slot_states_total = "1111111111111111") then
		enter_LED <= '1';
	else
		enter_LED <= '0';
	end if;
end process;


end Behavioral;