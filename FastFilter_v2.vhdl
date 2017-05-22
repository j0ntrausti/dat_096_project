
-- CHANNEL FILTER FOR INTERPOLATION OF ... N, this

-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs. 
-- The filter is written GENERIC so it is defined as;
--							WIDTH = number of bits
--							N = number of tabs   
-- Takes in, GENERIC values WIDTH (nr. of bits), N number of tabs, x[n]. 
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: J�n Trausti
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity IPOL_ch_filt is 
	GENERIC(WIDTH	:integer 	:=16;
		N :integer	:=56;
		inter:integer :=10);
	PORT(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
			clk31k:IN STD_LOGIC;
           clk312k:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end IPOL_ch_filt;



architecture behaiv_arch of IPOL_ch_filt is


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
t(0)<="0000000000010001";
        t(1)<="0000000000001101";
        t(2)<="0000000000010000";
        t(3)<="0000000000010010";
        t(4)<="0000000000010010";
        t(5)<="0000000000001111";
        t(6)<="0000000000001000";
        t(7)<="1111111111111111";
        t(8)<="1111111111101101";
        t(9)<="1111111111010111";
        t(10)<="1111111110111110";
        t(11)<="1111111110100001";
        t(12)<="1111111110000011";
        t(13)<="1111111101100101";
        t(14)<="1111111101001010";
        t(15)<="1111111100110101";
        t(16)<="1111111100101001";
        t(17)<="1111111100100111";
        t(18)<="1111111100110010";
        t(19)<="1111111101001011";
        t(20)<="1111111101110001";
        t(21)<="1111111110100101";
        t(22)<="1111111111100010";
        t(23)<="0000000000100111";
        t(24)<="0000000001101101";
        t(25)<="0000000010110000";
        t(26)<="0000000011101001";
        t(27)<="0000000100010010";
        t(28)<="0000000100100111";
        t(29)<="0000000100100010";
        t(30)<="0000000100000010";
        t(31)<="0000000011000101";
        t(32)<="0000000001101111";
        t(33)<="0000000000000010";
        t(34)<="1111111110000111";
        t(35)<="1111111100000101";
        t(36)<="1111111010001000";
        t(37)<="1111111000011011";
        t(38)<="1111110111001100";
        t(39)<="1111110110100100";
        t(40)<="1111110110110000";
        t(41)<="1111110111110101";
        t(42)<="1111111001111001";
        t(43)<="1111111100111100";
        t(44)<="0000000000111100";
        t(45)<="0000000101110001";
        t(46)<="0000001011010001";
        t(47)<="0000010001001100";
        t(48)<="0000010111010010";
        t(49)<="0000011101010000";
        t(50)<="0000100010110011";
        t(51)<="0000100111101001";
        t(52)<="0000101011100001";
        t(53)<="0000101110001110";
        t(54)<="0000101111100111";
        t(55)<="0000101111100111";
        t(56)<="0000101110001110";
        t(57)<="0000101011100001";
        t(58)<="0000100111101001";
        t(59)<="0000100010110011";
        t(60)<="0000011101010000";
        t(61)<="0000010111010010";
        t(62)<="0000010001001100";
        t(63)<="0000001011010001";
        t(64)<="0000000101110001";
        t(65)<="0000000000111100";
        t(66)<="1111111100111100";
        t(67)<="1111111001111001";
        t(68)<="1111110111110101";
        t(69)<="1111110110110000";
        t(70)<="1111110110100100";
        t(71)<="1111110111001100";
        t(72)<="1111111000011011";
        t(73)<="1111111010001000";
        t(74)<="1111111100000101";
        t(75)<="1111111110000111";
        t(76)<="0000000000000010";
        t(77)<="0000000001101111";
        t(78)<="0000000011000101";
        t(79)<="0000000100000010";
        t(80)<="0000000100100010";
        t(81)<="0000000100100111";
        t(82)<="0000000100010010";
        t(83)<="0000000011101001";
        t(84)<="0000000010110000";
        t(85)<="0000000001101101";
        t(86)<="0000000000100111";
        t(87)<="1111111111100010";
        t(88)<="1111111110100101";
        t(89)<="1111111101110001";
        t(90)<="1111111101001011";
        t(91)<="1111111100110010";
        t(92)<="1111111100100111";
        t(93)<="1111111100101001";
        t(94)<="1111111100110101";
        t(95)<="1111111101001010";
        t(96)<="1111111101100101";
        t(97)<="1111111110000011";
        t(98)<="1111111110100001";
        t(99)<="1111111110111110";
        t(100)<="1111111111010111";
        t(101)<="1111111111101101";
        t(102)<="1111111111111111";
        t(103)<="0000000000001000";
        t(104)<="0000000000001111";
        t(105)<="0000000000010010";
        t(106)<="0000000000010010";
        t(107)<="0000000000010000";
        t(108)<="0000000000001101";
        t(109)<="0000000000010001";









	elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  

	-- Single clock to start the filter
	
		if (clk312k='1') then 
			if (clk31K = '1') then
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


