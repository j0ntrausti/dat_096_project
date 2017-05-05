----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2017 23:41:56
-- Design Name: 
-- Module Name: mem_reg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity mem_reg is
    Port ( 
           start : in STD_LOGIC ;
           stop : out STD_LOGIC ;
           input_bits : in std_logic_vector (23 downto 0);
           ctrl_bits : out std_logic_vector (23 downto 0);
           --clk : in STD_LOGIC;
           reset_in: in STD_LOGIC);
end mem_reg;

architecture Behavioral of mem_reg is
begin
process(start,input_bits,reset_in)
begin
if (reset_in = '1') then
    ctrl_bits<= "111110101100011010001000";
    stop <='0';
else
 if (start = '1')then
 ctrl_bits <= input_bits;
 stop <='1';
else 
   ctrl_bits<= "111110101100011010001000";
    stop <='0';
 end if;
end if;
end process;
end Behavioral;
