

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY BitMulti IS
   GENERIC (WIDTH:INTEGER:=12);
	PORT(reset:IN STD_LOGIC;
             clk:IN STD_LOGIC;
	     start:IN STD_LOGIC;
	     A:IN signed(WIDTH-1 downto 0); -- X-input
	     B:IN signed(WIDTH-1 downto 0); -- coff modified vector
	     y:OUT signed(2*WIDTH-1 downto 0); -- multiplied output
             finished:OUT STD_LOGIC);
END BitMulti;


ARCHITECTURE arch_BitMulti OF
                      BitMulti IS
SIGNAL OnGoing,done:STD_LOGIC:='0';
SIGNAL B_stored,A_stored:signed(2*width-1 downto 0);
SIGNAL outs:signed(2*width-1 downto 0);
type BucketA is array (1 to 12) of signed(2*width-1 downto 0);
signal Bucket	:BucketA;

-- B_stored,Bucket = 10 bits




BEGIN

process(clk, reset,OnGoing)
begin
	if start = '0' then
		outs <= (others => '0');
		B_stored <= (others => '0');
		A_stored <= (others => '0');
		for i in 1 to 12 loop
               Bucket(i)<=(others=> '0'); 
		end loop;
	elsif rising_edge(clk) AND start='1' AND OnGoing<='0' then
	   A_stored(2*width-1 downto width) <= A;
	   A_stored(width-1 downto 0) <= (others => '0');
	   B_stored(2*width-1 downto width) <= B;
	   B_stored(width-1 downto 0) <= (others => '0');
	   --y <= outs(2*width-1 downto width);
	  finished <= '0';
	  OnGoing <= '1';
	end if;
	if(OnGoing = '1' AND start ='1') then
		for i in 1 to 12 loop
              	 Bucket(i)<=(others=> '0'); 
		end loop;
		for i in 1 to 12 loop
			if B_stored(24-i) ='1' then
				Bucket(i) <= (A_stored srl (i-1));
				if(i = 12) then
					finished <= '1';
					OnGoing <= '0';
					y <= Bucket(12)+Bucket(11)+Bucket(10)+ Bucket(9)+Bucket(8)+ Bucket(7)+Bucket(6)+ Bucket(5)+Bucket(4)+ Bucket(3)+Bucket(2)+Bucket(1);
				end if;	
			elsif(i = 12) then 
				finished <= '1';
				OnGoing <= '0';
				y <= Bucket(11)+Bucket(10)+ Bucket(9)+Bucket(8)+ Bucket(7)+Bucket(6)+ Bucket(5)+Bucket(4)+ Bucket(3)+Bucket(2)+Bucket(1);
			end if;
		
		end loop;
	end if;
end process;
END arch_BitMulti;