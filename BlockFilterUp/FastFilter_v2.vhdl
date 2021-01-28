
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
		N :integer	:=56;
		inter:integer :=2);
	port(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
		   clk500k:IN STD_LOGIC;
           clk4M:IN STD_LOGIC;
           x:IN signed(WIDTH-5 DOWNTO 0);
           y:OUT signed(WIDTH-5 DOWNTO 0);
           finished:OUT STD_LOGIC);
end IPOL_bl_filt_2;



architecture behaiv_arch of IPOL_bl_filt_2 is


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

signal y_s,a_s	:signed(2*width-1 downto 0);--temporary output
signal x_sig: signed(width-1 downto 0);

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
t(0)<="1111111111100001";
        t(1)<="1111111111011010";
        t(2)<="1111111111000110";
        t(3)<="1111111110101101";
        t(4)<="1111111110010010";
        t(5)<="1111111101110101";
        t(6)<="1111111101011001";
        t(7)<="1111111101000010";
        t(8)<="1111111100110011";
        t(9)<="1111111100110001";
        t(10)<="1111111100111111";
        t(11)<="1111111101100010";
        t(12)<="1111111110011110";
        t(13)<="1111111111110110";
        t(14)<="0000000001101011";
        t(15)<="0000000011111110";
        t(16)<="0000000110101111";
        t(17)<="0000001001111001";
        t(18)<="0000001101011000";
        t(19)<="0000010001000101";
        t(20)<="0000010100111010";
        t(21)<="0000011000101101";
        t(22)<="0000011100010101";
        t(23)<="0000011111101000";
        t(24)<="0000100010011101";
        t(25)<="0000100100101100";
        t(26)<="0000100110010000";
        t(27)<="0000100111000011";
        t(28)<="0000100111000011";
        t(29)<="0000100110010000";
        t(30)<="0000100100101100";
        t(31)<="0000100010011101";
        t(32)<="0000011111101000";
        t(33)<="0000011100010101";
        t(34)<="0000011000101101";
        t(35)<="0000010100111010";
        t(36)<="0000010001000101";
        t(37)<="0000001101011000";
        t(38)<="0000001001111001";
        t(39)<="0000000110101111";
        t(40)<="0000000011111110";
        t(41)<="0000000001101011";
        t(42)<="1111111111110110";
        t(43)<="1111111110011110";
        t(44)<="1111111101100010";
        t(45)<="1111111100111111";
        t(46)<="1111111100110001";
        t(47)<="1111111100110011";
        t(48)<="1111111101000010";
        t(49)<="1111111101011001";
        t(50)<="1111111101110101";
        t(51)<="1111111110010010";
        t(52)<="1111111110101101";
        t(53)<="1111111111000110";
        t(54)<="1111111111011010";
        t(55)<="1111111111100001";







	elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  

	-- Single clock to start the filter
	
		if (clk4M='1') then 
			if (clk500K = '1') then
				pipe <= signed(x_sig)&pipe(0 to pipe'length-2);
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