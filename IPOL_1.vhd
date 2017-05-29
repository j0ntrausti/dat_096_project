LIBRARY ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.Read_package.all;

--first interpolation/filter stage (channel level)
--takes sampling frequency of eight channels from 31.25Khz up to 312.5Khz, an interpolation factor by ten
entity IPOL_1 is
	GENERIC(WIDTH : integer:=12);
	PORT(   clk_100MHz: in STD_LOGIC;  -- calculating frequency
            clk_312KHz: in STD_LOGIC;  -- output sampling frequency
            clk_31Khz: in STD_LOGIC;   -- input sampling frequency
            reset: in STD_LOGIC;    
            input: in Channels;   -- input of 8 channels, real and imaginary(16x 12bit signed VECTOR array)
            output: out Channels);-- output of 8 channels, real and imaginary(16x 12bit signed VECTOR array)
end IPOL_1; 

architecture IPOL_1_arch of IPOL_1 is

--IPOL ch_filter
component IPOL_ch_filt 
	GENERIC(WIDTH	:integer 	:=12;
		N :integer	:=86;
		inter: integer:=10);
	PORT(  reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;    -- calculating frequency
           clk312k:IN STD_LOGIC;-- output sampling frequency
           clk31k:IN STD_LOGIC; -- input sampling frequency
           x:IN signed(WIDTH-1 DOWNTO 0); -- input
           y:OUT signed(WIDTH-1 DOWNTO 0);-- output
           finished:OUT STD_LOGIC); -- handshaking bit, not used
end component;

signal pol_2_filt : Channels;
signal finished : STD_LOGIC; -- not used

BEGIN

-- Declare 16 filters for 8 channels (real and imaginary)    
IPOL_filt_1:
    for i in 0 to 15 generate
    filt_x: IPOL_ch_filt
	GENERIC MAP(WIDTH	=> 	WIDTH,
		N => 110,
		inter => 10)
	PORT MAP(reset => reset,
         clk => clk_100MHz,
         clk312k => clk_312KHz,
         clk31k => clk_31KHz,
         x => input(i), -- index into array, resulting in 16bit signed vector
         y => output(i),-- index into array, resulting in 16bit signed vector
         finished => finished);
    end generate;


end IPOL_1_arch;
