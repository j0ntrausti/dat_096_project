LIBRARY ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.Read_package.all;

--IPOL_2
--second interplation/filter stage (block level)
--takes sampling frequency of one block from 312.5KHz up to 625KHz, an interpolation factor by two
entity IPOL_2 is
	GENERIC(WIDTH : integer:=12);
	PORT(   clk_100MHz: in STD_LOGIC; -- calculating frequency
            clk_312KHz: in STD_LOGIC; -- input sampling frequency
            clk_625KHz: in STD_LOGIC; -- output sampling frequency
            reset: in STD_LOGIC;
            input_r: in Signed;   -- real input
            input_i: in Signed;   -- imaginary input
            output_r: out Signed; -- real output
            output_i: out Signed);-- imaginary output
end IPOL_2; 

architecture IPOL_2_arch of IPOL_2 is

--IPOL bl_filter
component IPOL_bl_filt_1 
	GENERIC(WIDTH	:integer 	:=12;
		N :integer	:=86;
            inter: integer:=2);
	PORT(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk625k:IN STD_LOGIC;
           clk312k:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end component;

signal pol_2_filt_r : Signed(WIDTH-1 downto 0);
signal pol_2_filt_i : Signed(WIDTH-1 downto 0);
signal finished_r : STD_LOGIC;
signal finished_i : STD_LOGIC;

BEGIN

filt_r: IPOL_bl_filt_1
	GENERIC MAP(WIDTH => WIDTH,
		N => 214,
		inter => 2)
	PORT MAP(reset => reset,
         clk => clk_100MHz,
         clk625k => clk_625KHz,
         clk312k => clk_312KHz,
         x => input_r, 
         y => output_r,
         finished => finished_r);
         
filt_i: IPOL_bl_filt_1
    GENERIC MAP(WIDTH => WIDTH,
                N => 214,
                inter => 2)
    PORT MAP(reset => reset,
        clk => clk_100MHz,
        clk625k => clk_625KHz,
        clk312k => clk_312KHz,
        x => input_i, 
        y => output_i,
        finished => finished_i);

end IPOL_2_arch;
