library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity DEC_2 is
GENERIC (WIDTH:INTEGER:=10);
Port ( clk_100MHz : in STD_LOGIC;
	   clk_6MHz : in STD_LOGIC;
       clk_250KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r : out signed(WIDTH-1 downto 0);
       out_i : out signed(WIDTH-1 downto 0)
       );
end DEC_2;

architecture Behavioral of DEC_2 is

component filter
GENERIC (WIDTH:INTEGER:=12;
         N: INTEGER :=4);
	port(reset      :STD_LOGIC;
         start      :STD_LOGIC;
         clk        :STD_LOGIC;
         x          :IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
         y          :OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);
         finished   :OUT STD_LOGIC);
end component;

signal start_r : STD_LOGIC;
signal filt_out_r : STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);
signal finished_r : STD_LOGIC;

signal start_i : STD_LOGIC;
signal filt_out_i : STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);
signal finished_i : STD_LOGIC;

begin

filt_r: filter
GENERIC MAP(WIDTH => WIDTH,
            N => 4)
PORT MAP(reset => reset,
         start => start_r,
         clk => clk_100MHz,
         x => STD_LOGIC_VECTOR(in_r),
         y => filt_out_r,
         finished => finished_r);
         
filt_i: filter
GENERIC MAP(WIDTH => WIDTH,
            N => 4)
PORT MAP(reset => reset,
         start => start_i,
         clk => clk_100MHz,
         x => STD_LOGIC_VECTOR(in_i),
         y => filt_out_i,
         finished => finished_i);


process(clk_6MHz,clk_100MHz, reset)
begin
    if reset = '1' then
        out_r <= (others => '0');
        out_i <= (others => '0');
    elsif rising_edge(clk_100MHz) then
      start_r <= clk_250kHz;
      start_i <= clk_250kHz;
      if (finished_r = '1') then
        out_r <= signed(filt_out_r(2*WIDTH-2 downto WIDTH-1));
      end if;
      if (finished_i = '1') then
        out_i <= signed(filt_out_i(2*WIDTH-2 downto WIDTH-1));
      end if;
    end if;
end process;

end Behavioral;
