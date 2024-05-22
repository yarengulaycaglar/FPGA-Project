library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ultrasound_module is
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

end entity;

architecture arch of ultrasound_module is 
-- TRIGGER
SIGNAL s_module_top_trigger_out00 : STD_LOGIC;
SIGNAL s_module_top_trigger_out01 : STD_LOGIC;
SIGNAL s_module_top_trigger_out02 : STD_LOGIC;
SIGNAL s_module_top_trigger_out03 : STD_LOGIC;
SIGNAL s_module_top_trigger_out10 : STD_LOGIC;
SIGNAL s_module_top_trigger_out11 : STD_LOGIC;
SIGNAL s_module_top_trigger_out12 : STD_LOGIC;
SIGNAL s_module_top_trigger_out13 : STD_LOGIC;
SIGNAL s_module_top_trigger_out14 : STD_LOGIC;
SIGNAL s_module_top_trigger_out15 : STD_LOGIC;
SIGNAL s_module_top_trigger_out20 : STD_LOGIC;
SIGNAL s_module_top_trigger_out21 : STD_LOGIC;
SIGNAL s_module_top_trigger_out22 : STD_LOGIC;
SIGNAL s_module_top_trigger_out23 : STD_LOGIC;
SIGNAL s_module_top_trigger_out24 : STD_LOGIC;
SIGNAL s_module_top_trigger_out25 : STD_LOGIC;


--FSM 
type state_type00 is (IDLE00,occupied00,car_entered00,car_left00);
type state_type01 is (IDLE01,occupied01,car_entered01,car_left01);
type state_type02 is (IDLE02,occupied02,car_entered02,car_left02);
type state_type03 is (IDLE03,occupied03,car_entered03,car_left03);
type state_type10 is (IDLE10,occupied10,car_entered10,car_left10);
type state_type11 is (IDLE11,occupied11,car_entered11,car_left11);
type state_type12 is (IDLE12,occupied12,car_entered12,car_left12);
type state_type13 is (IDLE13,occupied13,car_entered13,car_left13);
type state_type14 is (IDLE14,occupied14,car_entered14,car_left14);
type state_type15 is (IDLE15,occupied15,car_entered15,car_left15);
type state_type20 is (IDLE20,occupied20,car_entered20,car_left20);
type state_type21 is (IDLE21,occupied21,car_entered21,car_left21);
type state_type22 is (IDLE22,occupied22,car_entered22,car_left22);
type state_type23 is (IDLE23,occupied23,car_entered23,car_left23);
type state_type24 is (IDLE24,occupied24,car_entered24,car_left24);
type state_type25 is (IDLE25,occupied25,car_entered25,car_left25);
signal state_now00, state_next00 : state_type00;
signal state_now01, state_next01 : state_type01;
signal state_now02, state_next02 : state_type02;
signal state_now03, state_next03 : state_type03;
signal state_now10, state_next10 : state_type10;
signal state_now11, state_next11 : state_type11;
signal state_now12, state_next12 : state_type12;
signal state_now13, state_next13 : state_type13;
signal state_now14, state_next14 : state_type14;
signal state_now15, state_next15 : state_type15;
signal state_now20, state_next20 : state_type20;
signal state_now21, state_next21 : state_type21;
signal state_now22, state_next22 : state_type22;
signal state_now23, state_next23 : state_type23;
signal state_now24, state_next24 : state_type24;
signal state_now25, state_next25 : state_type25;

--
SIGNAL LEFT5_00 : STD_LOGIC;
SIGNAL LEFT5_01 : STD_LOGIC;
SIGNAL LEFT5_02 : STD_LOGIC;
SIGNAL LEFT5_03 : STD_LOGIC;
SIGNAL LEFT5_10 : STD_LOGIC;
SIGNAL LEFT5_11 : STD_LOGIC;
SIGNAL LEFT5_12 : STD_LOGIC;
SIGNAL LEFT5_13 : STD_LOGIC;
SIGNAL LEFT5_14 : STD_LOGIC;
SIGNAL LEFT5_15 : STD_LOGIC;
SIGNAL LEFT5_20 : STD_LOGIC;
SIGNAL LEFT5_21 : STD_LOGIC;
SIGNAL LEFT5_22 : STD_LOGIC;
SIGNAL LEFT5_23 : STD_LOGIC;
SIGNAL LEFT5_24 : STD_LOGIC;
SIGNAL LEFT5_25 : STD_LOGIC;
--


--
SIGNAL LEFTER00 : STD_LOGIC;
SIGNAL LEFTER01 : STD_LOGIC;
SIGNAL LEFTER02 : STD_LOGIC;
SIGNAL LEFTER03 : STD_LOGIC;
SIGNAL LEFTER10 : STD_LOGIC;
SIGNAL LEFTER11 : STD_LOGIC;
SIGNAL LEFTER12 : STD_LOGIC;
SIGNAL LEFTER13 : STD_LOGIC;
SIGNAL LEFTER14 : STD_LOGIC;
SIGNAL LEFTER15 : STD_LOGIC;
SIGNAL LEFTER20 : STD_LOGIC;
SIGNAL LEFTER21 : STD_LOGIC;
SIGNAL LEFTER22 : STD_LOGIC;
SIGNAL LEFTER23 : STD_LOGIC;
SIGNAL LEFTER24 : STD_LOGIC;
SIGNAL LEFTER25 : STD_LOGIC;


--

component clk5S is
generic(
	c_clkfreq : integer := 5000 --Low value for testbench
	--c_clkfreq : integer := 50_000_000 --Real Design Value
);
port(
	clk 		: in std_logic;
	enable   	: in  STD_LOGIC;
	out_5s    	: out std_logic
);
end component;


component ultrasound_top is port(
	clk 			: in  stD_logic;
	echo00			: in  std_logic;		
	echo01			: in  std_logic;		
	echo02			: in  std_logic;		
	echo03			: in  std_logic;		
	echo10			: in  std_logic;		
	echo11			: in  std_logic;
	echo12			: in  std_logic;
	echo13			: in  std_logic;
	echo14			: in  std_logic;
	echo15			: in  std_logic;
	echo20			: in  std_logic;
	echo21			: in  std_logic;
	echo22			: in  std_logic;
	echo23			: in  std_logic;
	echo24			: in  std_logic;
	echo25			: in  std_logic;
	top_trigger_out00 	: out std_logic;
	top_trigger_out01 	: out std_logic;
	top_trigger_out02 	: out std_logic;
	top_trigger_out03 	: out std_logic;
	top_trigger_out10 	: out std_logic;
	top_trigger_out11 	: out std_logic;
	top_trigger_out12 	: out std_logic;
	top_trigger_out13 	: out std_logic;
	top_trigger_out14 	: out std_logic;
	top_trigger_out15 	: out std_logic;
	top_trigger_out20 	: out std_logic;
	top_trigger_out21 	: out std_logic;
	top_trigger_out22 	: out std_logic;
	top_trigger_out23 	: out std_logic;
	top_trigger_out24 	: out std_logic;
	top_trigger_out25 	: out std_logic;
	total_out00 	: out std_logic_vector(8 downto 0);
	total_out01 	: out std_logic_vector(8 downto 0);
	total_out02 	: out std_logic_vector(8 downto 0);
	total_out03 	: out std_logic_vector(8 downto 0);
	total_out10 	: out std_logic_vector(8 downto 0);
	total_out11 	: out std_logic_vector(8 downto 0);
	total_out12 	: out std_logic_vector(8 downto 0);
	total_out13 	: out std_logic_vector(8 downto 0);
	total_out14 	: out std_logic_vector(8 downto 0);
	total_out15 	: out std_logic_vector(8 downto 0);
	total_out20 	: out std_logic_vector(8 downto 0);
	total_out21 	: out std_logic_vector(8 downto 0);
	total_out22 	: out std_logic_vector(8 downto 0);
	total_out23 	: out std_logic_vector(8 downto 0);
	total_out24 	: out std_logic_vector(8 downto 0);
	total_out25 	: out std_logic_vector(8 downto 0));
	
end component;

--signal s_top_trigger_out 	: std_logic;
signal s_total_out00 		: std_logic_vector(8 downto 0);
signal s_total_out01 		: std_logic_vector(8 downto 0);
signal s_total_out02 		: std_logic_vector(8 downto 0);
signal s_total_out03 		: std_logic_vector(8 downto 0);
signal s_total_out10 		: std_logic_vector(8 downto 0);		
signal s_total_out11 		: std_logic_vector(8 downto 0);
signal s_total_out12 		: std_logic_vector(8 downto 0);	
signal s_total_out13 		: std_logic_vector(8 downto 0);	
signal s_total_out14 		: std_logic_vector(8 downto 0);		
signal s_total_out15 		: std_logic_vector(8 downto 0);		
signal s_total_out20 		: std_logic_vector(8 downto 0);		
signal s_total_out21 		: std_logic_vector(8 downto 0);		
signal s_total_out22 		: std_logic_vector(8 downto 0);		
signal s_total_out23 		: std_logic_vector(8 downto 0);		
signal s_total_out24 		: std_logic_vector(8 downto 0);				
signal s_total_out25 		: std_logic_vector(8 downto 0);	
--
signal s_slot00_state			: std_logic_vector(1 downto 0);--00 => empty
signal s_slot01_state		    : std_logic_vector(1 downto 0);--01 => occupied
signal s_slot02_state		    : std_logic_vector(1 downto 0);--10 => car entered
signal s_slot03_state		    : std_logic_vector(1 downto 0);--11 => car left
signal s_slot10_state		    : std_logic_vector(1 downto 0);
signal s_slot11_state		    : std_logic_vector(1 downto 0);
signal s_slot12_state		    : std_logic_vector(1 downto 0);
signal s_slot13_state		    : std_logic_vector(1 downto 0);
signal s_slot14_state		    : std_logic_vector(1 downto 0);
signal s_slot15_state		    : std_logic_vector(1 downto 0);
signal s_slot20_state		    : std_logic_vector(1 downto 0);
signal s_slot21_state		    : std_logic_vector(1 downto 0);
signal s_slot22_state		    : std_logic_vector(1 downto 0);
signal s_slot23_state		    : std_logic_vector(1 downto 0);
signal s_slot24_state		    : std_logic_vector(1 downto 0);
signal s_slot25_state		    : std_logic_vector(1 downto 0);
signal s_slot_states_total	: std_logic_vector(15 downto 0);
signal s_car_out 			    : std_logic;
signal s_stair0			    : std_logic_vector(3 downto 0);
signal s_stair1			    : std_logic_vector(5 downto 0);
signal s_stair2			    : std_logic_vector(5 downto 0);

--ara sinyaller
signal pre_00 : std_logic;
signal pre_01 : std_logic;
signal pre_02 : std_logic;
signal pre_03 : std_logic;
signal pre_10 : std_logic;
signal pre_11 : std_logic;
signal pre_12 : std_logic;
signal pre_13 : std_logic;
signal pre_14 : std_logic;
signal pre_15 : std_logic;
signal pre_20 : std_logic;
signal pre_21 : std_logic;
signal pre_22 : std_logic;
signal pre_23 : std_logic;
signal pre_24 : std_logic;
signal pre_25 : std_logic;

-- CLOCK 5SN SAYDI MI?

signal out5s_00 : std_logic;
signal out5s_01 : std_logic;
signal out5s_02 : std_logic;
signal out5s_03 : std_logic;
signal out5s_10 : std_logic;
signal out5s_11 : std_logic;
signal out5s_12 : std_logic;
signal out5s_13 : std_logic;
signal out5s_14 : std_logic;
signal out5s_15 : std_logic;
signal out5s_20 : std_logic;
signal out5s_21 : std_logic;
signal out5s_22 : std_logic;
signal out5s_23 : std_logic;
signal out5s_24 : std_logic;
signal out5s_25 : std_logic;

-- OCCUPIED CLOCK 5 SN SAYDI MI?
SIGNAL LONG00 : STD_LOGIC;
SIGNAL LONG01 : STD_LOGIC;
SIGNAL LONG02 : STD_LOGIC;
SIGNAL LONG03 : STD_LOGIC;
SIGNAL LONG10 : STD_LOGIC;
SIGNAL LONG11 : STD_LOGIC;
SIGNAL LONG12 : STD_LOGIC;
SIGNAL LONG13 : STD_LOGIC;
SIGNAL LONG14 : STD_LOGIC;
SIGNAL LONG15 : STD_LOGIC;
SIGNAL LONG20 : STD_LOGIC;
SIGNAL LONG21 : STD_LOGIC;
SIGNAL LONG22 : STD_LOGIC;
SIGNAL LONG23 : STD_LOGIC;
SIGNAL LONG24 : STD_LOGIC;
SIGNAL LONG25 : STD_LOGIC;

SIGNAL LEFT500: stD_logic;
SIGNAL LEFT501: stD_logic;
SIGNAL LEFT502: stD_logic;
SIGNAL LEFT503: stD_logic;
SIGNAL LEFT510: stD_logic;
SIGNAL LEFT511: stD_logic;
SIGNAL LEFT512: stD_logic;
SIGNAL LEFT513: stD_logic;
SIGNAL LEFT514: stD_logic;
SIGNAL LEFT515: stD_logic;
SIGNAL LEFT520: stD_logic;
SIGNAL LEFT521: stD_logic;
SIGNAL LEFT522: stD_logic;
SIGNAL LEFT523: stD_logic;
SIGNAL LEFT524: stD_logic;
SIGNAL LEFT525: stD_logic;

-- CAR LEFT 5 SN SAYDI MI? 

SIGNAL C_00: STD_LOGIC;
SIGNAL C_01: STD_LOGIC;
SIGNAL C_02: STD_LOGIC;
SIGNAL C_03: STD_LOGIC;
SIGNAL C_10: STD_LOGIC;
SIGNAL C_11: STD_LOGIC;
SIGNAL C_12: STD_LOGIC;
SIGNAL C_13: STD_LOGIC;
SIGNAL C_14: STD_LOGIC;
SIGNAL C_15: STD_LOGIC;
SIGNAL C_20: STD_LOGIC;
SIGNAL C_21: STD_LOGIC;
SIGNAL C_22: STD_LOGIC;
SIGNAL C_23: STD_LOGIC;
SIGNAL C_24: STD_LOGIC;
SIGNAL C_25: STD_LOGIC;

SIGNAL LEFTER500: stD_logic;
SIGNAL LEFTER501: stD_logic;
SIGNAL LEFTER502: stD_logic;
SIGNAL LEFTER503: stD_logic;
SIGNAL LEFTER510: stD_logic;
SIGNAL LEFTER511: stD_logic;
SIGNAL LEFTER512: stD_logic;
SIGNAL LEFTER513: stD_logic;
SIGNAL LEFTER514: stD_logic;
SIGNAL LEFTER515: stD_logic;
SIGNAL LEFTER520: stD_logic;
SIGNAL LEFTER521: stD_logic;
SIGNAL LEFTER522: stD_logic;
SIGNAL LEFTER523: stD_logic;
SIGNAL LEFTER524: stD_logic;
SIGNAL LEFTER525: stD_logic;





	


begin

ct00 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_00, 	
        out_5s	=> out5s_00);
ct01 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_01, 	
        out_5s	=> out5s_01);
ct02 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_02, 	
        out_5s	=> out5s_02);
ct03 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_03, 	
        out_5s	=> out5s_03);
ct10 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_10, 	
        out_5s	=> out5s_10); 
ct11 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_11, 	
        out_5s	=> out5s_11);
ct12 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_12, 	
        out_5s	=> out5s_12);
ct13 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_13, 	
        out_5s	=> out5s_13);
ct14 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_14, 	
        out_5s	=> out5s_14);
ct15 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_15, 	
        out_5s	=> out5s_15);
ct20 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_20, 	
        out_5s	=> out5s_20);
ct21 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_21, 	
        out_5s	=> out5s_21);
ct22 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_22, 	
        out_5s	=> out5s_22);
ct23 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_23, 	
        out_5s	=> out5s_23);
ct24 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_24, 	
        out_5s	=> out5s_24);
ct25 : clk5S port map(
		clk 	=> clk,	
		enable  => pre_25, 	
        out_5s	=> out5s_25);
		
------- OCCUPIED CLOCK


OC00 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG00, 	
        out_5s	=> LEFT500);
OC01 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG00, 	
        out_5s	=> LEFT501);
OC02 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG02, 	
        out_5s	=> LEFT502);
OC03 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG03, 	
        out_5s	=> LEFT503);
OC10 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG10, 	
        out_5s	=> LEFT510);		
OC11 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG11, 	
        out_5s	=> LEFT511);
OC12 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG12, 	
        out_5s	=> LEFT512);
OC13 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG13, 	
        out_5s	=> LEFT513);
OC14 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG14, 	
        out_5s	=> LEFT514);
OC15 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG15, 	
        out_5s	=> LEFT515);
OC20 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG20, 	
        out_5s	=> LEFT5_20);

OC21 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG21, 	
        out_5s	=> LEFT5_21);
OC22 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG22, 	
        out_5s	=> LEFT5_22);
OC23 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG23, 	
        out_5s	=> LEFT5_23);
OC24 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG24, 	
        out_5s	=> LEFT5_24);
OC25 : clk5S port map(
		clk 	=> clk,	
		enable  => LONG25, 	
        out_5s	=> LEFT5_25);


--------------- CAR LEFT 5 SN


CL00 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER00, 	
        out_5s	=> C_00		);
CL01 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER01, 	
        out_5s	=> C_01);
CL02 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER02,
        out_5s	=> C_02);
CL03 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER03,
        out_5s	=> C_03);
CL10 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER10,
        out_5s	=> C_10); 
CL11 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER11,
        out_5s	=> C_11);
CL12 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER12,
        out_5s	=> C_12);
CL13 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER13,
        out_5s	=> C_13);
CL14 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER14,
        out_5s	=> C_14);
CL15 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER15,
        out_5s	=> C_15);
CL20 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER20,
        out_5s	=> C_20);
CL21 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER21,
        out_5s	=> C_21);
CL22 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER22,
        out_5s	=> C_22);
CL23 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER23,
        out_5s	=> C_23);
CL24 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER24,
        out_5s	=> C_24);
CL25 : clk5S port map(
		clk 	=> clk,	
		enable  => LEFTER25,
        out_5s	=> C_25);




		
uut :  ultrasound_top port map(
			clk 	 					=> clk,		
		    echo00						=> top_echo00,
		    echo01			    		=> top_echo01,
		    echo02			    		=> top_echo02,
		    echo03			    		=> top_echo03,
		    echo10			    		=> top_echo10,
		    echo11			    		=> top_echo11,
		    echo12			    		=> top_echo12,
		    echo13			    		=> top_echo13,
		    echo14			    		=> top_echo14,
		    echo15			    		=> top_echo15,
		    echo20			    		=> top_echo20,
		    echo21			    		=> top_echo21,
		    echo22			    		=> top_echo22,
		    echo23			    		=> top_echo23,
		    echo24			    		=> top_echo24,
            echo25			    		=> top_echo25,
            top_trigger_out00	 => s_module_top_trigger_out00,
            top_trigger_out01    => s_module_top_trigger_out01,
            top_trigger_out02    => s_module_top_trigger_out02,
            top_trigger_out03    => s_module_top_trigger_out03,
            top_trigger_out10    => s_module_top_trigger_out10,
            top_trigger_out11    => s_module_top_trigger_out11,
            top_trigger_out12    => s_module_top_trigger_out12,
            top_trigger_out13    => s_module_top_trigger_out13,
            top_trigger_out14    => s_module_top_trigger_out14,
            top_trigger_out15    => s_module_top_trigger_out15,
            top_trigger_out20    => s_module_top_trigger_out20,
            top_trigger_out21    => s_module_top_trigger_out21,
            top_trigger_out22    => s_module_top_trigger_out22,
            top_trigger_out23    => s_module_top_trigger_out23,
            top_trigger_out24    => s_module_top_trigger_out24,
            top_trigger_out25    => s_module_top_trigger_out25,
            total_out00 	    		=> s_total_out00 	,
            total_out01 	    		=> s_total_out01 	,
            total_out02 	    		=> s_total_out02 	,
            total_out03 	    		=> s_total_out03 	,
            total_out10 	    		=> s_total_out10 	,
            total_out11 	    		=> s_total_out11 	,
            total_out12 	    		=> s_total_out12 	,
            total_out13 	    		=> s_total_out13 	,
            total_out14 	    		=> s_total_out14 	,
            total_out15 	    		=> s_total_out15 	,
            total_out20 	    		=> s_total_out20 	,
            total_out21 	    		=> s_total_out21 	,
            total_out22 	    		=> s_total_out22 	,
            total_out23 	    		=> s_total_out23 	,
            total_out24 	    		=> s_total_out24 	,
            total_out25 	    		=> s_total_out25 	);


process(s_total_out00,s_total_out01,s_total_out02,s_total_out03,s_total_out10,s_total_out11,s_total_out12,
s_total_out13,s_total_out14,s_total_out15,s_total_out20,s_total_out21,s_total_out22,s_total_out23,s_total_out24,s_total_out25)
begin
	if(s_total_out00 <= "000001100") then 
		pre_00 <= '1';
	else 
		pre_00 <= '0';
	end if;
	if(s_total_out01 <= "000001100") then 
		pre_01 <= '1';
	else 
		pre_01 <= '0';
	end if;
	if(s_total_out02 <= "000001100") then 
		pre_02 <= '1';
	else 
		pre_02 <= '0';
	end if;
	if(s_total_out03 <= "000001100") then 
		pre_03 <= '1';
	else 
		pre_03 <= '0';
	end if;
	if(s_total_out10 <= "000001100") then 
		pre_10 <= '1';
	else 
		pre_10 <= '0';
	end if;
	if(s_total_out11 <= "000001100") then 
		pre_11 <= '1';
	else 
		pre_11 <= '0';
	end if;
	if(s_total_out12 <= "000001100") then 
		pre_12 <= '1';
	else 
		pre_12 <= '0';
	end if;
	if(s_total_out13 <= "000001100") then 
		pre_13 <= '1';
	else 
		pre_13 <= '0';
	end if;
	if(s_total_out14 <= "000001100") then 
		pre_14 <= '1';
	else 
		pre_14 <= '0';
	end if;
	if(s_total_out15 <= "000001100") then 
		pre_15 <= '1';
	else 
		pre_15 <= '0';
	end if;
	if(s_total_out20 <= "000001100") then 
		pre_20 <= '1';
	else 
		pre_20 <= '0';
	end if;
	if(s_total_out21 <= "000001100") then 
		pre_21 <= '1';
	else 
		pre_21 <= '0';
	end if;
	if(s_total_out22 <= "000001100") then 
		pre_22 <= '1';
	else 
		pre_22 <= '0';
	end if;
	if(s_total_out23 <= "000001100") then 
		pre_23 <= '1';
	else 
		pre_23 <= '0';
	end if;
	if(s_total_out24 <= "000001100") then 
		pre_24 <= '1';
	else 
		pre_24 <= '0';
	end if;
	if(s_total_out25 <= "000001100") then 
		pre_25 <= '1';
	else 
		pre_25 <= '0';
	end if;
	
end process;

process(s_total_out00,s_total_out01,s_total_out02,s_total_out03,s_total_out10,s_total_out11,s_total_out12,
s_total_out13,s_total_out14,s_total_out15,s_total_out20,s_total_out21,s_total_out22,s_total_out23,s_total_out24,s_total_out25)
begin
	if(s_total_out00 >= "000001100") then 
		LONG00 <= '1';
	else 
		LONG00 <= '0';
	end if;
	if(s_total_out01 >= "000001100") then 
		LONG01 <= '1';
	else 
		LONG01 <= '0';
	end if;
	if(s_total_out02 >= "000001100") then 
		LONG02 <= '1';
	else 
		LONG02 <= '0';
	end if;
	if(s_total_out03 >= "000001100") then 
		LONG03 <= '1';
	else 
		LONG03 <= '0';
	end if;
	if(s_total_out10 >= "000001100") then 
		LONG10 <= '1';
	else 
		LONG10 <= '0';
	end if;
	if(s_total_out11 >= "000001100") then 
		LONG11 <= '1';
	else 
		LONG11 <= '0';
	end if;
	if(s_total_out12 >= "000001100") then 
		LONG12 <= '1';
	else 
		LONG12 <= '0';
	end if;
	if(s_total_out13 >= "000001100") then 
		LONG13 <= '1';
	else 
		LONG13 <= '0';
	end if;
	if(s_total_out14 >= "000001100") then 
		LONG14 <= '1';
	else 
		LONG14 <= '0';
	end if;
	if(s_total_out15 >= "000001100") then 
		LONG15 <= '1';
	else 
		LONG15 <= '0';
	end if;
	if(s_total_out20 >= "000001100") then 
		LONG20 <= '1';
	else 
		LONG20 <= '0';
	end if;
	if(s_total_out21 >= "000001100") then 
		LONG21 <= '1';
	else 
		LONG21 <= '0';
	end if;
	if(s_total_out22 >= "000001100") then 
		LONG22 <= '1';
	else 
		LONG22 <= '0';
	end if;
	if(s_total_out23 >= "000001100") then 
		LONG23 <= '1';
	else 
		LONG23 <= '0';
	end if;
	if(s_total_out24 >= "000001100") then 
		LONG24 <= '1';
	else 
		LONG24 <= '0';
	end if;
	if(s_total_out25 >= "000001100") then 
		LONG25 <= '1';
	else 
		LONG25 <= '0';
	end if;
	
end process;

process(clk)
begin 
if(rising_edge(clk)) then 
	if(reset = '1') then 
		state_now00 <= IDLE00;
		state_now01 <= IDLE01;
		state_now02 <= IDLE02;
		state_now03 <= IDLE03;
		state_now10 <= IDLE10;
		state_now11 <= IDLE11;
		state_now12 <= IDLE12;
		state_now13 <= IDLE13;
		state_now14 <= IDLE14;
		state_now15 <= IDLE15;
		state_now20 <= IDLE20;
		state_now21 <= IDLE21;
		state_now22 <= IDLE22;
		state_now23 <= IDLE23;
		state_now24 <= IDLE24;
		state_now25 <= IDLE25;
		
	else	
		state_now00 <= state_next00;
		state_now01 <= state_next01;
		state_now02 <= state_next02;
		state_now03 <= state_next03;
		state_now10 <= state_next10;
		state_now11 <= state_next11;
		state_now12 <= state_next12;
		state_now13 <= state_next13;
		state_now14 <= state_next14;
		state_now15 <= state_next15;
		state_now20 <= state_next20;
		state_now21 <= state_next21;
		state_now22 <= state_next22;
		state_now23 <= state_next23;
		state_now24 <= state_next24;
		state_now25 <= state_next25;
	end if;
	
end if;
end process;

process(state_now00,out5s_00)
begin
case state_now00 is 
	when IDLE00 => 
		s_slot00_state <= "00";
		slot_states_total(0) 	<= '0'; 
		stair0(0) 				<= '0';
		if(out5s_00 = '1') then 
			--s_slot00_state <= "10";
			state_next00 <= car_entered00;
		else 
			state_next00 <= IDLE00;
		end if;
	when car_entered00 => 
		s_slot00_state <= "10";
		state_next00 <= occupied00;

	when occupied00 => 
		s_slot00_state 			<= "01";
		slot_states_total(0) 	<= '1'; 
		stair0(0) 				<= '1';			 
		
		IF(LEFT500 = '1') THEN 
			state_next00 <= car_left00;
		else 
			state_next00 <= occupied00;
		END IF;
	when car_left00 => 
		s_slot00_state <= "11";
		LEFTER500 <= '1';
		IF(C_00 = '1') THEN 
			STATE_NEXT00 <= IDLE00;
		ELSE 
			STATE_NEXT00 <= car_left00;
		END IF;
END CASE;
END PROCESS;

process(state_now01)
begin
case state_now01 is 
	when IDLE01 => 
		s_slot01_state <= "00";
		slot_states_total(1) 	<= '0';
		stair0(1) 				<= '0';
		if(out5s_01 = '1') then 
			--s_slot00_state <= "10";
			state_next01 <= car_entered01;
		else 
			state_next01 <= IDLE01;
		end if;
	when car_entered01 => 
		s_slot01_state <= "10";
		state_next01 <= occupied01;

	when occupied01 =>
		slot_states_total(1) 	<= '1';
		stair0(1) 				<= '1';
	
		s_slot01_state <= "01";
		IF(LEFT501 = '1') THEN 
			state_next01 <= car_left01;
		else 
			state_next01 <= occupied01;
		END IF;
	when car_left01 => 
		s_slot01_state <= "11";
		LEFTER501 <= '1';
		IF(C_01 = '1') THEN 
			STATE_NEXT01 <= IDLE01;
		ELSE 
			STATE_NEXT01 <= car_left01;
		END IF;
END CASE;
END PROCESS;

process(state_now02)
begin
case state_now02 is 
	when IDLE02 => 
		s_slot02_state <= "00";
		slot_states_total(2) 	<= '0';
	    stair0(2) 				<= '0';
		if(out5s_02 = '1') then 
			--s_slot00_state <= "10";
			state_next02 <= car_entered02;
		else 
			state_next02 <= IDLE02;
		end if;
	when car_entered02 => 
		s_slot02_state <= "10";
		state_next02 <= occupied02;

	when occupied02 =>
		slot_states_total(2) 	<= '1';
	    stair0(2) 				<= '1';
		s_slot02_state <= "01";
		IF(LEFT502 = '1') THEN 
			state_next02 <= car_left02;
		else 
			state_next02 <= occupied02;
		END IF;
	when car_left02 => 
		s_slot02_state <= "11";
		LEFTER502 <= '1';
		IF(C_02 = '1') THEN 
			STATE_NEXT02 <= IDLE02;
		ELSE 
			STATE_NEXT02 <= car_left02;
		END IF;
END CASE;
END PROCESS;

process(state_now03)
begin
case state_now03 is 
	when IDLE03 => 
		s_slot03_state <= "00";
		slot_states_total(3) 	<= '0';
		stair0(3) 				<= '0';
		if(out5s_03 = '1') then 
			--s_slot00_state <= "10";
			state_next03 <= car_entered03;
		else 
			state_next03 <= IDLE03;
		end if;
	when car_entered03 => 
		s_slot03_state <= "10";
		state_next03 <= occupied03;

	when occupied03 => 
		s_slot03_state <= "01";
		slot_states_total(3) 	<= '1';
		stair0(3) 				<= '1';
		IF(LEFT503 = '1') THEN 
			state_next03 <= car_left03;
		else 
			state_next03 <= occupied03;
		END IF;
	when car_left03 => 
		s_slot03_state <= "11";
		LEFTER503 <= '1';
		IF(C_03 = '1') THEN 
			STATE_NEXT00 <= IDLE00;
		ELSE 
			STATE_NEXT00 <= car_left00;
		END IF;
END CASE;
END PROCESS;

process(state_now10)
begin
case state_now10 is 
	when IDLE10 => 
		s_slot10_state <= "00";
		slot_states_total(4) 	<= '0';
		stair1(0) 				<= '0';
		if(out5s_10 = '1') then 
			--s_slot00_state <= "10";
			state_next10 <= car_entered10;
		else 
			state_next10 <= IDLE10;
		end if;
	when car_entered10 => 
		s_slot10_state <= "10";
		state_next10 <= occupied10;

	when occupied10 => 
		s_slot10_state <= "01";
		slot_states_total(4) 	<= '1';
		stair1(0) 				<= '1';
		IF(LEFT510 = '1') THEN 
			state_next10 <= car_left10;
		else 
			state_next10 <= occupied10;
		END IF;
	when car_left10 => 
		s_slot10_state <= "11";
		LEFTER510 <= '1';
		IF(C_10 = '1') THEN 
			STATE_NEXT10 <= IDLE10;
		ELSE 
			STATE_NEXT10 <= car_left10;
		END IF;
END CASE;
END PROCESS;

process(state_now11)
begin
case state_now11 is 
	when IDLE11 => 
		s_slot11_state <= "00";
		slot_states_total(5) 	<= '0';
		stair1(1) 				<= '0';
		if(out5s_11 = '1') then 
			--s_slot00_state <= "10";
			state_next11 <= car_entered11;
		else 
			state_next11 <= IDLE11;
		end if;
	when car_entered11 => 
		s_slot11_state <= "10";
		state_next11 <= occupied11;

	when occupied11 => 
		s_slot11_state <= "01";
		slot_states_total(5) 	<= '1';
		stair1(1) 				<= '1';
		IF(LEFT511 = '1') THEN 
			state_next11 <= car_left11;
		else 
			state_next11 <= occupied11;
		END IF;
	when car_left11 => 
		s_slot11_state <= "11";
		LEFTER511 <= '1';
		IF(C_11 = '1') THEN 
			STATE_NEXT11 <= IDLE11;
		ELSE 
			STATE_NEXT11 <= car_left11;
		END IF;
END CASE;
END PROCESS;

process(state_now12)
begin
case state_now12 is 
	when IDLE12 => 
		s_slot12_state <= "00";
		slot_states_total(6) 	<= '0';
		stair1(2) 				<= '0';
		if(out5s_12 = '1') then 
			--s_slot00_state <= "10";
			state_next12 <= car_entered12;
		else 
			state_next12 <= IDLE12;
		end if;
	when car_entered12 => 
		s_slot12_state <= "10";
		state_next12 <= occupied12;

	when occupied12 => 
		s_slot12_state <= "01";
		slot_states_total(6) 	<= '1';
		stair1(2) 				<= '1';
		IF(LEFT512 = '1') THEN 
			state_next12 <= car_left12;
		else 
			state_next12 <= occupied12;
		END IF;
	when car_left12 => 
		s_slot12_state <= "11";
		LEFTER512 <= '1';
		IF(C_12 = '1') THEN 
			STATE_NEXT12 <= IDLE12;
		ELSE 
			STATE_NEXT12 <= car_left12;
		END IF;
END CASE;
END PROCESS;

process(state_now13)
begin
case state_now13 is 
	when IDLE13 => 
		s_slot13_state <= "00";
		slot_states_total(7) 	<= '0';
		stair1(3) 				<= '0';
		if(out5s_13 = '1') then 
			--s_slot00_state <= "10";
			state_next13 <= car_entered13;
		else 
			state_next13 <= IDLE13;
		end if;
	when car_entered13 => 
		s_slot13_state <= "10";
		state_next13 <= occupied13;

	when occupied13 => 
		slot_states_total(7) 	<= '1';
		stair1(3) 				<= '1';
		s_slot13_state <= "01";
		IF(LEFT513 = '1') THEN 
			state_next13 <= car_left13;
		else 
			state_next13 <= occupied13;
		END IF;
	when car_left13 => 
		s_slot13_state <= "11";
		LEFTER513 <= '1';
		IF(C_13 = '1') THEN 
			STATE_NEXT13 <= IDLE13;
		ELSE 
			STATE_NEXT13 <= car_left13;
		END IF;
END CASE;
END PROCESS;

process(state_now14)
begin
case state_now14 is 
	when IDLE14 => 
		s_slot14_state <= "00";
		slot_states_total(8) 	<= '0';
		stair1(4) 				<= '0';
		if(out5s_14 = '1') then 
			--s_slot00_state <= "10";
			state_next14 <= car_entered14;
		else 
			state_next14 <= IDLE14;
		end if;
	when car_entered14 => 
		s_slot14_state <= "10";
		state_next14 <= occupied14;

	when occupied14 => 
		s_slot14_state <= "01";
		slot_states_total(8) 	<= '1';
		stair1(4) 				<= '1';
		IF(LEFT514 = '1') THEN 
			state_next14 <= car_left14;
		else 
			state_next14 <= occupied14;
		END IF;
	when car_left14 => 
		s_slot14_state <= "11";
		LEFTER514 <= '1';
		IF(C_14 = '1') THEN 
			STATE_NEXT14 <= IDLE14;
		ELSE 
			STATE_NEXT14 <= car_left14;
		END IF;
END CASE;
END PROCESS;

process(state_now15)
begin
case state_now15 is 
	when IDLE15 => 
		s_slot15_state <= "00";
		slot_states_total(9) 	<= '0';
		stair1(5) 				<= '0';
		if(out5s_15 = '1') then 
			--s_slot00_state <= "10";
			state_next15 <= car_entered15;
		else 
			state_next15 <= IDLE15;
		end if;
	when car_entered15 => 
		s_slot15_state <= "10";
		state_next15 <= occupied15;

	when occupied15 => 
		s_slot15_state <= "01";
		slot_states_total(9) 	<= '1';
		stair1(5) 				<= '1';
		IF(LEFT500 = '1') THEN 
			state_next15 <= car_left15;
		else 
			state_next15 <= occupied15;
		END IF;
	when car_left15 => 
		s_slot15_state <= "11";
		LEFTER515 <= '1';
		IF(C_15 = '1') THEN 
			STATE_NEXT15 <= IDLE15;
		ELSE 
			STATE_NEXT15 <= car_left15;
		END IF;
END CASE;
END PROCESS;

process(state_now20)
begin
case state_now20 is 
	when IDLE20 => 
		s_slot20_state <= "00";
		slot_states_total(10) 	<= '0';
		stair2(0) 				<= '0';
		if(out5s_20 = '1') then 
			--s_slot00_state <= "10";
			state_next20 <= car_entered20;
		else 
			state_next20 <= IDLE20;
		end if;
	when car_entered20 => 
		s_slot20_state <= "10";
		state_next20 <= occupied20;

	when occupied20 => 
		s_slot20_state <= "01";
		slot_states_total(10) 	<= '1';
		stair2(0) 				<= '1';
		IF(LEFT520 = '1') THEN 
			state_next20 <= car_left20;
		else 
			state_next20 <= occupied20;
		END IF;
	when car_left20 => 
		s_slot20_state <= "11";
		LEFTER520 <= '1';
		IF(C_20 = '1') THEN 
			STATE_NEXT20 <= IDLE20;
		ELSE 
			STATE_NEXT20 <= car_left20;
		END IF;
END CASE;
END PROCESS;

process(state_now21)
begin
case state_now21 is 
	when IDLE21 => 
		s_slot21_state <= "00";
		slot_states_total(11) 	<= '0';
		stair2(1) 				<= '0';
		if(out5s_21 = '1') then 
			--s_slot00_state <= "10";
			state_next21 <= car_entered21;
		else 
			state_next21 <= IDLE21;
		end if;
	when car_entered21 => 
		s_slot21_state <= "10";
		state_next21 <= occupied21;

	when occupied21 => 
		s_slot21_state <= "01";
		slot_states_total(11) 	<= '1';
		stair2(1) 				<= '1';
		IF(LEFT521 = '1') THEN 
			state_next21 <= car_left21;
		else 
			state_next21 <= occupied21;
		END IF;
	when car_left21 => 
		s_slot21_state <= "11";
		LEFTER521 <= '1';
		IF(C_21 = '1') THEN 
			STATE_NEXT21 <= IDLE21;
		ELSE 
			STATE_NEXT21 <= car_left21;
		END IF;
END CASE;
END PROCESS;

process(state_now22)
begin
case state_now22 is 
	when IDLE22 => 
		s_slot22_state <= "00";
		slot_states_total(12) 	<= '0';
		stair2(2) 				<= '0';
		if(out5s_22 = '1') then 
			--s_slot00_state <= "10";
			state_next22 <= car_entered22;
		else 
			state_next22 <= IDLE22;
		end if;
	when car_entered22 => 
		s_slot22_state <= "10";
		state_next22 <= occupied22;

	when occupied22 => 
		s_slot22_state <= "01";
		slot_states_total(12) 	<= '1';
		stair2(2) 				<= '1';
		IF(LEFT522 = '1') THEN 
			state_next22 <= car_left22;
		else 
			state_next22 <= occupied22;
		END IF;
	when car_left22 => 
		s_slot22_state <= "11";
		LEFTER522 <= '1';
		IF(C_22 = '1') THEN 
			STATE_NEXT22 <= IDLE22;
		ELSE 
			STATE_NEXT22 <= car_left22;
		END IF;
END CASE;
END PROCESS;

process(state_now23)
begin
case state_now23 is 
	when IDLE23 => 
		s_slot23_state <= "00";
		slot_states_total(13) 	<= '0';
		stair2(3) 				<= '0';
		if(out5s_23 = '1') then 
			--s_slot00_state <= "10";
			state_next23 <= car_entered23;
		else 
			state_next23 <= IDLE23;
		end if;
	when car_entered23 => 
		s_slot23_state <= "10";
		state_next23 <= occupied23;

	when occupied23 => 
		s_slot23_state <= "01";
		slot_states_total(13) 	<= '1';
		stair2(3) 				<= '1';
		IF(LEFT523 = '1') THEN 
			state_next23 <= car_left23;
		else 
			state_next23 <= occupied23;
		END IF;
	when car_left23 => 
		s_slot23_state <= "11";
		LEFTER523 <= '1';
		IF(C_23 = '1') THEN 
			STATE_NEXT23 <= IDLE23;
		ELSE 
			STATE_NEXT23 <= car_left23;
		END IF;
END CASE;
END PROCESS;

process(state_now24)
begin
case state_now24 is 
	when IDLE24 => 
		s_slot24_state <= "00";
		slot_states_total(14) 	<= '0';
		stair2(4) 				<= '0';
		if(out5s_24 = '1') then 
			--s_slot00_state <= "10";
			state_next24 <= car_entered24;
		else 
			state_next24 <= IDLE24;
		end if;
	when car_entered24 => 
		s_slot24_state <= "10";
		state_next24 <= occupied24;

	when occupied24 => 
		s_slot24_state <= "01";
		slot_states_total(14) 	<= '1';
		stair2(4) 				<= '1';
		IF(LEFT524 = '1') THEN 
			state_next24 <= car_left24;
		else 
			state_next24 <= occupied24;
		END IF;
	when car_left24 => 
		s_slot24_state <= "11";
		LEFTER524 <= '1';
		IF(C_24 = '1') THEN 
			STATE_NEXT24 <= IDLE24;
		ELSE 
			STATE_NEXT24 <= car_left24;
		END IF;
END CASE;
END PROCESS;

process(state_now25)
begin
case state_now25 is 
	when IDLE25 => 
		s_slot25_state <= "00";
		slot_states_total(15) 	<= '0';
		stair2(5) 				<= '0';
		if(out5s_25 = '1') then 
			--s_slot00_state <= "10";
			state_next25 <= car_entered25;
		else 
			state_next25 <= IDLE25;
		end if;
	when car_entered25 => 
		s_slot25_state <= "10";
		state_next25 <= occupied25;

	when occupied25 => 
		s_slot25_state <= "01";
		slot_states_total(15) 	<= '1';
		stair2(5) 				<= '1';
		IF(LEFT525 = '1') THEN 
			state_next25 <= car_left25;
		else 
			state_next25 <= occupied25;
		END IF;
	when car_left25 => 
		s_slot25_state <= "11";
		LEFTER525 <= '1';
		IF(C_25 = '1') THEN 
			STATE_NEXT25 <= IDLE25;
		ELSE 
			STATE_NEXT25 <= car_left25;
		END IF;
END CASE;
END PROCESS;
slot00_state		<= s_slot00_state		;	
slot01_state		<= s_slot01_state		;
slot02_state		<= s_slot02_state		;
slot03_state		<= s_slot03_state		;
slot10_state		<= s_slot10_state		;
slot11_state		<= s_slot11_state		;
slot12_state		<= s_slot12_state		;
slot13_state		<= s_slot13_state		;
slot14_state		<= s_slot14_state		;
slot15_state		<= s_slot15_state		;
slot20_state		<= s_slot20_state		;
slot21_state		<= s_slot21_state		;
slot22_state		<= s_slot22_state		;
slot23_state		<= s_slot23_state		;
slot24_state		<= s_slot24_state		;
slot25_state		<= s_slot25_state		;
slot_states_total	<= s_slot_states_total	;
stair0			    <= s_stair0			    ;
stair1			    <= s_stair1			    ;
stair2			    <= s_stair2			    ;

module_top_trigger_out00   <= s_module_top_trigger_out00;
module_top_trigger_out01   <= s_module_top_trigger_out01;
module_top_trigger_out02   <= s_module_top_trigger_out02;
module_top_trigger_out03   <= s_module_top_trigger_out03;
module_top_trigger_out10   <= s_module_top_trigger_out10;
module_top_trigger_out11   <= s_module_top_trigger_out11;
module_top_trigger_out12   <= s_module_top_trigger_out12;
module_top_trigger_out13   <= s_module_top_trigger_out13;
module_top_trigger_out14   <= s_module_top_trigger_out14;
module_top_trigger_out15   <= s_module_top_trigger_out15;
module_top_trigger_out20   <= s_module_top_trigger_out20;
module_top_trigger_out21   <= s_module_top_trigger_out21;
module_top_trigger_out22   <= s_module_top_trigger_out22;
module_top_trigger_out23   <= s_module_top_trigger_out23;
module_top_trigger_out24   <= s_module_top_trigger_out24;
module_top_trigger_out25   <= s_module_top_trigger_out25;

		
end arch;