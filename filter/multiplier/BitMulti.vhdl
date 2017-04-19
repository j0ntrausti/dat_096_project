
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
	     y:OUT signed(WIDTH-1 downto 0); -- multiplied output
             finished:OUT STD_LOGIC);
END BitMulti;


ARCHITECTURE arch_BitMulti OF
                      BitMulti IS
SIGNAL OnGoing,done:STD_LOGIC;
SIGNAL B_stored,A_stored:signed(width-1 downto 0);
SIGNAL Bucket:signed(2*width-1 downto 0);


-- B_stored,Bucket = 10 bits




BEGIN

process(clk, reset)
begin
	if reset = '1' then
		Bucket <= (others => '0');
		B_stored <= (others => '0');
		A_stored<=(others=>'0');
	elsif rising_edge(clk) AND start='1' then
	  B_Stored <= B;
	  A_stored <= A;
	  Bucket(2*width-1 downto width) <= (others=>'0');
	  finished <= '0';
	  OnGoing <= '1';
	elsif(OnGoing = '1' AND start ='1') then
		for i in 1 to 12 loop
			if B_stored(12-i) ='1' then
				Bucket( <= Bucket + (A_stored srl (i-1));
				if(i = 12) then
					done <= '1';
				end if;	
			elsif(i = 12) then 
				done <= '1';
			end if;

		end loop;
		if(done = '1') then
			y <= Bucket(2*width-1 downto width);
			done <= '0';
			finished <= '1';
			OnGoing <= '0';
		end if;
	end if;
end process;




END arch_BitMulti;