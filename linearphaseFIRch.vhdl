
-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs. 
-- The filter is written generic so it is defined as;
--							Width = number of bits
--							N = number of tabs   
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n]. 
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: Jón Trausti & Raja
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity linearphaseFIRch is 
	generic(Width	:integer 	:=16;
		N :integer	:=92);
	port(	reset:STD_LOGIC;
           start:STD_LOGIC;
           clk:STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(2*WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end linearphaseFIRch;



architecture behaiv_arch of linearphaseFIRch is
-- New signals
signal onGoing	:std_logic :='0'; --this shall trigger when start goes to '1' and go down when start goes to '0' to see if there is a new x or not
signal i	:integer range 0 to N; --index for how many clkcykles the calculation have been running

-- For our x's
-- (2*(N-1)-2) is the last X, yeah I've done the calc right, unless I'm wrong (haven't tested) 
type xLArray is array (0 to (2*(N-1)-2)) of signed(width-1 downto 0);
signal xL	:xLArray;

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
		onGoing<='0'; -- Pretty much same as start, just double sec. since start is input signal
		i<=0;	-- reset the counter 
	
		for i in 0 to (2*(N-1)-2) loop
			if (i<(2*(N-1)-1)) then
				xL(i)<=(others=> '0'); 
			end if;
		end loop;
		    t(0)<="0000000000010001";
    t(1)<="0000000000011000";
    t(2)<="0000000000100110";
    t(3)<="0000000000110110";
    t(4)<="0000000001000110";
    t(5)<="0000000001010011";
    t(6)<="0000000001011010";
    t(7)<="0000000001011010";
    t(8)<="0000000001001110";
    t(9)<="0000000000110101";
    t(10)<="0000000000010000";
    t(11)<="1111111111011111";
    t(12)<="1111111110101000";
    t(13)<="1111111101101110";
    t(14)<="1111111100111001";
    t(15)<="1111111100010001";
    t(16)<="1111111011111101";
    t(17)<="1111111100000011";
    t(18)<="1111111100100110";
    t(19)<="1111111101100101";
    t(20)<="1111111110111101";
    t(21)<="0000000000100101";
    t(22)<="0000000010010010";
    t(23)<="0000000011110011";
    t(24)<="0000000100111011";
    t(25)<="0000000101011011";
    t(26)<="0000000101001001";
    t(27)<="0000000011111111";
    t(28)<="0000000010000000";
    t(29)<="1111111111010100";
    t(30)<="1111111100001101";
    t(31)<="1111111001000011";
    t(32)<="1111110110010011";
    t(33)<="1111110100011010";
    t(34)<="1111110011110101";
    t(35)<="1111110100111010";
    t(36)<="1111110111111010";
    t(37)<="1111111100110111";
    t(38)<="0000000011101001";
    t(39)<="0000001011111010";
    t(40)<="0000010101001010";
    t(41)<="0000011110101111";
    t(42)<="0000100111111100";
    t(43)<="0000110000000011";
    t(44)<="0000110110010111";
    t(45)<="0000111010011001";
    t(46)<="0000111011110001";
    t(47)<="0000111010011001";
    t(48)<="0000110110010111";
    t(49)<="0000110000000011";
    t(50)<="0000100111111100";
    t(51)<="0000011110101111";
    t(52)<="0000010101001010";
    t(53)<="0000001011111010";
    t(54)<="0000000011101001";
    t(55)<="1111111100110111";
    t(56)<="1111110111111010";
    t(57)<="1111110100111010";
    t(58)<="1111110011110101";
    t(59)<="1111110100011010";
    t(60)<="1111110110010011";
    t(61)<="1111111001000011";
    t(62)<="1111111100001101";
    t(63)<="1111111111010100";
    t(64)<="0000000010000000";
    t(65)<="0000000011111111";
    t(66)<="0000000101001001";
    t(67)<="0000000101011011";
    t(68)<="0000000100111011";
    t(69)<="0000000011110011";
    t(70)<="0000000010010010";
    t(71)<="0000000000100101";
    t(72)<="1111111110111101";
    t(73)<="1111111101100101";
    t(74)<="1111111100100110";
    t(75)<="1111111100000011";
    t(76)<="1111111011111101";
    t(77)<="1111111100010001";
    t(78)<="1111111100111001";
    t(79)<="1111111101101110";
    t(80)<="1111111110101000";
    t(81)<="1111111111011111";
    t(82)<="0000000000010000";
    t(83)<="0000000000110101";
    t(84)<="0000000001001110";
    t(85)<="0000000001011010";
    t(86)<="0000000001011010";
    t(87)<="0000000001010011";
    t(88)<="0000000001000110";
    t(89)<="0000000000110110";
    t(90)<="0000000000100110";
    t(91)<="0000000000011000";
    t(92)<="0000000000010001";
    
	


	elsif (rising_edge(clk)) then		
		if (start='1' AND onGoing='0') then
			finished<='0';
			onGoing<='1';
			y_s<=(xL((2*(N-1)-2)) + x)*t(0);
			i<=1;	
		elsif (ongoing='1') then
			-- First Case
			
			if (i=N-1) then--last itteration	
				i<=0;
				onGoing<='0';
				finished<='1';
				y<=(((xL(i-1))*(t(i))+(y_s)) sll 1); -- maybe I need to shift it??
				for j in 0 to (2*(N-1)-2) loop--Swap the x-array
					if (j<(2*(N-1)-2)) then
						xL((2*(N-1)-2)-j)<=xL((2*(N-1)-3)-j);
					elsif (j=(2*(N-1)-2)) then
						xL(0)<=x;
					end if;
				end loop;
			else
				
				y_s<=((xL(i-1) + xL(2*(N-1)-3-i))*t(i)+y_s);		
				i<=i+1;
				
			end if;	
		end if;
	end if;
end process;

end behaiv_arch;
