library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- the confirmation block is to make sure all the mux ate loaded with the control bits 



-- component
entity confirmation_block is

    Port ( con_mux_in : in STD_LOGIC_VECTOR (7 downto 0); -- 8 individual single bit confirmation lines connected from the 8 individual mux
           reset_in2 : in std_logic; -- just to reset the those 8 individual confirmation line to 0 anfter the switching process got over
           con_mux_out : out STD_LOGIC); -- otuput of the confimation block refered as stop bit in the top design used inimate the end of the process
           
end confirmation_block;

architecture Behavioral of confirmation_block is

signal comparator : STD_LOGIC_VECTOR (7 downto 0) := (others=>'1'); --- signal 


begin

p2:process (con_mux_in, reset_in2)

begin
if (reset_in2 = '1') then   -- if defines the reset statement of this block
con_mux_out <='0';
else        -- else defines condition when based on the input
case con_mux_in is
when "11111111" => con_mux_out <= '1'; 
when others => con_mux_out <= '0';
end case;

end if ;
end process;
end Behavioral;
