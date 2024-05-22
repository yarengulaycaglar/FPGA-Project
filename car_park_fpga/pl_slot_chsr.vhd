library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pl_slot_chsr is
generic(
	--c_clkfreq : integer := 20 --Low value for testbench
	c_clkfreq : integer := 50_000_000 --Real Design Value
);
  Port (
  		clk					: in std_logic;
		reset 				: in std_logic;
		color_ID			: in std_logic_vector(23 downto 0);	
		--slot_state			: in std_logic_vector(1 downto 0);	
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
end pl_slot_chsr;

architecture Behavioral of pl_slot_chsr is

signal slot_states_total_pre : std_logic_vector(15 downto 0);
signal last_active_slot_reg  : std_logic_vector(7 downto 0);
--signal car_out 				 : std_logic;




component pl_slot_memory_reg is --Timer buna girecek car_inside = '1' ise count sayacak
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
		
		time_spent_s 		: out std_logic_vector(11 downto 0);--saniyesi 1kurus --dakikası 60kr
		time_spent_m 		: out std_logic_vector(5 downto 0);--saati 36tl
		time_spent_h 		: out std_logic_vector(5 downto 0);--günü 864tl
		
		color_ID_out		: out std_logic_vector(23 downto 0);	
		destination_out		: out std_logic_vector(7 downto 0);												    
		fee					: out std_logic_vector(11 downto 0)
		
  );
end component;

	
signal slot_state_out_s00		: std_logic_vector(1 downto 0);
signal slot_state_out_s01		: std_logic_vector(1 downto 0);
signal slot_state_out_s02		: std_logic_vector(1 downto 0);
signal slot_state_out_s03		: std_logic_vector(1 downto 0);
signal slot_state_out_s10		: std_logic_vector(1 downto 0);
signal slot_state_out_s11		: std_logic_vector(1 downto 0);
signal slot_state_out_s12		: std_logic_vector(1 downto 0);
signal slot_state_out_s13		: std_logic_vector(1 downto 0);
signal slot_state_out_s14		: std_logic_vector(1 downto 0);
signal slot_state_out_s15		: std_logic_vector(1 downto 0);
signal slot_state_out_s20		: std_logic_vector(1 downto 0);
signal slot_state_out_s21		: std_logic_vector(1 downto 0);
signal slot_state_out_s22		: std_logic_vector(1 downto 0);
signal slot_state_out_s23		: std_logic_vector(1 downto 0);
signal slot_state_out_s24		: std_logic_vector(1 downto 0);
signal slot_state_out_s25		: std_logic_vector(1 downto 0);
	
signal color_ID_out_s00			: std_logic_vector(23 downto 0);
signal color_ID_out_s01			: std_logic_vector(23 downto 0);
signal color_ID_out_s02			: std_logic_vector(23 downto 0);
signal color_ID_out_s03			: std_logic_vector(23 downto 0);
signal color_ID_out_s10			: std_logic_vector(23 downto 0);
signal color_ID_out_s11			: std_logic_vector(23 downto 0);
signal color_ID_out_s12			: std_logic_vector(23 downto 0);
signal color_ID_out_s13			: std_logic_vector(23 downto 0);
signal color_ID_out_s14			: std_logic_vector(23 downto 0);
signal color_ID_out_s15			: std_logic_vector(23 downto 0);
signal color_ID_out_s20			: std_logic_vector(23 downto 0);
signal color_ID_out_s21			: std_logic_vector(23 downto 0);
signal color_ID_out_s22			: std_logic_vector(23 downto 0);
signal color_ID_out_s23			: std_logic_vector(23 downto 0);
signal color_ID_out_s24			: std_logic_vector(23 downto 0);
signal color_ID_out_s25			: std_logic_vector(23 downto 0);

signal color_ID_reg00 : std_logic_vector(23 downto 0);
signal color_ID_reg01 : std_logic_vector(23 downto 0);
signal color_ID_reg02 : std_logic_vector(23 downto 0);
signal color_ID_reg03 : std_logic_vector(23 downto 0);
signal color_ID_reg10 : std_logic_vector(23 downto 0);
signal color_ID_reg11 : std_logic_vector(23 downto 0);
signal color_ID_reg12 : std_logic_vector(23 downto 0);
signal color_ID_reg13 : std_logic_vector(23 downto 0);
signal color_ID_reg14 : std_logic_vector(23 downto 0);
signal color_ID_reg15 : std_logic_vector(23 downto 0);
signal color_ID_reg20 : std_logic_vector(23 downto 0);
signal color_ID_reg21 : std_logic_vector(23 downto 0);
signal color_ID_reg22 : std_logic_vector(23 downto 0);
signal color_ID_reg23 : std_logic_vector(23 downto 0);
signal color_ID_reg24 : std_logic_vector(23 downto 0);
signal color_ID_reg25 : std_logic_vector(23 downto 0);


signal destination_reg00  	: std_logic_vector(7 downto 0);	
signal destination_reg01  	: std_logic_vector(7 downto 0);	
signal destination_reg02  	: std_logic_vector(7 downto 0);	
signal destination_reg03  	: std_logic_vector(7 downto 0);	
signal destination_reg10  	: std_logic_vector(7 downto 0);	
signal destination_reg11  	: std_logic_vector(7 downto 0);	
signal destination_reg12  	: std_logic_vector(7 downto 0);	
signal destination_reg13  	: std_logic_vector(7 downto 0);	
signal destination_reg14  	: std_logic_vector(7 downto 0);	
signal destination_reg15  	: std_logic_vector(7 downto 0);	
signal destination_reg20  	: std_logic_vector(7 downto 0);	
signal destination_reg21  	: std_logic_vector(7 downto 0);	
signal destination_reg22  	: std_logic_vector(7 downto 0);	
signal destination_reg23  	: std_logic_vector(7 downto 0);	
signal destination_reg24  	: std_logic_vector(7 downto 0);	
signal destination_reg25  	: std_logic_vector(7 downto 0);	
	
signal destination_out_s00  	: std_logic_vector(7 downto 0);	
signal destination_out_s01  	: std_logic_vector(7 downto 0);	
signal destination_out_s02  	: std_logic_vector(7 downto 0);	
signal destination_out_s03  	: std_logic_vector(7 downto 0);	
signal destination_out_s10  	: std_logic_vector(7 downto 0);	
signal destination_out_s11  	: std_logic_vector(7 downto 0);	
signal destination_out_s12  	: std_logic_vector(7 downto 0);	
signal destination_out_s13  	: std_logic_vector(7 downto 0);	
signal destination_out_s14  	: std_logic_vector(7 downto 0);	
signal destination_out_s15  	: std_logic_vector(7 downto 0);	
signal destination_out_s20  	: std_logic_vector(7 downto 0);	
signal destination_out_s21  	: std_logic_vector(7 downto 0);	
signal destination_out_s22  	: std_logic_vector(7 downto 0);	
signal destination_out_s23  	: std_logic_vector(7 downto 0);	
signal destination_out_s24  	: std_logic_vector(7 downto 0);	
signal destination_out_s25  	: std_logic_vector(7 downto 0);	


signal fee_out_s00	: std_logic_vector(11 downto 0);
signal fee_out_s01	: std_logic_vector(11 downto 0);
signal fee_out_s02	: std_logic_vector(11 downto 0);
signal fee_out_s03	: std_logic_vector(11 downto 0);
signal fee_out_s10	: std_logic_vector(11 downto 0);
signal fee_out_s11	: std_logic_vector(11 downto 0);
signal fee_out_s12	: std_logic_vector(11 downto 0);
signal fee_out_s13	: std_logic_vector(11 downto 0);
signal fee_out_s14	: std_logic_vector(11 downto 0);
signal fee_out_s15	: std_logic_vector(11 downto 0);
signal fee_out_s20	: std_logic_vector(11 downto 0);
signal fee_out_s21	: std_logic_vector(11 downto 0);
signal fee_out_s22	: std_logic_vector(11 downto 0);
signal fee_out_s23	: std_logic_vector(11 downto 0);
signal fee_out_s24	: std_logic_vector(11 downto 0);
signal fee_out_s25	: std_logic_vector(11 downto 0);


signal car_out00 : std_logic;
signal car_out01 : std_logic;
signal car_out02 : std_logic;
signal car_out03 : std_logic;
signal car_out10 : std_logic;
signal car_out11 : std_logic;
signal car_out12 : std_logic;
signal car_out13 : std_logic;
signal car_out14 : std_logic;
signal car_out15 : std_logic;
signal car_out20 : std_logic;
signal car_out21 : std_logic;
signal car_out22 : std_logic;
signal car_out23 : std_logic;
signal car_out24 : std_logic;
signal car_out25 : std_logic;


signal time_spent_s00 : std_logic_vector(11 downto 0);--saniyesi 1kurus --dakikası 60kr
signal time_spent_s01 : std_logic_vector(11 downto 0);
signal time_spent_s02 : std_logic_vector(11 downto 0);
signal time_spent_s03 : std_logic_vector(11 downto 0);
signal time_spent_s10 : std_logic_vector(11 downto 0);
signal time_spent_s11 : std_logic_vector(11 downto 0);
signal time_spent_s12 : std_logic_vector(11 downto 0);
signal time_spent_s13 : std_logic_vector(11 downto 0);
signal time_spent_s14 : std_logic_vector(11 downto 0);
signal time_spent_s15 : std_logic_vector(11 downto 0);
signal time_spent_s20 : std_logic_vector(11 downto 0);
signal time_spent_s21 : std_logic_vector(11 downto 0);
signal time_spent_s22 : std_logic_vector(11 downto 0);
signal time_spent_s23 : std_logic_vector(11 downto 0);
signal time_spent_s24 : std_logic_vector(11 downto 0);
signal time_spent_s25 : std_logic_vector(11 downto 0);


signal time_spent_m00 : std_logic_vector(5 downto 0);--saati 36tl
signal time_spent_m01 : std_logic_vector(5 downto 0);
signal time_spent_m02 : std_logic_vector(5 downto 0);
signal time_spent_m03 : std_logic_vector(5 downto 0);
signal time_spent_m10 : std_logic_vector(5 downto 0);
signal time_spent_m11 : std_logic_vector(5 downto 0);
signal time_spent_m12 : std_logic_vector(5 downto 0);
signal time_spent_m13 : std_logic_vector(5 downto 0);
signal time_spent_m14 : std_logic_vector(5 downto 0);
signal time_spent_m15 : std_logic_vector(5 downto 0);
signal time_spent_m20 : std_logic_vector(5 downto 0);
signal time_spent_m21 : std_logic_vector(5 downto 0);
signal time_spent_m22 : std_logic_vector(5 downto 0);
signal time_spent_m23 : std_logic_vector(5 downto 0);
signal time_spent_m24 : std_logic_vector(5 downto 0);
signal time_spent_m25 : std_logic_vector(5 downto 0);



signal time_spent_h00 : std_logic_vector(5 downto 0);--günü 864tl
signal time_spent_h01 : std_logic_vector(5 downto 0);
signal time_spent_h02 : std_logic_vector(5 downto 0);
signal time_spent_h03 : std_logic_vector(5 downto 0);
signal time_spent_h10 : std_logic_vector(5 downto 0);
signal time_spent_h11 : std_logic_vector(5 downto 0);
signal time_spent_h12 : std_logic_vector(5 downto 0);
signal time_spent_h13 : std_logic_vector(5 downto 0);
signal time_spent_h14 : std_logic_vector(5 downto 0);
signal time_spent_h15 : std_logic_vector(5 downto 0);
signal time_spent_h20 : std_logic_vector(5 downto 0);
signal time_spent_h21 : std_logic_vector(5 downto 0);
signal time_spent_h22 : std_logic_vector(5 downto 0);
signal time_spent_h23 : std_logic_vector(5 downto 0);
signal time_spent_h24 : std_logic_vector(5 downto 0);
signal time_spent_h25 : std_logic_vector(5 downto 0);

begin

last_active_slot <= last_active_slot_reg;

pl_slot_memory_reg00 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out00,
color_ID		=> color_ID_reg00,
slot_state		=> slot00_state,
destination 	=> destination_reg00,
time_spent_s 	=> time_spent_s00,
time_spent_m 	=> time_spent_m00,
time_spent_h 	=> time_spent_h00,
color_ID_out	=> color_ID_out_s00,
destination_out	=> destination_out_s00,
fee				=> fee_out_s00
);

pl_slot_memory_reg01 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out01,
color_ID		=> color_ID_reg01,
slot_state		=> slot01_state,
destination 	=> destination_reg01,
time_spent_s 	=> time_spent_s01,
time_spent_m 	=> time_spent_m01,
time_spent_h 	=> time_spent_h01,
color_ID_out	=> color_ID_out_s01,
destination_out	=> destination_out_s01,
fee				=> fee_out_s01
);

pl_slot_memory_reg02 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out02,
color_ID		=> color_ID_reg02,
slot_state		=> slot02_state,
destination 	=> destination_reg02,
time_spent_s 	=> time_spent_s02,
time_spent_m 	=> time_spent_m02,
time_spent_h 	=> time_spent_h02,
color_ID_out	=> color_ID_out_s02,
destination_out	=> destination_out_s02,
fee				=> fee_out_s02
);

pl_slot_memory_reg03 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out03,
color_ID		=> color_ID_reg03,
slot_state		=> slot03_state,
destination 	=> destination_reg03,
time_spent_s 	=> time_spent_s03,
time_spent_m 	=> time_spent_m03,
time_spent_h 	=> time_spent_h03,
color_ID_out	=> color_ID_out_s03,
destination_out	=> destination_out_s03,
fee				=> fee_out_s03
);

pl_slot_memory_reg10 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out10,
color_ID		=> color_ID_reg10,
slot_state		=> slot10_state,
destination 	=> destination_reg10,
time_spent_s 	=> time_spent_s10,
time_spent_m 	=> time_spent_m10,
time_spent_h 	=> time_spent_h10,
color_ID_out	=> color_ID_out_s10,
destination_out	=> destination_out_s10,
fee				=> fee_out_s10
);

pl_slot_memory_reg11 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out11,
color_ID		=> color_ID_reg11,
slot_state		=> slot11_state,
destination 	=> destination_reg11,
time_spent_s 	=> time_spent_s11,
time_spent_m 	=> time_spent_m11,
time_spent_h 	=> time_spent_h11,
color_ID_out	=> color_ID_out_s11,
destination_out	=> destination_out_s11,
fee				=> fee_out_s11
);

pl_slot_memory_reg12 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out12,
color_ID		=> color_ID_reg12,
slot_state		=> slot12_state,
destination 	=> destination_reg12,
time_spent_s 	=> time_spent_s12,
time_spent_m 	=> time_spent_m12,
time_spent_h 	=> time_spent_h12,
color_ID_out	=> color_ID_out_s12,
destination_out	=> destination_out_s12,
fee				=> fee_out_s12
);

pl_slot_memory_reg13 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out13,
color_ID		=> color_ID_reg13,
slot_state		=> slot13_state,
destination 	=> destination_reg13,
time_spent_s 	=> time_spent_s13,
time_spent_m 	=> time_spent_m13,
time_spent_h 	=> time_spent_h13,
color_ID_out	=> color_ID_out_s13,
destination_out	=> destination_out_s13,
fee				=> fee_out_s13
);

pl_slot_memory_reg14 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out14,
color_ID		=> color_ID_reg14,
slot_state		=> slot14_state,
destination 	=> destination_reg14,
time_spent_s 	=> time_spent_s14,
time_spent_m 	=> time_spent_m14,
time_spent_h 	=> time_spent_h14,
color_ID_out	=> color_ID_out_s14,
destination_out	=> destination_out_s14,
fee				=> fee_out_s14
);

pl_slot_memory_reg15 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out15,
color_ID		=> color_ID_reg15,
slot_state		=> slot15_state,
destination 	=> destination_reg15,
time_spent_s 	=> time_spent_s15,
time_spent_m 	=> time_spent_m15,
time_spent_h 	=> time_spent_h15,
color_ID_out	=> color_ID_out_s15,
destination_out	=> destination_out_s15,
fee				=> fee_out_s15
);

pl_slot_memory_reg20 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out20,
color_ID		=> color_ID_reg20,
slot_state		=> slot20_state,
destination 	=> destination_reg20,
time_spent_s 	=> time_spent_s20,
time_spent_m 	=> time_spent_m20,
time_spent_h 	=> time_spent_h20,
color_ID_out	=> color_ID_out_s20,
destination_out	=> destination_out_s20,
fee				=> fee_out_s20
);

pl_slot_memory_reg21 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out21,
color_ID		=> color_ID_reg21,
slot_state		=> slot21_state,
destination 	=> destination_reg21,
time_spent_s 	=> time_spent_s21,
time_spent_m 	=> time_spent_m21,
time_spent_h 	=> time_spent_h21,
color_ID_out	=> color_ID_out_s21,
destination_out	=> destination_out_s21,
fee				=> fee_out_s21
);


pl_slot_memory_reg22 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out22,
color_ID		=> color_ID_reg22,
slot_state		=> slot22_state,
destination 	=> destination_reg22,
time_spent_s 	=> time_spent_s22,
time_spent_m 	=> time_spent_m22,
time_spent_h 	=> time_spent_h22,
color_ID_out	=> color_ID_out_s22,
destination_out	=> destination_out_s22,
fee				=> fee_out_s22
);

pl_slot_memory_reg23 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out23,
color_ID		=> color_ID_reg23,
slot_state		=> slot23_state,
destination 	=> destination_reg23,
time_spent_s 	=> time_spent_s23,
time_spent_m 	=> time_spent_m23,
time_spent_h 	=> time_spent_h23,
color_ID_out	=> color_ID_out_s23,
destination_out	=> destination_out_s23,
fee				=> fee_out_s23
);

pl_slot_memory_reg24 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out24,
color_ID		=> color_ID_reg24,
slot_state		=> slot24_state,
destination 	=> destination_out_s24,
time_spent_s 	=> time_spent_s24,
time_spent_m 	=> time_spent_m24,
time_spent_h 	=> time_spent_h24,
color_ID_out	=> color_ID_out_s24,
destination_out	=> destination_out_s24,
fee				=> fee_out_s24
);

pl_slot_memory_reg25 : pl_slot_memory_reg
port map(
clk				=> clk,
reset   		=> reset,
car_out 		=> car_out25,
color_ID		=> color_ID_reg25,
slot_state		=> slot25_state,
destination 	=> destination_reg25,
time_spent_s 	=> time_spent_s25,
time_spent_m 	=> time_spent_m25,
time_spent_h 	=> time_spent_h25,
color_ID_out	=> color_ID_out_s25,
destination_out	=> destination_out_s25,
fee				=> fee_out_s25
);



process(slot_states_total) 
begin
	if ((slot_states_total_pre) /= (slot_states_total)) then
		slot_states_total_pre <= slot_states_total;
	--------------------------------------------------------------------	
		if((slot00_state = "10") or (slot00_state = "01")) then
			color_ID_reg00			<= color_ID		;
			destination_reg00 		<= destination 	;
			last_active_slot_reg	<= "00000001";
			car_out00 <= '0';
			
		elsif ((slot00_state = "11") or (slot00_state = "00")) then

			last_active_slot_reg	<= "00000001";
			if(slot00_state = "11") then
				car_out00 <= '1';
				car_out <= '1';
			else	
				color_ID_reg00			<= (others => '0');
				destination_reg00 		<= (others => '0');
				car_out00 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------		
		elsif((slot01_state = "10") or (slot01_state = "01")) then
			color_ID_reg01			<= color_ID		;
			destination_reg01 		<= destination 	;
			last_active_slot_reg	<= "00000010";
			car_out01 <= '0';
		elsif ((slot01_state = "11") or (slot01_state = "00")) then
			last_active_slot_reg	<= "00000010";
			if(slot01_state = "11") then
				car_out01 <= '1';
				car_out <= '1';
			else	
				color_ID_reg01			<= (others => '0');
				destination_reg01 		<= (others => '0');
				car_out01 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------
		elsif((slot02_state = "10") or (slot02_state = "01")) then
			--car_out_reg00			<= 
			color_ID_reg02			<= color_ID		;
			destination_reg02 		<= destination 	;
			last_active_slot_reg	<= "00000100";
			car_out02 <= '0';
		elsif ((slot02_state = "11") or (slot02_state = "00")) then
			last_active_slot_reg	<= "00000100";
			if(slot02_state = "11") then
				car_out02 <= '1';
				car_out <= '1';
			else	
				color_ID_reg02			<= (others => '0');
				destination_reg02 		<= (others => '0');
				car_out02 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------		
		elsif((slot03_state = "10") or (slot03_state = "01")) then
			color_ID_reg03			<= color_ID		;
			destination_reg03 		<= destination 	;
			last_active_slot_reg	<= "00001000";
			car_out03 <= '0';
		elsif ((slot03_state = "11") or (slot03_state = "00")) then
			
			
			last_active_slot_reg	<= "00001000";
			if(slot03_state = "11") then
				car_out03 <= '1';
				car_out <= '1';
			else	
				color_ID_reg03			<= (others => '0');
				destination_reg03 		<= (others => '0');	
				car_out03 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------	
	--------------------------------------------------------------------
		elsif((slot10_state = "10") or (slot10_state = "01")) then
			color_ID_reg10			<= color_ID		;
			destination_reg10 		<= destination 	;
			last_active_slot_reg	<= "01000001";
			car_out10 <= '0';
		elsif ((slot10_state = "11") or (slot10_state = "00")) then
			
			
			last_active_slot_reg	<= "01000001";
			if(slot10_state = "11") then
				car_out10 <= '1';
				car_out <= '1';
			else	
				color_ID_reg10			<= (others => '0');
				destination_reg10 		<= (others => '0');
				car_out10 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------		
		elsif((slot11_state = "10") or (slot11_state = "01")) then
			color_ID_reg11			<= color_ID		;
			destination_reg11 		<= destination 	;
			last_active_slot_reg	<= "01000010";
			car_out11 <= '0';
		elsif ((slot11_state = "11") or (slot11_state = "00")) then
			
				
			last_active_slot_reg	<= "01000010";
			if(slot11_state = "11") then
				car_out11 <= '1';
				car_out <= '1';
			else	
				color_ID_reg11			<= (others => '0');
			    destination_reg11 		<= (others => '0');
				car_out11 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------
		elsif((slot12_state = "10") or (slot12_state = "01")) then
			color_ID_reg12			<= color_ID		;
			destination_reg12 		<= destination 	;
			last_active_slot_reg	<= "01000100";
			car_out12 <= '0';
		elsif ((slot12_state = "11") or (slot12_state = "00")) then
			
			
			last_active_slot_reg	<= "01000100";
			if(slot12_state = "11") then
				car_out12 <= '1';
				car_out <= '1';
			else	
				color_ID_reg12			<= (others => '0');
				destination_reg12 		<= (others => '0');
				car_out12 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------		
		elsif((slot13_state = "10") or (slot13_state = "01")) then
			color_ID_reg13			<= color_ID		;
			destination_reg13 		<= destination 	;
			last_active_slot_reg	<= "01001000";
			car_out13 <= '0';
		elsif ((slot13_state = "11") or (slot13_state = "00")) then
			
				
			last_active_slot_reg	<= "01001000";
			if(slot13_state = "11") then
				car_out13 <= '1';
				car_out <= '1';
			else	
				color_ID_reg13			<= (others => '0');
				destination_reg13 		<= (others => '0');
				car_out13 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------
		elsif((slot14_state = "10") or (slot14_state = "01")) then
			color_ID_reg14			<= color_ID		;
			destination_reg14 		<= destination 	;
			last_active_slot_reg	<= "01010000";
			car_out14 <= '0';
		elsif ((slot14_state = "11") or (slot14_state = "00")) then
			
			
			last_active_slot_reg	<= "01010000";
			if(slot14_state = "11") then
				car_out14 <= '1';
				car_out <= '1';
			else	
				color_ID_reg14			<= (others => '0');
				destination_reg14 		<= (others => '0');
				car_out14 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------		
		elsif((slot15_state = "10") or (slot15_state = "01")) then
			color_ID_reg15			<= color_ID		;
			destination_reg15 		<= destination 	;
			last_active_slot_reg	<= "01100000";
			car_out15 <= '0';
		elsif ((slot15_state = "11") or (slot15_state = "00")) then
			
			
			last_active_slot_reg	<= "01100000";
			if(slot15_state = "11") then
				car_out15 <= '1';
				car_out <= '1';
			else	
				color_ID_reg15			<= (others => '0');
			    destination_reg15 		<= (others => '0');	
				car_out15 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------
	--------------------------------------------------------------------
		elsif((slot20_state = "10") or (slot20_state = "01")) then
			color_ID_reg20			<= color_ID		;
			destination_reg20 		<= destination 	;
			last_active_slot_reg	<= "10000001";
			car_out20 <= '0';
		elsif ((slot20_state = "11") or (slot20_state = "00")) then
			
			
			last_active_slot_reg	<= "10000001";
			if(slot20_state = "11") then
				car_out20 <= '1';
				car_out <= '1';
			else	
				color_ID_reg20			<= (others => '0');
				destination_reg20 		<= (others => '0');
				car_out20 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------		
		elsif((slot21_state = "10") or (slot21_state = "01")) then
			color_ID_reg21			<= color_ID		;
			destination_reg21 		<= destination 	;
			last_active_slot_reg	<= "10000010";
			car_out21 <= '0';
		elsif ((slot21_state = "11") or (slot21_state = "00")) then
			
			
			last_active_slot_reg	<= "10000010";	
			if(slot21_state = "11") then
				car_out21 <= '1';
				car_out <= '1';
			else	
				color_ID_reg21			<= (others => '0');
			    destination_reg21 		<= (others => '0');
				car_out21 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------
		elsif((slot22_state = "10") or (slot22_state = "01")) then
			color_ID_reg22			<= color_ID		;
			destination_reg22 		<= destination 	;
			last_active_slot_reg	<= "10000100"	;
			car_out22 <= '0';
		elsif ((slot22_state = "11") or (slot22_state = "00")) then
			
			
			last_active_slot_reg	<= "10000100"	;
			if(slot22_state = "11") then
				car_out22 <= '1';
				car_out <= '1';
			else	
				color_ID_reg22			<= (others => '0');
			    destination_reg22 		<= (others => '0');
				car_out22 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------		
		elsif((slot23_state = "10") or (slot23_state = "01")) then
			color_ID_reg23			<= color_ID		;
			destination_reg23 		<= destination 	;
			last_active_slot_reg	<= "10001000";
			car_out23 <= '0';
		elsif ((slot23_state = "11") or (slot23_state = "00")) then
			
			
			last_active_slot_reg	<= "10001000";
			if(slot23_state = "11") then
				car_out23 <= '1';
				car_out <= '1';
			else	
				color_ID_reg23			<= (others => '0');
				destination_reg23 		<= (others => '0');	
				car_out23 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------
		elsif((slot24_state = "10") or (slot24_state = "01")) then
			color_ID_reg24			<= color_ID		;
			destination_reg24 		<= destination 	;
			last_active_slot_reg	<= "10010000";
			car_out24 <= '0';
		elsif ((slot24_state = "11") or (slot24_state = "00")) then
			
			
			last_active_slot_reg	<= "10010000";
			if(slot24_state = "11") then
				car_out24 <= '1';
				car_out <= '1';
			else	
				color_ID_reg24			<= (others => '0');
				destination_reg24 		<= (others => '0');
				car_out24 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------		
		elsif((slot25_state = "10") or (slot25_state = "01")) then
			color_ID_reg25			<= color_ID		;
			destination_reg25 		<= destination 	;
			last_active_slot_reg	<= "10100000";
			car_out25 <= '0';
		elsif ((slot25_state = "11") or (slot25_state = "00")) then
			
			
			last_active_slot_reg	<= "10100000";
			if(slot25_state = "11") then
				car_out25 <= '1';
				car_out <= '1';
			else	
				color_ID_reg25			<= (others => '0');
				destination_reg25 		<= (others => '0');	
				car_out25 <= '0';
				car_out <= '0';
			end if;
	--------------------------------------------------------------------
	
		end if;
		
	end if;
end process;


process(last_active_slot_reg)
begin
	case last_active_slot_reg is
		when "00000001" =>
			color_ID_out	<= color_ID_out_s00;
			slot_state_out	<= slot_state_out_s00;
			destination_out	<= destination_out_s00;
			fee_out 		<= fee_out_s00;
			time_spent_s	<= time_spent_s00;
			time_spent_m	<= time_spent_m00;
			time_spent_h	<= time_spent_h00;
		when "00000010" =>
			color_ID_out	<= color_ID_out_s01;
			slot_state_out	<= slot_state_out_s01;
			destination_out	<= destination_out_s01;	
			fee_out 		<= fee_out_s01;
			time_spent_s	<= time_spent_s01;
			time_spent_m	<= time_spent_m01;
			time_spent_h	<= time_spent_h01;
		when "00000101" =>
			color_ID_out	<= color_ID_out_s02;
			slot_state_out	<= slot_state_out_s02;
			destination_out	<= destination_out_s02;	
			fee_out 		<= fee_out_s02;		
			time_spent_s	<= time_spent_s02;
			time_spent_m	<= time_spent_m02;
			time_spent_h	<= time_spent_h02;	
		when "00001000" =>
			color_ID_out	<= color_ID_out_s03;
			slot_state_out	<= slot_state_out_s03;
			destination_out	<= destination_out_s03;	
			fee_out 		<= fee_out_s03;		
			time_spent_s	<= time_spent_s03;
			time_spent_m	<= time_spent_m03;
			time_spent_h	<= time_spent_h03;	
		when "01000001" =>
			color_ID_out	<= color_ID_out_s10;
			slot_state_out	<= slot_state_out_s10;
			destination_out	<= destination_out_s10;	
			fee_out 		<= fee_out_s10;
			time_spent_s	<= time_spent_s10;
			time_spent_m	<= time_spent_m10;
			time_spent_h	<= time_spent_h10;
		when "01000010" =>
			color_ID_out	<= color_ID_out_s11;
			slot_state_out	<= slot_state_out_s11;
			destination_out	<= destination_out_s11;	
			fee_out 		<= fee_out_s11;	
			time_spent_s	<= time_spent_s11;
			time_spent_m	<= time_spent_m11;
			time_spent_h	<= time_spent_h11;
		when "01000100" =>
			color_ID_out	<= color_ID_out_s12;
			slot_state_out	<= slot_state_out_s12;
			destination_out	<= destination_out_s12;	
			fee_out 		<= fee_out_s12;	
			time_spent_s	<= time_spent_s12;
			time_spent_m	<= time_spent_m12;
			time_spent_h	<= time_spent_h12;
		when "01001000" =>
			color_ID_out	<= color_ID_out_s13;
			slot_state_out	<= slot_state_out_s13;
			destination_out	<= destination_out_s13;	
			fee_out 		<= fee_out_s13;	
			time_spent_s	<= time_spent_s13;
			time_spent_m	<= time_spent_m13;
			time_spent_h	<= time_spent_h13;
		when "01010000" =>
			color_ID_out	<= color_ID_out_s14;
			slot_state_out	<= slot_state_out_s14;
			destination_out	<= destination_out_s14;
			fee_out 		<= fee_out_s14;	
			time_spent_s	<= time_spent_s14;
			time_spent_m	<= time_spent_m14;
			time_spent_h	<= time_spent_h14;	
		when "01100000" =>
			color_ID_out	<= color_ID_out_s15;
			slot_state_out	<= slot_state_out_s15;
			destination_out	<= destination_out_s15;	
			fee_out 		<= fee_out_s15;	
			time_spent_s	<= time_spent_s15;
			time_spent_m	<= time_spent_m15;
			time_spent_h	<= time_spent_h15;
		when "10000001" =>
			color_ID_out	<= color_ID_out_s20;
			slot_state_out	<= slot_state_out_s20;
			destination_out	<= destination_out_s20;	
			fee_out 		<= fee_out_s20;	
			time_spent_s	<= time_spent_s20;
			time_spent_m	<= time_spent_m20;
			time_spent_h	<= time_spent_h20;
		when "10000010" =>
			color_ID_out	<= color_ID_out_s21;
			slot_state_out	<= slot_state_out_s21;
			destination_out	<= destination_out_s21;		
			fee_out 		<= fee_out_s21;		
			time_spent_s	<= time_spent_s21;
			time_spent_m	<= time_spent_m21;
			time_spent_h	<= time_spent_h21;			 
		when "10000100" =>
			color_ID_out	<= color_ID_out_s22;
			slot_state_out	<= slot_state_out_s22;
			destination_out	<= destination_out_s22;		
			fee_out 		<= fee_out_s22;		
			time_spent_s	<= time_spent_s22;
			time_spent_m	<= time_spent_m22;
			time_spent_h	<= time_spent_h22;			 
		when "10001000" =>
			color_ID_out	<= color_ID_out_s23;
			slot_state_out	<= slot_state_out_s23;
			destination_out	<= destination_out_s23;		
			fee_out 		<= fee_out_s23;		
			time_spent_s	<= time_spent_s23;
			time_spent_m	<= time_spent_m23;
			time_spent_h	<= time_spent_h23;			 
		when "10010000" =>
			color_ID_out	<= color_ID_out_s24;
			slot_state_out	<= slot_state_out_s24;
			destination_out	<= destination_out_s24;
			fee_out 		<= fee_out_s24;		
			time_spent_s	<= time_spent_s24;
			time_spent_m	<= time_spent_m24;
			time_spent_h	<= time_spent_h24; 
		when "10100000" =>
			color_ID_out	<= color_ID_out_s25;
			slot_state_out	<= slot_state_out_s25;
			destination_out	<= destination_out_s25;	
			fee_out 		<= fee_out_s25;	
			time_spent_s	<= time_spent_s25;
			time_spent_m	<= time_spent_m25;
			time_spent_h	<= time_spent_h25;
		when others => 
			color_ID_out	<= (others => '0');
			slot_state_out	<= (others => '0');
			destination_out	<= (others => '0');		
			fee_out 		<= (others => '0');	
			time_spent_s	<= (others => '0');
			time_spent_m	<= (others => '0');
			time_spent_h	<= (others => '0');	
	end case;	

end process;

end Behavioral;