library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--second decimation/filter stage (block level)
--takes sampling frequency of one block from 625MHz down to 312.5KHz, a decimation factory by two
entity DEC_1_312 is
GENERIC (WIDTH:INTEGER:=12);
PORT ( clk_100MHz : in STD_LOGIC; -- calculating frequency
       clk_625KHz : in STD_LOGIC; -- input sampling frequency
       clk_312KHz : in STD_LOGIC; -- output sampling frequency
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);   -- real input
       in_i : in signed(WIDTH-1 downto 0);   -- imaginary input
       out_r : out signed(WIDTH-1 downto 0); -- real input
       out_i : out signed(WIDTH-1 downto 0));-- imaginary output
end DEC_1_312;

architecture Behavioral of DEC_1_312 is

component Block_Filter_250
GENERIC (WIDTH:INTEGER:=12;
         N: INTEGER :=2018);
	PORT(reset      :IN STD_LOGIC;
         clk        :IN STD_LOGIC;
         clk312K    :IN STD_LOGIC;
         clk625K    :IN STD_LOGIC;
         x          :IN signed(WIDTH-1 DOWNTO 0);
         y          :OUT signed(WIDTH-1 DOWNTO 0);
         finished   :OUT STD_LOGIC);
end component;

signal finished_r : STD_LOGIC; -- not used
signal finished_i : STD_LOGIC; -- not used

begin

--Filter for real part
filt_r: Block_Filter_250
GENERIC MAP(WIDTH => WIDTH,
            N => 214)
PORT MAP(reset => reset,
         clk => clk_100MHz,
         clk312K => clk_312KHz,
         clk625K => clk_625KHz,
         x =>in_r,
         y => out_r,
         finished => finished_r);

--Filter for imagniary part
filt_i: Block_Filter_250
GENERIC MAP(WIDTH => WIDTH,
            N => 214)
PORT MAP(reset => reset,
         clk => clk_100MHz,
         clk312K => clk_312KHz,
         clk625K => clk_625KHz,
         x => in_i,
         y => out_i,
         finished => finished_i);


end Behavioral;