
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
	generic(Width	:integer 	:=8;
		N :integer	:=4);
	port(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           clk6M:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end FastFilter;



architecture behaiv_arch of FastFilter is


-- New signals
signal swapping	:std_logic :='0'; --this shall trigger when start goes to '1' and go down when start goes to '0' to see if there is a new x or not
signal i	:integer range 0 to N; --index for how many clkcykles the calculation have been running
signal finished_sig	:std_logic :='1';
-- For our x's
-- (2*(N-1)-2) is the last X, yeah I've done the calc right, unless I'm wrong (haven't tested) 
type xLArray is array (0 to (2*(N-1)-2)) of signed(width-1 downto 0);
signal xL	:xLArray;

type MiddleArray is array (0 to (N-1)) of signed(width-1 downto 0); --- need to fix size
signal MiddleAdder	:MiddleArray;

type queue2multiArray is array (0 to (N-1)) of signed(width-1 downto 0); --- need to fix size
signal queue2multi	:queue2multiArray;

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
		 -- Pretty much same as start, just double sec. since start is input signal
		i<=0;	-- reset the counter 
		y_s <= (others => '0');
		finished <= '0';
		finished_sig <= '1';
		for i in 0 to (2*(N-1)-2) loop
			if (i<(2*(N-1)-1)) then
				xL(i)<=(others=> '0'); 
			end if;
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
		t(92)<="000001100111";
		t(93)<="000001101000";
		t(94)<="000001101000";
		t(95)<="000001100111";
		t(96)<="000001100101";
		t(97)<="000001100011";
		t(98)<="000001011111";
		t(99)<="000001011011";
		t(100)<="000001010110";
		t(101)<="000001010000";
		t(102)<="000001001010";
		t(103)<="000001000011";
		t(104)<="000000111100";
		t(105)<="000000110101";
		t(106)<="000000101110";
		t(107)<="000000100110";
		t(108)<="000000011111";
		t(109)<="000000011000";
		t(110)<="000000010001";
		t(111)<="000000001011";
		t(112)<="000000000101";
		t(113)<="000000000000";
		t(114)<="111111111011";
		t(115)<="111111110111";
		t(116)<="111111110011";
		t(117)<="111111110000";
		t(118)<="111111101110";
		t(119)<="111111101101";
		t(120)<="111111101100";
		t(121)<="111111101011";
		t(122)<="111111101100";
		t(123)<="111111101100";
		t(124)<="111111101101";
		t(125)<="111111101111";
		t(126)<="111111110001";
		t(127)<="111111110011";
		t(128)<="111111110101";
		t(129)<="111111110111";
		t(130)<="111111111001";
		t(131)<="111111111100";
		t(132)<="111111111110";
		t(133)<="000000000000";
		t(134)<="000000000010";
		t(135)<="000000000100";
		t(136)<="000000000101";
		t(137)<="000000000111";
		t(138)<="000000001000";
		t(139)<="000000001000";
		t(140)<="000000001001";
		t(141)<="000000001001";
		t(142)<="000000001001";
		t(143)<="000000001000";
		t(144)<="000000001000";
		t(145)<="000000000111";
		t(146)<="000000000110";
		t(147)<="000000000101";
		t(148)<="000000000100";
		t(149)<="000000000011";
		t(150)<="000000000010";
		t(151)<="000000000001";
		t(152)<="000000000000";
		t(153)<="111111111111";
		t(154)<="111111111110";
		t(155)<="111111111101";
		t(156)<="111111111100";
		t(157)<="111111111100";
		t(158)<="111111111011";
		t(159)<="111111111011";
		t(160)<="111111111010";
		t(161)<="111111111010";
		t(162)<="111111111010";
		t(163)<="111111111010";
		t(164)<="111111111010";
		t(165)<="111111111010";
		t(166)<="111111111010";
		t(167)<="111111111011";
		t(168)<="111111111011";
		t(169)<="111111111011";
		t(170)<="111111111100";
		t(171)<="111111111100";
		t(172)<="111111111101";
		t(173)<="111111111101";
		t(174)<="111111111101";
		t(175)<="111111111110";
		t(176)<="111111111110";
		t(177)<="111111111110";
		t(178)<="111111111111";
		t(179)<="111111111111";
		t(180)<="111111111111";
		t(181)<="111111111111";
		t(182)<="111111111111";
		t(183)<="111111111111";
		t(184)<="000000000000";
		t(185)<="000000000000";
		t(186)<="000000000000";
		t(187)<="000000000000";



	elsif (rising_edge(clk)) then
--------------------------------------------------------------------	
-----------------------------SENDING OUT ---------------------------	
--------------------------------------------------------------------       
		if(finished_sig = '0') then
			
			if(i=N) then
				finished <= '1';
				finished_sig <= '1';
				y <= y_s(2*width-2 downto width-1);
			else
				y_s <= ((queue2multi(i)*t(i))+y_s);
				i <= i+1;
			end if;
		elsif(clk250k = '1') then			
			finished_sig <= '0';
			finished<='0';
			i<=0;
			for j in 0 to N-1 loop
				queue2multi(j)<= MiddleAdder(j);
			end loop;
		end if;
--------------------------------------------------------------------	
-----------------------------READING IN ----------------------------	
--------------------------------------------------------------------  
		if (clk6M='1' AND swapping='0') then   	
			swapping<='1';
			y_s <= (others => '0');
			-- the first adding
			MiddleAdder(0)<=(xL((2*(N-1)-2)) + x); 
			-- the last adding
			MiddleAdder(N-1)<= (xL(N-1));            			
			-- all the other adding 
			for j in 1 to N-2 loop
				MiddleAdder(j)<= (xL(j-1) + xL(2*(N-1)-3-j));
			end loop;
		elsif (swapping='1') then
			-- this is the "delay" process, that moves x's to new location.
			-- its ok the swap them this soon, since after we load the middle adder we don't care about them.
			for j in 0 to (2*(N-1)-2) loop
				if (j<(2*(N-1)-2)) then
					xL((2*(N-1)-2)-j)<=xL((2*(N-1)-3)-j);
				elsif (j=(2*(N-1)-2)) then
					xL(0)<=x;
				end if;
			end loop;
			swapping<='0';	
		end if;
	end if;
end process;

end behaiv_arch;
