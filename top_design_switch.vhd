----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2017 20:04:06
-- Design Name: switch
-- Module Name: top_switch - Behavioral
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
USE work.MUX_PACK.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_switch is
    Port ( clk_in : in STD_LOGIC;
           reset_in : in STD_LOGIC;
           system_in : in std_logic_vector(4 downto 0);
           switch_mux_in : in Mux_ctrlType;-- in STD_LOGIC_VECTOR (32 downto 0);
           switch_mux_out : out signed(11 downto 0));
end top_switch;

architecture Behavioral of top_switch is
    
 Component mux_32to1_top is
        Port ( mux_ch_selection : in  signed (4 downto 0);     -- select input
               Mux_in  : in   Mux_ctrlType;     -- inputs
               Mux_out : out signed(11 downto 0));                        -- output
    end component;
    
 Component fifo is
 
  Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           wr : in  STD_LOGIC;
           rd : in  STD_LOGIC;
           datain : in  STD_LOGIC_VECTOR (4 downto 0);
           dataout : out  signed (4 downto 0);
           empty : out  STD_LOGIC;
           full : out  STD_LOGIC);
           
  end component;
    
signal control_test:  signed ( 4 downto 0);
signal switch_connect: signed (11 downto 0);    
signal system_connect: Mux_selectType;
signal switch_in: Mux_ctrlType;
signal count_int: integer range 0 to 31;
signal i: integer range 0 to 48;
signal data_fifo: std_logic_vector (4 downto 0);
signal empty_fifo: std_logic; -- indicator used to specify if the fifo is empty of full. Not of any particular use
signal full_fifo: std_logic;
signal rd_test: std_logic; --to_test
signal wr_test: std_logic; -- to_test
    
begin

G:FOR I in 1 to 48 generate
  test_i: mux_32to1_top 
          port map (mux_ch_selection => system_connect(I)(4 DOWNTO 0),  
          Mux_in => switch_mux_in, 
          Mux_out => switch_connect);
end generate;
            
fifo_comp: fifo
port map (
clk => clk_in,
rst => reset_in,
rd => rd_test,
wr => wr_test,
datain => system_in,
dataout => control_test,
empty => empty_fifo,
full => full_fifo);        
            

process(clk_in,reset_in)
variable system_test: signed ( 4 downto 0);
begin 
if (reset_in = '1') then
i <= 0;
elsif(RISING_EDGE(clk_in))then
    if (i<= 48) then 
    system_test := control_test;
    system_connect(I)<= system_test; 
    end if;

end if;
end process;  
end Behavioral;
