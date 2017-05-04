
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

entity UpBlockFilter is 
	generic(Width	:integer 	:=12;
		N :integer	:=92);
	port(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           clk6M:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end UpBlockFilter;



architecture behaiv_arch of UpBlockFilter is


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
			loc(i) <= 0;
        	end loop;
		
		-- here the coeff. comes in for ex. 
		t(0)<="000000000000";
		t(1)<="000000000000";
		t(2)<="000000000000";
		t(3)<="000000000000";
		t(4)<="111111111111";
		t(5)<="111111111111";
		t(6)<="111111111111";
		t(7)<="111111111111";
		t(8)<="111111111111";
		t(9)<="111111111111";
		t(10)<="111111111110";
		t(11)<="111111111110";
		t(12)<="111111111110";
		t(13)<="111111111101";
		t(14)<="111111111101";
		t(15)<="111111111101";
		t(16)<="111111111100";
		t(17)<="111111111100";
		t(18)<="111111111011";
		t(19)<="111111111011";
		t(20)<="111111111011";
		t(21)<="111111111010";
		t(22)<="111111111010";
		t(23)<="111111111010";
		t(24)<="111111111010";
		t(25)<="111111111010";
		t(26)<="111111111010";
		t(27)<="111111111010";
		t(28)<="111111111011";
		t(29)<="111111111011";
		t(30)<="111111111100";
		t(31)<="111111111100";
		t(32)<="111111111101";
		t(33)<="111111111110";
		t(34)<="111111111111";
		t(35)<="000000000000";
		t(36)<="000000000001";
		t(37)<="000000000010";
		t(38)<="000000000011";
		t(39)<="000000000100";
		t(40)<="000000000101";
		t(41)<="000000000110";
		t(42)<="000000000111";
		t(43)<="000000001000";
		t(44)<="000000001000";
		t(45)<="000000001001";
		t(46)<="000000001001";
		t(47)<="000000001001";
		t(48)<="000000001000";
		t(49)<="000000001000";
		t(50)<="000000000111";
		t(51)<="000000000101";
		t(52)<="000000000100";
		t(53)<="000000000010";
		t(54)<="000000000000";
		t(55)<="111111111110";
		t(56)<="111111111100";
		t(57)<="111111111001";
		t(58)<="111111110111";
		t(59)<="111111110101";
		t(60)<="111111110011";
		t(61)<="111111110001";
		t(62)<="111111101111";
		t(63)<="111111101101";
		t(64)<="111111101100";
		t(65)<="111111101100";
		t(66)<="111111101011";
		t(67)<="111111101100";
		t(68)<="111111101101";
		t(69)<="111111101110";
		t(70)<="111111110000";
		t(71)<="111111110011";
		t(72)<="111111110111";
		t(73)<="111111111011";
		t(74)<="000000000000";
		t(75)<="000000000101";
		t(76)<="000000001011";
		t(77)<="000000010001";
		t(78)<="000000011000";
		t(79)<="000000011111";
		t(80)<="000000100110";
		t(81)<="000000101110";
		t(82)<="000000110101";
		t(83)<="000000111100";
		t(84)<="000001000011";
		t(85)<="000001001010";
		t(86)<="000001010000";
		t(87)<="000001010110";
		t(88)<="000001011011";
		t(89)<="000001011111";
		t(90)<="000001100011";
		t(91)<="000001100101";

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
		if(i<N/6) then
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
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  

	if (clk6M='1' ) then 
		pipe <= signed(x)&pipe(0 to pipe'length-2);
	elsif(Load_On ='1') then
		for j in 0 to N-1 loop
             	   if(pipe(j)=0)  then
				queue2multi(k)<= pipe(j);
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
	end if;

    end if;
end process;

end behaiv_arch;

