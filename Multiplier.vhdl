library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity Multiplier is
    GENERIC (WIDTH:INTEGER:=10);
    PORT ( clk : in STD_LOGIC;
           a_r : in SIGNED (WIDTH-1 downto 0);
           a_i : in SIGNED (WIDTH-1 downto 0);
           b_r : in SIGNED (WIDTH-1 downto 0);
           b_i : in SIGNED (WIDTH-1 downto 0);
           ut_r : out SIGNED (WIDTH-1 downto 0);
           ut_i : out SIGNED (WIDTH-1 downto 0));
end Multiplier;


architecture Behavioral of Multiplier is

signal c_r : SIGNED(2*WIDTH-1 downto 0):=(others => '0');
signal c_i : SIGNED(2*WIDTH-1 downto 0):=(others => '0');

begin

process(clk)
begin
 if rising_edge(clk) then
     c_r <= a_r*b_r - a_i*b_i;
     c_i <= a_r*b_i + a_i*b_r;
 end if;
end process;

ut_r <= c_r(2*WIDTH-2 downto WIDTH-1);
ut_i <= c_i(2*WIDTH-2 downto WIDTH-1);

end Behavioral;