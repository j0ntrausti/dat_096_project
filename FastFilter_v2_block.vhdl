
-- This is a FIR filter interpolator, Has N coeff. and N-1 inputs.  
-- Takes in, GENERIC values WIDTH (nr. of bits), N number of tabs (counted from 1), inter interpolation factor
-- 	     x'array inputs from different channels.
-- Sends out finish signal and output of the filter, y'array  - same length as input.
-- this design only works for 16 bits, but can be modified easily for other bit numbers.

-- interpolation is handled by hopping over the taps in the multiplier by the interpolation factor
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity IPOL_bl_filt_2  is 
	GENERIC(WIDTH	:integer 	:=16; -- signal length
		N :integer	:=56; -- number of taps
		inter:integer :=2); -- interpolation factor
	PORT(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC; -- calculated frequency
	   clk500k:IN STD_LOGIC; -- input frequency
           clk4M:IN STD_LOGIC; -- output -frequency
           x:IN signed(WIDTH-1 DOWNTO 0); -- input value
           y:OUT signed(WIDTH-1 DOWNTO 0); -- output value
           finished:OUT STD_LOGIC); -- finished flag
end IPOL_bl_filt_2 ;



architecture behaiv_arch of IPOL_bl_filt_2  is


-- Signals
signal i,k	:integer range 0 to N; -- counters
signal finished_sig,GoOn    :STD_LOGIC :='0'; -- flags

-- Array types
type a_array is array (0 to (N-1)) of signed(WIDTH-1 downto 0); 
type p_array is array (0 to (N/inter -1)) of signed(WIDTH-1 downto 0);

-- Array Signals
signal t		:a_array; -- coefficients
signal pipe		:p_array; -- pipeline




signal y_s	:signed(2*WIDTH-1 downto 0); --temporary output

begin
	



process(clk,reset)
begin

	-- Asynchronous reset
	-- resets all the vital signals, and inputs the coefficient values
	if(reset='1') then
		 -- Pretty much same as start, just double sec. since start is input signal
		i<=0;	-- reset the counter 
		k<=0;	
		y_s <= (others => '0');
		finished <= '0';
		finished_sig <= '1';	
	    	for i in 0 to (pipe'length-1) loop
			pipe(i)<=(others=> '0'); 
        	end loop;

		
		
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

	-- outputs and inputs at the same clock frequency
	
		if (clk4M='1') then 
			-- reads into the pipeline at slower rate
			if (clk500k = '1') then
				pipe <= signed(x)&pipe(0 to pipe'length-2); -- the pipeline
				GoOn<='1'; -- activates the multiplies
				k<=0;
			else		
				k<=k+1;			
			end if;
	
	        	
	           	finished<='0';
			finished_sig<='0';
	         	i<=0;
			
			y_s <= (others => '0'); -- reset the tempory output
			
		elsif(    (i= (N/inter - 1)) AND GoOn<='1'  ) then  
				y_s <= (( pipe(i)* t( inter*(i)) ) +y_s); -- the last multiply
				i <= i+1;
			
		elsif(    (i< (N/inter - 1)) AND GoOn<='1'  ) then  
				y_s <= (( pipe(i)* t( inter*(i) + k ) ) +y_s); -- the rest of the multiply
				i <= i+1;
		else
			finished_sig<='1'; -- finished flag
			finished <= '1'; -- finished flag
	        y <= y_s(2*WIDTH-4 downto WIDTH-3); -- output
		end if;
	end if;
   
end process;

end behaiv_arch;




		
