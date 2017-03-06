library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
LIBRARY dds_compiler_v6_0_12;
USE dds_compiler_v6_0_12.dds_compiler_v6_0_12;

entity sin_cos_6MHz_up_1 is
GENERIC (WIDTH:INTEGER:=10);
Port ( clk_6MHz : in STD_LOGIC;
       Cos_0 : out signed(WIDTH-1 downto 0); -- 375KHz
       Cos_1 : out signed(WIDTH-1 downto 0); -- 343.75KHz
       Cos_2 : out signed(WIDTH-1 downto 0); -- 312.5KHz
       Cos_3 : out signed(WIDTH-1 downto 0); -- 281.25KHz
       Cos_4 : out signed(WIDTH-1 downto 0); -- 250KHz
       Cos_5 : out signed(WIDTH-1 downto 0); -- 218.75KHz
       Cos_6 : out signed(WIDTH-1 downto 0); -- 187.5KHz
       Cos_7 : out signed(WIDTH-1 downto 0); -- 156.25KHz
       Sin_0 : out signed(WIDTH-1 downto 0); -- 375KHz
       Sin_1 : out signed(WIDTH-1 downto 0); -- 343.75KHz
       Sin_2 : out signed(WIDTH-1 downto 0); -- 312.5KHz
       Sin_3 : out signed(WIDTH-1 downto 0); -- 281.25KHz
	   Sin_4 : out signed(WIDTH-1 downto 0); -- 250KHz
       Sin_5 : out signed(WIDTH-1 downto 0); -- 218.75KHz
       Sin_6 : out signed(WIDTH-1 downto 0); -- 187.5KHz
       Sin_7 : out signed(WIDTH-1 downto 0));-- 156.25KHz
end sin_cos_6MHz_up_1;

architecture Behavioral of sin_cos_6MHz_up_1 is

--DDS compiler IP-block, gives all outputs in "m_axis_data_tdata"
--with some padding. Check it in simulation and extract the different channels

-- 375KHz
component dds_0_2 
 PORT (
    aclk : IN STD_LOGIC;
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_phase_tvalid : OUT STD_LOGIC; 
    m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

-- 343.75KHz
component dds_1_2
PORT (
    aclk : IN STD_LOGIC;
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_phase_tvalid : OUT STD_LOGIC; 
    m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

-- 312.5KHz
component dds_2_2
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
     m_axis_phase_tvalid : OUT STD_LOGIC; 
     m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
end component;

-- 281.25KHz  
component dds_3_2
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
     m_axis_phase_tvalid : OUT STD_LOGIC; 
     m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;

-- 250KHz
component dds_4_2
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
     m_axis_phase_tvalid : OUT STD_LOGIC; 
     m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;

-- 218.75KHz
component dds_5_2
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
     m_axis_phase_tvalid : OUT STD_LOGIC; 
     m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;

-- 187.5KHz
component dds_6_2
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
     m_axis_phase_tvalid : OUT STD_LOGIC; 
     m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;

-- 156.25KHz
component dds_7_2
  PORT (
     aclk : IN STD_LOGIC;
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
     m_axis_phase_tvalid : OUT STD_LOGIC; 
     m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );   
end component;

signal angle_0  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_0 : STD_LOGIC;
signal phase_valid_0 : STD_LOGIC;
signal outs_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal angle_1  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_1 : STD_LOGIC;
signal phase_valid_1 : STD_LOGIC;
signal outs_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal angle_2  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_2 : STD_LOGIC;
signal phase_valid_2 : STD_LOGIC;
signal outs_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal angle_3  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_3 : STD_LOGIC;
signal phase_valid_3 : STD_LOGIC;
signal outs_3 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal angle_4  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_4 : STD_LOGIC;
signal phase_valid_4 : STD_LOGIC;
signal outs_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal angle_5  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_5 : STD_LOGIC;
signal phase_valid_5 : STD_LOGIC;
signal outs_5 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal angle_6  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_6 : STD_LOGIC;
signal phase_valid_6 : STD_LOGIC;
signal outs_6 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal angle_7  : STD_LOGIC_VECTOR(15 downto 0);
signal data_valid_7 : STD_LOGIC;
signal phase_valid_7 : STD_LOGIC;
signal outs_7 : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
DDS_0: dds_0_2 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_0,
         m_axis_data_tdata => outs_0,
         m_axis_phase_tvalid => phase_valid_0,
         m_axis_phase_tdata => angle_0
         );

DDS_1: dds_1_2 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_1,
         m_axis_data_tdata => outs_1,
         m_axis_phase_tvalid => phase_valid_1,
         m_axis_phase_tdata => angle_1
         );

DDS_2: dds_2_2 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_2,
         m_axis_data_tdata => outs_2,
         m_axis_phase_tvalid => phase_valid_2,
         m_axis_phase_tdata => angle_2
         );

DDS_3: dds_3_2 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_3,
         m_axis_data_tdata => outs_3,
         m_axis_phase_tvalid => phase_valid_3,
         m_axis_phase_tdata => angle_3
         );
         
DDS_4: dds_4_2 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_4,
         m_axis_data_tdata => outs_4,
         m_axis_phase_tvalid => phase_valid_4,
         m_axis_phase_tdata => angle_4
         );
         
DDS_5: dds_5_2 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_5,
         m_axis_data_tdata => outs_5,
         m_axis_phase_tvalid => phase_valid_5,
         m_axis_phase_tdata => angle_5
         );

DDS_6: dds_6_2 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_6,
         m_axis_data_tdata => outs_6,
         m_axis_phase_tvalid => phase_valid_6,
         m_axis_phase_tdata => angle_6
         );
         
DDS_7: dds_7_2 PORT MAP (
         aclk => clk_6MHz,
         m_axis_data_tvalid => data_valid_7,
         m_axis_data_tdata => outs_7,
         m_axis_phase_tvalid => phase_valid_7,
         m_axis_phase_tdata => angle_7
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

Sin_4 <= signed(outs_4(WIDTH-1 downto 0));
Cos_4 <= signed(outs_4(16+WIDTH-1 downto 16));

Sin_5 <= signed(outs_5(WIDTH-1 downto 0));
Cos_5 <= signed(outs_5(16+WIDTH-1 downto 16));

Sin_6 <= signed(outs_6(WIDTH-1 downto 0));
Cos_6 <= signed(outs_6(16+WIDTH-1 downto 16));

Sin_7 <= signed(outs_7(WIDTH-1 downto 0));
Cos_7 <= signed(outs_7(16+WIDTH-1 downto 16));

end Behavioral;

