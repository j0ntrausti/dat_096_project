library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.MUX_PACK.all;

entity mux_8to1_top is

    Port ( ready : in std_logic ;
           finish : out std_logic;
           mux_ch_selection : in  std_logic_vector (2 downto 0);     -- select input
           Mux_in  : in  Mux_ctrlType;     -- inputs
           Mux_out : out std_logic_vector(23 downto 0)); -- output
end mux_8to1_top;

architecture Behavioral of mux_8to1_top is
begin

p1:process(ready, Mux_ch_selection, Mux_in)
 
begin 

if (ready= '1') then 

case mux_ch_selection is

when "000" => Mux_out <= Mux_in(0); 
when "001" => Mux_out <= Mux_in(1);
when "010" => Mux_out <= Mux_in(2);
when "011" => Mux_out <= Mux_in(3);
when "100" => Mux_out <= Mux_in(4); 
when "101" => Mux_out <= Mux_in(5);
when "110" => Mux_out <= Mux_in(6); 
when "111" => Mux_out <= Mux_in(7);
when others => Mux_out <= (others => '0');

end case;
finish <= '1';

else 

finish <= '0';

end if ;



end process;     
                
end Behavioral;
