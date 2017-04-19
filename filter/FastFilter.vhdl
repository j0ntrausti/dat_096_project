

-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs.
-- The filter is written generic so it is defined as;
--                            Width = number of bits
--                            N = number of tabs   
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n].
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: Jo�n Trausti
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FastFilter is
    generic(Width    :integer     :=12;
        N :integer    :=20);
    port(    reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           clk6M:IN STD_LOGIC;
           x:IN signed(width-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end FastFilter;



architecture behaiv_arch of FastFilter is


   COMPONENT BitMulti IS
      GENERIC(WIDTH:INTEGER:=12);
      PORT(reset:IN STD_LOGIC;
             clk:IN STD_LOGIC;
	     start:IN STD_LOGIC;
	     A:IN signed(WIDTH-1 downto 0); -- X-input
	     B:IN signed(WIDTH-1 downto 0); -- coff modified vector
	     y:OUT signed(WIDTH-1 downto 0); -- multiplied output
             finished:OUT STD_LOGIC);
   END COMPONENT BitMulti;


-- New signals
signal swapping    :std_logic :='0'; --this shall trigger when start goes to '1' and go down when start goes to '0' to see if there is a new x or not
signal i    :integer range 0 to N; --index for how many clkcykles the calculation have been running
signal finished_sig,GoOn    :std_logic :='1';
signal MultiInput,MultiCoff,MultiOutput :signed(width-1 downto 0);
signal MultiFinished,start    :std_logic :='1'; 





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
		     start=>'1',
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
        for i in 0 to (N-1) loop
                xL(i)<=(others=> '0');  
        end loop;
        
        for i in 0 to (N-1) loop
               MiddleAdder(i)<=(others=> '0');
               queue2multi(i)<=(others=> '0');
        end loop;
        

        -- here the coeff. comes in for ex.

		
		t(0)<="000000000000";
		t(1)<="000000000001";
		t(2)<="000000000010";
		t(3)<="000000000011";
		t(4)<="000000000100";
		t(5)<="000010000101";
		t(6)<="000010000110";
		t(7)<="000010000111";
		t(8)<="000010001000";
		t(9)<="000010001000";
		t(10)<="000100001001";
		t(11)<="000100001001";
		t(12)<="000100001001";
		t(13)<="000100001000";
		t(14)<="000100001000";
		t(15)<="000100000111";
		t(16)<="000110000101";
		t(17)<="000100000100";
		t(18)<="000100000010";
		t(19)<="000100000000";
		


    elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------SENDING OUT ---------------------------    
--------------------------------------------------------------------       
        if(finished_sig = '0' AND GoOn='1') then
            
            if(i=N) then
                finished <= '1';
                finished_sig <= '1';
                y <= y_s(2*width-2 downto width-1);
                
            else
		MultiInput<=queue2multi(i);
		MultiCoff<=t(i);
		if(MultiFinished<='1') then
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


