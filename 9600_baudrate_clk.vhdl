-------------------------------------------------------------------------------------------
---file:9600_baudrate_clk.vhdl
---purpose: one of the components of UART code
------------createscreates a 9600Khz baud rate clock for the serial communication
-------------------------------------------------------------------------------------------
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;
use IEEE.std_logic_arith.all;

entity samplefreq_clk_9600khz is
port(	
        clk : in std_logic;
	    samplefreq_clk : out std_logic);
end samplefreq_clk_9600khz; 

architecture samplefreq_clk_9600khz_arch of samplefreq_clk_9600khz is


signal count : integer:=0;

begin

PROCESS (clk)
begin

if rising_edge(clk) then

	if count = 10400 then    ---9600 boud rate
		samplefreq_clk <= '1';
		count <= 0;
	elsif count > 10300 then
		samplefreq_clk <= '1';
		count <= count +1;
	else
		samplefreq_clk <= '0';
		count <= count +1;
	end if;
end if;
end process;
end samplefreq_clk_9600khz_arch;
