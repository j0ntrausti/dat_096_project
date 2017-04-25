
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE MUX_PACK IS

CONSTANT CTRL_IN: INTEGER:= 5;
CONSTANT CTRL_PIN: INTEGER:= 48;

TYPE Mux_ctrlType is array (31 DOWNTO 0) of signed(11 downto 0);
TYPE Mux_ctrl_OutputType is array ( (CTRL_PIN-1) downto 0 ) of Mux_ctrlType;
TYPE Mux_selectType is array (48 DOWNTO 0) of signed(4 downto 0);

END PACKAGE;