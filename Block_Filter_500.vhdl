


-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs.
-- The filter is written GENERIC so it is defined as;
--                            WIDTH = number of bits
--                            N = number of tabs   
--			      M = Channel filter type, (to maximise the available space for multiplication)
-- Takes in, GENERIC values WIDTH (nr. of bits), N number of tabs, x[n].
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: Jo³n Trausti
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity Block_Filter_500 is
    GENERIC(WIDTH    :integer     :=12;
        N :integer    :=188);
    PORT(    reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk625k:IN STD_LOGIC;
           clk5M:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end Block_Filter_500;



architecture behaiv_arch of Block_Filter_500 is


-- New signals
signal i    :integer range 0 to N+3; --index for how many clkcykles the calculation have been running
signal finished_sig,GoOn,Load_On    :STD_LOGIC :='0';
signal y_s    :signed(2*WIDTH-1 downto 0);--temporary output
signal x_sig :signed(WIDTH-1 downto 0);

type a_pipe is array (0 to N-1) of signed(WIDTH-1 downto 0);
type a_queue2multi is array (0 to N-1) of signed(WIDTH-1 downto 0);
type a_tL is array (0 to N-1) of signed(WIDTH-1 downto 0);

signal pipe    		: a_pipe;
signal queue2multi	:a_queue2multi;
signal t		:a_tL;




-- Old signals



begin


--x_sig(WIDTH-1 downto 4) <= x;
--x_sig(3 downto 0) <= (others => '0');
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
        

        -- here the coeff. comes in for ex.t(0)<="1111111111100001";
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
-----------------------------SENDING OUT ---------------------------    
--------------------------------------------------------------------       
        if(clk625k = '1') then   
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
               		y <= y_s(2*WIDTH-2 downto WIDTH-1);
		end if;
		
        end if;
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  

	if (clk5M='1' ) then 
		pipe <= signed(x)&pipe(0 to pipe'length-2);
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
