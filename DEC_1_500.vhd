library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity DEC_1_500 is
GENERIC (WIDTH:INTEGER:=12);
Port ( clk_100MHz : in STD_LOGIC;
       clk_4MHz   : in STD_LOGIC;
       clk_500KHz : in STD_LOGIC;
       --start : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r : out signed(WIDTH-1 downto 0);
       out_i : out signed(WIDTH-1 downto 0)
       );
end DEC_1_500;

architecture Behavioral of DEC_1_500 is

component Block_Filter_500
GENERIC (WIDTH:INTEGER:=12;
         N: INTEGER :=2018);
	port(reset      :IN STD_LOGIC;
         --start      :IN STD_LOGIC;
         clk        :IN STD_LOGIC;
         clk500k    :IN STD_LOGIC;
         clk4M      :IN STD_LOGIC;
         x          :IN signed(WIDTH-5 DOWNTO 0);
         y          :OUT signed(WIDTH-5 DOWNTO 0);
         finished   :OUT STD_LOGIC);
end component;

--signal start_r : STD_LOGIC;
signal filt_out_r : signed(WIDTH-1 DOWNTO 0);
signal finished_r : STD_LOGIC;

--signal start_i : STD_LOGIC;
signal filt_out_i : signed(WIDTH-1 DOWNTO 0);
signal finished_i : STD_LOGIC;

begin

filt_r: Block_Filter_500
GENERIC MAP(WIDTH => 16,
            N => 27)
PORT MAP(reset => reset,
         --start => start_r,
         clk => clk_100MHz,
         clk500k => clk_500KHz,
         clk4M => clk_4MHz,
         --start => clk_6MHz,
         x =>in_r,
         y => filt_out_r,
         finished => finished_r);
         
filt_i: Block_Filter_500
GENERIC MAP(WIDTH => 16,
            N => 27)
PORT MAP(reset => reset,
         --start => start_r,
         clk => clk_100MHz,
         clk500k => clk_500KHz,
         clk4M => clk_4MHz,
         --start => clk_6MHz,
         x => in_i,
         y => filt_out_i,
         finished => finished_i);

out_i <= filt_out_i;
out_r <= filt_out_r;

end Behavioral;