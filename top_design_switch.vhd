----------------------------------------------------------------------------------

-- 
-- Create Date: 27.03.2017 20:04:06
-- Design Name: switch
-- Module Name: top_switch - Behavioral

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.MUX_PACK.all;


entity top_switch is
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           system_start : in STD_LOGIC;
           system_in : in std_logic_vector(23 downto 0);
           switch_mux_in : in Mux_ctrlType;
           system_stop : out STD_LOGIC;
           switch_mux_out : out Mux_ctrlType);
end top_switch;

architecture Behavioral of top_switch is
    
 Component mux_8to1_top is
        Port ( ready : in std_logic ;
               finish : out std_logic;
               mux_ch_selection : in std_logic_vector(2 downto 0);     -- select input
               Mux_in  : in   Mux_ctrlType;     -- inputs
               Mux_out : out std_logic_vector (23 downto 0)); -- output
    end component;
    
 Component mem_reg is
 
  Port (
            start : in STD_LOGIC ;
            stop : out STD_LOGIC ;
            input_bits : in std_logic_vector (23 downto 0);
            ctrl_bits : out std_logic_vector (23 downto 0);
            --clk : in STD_LOGIC;
            reset_in: in STD_LOGIC);

end component;

component confirmation_block is

 Port ( con_mux_in : in STD_LOGIC_VECTOR (7 downto 0);
           reset_in2 : in std_logic;
           con_mux_out : out STD_LOGIC);
end component;

-- signals used to connect mem-reg with mux 
signal ready_2_start :std_logic ;
signal ctrl_data_2_mx_ch_sl :STD_LOGIC_VECTOR (23 downto 0);
-- signals used to connect mux with confirmation block --
signal finish_2_con_mux_in : std_logic_vector(7 downto 0) ;
-- signals used to connect confirmation block with mem_reg ---
signal con_mux_out_2_stop :std_logic ;
--- signal use to connect top level to mem_reg ---
signal sys_st_2_start: std_logic;
signal sys_stop_2_stop :std_logic;
signal systemin_2_inputbits:STD_LOGIC_VECTOR (23 downto 0);


begin

G:FOR I in 0 to 7 generate 
  MUX : mux_8to1_top 
          Port map (  ready => ready_2_start ,
                      finish => finish_2_con_mux_in(I) ,
                      mux_ch_selection(2)=> ctrl_data_2_mx_ch_sl(23 -(I*3)),
                      mux_ch_selection(1)=> ctrl_data_2_mx_ch_sl(23-((I*3)+1)),
                      mux_ch_selection(0)=> ctrl_data_2_mx_ch_sl(23-((I*3)+2)),
                      Mux_in => switch_mux_in , 
                      Mux_out => switch_mux_out(I)); 
end generate;

  MUX : mux_8to1_top 
          Port map (  ready => ready_2_start ,
                      finish => finish_2_con_mux_in(0) ,
                      mux_ch_selection(2)=> ctrl_data_2_mx_ch_sl(23),
                      mux_ch_selection(1)=> ctrl_data_2_mx_ch_sl(22),
                      mux_ch_selection(0)=> ctrl_data_2_mx_ch_sl(21),
                      Mux_in => switch_mux_in , 
                      Mux_out => switch_mux_out(0)); 
 reg: mem_reg
    Port map (
             start => ready_2_start, 
             stop => sys_stop_2_stop,
             input_bits => systemin_2_inputbits, 
             ctrl_bits => ctrl_data_2_mx_ch_sl,
           --clk : in STD_LOGIC;
             reset_in=> reset);         
     
 conform: confirmation_block 
  port map( con_mux_in =>  finish_2_con_mux_in ,
            reset_in2=> reset,
            con_mux_out => con_mux_out_2_stop 
  );         

end Behavioral;
