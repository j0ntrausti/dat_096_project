library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
LIBRARY dds_compiler_v6_0_12;
USE dds_compiler_v6_0_12.dds_compiler_v6_0_12;

entity sin_cos_6MHz is
GENERIC (WIDTH:INTEGER:=10);
Port ( clk_6MHz : in STD_LOGIC;
       Cos_0 : out signed(WIDTH-1 downto 0):= (others => '0'); --1.125MHz
       Cos_1 : out signed(WIDTH-1 downto 0):= (others => '0'); --1.375MHz
       Cos_2 : out signed(WIDTH-1 downto 0):= (others => '0'); --1.625MHz
       Cos_3 : out signed(WIDTH-1 downto 0):= (others => '0'); --1.875MHz
       Sin_0 : out signed(WIDTH-1 downto 0):= (others => '0'); --1.125MHz
       Sin_1 : out signed(WIDTH-1 downto 0):= (others => '0'); --1.375MHz
       Sin_2 : out signed(WIDTH-1 downto 0):= (others => '0'); --1.625MHz
       Sin_3 : out signed(WIDTH-1 downto 0):= (others => '0'));--1.875MHz
end sin_cos_6MHz;

architecture Behavioral of sin_cos_6MHz is

--DDS compiler IP-block, gives all outputs in "m_axis_data_tdata"
--with some padding. Check it in simulation and extract the different channels

--1.125MHz
component dds_0_0    
 PORT (
    aclk : IN STD_LOGIC;
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    --m_axis_phase_tvalid : OUT STD_LOGIC; 
    --m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

--1.375MHz
component dds_1_0
PORT (
    aclk : IN STD_LOGIC;
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    --m_axis_phase_tvalid : OUT STD_LOGIC; 
    --m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

--1.625MHz 
component dds_2_0    
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     --m_axis_phase_tvalid : OUT STD_LOGIC; 
     --m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
end component;

--1.875MHz   
component dds_3_0
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     --m_axis_phase_tvalid : OUT STD_LOGIC; 
     --m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;

--signal angle_0  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_0 : STD_LOGIC;
--signal phase_valid_0 : STD_LOGIC;
signal outs_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);

--signal angle_1  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_1 : STD_LOGIC;
--signal phase_valid_1 : STD_LOGIC;
signal outs_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);

--signal angle_2  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_2 : STD_LOGIC;
--signal phase_valid_2 : STD_LOGIC;
signal outs_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

--signal angle_3  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_3 : STD_LOGIC;
--signal phase_valid_3 : STD_LOGIC;
signal outs_3 : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
DDS_0: dds_0_0 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_0,
         m_axis_data_tdata => outs_0
         --m_axis_phase_tvalid => phase_valid_0,
         --m_axis_phase_tdata => angle_0
         );

DDS_1: dds_1_0 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_1,
         m_axis_data_tdata => outs_1
         --m_axis_phase_tvalid => phase_valid_1,
         --m_axis_phase_tdata => angle_1
         );

DDS_2: dds_2_0 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_2,
         m_axis_data_tdata => outs_2
         --m_axis_phase_tvalid => phase_valid_2,
         --m_axis_phase_tdata => angle_2
         );

DDS_3: dds_3_0 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_3,
         m_axis_data_tdata => outs_3
         --m_axis_phase_tvalid => phase_valid_3,
         --m_axis_phase_tdata => angle_3
         );

--Extract channels THIS IS PROBABLY INCORRECT!!!! 
--edit: now it's maybe more correct
Sin_0 <= signed(outs_0(WIDTH-1 downto 0));
Cos_0 <= signed(outs_0(16+WIDTH-1 downto 16));

Sin_1 <= signed(outs_1(WIDTH-1 downto 0));
Cos_1 <= signed(outs_1(16+WIDTH-1 downto 16));

Sin_2 <= signed(outs_2(WIDTH-1 downto 0));
Cos_2 <= signed(outs_2(16+WIDTH-1 downto 16));

Sin_3 <= signed(outs_3(WIDTH-1 downto 0));
Cos_3 <= signed(outs_3(16+WIDTH-1 downto 16));

end Behavioral;




