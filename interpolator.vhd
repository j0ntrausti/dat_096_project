
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;


entity interpolator is
	port(	Clk_enable: in std_logic; -- input the higher Clk_enable (To interpolate to 6 Mhz, this should be 6 Mhz)
		reset: in std_logic;
		input: in std_logic_vector(11 downto 0);
		output: out std_logic_vector(11 downto 0));
end interpolator; 

architecture interpolator_arch of interpolator is

signal interpolate: integer := 8; -- Interpolation factor (For 1 Mhz to 6Mhz, put 6 here)
signal counter: integer := 0;

BEGIN
	PROCESS ( Clk_enable, reset )
	BEGIN
		IF reset = '0' then 
			output <=  (OTHERS =>'0') ;
			counter <= 0;
			
		elsif rising_edge(clk_enable)then

			if counter = interpolate-1 then
				output <= input;
				counter <= 0;
			else

				output <= (OTHERS => '0');
				counter <= counter + 1;

			end if; 
		END IF;	
	

	END PROCESS;


end interpolator_arch;