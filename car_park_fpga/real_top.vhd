library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity WS2812B_SRAM is
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
end entity WS2812B_SRAM;

architecture RTL of WS2812B_SRAM is
	constant length : integer := 23;
	--signal slot : std_logic_vector(7 downto 0) := "00000100";

	signal rst           : std_logic;
	signal addr          : std_logic_vector(integer(ceil(log2(real(length))))-1 downto 0);
	signal data_red      : std_logic_vector(7 downto 0);
	signal data_green    : std_logic_vector(7 downto 0);
	signal data_blue     : std_logic_vector(7 downto 0);
	
	signal data_red_ID   : std_logic_vector(7 downto 0);
	signal data_green_ID : std_logic_vector(7 downto 0);
	signal data_blue_ID  : std_logic_vector(7 downto 0);
	
	signal dataOut_red   : std_logic_vector(7 downto 0);
	signal dataOut_green : std_logic_vector(7 downto 0);
	signal dataOut_blue  : std_logic_vector(7 downto 0);
	signal we            : std_logic;						-- write enable
	signal render        : std_logic;
	signal vsync         : std_logic;
	signal done          : std_logic;
	signal colIdx        : std_logic_vector(1 downto 0);

	component LED_controller is
		generic(
			LED_len : integer := 16;         -- Amount of LEDs on the link
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
			clk           : in  std_logic;
			rst           : in  std_logic;
			-- Hardware Connection
			so            : out std_logic;  -- Serial output to WS2812B
			-- Data Link
			addr          : in  std_logic_vector(integer(ceil(log2(real(LED_len))))-1 downto 0); -- Address of the LED
			data_red      : in  std_logic_vector(7 downto 0);
			data_green    : in  std_logic_vector(7 downto 0);
			data_blue     : in  std_logic_vector(7 downto 0);
			dataOut_red   : out std_logic_vector(7 downto 0);
			dataOut_green : out std_logic_vector(7 downto 0);
			dataOut_blue  : out std_logic_vector(7 downto 0);
			write_en	  : in  std_logic;  -- Write to RAM (Write Enable)
			render        : in  std_logic;  -- Send data to LEDs
			vsync         : out std_logic   -- Finished sending data out 
		);
	end component;

begin
	rst <= not rst_hw;

	colIdx <= addr(1 downto 0);
	data_red_ID   <= color_ID(23 downto 16);
	data_green_ID <= color_ID(15 downto 8);
	data_blue_ID  <= color_ID(7 downto 0);
	
	LED_controller_inst : LED_controller
		generic map(
			LED_len =>	length,
			f_clk	=>	f_clk,
			T0H     =>	T0H,
			T1H     =>	T1H,
			T0L     =>	T0L,
			T1L     =>	T1L,
			DEL     =>	DEL,
			RES     =>	RES
		)
		port map(
			clk           => clk,
			rst           => rst,
			so            => so,
			addr          => addr,
			data_red      => data_red,
			data_green    => data_green,
			data_blue     => data_blue,
			dataOut_red   => dataOut_red,
			dataOut_green => dataOut_green,
			dataOut_blue  => dataOut_blue,
			write_en      => we,
			render        => render,
			vsync         => vsync
		);

	prog : process(clk, rst) is
		variable colRot : unsigned(1 downto 0);
		variable c2     : integer range 0 to 25000000;
		variable leds   : integer range 0 to 23;
	begin
		if rst = '1' then
			addr       <= (others => '1');
			data_red   <= (others => '0');
			data_green <= (others => '0');
			data_blue  <= (others => '0');
			we         <= '0';
			done       <= '1';
			c2         := 0;
			colRot     := "00";
			render     <= '0';
		elsif rising_edge(clk) then
			we     <= '0';
			render <= '0';
			if done = '0' then
				addr <= std_logic_vector(unsigned(addr) + 1);

				-- If we wrote the entire strip, render the data!
				if to_integer(unsigned(addr)) = length - 1 then
					done   <= '1';
					render <= '1';
				end if;

				if (slot = "00000001") then
					leds := 9;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000010") then
					leds := 13;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00001000") then
					leds := 23;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) or (to_integer(unsigned(addr)) = 17) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;
----------------------------------------------------------
				if (slot = "01000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				if (slot = "00000100") then
					leds := 19;
					
					if to_integer(unsigned(addr)) > leds then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					elsif (to_integer(unsigned(addr)) = 7) or (to_integer(unsigned(addr)) = 11) then
						data_red   <= (others => '0');
						data_green <= (others => '0');
						data_blue  <= (others => '0');
					else
						data_red   <= data_red_ID;
						data_green <= data_green_ID;
						data_blue  <= data_blue_ID;
					end if;
				end if;

				--if (btn_n = '0') then
				--	data_red   <= (others => '1');
				--	data_green <= (others => '1');
				--	data_blue  <= (others => '1');
				--end if;
				we <= '1';
			else
				if c2 = 10000000 then
					done   <= '0';
					c2     := 0;
					colRot := colRot + 1;
				else
					c2 := c2 + 1;
				end if;
			end if;
		end if;
	end process prog;

end architecture RTL;