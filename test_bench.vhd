library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.MUX_PACK.all;


entity top_switch_testbench is
    
end top_switch_testbench;

architecture arch_switch_testbench of top_switch_testbench is
    

component top_switch is
    Port (  clk_in : in STD_LOGIC;
          reset : in STD_LOGIC;
          system_start : in STD_LOGIC;
          system_in : in std_logic_vector(23 downto 0);
          switch_mux_in : in Mux_ctrlType;
          system_stop : out STD_LOGIC;
          switch_mux_out : out Mux_ctrlType);
end component top_switch;
    

SIGNAL clk_in_tb_signal : STD_LOGIC:='0';
SIGNAL reset_in_tb_signal :  STD_LOGIC:='0';
SIGNAL system_in_tb_signal :  std_logic_vector(23 downto 0);
SIGNAL switch_mux_in_tb_signal :  Mux_ctrlType;
SIGNAL system_start_tb_signal: STD_LOGIC;
SIGNAL  system_stop_tb_signal : STD_LOGIC;
SIGNAL I: integer range 0 to 10; 
SIGNAL switch_mux_out_tb_signal : Mux_ctrlType;
		  
begin
top_switch_comp :
component top_switch
 port map( clk_in => clk_in_tb_signal,
           reset => reset_in_tb_signal,
           system_start => system_start_tb_signal,
           system_in => system_in_tb_signal,
           switch_mux_in =>  switch_mux_in_tb_signal,
           system_stop => system_stop_tb_signal,
           switch_mux_out => switch_mux_out_tb_signal);                     

--component top_switch is
--    Port (  clk_in : in STD_LOGIC;
--          reset : in STD_LOGIC;
--          system_start : in STD_LOGIC;
--          system_in : in std_logic_vector(23 downto 0);
--          switch_mux_in : in Mux_ctrlType;
--          system_stop : out STD_LOGIC;
--          switch_mux_out : out Mux_ctrlType);
--end component top_switch;

clk_proc:PROCESS
   BEGIN
      WAIT FOR 10 ns;
      clk_in_tb_signal<=NOT(clk_in_tb_signal);
    END PROCESS clk_proc;

test_in: PROCESS 
 BEGIN
 
switch_mux_in_tb_signal(I) <= "000000000000000000000000", 
                              "000000000000111111111111" AFTER 100 ns, 
                              "111111111111000000000000" AFTER 300 ns, 
                              "000000111111000000111111" AFTER 700 ns; 
                              

reset_in_tb_signal<='0',
                    '1' AFTER 125 ns,
                    '0' AFTER 225 ns;
                              
                              
system_in_tb_signal <= "111000000000000000000000", 
                       "111111000000000000000000" AFTER 100 ns, 
                       "000000000000000000000111" AFTER 300 ns, 
                       "000000000000000000111111" AFTER 700 ns;                                
                             
end process;

end arch_switch_testbench;

--test:PROCESS
--   BEGIN
--      WAIT FOR 550 ns; -- 550 ns
--      ASSERT (switch_mux_out_tb_signal="010101110101")
--      REPORT "incorrect result"
--      SEVERITY ERROR;
--      WAIT FOR 300 ns; -- 850 ns
--      ASSERT (switch_mux_out_tb_signal="110000000010")
--      REPORT "incorrect result"
--      SEVERITY ERROR;
--      WAIT FOR 300 ns; -- 1150 ns
--      ASSERT (switch_mux_out_tb_signal="100100010010")
--      REPORT "incorrect result"
--      SEVERITY ERROR;
--   END PROCESS test;					
