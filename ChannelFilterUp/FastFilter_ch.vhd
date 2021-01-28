
-- CHANNEL FILTER FOR INTERPOLATION OF ... N, this

-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs. 
-- The filter is written generic so it is defined as;
--							Width = number of bits
--							N = number of tabs   
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n]. 
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: J�n Trausti
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IPOL_ch_filt is 
	generic(Width	:integer 	:=12;
		N :integer	:=86);
	port(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           --clk6M:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end IPOL_ch_filt;



architecture behaiv_arch of IPOL_ch_filt is


-- Signals
signal i,k,j,max	:integer range 0 to N; --index for how many clkcykles the calculation have been running
signal finished_sig,GoOn,Load_On    :std_logic :='0';

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
		t(0)<="000000000001";
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
        t(56)<="111111010101";
        t(57)<="111111011111";
        t(58)<="111111101010";
        t(59)<="111111110111";
        t(60)<="000000000011";
        t(61)<="000000001101";
        t(62)<="000000010011";
        t(63)<="000000010110";
        t(64)<="000000010110";
        t(65)<="000000010100";
        t(66)<="000000001110";
        t(67)<="000000001000";
        t(68)<="000000000001";
        t(69)<="111111111011";
        t(70)<="111111110101";
        t(71)<="111111110001";
        t(72)<="111111101111";
        t(73)<="111111101110";
        t(74)<="111111101111";
        t(75)<="111111110001";
        t(76)<="111111110011";
        t(77)<="111111110110";
        t(78)<="111111111001";
        t(79)<="111111111011";
        t(80)<="111111111101";
        t(81)<="111111111111";
        t(82)<="000000000000";
        t(83)<="000000000000";
        t(84)<="000000000000";
        t(85)<="000000000001";


	elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  
	

	-- Single clock to start the filter
	if (clk250k='1') then 
		pipe <= signed(x)&pipe(0 to pipe'length-2);
		Load_On<='1';
        	y_s <= (others => '0');
            	finished_sig <= '0';
           	finished<='0';
         	i<=0;
	elsif(Load_On ='1') then
		
		for j in 0 to N-1 loop
		   -- Isn't there a shorter format to check this?
             	   if(pipe(j)= ("000000000000" XNOR "111111111111") OR t(j)= ("000000000000" XNOR "111111111111"))  then
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
                	y <= y_s(2*width-2 downto width-1);
                end if;
	end if;
    end if;
end process;

end behaiv_arch;

