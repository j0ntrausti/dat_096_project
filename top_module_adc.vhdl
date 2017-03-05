-------top_module----------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity top_module is 
port(
CS0:out std_logic;
CS1:out std_logic;
clk : in std_logic;
clk_6Mhz : out std_logic;
Reset: in std_logic;
Read_low :out std_logic ; 
Wr_low: out std_logic ; 
config_output_D11_D0: inout std_logic_vector (11 downto 0);
--config_output_D11_D0: out std_logic_vector (11 downto 0);
Data_av: in std_logic;
DIG_OUT_TOP : out std_logic_vector (11 downto 0)
);
end top_module ;

architecture top_module_arch of top_module is

signal Digital_op:  std_logic_vector (11 downto 0);
signal Clk_enable:  std_logic;

component samplefreq_clk_6Mhz is
port(	clk: in std_logic;
	samplefreq_clk: out std_logic);
end component; 


component ADC_THS1206 is 
port(
CS0_activelow: out std_logic;
CS1_activehigh: out std_logic;
--clk: in std_logic;
clk_6MHz: in std_logic;
dig_out: out std_logic_vector (11 downto 0);
reset: in std_logic;
data_av: in std_logic;
rd_activelow: out std_logic ; 
wr_activelow: out std_logic ; 
D11_D0 : inout std_logic_vector (11 downto 0) ----must be sat as inout?
);
end component  ;


begin

clk_6Mhz <= Clk_enable;

comp_clk: component samplefreq_clk_6Mhz
			port map ( clk=>clk,
					   samplefreq_clk=>Clk_enable
			
					);
			
			
			

comp_adc : component ADC_THS1206 
			port map ( 		CS0_activelow =>CS0,
							CS1_activehigh =>CS1,
							clk_6MHz=>Clk_enable, 
							dig_out=> DIG_OUT_TOP,
							reset=>Reset,
							data_av=>Data_av,
							rd_activelow=>Read_low,
							wr_activelow=>Wr_low,
							D11_D0 => config_output_D11_D0
					);
			
			
			
			
			

end architecture top_module_arch ;
