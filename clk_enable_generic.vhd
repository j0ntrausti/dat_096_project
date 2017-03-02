-- SamplingClock
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY clk_enable_generic IS
	generic (N:integer); --how fast should the clock be.
    PORT( clk       : in STD_LOGIC;
          reset	    : in STD_LOGIC;
          end_clk   : out STD_LOGIC;
		      clk_enable: out STD_LOGIC);
END clk_enable_generic;

ARCHITECTURE arch OF clk_enable_generic IS
signal i : integer range 0 to N;   -- not sure if this will synthesise
begin 

process(clk,reset)
	
begin

	if (reset='1') then
		i<=0;
	elsif rising_edge(clk) then
		if (i = 0) then
			clk_enable<='1';
			end_clk<='0';
			i<=i+1;
  			
		elsif(i < (N/2)) then
			clk_enable<='0';
			end_clk<='0';
			i <= i+1;
		elsif(i=N) then
			clk_enable<='0';
			end_clk<='1';
			i<=0;
		else
			clk_enable<='0';
			end_clk<='0';
			i<=i+1;
		end if;
	end if;
end process;
END arch;

