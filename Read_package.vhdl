library IEEE; 
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-----------------------------------------------------------------------------
-- Declarations
-----------------------------------------------------------------------------    
package Read_package is

  constant Blockss   : integer := 4;
  constant Channelss : integer := 8;
  constant WIDTH   	: integer := 16;
  
  --even indexses are real parts, odd are imaginary
  type Blocks is array (2*Blockss-1 downto 0) of signed(WIDTH-1 downto 0);
  type Channels is array (2*Channelss-1 downto 0) of signed(WIDTH-1 downto 0);
  type Signals is array (Blockss-1 downto 0) of Channels;
  
  --function loadOperand (fileName : string) return Operand_array;
  --function loadOpCode (fileName : string) return OpCode_array;
  
  -- converts STD_LOGIC into a character
  function chr(sl: STD_LOGIC) return character;
  
  -- converts STD_LOGIC into a string (1 to 1)
  function str(sl: STD_LOGIC) return string;

  -- converts STD_LOGIC_VECTOR into a string (binary base)
  function str(slv: STD_LOGIC_VECTOR) return string;

end Read_package;

-----------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------
package body Read_package is
    
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

  --function loadOperand (
--    fileName : string)
--    return Operand_array is
--    file objectFile : text open read_mode is fileName;
--    variable memory : Operand_array;
--    variable L      : line;
--    variable index  : natural := 0;
--    variable myChar : character;
--  begin
--    while not endfile(objectFile) loop
--      readline(objectFile, L);
--      for i in 31 downto 0 loop
--        read(L, myChar);
--        memory(index)(i) := bin(myChar);
--      end loop;
--      index := index + 1;
--    end loop;
--    return memory;
--  end loadOperand;
--
--
--  function loadOpCode (
--    fileName : string)
--    return OpCode_array is
--    file objectFile : text open read_mode is fileName;
--    variable memory : OpCode_array;
--    variable L      : line;
--    variable index  : natural := 0;
--    variable myChar : character;
--  begin
--    while not endfile(objectFile) loop
--      readline(objectFile, L);
--      for i in 3 downto 0 loop
--        read(L, myChar);
--        memory(index)(i) := bin(myChar);
--      end loop;
--      index := index + 1;
--    end loop;
--    return memory;
--  end loadOpCode;
  
  -- converts STD_LOGIC into a character
  function chr(sl: STD_LOGIC) return character is
    variable c: character;
  begin
    case sl is
      when 'U' => c:= 'U';
      when 'X' => c:= 'X';
      when '0' => c:= '0';
      when '1' => c:= '1';
      when 'Z' => c:= 'Z';
      when 'W' => c:= 'W';
      when 'L' => c:= 'L';
      when 'H' => c:= 'H';
      when '-' => c:= '-';
    end case;
    return c;
   end chr;
  
  -- converts STD_LOGIC into a string (1 to 1)
  function str(sl: STD_LOGIC) return string is
    variable s: string(1 to 1);
  begin
    s(1) := chr(sl);
    return s;
  end str;



   -- converts STD_LOGIC_VECTOR into a string (binary base)
   function str(slv: STD_LOGIC_VECTOR) return string is
     variable result : string (1 to slv'length);
     variable r : integer;
   begin
     r := 1;
     for i in slv'range loop
        result(r) := chr(slv(i));
        r := r + 1;
     end loop;
     return result;
   end str;
  
end Read_package;
