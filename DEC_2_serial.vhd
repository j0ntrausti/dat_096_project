library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.Read_package.all;

--third decimation/filter stage (channel level)
--takes sampling frequency of eigth channels from 312.5Khz down to 31.25Khz, a decimation factor by ten
entity DEC_2 is
GENERIC (WIDTH:INTEGER:=10);
PORT ( clk_100MHz : in STD_LOGIC; -- calculating frecuency
	   clk_312KHz : in STD_LOGIC; -- input sampling frequency
       clk_31KHz : in STD_LOGIC;  -- output sampling frequency
       reset : in STD_LOGIC;
       in_channels : in Channels;   -- input of 8 channels, real and imaginary(16x 12bit signed VECTOR array)
       out_channels : out Channels);-- output of 8 channels, real and imaginary(16x 12bit signed VECTOR array)
end DEC_2;

architecture Behavioral of DEC_2 is

component ChannelFilter_1
GENERIC (WIDTH:INTEGER:=12;
         N: INTEGER :=93);
	PORT(reset      :IN STD_LOGIC;
         clk        :IN STD_LOGIC;
         clk31K     :IN STD_LOGIC;
         clk312K    :IN STD_LOGIC;
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
            N => 110)
PORT MAP(reset => reset,
         clk => clk_100MHz,
         clk31K => clk_31KHz,
         clk312K => clk_312KHz,
         x => in_channels,
         y => out_channels,
         finished => finished_r);

end Behavioral;
