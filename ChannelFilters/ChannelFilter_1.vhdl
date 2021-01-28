

-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs.
-- The filter is written generic so it is defined as;
--                            Width = number of bits
--                            N = number of tabs   
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n].
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: Jo³n Trausti
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ChannelFilter_1 is
    generic(Width    :integer     :=12;
        N :integer    :=20);
    port(    reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           clk6M:IN STD_LOGIC;
           x:IN signed(width-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end ChannelFilter_1;



architecture behaiv_arch of ChannelFilter_1 is


   COMPONENT BitMulti IS
      GENERIC(WIDTH:INTEGER:=12);
      PORT(reset:IN STD_LOGIC;
             clk:IN STD_LOGIC;
	     start:IN STD_LOGIC;
	     A:IN signed(WIDTH-1 downto 0); -- X-input
	     B:IN signed(WIDTH-1 downto 0); -- coff modified vector
	     y:OUT signed(2*WIDTH-1 downto 0); -- multiplied output
             finished:OUT STD_LOGIC);
   END COMPONENT BitMulti;


-- New signals
signal swapping    :std_logic :='0'; --this shall trigger when start goes to '1' and go down when start goes to '0' to see if there is a new x or not
signal i    :integer range 0 to N+3; --index for how many clkcykles the calculation have been running
signal finished_sig,GoOn    :std_logic :='1';
signal MultiInput,MultiCoff :signed(width-1 downto 0);
signal MultiFinished    :std_logic :='1'; 
signal MultiOutput :signed(2*width-1 downto 0);
signal MultiStart:std_logic;



type xLArray is array (0 to N-1) of signed(width-1 downto 0);
signal xL    :xLArray;
type MiddleArray is array (0 to N-1) of signed(width-1 downto 0); --- need to fix size
signal MiddleAdder    :MiddleArray;
type queue2multiArray is array (0 to N-1) of signed(width-1 downto 0); --- need to fix size
signal queue2multi    :queue2multiArray;
type tLArray is array (0 to N-1) of signed(width-1 downto 0);
signal t    :tLArray;




-- Old signals

signal y_s    :signed(2*width-1 downto 0);--temporary output

begin


multiplier:
COMPONENT BitMulti
         GENERIC MAP(WIDTH=>WIDTH)
         PORT MAP(reset=>reset,
 	            clk=>clk,
		     start=>MultiStart,
		     A=>MultiInput, -- X-input
		     B=>MultiCoff, -- coff modified vector
		     y=>MultiOutput, -- multiplied output
	             finished=>MultiFinished );




process(clk,reset)
begin

    -- This will set all the x's to zero, resetting everything.
    -- so when the program start all values have zeros except for the coefficients
    if(reset='1') then
         -- Pretty much same as start, just double sec. since start is input signal
        i<=0;    -- reset the counter
        y_s <= (others => '0');
        y <= (others => '0');
        finished <= '0';
        finished_sig <= '1';
   	MultiInput<=(others => '0');
	MultiCoff<=(others => '0');
	MultiStart<='0';
        for i in 0 to (N-1) loop
                xL(i)<=(others=> '0');  
        end loop;
        
        for i in 0 to (N-1) loop
               MiddleAdder(i)<=(others=> '0');
               queue2multi(i)<=(others=> '0');
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
        if(finished_sig = '0' AND GoOn='1') then
            
            if(i=N+3) then
                finished <= '1';
                finished_sig <= '1';
                y <= y_s(2*width-2 downto width-1);
                
            else
		if(i<N) then
			MultiInput<=queue2multi(i);
			MultiCoff<=t(i);
			i <= i+1;
			y_s <= y_s + MultiOutput;
		elsif(i<N+3) then
			y_s <= y_s + MultiOutput;
			i <= i+1;
		end if;
			


              
            end if;
        elsif(clk250k = '1') then   
	    	GoOn<='1';  
        	y_s <= (others => '0');
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
	    MultiStart<='1'; 
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


