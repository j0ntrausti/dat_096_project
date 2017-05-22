LIBRARY ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.Read_package.all;

--third interpolation/filter stage (block level)
--takes sampling frequency of one block from 625KHz up to 5MHz, an interpolation factor by four
entity IPOL_3 is
	GENERIC(WIDTH : integer:=12);
	PORT(clk_100MHz: in STD_LOGIC; -- calculating frequency
         clk_625KHz: in STD_LOGIC;  -- input sampling frequency
         clk_5MHz: in STD_LOGIC;    -- output sampling frequency
         reset: in STD_LOGIC;
         input_r: in Signed;    -- real input
         input_i: in Signed;    -- imaginary input
         output_r: out Signed;  -- real output
         output_i: out Signed); -- imaginary output
end IPOL_3; 

architecture IPOL_3_arch of IPOL_3 is

--IPOL ch_filter
component IPOL_bl_filt_2 
	GENERIC(WIDTH	:integer 	:=12;
		N :integer	:=86;
        inter: integer:=8);
	PORT(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk500k:IN STD_LOGIC;
           clk4M:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end component;

signal pol_2_filt_r : Signed(WIDTH-1 downto 0);
signal pol_2_filt_i : Signed(WIDTH-1 downto 0);
signal finished_r : STD_LOGIC;
signal finished_i : STD_LOGIC;

BEGIN

-- filter for real part
filt_r: IPOL_bl_filt_2
	GENERIC MAP(WIDTH => WIDTH,
		N => 58,
		inter => 8)
	PORT MAP(reset => reset,
         clk => clk_100MHz,
         clk4M => clk_5MHz,
         clk500k => clk_625KHz,
         x => input_r, 
         y => output_r,
         finished => finished_r);

-- filter for imaginary part         
filt_i: IPOL_bl_filt_2
    GENERIC MAP(WIDTH => WIDTH,
                N => 58,
                inter => 8)
    PORT MAP(reset => reset,
        clk => clk_100MHz,
        clk4M => clk_5MHz,
        clk500k => clk_625KHz,
        x => input_i, 
        y => output_i,
        finished => finished_i);

end IPOL_3_arch;
