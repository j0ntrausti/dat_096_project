--- The serial filter ---
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n]. 
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)

-- NOTE: need to adjust bits. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity linearphaseFIR is 
--jag bör ändra dessa generic värden för eller senare
	generic(Width	:integer 	:=16;
		N :integer	:=100);
	port(	reset:STD_LOGIC;
           start:STD_LOGIC;
           clk:STD_LOGIC;
           x:IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
           y:OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end linearphaseFIR;



architecture behaiv_arch of linearphaseFIR is
-- New signals





-- Old signals
type xLArray is array (0 to N-2) of std_logic_vector(width-1 downto 0);
signal xL	:xLArray;
type tLArray is array (0 to N-1) of std_logic_vector(width-1 downto 0);
signal t	:tLArray;
signal y_s	:std_logic_vector(2*width-1 downto 0);--temporary output
signal i	:integer range 0 to N; --index for how many clkcykles the calculation have been running
signal onGoing	:std_logic :='0'; --this shall trigger when start goes to '1' and go down when start goes to '0' to see if there is a new x or not

begin

process(clk,reset)
begin
	if(reset='1') then
		
		
		

	elsif (rising_edge(clk)) then		
		if (start='1') then--start the filter calculation
			
			-- First x[1] gets added to the x[2*N-1] --> gets multiplied by tab1 --> Bucket1
			-- x[2} gets added to x[2*N-2] --> multiplied by tab2 --> Bucket2, added with bucket 1
			--  ..... untill counter = 
 
				
	end if;
end process;

end behaiv_arch;