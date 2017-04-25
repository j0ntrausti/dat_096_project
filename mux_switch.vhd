library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.MUX_PACK.all;

entity mux_32to1_top is
    Port ( clk: in std_logic;
           mux_ch_selection : in  signed (4 downto 0);     -- select input
           Mux_in  : in  Mux_ctrlType; --STD_LOGIC_VECTOR (31 downto 0);     -- inputs
           Mux_out : out signed(11 downto 0));                        -- output
end mux_32to1_top;

architecture Behavioral of mux_32to1_top is
begin
p1:process (clk)
begin 
case mux_ch_selection is
when "00000" => Mux_out <= Mux_in(0)(11 downto 0); 
when "00001" => Mux_out <= Mux_in(1)(11 downto 0);
when "00010" => Mux_out <= Mux_in(2)(11 downto 0);
when "00011" => Mux_out <= Mux_in(3)(11 downto 0);
when "00100" => Mux_out <= Mux_in(4)(11 downto 0); 
when "00101" => Mux_out <= Mux_in(5)(11 downto 0);
when "00110" => Mux_out <= Mux_in(6)(11 downto 0); 
when "00111" => Mux_out <= Mux_in(7)(11 downto 0);

when "01000" => Mux_out <= Mux_in(8)(11 downto 0);
when "01001" => Mux_out <= Mux_in(9)(11 downto 0);
when "01010" => Mux_out <= Mux_in(10)(11 downto 0);
when "01011" => Mux_out <= Mux_in(11)(11 downto 0);
when "01100" => Mux_out <= Mux_in(12)(11 downto 0);
when "01101" => Mux_out <= Mux_in(13)(11 downto 0);
when "01110" => Mux_out <= Mux_in(14)(11 downto 0);
when "01111" => Mux_out <= Mux_in(15)(11 downto 0);

when "10000" => Mux_out <= Mux_in(16)(11 downto 0);
when "10001" => Mux_out <= Mux_in(17)(11 downto 0);
when "10010" => Mux_out <= Mux_in(18)(11 downto 0);
when "10011" => Mux_out <= Mux_in(19)(11 downto 0);
when "10100" => Mux_out <= Mux_in(20)(11 downto 0);
when "10101" => Mux_out <= Mux_in(21)(11 downto 0);
when "10110" => Mux_out <= Mux_in(22)(11 downto 0);
when "10111" => Mux_out <= Mux_in(23)(11 downto 0);

when "11000" => Mux_out <= Mux_in(24)(11 downto 0);
when "11001" => Mux_out <= Mux_in(25)(11 downto 0);
when "11010" => Mux_out <= Mux_in(26)(11 downto 0);
when "11011" => Mux_out <= Mux_in(27)(11 downto 0);
when "11100" => Mux_out <= Mux_in(28)(11 downto 0);
when "11101" => Mux_out <= Mux_in(29)(11 downto 0);
when "11110" => Mux_out <= Mux_in(30)(11 downto 0);
when "11111" => Mux_out <= Mux_in(31)(11 downto 0); 

  
end case;
end process;     
                

--with mux_ch_selection select
--- Mux_out(0) <= Mux_in(0)(1) when "00000",
 --        Mux_in(1) when "00001",
  --       Mux_in(2) when "00010",
   --      Mux_in(3) when "00011",
       --  Mux_in(5) when "00101",
       --  Mux_in(6) when "00110",
       --  Mux_in(7) when "00111",
         --Mux_in(8) when "01000",
        -- Mux_in(9) when "01001",
        -- Mux_in(10)when "01010",
        -- Mux_in(11)when "01011",
        -- Mux_in(12)when "01100",
        -- Mux_in(13)when "01101",
        -- Mux_in(14)when "01110",
        -- Mux_in(15)when "01111",
        -- Mux_in(16)when "10000",
        -- Mux_in(17)when "10001",
         --Mux_in(18)when "10010",
        -- Mux_in(19)when "10011",
        -- Mux_in(20)when "10100",
        -- Mux_in(21)when "10101",
        -- Mux_in(22)when "10110",
         --Mux_in(23)when "10111",
        --- Mux_in(24)when "11000",
        --- Mux_in(25)when "11001",
         --Mux_in(26)when "11010",
         --Mux_in(27)when "11011",
         --Mux_in(28)when "11100",
         --Mux_in(29)when "11101",
         --Mux_in(30)when "11110",
         --Mux_in(31)when "11111",
         --'0'  when others;
end Behavioral;
