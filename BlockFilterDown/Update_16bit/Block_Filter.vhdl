


-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs.
-- The filter is written generic so it is defined as;
--                            Width = number of bits
--                            N = number of tabs   
--			      M = Channel filter type, (to maximise the available space for multiplication)
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n].
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: Jo³n Trausti
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Block_Filter is
    generic(Width    :integer     :=12;
        N :integer    :=188);
    port(    reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           clk6M:IN STD_LOGIC;
           x:IN signed(width-1-4 DOWNTO 0);
           y:OUT signed(WIDTH-1-4 DOWNTO 0);
           finished:OUT STD_LOGIC);
end Block_Filter;



architecture behaiv_arch of Block_Filter is


-- New signals
signal i    :integer range 0 to N+3; --index for how many clkcykles the calculation have been running
signal finished_sig,GoOn,Load_On    :std_logic :='0';
signal y_s    :signed(2*width-1 downto 0);--temporary output
signal x_sig :signed(width-1 downto 0);

type a_pipe is array (0 to N-1) of signed(width-1 downto 0);
type a_queue2multi is array (0 to N-1) of signed(width-1 downto 0);
type a_tL is array (0 to N-1) of signed(width-1 downto 0);

signal pipe    		: a_pipe;
signal queue2multi	:a_queue2multi;
signal t		:a_tL;




-- Old signals



begin


x_sig(width-1 downto 4) <= x;
x_sig(11 downto 0) <= (others => '0');
process(clk,reset)
begin

    -- This will set all the x's to zero, resetting everything.
    -- so when the program start all values have zeros except for the coefficients
    if(reset='1') then
        i<=0;    -- reset the counter
        y_s <= (others => '0');
        y <= (others => '0');
        finished <= '0';
        finished_sig <= '1';
        for i in 0 to (N-1) loop
               pipe(i)<=(others=> '0');
               queue2multi(i)<=(others=> '0');
        end loop;
        

        -- here the coeff. comes in for ex.


    elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------SENDING OUT ---------------------------    
--------------------------------------------------------------------       
        if(clk250k = '1') then   
		Load_On<='1';
        	y_s <= (others => '0');
            	finished_sig <= '0';
           	finished<='0';
         	i<=0;
	elsif(finished_sig = '0' AND Load_On='0' AND GoOn='1') then
		if(i<N) then
			y_s <= y_s + (queue2multi(i)*t(i));
			i <= i+1;
		else
			finished <= '1';
                	finished_sig <= '1';
               		y <= y_s(2*width-2 downto width-1+4);
		end if;
		
        end if;
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  

	if (clk6M='1' ) then 
		pipe <= signed(x_sig)&pipe(0 to pipe'length-2);
	elsif(Load_On ='1') then
		for j in 0 to N-1 loop
             	   queue2multi(j)<= pipe(j);
         	end loop;
		GoOn<='1';  
		Load_On<='0';
	end if;

    end if;
end process;

end behaiv_arch;
