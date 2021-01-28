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

entity UpChannelFilter is 
	generic(Width	:integer 	:=12;
		N :integer	:=92);
	port(	reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           clk6M:IN STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end UpChannelFilter;



architecture behaiv_arch of UpChannelFilter is


-- New signals
signal swapping	:std_logic :='0'; --this shall trigger when start goes to '1' and go down when start goes to '0' to see if there is a new x or not
signal i,k,j,max	:integer range 0 to N; --index for how many clkcykles the calculation have been running
signal finished_sig	:std_logic :='1';
-- For our x's
-- (2*(N-1)-2) is the last X, yeah I've done the calc right, unless I'm wrong (haven't tested) 
type xLArray is array (0 to (N-1)) of signed(width-1 downto 0);
signal xL	:xLArray;

type MiddleArray is array (0 to (N-1)) of signed(width-1 downto 0); --- need to fix size
signal MiddleAdder	:MiddleArray;

type queue2multiArray is array (0 to (N-1)) of signed(width-1 downto 0); --- need to fix size
signal queue2multi	:queue2multiArray;

-- For the tabs
type tLArray is array (0 to N-1) of signed(width-1 downto 0);
signal t	:tLArray;



type locator is array (0 to 50) of integer;
signal loc	:locator;



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
			xL(i)<=(others=> '0'); 
		end loop;
		
	    for i in 0 to (N-1) loop
               MiddleAdder(i)<=(others=> '0'); 
               queue2multi(i)<=(others=> '0'); 
		loc(i) <= 0;
        end loop;
		
		-- here the coeff. comes in for ex. 
	t(0)<="000000000001";
t(1)<="000000000001";
t(2)<="000000000010";
t(3)<="000000000011";
t(4)<="000000000100";
t(5)<="000000000101";
t(6)<="000000000101";
t(7)<="000000000101";
t(8)<="000000000100";
t(9)<="000000000011";
t(10)<="000000000001";
t(11)<="111111111101";
t(12)<="111111111010";
t(13)<="111111110110";
t(14)<="111111110011";
t(15)<="111111110001";
t(16)<="111111101111";
t(17)<="111111110000";
t(18)<="111111110010";
t(19)<="111111110110";
t(20)<="111111111011";
t(21)<="000000000010";
t(22)<="000000001001";
t(23)<="000000001111";
t(24)<="000000010011";
t(25)<="000000010101";
t(26)<="000000010100";
t(27)<="000000001111";
t(28)<="000000001000";
t(29)<="111111111101";
t(30)<="111111110000";
t(31)<="111111100100";
t(32)<="111111011001";
t(33)<="111111010001";
t(34)<="111111001111";
t(35)<="111111010011";
t(36)<="111111011111";
t(37)<="111111110011";
t(38)<="000000001110";
t(39)<="000000101111";
t(40)<="000001010100";
t(41)<="000001111010";
t(42)<="000010011111";
t(43)<="000011000000";
t(44)<="000011011001";
t(45)<="000011101001";
t(46)<="000011101111";
t(47)<="000011101001";
t(48)<="000011011001";
t(49)<="000011000000";
t(50)<="000010011111";
t(51)<="000001111010";
t(52)<="000001010100";
t(53)<="000000101111";
t(54)<="000000001110";
t(55)<="111111110011";
t(56)<="111111011111";
t(57)<="111111010011";
t(58)<="111111001111";
t(59)<="111111010001";
t(60)<="111111011001";
t(61)<="111111100100";
t(62)<="111111110000";
t(63)<="111111111101";
t(64)<="000000001000";
t(65)<="000000001111";
t(66)<="000000010100";
t(67)<="000000010101";
t(68)<="000000010011";
t(69)<="000000001111";
t(70)<="000000001001";
t(71)<="000000000010";
t(72)<="111111111011";
t(73)<="111111110110";
t(74)<="111111110010";
t(75)<="111111110000";
t(76)<="111111101111";
t(77)<="111111110001";
t(78)<="111111110011";
t(79)<="111111110110";
t(80)<="111111111010";
t(81)<="111111111101";
t(82)<="000000000001";
t(83)<="000000000011";
t(84)<="000000000100";
t(85)<="000000000101";
t(86)<="000000000101";
t(87)<="000000000101";
t(88)<="000000000100";
t(89)<="000000000011";
t(90)<="000000000010";
t(91)<="000000000001";
t(92)<="000000000001";

	elsif (rising_edge(clk)) then
--------------------------------------------------------------------	
-----------------------------SENDING OUT ---------------------------	
--------------------------------------------------------------------       
		if(finished_sig = '0') then
			
			if(i=max) then
				finished <= '1';
				finished_sig <= '1';
				y <= y_s(2*width-2 downto width-1);
				y_s <= (others => '0');
				i<=0;	-- reset the counter 
				k<=0;	
				j<=0;	
				max <= 0;
			else
				y_s <= ((queue2multi(i)*  t(loc(i)))+y_s);
				i <= i+1;
			end if;
		elsif(clk250k = '1') then			
			finished_sig <= '0';
			finished<='0';	
			-- Critical path, need to simplify somehow
			for j in 0 to N-1 loop
				if(MiddleAdder(j) = not("000000000000")) then
					queue2multi(k)<= MiddleAdder(j);
					if(j = N-1) then
						max <= k;
						loc(k) <= j;
					else
						k <= k+1;
						loc(k) <= j;
					end if;
				end if;
			end loop;
		end if;
			
			
--------------------------------------------------------------------	
-----------------------------READING IN ----------------------------	
--------------------------------------------------------------------  
		if (clk6M='1' AND swapping='0') then   	
		            swapping<='1';
            --y_s <= (others => '0');            
            -- Load into an Array the swapping. 
          	 	for j in 0 to N-1 loop
             			MiddleAdder(j)<= (xL(j));
			end loop;	
						
		elsif (swapping='1') then
			-- this is the "delay" process, that moves x's to new location.
			-- its ok the swap them this soon, since after we load the middle adder we don't care about them.
			for j in 0 to (N-1) loop
                		if (j<(N-1)) then
                   			xL((N-1)-j)<=xL((N-2)-j);
              			elsif (j=(N-1)) then
                   		 	xL(0) <= x;
				end if;
			end loop;
			swapping<='0';	
		end if;
	end if;
end process;

end behaiv_arch;
