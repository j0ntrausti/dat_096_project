library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.Read_package.all;

entity DEC_2 is
GENERIC (WIDTH:INTEGER:=10);
Port ( clk_100MHz : in STD_LOGIC;
	   clk_250KHz : in STD_LOGIC;
       clk_31KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_channels : in Channels;
       out_channels : out Channels
       );
end DEC_2;

architecture Behavioral of DEC_2 is

component ChannelFilter_1
GENERIC (WIDTH:INTEGER:=12;
         N: INTEGER :=93);
	port(reset      :IN STD_LOGIC;
         --start      :IN STD_LOGIC;
         clk        :IN STD_LOGIC;
         clk250K    :IN STD_LOGIC;
         clk6M      :IN STD_LOGIC;
         x          :IN Channels;
         y          :OUT Channels;
         finished   :OUT STD_LOGIC);
end component;

signal filt_in : signed(WIDTH-1 DOWNTO 0);
signal filt_out : signed(WIDTH-1 DOWNTO 0);
signal finished_r : STD_LOGIC;
signal ch : integer:=16; -- nr of channels (real and imaginary)


begin

filt: ChannelFilter_1
GENERIC MAP(WIDTH => WIDTH,
            N => 93)
PORT MAP(reset => reset,
         --start => start_i,
         clk => clk_100MHz,
         clk250K => clk_31KHz,
         clk6M => clk_250KHz,
         x => in_channels,
         y => out_channels,
         finished => finished_r);

end Behavioral;
