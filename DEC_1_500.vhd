library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--first decimation/filter stage (block level)
--takes sampling frequency of one block from 5MHz down to 625KHz, a decimation factory by four
entity DEC_1_625 is
GENERIC (WIDTH:INTEGER:=16);
PORT (clk_100MHz : in STD_LOGIC; -- calculating frequency
      clk_5MHz : in STD_LOGIC;   -- input sampling frequency
      clk_625KHz : in STD_LOGIC; -- output sampling frequency
      reset : in STD_LOGIC;
      in_r : in signed(WIDTH-1 downto 0);   -- real input
      in_i : in signed(WIDTH-1 downto 0);   -- imaginary input
      out_r : out signed(WIDTH-1 downto 0); -- real output
      out_i : out signed(WIDTH-1 downto 0));-- imaginary output
end DEC_1_625;

architecture Behavioral of DEC_1_625 is

component Block_Filter_500
GENERIC (WIDTH:INTEGER:=16;
         N: INTEGER :=0);--number of taps, must be input manually and dont get it wrong!
PORT(reset      :IN STD_LOGIC;
     clk        :IN STD_LOGIC; -- calculating frequency
     clk625k    :IN STD_LOGIC; -- input sampling frequency
     clk5M      :IN STD_LOGIC; -- output sampling frequency
     x          :IN signed(WIDTH-1 DOWNTO 0); -- data input
     y          :OUT signed(WIDTH-1 DOWNTO 0);-- data output
     finished   :OUT STD_LOGIC); -- handshaking bit, not used
end component;

signal finished_r : STD_LOGIC; -- Not used
signal finished_i : STD_LOGIC; -- Not used

begin

filt_r: Block_Filter_500
GENERIC MAP(WIDTH => WIDTH,
            N => 58)
PORT MAP(reset => reset,
         clk => clk_100MHz,
         clk625K => clk_625KHz,
         clk5M => clk_5MHz,
         x =>in_r,
         y => out_r,
         finished => finished_r);
         
filt_i: Block_Filter_500
GENERIC MAP(WIDTH => WIDTH,
            N => 58)
PORT MAP(reset => reset,
         clk => clk_100MHz,
         clk625K => clk_625KHz,
         clk5M => clk_5MHz,
         x => in_i,
         y => out_i,
         finished => finished_i);


end Behavioral;