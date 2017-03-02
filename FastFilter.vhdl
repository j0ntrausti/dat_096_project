
-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs. 
-- The filter is written generic so it is defined as;
--							Width = number of bits
--							N = number of tabs   
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n]. 
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: Jón Trausti
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FastFilter is 
	generic(Width	:integer 	:=8;
		N :integer	:=4);
	port(	reset:STD_LOGIC;
           clk:STD_LOGIC;
           clk250k:STD_LOGIC;
           clk6M:STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(2*WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);

end FastFilter;



architecture behaiv_arch of FastFilter is


-- New signals
signal swapping	:std_logic :='0'; --this shall trigger when start goes to '1' and go down when start goes to '0' to see if there is a new x or not
signal i	:integer range 0 to N; --index for how many clkcykles the calculation have been running
signal finished_sig	:std_logic :='1';
-- For our x's
-- (2*(N-1)-2) is the last X, yeah I've done the calc right, unless I'm wrong (haven't tested) 
type xLArray is array (0 to (2*(N-1)-2)) of signed(width-1 downto 0);
signal xL	:xLArray;

type MiddleArray is array (0 to (N-1)) of signed(width-1 downto 0); --- need to fix size
signal MiddleAdder	:MiddleArray;

type queue2multiArray is array (0 to (N-1)) of signed(width-1 downto 0); --- need to fix size
signal queue2multi	:queue2multiArray;

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
		 -- Pretty much same as start, just double sec. since start is input signal
		i<=0;	-- reset the counter 
		y_s <= (others => '0');
		finished <= '0';
		finished_sig <= '1';
		for i in 0 to (2*(N-1)-2) loop
			if (i<(2*(N-1)-1)) then
				xL(i)<=(others=> '0'); 
			end if;
		end loop;
		
		-- here the coeff. comes in for ex. 
		--t(0)<="000000000000";
		t(0)<= "11011000";
		t(1)<= "00011101";
		t(2)<= "00011101";
		t(3)<= "11011000";

	elsif (rising_edge(clk)) then		       -- 100 MHz
		if(finished_sig = '0') then
			
			if(i=N) then
				finished <= '1';
				finished_sig <= '1';
				y <= (y_s sll 1);
			else
				y_s <= ((queue2multi(i)*t(i))+y_s);
				i <= i+1;
			end if;
		elsif(clk250k = '1') then			-- 250 kHz not sure about this.... the need for it
			finished_sig <= '0';
			finished<='0';
			i<=0;
			for j in 0 to N-1 loop
				queue2multi(j)<= MiddleAdder(j);
			end loop;
			
		end if;

		if (clk6M='1' AND swapping='0') then    -- 6 MHz
			
			
			swapping<='1';
			y_s <= (others => '0');
			-- the first adding
			MiddleAdder(0)<=(xL((2*(N-1)-2)) + x); 
			-- the last adding
			MiddleAdder(N-1)<= (xL((N/2)-1));            			
			-- all the other adding 
			for j in 1 to N-2 loop
				MiddleAdder(j)<= (xL(j-1) + xL(2*(N-1)-2-j));
			end loop;


		-- possible error, check the timing if they match.
		elsif (swapping='1') then
			-- this is the "delay" process, that moves x's to new location.
			-- its ok the swap them this soon, since after we load the middle adder we don't care about them.
			for j in 0 to (2*(N-1)-2) loop
				if (j<(2*(N-1)-2)) then
					xL((2*(N-1)-2)-j)<=xL((2*(N-1)-3)-j);
				elsif (j=(2*(N-1)-2)) then
					xL(0)<=x;
				end if;
			end loop;
			swapping<='0';	
		end if;
	end if;
end process;

end behaiv_arch;