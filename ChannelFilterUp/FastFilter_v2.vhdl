
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

entity FastFilter is 
	generic(Width	:integer 	:=16;
		N :integer	:=56;
		inter:integer :=2);
	port(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
	   clk250k:IN STD_LOGIC;
           clk6M:IN STD_LOGIC;
           x:IN signed(WIDTH-5 DOWNTO 0);
           y:OUT signed(WIDTH-5 DOWNTO 0);
           finished:OUT STD_LOGIC);
end FastFilter;



architecture behaiv_arch of FastFilter is


-- Signals
signal i,k	:integer range 0 to N; --index for how many clkcykles the calculation have been running
signal finished_sig,GoOn    :std_logic :='0';

-- Array types
type a_array is array (0 to (N-1)) of signed(width-1 downto 0);
type p_array is array (0 to (N/inter -1)) of signed(width-1 downto 0);

-- Array Signals
signal t		:a_array;
signal pipe		:p_array;



-- Old signals

signal y_s,a_s,x_sig	:signed(2*width-1 downto 0);--temporary output

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
		a_s <= (others => '0');
		y_s <= (others => '0');
		finished <= '0';
		finished_sig <= '1';	
	    	for i in 0 to (pipe'length-1) loop
			pipe(i)<=(others=> '0'); 
        	end loop;

		
		
		-- here the coeff. comes in for ex. 
		t(0)<="000000000001"; -- *0
t(1)<="000000000000";
t(2)<="000000000000";
t(3)<="000000000000";
t(4)<="111111111111";
t(5)<="111111111101";
t(6)<="111111111011";
t(7)<="111111111001";
t(8)<="111111110110";
t(9)<="111111110011";
t(10)<="111111110001";
t(11)<="111111101111";
t(12)<="111111101110";
t(13)<="111111101111";
t(14)<="111111110001";
t(15)<="111111110101";
t(16)<="111111111011";
t(17)<="000000000001";
t(18)<="000000001000";
t(19)<="000000001110";
t(20)<="000000010100";
t(21)<="000000010110";
t(22)<="000000010110";
t(23)<="000000010011";
t(24)<="000000001101";
t(25)<="000000000011";
t(26)<="111111110111";
t(27)<="111111101010";
t(28)<="111111011111";
t(29)<="111111010101";
t(30)<="111111010001";
t(31)<="111111010010";
t(32)<="111111011010";
t(33)<="111111101010";
t(34)<="000000000010";
t(35)<="000000100000";
t(36)<="000001000011";
t(37)<="000001101001";
t(38)<="000010001110";
t(39)<="000010110001";
t(40)<="000011001101";
t(41)<="000011100010";
t(42)<="000011101101";
t(43)<="000011101101";
t(44)<="000011100010";
t(45)<="000011001101";
t(46)<="000010110001";
t(47)<="000010001110";
t(48)<="000001101001";
t(49)<="000001000011";
t(50)<="000000100000";
t(51)<="000000000010";
t(52)<="111111101010";
t(53)<="111111011010";
t(54)<="111111010010";
t(55)<="111111010001";





	elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  

	-- Single clock to start the filter
	
		if (clk6M='1') then 
			if (clk250K = '1') then
				pipe <= signed(x)&pipe(0 to pipe'length-2);
				GoOn<='1';
				k<=0;
			else		
				k<=k+1;			
			end if;
	
	        	
	           	finished<='0';
			finished_sig<='0';
	         	i<=0;
			y <= a_s(2*width-2 downto width+3);
			y_s <= (others => '0');
			
		elsif(    (i= (N/inter - 1)) AND GoOn<='1'  ) then  
				y_s <= (( pipe(i)* t( inter*(i)) ) +y_s); 
				i <= i+1;
			
		elsif(    (i< (N/inter - 1)) AND GoOn<='1'  ) then  
				y_s <= (( pipe(i)* t( inter*(i) + k ) ) +y_s); 
				i <= i+1;
		else
			finished_sig<='1';
			finished <= '1';
	                a_s <=y_s;
		end if;
	end if;
   
end process;

end behaiv_arch;


