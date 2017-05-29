library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.Read_package.all; -- Package with array type declaration and read functions

entity top_level is
GENERIC (WIDTH:INTEGER:=16);
PORT ( clk_100MHz 	: in STD_LOGIC;
	   reset 		: in STD_LOGIC:= '0';
       Switches 	: in STD_LOGIC_VECTOR(15 downto 0):=(others => '0'); --Switches on FPGA board
       LED			: out STD_LOGIC_VECTOR(14 downto 0); -- LEDS on FPGA board
       DUMMY_0      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)); -- dummy output to make Vivado not optimize away the design during testing synthesis
end top_level;

architecture Behavioral of top_level is

---------------------------------------------------------------------------------------------
------------------------------------------COMPONENT------------------------------------------
----------------------------------------DECLARATIONS-----------------------------------------
---------------------------------------------------------------------------------------------

--Clock enable
component clk_enable_generic
GENERIC (N:integer); --division factor
PORT  ( clk 		: in STD_LOGIC;
        reset		: in STD_LOGIC;
        clk_enable	: out STD_LOGIC);
end component;

--ADC
--at the moment only a testVECTOR "player"
component ADC    
GENERIC (WIDTH:INTEGER:=WIDTH);
PORT ( clk_5MHz : in STD_LOGIC;
       reset 	: in STD_LOGIC;
       adc_out 	: out STD_LOGIC_VECTOR(WIDTH-1 downto 0));
end component;

--First mixer down step
--capability for four blocks but only block 0 is used
--mixes carrier signal down to block level
component Mixer_down_1    
GENERIC (WIDTH:INTEGER:=WIDTH);
PORT ( clk_5MHz : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0); -- real input (carrier level)
       out_r_0 : out signed(WIDTH-1 downto 0); -- block 0 real output
       out_i_0 : out signed(WIDTH-1 downto 0); -- block 0 imaginary output
       out_r_1 : out signed(WIDTH-1 downto 0); -- block 1 real output
       out_i_1 : out signed(WIDTH-1 downto 0); -- block 1 imaginary output
       out_r_2 : out signed(WIDTH-1 downto 0); -- block 2 real output
       out_i_2 : out signed(WIDTH-1 downto 0); -- block 2 imaginary output
       out_r_3 : out signed(WIDTH-1 downto 0); -- block 3 real output
       out_i_3 : out signed(WIDTH-1 downto 0));-- block 3 imaginary output
end component;

--Second mixer down step
--mixes a block down to channel level, instansiate one per block used
component Mixer_down_2   
GENERIC (WIDTH:INTEGER:=WIDTH);
PORT ( clk_312KHz : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0); -- real input (block level)
       in_i : in signed(WIDTH-1 downto 0); -- imaginary input (block level)
       out_r_0 : out signed(WIDTH-1 downto 0); -- channel 0 real output
       out_i_0 : out signed(WIDTH-1 downto 0); -- channel 0 imaginary output
       out_r_1 : out signed(WIDTH-1 downto 0); -- channel 1 real output
       out_i_1 : out signed(WIDTH-1 downto 0); -- channel 1 imaginary output
       out_r_2 : out signed(WIDTH-1 downto 0); -- channel 2 real output
       out_i_2 : out signed(WIDTH-1 downto 0); -- channel 2 imaginary output
       out_r_3 : out signed(WIDTH-1 downto 0); -- channel 3 real output
       out_i_3 : out signed(WIDTH-1 downto 0); -- channel 3 imaginary output
       out_r_4 : out signed(WIDTH-1 downto 0); -- channel 4 real output
       out_i_4 : out signed(WIDTH-1 downto 0); -- channel 4 imaginary output
       out_r_5 : out signed(WIDTH-1 downto 0); -- channel 5 real output
       out_i_5 : out signed(WIDTH-1 downto 0); -- channel 5 imaginary output
       out_r_6 : out signed(WIDTH-1 downto 0); -- channel 6 real output
       out_i_6 : out signed(WIDTH-1 downto 0); -- channel 6 imaginary output
       out_r_7 : out signed(WIDTH-1 downto 0); -- channel 7 real output
       out_i_7 : out signed(WIDTH-1 downto 0));-- channel 7 imaginary output
end component;

--First mixer up step
--mixes eight channels up into one block, instansiate one per block used
component Mixer_up_1   
GENERIC (WIDTH:INTEGER:=WIDTH);
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
end component;

--Second mixer up step
--mixes four blocks up to carrier level
component Mixer_up_2    
GENERIC (WIDTH:INTEGER:=WIDTH);
PORT ( clk_5MHz : in STD_LOGIC;
        in_r_0 : in signed(WIDTH-1 downto 0); -- block 0 real input
        in_i_0 : in signed(WIDTH-1 downto 0); -- block 0 imaginary input
        in_r_1 : in signed(WIDTH-1 downto 0); -- block 1 real input
        in_i_1 : in signed(WIDTH-1 downto 0); -- block 1 imaginary input
        in_r_2 : in signed(WIDTH-1 downto 0); -- block 2 real input
        in_i_2 : in signed(WIDTH-1 downto 0); -- block 2 imaginary input
        in_r_3 : in signed(WIDTH-1 downto 0); -- block 3 real input
        in_i_3 : in signed(WIDTH-1 downto 0); -- block 3 imaginary input
        out_r : out signed(WIDTH-1 downto 0); -- real output (carrier level)
        out_i : out signed(WIDTH-1 downto 0));-- imaginary output (carrier level), not used.
end component;

--DEC_1_625k
--first decimation/filter stage (block level)
--takes sampling frequency of one block from 5MHz down to 625KHz, a decimation factory by four
component DEC_1_625
GENERIC (WIDTH:INTEGER:=WIDTH);
PORT ( clk_100MHz : in STD_LOGIC; -- calculating frequency
       clk_5MHz : in STD_LOGIC;   -- input sampling frequency
       clk_625KHz : in STD_LOGIC; -- output sampling frequency
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);   -- real input
       in_i : in signed(WIDTH-1 downto 0);   -- imaginary input
       out_r : out signed(WIDTH-1 downto 0); -- real output
       out_i : out signed(WIDTH-1 downto 0));-- imaginary output
end component;

--DEC_1_312.5k
--second decimation/filter stage (block level)
--takes sampling frequency of one block from 625MHz down to 312.5KHz, a decimation factory by two
component DEC_1_312
GENERIC (WIDTH:INTEGER:=WIDTH);
PORT ( clk_100MHz : in STD_LOGIC; -- calculating frequency
       clk_625KHz : in STD_LOGIC; -- input sampling frequency
       clk_312KHz : in STD_LOGIC; -- output sampling frequency
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);   -- real input
       in_i : in signed(WIDTH-1 downto 0);   -- imaginary input
       out_r : out signed(WIDTH-1 downto 0); -- real input
       out_i : out signed(WIDTH-1 downto 0));-- imaginary output
end component;

--DEC_2_31k
--third decimation/filter stage (channel level)
--takes sampling frequency of eigth channels from 312.5Khz down to 31.25Khz, a decimation factor by ten
component DEC_2
GENERIC (WIDTH:INTEGER:=WIDTH);
PORT ( clk_100MHz : in STD_LOGIC; -- calculating frecuency
	   clk_312KHz : in STD_LOGIC; -- input sampling frequency
       clk_31KHz : in STD_LOGIC;  -- output sampling frequency
       reset : in STD_LOGIC;
       in_channels : in Channels;   -- input of 8 channels, real and imaginary(16x 12bit signed VECTOR array)
       out_channels : out Channels);-- output of 8 channels, real and imaginary(16x 12bit signed VECTOR array)
end component;

--IPOL_1
--first interpolation/filter stage (channel level)
--takes sampling frequency of eight channels from 31.25Khz up to 312.5Khz, an interpolation factor by ten
component IPOL_1
GENERIC(WIDTH:integer:=WIDTH);
PORT(   clk_100MHz: in STD_LOGIC;  -- calculating frequency
        clk_312KHz: in STD_LOGIC;  -- output sampling frequency
        clk_31Khz: in STD_LOGIC;   -- input sampling frequency
        reset: in STD_LOGIC;    
        input: in Channels;   -- input of 8 channels, real and imaginary(16x 12bit signed VECTOR array)
        output: out Channels);-- output of 8 channels, real and imaginary(16x 12bit signed VECTOR array)
end component;


--IPOL_2
--second interplation/filter stage (block level)
--takes sampling frequency of one block from 312.5KHz up to 625KHz, an interpolation factor by two
component IPOL_2
GENERIC(WIDTH:integer:=WIDTH);
PORT(   clk_100MHz: in STD_LOGIC; -- calculating frequency
        clk_312KHz: in STD_LOGIC; -- input sampling frequency
        clk_625KHz: in STD_LOGIC; -- output sampling frequency
        reset: in STD_LOGIC;
        input_r: in Signed;   -- real input
        input_i: in Signed;   -- imaginary input
        output_r: out Signed; -- real output
        output_i: out Signed);-- imaginary output
end component;

--IPOL_3
--third interpolation/filter stage (block level)
--takes sampling frequency of one block from 625KHz up to 5MHz, an interpolation factor by four
component IPOL_3
GENERIC(WIDTH:integer:=WIDTH);
PORT(clk_100MHz: in STD_LOGIC; -- calculating frequency
    clk_625KHz: in STD_LOGIC;  -- input sampling frequency
    clk_5MHz: in STD_LOGIC;    -- output sampling frequency
    reset: in STD_LOGIC;
    input_r: in Signed;    -- real input
    input_i: in Signed;    -- imaginary input
    output_r: out Signed;  -- real output
    output_i: out Signed); -- imaginary output
end component;  
      
---------------------------------------------------------------------------------------------
-------------------------------------------SIGNAL--------------------------------------------
----------------------------------------DECLARATIONS-----------------------------------------
---------------------------------------------------------------------------------------------

--Clocks
signal clk_5MHz : STD_LOGIC :='0';
signal clk_625KHz : STD_LOGIC :='0';
signal clk_312KHz : STD_LOGIC :='0';
signal clk_31KHz : STD_LOGIC :='0';

-----------------------------------VVVV SIGNAL PATH VVVV--------------------------------------

--signal declaration here follow the signal path line by line
--comments are inserted for where different components are

--ADC component
signal adc_out : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
--First down mixer component (Mixer_down_1)
signal blocks_undec: Blocks;    --2D array
--First decimation stage (DEC_1_625)
signal blocks_dec_1: Blocks;    --2D array
--Second decimation stage (DEC_1_312)
signal blocks_dec_2: Blocks;    --2D array
--Second down mixer component (Mixer_down_2)
signal signals_undec: Signals;  --3D array
--Third decimation stage (DEC_2)
signal signals_dec: Signals;    --3D array
--Redirect should go here
signal signals_unpol: Signals;  --3D array
--First interpolation stage (IPOL_1)
signal signals_pol: Signals;    --3D array
--First up mixer component (Mixer_up_1)
signal blocks_unpol: Blocks;    --2D array
--Second interpolation stage (IPOL_2)
signal blocks_pol_1: Blocks;    --2D array
--Third interpolation stage (IPOL_3)
signal blocks_pol_2: Blocks;    --2D array
--Second up mixer component (Mixer_up_2)
signal dac_in_r : signed(WIDTH-1 downto 0);
signal dac_in_i : signed(WIDTH-1 downto 0);
--Dac component should go here

begin

---------------------------------------------------------------------------------------------
--------------------------------------------PORT---------------------------------------------
------------------------------------------MAPPINGS-------------------------------------------
---------------------------------------------------------------------------------------------

--Port mappings follow signal path

--Clock Enables
clk_en_5MHz: clk_enable_generic 
GENERIC MAP(N => 20)
PORT MAP (  clk => clk_100MHz,
            reset => reset,
            clk_enable => clk_5MHz);

clk_en_625KHz: clk_enable_generic 
GENERIC MAP(N => 160) 
PORT MAP (  clk => clk_100MHz,
            reset => reset,
            clk_enable => clk_625KHz);

clk_en_312KHz: clk_enable_generic 
GENERIC MAP(N => 320) 
PORT MAP (  clk => clk_100MHz,
            reset => reset,
            clk_enable => clk_312KHz);
  
clk_en_31KHz: clk_enable_generic
GENERIC MAP(N => 3200)
PORT MAP (  clk => clk_100MHz,
            reset => reset,
            clk_enable => clk_31KHz);
         
--ADC
ADC_cmp: ADC    
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
	clk_5MHz => clk_5MHz,
	reset => reset,
	adc_out => adc_out);

--Mixer_down_1
Mixer_dnw_1: Mixer_down_1    
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
	clk_5MHz => clk_5MHz,
	in_r => signed(adc_out),
	out_r_0 => blocks_undec(0),
	out_i_0 => blocks_undec(1),
	out_r_1 => blocks_undec(2),
	out_i_1 => blocks_undec(3),
	out_r_2 => blocks_undec(4),
	out_i_2 => blocks_undec(5),
	out_r_3 => blocks_undec(6),
	out_i_3 => blocks_undec(7));

--DEC_1_500_block_0
DEC_1_625_block_0: DEC_1_625
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_100MHz => clk_100MHz,
    clk_5MHz => clk_5MHz,
	clk_625KHz => clk_625KHz,
	reset => reset,
	in_r => blocks_undec(0),
	in_i => blocks_undec(1),
	out_r => blocks_dec_1(0),
	out_i => blocks_dec_1(1));

--DEC_1_250_block_0
DEC_1_312_block_0: DEC_1_312
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_100MHz => clk_100MHz,
    clk_625KHz => clk_625KHz,
    clk_312KHz => clk_312KHz,
    reset => reset,
    in_r => blocks_dec_1(0),
    in_i => blocks_dec_1(1),
    out_r => blocks_dec_2(0),
    out_i => blocks_dec_2(1));
                

Mixer_dnw_2_block_0: Mixer_down_2    
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_312KHz => clk_312KHz,
	in_r => blocks_dec_2(0),
	in_i => blocks_dec_2(1),
	out_r_0 => signals_undec(0)(0),
	out_i_0 => signals_undec(0)(1),
	out_r_1 => signals_undec(0)(2),
	out_i_1 => signals_undec(0)(3),
	out_r_2 => signals_undec(0)(4),
	out_i_2 => signals_undec(0)(5),
	out_r_3 => signals_undec(0)(6),
	out_i_3 => signals_undec(0)(7),
	out_r_4 => signals_undec(0)(8),
	out_i_4 => signals_undec(0)(9),
	out_r_5 => signals_undec(0)(10),
	out_i_5 => signals_undec(0)(11),
	out_r_6 => signals_undec(0)(12),
	out_i_6 => signals_undec(0)(13),
	out_r_7 => signals_undec(0)(14),
	out_i_7 => signals_undec(0)(15));

--DEC_1_block_0
DEC_2_block_0: DEC_2
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_100MHz => clk_100MHz,
    clk_312KHz => clk_312KHz,
    clk_31KHz => clk_31KHz,
	reset => reset,
	in_channels => signals_undec(0),
	out_channels => signals_dec(0));
	

--Redirect (doesn't exist yet)
signals_unpol <= signals_dec;

--First interpolator stage
IPOL_1_312: IPOL_1
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_100MHz => clk_100MHz,
    clk_312KHz => clk_312KHz,
    clk_31KHz => clk_31KHz,
    reset => reset,
    input => signals_unpol(0),
    output => signals_pol(0));

    
--first mixer up block_0       
Mixer_up_1_block_0: Mixer_up_1    
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_312KHz => clk_312KHz,
    in_r_0 => signals_pol(0)(0),
    in_i_0 => signals_pol(0)(1),
    in_r_1 => signals_pol(0)(2),
    in_i_1 => signals_pol(0)(3),
    in_r_2 => signals_pol(0)(4),
    in_i_2 => signals_pol(0)(5),
    in_r_3 => signals_pol(0)(6),
    in_i_3 => signals_pol(0)(7),
    in_r_4 => signals_pol(0)(8),
    in_i_4 => signals_pol(0)(9),
    in_r_5 => signals_pol(0)(10),
    in_i_5 => signals_pol(0)(11),
    in_r_6 => signals_pol(0)(12),
    in_i_6 => signals_pol(0)(13),
    in_r_7 => signals_pol(0)(14),
    in_i_7 => signals_pol(0)(15),
    out_r => blocks_unpol(0),
    out_i => blocks_unpol(1));
            
IPOL_2_625: IPOL_2
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_100MHz => clk_100MHz,
    clk_625KHz => clk_625KHz,
    clk_312KHz => clk_312KHz,
    reset => reset,
    input_r => Blocks_unpol(0),
    input_i => Blocks_unpol(1),
    output_r => Blocks_pol_1(0),
    output_i => Blocks_pol_1(1)
    );
            
IPOL_3_5M: IPOL_3
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_100MHz => clk_100MHz,
    clk_5MHz => clk_5MHz,
    clk_625KHz => clk_625KHz,
    reset => reset,
    input_r => Blocks_pol_1(0),
    input_i => Blocks_pol_1(1),
    output_r => Blocks_pol_2(0),
    output_i => Blocks_pol_2(1)
    );

--Second mixer up block
Mixer_up_2_block_0: Mixer_up_2    
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_5MHz => clk_5MHz,
    in_r_0 => blocks_pol_2(0),
    in_i_0 => blocks_pol_2(1),
    in_r_1 => blocks_pol_2(2),
    in_i_1 => blocks_pol_2(3),
    in_r_2 => blocks_pol_2(4),
    in_i_2 => blocks_pol_2(5),
    in_r_3 => blocks_pol_2(6),
    in_i_3 => blocks_pol_2(7),
    out_r => dac_in_r,
    out_i => dac_in_i
    );
    
DUMMY_0 <= STD_LOGIC_VECTOR(dac_in_r);

end Behavioral;