
-- CHANNEL FILTER FOR INTERPOLATION OF ... N, this

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

entity IPOL_bl_filt_2 is 
	generic(Width	:integer 	:=16;
		N :integer	:=86);
	port(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           --clk250k:IN STD_LOGIC;
           clk4M:IN STD_LOGIC;
           x:IN signed(WIDTH-1-4 DOWNTO 0);
           y:OUT signed(WIDTH-1-4 DOWNTO 0);
           finished:OUT STD_LOGIC);
end IPOL_bl_filt_2;



architecture behaiv_arch of IPOL_bl_filt_2 is


-- Signals
signal i,k,j,max	:integer range 0 to N; --index for how many clkcykles the calculation have been running
signal finished_sig,GoOn,Load_On    :std_logic :='0';
signal x_sig :signed(width-1 downto 0);
-- Array types
type a_array is array (0 to (N-1)) of signed(width-1 downto 0);
type a_locator is array (0 to 50) of integer;

-- Array Signals
signal t		:a_array;
signal queue2multi	:a_array;
signal pipe		:a_array;
signal loc		:a_locator;



-- Old signals

signal y_s	:signed(2*width-1 downto 0);--temporary output

begin

x_sig(width-1 downto 4) <= x;
x_sig(3 downto 0) <= (others => '0');

process(clk,reset)
begin

	-- This will set all the x's to zero, resetting everything.
	-- so when the program start all values have zeros except for the coefficients
	if(reset='1') then
		 -- Pretty much same as start, just double sec. since start is input signal
		i<=0;	-- reset the counter 
		k<=0;	
		max <= 0;
		y_s <= (others => '0');
		finished <= '0';
		finished_sig <= '1';	
	    	for i in 0 to (N-1) loop
             	 queue2multi(i)<=(others=> '0'); 
			     pipe(i)<=(others=> '0'); 
        	end loop;
        	for i in 0 to 50 loop
                loc(i) <= 0;
            end loop;
		
		-- here the coeff. comes in for ex. 
t(0)<="1111111111110011";
        t(1)<="0000000000010001";
        t(2)<="0000000001011001";
        t(3)<="0000000011110001";
        t(4)<="0000000111110111";
        t(5)<="0000001101111011";
        t(6)<="0000010101110111";
        t(7)<="0000011111001010";
        t(8)<="0000101000111001";
        t(9)<="0000110001110101";
        t(10)<="0000111000101100";
        t(11)<="0000111100011011";
        t(12)<="0000111100011011";
        t(13)<="0000111000101100";
        t(14)<="0000110001110101";
        t(15)<="0000101000111001";
        t(16)<="0000011111001010";
        t(17)<="0000010101110111";
        t(18)<="0000001101111011";
        t(19)<="0000000111110111";
        t(20)<="0000000011110001";
        t(21)<="0000000001011001";
        t(22)<="0000000000010001";
        t(23)<="1111111111110011";


	elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  
	

	-- Single clock to start the filter
	if (clk4M='1') then 
		pipe <= signed(x_sig)&pipe(0 to pipe'length-2);
		Load_On<='1';
        	y_s <= (others => '0');
            	finished_sig <= '0';
           	finished<='0';
         	i<=0;
	elsif(Load_On ='1') then
		
		for j in 0 to N-1 loop
		   -- Isn't there a shorter format to check this?
             	   if(pipe(j)= ("0000000000000000" XNOR "1111111111111111") OR t(j)= ("0000000000000000" XNOR "1111111111111111"))  then
				queue2multi(k)<= pipe(j); -- could make the array shorter?
				if(j = N-1) then
					max <= k;
					loc(k) <= j;
				else
					k <= k+1;
					loc(k) <= j;
				end if;
			end if;
         	end loop;
		GoOn<='1';  
		Load_On<='0';
	elsif(finished_sig = '0' AND GoOn='1') then

		if(i<=max) then
			y_s <= ((queue2multi(i)*  t(loc(i)))+y_s);
			i <= i+1;
		else
			finished <= '1';
               		finished_sig <= '1';
			max <= 0;
			k<=0;
			i<=0;
                	y <= y_s(2*width-2 downto width-1+4);
                end if;
	end if;
    end if;
end process;

end behaiv_arch;

