LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.math_real.ALL;
use std.textio.all; --this library is needed for textio functions

entity ADC is
GENERIC (WIDTH:INTEGER:=12);
	PORT(
		clk_5MHz : in STD_LOGIC;
		reset : STD_LOGIC;
		adc_out : out STD_LOGIC_VECTOR(WIDTH-1 downto 0):= (others => '0'));
end ADC;

architecture Behavioral of ADC is

signal output: STD_LOGIC_VECTOR(WIDTH-1 downto 0):=(others => '0');


 -- Declarations
  -----------------------------------------------------------------------------

  constant Size    : integer := 500000;
  type Operand_array is array (Size downto 0) of STD_LOGIC_VECTOR(15 downto 0);

signal AMem : Operand_array := (others => (others => '0'));
signal counter: integer range 0 to 1000000 := 0;


  -----------------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------------

  function bin (
    myChar : character)
    return STD_LOGIC is
    variable bin : STD_LOGIC;
  begin
    case myChar is
      when '0' => bin := '0';
      when '1' => bin := '1';
      when 'x' => bin := '0';
      when others => assert (false) rePORT "no binary character read" severity failure;
    end case;
    return bin;
  end bin;

  function loadOperand (
    fileName : string)
    return Operand_array is
    file objectFile : text open read_mode is fileName;
    variable memory : Operand_array;
    variable L      : line;
    variable index  : natural := 0;
    variable myChar : character;
  begin
    while not endfile(objectFile) loop
      readline(objectFile, L);
      for i in 15 downto 0 loop
        read(L, myChar);
        memory(index)(i) := bin(myChar);
      end loop;
      index := index + 1;
    end loop;
    return memory;
  end loadOperand;

begin

AMem <= loadOperand(string'("tvb.tv"));

process(clk_5MHz)
begin
if rising_edge(clk_5MHz) then

	output <= Amem(counter);
	--if counter =  7913 then
	--  counter <= 0;
	--else
	   counter <= counter + 1;
    --end if;
end if;

end process;

adc_out <= output;


end Behavioral;