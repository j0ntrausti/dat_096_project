--copyrights : technical Q youtube channel.
-- once we test all codes togeather i ll do re-modify the code completely without copyrights issue
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity fifo is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           wr : in  STD_LOGIC;
           rd : in  STD_LOGIC;
           datain : in  STD_LOGIC_VECTOR (3 downto 0);
           dataout : out signed (3 downto 0); -- STD_LOGIC_VECTOR
           empty : out  STD_LOGIC;
           full : out  STD_LOGIC);
end fifo;

architecture fifo_arch of fifo is

begin
fifo_proc:process(clk)
type fifo_memory is  array(0 to 3) of std_logic_vector(3 downto 0);
variable memory:fifo_memory;
variable head:natural range 0 to 3;
variable tail:natural range 0 to 3;
variable looped:boolean;
begin
	if rising_edge(clk)then
		if rst='1'then
		head:=0;
		tail:=0;
		looped:=false;
		full<='0';
		empty<='1';
		
   else
		if(rd='1')then
			if((looped=true)or(head/=tail))then
			dataout<=memory(tail);
			if(tail=3)then
				tail:=0;
				looped:=false;
			else
			tail:=tail+1;
			end if;
		   end if;
      end if;

     if(wr='1')then
      if((looped =false)or(head/=tail))then
      memory(head):=datain;
		if (head=3) then
			head :=0;
			looped:=true;
		else
			head:=head+1;
		end if;
		end if;
	 end if;

	if(head=tail)then
		if looped then
			full<='1';
		else
			empty <='1';
		end if;


	else
			full<='0';
			empty<='0';
	end if;
	end if;
  end if;
end process;
end fifo_arch;