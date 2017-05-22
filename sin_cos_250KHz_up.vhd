library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
LIBRARY dds_compiler_v6_0_12;
USE dds_compiler_v6_0_12.dds_compiler_v6_0_12;

entity sin_cos_250KHz_up_1 is
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
end sin_cos_250KHz_up_1;

architecture Behavioral of sin_cos_250KHz_up_1 is

--DDS compiler IP-block, gives all outputs in "m_axis_data_tdata"
--with some padding. Check it in simulation and extract the different channels

--  109.375KHz
component dds_0_2 
 PORT (
    aclk : IN STD_LOGIC;
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0));
end component;

--  78.125KHz
component dds_1_2
PORT (
    aclk : IN STD_LOGIC;
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0));
end component;

--  46.875KHz
component dds_2_2
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0));
end component;

--  15.625KHz
component dds_3_2
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0));   
end component;

signal data_valid_0 : STD_LOGIC;
signal outs_0 : STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);

signal data_valid_1 : STD_LOGIC;
signal outs_1 : STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);

signal data_valid_2 : STD_LOGIC;
signal outs_2 : STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);

signal data_valid_3 : STD_LOGIC;
signal outs_3 : STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);

begin
DDS_0: dds_0_2 PORT MAP (
         aclk => clk_312KHz,
         m_axis_data_tvalid => data_valid_0,
         m_axis_data_tdata => outs_0);

DDS_1: dds_1_2 PORT MAP (
         aclk => clk_312KHz,
         m_axis_data_tvalid => data_valid_1,
         m_axis_data_tdata => outs_1);

DDS_2: dds_2_2 PORT MAP (
         aclk => clk_312KHz,
         m_axis_data_tvalid => data_valid_2,
         m_axis_data_tdata => outs_2);

DDS_3: dds_3_2 PORT MAP (
         aclk => clk_312KHz,
         m_axis_data_tvalid => data_valid_3,
         m_axis_data_tdata => outs_3);
         
--Signal extraction
Cos_0 <= signed(outs_0(WIDTH-1 downto 0)); 
Sin_0 <= signed(outs_0(2*WIDTH-1 downto WIDTH));

Cos_1 <= signed(outs_1(WIDTH-1 downto 0));
Sin_1 <= signed(outs_1(2*WIDTH-1 downto WIDTH));

Cos_2 <= signed(outs_2(WIDTH-1 downto 0));
Sin_2 <= signed(outs_2(2*WIDTH-1 downto WIDTH));

Cos_3 <= signed(outs_3(WIDTH-1 downto 0));
Sin_3 <= signed(outs_3(2*WIDTH-1 downto WIDTH));

--extract and convert frequencies to "negative"
Cos_4 <= signed(outs_3(WIDTH-1 downto 0));
Sin_4 <= not signed(outs_3(2*WIDTH-1 downto WIDTH)) + 1;

Cos_5 <= signed(outs_2(WIDTH-1 downto 0));
Sin_5 <= not signed(outs_2(2*WIDTH-1 downto WIDTH)) + 1;

Cos_6 <= signed(outs_1(WIDTH-1 downto 0));
Sin_6 <= not signed(outs_1(2*WIDTH-1 downto WIDTH)) + 1;

Cos_7 <= signed(outs_0(WIDTH-1 downto 0));
Sin_7 <= not signed(outs_0(2*WIDTH-1 downto WIDTH)) + 1;

end Behavioral;