library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity First_Multi is -- This multiplier takes a real signal and multiplies it with a complex signal
    GENERIC (WIDTH:INTEGER:=10);
    Port ( clk : in STD_LOGIC;
           a_r : in SIGNED (WIDTH-1 downto 0); -- Comes from signal

           b_r : in SIGNED (WIDTH-1 downto 0); -- Generated sine wave
           b_i : in SIGNED (WIDTH-1 downto 0); -- Generated cosine wave
           ut_r : out SIGNED (WIDTH-1 downto 0);
           ut_i : out SIGNED (WIDTH-1 downto 0));
end First_Multi;


architecture Behavioral of First_Multi is

signal c_r : SIGNED(2*WIDTH-1 downto 0):=(others => '0');
signal c_i : SIGNED(2*WIDTH-1 downto 0):=(others => '0');

begin

process(clk)
begin
 if rising_edge(clk) then
     c_r <= a_r*b_r; --(x+yi)(u+vi)=(xu - yv) + (xv +yu)
     c_i <= a_r*b_i;
 end if;
end process;

ut_r <= c_r(2*WIDTH-2 downto WIDTH-1);
ut_i <= c_i(2*WIDTH-2 downto WIDTH-1);

end Behavioral;