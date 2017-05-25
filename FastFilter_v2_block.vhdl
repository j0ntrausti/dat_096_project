
-- CHANNEL FILTER FOR INTERPOLATION OF ... N, this

-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs. 
-- The filter is written GENERIC so it is defined as;
--							WIDTH = number of bits
--							N = number of tabs   
-- Takes in, GENERIC values WIDTH (nr. of bits), N number of tabs, x[n]. 
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: Jón Trausti
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity IPOL_bl_filt_2 is 
	GENERIC(WIDTH	:integer 	:=16;
		N :integer	:=56;
		inter:integer :=2);
	PORT(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
		   clk500k:IN STD_LOGIC;
           clk4M:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end IPOL_bl_filt_2;



architecture behaiv_arch of IPOL_bl_filt_2 is


-- Signals
signal i,k	:integer range 0 to N; --index for how many clkcykles the calculation have been running
signal finished_sig,GoOn    :STD_LOGIC :='0';

-- Array types
type a_array is array (0 to (N-1)) of signed(WIDTH-1 downto 0);
type p_array is array (0 to (N/inter -1)) of signed(WIDTH-1 downto 0);

-- Array Signals
signal t		:a_array;
signal pipe		:p_array;



-- Old signals

signal y_s,a_s	:signed(2*WIDTH-1 downto 0);--temporary output
signal x_sig: signed(WIDTH-1 downto 0);

begin



--x_sig(WIDTH-1 downto 4) <= x;
--x_sig(3 downto 0) <= (others => '0');

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
t(0)<="1111111111100111";
        t(1)<="1111111111011111";
        t(2)<="1111111111001011";
        t(3)<="1111111110110011";
        t(4)<="1111111110010111";
        t(5)<="1111111101110111";
        t(6)<="1111111101010111";
        t(7)<="1111111100111000";
        t(8)<="1111111100011101";
        t(9)<="1111111100001100";
        t(10)<="1111111100001000";
        t(11)<="1111111100010101";
        t(12)<="1111111100111001";
        t(13)<="1111111101110110";
        t(14)<="1111111111001111";
        t(15)<="0000000001000111";
        t(16)<="0000000011011101";
        t(17)<="0000000110010000";
        t(18)<="0000001001011110";
        t(19)<="0000001101000000";
        t(20)<="0000010000110010";
        t(21)<="0000010100101010";
        t(22)<="0000011000011111";
        t(23)<="0000011100001010";
        t(24)<="0000011111011111";
        t(25)<="0000100010010110";
        t(26)<="0000100100100111";
        t(27)<="0000100110001011";
        t(28)<="0000100110111111";
        t(29)<="0000100110111111";
        t(30)<="0000100110001011";
        t(31)<="0000100100100111";
        t(32)<="0000100010010110";
        t(33)<="0000011111011111";
        t(34)<="0000011100001010";
        t(35)<="0000011000011111";
        t(36)<="0000010100101010";
        t(37)<="0000010000110010";
        t(38)<="0000001101000000";
        t(39)<="0000001001011110";
        t(40)<="0000000110010000";
        t(41)<="0000000011011101";
        t(42)<="0000000001000111";
        t(43)<="1111111111001111";
        t(44)<="1111111101110110";
        t(45)<="1111111100111001";
        t(46)<="1111111100010101";
        t(47)<="1111111100001000";
        t(48)<="1111111100001100";
        t(49)<="1111111100011101";
        t(50)<="1111111100111000";
        t(51)<="1111111101010111";
        t(52)<="1111111101110111";
        t(53)<="1111111110010111";
        t(54)<="1111111110110011";
        t(55)<="1111111111001011";
        t(56)<="1111111111011111";
        t(57)<="1111111111100111";











	elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  

	-- Single clock to start the filter
	
		if (clk4M='1') then 
			if (clk500K = '1') then
				pipe <= signed(x)&pipe(0 to pipe'length-2);
				GoOn<='1';
				k<=0;
			else		
				k<=k+1;			
			end if;
	
	        	
	           	finished<='0';
			finished_sig<='0';
	         	i<=0;
			
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
	        y <= y_s(2*WIDTH-2 downto WIDTH-1);
		end if;
	end if;
   
end process;

end behaiv_arch;