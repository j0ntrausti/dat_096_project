library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Mixer_up_2 is
GENERIC (WIDTH:INTEGER:=10);
Port ( clk_4MHz : in STD_LOGIC;
       in_r_0 : in signed(WIDTH-1 downto 0);
       in_i_0 : in signed(WIDTH-1 downto 0);
       in_r_1 : in signed(WIDTH-1 downto 0);
       in_i_1 : in signed(WIDTH-1 downto 0);
       in_r_2 : in signed(WIDTH-1 downto 0);
       in_i_2 : in signed(WIDTH-1 downto 0);
       in_r_3 : in signed(WIDTH-1 downto 0);
       in_i_3 : in signed(WIDTH-1 downto 0);
       out_r : out signed(WIDTH-1 downto 0);
       out_i : out signed(WIDTH-1 downto 0)
       );
end Mixer_up_2;

architecture Behavioral of Mixer_up_2 is
--Sin/Cos generation first step

component sin_cos_4MHz_up  
GENERIC (WIDTH:INTEGER:=10);
PORT ( clk_4MHz : in STD_LOGIC;
       Cos_0 : out signed(WIDTH-1 downto 0); -- 875KHz
       Cos_1 : out signed(WIDTH-1 downto 0); -- 1.125KHz
       Cos_2 : out signed(WIDTH-1 downto 0); -- 1.375MHz
       Cos_3 : out signed(WIDTH-1 downto 0); -- 1.625MHz
       Sin_0 : out signed(WIDTH-1 downto 0); -- 875KHz
       Sin_1 : out signed(WIDTH-1 downto 0); -- 1.125MHz
       Sin_2 : out signed(WIDTH-1 downto 0); -- 1.375MHz
       Sin_3 : out signed(WIDTH-1 downto 0));-- 1.625MHz
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

signal Cos_0 : signed(WIDTH-1 downto 0);
signal Cos_1 : signed(WIDTH-1 downto 0);
signal Cos_2 : signed(WIDTH-1 downto 0);
signal Cos_3 : signed(WIDTH-1 downto 0);
signal Sin_0 : signed(WIDTH-1 downto 0);
signal Sin_1 : signed(WIDTH-1 downto 0);
signal Sin_2 : signed(WIDTH-1 downto 0);
signal Sin_3 : signed(WIDTH-1 downto 0);

signal out_r_0 : signed(WIDTH-1 downto 0);
signal out_i_0 : signed(WIDTH-1 downto 0);
signal out_r_1 : signed(WIDTH-1 downto 0);
signal out_i_1 : signed(WIDTH-1 downto 0);
signal out_r_2 : signed(WIDTH-1 downto 0);
signal out_i_2 : signed(WIDTH-1 downto 0);
signal out_r_3 : signed(WIDTH-1 downto 0);
signal out_i_3 : signed(WIDTH-1 downto 0);


begin

sin_cos_1: sin_cos_4MHz_up
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
       clk_4MHz => clk_4MHz,
       Cos_0 => Cos_0,
       Cos_1 => Cos_1,
       Cos_2 => Cos_2,
       Cos_3 => Cos_3,
       Sin_0 => Sin_0,
       Sin_1 => Sin_1,
       Sin_2 => Sin_2,
       Sin_3 => Sin_3
      );
         
mult_0: Multiplier
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_4MHz,
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
    clk => clk_4MHz,
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
    clk => clk_4MHz,
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
    clk => clk_4MHz,
    a_r => in_r_3,
    a_i => in_i_3,
    b_r => Cos_3,
    b_i => Sin_3,
    ut_r => out_r_3,
    ut_i => out_i_3
  );
  
 out_r <= out_r_0 + out_r_1 + out_r_2 + out_r_3;
 out_i <= out_i_0 + out_i_1 + out_i_2 + out_i_3;
 
end Behavioral;
