library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.Read_package.all;

entity top_level is
GENERIC (WIDTH:INTEGER:=12);
Port ( clk_100MHz 	: in STD_LOGIC;
       clk_uber     : in STD_LOGIC;
	   reset 		: in STD_LOGIC:= '0';
       Switches 	: in STD_LOGIC_VECTOR(11 downto 0):=(others => '0');
       LED			: out STD_LOGIC_VECTOR(14 downto 0);
       DUMMY_0      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0));
end top_level;

architecture Behavioral of top_level is

--COMPONENT DECLARATIONS
--Clock enable
component clk_enable_generic
GENERIC (N:integer); --how fast should the clock be.
Port  (	clk 		: in STD_LOGIC;
		    reset		: in STD_LOGIC;
		    --end_clk		: out STD_LOGIC;
		    clk_enable	: out STD_LOGIC
		    );
end component;

--ADC
component ADC    
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_4MHz : in STD_LOGIC;
       reset 	: in STD_LOGIC;
       adc_out 	: out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
       );
end component;

--First mixer down step
component Mixer_down_1    
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_4MHz : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r_0 : out signed(WIDTH-1 downto 0);
       out_i_0 : out signed(WIDTH-1 downto 0);
       out_r_1 : out signed(WIDTH-1 downto 0);
       out_i_1 : out signed(WIDTH-1 downto 0);
       out_r_2 : out signed(WIDTH-1 downto 0);
       out_i_2 : out signed(WIDTH-1 downto 0);
       out_r_3 : out signed(WIDTH-1 downto 0);
       out_i_3 : out signed(WIDTH-1 downto 0)
       );
end component;

--Second mixer down step
component Mixer_down_2   
GENERIC (WIDTH:INTEGER:=WIDTH);
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
end component;

--First mixer up step
component Mixer_up_1   
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_4MHz : in STD_LOGIC;
        in_r_0 : in signed(WIDTH-1 downto 0);
        in_i_0 : in signed(WIDTH-1 downto 0);
        in_r_1 : in signed(WIDTH-1 downto 0);
        in_i_1 : in signed(WIDTH-1 downto 0);
        in_r_2 : in signed(WIDTH-1 downto 0);
        in_i_2 : in signed(WIDTH-1 downto 0);
        in_r_3 : in signed(WIDTH-1 downto 0);
        in_i_3 : in signed(WIDTH-1 downto 0);
        in_r_4 : in signed(WIDTH-1 downto 0);
        in_i_4 : in signed(WIDTH-1 downto 0);
        in_r_5 : in signed(WIDTH-1 downto 0);
        in_i_5 : in signed(WIDTH-1 downto 0);
        in_r_6 : in signed(WIDTH-1 downto 0);
        in_i_6 : in signed(WIDTH-1 downto 0);
        in_r_7 : in signed(WIDTH-1 downto 0);
        in_i_7 : in signed(WIDTH-1 downto 0);
        out_r : out signed(WIDTH-1 downto 0);
        out_i : out signed(WIDTH-1 downto 0)
       );
end component;

--Second mixer up step
component Mixer_up_2    
GENERIC (WIDTH:INTEGER:=WIDTH);
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
end component;

--DEC_1_500k
component DEC_1_500
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_100MHz : in STD_LOGIC;
       clk_4MHz : in STD_LOGIC;
       clk_500KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r : out signed(WIDTH-1 downto 0);
       out_i : out signed(WIDTH-1 downto 0)
       );
end component;

--DEC_1_250k
component DEC_1_250
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_100MHz : in STD_LOGIC;
       clk_4MHz : in STD_LOGIC;
       clk_250KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r : out signed(WIDTH-1 downto 0);
       out_i : out signed(WIDTH-1 downto 0)
       );
end component;

--DEC_2_31k
component DEC_2
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_100MHz : in STD_LOGIC;
	   clk_250KHz : in STD_LOGIC;
       clk_31KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_channels : in Channels;
       out_channels : out Channels
       );
end component;

--IPOL_1
component IPOL_1
GENERIC(WIDTH:integer:=WIDTH);
PORT(Clk_100MHz: in std_logic;
    Clk_250Khz: in STD_LOGIC;
    reset: in std_logic;    
    input: in Channels;
    output: out Channels
    );
end component;


--IPOL_2
component IPOL_2
GENERIC(WIDTH:integer:=WIDTH);
PORT(Clk_100MHz: in std_logic;
    Clk_500Khz: in std_logic;
    reset: in std_logic;
    input_r: in Signed;
    input_i: in Signed;
    output_r: out Signed;
    output_i: out Signed);
end component;

--IPOL_2
component IPOL_3
GENERIC(WIDTH:integer:=WIDTH);
PORT(Clk_100MHz: in std_logic;
    Clk_4Mhz: in STD_LOGIC;
    reset: in std_logic;
    input_r: in Signed;
    input_i: in Signed;
    output_r: out Signed;
    output_i: out Signed);
end component;


        

--SIGNAL DECLARATIONS
--Clocks
--signal clk_uber : std_logic :='0';
signal clk_4MHz : std_logic :='0';
signal clk_500KHz : std_logic :='0';
signal clk_250KHz : std_logic :='0';
signal clk_31KHz : std_logic :='0';

---VVVV SIGNAL PATH VVVV----
--ADC component
signal adc_out : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
--mixer_down_1
signal blocks_undec: Blocks; 		--2D array
--DEC_1_500
signal blocks_dec_1: Blocks; 			--2D array
--DEC_1_250
signal blocks_dec_2: Blocks; 			--2D array
--Mixer_down_2
signal signals_undec: Signals; 		--3D array
--DEC_2
signal signals_dec: Signals; 		--3D array
--Redirect
signal signals_unpol: Signals; --3D array
--IPOL_1
signal signals_pol: Signals; --3D array
--Mixer_up_1
signal blocks_unpol: Blocks; 		--2D array
--IPOL_2
signal blocks_pol_1: Blocks; 			--2D array
--IPOL_3
signal blocks_pol_2: Blocks; 			--2D array

--To dac
signal dac_in_r : signed(WIDTH-1 downto 0);
signal dac_in_i : signed(WIDTH-1 downto 0);


--DAC component

begin

--Clock Enables
--4MHz ACTUALLY 5MHz
Clk_en_4MHz: clk_enable_generic 
GENERIC MAP(N => 20)
PORT MAP (
    clk => clk_100MHz,
    reset => reset,
    clk_enable => clk_4MHz);

--500KHz ACTUALLY 625KHz!
Clk_en_500KHz: clk_enable_generic 
    GENERIC MAP(N => 160) 
    PORT MAP (
        clk => clk_100MHz,
        reset => reset,
        clk_enable => clk_500KHz);

--250KHz ACTUALLY 312.5KHz
Clk_en_250KHz: clk_enable_generic 
GENERIC MAP(N => 320) 
PORT MAP (
    clk => clk_100MHz,
    reset => reset,
    clk_enable => clk_250KHz);

--31.5k     
Clk_en_31KHz: clk_enable_generic 
GENERIC MAP(N => 3200)
PORT MAP (
    clk => clk_100MHz,
    reset => reset,
    clk_enable => clk_31KHz);
         
--ADC
ADC_cmp: ADC    
--GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
	clk_4MHz => clk_4MHz,
	reset => reset,
	adc_out => adc_out);

--Mixer_down_1
Mixer_dnw_1: Mixer_down_1    
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
	clk_4MHz => clk_4MHz,
	in_r => signed(Switches),
	in_i => (others=> '0'),
	out_r_0 => blocks_undec(0),
	out_i_0 => blocks_undec(1),
	out_r_1 => blocks_undec(2),
	out_i_1 => blocks_undec(3),
	out_r_2 => blocks_undec(4),
	out_i_2 => blocks_undec(5),
	out_r_3 => blocks_undec(6),
	out_i_3 => blocks_undec(7));

--DEC_1_500_block_0
DEC_1_500_block_0: DEC_1_500
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_100MHz => clk_100MHz,
    clk_4MHz => clk_4MHz,
	clk_500KHz => clk_500KHz,
	reset => reset,
	in_r => blocks_undec(0),
	in_i => blocks_undec(1),
	out_r => blocks_dec_1(0),
	out_i => blocks_dec_1(1));

--DEC_1_250_block_0
DEC_1_250_block_0: DEC_1_250
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_100MHz => clk_100MHz,
    clk_4MHz => clk_4MHz,
    clk_250KHz => clk_250KHz,
    reset => reset,
    in_r => blocks_dec_1(0),
    in_i => blocks_dec_1(1),
    out_r => blocks_dec_2(0),
    out_i => blocks_dec_2(1));
                

Mixer_dnw_2_block_0: Mixer_down_2    
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_250KHz => clk_250KHz,
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
    clk_250KHz => clk_250KHz,
    clk_31KHz => clk_31KHz,
	reset => reset,
	in_channels => signals_undec(0),
	out_channels => signals_dec(0));
	

--Redirect (doesn't exist yet)
signals_unpol <= signals_dec;

--First interpolator stage
IPOL_1_250: IPOL_1
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    Clk_100MHz => clk_100MHz,
    clk_250KHz => clk_250KHz,
    reset => reset,
    input => signals_unpol(0),
    output => signals_unpol(0));

    
--first mixer up block_0       
Mixer_up_1_block_0: Mixer_up_1    
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    clk_4MHz => clk_4MHz,
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
            
IPOL_2_500: IPOL_2
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    Clk_100MHz => clk_100MHz,
    clk_500KHz => clk_500KHz,
    reset => reset,
    input_r => Blocks_unpol(0),
    input_i => Blocks_unpol(1),
    output_r => Blocks_pol_1(0),
    output_i => Blocks_pol_1(1)
    );
            
IPOL_3_4M: IPOL_3
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
    Clk_100MHz => clk_100MHz,
    clk_4MHz => clk_4MHz,
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
    clk_4MHz => clk_4MHz,
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