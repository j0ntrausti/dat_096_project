-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs. 
-- The filter is written generic so it is defined as;
--							Width = number of bits
--							N = number of tabs   
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n]. 
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: Jón Trausti & Raja
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity linearphaseFIR is 
	generic(Width	:integer 	:=16;
		N :integer	:=100);
	port(	reset:STD_LOGIC;
           start:STD_LOGIC;
           clk:STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(2*WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end linearphaseFIR;



architecture behaiv_arch of linearphaseFIR is
-- New signals
signal onGoing	:std_logic :='0'; --this shall trigger when start goes to '1' and go down when start goes to '0' to see if there is a new x or not
signal i	:integer range 0 to N; --index for how many clkcykles the calculation have been running

-- For our x's
-- (2*(N-1)-2) is the last X, yeah I've done the calc right, unless I'm wrong (haven't tested) 
type xLArray is array (0 to (2*(N-1)-2)) of signed(width-1 downto 0);
signal xL	:xLArray;

-- For the tabs
type tLArray is array (0 to N-1) of signed(width-1 downto 0);
signal t	:tLArray;




-- Old signals

signal y_s	:signed(2*width-1 downto 0);--temporary output

begin

process(clk,reset)
begin

	-- This will set all the x's to zero, resetting everything.
	-- so when the program start all values have zeros except for the coefficients
	if(reset='1') then
		onGoing<='0'; -- Pretty much same as start, just double sec. since start is input signal
		i<=0;	-- reset the counter 
	
		for i in 0 to (2*(N-1)-2) loop
			if (i<(2*(N-1)-1)) then
				xL(i)<=(others=> '0'); 
			end if;
		end loop;
		
		-- here the coeff. comes in for ex. 
		--t(0)<="000000000000";

	elsif (rising_edge(clk)) then		
		if (start='1' AND onGoing='0') then
			finished<='0';
			onGoing<='1';
			y_s<=(xL((2*(N-1)-2)) + x)*t(0);
			i<=1;	
		elsif (ongoing='1') then
			-- First Case
			
			if (i=N-1) then--last itteration	
				i<=0;
				onGoing<='0';
				finished<='1';
				y<=((xL(i-1))*(t(i))+(y_s)); -- maybe I need to shift it??
				for j in 0 to (2*(N-1)-2) loop--Swap the x-array
					if (j<(2*(N-1)-2)) then
						xL((2*(N-1)-2)-j)<=xL((2*(N-1)-3)-j);
					elsif (j=(2*(N-1)-2)) then
						xL(0)<=x;
					end if;
				end loop;
			else
				
				y_s<=((xL(i-1) + xL(2*(N-1)-3-i))*t(i)+y_s);		
				i<=i+1;
				
			end if;	
		end if;
	end if;
end process;

end behaiv_arch;
