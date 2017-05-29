library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--First mixer up step
--mixes eight channels up into one block, instansiate one per block used
entity Mixer_up_1 is
GENERIC (WIDTH:INTEGER:=10);
PORT ( clk_312KHz : in STD_LOGIC;
       in_r_0 : in signed(WIDTH-1 downto 0); -- channel 0 real input
       in_i_0 : in signed(WIDTH-1 downto 0); -- channel 0 imaginary input
       in_r_1 : in signed(WIDTH-1 downto 0); -- channel 1 real input
       in_i_1 : in signed(WIDTH-1 downto 0); -- channel 1 imaginary input
       in_r_2 : in signed(WIDTH-1 downto 0); -- channel 2 real input
       in_i_2 : in signed(WIDTH-1 downto 0); -- channel 2 imaginary input
       in_r_3 : in signed(WIDTH-1 downto 0); -- channel 3 real input
       in_i_3 : in signed(WIDTH-1 downto 0); -- channel 3 imaginary input
       in_r_4 : in signed(WIDTH-1 downto 0); -- channel 4 real input
       in_i_4 : in signed(WIDTH-1 downto 0); -- channel 4 imaginary input
       in_r_5 : in signed(WIDTH-1 downto 0); -- channel 5 real input
       in_i_5 : in signed(WIDTH-1 downto 0); -- channel 5 imaginary input
       in_r_6 : in signed(WIDTH-1 downto 0); -- channel 6 real input
       in_i_6 : in signed(WIDTH-1 downto 0); -- channel 6 imaginary input
       in_r_7 : in signed(WIDTH-1 downto 0); -- channel 7 real input
       in_i_7 : in signed(WIDTH-1 downto 0); -- channel 7 imaginary input
       out_r : out signed(WIDTH-1 downto 0); -- real output (block level)
       out_i : out signed(WIDTH-1 downto 0));-- imaginary output (block level)
end Mixer_up_1;

architecture Behavioral of Mixer_up_1 is

--Sin/Cos generation second step
component sin_cos_250KHz_up_1   
GENERIC (WIDTH:INTEGER:=10);
PORT (  clk_312KHz : in STD_LOGIC;
        Cos_0 : out signed(WIDTH-1 downto 0):= (others => '0'); --  109.375KHz
        Cos_1 : out signed(WIDTH-1 downto 0):= (others => '0'); --  78.125KHz
        Cos_2 : out signed(WIDTH-1 downto 0):= (others => '0'); --  46.875KHz
        Cos_3 : out signed(WIDTH-1 downto 0):= (others => '0'); --  15.625KHz
        Cos_4 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -15.625KHz
        Cos_5 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -46.875KHz
        Cos_6 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -78.125KHz
        Cos_7 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -109.375KHz
        Sin_0 : out signed(WIDTH-1 downto 0):= (others => '0'); --  109.375KHz
        Sin_1 : out signed(WIDTH-1 downto 0):= (others => '0'); --  78.125KHz
        Sin_2 : out signed(WIDTH-1 downto 0):= (others => '0'); --  46.875KHz
        Sin_3 : out signed(WIDTH-1 downto 0):= (others => '0'); --  15.625KHz
        Sin_4 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -15.625KHz
        Sin_5 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -46.875KHz
        Sin_6 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -78.125KHz
        Sin_7 : out signed(WIDTH-1 downto 0):= (others => '0'));-- -109.375KHz
end component;

component Multiplier
GENERIC (WIDTH:INTEGER:=10);    
 PORT (
    clk : IN STD_LOGIC;
    a_r : IN signed(WIDTH-1 DOWNTO 0);
    a_i : IN signed(WIDTH-1 DOWNTO 0);
    b_r : IN signed(WIDTH-1 DOWNTO 0);
    b_i : IN signed(WIDTH-1 DOWNTO 0);
    ut_r : OUT signed(WIDTH-1 DOWNTO 0);
    ut_i : OUT signed(WIDTH-1 DOWNTO 0)
  );
end component;

signal Cos_0 : signed(WIDTH-1 downto 0);--  109.375KHz
signal Cos_1 : signed(WIDTH-1 downto 0);--  78.125KHz
signal Cos_2 : signed(WIDTH-1 downto 0);--  46.875KHz
signal Cos_3 : signed(WIDTH-1 downto 0);--  15.625KHz
signal Cos_4 : signed(WIDTH-1 downto 0);-- -15.625KHz
signal Cos_5 : signed(WIDTH-1 downto 0);-- -46.875KHz
signal Cos_6 : signed(WIDTH-1 downto 0);-- -78.125KHz
signal Cos_7 : signed(WIDTH-1 downto 0);-- -109.375KHz

signal Sin_0 : signed(WIDTH-1 downto 0);--  109.375KHz
signal Sin_1 : signed(WIDTH-1 downto 0);--  78.125KHz
signal Sin_2 : signed(WIDTH-1 downto 0);--  46.875KHz
signal Sin_3 : signed(WIDTH-1 downto 0);--  15.625KHz
signal Sin_4 : signed(WIDTH-1 downto 0);-- -15.625KHz
signal Sin_5 : signed(WIDTH-1 downto 0);-- -46.875KHz
signal Sin_6 : signed(WIDTH-1 downto 0);-- -78.125KHz
signal Sin_7 : signed(WIDTH-1 downto 0);-- -109.375KHz

--Signals to summation
signal out_r_0 : signed(WIDTH-1 downto 0);
signal out_i_0 : signed(WIDTH-1 downto 0);
signal out_r_1 : signed(WIDTH-1 downto 0);
signal out_i_1 : signed(WIDTH-1 downto 0);
signal out_r_2 : signed(WIDTH-1 downto 0);
signal out_i_2 : signed(WIDTH-1 downto 0);
signal out_r_3 : signed(WIDTH-1 downto 0);
signal out_i_3 : signed(WIDTH-1 downto 0);
signal out_r_4 : signed(WIDTH-1 downto 0);
signal out_i_4 : signed(WIDTH-1 downto 0);
signal out_r_5 : signed(WIDTH-1 downto 0);
signal out_i_5 : signed(WIDTH-1 downto 0);
signal out_r_6 : signed(WIDTH-1 downto 0);
signal out_i_6 : signed(WIDTH-1 downto 0);
signal out_r_7 : signed(WIDTH-1 downto 0);
signal out_i_7 : signed(WIDTH-1 downto 0);


begin

sin_cos_1: sin_cos_250KHz_up_1
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
       clk_312KHz => clk_312KHz,
       Cos_0 => Cos_0,--  109.375KHz
       Cos_1 => Cos_1,--  78.125KHz
       Cos_2 => Cos_2,--  46.875KHz
       Cos_3 => Cos_3,--  15.625KHz
       Cos_4 => Cos_4,-- -15.625KHz
       Cos_5 => Cos_5,-- -46.875KHz
       Cos_6 => Cos_6,-- -78.125KHz
       Cos_7 => Cos_7,-- -109.375KHz
       Sin_0 => Sin_0,--  109.375KHz
       Sin_1 => Sin_1,--  78.125KHz
       Sin_2 => Sin_2,--  46.875KHz
       Sin_3 => Sin_3,--  15.625KHz
       Sin_4 => Sin_4,-- -15.625KHz
       Sin_5 => Sin_5,-- -46.875KHz
       Sin_6 => Sin_6,-- -78.125KHz
       Sin_7 => Sin_7-- -109.375KHz
      );
         
mult_0: Multiplier
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_312KHz,
    a_r => in_r_0,
    a_i => in_i_0,
    b_r => Cos_0,
    b_i => Sin_0,
    ut_r => out_r_0,
    ut_i => out_i_0
  );
  
mult_1: Multiplier
  GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_312KHz,
    a_r => in_r_1,
    a_i => in_i_1,
    b_r => Cos_1,
    b_i => Sin_1,
    ut_r => out_r_1,
    ut_i => out_i_1
  );

mult_2: Multiplier
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_312KHz,
    a_r => in_r_2,
    a_i => in_i_2,
    b_r => Cos_2,
    b_i => Sin_2,
    ut_r => out_r_2,
    ut_i => out_i_2
  );

mult_3: Multiplier
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_312KHz,
    a_r => in_r_3,
    a_i => in_i_3,
    b_r => Cos_3,
    b_i => Sin_3,
    ut_r => out_r_3,
    ut_i => out_i_3
  );
  
mult_4: Multiplier
  GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_312KHz,
    a_r => in_r_4,
    a_i => in_i_4,
    b_r => Cos_4,
    b_i => Sin_4,
    ut_r => out_r_4,
    ut_i => out_i_4
  );
  
mult_5: Multiplier
  GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_312KHz,
    a_r => in_r_5,
    a_i => in_i_5,
    b_r => Cos_5,
    b_i => Sin_5,
    ut_r => out_r_5,
    ut_i => out_i_5
  );
  
mult_6: Multiplier
  GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_312KHz,
    a_r => in_r_6,
    a_i => in_i_6,
    b_r => Cos_6,
    b_i => Sin_6,
    ut_r => out_r_6,
    ut_i => out_i_6
  );
  
mult_7: Multiplier
  GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_312KHz,
    a_r => in_r_7,
    a_i => in_i_7,
    b_r => Cos_7,
    b_i => Sin_7,
    ut_r => out_r_7,
    ut_i => out_i_7
  );
  
--summation of eight channels into one block
out_r <= out_r_0 + out_r_1 + out_r_2 + out_r_3 + out_r_4 + out_r_5 + out_r_6 + out_r_7;
out_i <= out_i_0 + out_i_1 + out_i_2 + out_i_3 + out_i_4 + out_i_5 + out_i_6 + out_i_7;
  
end Behavioral;
