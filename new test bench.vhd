----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2017 05:06:39
-- Design Name: 
-- Module Name: TestBench - Behavioral
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
USE work.MUX_PACK.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestBench is
--  Port ( );
end TestBench;

architecture Behavioral of TestBench is

component top_switch is
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           system_start : in STD_LOGIC;
           system_in : in std_logic_vector(23 downto 0);
           switch_mux_in : in Mux_ctrlType;
           system_stop : out STD_LOGIC;
           switch_mux_out : out Mux_ctrlType);
end component;

signal Tb_Clk_in: STD_LOGIC := '0';
signal Tb_Reset_in: STD_LOGIC:='0';
signal Tb_system_start : STD_LOGIC:='1';
signal Tb_system_in : std_logic_vector(23 downto 0);
signal Tb_switch_mux_in : Mux_ctrlType;

signal Tb_system_stop : std_logic;
signal Tb_switch_mux_out : Mux_ctrlType;

begin

    
    p1:top_switch Port map (
        clk_in => Tb_Clk_in,
        reset => Tb_Reset_in,
        system_start => Tb_system_start,
        system_in => Tb_system_in,
        switch_mux_in => Tb_switch_mux_in,
        system_stop => Tb_system_stop,
        switch_mux_out => Tb_switch_mux_out 
    );

Clock_Proc: Process 

begin

    Tb_Clk_in<= '0';
        wait for 5ns;  --for 0.5 ns signal is '0'.
    Tb_Clk_in<= '1';
        wait for 5ns;  --for next 0.5 ns signal is '1'.
    end process;
    
    
Test_Proc: Process 

begin
    Tb_Reset_in        <= '1', 
                       '0' AFTER 15 ns;

    Tb_system_in        <= "111110101100011010001000", 
                           "000000111111000000111111" AFTER 700 ns;
                           
    Tb_switch_mux_in(0) <= "000000000000000000000000", 
                           "000000000000111111111111" AFTER 10 ns, 
                           "111111111111000000000000" AFTER 20 ns, 
                           "000000111111000000111111" AFTER 30 ns;
                           
    Tb_switch_mux_in(1) <= "000000000000000000000000", 
                                                  "000000000000111111111111" AFTER 10 ns, 
                                                  "111111111111000000000000" AFTER 20 ns, 
                                                  "000000111111000000111111" AFTER 30 ns;
                                                                             
    Tb_switch_mux_in(2) <= "000000000000000000000000", 
                            "000000000000111111111111" AFTER 10 ns, 
                            "111111111111000000000000" AFTER 20 ns, 
                            "000000111111000000111111" AFTER 30 ns;           

                           
    Tb_switch_mux_in(3) <= "000000000000000000000000", 
                           "000000000000111111111111" AFTER 10 ns, 
                           "111111111111000000000000" AFTER 20 ns, 
                           "000000111111000000111111" AFTER 30 ns;
                           
    Tb_switch_mux_in(4) <= "000000000000000000000000", 
                                                  "000000000000111111111111" AFTER 10 ns, 
                                                  "111111111111000000000000" AFTER 20 ns, 
                                                  "000000111111000000111111" AFTER 30 ns;
                                                                             
    Tb_switch_mux_in(5) <= "000000000000000000000000", 
                            "000000000000111111111111" AFTER 10 ns, 
                            "111111111111000000000000" AFTER 20 ns, 
                            "000000111111000000111111" AFTER 30 ns;                                                                             
                                                                                
                           
     Tb_switch_mux_in(6) <= "000000000000000000000000", 
                            "000000000000111111111111" AFTER 10 ns, 
                            "111111111111000000000000" AFTER 20 ns, 
                            "000000111111000000111111" AFTER 30 ns;
                            
     Tb_switch_mux_in(7) <= "000000000000000000000000", 
                                                   "000000000000111111111111" AFTER 10 ns, 
                                                   "111111111111000000000000" AFTER 20 ns, 
                                                   "000000111111000000111111" AFTER 30 ns;                                                                    
                                                                                              

    Tb_system_start <= '0',
                       '1' after 9ns;
                                  
                              
    wait;
    end process;    

end Behavioral;
