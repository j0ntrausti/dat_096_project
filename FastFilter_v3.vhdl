-- This is a FIR filter interpolator, Has N coeff. and N-1 inputs.  
-- Takes in, GENERIC values WIDTH (nr. of bits), N number of tabs (counted from 1), inter interpolation factor
-- 	     x'array inputs from different channels.
-- Sends out finish signal and output of the filter, y'array  - same length as input.
-- this design only works for 16 bits, but can be modified easily for other bit numbers.

-- interpolation is handled by hopping over the taps in the multiplier by the interpolation factor
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity IPOL_bl_filt_1  is 
	GENERIC(WIDTH	:integer 	:=16; -- signal length
		N :integer	:=56; -- number of taps
		inter:integer :=8); -- interpolation factor
	PORT(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC; -- calculated frequency
	   clk312k:IN STD_LOGIC; -- input frequency
           clk625k:IN STD_LOGIC; -- output -frequency
           x:IN signed(WIDTH-1 DOWNTO 0); -- input value
           y:OUT signed(WIDTH-1 DOWNTO 0); -- output value
           finished:OUT STD_LOGIC); -- finished flag
end IPOL_bl_filt_1 ;



architecture behaiv_arch of IPOL_bl_filt_1  is


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

		
		
		-- here the coeff. comes in for ex. 
t(0)<="0000000000111011";
        t(1)<="0000000010100010";
        t(2)<="0000000011111111";
        t(3)<="0000000011110100";
        t(4)<="0000000001011011";
        t(5)<="1111111110001000";
        t(6)<="1111111100010000";
        t(7)<="1111111101000001";
        t(8)<="1111111111010000";
        t(9)<="0000000000100011";
        t(10)<="1111111111110000";
        t(11)<="1111111110000111";
        t(12)<="1111111101101101";
        t(13)<="1111111110111101";
        t(14)<="0000000000010010";
        t(15)<="0000000000000101";
        t(16)<="1111111110110001";
        t(17)<="1111111110001001";
        t(18)<="1111111111000011";
        t(19)<="0000000000010101";
        t(20)<="0000000000010100";
        t(21)<="1111111111000110";
        t(22)<="1111111110010110";
        t(23)<="1111111111001001";
        t(24)<="0000000000011101";
        t(25)<="0000000000100011";
        t(26)<="1111111111010011";
        t(27)<="1111111110011011";
        t(28)<="1111111111001011";
        t(29)<="0000000000100111";
        t(30)<="0000000000110010";
        t(31)<="1111111111011100";
        t(32)<="1111111110011010";
        t(33)<="1111111111001010";
        t(34)<="0000000000110000";
        t(35)<="0000000001000010";
        t(36)<="1111111111100101";
        t(37)<="1111111110010101";
        t(38)<="1111111111000100";
        t(39)<="0000000000111000";
        t(40)<="0000000001010100";
        t(41)<="1111111111101101";
        t(42)<="1111111110001100";
        t(43)<="1111111110111011";
        t(44)<="0000000001000000";
        t(45)<="0000000001100111";
        t(46)<="1111111111110101";
        t(47)<="1111111110000001";
        t(48)<="1111111110101110";
        t(49)<="0000000001000110";
        t(50)<="0000000001111100";
        t(51)<="1111111111111111";
        t(52)<="1111111101110100";
        t(53)<="1111111110011101";
        t(54)<="0000000001001100";
        t(55)<="0000000010010100";
        t(56)<="0000000000001010";
        t(57)<="1111111101100100";
        t(58)<="1111111110001000";
        t(59)<="0000000001010001";
        t(60)<="0000000010110000";
        t(61)<="0000000000011000";
        t(62)<="1111111101010000";
        t(63)<="1111111101101110";
        t(64)<="0000000001010110";
        t(65)<="0000000011010001";
        t(66)<="0000000000101010";
        t(67)<="1111111100111001";
        t(68)<="1111111101001101";
        t(69)<="0000000001011010";
        t(70)<="0000000011111001";
        t(71)<="0000000001000001";
        t(72)<="1111111100011101";
        t(73)<="1111111100100010";
        t(74)<="0000000001011110";
        t(75)<="0000000100101011";
        t(76)<="0000000001011110";
        t(77)<="1111111011111001";
        t(78)<="1111111011101001";
        t(79)<="0000000001100001";
        t(80)<="0000000101101110";
        t(81)<="0000000010001000";
        t(82)<="1111111011001001";
        t(83)<="1111111010011001";
        t(84)<="0000000001100100";
        t(85)<="0000000111001101";
        t(86)<="0000000011000110";
        t(87)<="1111111010000011";
        t(88)<="1111111000100001";
        t(89)<="0000000001100110";
        t(90)<="0000001001100000";
        t(91)<="0000000100101001";
        t(92)<="1111111000010001";
        t(93)<="1111110101010100";
        t(94)<="0000000001101000";
        t(95)<="0000001101101101";
        t(96)<="0000000111101000";
        t(97)<="1111110100101101";
        t(98)<="1111101110011101";
        t(99)<="0000000001101001";
        t(100)<="0000011000001100";
        t(101)<="0000001111111111";
        t(102)<="1111101001011011";
        t(103)<="1111010100010011";
        t(104)<="0000000001101001";
        t(105)<="0001100111110011";
        t(106)<="0010111110001110";
        t(107)<="0010111110001110";
        t(108)<="0001100111110011";
        t(109)<="0000000001101001";
        t(110)<="1111010100010011";
        t(111)<="1111101001011011";
        t(112)<="0000001111111111";
        t(113)<="0000011000001100";
        t(114)<="0000000001101001";
        t(115)<="1111101110011101";
        t(116)<="1111110100101101";
        t(117)<="0000000111101000";
        t(118)<="0000001101101101";
        t(119)<="0000000001101000";
        t(120)<="1111110101010100";
        t(121)<="1111111000010001";
        t(122)<="0000000100101001";
        t(123)<="0000001001100000";
        t(124)<="0000000001100110";
        t(125)<="1111111000100001";
        t(126)<="1111111010000011";
        t(127)<="0000000011000110";
        t(128)<="0000000111001101";
        t(129)<="0000000001100100";
        t(130)<="1111111010011001";
        t(131)<="1111111011001001";
        t(132)<="0000000010001000";
        t(133)<="0000000101101110";
        t(134)<="0000000001100001";
        t(135)<="1111111011101001";
        t(136)<="1111111011111001";
        t(137)<="0000000001011110";
        t(138)<="0000000100101011";
        t(139)<="0000000001011110";
        t(140)<="1111111100100010";
        t(141)<="1111111100011101";
        t(142)<="0000000001000001";
        t(143)<="0000000011111001";
        t(144)<="0000000001011010";
        t(145)<="1111111101001101";
        t(146)<="1111111100111001";
        t(147)<="0000000000101010";
        t(148)<="0000000011010001";
        t(149)<="0000000001010110";
        t(150)<="1111111101101110";
        t(151)<="1111111101010000";
        t(152)<="0000000000011000";
        t(153)<="0000000010110000";
        t(154)<="0000000001010001";
        t(155)<="1111111110001000";
        t(156)<="1111111101100100";
        t(157)<="0000000000001010";
        t(158)<="0000000010010100";
        t(159)<="0000000001001100";
        t(160)<="1111111110011101";
        t(161)<="1111111101110100";
        t(162)<="1111111111111111";
        t(163)<="0000000001111100";
        t(164)<="0000000001000110";
        t(165)<="1111111110101110";
        t(166)<="1111111110000001";
        t(167)<="1111111111110101";
        t(168)<="0000000001100111";
        t(169)<="0000000001000000";
        t(170)<="1111111110111011";
        t(171)<="1111111110001100";
        t(172)<="1111111111101101";
        t(173)<="0000000001010100";
        t(174)<="0000000000111000";
        t(175)<="1111111111000100";
        t(176)<="1111111110010101";
        t(177)<="1111111111100101";
        t(178)<="0000000001000010";
        t(179)<="0000000000110000";
        t(180)<="1111111111001010";
        t(181)<="1111111110011010";
        t(182)<="1111111111011100";
        t(183)<="0000000000110010";
        t(184)<="0000000000100111";
        t(185)<="1111111111001011";
        t(186)<="1111111110011011";
        t(187)<="1111111111010011";
        t(188)<="0000000000100011";
        t(189)<="0000000000011101";
        t(190)<="1111111111001001";
        t(191)<="1111111110010110";
        t(192)<="1111111111000110";
        t(193)<="0000000000010100";
        t(194)<="0000000000010101";
        t(195)<="1111111111000011";
        t(196)<="1111111110001001";
        t(197)<="1111111110110001";
        t(198)<="0000000000000101";
        t(199)<="0000000000010010";
        t(200)<="1111111110111101";
        t(201)<="1111111101101101";
        t(202)<="1111111110000111";
        t(203)<="1111111111110000";
        t(204)<="0000000000100011";
        t(205)<="1111111111010000";
        t(206)<="1111111101000001";
        t(207)<="1111111100010000";
        t(208)<="1111111110001000";
        t(209)<="0000000001011011";
        t(210)<="0000000011110100";
        t(211)<="0000000011111111";
        t(212)<="0000000010100010";
        t(213)<="0000000000111011";










	elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  

	-- outputs and inputs at the same clock frequency
	
		if (clk625K='1') then 
			-- reads into the pipeline at slower rate
			if (clk312K = '1') then
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




		
		
		


