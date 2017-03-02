library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.Read_package.all;

entity top_level is
GENERIC (WIDTH:INTEGER:=12);
Port ( clk_100MHz 	: in STD_LOGIC;
	   reset 		: in STD_LOGIC;
       Switches 	: in STD_LOGIC_VECTOR(14 downto 0);
       LED			: out STD_LOGIC_VECTOR(14 downto 0);
       DUMMY_0      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
       DUMMY_1      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
       DUMMY_2      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
       DUMMY_3      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
       DUMMY_4      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
       DUMMY_5      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
       DUMMY_6      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
       DUMMY_7      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0));
end top_level;

architecture Behavioral of top_level is
--COMPONENT DECLARATIONS
--Clock enable
component clk_enable_generic
GENERIC (N:integer); --how fast should the clock be.
Port  (	clk 		: in STD_LOGIC;
		    reset		: in STD_LOGIC;
		    end_clk		: out STD_LOGIC;
		    clk_enable	: out STD_LOGIC
		    );
end component;

--ADC
component ADC    
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_6MHz : in STD_LOGIC;
       reset 	: in STD_LOGIC;
       adc_out 	: out signed(WIDTH-1 downto 0)
       );
end component;

--First mixer step
component Mixer_down_1    
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_6MHz : in STD_LOGIC;
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

--Second mixer step
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

--DEC_1
component DEC_1
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_100MHz : in STD_LOGIC;
       clk_6MHz : in STD_LOGIC;
       clk_250KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r : out signed(WIDTH-1 downto 0);
       out_i : out signed(WIDTH-1 downto 0)
       );
end component;
       
--DEC_2
component DEC_2
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_100MHz : in STD_LOGIC;
       clk_6MHz : in STD_LOGIC;
       clk_250KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r : out signed(WIDTH-1 downto 0);
       out_i : out signed(WIDTH-1 downto 0)
       );
end component;

--SIGNAL DECLARATIONS
--Clocks
signal clk_6MHz : std_logic :='0';
signal clk_250KHz : std_logic :='0';

--Routing signals
signal adc_out : signed(WIDTH-1 downto 0);

--from Mixer_down_1 to DEC_1 i.e undecimated blocks
signal block_0_undec_r : signed(WIDTH-1 downto 0);
signal block_0_undec_i : signed(WIDTH-1 downto 0);
signal block_1_undec_r : signed(WIDTH-1 downto 0);
signal block_1_undec_i : signed(WIDTH-1 downto 0);
signal block_2_undec_r : signed(WIDTH-1 downto 0);
signal block_2_undec_i : signed(WIDTH-1 downto 0);
signal block_3_undec_r : signed(WIDTH-1 downto 0);
signal block_3_undec_i : signed(WIDTH-1 downto 0);

--array version of previous signals?(see Read_package.vhdl):
--blocks_undec(0)=block_0_undec_r
--blocks_undec(1)=block_0_undec_i
--blocks_undec(2)=block_1_undec_r
--blocks_undec(3)=block_1_undec_i
--etc...
signal blocks_undec: Blocks;

--from DEC_1 to Mixer_down_2 i.e decimated blocks
signal block_0_dec_r : signed(WIDTH-1 downto 0);
signal block_0_dec_i : signed(WIDTH-1 downto 0);
signal block_1_dec_r : signed(WIDTH-1 downto 0);
signal block_1_dec_i : signed(WIDTH-1 downto 0);
signal block_2_dec_r : signed(WIDTH-1 downto 0);
signal block_2_dec_i : signed(WIDTH-1 downto 0);
signal block_3_dec_r : signed(WIDTH-1 downto 0);
signal block_3_dec_i : signed(WIDTH-1 downto 0);


--array version again:
signal blocks_dec: Blocks;

--from Mixer_down_2 to DEC_2 - i.e undecimated signals
	--first block
	signal channel_0_block_0_undec_r : signed(WIDTH-1 downto 0);
	signal channel_0_block_0_undec_i : signed(WIDTH-1 downto 0);
	signal channel_1_block_0_undec_r : signed(WIDTH-1 downto 0);
	signal channel_1_block_0_undec_i : signed(WIDTH-1 downto 0);
	signal channel_2_block_0_undec_r : signed(WIDTH-1 downto 0);
	signal channel_2_block_0_undec_i : signed(WIDTH-1 downto 0);
	signal channel_3_block_0_undec_r : signed(WIDTH-1 downto 0);
	signal channel_3_block_0_undec_i : signed(WIDTH-1 downto 0);
	signal channel_4_block_0_undec_r : signed(WIDTH-1 downto 0);
	signal channel_4_block_0_undec_i : signed(WIDTH-1 downto 0);
	signal channel_5_block_0_undec_r : signed(WIDTH-1 downto 0);
	signal channel_5_block_0_undec_i : signed(WIDTH-1 downto 0);
	signal channel_6_block_0_undec_r : signed(WIDTH-1 downto 0);
	signal channel_6_block_0_undec_i : signed(WIDTH-1 downto 0);
	signal channel_7_block_0_undec_r : signed(WIDTH-1 downto 0);
	signal channel_7_block_0_undec_i : signed(WIDTH-1 downto 0);
	
	--second block
	signal channel_0_block_1_undec_r : signed(WIDTH-1 downto 0);
	signal channel_0_block_1_undec_i : signed(WIDTH-1 downto 0);
	signal channel_1_block_1_undec_r : signed(WIDTH-1 downto 0);
	signal channel_1_block_1_undec_i : signed(WIDTH-1 downto 0);
	signal channel_2_block_1_undec_r : signed(WIDTH-1 downto 0);
	signal channel_2_block_1_undec_i : signed(WIDTH-1 downto 0);
	signal channel_3_block_1_undec_r : signed(WIDTH-1 downto 0);
	signal channel_3_block_1_undec_i : signed(WIDTH-1 downto 0);
	signal channel_4_block_1_undec_r : signed(WIDTH-1 downto 0);
	signal channel_4_block_1_undec_i : signed(WIDTH-1 downto 0);
	signal channel_5_block_1_undec_r : signed(WIDTH-1 downto 0);
	signal channel_5_block_1_undec_i : signed(WIDTH-1 downto 0);
	signal channel_6_block_1_undec_r : signed(WIDTH-1 downto 0);
	signal channel_6_block_1_undec_i : signed(WIDTH-1 downto 0);
	signal channel_7_block_1_undec_r : signed(WIDTH-1 downto 0);
	signal channel_7_block_1_undec_i : signed(WIDTH-1 downto 0);

	
	--third block
	signal channel_0_block_2_undec_r : signed(WIDTH-1 downto 0);
	signal channel_0_block_2_undec_i : signed(WIDTH-1 downto 0);
	signal channel_1_block_2_undec_r : signed(WIDTH-1 downto 0);
	signal channel_1_block_2_undec_i : signed(WIDTH-1 downto 0);
	signal channel_2_block_2_undec_r : signed(WIDTH-1 downto 0);
	signal channel_2_block_2_undec_i : signed(WIDTH-1 downto 0);
	signal channel_3_block_2_undec_r : signed(WIDTH-1 downto 0);
	signal channel_3_block_2_undec_i : signed(WIDTH-1 downto 0);
	signal channel_4_block_2_undec_r : signed(WIDTH-1 downto 0);
	signal channel_4_block_2_undec_i : signed(WIDTH-1 downto 0);
	signal channel_5_block_2_undec_r : signed(WIDTH-1 downto 0);
	signal channel_5_block_2_undec_i : signed(WIDTH-1 downto 0);
	signal channel_6_block_2_undec_r : signed(WIDTH-1 downto 0);
	signal channel_6_block_2_undec_i : signed(WIDTH-1 downto 0);
	signal channel_7_block_2_undec_r : signed(WIDTH-1 downto 0);
	signal channel_7_block_2_undec_i : signed(WIDTH-1 downto 0);
	
	
	--fourth block
	signal channel_0_block_3_undec_r : signed(WIDTH-1 downto 0);
	signal channel_0_block_3_undec_i : signed(WIDTH-1 downto 0);
	signal channel_1_block_3_undec_r : signed(WIDTH-1 downto 0);
	signal channel_1_block_3_undec_i : signed(WIDTH-1 downto 0);
	signal channel_2_block_3_undec_r : signed(WIDTH-1 downto 0);
	signal channel_2_block_3_undec_i : signed(WIDTH-1 downto 0);
	signal channel_3_block_3_undec_r : signed(WIDTH-1 downto 0);
	signal channel_3_block_3_undec_i : signed(WIDTH-1 downto 0);
	signal channel_4_block_3_undec_r : signed(WIDTH-1 downto 0);
	signal channel_4_block_3_undec_i : signed(WIDTH-1 downto 0);
	signal channel_5_block_3_undec_r : signed(WIDTH-1 downto 0);
	signal channel_5_block_3_undec_i : signed(WIDTH-1 downto 0);
	signal channel_6_block_3_undec_r : signed(WIDTH-1 downto 0);
	signal channel_6_block_3_undec_i : signed(WIDTH-1 downto 0);
	signal channel_7_block_3_undec_r : signed(WIDTH-1 downto 0);
	signal channel_7_block_3_undec_i : signed(WIDTH-1 downto 0);
	
--Three-dimentional array version:
--signals_undec(0)(0) = channel_0_block_0_undec_r
--signals_undec(0)(1) = channel_0_block_0_undec_i
--signals_undec(0)(2) = channel_0_block_1_undec_r
--signals_undec(0)(3) = channel_0_block_1_undec_i
--signals_undec(1)(0) = channel_1_block_0_undec_r
--signals_undec(1)(1) = channel_1_block_0_undec_i
--signals_undec(1)(2) = channel_1_block_1_undec_r
--signals_undec(1)(3) = channel_1_block_1_undec_i
--etc...
signal signals_undec: Signals;
	
--from DEC_2 to Redirect - i.e decimated signals
		--first block
	signal channel_0_block_0_dec_r : signed(WIDTH-1 downto 0);
	signal channel_0_block_0_dec_i : signed(WIDTH-1 downto 0);
	signal channel_1_block_0_dec_r : signed(WIDTH-1 downto 0);
	signal channel_1_block_0_dec_i : signed(WIDTH-1 downto 0);
	signal channel_2_block_0_dec_r : signed(WIDTH-1 downto 0);
	signal channel_2_block_0_dec_i : signed(WIDTH-1 downto 0);
	signal channel_3_block_0_dec_r : signed(WIDTH-1 downto 0);
	signal channel_3_block_0_dec_i : signed(WIDTH-1 downto 0);
	signal channel_4_block_0_dec_r : signed(WIDTH-1 downto 0);
	signal channel_4_block_0_dec_i : signed(WIDTH-1 downto 0);
	signal channel_5_block_0_dec_r : signed(WIDTH-1 downto 0);
	signal channel_5_block_0_dec_i : signed(WIDTH-1 downto 0);
	signal channel_6_block_0_dec_r : signed(WIDTH-1 downto 0);
	signal channel_6_block_0_dec_i : signed(WIDTH-1 downto 0);
	signal channel_7_block_0_dec_r : signed(WIDTH-1 downto 0);
	signal channel_7_block_0_dec_i : signed(WIDTH-1 downto 0);
	
	--second block
	signal channel_0_block_1_dec_r : signed(WIDTH-1 downto 0);
	signal channel_0_block_1_dec_i : signed(WIDTH-1 downto 0);
	signal channel_1_block_1_dec_r : signed(WIDTH-1 downto 0);
	signal channel_1_block_1_dec_i : signed(WIDTH-1 downto 0);
	signal channel_2_block_1_dec_r : signed(WIDTH-1 downto 0);
	signal channel_2_block_1_dec_i : signed(WIDTH-1 downto 0);
	signal channel_3_block_1_dec_r : signed(WIDTH-1 downto 0);
	signal channel_3_block_1_dec_i : signed(WIDTH-1 downto 0);
	signal channel_4_block_1_dec_r : signed(WIDTH-1 downto 0);
	signal channel_4_block_1_dec_i : signed(WIDTH-1 downto 0);
	signal channel_5_block_1_dec_r : signed(WIDTH-1 downto 0);
	signal channel_5_block_1_dec_i : signed(WIDTH-1 downto 0);
	signal channel_6_block_1_dec_r : signed(WIDTH-1 downto 0);
	signal channel_6_block_1_dec_i : signed(WIDTH-1 downto 0);
	signal channel_7_block_1_dec_r : signed(WIDTH-1 downto 0);
	signal channel_7_block_1_dec_i : signed(WIDTH-1 downto 0);

	
	--third block
	signal channel_0_block_2_dec_r : signed(WIDTH-1 downto 0);
	signal channel_0_block_2_dec_i : signed(WIDTH-1 downto 0);
	signal channel_1_block_2_dec_r : signed(WIDTH-1 downto 0);
	signal channel_1_block_2_dec_i : signed(WIDTH-1 downto 0);
	signal channel_2_block_2_dec_r : signed(WIDTH-1 downto 0);
	signal channel_2_block_2_dec_i : signed(WIDTH-1 downto 0);
	signal channel_3_block_2_dec_r : signed(WIDTH-1 downto 0);
	signal channel_3_block_2_dec_i : signed(WIDTH-1 downto 0);
	signal channel_4_block_2_dec_r : signed(WIDTH-1 downto 0);
	signal channel_4_block_2_dec_i : signed(WIDTH-1 downto 0);
	signal channel_5_block_2_dec_r : signed(WIDTH-1 downto 0);
	signal channel_5_block_2_dec_i : signed(WIDTH-1 downto 0);
	signal channel_6_block_2_dec_r : signed(WIDTH-1 downto 0);
	signal channel_6_block_2_dec_i : signed(WIDTH-1 downto 0);
	signal channel_7_block_2_dec_r : signed(WIDTH-1 downto 0);
	signal channel_7_block_2_dec_i : signed(WIDTH-1 downto 0);
	
	
	--fourth block
	signal channel_0_block_3_dec_r : signed(WIDTH-1 downto 0);
	signal channel_0_block_3_dec_i : signed(WIDTH-1 downto 0);
	signal channel_1_block_3_dec_r : signed(WIDTH-1 downto 0);
	signal channel_1_block_3_dec_i : signed(WIDTH-1 downto 0);
	signal channel_2_block_3_dec_r : signed(WIDTH-1 downto 0);
	signal channel_2_block_3_dec_i : signed(WIDTH-1 downto 0);
	signal channel_3_block_3_dec_r : signed(WIDTH-1 downto 0);
	signal channel_3_block_3_dec_i : signed(WIDTH-1 downto 0);
	signal channel_4_block_3_dec_r : signed(WIDTH-1 downto 0);
	signal channel_4_block_3_dec_i : signed(WIDTH-1 downto 0);
	signal channel_5_block_3_dec_r : signed(WIDTH-1 downto 0);
	signal channel_5_block_3_dec_i : signed(WIDTH-1 downto 0);
	signal channel_6_block_3_dec_r : signed(WIDTH-1 downto 0);
	signal channel_6_block_3_dec_i : signed(WIDTH-1 downto 0);
	signal channel_7_block_3_dec_r : signed(WIDTH-1 downto 0);
	signal channel_7_block_3_dec_i : signed(WIDTH-1 downto 0);
	
--array version again:
signal signals_dec: Signals;

begin

--Clock Enables
	--6MHz
	Clk_en_6MHz: clk_enable_generic 
	GENERIC MAP(N => 17)
	PORT MAP (
         clk => clk_100MHz,
         reset => reset,
         --end_clk => --what?
         clk_enable => clk_6MHz);
	--250KHz
	Clk_en_250KHz: clk_enable_generic 
	GENERIC MAP(N => 413)
	PORT MAP (
         clk => clk_100MHz,
         reset => reset,
         --end_clk => --what?
         clk_enable => clk_250KHz);
         
--ADC
ADC_cmp: ADC    
GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
		clk_6MHz => clk_6MHz,
		reset => reset,
		adc_out => adc_out 
    );

--Mixer_down_1
	Mixer_dnw_1: Mixer_down_1    
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
		clk_6MHz => clk_6MHz,
		in_r => adc_out,
		in_i => (others=> '0'),
		out_r_0 => block_0_undec_r,
		out_i_0 => block_0_undec_i,
		out_r_1 => block_1_undec_r,
		out_i_1 => block_1_undec_i,
		out_r_2 => block_2_undec_r,
		out_i_2 => block_2_undec_i,
		out_r_3 => block_3_undec_r,
		out_i_3 => block_3_undec_i
		);

--DEC_1_block_0
	Decimation_1_block_0: DEC_1
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
	    clk_100MHz => clk_100MHz,
	    clk_6MHz => clk_6MHz,
		clk_250KHz => clk_250KHz,
		reset => reset,
		in_r => block_0_undec_r,
		in_i => block_0_undec_i,
		out_r => block_0_dec_r,
		out_i => block_0_dec_i
		);

--Mixer_down_2_block_0
	Mixer_dnw_2_block_0: Mixer_down_2    
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
		clk_250KHz => clk_250KHz,
		in_r => block_0_dec_r,
		in_i => block_0_dec_i,
		out_r_0 => channel_0_block_0_undec_r,
		out_i_0 => channel_0_block_0_undec_i,
		out_r_1 => channel_1_block_0_undec_r,
		out_i_1 => channel_1_block_0_undec_i,
		out_r_2 => channel_2_block_0_undec_r,
		out_i_2 => channel_2_block_0_undec_i,
		out_r_3 => channel_3_block_0_undec_r,
		out_i_3 => channel_3_block_0_undec_i,
		out_r_4 => channel_4_block_0_undec_r,
		out_i_4 => channel_4_block_0_undec_i,
		out_r_5 => channel_5_block_0_undec_r,
		out_i_5 => channel_5_block_0_undec_i,
		out_r_6 => channel_6_block_0_undec_r,
		out_i_6 => channel_6_block_0_undec_i,
		out_r_7 => channel_7_block_0_undec_r,
		out_i_7 => channel_7_block_0_undec_i
		);

--DEC_2_channel_5_block_1
	Decimation_2_channel_5_block_0: DEC_2
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
		clk_100MHz => clk_100MHz,
        clk_6MHz => clk_6MHz,
        clk_250KHz => clk_250KHz,
		reset => reset,
		in_r => channel_5_block_0_undec_r,
		in_i => channel_5_block_0_undec_i,
		out_r => channel_5_block_0_dec_r,
		out_i => channel_5_block_0_dec_i
		);

--DEC_2_channel_6_block_1
	Decimation_2_channel_6_block_0: DEC_2
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
	    clk_100MHz => clk_100MHz,
        clk_6MHz => clk_6MHz,
        clk_250KHz => clk_250KHz,
		reset => reset,
		in_r => channel_6_block_0_undec_r,
		in_i => channel_6_block_0_undec_i,
		out_r => channel_6_block_0_dec_r,
		out_i => channel_6_block_0_dec_i
		);
		
--DEC_2_channel_7_block_1
    Decimation_2_channel_7_block_0: DEC_2
    GENERIC MAP(WIDTH => WIDTH)
    PORT MAP( 
        clk_100MHz => clk_100MHz,
        clk_6MHz => clk_6MHz,
        clk_250KHz => clk_250KHz,
        reset => reset,
        in_r => channel_7_block_0_undec_r,
        in_i => channel_7_block_0_undec_i,
        out_r => channel_7_block_0_dec_r,
        out_i => channel_7_block_0_dec_i
        );
		
DUMMY_0 <= STD_LOGIC_VECTOR(channel_0_block_0_dec_r);
DUMMY_1 <= STD_LOGIC_VECTOR(channel_1_block_0_dec_r);
DUMMY_2 <= STD_LOGIC_VECTOR(channel_2_block_0_dec_r);
DUMMY_3 <= STD_LOGIC_VECTOR(channel_3_block_0_dec_r);
DUMMY_4 <= STD_LOGIC_VECTOR(channel_4_block_0_dec_r);
DUMMY_5 <= STD_LOGIC_VECTOR(channel_5_block_0_dec_r);
DUMMY_6 <= STD_LOGIC_VECTOR(channel_6_block_0_dec_r);
DUMMY_7 <= STD_LOGIC_VECTOR(channel_7_block_0_dec_r);

end Behavioral;
