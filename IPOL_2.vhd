LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Read_package.all;


entity IPOL_2 is
	Generic(WIDTH : integer:=12);
	port(Clk_100MHz: in std_logic;
		Clk_500KHz: in std_logic; -- input the higher Clk_enable (To interpolate to 6 Mhz, this should be 6 Mhz)
		clk_250KHz: in std_logic;
		reset: in std_logic;
		input_r: in Signed;
		input_i: in Signed;
		output_r: out Signed;
		output_i: out Signed);
end IPOL_2; 

architecture IPOL_2_arch of IPOL_2 is

----IPOL
--component interpolator
--	generic(WIDTH	:integer 	:=12;
--		    interpolate :integer	:=8);
--	port(Clk_enable: in std_logic; -- input the higher Clk_enable (To interpolate to 6 Mhz, this should be 6 Mhz)
--		reset: in std_logic;
--		input: in signed(11 downto 0);
--		output: out signed(11 downto 0));
--end component;

--IPOL bl_filter
component IPOL_bl_filt_1 
	generic(Width	:integer 	:=12;
		N :integer	:=86;
            inter: integer:=2);
	port(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk500k:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           x:IN signed(WIDTH-5 DOWNTO 0);
           y:OUT signed(WIDTH-5 DOWNTO 0);
           finished:OUT STD_LOGIC);
end component;

signal pol_2_filt_r : Signed(WIDTH-1 downto 0);
signal pol_2_filt_i : Signed(WIDTH-1 downto 0);
signal finished_r : STD_LOGIC;
signal finished_i : STD_LOGIC;

BEGIN


--IPOL_r: interpolator
--    PORT MAP(
--        Clk_enable => clk_500KHz, -- input the higher Clk_enable (To interpolate to 6 Mhz, this should be 6 Mhz)
--		reset => reset,
--		input => input_r,
--		output => pol_2_filt_r
--    );

--IPOL_i: interpolator
--    PORT MAP(
--        Clk_enable => clk_500KHz, -- input the higher Clk_enable (To interpolate to 6 Mhz, this should be 6 Mhz)
--        reset => reset,
--        input => input_i,
--        output => pol_2_filt_i
--    );
    

filt_r: IPOL_bl_filt_1
	GENERIC MAP(WIDTH => 16,
		N => 214,
		inter => 2)
	PORT MAP(reset => reset,
         clk => Clk_100MHz,
         clk500k => Clk_500KHz,
         clk250k => Clk_250KHz,
         x => input_r, 
         y => output_r,
         finished => finished_r);
         
filt_i: IPOL_bl_filt_1
    GENERIC MAP(WIDTH => 16,
                N => 214,
                inter => 2)
    PORT MAP(reset => reset,
        clk => Clk_100MHz,
        clk500k => Clk_500KHz,
        clk250k => clk_250KHz,
        x => input_i, 
        y => output_i,
        finished => finished_i);

end IPOL_2_arch;
