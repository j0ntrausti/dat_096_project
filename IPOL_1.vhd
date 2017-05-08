LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Read_package.all;


entity IPOL_1 is
	Generic(WIDTH : integer:=12);
	port(Clk_100MHz: in std_logic;
		Clk_250KHz: in std_logic; -- input the higher Clk_enable (To interpolate to 6 Mhz, this should be 6 Mhz)
		reset: in std_logic;
		input: in Channels;
		output: out Channels);
end IPOL_1; 

architecture IPOL_1_arch of IPOL_1 is

--IPOL
component interpolator
	generic(WIDTH	:integer 	:=12;
		    interpolate :integer	:=8);
	port(Clk_enable: in std_logic; -- input the higher Clk_enable (To interpolate to 6 Mhz, this should be 6 Mhz)
		reset: in std_logic;
		input: in signed(11 downto 0);
		output: out signed(11 downto 0));
end component;


--IPOL ch_filter
component IPOL_ch_filt 
	generic(Width	:integer 	:=12;
		N :integer	:=86);
	port(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           --clk6M:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end component;

signal pol_2_filt : Channels;
signal finished : STD_LOGIC;

BEGIN

IPOL_1:
    for i in 0 to 15 generate
    IPOL: interpolator
    PORT MAP(
        Clk_enable => clk_250KHz, -- input the higher Clk_enable (To interpolate to 6 Mhz, this should be 6 Mhz)
		reset => reset,
		input => input(i),
		output => pol_2_filt(i)
    );
    end generate IPOL_1;
    
IPOL_filt_1:
    for i in 0 to 15 generate
    filt_x: IPOL_ch_filt
	GENERIC MAP(WIDTH	=> 	WIDTH,
		N => 86)
	PORT MAP(reset => reset,
         clk => Clk_100MHz,
         clk250k => Clk_250KHz,
         --clk6M:IN STD_LOGIC;
         x => pol_2_filt(i), 
         y => output(i),
         finished => finished);
    end generate;


end IPOL_1_arch;
