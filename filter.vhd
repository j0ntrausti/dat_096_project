--- The serial filter ---
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n]. 
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)

-- NOTE: need to adjust bits. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter is 
--jag bör ändra dessa generic värden för eller senare
	generic(Width	:integer 	:=12;
		N :integer	:=4);
	port(	reset:STD_LOGIC;
           start:STD_LOGIC;
           clk:STD_LOGIC;
           x:IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
           y:OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end filter;

architecture behaiv_arch of filter is
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
		--reset everything!! :D
		onGoing<='0';
		i<=0;		
		for i in 0 to N-2 loop
			if (i<(N-1)) then
				xL(i)<=(others=> '0');
			end if;
		end loop;

		t(0)<="111110110000";
		t(1)<="000000111010";
		t(2)<="000000111010";
		t(3)<="111110110000";
		

	elsif (rising_edge(clk)) then		
		if ((start='1' and onGoing='0')) then--start the filter calculation
			finished<='0';
			onGoing<='1';
			y_s<=std_logic_vector(signed(x)*signed(t(0)));
			i<=1;
		elsif (ongoing='1') then
			
			if (i=N-1) then--last itteration
				i<=0;
				onGoing<='0';
				finished<='1';
				y<=std_logic_vector((signed(xL(i-1))*signed(t(i))+signed(y_s)) );--sll 1 makes sure that the output format is 1,15 not 1,14 (maybe need to sll 1)sll 1

				for j in 0 to N-2 loop--Swap the x-array
					if (j<(N-2)) then
						xL(N-2-j)<=xL(N-3-j);
					elsif (j=(N-2)) then
						xL(0)<=x;
					end if;
				end loop;
			else
				y_s<=std_logic_vector(signed(xL(i-1))*signed(t(i))+signed(y_s));		
				i<=i+1;
			end if;
		end if;		
	end if;
end process;

end behaiv_arch;
