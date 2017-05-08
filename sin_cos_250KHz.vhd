library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
LIBRARY dds_compiler_v6_0_12;
USE dds_compiler_v6_0_12.dds_compiler_v6_0_12;

entity sin_cos_250KHz is
GENERIC (WIDTH:INTEGER:=10);
Port ( clk_250KHz : in STD_LOGIC;
       Cos_0 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -109.375KHz
       Cos_1 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -78.125KHz
       Cos_2 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -46.875KHz
       Cos_3 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -15.625KHz
       Cos_4 : out signed(WIDTH-1 downto 0):= (others => '0'); --  15.625KHz
       Cos_5 : out signed(WIDTH-1 downto 0):= (others => '0'); --  46.875KHz
       Cos_6 : out signed(WIDTH-1 downto 0):= (others => '0'); --  78.125KHz
       Cos_7 : out signed(WIDTH-1 downto 0):= (others => '0'); --  109.375KHz
       Sin_0 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -109.375KHz
       Sin_1 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -78.125KHz
       Sin_2 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -46.875KHz
       Sin_3 : out signed(WIDTH-1 downto 0):= (others => '0'); -- -15.625KHz
       Sin_4 : out signed(WIDTH-1 downto 0):= (others => '0'); --  15.625KHz
       Sin_5 : out signed(WIDTH-1 downto 0):= (others => '0'); --  46.875KHz
       Sin_6 : out signed(WIDTH-1 downto 0):= (others => '0'); --  78.125KHz
       Sin_7 : out signed(WIDTH-1 downto 0):= (others => '0'));--  109.375KHz
end sin_cos_250KHz;

architecture Behavioral of sin_cos_250KHz is



-- 15.625KHz   
component dds_4_1
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     --m_axis_phase_tvalid : OUT STD_LOGIC; 
     --m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;

-- 46.875KHz
component dds_5_1
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     --m_axis_phase_tvalid : OUT STD_LOGIC; 
     --m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;

-- 78.125KHz
component dds_6_1
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     --m_axis_phase_tvalid : OUT STD_LOGIC; 
     --m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;

-- 109.375KHz
component dds_7_1
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     --m_axis_phase_tvalid : OUT STD_LOGIC; 
     --m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;



signal data_valid_4 : STD_LOGIC;
signal outs_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal data_valid_5 : STD_LOGIC;
signal outs_5 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal data_valid_6 : STD_LOGIC;
signal outs_6 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal data_valid_7 : STD_LOGIC;
signal outs_7 : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin

DSS_4: dds_4_1 PORT MAP (
         aclk => clk_250KHz,
         m_axis_data_tvalid => data_valid_4,
         m_axis_data_tdata => outs_4
         -- m_axis_phase_tvalid => phase_valid_4,
         --m_axis_phase_tdata => angle_4
         );
         
DDS_5: dds_5_1 PORT MAP (
         aclk => clk_250KHz,
         m_axis_data_tvalid => data_valid_5,
         m_axis_data_tdata => outs_5
         --m_axis_phase_tvalid => phase_valid_5,
         --m_axis_phase_tdata => angle_5
         );

DDS_6: dds_6_1 PORT MAP (
         aclk => clk_250KHz,
         m_axis_data_tvalid => data_valid_6,
         m_axis_data_tdata => outs_6
         --m_axis_phase_tvalid => phase_valid_6,
         --m_axis_phase_tdata => angle_6
         );
         
DDS_7: dds_7_1 PORT MAP (
         aclk => clk_250KHz,
         m_axis_data_tvalid => data_valid_7,
         m_axis_data_tdata => outs_7
         --m_axis_phase_tvalid => phase_valid_7,
         --m_axis_phase_tdata => angle_7
         );      

--take signals from dds_7
Cos_0 <= not signed(outs_7(WIDTH-1 downto 0)) + 1; --invert to negative
Sin_0 <= signed(outs_7(16+WIDTH-1 downto 16));

--take signals from dds_6
Cos_1 <= not signed(outs_6(WIDTH-1 downto 0)) + 1;--invert to negative
Sin_1 <= signed(outs_6(16+WIDTH-1 downto 16));

--take signals from dds_5
Cos_2 <= not signed(outs_5(WIDTH-1 downto 0)) + 1;--invert to negative
Sin_2 <= signed(outs_5(16+WIDTH-1 downto 16));

--take signals from dds_4
Cos_3 <= not signed(outs_4(WIDTH-1 downto 0)) + 1;--invert to negative
Sin_3 <= signed(outs_4(16+WIDTH-1 downto 16));

Cos_4 <= signed(outs_4(WIDTH-1 downto 0));
Sin_4 <= signed(outs_4(16+WIDTH-1 downto 16));

Cos_5 <= signed(outs_5(WIDTH-1 downto 0));
Sin_5 <= signed(outs_5(16+WIDTH-1 downto 16));

Cos_6 <= signed(outs_6(WIDTH-1 downto 0));
Sin_6 <= signed(outs_6(16+WIDTH-1 downto 16));

Cos_7 <= signed(outs_7(WIDTH-1 downto 0));
Sin_7 <= signed(outs_7(16+WIDTH-1 downto 16));

end Behavioral;

