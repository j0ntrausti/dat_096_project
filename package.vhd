
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE MUX_PACK IS ---package file created for MUX

CONSTANT CTRL_IN: INTEGER:= 8;

TYPE Mux_ctrlType is array (7 DOWNTO 0) of std_logic_vector(23 downto 0); -- 
--TYPE Mux_ctrl_OutputType is array ( 7 downto 0 ) of Mux_ctrlType;
TYPE Mux_outType is array (7 DOWNTO 0) of std_logic_vector( 23 downto 0);

END PACKAGE;