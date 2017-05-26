----------------------------------------------------------------------------------------------------
---file:7-seg.vhdl----------------------------------------------------------------------
---purpose: one of the components of UART vhdl code
------------displays digital value from 0 to F on 7-segment
---------------------------------------------------------------------------------------------------



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


-------------------package sub_function gives the definition of displaying digital value from 0 to F.-----------------------------------
package sub_function is

function hex_7seg(in_data: STD_LOGIC_VECTOR)return STD_LOGIC_VECTOR;
type vector_array is array ( N-1 downto 0) of STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
end package sub_function;


package body sub_function is

function hex_7seg(in_data: STD_LOGIC_VECTOR)return STD_LOGIC_VECTOR is
variable  local_data: STD_LOGIC_VECTOR(7 DOWNTO 0):="11111110";  -------initial value and only open the most right of 8 7-segments.

begin
local_data := in_data;
case local_data is
		when "00000000" => return "0000001"; -----digital value 0
		when "00000001" => return "1001111"; -----digital value 1
		when "00000010" => return"0010010";  -----digital value 2
		when "00000011" => return "0000110"; -----digital value 3
		when "00000100" => return "1001100";-----digital value 4
		when "00000101" => return "0100100";-----digital value 5
		when "00000110" => return "0100000";-----digital value 6
		when "00000111" => return"0001111";-----digital value 7
		when "00001000" => return "0000000";-----digital value 8
		when "00001001" => return "0000100";-----digital value 9
		when "00001010" => return "0001000";-----digital value A
		when "00001011" => return"1100000";-----digital value B
		when "00001100" => return "0110001";-----digital value C
		when "00001101" => return "1000010";-----digital value D
		when "00001110" => return "0110000";-----digital value E
		when "00001111" => return"0111000";-----digital value F
		when others => return "1111111";-----no digital value
		
end case;
end function;

end package body;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.sub_function.all;


-------------------entity for writing data on 7-segment-------------------------------------
ENTITY readwrite_display IS
	 
	 PORT ( 
			data : IN STD_LOGIC_VECTOR(7 downto 0);
			clk : IN  STD_LOGIC;
			ANO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			CATH : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			Reset : IN STD_LOGIC
	       );
            
END readwrite_display;


ARCHITECTURE arch_readwrite_display OF readwrite_display IS


BEGIN
-------write read data-----------
ANO <= "11111110";	
CATH <= hex_7seg(data);	

writ_read_data:
process(Reset,clk)
begin

if Reset = '1' then
			 ANO <= "11111110";	
end if; ----reset

END PROCESS writ_read_data;
END arch_readwrite_display;