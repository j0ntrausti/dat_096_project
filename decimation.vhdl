-- Generic decimation, output the first 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decimation is 
	generic(Width	:integer 	:=12;
		N :integer	:=24);
	port(	
	   reset:STD_LOGIC;
           clk:STD_LOGIC;
           x_in:IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
           x_out:OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0));
end decimation;

architecture behaiv_arch of decimation is

signal x_middle	:std_logic_vector(width-1 downto 0);--temporary output
signal counter	:integer range 0 to N; --how big decimation

begin

process(clk,reset)
begin
	if(reset='1') then
		counter <= N-1; 
		x_middle <= (others => '0');	
	elsif (rising_edge(clk)) then	
		x_middle <= x_in;
		counter <= counter + 1;
		if(counter = N) then
			x_out <= x_middle;
			counter <= 1;
		end if;	
	end if;
end process;

end behaiv_arch;