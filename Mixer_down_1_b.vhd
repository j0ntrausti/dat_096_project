library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--First mixer down step
--capability for four blocks but only block 0 is used
--mixes carrier signal down to block level
entity Mixer_down_1 is
GENERIC (WIDTH:INTEGER:=10);
PORT(   clk_5MHz : in STD_LOGIC;
        in_r : in signed(WIDTH-1 downto 0); -- real input (carrier level)
        out_r_0 : out signed(WIDTH-1 downto 0); -- block 0 real output
        out_i_0 : out signed(WIDTH-1 downto 0); -- block 0 imaginary output
        out_r_1 : out signed(WIDTH-1 downto 0); -- block 1 real output
        out_i_1 : out signed(WIDTH-1 downto 0); -- block 1 imaginary output
        out_r_2 : out signed(WIDTH-1 downto 0); -- block 2 real output
        out_i_2 : out signed(WIDTH-1 downto 0); -- block 2 imaginary output
        out_r_3 : out signed(WIDTH-1 downto 0); -- block 3 real output
        out_i_3 : out signed(WIDTH-1 downto 0));-- block 3 imaginary output
end Mixer_down_1;

architecture Behavioral of Mixer_down_1 is

--DUE TO ONLY USING ONE BLOCK, CAPABILITIES TO MIX DOWN OTHER BLOCKS HAVE BEEN COMMENTED OUT!

--Sin/Cos generation component
component sin_cos_4MHz    
GENERIC (WIDTH:INTEGER:=10);
PORT ( clk_5MHz : in STD_LOGIC;
       Cos_0 : out signed(WIDTH-1 downto 0); -- 1.125MHz
       Cos_1 : out signed(WIDTH-1 downto 0); -- 1.375MHz
       Cos_2 : out signed(WIDTH-1 downto 0); -- 1.625MHz
       Cos_3 : out signed(WIDTH-1 downto 0); -- 1.875MHz
       Sin_0 : out signed(WIDTH-1 downto 0); -- 1.125MHz
       Sin_1 : out signed(WIDTH-1 downto 0); -- 1.375MHz
       Sin_2 : out signed(WIDTH-1 downto 0); -- 1.625MHz
       Sin_3 : out signed(WIDTH-1 downto 0));-- 1.875MHz
end component;

--Complex multiplier (modified for one real only input)
component First_Multi
GENERIC (WIDTH:INTEGER:=10); 
 PORT (
    clk : IN STD_LOGIC;
    a_r : IN signed(WIDTH-1 DOWNTO 0);
    b_r : IN signed(WIDTH-1 DOWNTO 0);
    b_i : IN signed(WIDTH-1 DOWNTO 0);
    ut_r : OUT signed(WIDTH-1 DOWNTO 0);
    ut_i : OUT signed(WIDTH-1 DOWNTO 0)
  );
end component;

signal Cos_0 : signed(WIDTH-1 downto 0);-- 1.125MHz
signal Cos_1 : signed(WIDTH-1 downto 0);-- 1.375MHz
signal Cos_2 : signed(WIDTH-1 downto 0);-- 1.625MHz
signal Cos_3 : signed(WIDTH-1 downto 0);-- 1.875MHz
signal Sin_0 : signed(WIDTH-1 downto 0);-- 1.125MHz
signal Sin_1 : signed(WIDTH-1 downto 0);-- 1.375MHz
signal Sin_2 : signed(WIDTH-1 downto 0);-- 1.625MHz
signal Sin_3 : signed(WIDTH-1 downto 0);-- 1.875MHz


begin

sin_cos_1: sin_cos_4MHz
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
       clk_5MHz => clk_5MHz,
       Cos_0 => Cos_0,-- 1.125MHz
       Cos_1 => Cos_1,-- 1.375MHz
       Cos_2 => Cos_2,-- 1.625MHz
       Cos_3 => Cos_3,-- 1.875MHz
       Sin_0 => Sin_0,-- 1.125MHz
       Sin_1 => Sin_1,-- 1.375MHz
       Sin_2 => Sin_2,-- 1.625MHz
       Sin_3 => Sin_3-- 1.875MHz
      );
         
mult_0: First_Multi
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_5MHz,
    a_r => in_r,
    b_r => Cos_0,
    b_i => Sin_0,
    ut_r => out_r_0,
    ut_i => out_i_0
  );
  
--mult_1: First_Multi
--GENERIC MAP(WIDTH => WIDTH)
--PORT MAP (
--    clk => clk_5MHz,
--    a_r => in_r,
--    b_r => Cos_1,
--    b_i => Sin_1,
--    ut_r => out_r_1,
--    ut_i => out_i_1
--  );

--mult_2: First_Multi
--GENERIC MAP(WIDTH => WIDTH)
--PORT MAP (
--    clk => clk_5MHz,
--    a_r => in_r,
--    b_r => Cos_2,
--    b_i => Sin_2,
--    ut_r => out_r_2,
--    ut_i => out_i_2
--  );

--mult_3: First_Multi
--GENERIC MAP(WIDTH => WIDTH)
--PORT MAP (
--    clk => clk_5MHz,
--    a_r => in_r,
--    b_r => Cos_3,
--    b_i => Sin_3,
--    ut_r => out_r_3,
--    ut_i => out_i_3
--  );

--REMOVE THIS IF USING MORE THAN ONE BLOCK!
out_r_1 <= (others => '0');
out_i_1 <= (others => '0');
out_r_2 <= (others => '0');
out_i_2 <= (others => '0');
out_r_3 <= (others => '0');
out_i_3 <= (others => '0');
  
end Behavioral;
