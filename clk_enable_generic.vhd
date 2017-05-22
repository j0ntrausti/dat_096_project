-- SamplingClock
LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY clk_enable_generic IS
	GENERIC (N:integer); --clock division factor
    PORT( clk       : in STD_LOGIC;
          reset	    : in STD_LOGIC;
		  clk_enable: out STD_LOGIC);
END clk_enable_generic;

ARCHITECTURE arch OF clk_enable_generic IS

signal i : integer range 0 to N;

begin 

process(clk,reset)	
begin
	if (reset='1') then
		i<=0;
	elsif rising_edge(clk) then
		if (i = 0) then
			clk_enable<='1';
			i<=i+1;
		elsif(i=N-1) then
			clk_enable<='0';
			i<=0;
		else
			clk_enable<='0';
			i<=i+1;
		end if;
	end if;
end process;
END arch;

