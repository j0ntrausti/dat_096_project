----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2017 23:41:56
-- Design Name: behavirol
-- Module Name: mem_reg - Behavioral
-- Project Name: 

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity mem_reg is --this component connected to the UART (serial interface)to receive the set of control bits to drive all the 8 MUXs
    Port ( 
           start_top : in STD_LOGIC ; -- refered to begin the process
           --stop_con : in STD_LOGIC ;
           input_bits : in std_logic_vector (23 downto 0);
          
           ctrl_bits : out std_logic_vector (23 downto 0);
           --stop_top : out STD_LOGIC ;
           start_ready : out STD_LOGIC ; -- bit received from the start loaded to mux to start reading the control bits
           --clk : in STD_LOGIC;
           reset_in: in STD_LOGIC); --clear the control bits
end mem_reg;

architecture Behavioral of mem_reg is
begin
process(start_top,input_bits,reset_in)
begin

if (reset_in = '1') then
    ctrl_bits<= "111110101100011010001000";
    --stop_top <='0';
    start_ready <='0';
    
else
 if (start_top = '1')then
     start_ready<= start_top; -- load start bit to MUX
     ctrl_bits <= input_bits; -- load contol bits from the serial to control lines
    -- stop_top <='1';
  else 
   ctrl_bits<= "111110101100011010001000"; -- when no ctrl data loaded to mux normally it connected directly like i/p ch 0 => o/p ch 0
    --stop_top <='0';
 end if;
end if;
end process;
end Behavioral;
