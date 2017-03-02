library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ADC is
GENERIC (WIDTH:INTEGER:=10);
Port ( clk_6MHz : in STD_LOGIC;
       reset    : in STD_LOGIC;
       adc_out  : out signed(WIDTH-1 downto 0)
       );
end ADC;

architecture Behavioral of ADC is

signal test : signed(WIDTH-1 downto 0):=(others => '0');

begin

process(clk_6MHz, reset)
begin
    if reset = '1' then
        test <= (others => '0');
    elsif rising_edge(clk_6MHz) then
        test <= test + 500;
    end if;
end process;

adc_out <= test;
  
end Behavioral;