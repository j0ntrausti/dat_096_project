library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Mixer_down_2 is
GENERIC (WIDTH:INTEGER:=10);
Port ( clk_250KHz : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r_0 : out signed(WIDTH-1 downto 0);
       out_i_0 : out signed(WIDTH-1 downto 0);
       out_r_1 : out signed(WIDTH-1 downto 0);
       out_i_1 : out signed(WIDTH-1 downto 0);
       out_r_2 : out signed(WIDTH-1 downto 0);
       out_i_2 : out signed(WIDTH-1 downto 0);
       out_r_3 : out signed(WIDTH-1 downto 0);
       out_i_3 : out signed(WIDTH-1 downto 0);
       out_r_4 : out signed(WIDTH-1 downto 0);
       out_i_4 : out signed(WIDTH-1 downto 0);
       out_r_5 : out signed(WIDTH-1 downto 0);
       out_i_5 : out signed(WIDTH-1 downto 0);
       out_r_6 : out signed(WIDTH-1 downto 0);
       out_i_6 : out signed(WIDTH-1 downto 0);
       out_r_7 : out signed(WIDTH-1 downto 0);
       out_i_7 : out signed(WIDTH-1 downto 0)
       );
end Mixer_down_2;

architecture Behavioral of Mixer_down_2 is

--Sin/Cos generation second step
component sin_cos_250KHz    
GENERIC (WIDTH:INTEGER:=10);
PORT ( clk_250KHz : in STD_LOGIC;
       Cos_0 : out signed(WIDTH-1 downto 0); -- -125KHz
       Cos_1 : out signed(WIDTH-1 downto 0); -- -93.75KHz
       Cos_2 : out signed(WIDTH-1 downto 0); -- -62.5KHz
       Cos_3 : out signed(WIDTH-1 downto 0); -- -31.25KHz
       Cos_5 : out signed(WIDTH-1 downto 0); --  31.25KHz
       Cos_6 : out signed(WIDTH-1 downto 0); --  62.5KHz
       Cos_7 : out signed(WIDTH-1 downto 0); --  93.75KHz
       Sin_0 : out signed(WIDTH-1 downto 0); -- -125KHz
       Sin_1 : out signed(WIDTH-1 downto 0); -- -93.75KHz
       Sin_2 : out signed(WIDTH-1 downto 0); -- -62.5KHz
       Sin_3 : out signed(WIDTH-1 downto 0); -- -31.25KHz
       Sin_5 : out signed(WIDTH-1 downto 0); --  31.25KHz
       Sin_6 : out signed(WIDTH-1 downto 0); --  62.5KHz
       Sin_7 : out signed(WIDTH-1 downto 0));--  93.75KHz
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
signal Cos_5 : signed(WIDTH-1 downto 0);
signal Cos_6 : signed(WIDTH-1 downto 0);
signal Cos_7 : signed(WIDTH-1 downto 0);

signal Sin_0 : signed(WIDTH-1 downto 0);
signal Sin_1 : signed(WIDTH-1 downto 0);
signal Sin_2 : signed(WIDTH-1 downto 0);
signal Sin_3 : signed(WIDTH-1 downto 0);
signal Sin_5 : signed(WIDTH-1 downto 0);
signal Sin_6 : signed(WIDTH-1 downto 0);
signal Sin_7 : signed(WIDTH-1 downto 0);


begin

sin_cos_1: sin_cos_250KHz
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
       clk_250KHz => clk_250KHz,
       Cos_0 => Cos_0,
       Cos_1 => Cos_1,
       Cos_2 => Cos_2,
       Cos_3 => Cos_3,
       Cos_5 => Cos_5,
       Cos_6 => Cos_6,
       Cos_7 => Cos_7,
       Sin_0 => Sin_0,
       Sin_1 => Sin_1,
       Sin_2 => Sin_2,
       Sin_3 => Sin_3,
       Sin_5 => Sin_5,
       Sin_6 => Sin_6,
       Sin_7 => Sin_7
      );
         
mult_0: Multiplier
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_250KHz,
    a_r => in_r,
    a_i => in_i,
    b_r => Cos_0,
    b_i => Sin_0,
    ut_r => out_r_0,
    ut_i => out_i_0
  );
  
mult_1: Multiplier
  GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_250KHz,
    a_r => in_r,
    a_i => in_i,
    b_r => Cos_1,
    b_i => Sin_1,
    ut_r => out_r_1,
    ut_i => out_i_1
  );

mult_2: Multiplier
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_250KHz,
    a_r => in_r,
    a_i => in_i,
    b_r => Cos_2,
    b_i => Sin_2,
    ut_r => out_r_2,
    ut_i => out_i_2
  );

mult_3: Multiplier
GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_250KHz,
    a_r => in_r,
    a_i => in_i,
    b_r => Cos_3,
    b_i => Sin_3,
    ut_r => out_r_3,
    ut_i => out_i_3
  );
  
mult_5: Multiplier
  GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_250KHz,
    a_r => in_r,
    a_i => in_i,
    b_r => Cos_5,
    b_i => Sin_5,
    ut_r => out_r_5,
    ut_i => out_i_5
  );
  
mult_6: Multiplier
  GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_250KHz,
    a_r => in_r,
    a_i => in_i,
    b_r => Cos_6,
    b_i => Sin_6,
    ut_r => out_r_6,
    ut_i => out_i_6
  );
  
mult_7: Multiplier
  GENERIC MAP(WIDTH => WIDTH)
PORT MAP (
    clk => clk_250KHz,
    a_r => in_r,
    a_i => in_i,
    b_r => Cos_7,
    b_i => Sin_7,
    ut_r => out_r_7,
    ut_i => out_i_7
  );
  
out_r_4 <= (others=> '0');
out_i_4 <= (others=> '0');
  
end Behavioral;
