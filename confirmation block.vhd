----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2017 23:23:26
-- Design Name: 
-- Module Name: confirmation block - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity confirmation_block is

    Port ( con_mux_in : in STD_LOGIC_VECTOR (7 downto 0);
           reset_in2 : in std_logic;
           con_mux_out : out STD_LOGIC);
           
end confirmation_block;

architecture Behavioral of confirmation_block is

signal comparator : STD_LOGIC_VECTOR (7 downto 0) := (others=>'1');


begin

p2:process (con_mux_in, reset_in2)

begin
if (reset_in2 = '1') then
con_mux_out <='0';
else 
case con_mux_in is
when "11111111" => con_mux_out <= '1'; 
when others => con_mux_out <= '0';
end case;

end if ;
end process;
end Behavioral;
